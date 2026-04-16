# Contributing

Thank you for improving this collection! The goal is a tight set of **high-quality, focused agents** for GitHub Copilot and OpenCode.

---

## Adding a New Agent

### 1 — Choose a category

Place the source file in the right category under `categories/`:

| Dir | Focus |
|-----|-------|
| `01-core-development` | Full-stack, APIs, mobile, desktop, real-time |
| `02-language-specialists` | Deep language/framework expertise |
| `03-infrastructure` | Cloud, DevOps, networking, platforms |
| `04-quality-security` | Testing, auditing, security, performance |
| `05-data-ai` | Databases, ML/AI, prompting |
| `06-developer-experience` | Tooling, docs, refactoring |
| `07-specialized-domains` | Industry/domain-specific agents |

### 2 — Write the source file

Create `categories/<category>/<agent-name>.md`. Use only `name` and `description` in the frontmatter — platform-specific keys are generated automatically.

```markdown
---
name: your-agent-name
description: "Use this agent when <specific scenario>. Invoke when <trigger condition>."
---

You are a <role> with expertise in <domain>. Your focus is <primary responsibility> with emphasis on <key quality>.

When invoked:
1. <first step>
2. <second step>
3. <third step>

<Core capabilities and checklist>
```

Rules:
- **`name`** matches the filename (kebab-case, no spaces)
- **`description`** is the invocation trigger — be specific about when vs. when not to use
- No `tools:`, `model:`, or `permission:` keys in the source file — those are generated
- Body should be self-contained: the agent gets no other context

### 3 — Regenerate platform files

Run the generator to produce/update the Copilot and OpenCode variants:

```bash
python3 tools/gen_agents.py
```

Or re-run the full generation manually:

```bash
# From repo root
python3 - << 'EOF'
# (paste gen_agents.py body here or run via tools/)
EOF
```

The script reads `categories/` and writes:
- `.github/agents/<name>.agent.md` — GitHub Copilot
- `.opencode/agents/<name>.md` — OpenCode

### 4 — Update the category README

Edit `categories/<category>/README.md`:
- Add a row to the agents table (alphabetical order)
- Add a row to the Quick Selection Guide

### 5 — Update the root README

Edit `README.md` and add the agent to its category table (alphabetical order).

### 6 — Submit a PR

Include in your PR description:
- What the agent does and when to use it
- Which category it belongs to and why
- A short example prompt that would invoke it

---

## Modifying an Existing Agent

1. Edit the source file in `categories/<category>/`
2. Regenerate: `python3 tools/gen_agents.py`
3. Verify frontmatter in `.github/agents/` and `.opencode/agents/` looks correct
4. Submit PR with before/after sample of the changed behaviour

---

## Tool Permissions Reference

The generator assigns tool permissions based on agent role. If your agent needs a different profile, update the sets in `tools/gen_agents.py`:

| Profile | Agents | Copilot tools | OpenCode permission |
|---------|--------|---------------|---------------------|
| **full-access** | dev/eng agents | `read, edit, create, findFiles, search, runCommand` | `edit/bash/write: allow` |
| **readonly** | audit/review agents | `read, findFiles, search` | `edit/bash/write: deny` |
| **research** | docs/prompt agents | `read, findFiles, search, fetch, web` | `edit/bash/write: deny, webfetch: allow` |

Model routing (OpenCode only):

| Model | Agents |
|-------|--------|
| `anthropic/claude-opus-4-5` | `architect-reviewer`, `compliance-auditor`, `penetration-tester`, `security-auditor` |
| `anthropic/claude-sonnet-4-5` | All others |

---

## Code of Conduct

- Be specific — vague agents that overlap with existing ones won't be merged
- Test before submitting — run the generator and check the output frontmatter
- Keep descriptions honest — the description is the invocation trigger; make it accurate
- One agent per PR — keeps reviews focused

---

## Questions?

Open an issue with the label `question`.
