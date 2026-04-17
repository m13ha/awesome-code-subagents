#!/usr/bin/env python3
import os, re

# Resolve repo root relative to this script (tools/gen_agents.py → repo root)
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Agents that are read-only (review/audit — no code writes or command execution)
READONLY_AGENTS = {"architect-reviewer", "code-reviewer", "compliance-auditor",
                   "penetration-tester", "security-auditor"}

# Agents that primarily research/fetch but don't write code
RESEARCH_AGENTS = {"prompt-engineer", "documentation-engineer", "readme-generator"}

def copilot_tools(name):
    if name in READONLY_AGENTS:
        return "['read', 'findFiles', 'search']"
    if name in RESEARCH_AGENTS:
        return "['read', 'findFiles', 'search', 'fetch', 'web']"
    return "['read', 'edit', 'create', 'findFiles', 'search', 'runCommand']"

def opencode_permission(name):
    if name in READONLY_AGENTS:
        return "  edit: deny\n  bash: deny\n  write: deny"
    if name in RESEARCH_AGENTS:
        return "  edit: deny\n  bash: deny\n  write: deny\n  webfetch: allow"
    return "  edit: allow\n  bash: allow\n  write: allow"

def parse_agent(filepath):
    with open(filepath) as f:
        content = f.read()
    m = re.match(r'^---\n(.*?)\n---\n(.*)', content, re.DOTALL)
    if not m:
        return None
    fm, body = m.group(1), m.group(2).strip()
    name = re.search(r'^name:\s*(.+)$', fm, re.MULTILINE)
    desc = re.search(r'^description:\s*(.+)$', fm, re.MULTILINE)
    return (name.group(1).strip() if name else "",
            desc.group(1).strip() if desc else "",
            body)

copilot_dir = os.path.join(REPO, ".github", "agents")
opencode_dir = os.path.join(REPO, ".opencode", "agents")
os.makedirs(copilot_dir, exist_ok=True)
os.makedirs(opencode_dir, exist_ok=True)

count = 0
for cat in sorted(os.listdir(os.path.join(REPO, "categories"))):
    cat_path = os.path.join(REPO, "categories", cat)
    if not os.path.isdir(cat_path):
        continue
    for fname in sorted(os.listdir(cat_path)):
        if fname == "README.md" or not fname.endswith(".md"):
            continue
        result = parse_agent(os.path.join(cat_path, fname))
        if not result:
            print(f"SKIP {fname}")
            continue
        name, desc, body = result

        # GitHub Copilot — .agent.md
        with open(os.path.join(copilot_dir, f"{name}.agent.md"), "w") as f:
            f.write(f"---\nname: {name}\ndescription: {desc}\ntools: {copilot_tools(name)}\n---\n\n{body}\n")

        # OpenCode — .md
        with open(os.path.join(opencode_dir, f"{name}.md"), "w") as f:
            f.write(f"---\ndescription: {desc}\nmode: subagent\npermission:\n{opencode_permission(name)}\n---\n\n{body}\n")

        count += 1
        print(f"  {name}")

print(f"\nGenerated {count} agents → {count} Copilot + {count} OpenCode = {count*2} total files")
