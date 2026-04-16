# Project Plan: awesome-code-subagents

**Objective:** Transform the forked `awesome-claude-code-subagents` into a compact, dual-platform collection of 42 specialized agents targeting **GitHub Copilot** (VS Code) and **OpenCode**, removing all Claude Code-specific infrastructure and reducing the agent catalogue to the approved list.

---

## Research Summary

### Platform Agent Formats

#### GitHub Copilot (VS Code) — `.agent.md`
- **Location:** `.github/agents/` (workspace) or `~/.copilot/agents/` (global)
- **File extension:** `.agent.md`
- **Frontmatter fields:**

```yaml
---
name: agent-name
description: When this agent should be invoked
tools: ['read', 'edit', 'create', 'findFiles', 'search', 'runCommand', 'fetch']
model: claude-sonnet-4-5   # optional – omit to inherit user's selected model
---
```

- **Tool names:** `read`, `edit`, `create`, `findFiles`, `search`, `runCommand`, `fetch`, `web`
- **Model:** Copilot-managed; specify qualified name like `GPT-4o (copilot)` or omit for flexibility
- **Invocation:** Selected from the agents dropdown in VS Code Chat, or via `/agents`
- **Scope:** Workspace (`.github/agents/`) takes precedence over user-global

#### OpenCode — `.md`
- **Location:** `.opencode/agents/` (project) or `~/.config/opencode/agents/` (global)
- **File extension:** `.md`
- **Frontmatter fields:**

```yaml
---
description: What the agent does (required)
mode: subagent          # primary | subagent | all
model: anthropic/claude-sonnet-4-5   # provider/model-id format
temperature: 0.3
permission:
  edit: allow           # allow | ask | deny
  bash: allow
  write: allow
  webfetch: deny
---
```

- **Model format:** `provider/model-id` (e.g., `anthropic/claude-sonnet-4-5`, `openai/gpt-4o`, `google/gemini-2.5-pro`)
- **Invocation:** `Tab` key cycles primary agents; `@agent-name` invokes subagents inline
- **Agent name:** Derived from the filename (no extension)

---

### Tool Permission Mapping

| Claude Code (source) | GitHub Copilot tools array | OpenCode permission |
|---|---|---|
| `Read` | `read` | *(no restriction needed)* |
| `Write` | `create` | `write: allow` |
| `Edit` | `edit` | `edit: allow` |
| `Bash` | `runCommand` | `bash: allow` |
| `Glob` | `findFiles` | *(no restriction needed)* |
| `Grep` | `search` | *(no restriction needed)* |
| `WebFetch` | `fetch` | `webfetch: allow` |
| `WebSearch` | `web` | *(no direct equivalent)* |

**Read-only agents** (reviewers/auditors):
- Copilot: `['read', 'findFiles', 'search']`
- OpenCode: `permission: { edit: deny, bash: deny, write: deny }`

**Research agents** (analysts + docs):
- Copilot: `['read', 'findFiles', 'search', 'fetch', 'web']`
- OpenCode: `permission: { edit: deny, bash: deny, write: deny, webfetch: allow }`

**Full-access agents** (developers/engineers):
- Copilot: `['read', 'edit', 'create', 'findFiles', 'search', 'runCommand']`
- OpenCode: `permission: { edit: allow, bash: allow, write: allow }`

---

### Model Routing Strategy

| Claude Code tier | GitHub Copilot equivalent | OpenCode equivalent |
|---|---|---|
| `opus` | *(omit — user selects)* | `anthropic/claude-opus-4-5` |
| `sonnet` | *(omit — user selects)* | `anthropic/claude-sonnet-4-5` |
| `haiku` | *(omit — user selects)* | `anthropic/claude-haiku-4-5` |

> **Decision:** For Copilot agents, omit the `model` field entirely to remain provider-agnostic (Copilot supports Claude, GPT, Gemini etc.). For OpenCode, default to `anthropic/claude-sonnet-4-5` for everyday agents and `anthropic/claude-opus-4-5` for deep-reasoning agents (security-auditor, architect-reviewer, penetration-tester).

---

## Approved Agent Catalogue (42 agents)

### 01 — Core Development (11)
| Agent | Description |
|---|---|
| api-designer | REST and GraphQL API architect |
| backend-developer | Server-side expert for scalable APIs |
| design-bridge | Design-to-agent translator |
| electron-pro | Desktop application expert |
| frontend-developer | UI/UX specialist for React, Vue, and Angular |
| fullstack-developer | End-to-end feature development |
| graphql-architect | GraphQL schema and federation expert |
| microservices-architect | Distributed systems designer |
| mobile-developer | Cross-platform mobile specialist |
| ui-designer | Visual design and interaction specialist |
| websocket-engineer | Real-time communication specialist |

### 02 — Language Specialists (6)
| Agent | Description |
|---|---|
| expo-react-native-expert | Expo and React Native mobile development expert |
| flutter-expert | Flutter 3+ cross-platform mobile expert |
| golang-pro | Go concurrency specialist |
| javascript-pro | JavaScript development expert |
| react-specialist | React 18+ modern patterns expert |
| typescript-pro | TypeScript specialist |

### 03 — Infrastructure (6)
| Agent | Description |
|---|---|
| cloud-architect | AWS/GCP/Azure specialist |
| deployment-engineer | Deployment automation specialist |
| devops-engineer | CI/CD and automation expert |
| network-engineer | Network infrastructure specialist |
| platform-engineer | Platform architecture expert |
| security-engineer | Infrastructure security specialist |

### 04 — Quality & Security (9)
| Agent | Description |
|---|---|
| architect-reviewer | Architecture review specialist |
| chaos-engineer | System resilience testing expert |
| code-reviewer | Code quality guardian |
| compliance-auditor | Regulatory compliance expert |
| penetration-tester | Ethical hacking specialist |
| performance-engineer | Performance optimization expert |
| qa-expert | Test automation specialist |
| security-auditor | Security vulnerability expert |
| test-automator | Test automation framework expert |

### 05 — Data & AI (3)
| Agent | Description |
|---|---|
| postgres-pro | PostgreSQL database expert |
| prompt-engineer | Prompt optimization specialist |
| reinforcement-learning-engineer | Reinforcement learning and agent training expert |

### 06 — Developer Experience (4)
| Agent | Description |
|---|---|
| cli-developer | Command-line tool creator |
| documentation-engineer | Technical documentation expert |
| readme-generator | Repository README generation specialist |
| refactoring-specialist | Code refactoring expert |

### 07 — Specialized Domains (3)
| Agent | Description |
|---|---|
| game-developer | Game development expert |
| mobile-app-developer | Mobile application specialist |
| payment-integration | Payment systems expert |

---

## Repository Structure (Target State)

```
awesome-code-subagents/
├── .github/
│   └── agents/                   # Pre-built Copilot agents (42 .agent.md files)
│       ├── api-designer.agent.md
│       ├── backend-developer.agent.md
│       └── ...
├── .opencode/
│   └── agents/                   # Pre-built OpenCode agents (42 .md files)
│       ├── api-designer.md
│       ├── backend-developer.md
│       └── ...
├── categories/                   # Canonical source definitions (7 categories)
│   ├── 01-core-development/
│   ├── 02-language-specialists/
│   ├── 03-infrastructure/
│   ├── 04-quality-security/
│   ├── 05-data-ai/
│   ├── 06-developer-experience/
│   └── 07-specialized-domains/
├── tools/
│   └── subagent-catalog/         # Retained discovery tool (updated)
├── install-agents.sh             # Rewritten for Copilot + OpenCode
├── README.md                     # Completely rewritten
├── CONTRIBUTING.md               # Updated for dual-platform workflow
├── plan.md                       # This file
└── LICENSE
```

---

## Epics

---

### Epic 1: Scrub Unapproved Agents from All Categories

**Goal:** Remove every agent file not in the approved list. Remove categories 08, 09, 10 entirely.

**Scope and file deletions:**

- **02-language-specialists** — DELETE: `angular-architect.md`, `cpp-pro.md`, `csharp-developer.md`, `django-developer.md`, `dotnet-core-expert.md`, `dotnet-framework-4.8-expert.md`, `elixir-expert.md`, `fastapi-developer.md`, `java-architect.md`, `kotlin-specialist.md`, `laravel-specialist.md`, `nextjs-developer.md`, `php-pro.md`, `powershell-5.1-expert.md`, `powershell-7-expert.md`, `python-pro.md`, `rails-expert.md`, `rust-engineer.md`, `spring-boot-engineer.md`, `sql-pro.md`, `swift-expert.md`, `symfony-specialist.md`, `vue-expert.md`
- **03-infrastructure** — DELETE: `azure-infra-engineer.md`, `database-administrator.md`, `devops-incident-responder.md`, `docker-expert.md`, `incident-responder.md`, `kubernetes-specialist.md`, `sre-engineer.md`, `terraform-engineer.md`, `terragrunt-expert.md`, `windows-infra-admin.md`
- **04-quality-security** — DELETE: `accessibility-tester.md`, `ad-security-reviewer.md`, `ai-writing-auditor.md`, `debugger.md`, `error-detective.md`, `powershell-security-hardening.md`
- **05-data-ai** — DELETE: `ai-engineer.md`, `data-analyst.md`, `data-engineer.md`, `data-scientist.md`, `database-optimizer.md`, `llm-architect.md`, `machine-learning-engineer.md`, `ml-engineer.md`, `mlops-engineer.md`, `nlp-engineer.md`
- **06-developer-experience** — DELETE: `build-engineer.md`, `dependency-manager.md`, `dx-optimizer.md`, `git-workflow-manager.md`, `legacy-modernizer.md`, `mcp-developer.md`, `powershell-module-architect.md`, `powershell-ui-architect.md`, `slack-expert.md`, `tooling-engineer.md`
- **07-specialized-domains** — DELETE: `api-documenter.md`, `blockchain-developer.md`, `embedded-systems.md`, `fintech-engineer.md`, `iot-engineer.md`, `m365-admin.md`, `quant-analyst.md`, `risk-manager.md`, `seo-specialist.md`
- **08-business-product** — DELETE entire directory
- **09-meta-orchestration** — DELETE entire directory
- **10-research-analysis** — DELETE entire directory

**Also remove per category:**
- All `.claude-plugin/` subdirectories
- Update each category `README.md` to remove scrubbed agent references

**Acceptance criteria:**
- `categories/` contains exactly 7 subdirectories
- Total `.md` agent files across all categories = 42
- No references to deleted agents remain in any README

---

### Epic 2: Remove Claude Code Infrastructure

**Goal:** Strip all Claude Code-specific files, directories, and references from the repository root and category structure.

**Deletions:**
- `.claude/` directory (entire)
- `.claude-plugin/` at repo root
- `CLAUDE.md`
- Remove `model: sonnet/opus/haiku` frontmatter pattern from all source agents (will be replaced in Epic 4)
- Remove all `tools: Read, Write, Edit, Bash, Glob, Grep` comma-string frontmatter (will be replaced in Epic 4)

**Updates:**
- `CONTRIBUTING.md` — remove all Claude Code mentions; add Copilot and OpenCode contribution guidance
- `LICENSE` — no changes needed

**Acceptance criteria:**
- No `.claude/` directory exists
- No `CLAUDE.md` file exists
- No Claude Code frontmatter syntax remains in source agent files
- No Claude-branded language in `CONTRIBUTING.md`

---

### Epic 3: Establish Dual-Platform Agent Directories

**Goal:** Create `.github/agents/` and `.opencode/agents/` directories populated with fully converted agents for their respective platforms — these are the ready-to-use drop-in files users install directly.

**Sub-tasks:**

#### 3a: Define conversion rules
Document the canonical frontmatter transformation for each platform (see Tool Mapping table above). Formalize:
- `copilot` agent frontmatter template
- `opencode` agent frontmatter template
- Agent body: retained verbatim from source (body is platform-agnostic)

#### 3b: Generate `.github/agents/*.agent.md` (42 files)
For each approved agent:
1. Copy body text from `categories/<cat>/<agent>.md`
2. Apply Copilot frontmatter:
   ```yaml
   ---
   name: <agent-name>
   description: "<original description>"
   tools: [<mapped tool array>]
   # model omitted for provider-agnostic flexibility
   ---
   ```
3. Save as `.github/agents/<agent-name>.agent.md`

**Tool array assignment by agent role:**
- Full-access (developers, engineers): `['read', 'edit', 'create', 'findFiles', 'search', 'runCommand']`
- Read-only (reviewers, auditors): `['read', 'findFiles', 'search']`
- Research (docs, analysts): `['read', 'findFiles', 'search', 'fetch', 'web']`

#### 3c: Generate `.opencode/agents/*.md` (42 files)
For each approved agent:
1. Copy body text from `categories/<cat>/<agent>.md`
2. Apply OpenCode frontmatter:
   ```yaml
   ---
   description: "<original description>"
   mode: subagent
   model: anthropic/claude-sonnet-4-5  # or opus for deep-reasoning agents
   temperature: 0.3
   permission:
     edit: <allow|deny>
     bash: <allow|deny>
     write: <allow|deny>
   ---
   ```
3. Save as `.opencode/agents/<agent-name>.md`

**OpenCode model assignment:**
- `anthropic/claude-opus-4-5`: `security-auditor`, `architect-reviewer`, `penetration-tester`, `compliance-auditor`
- `anthropic/claude-sonnet-4-5`: all other agents

**Acceptance criteria:**
- `.github/agents/` contains exactly 42 `.agent.md` files
- `.opencode/agents/` contains exactly 42 `.md` files
- All files pass YAML frontmatter validation
- No Claude-Code-specific fields (`model: sonnet/opus/haiku`) remain

---

### Epic 4: Rewrite `install-agents.sh` for Dual-Platform Support

**Goal:** Replace the Claude Code-only installer with a new script that installs agents for either GitHub Copilot or OpenCode, from local source or remote GitHub.

**New script behaviour:**

```
Usage:
  ./install-agents.sh                  # Interactive mode
  ./install-agents.sh --platform copilot   # Target Copilot
  ./install-agents.sh --platform opencode  # Target OpenCode

Install locations:
  Copilot  global:  ~/.copilot/agents/
  Copilot  local:   .github/agents/
  OpenCode global:  ~/.config/opencode/agents/
  OpenCode local:   .opencode/agents/
```

**Key changes from original script:**

1. **Replace** all `CLAUDE_AGENTS_DIR`, `GLOBAL_AGENTS_DIR` references with platform-aware equivalents
2. **Replace** GitHub API base URLs from `VoltAgent/awesome-claude-code-subagents` to the new repo path
3. **Add** `--platform` flag parsing and platform-selection menu
4. **Add** on-the-fly frontmatter transpilation: when installing from `categories/` source, convert Claude-format frontmatter to target-platform format
5. **Remove** `.claude/` directory detection logic
6. **Remove** Claude Code plugin install option
7. **Retain** interactive category/agent browser, remote GitHub download, and local source modes
8. **Add** `uninstall` flow that targets the correct platform directory

**Acceptance criteria:**
- Script installs to correct platform directory based on selection
- Script works in remote mode against the new repository
- Frontmatter is correctly converted for the selected platform
- Existing local install guard (no double-install) still works
- Help text (`-h`/`--help`) explains both platforms

---

### Epic 5: Update Category READMEs

**Goal:** Each category directory should have a clean `README.md` that reflects only the agents that remain, with correct Copilot and OpenCode installation hints.

**Template per category README:**
```markdown
# <Category Name>

<Brief description of the category>

## Agents

| Agent | Description | Tools |
|---|---|---|
| [agent-name](./agent-name.md) | Description | full-access / read-only / research |

## Installation

### GitHub Copilot
Copy `.agent.md` files to `.github/agents/` in your project, or `~/.copilot/agents/` for global access.

### OpenCode
Copy `.md` files to `.opencode/agents/` in your project, or `~/.config/opencode/agents/` for global access.
```

**Acceptance criteria:**
- All 7 category READMEs updated
- No references to removed agents
- No Claude Code installation instructions
- Install paths correct for both platforms

---

### Epic 6: Rewrite Root `README.md`

**Goal:** Replace the VoltAgent/Claude-Code-branded README with one describing this as a compact, dual-platform agent collection for GitHub Copilot and OpenCode.

**Sections:**
1. **Header** — project name, badge (agent count: 42), platforms supported (Copilot, OpenCode)
2. **What are agents?** — brief explainer for each platform
3. **Quick Install** — 4 methods:
   - Interactive installer (`./install-agents.sh`)
   - Manual Copilot (copy `.github/agents/*.agent.md`)
   - Manual OpenCode (copy `.opencode/agents/*.md`)
   - One-liner curl (remote download, no clone required)
4. **Platform Agent Format** — side-by-side frontmatter examples for Copilot vs OpenCode
5. **Categories** — table of 7 categories with agent counts and links
6. **Full Agent List** — per-category tables with descriptions
7. **Contributing** — link to CONTRIBUTING.md
8. **License** — MIT

**Remove from original:**
- All Claude Code plugin install instructions
- VoltAgent branding and Discord links
- `model: sonnet/opus/haiku` smart routing section
- References to categories 08–10

**Acceptance criteria:**
- No mention of Claude Code or CLAUDE.md
- Both platforms documented with correct install paths and frontmatter
- All 42 agents listed

---

### Epic 7: Update `CONTRIBUTING.md`

**Goal:** Update the contribution guide to reflect the dual-platform nature and new agent format.

**Key changes:**
- Remove all Claude Code-specific guidance
- Add agent format spec for **both** Copilot (`.agent.md`) and OpenCode (`.md`)
- Add the tool permission table (see Research Summary above)
- Add PR checklist: source agent in `categories/`, Copilot version in `.github/agents/`, OpenCode version in `.opencode/agents/`
- Remove plugin/category plugin references

---

### Epic 8: Validation & Testing

**Goal:** Verify all 42 agents load correctly on both platforms before the branch is considered merge-ready.

**Copilot validation:**
- Copy `.github/agents/` to a test VS Code workspace
- Open Copilot Chat → agents dropdown should list all 42 agents
- Spot-check 5 agents across categories: invoke each and confirm correct persona response
- Confirm no YAML parse errors (use VS Code diagnostics right-click → Diagnostics)

**OpenCode validation:**
- Copy `.opencode/agents/` into a test project
- Run `opencode` and use `@` autocomplete to confirm all 42 agents appear
- Spot-check 5 agents: invoke via `@<agent-name>` and confirm correct persona response
- Confirm no frontmatter parse errors (`opencode debug config`)

**Installer validation:**
- Run `./install-agents.sh --platform copilot` — verify files land in correct directory with correct format
- Run `./install-agents.sh --platform opencode` — verify files land in correct directory with correct format
- Run remote mode (no local clone) for both platforms

**Acceptance criteria:**
- All 42 Copilot agents load without errors in VS Code Copilot Chat
- All 42 OpenCode agents load without errors in OpenCode TUI
- Installer correctly targets both platforms in both local and remote modes
- No remaining Claude Code references anywhere in the repository

---

## Implementation Order & Dependencies

```
Epic 1 (Scrub) ──────────────────────────────┐
Epic 2 (Remove Claude infra) ────────────────┤
                                              ▼
                                    Epic 3 (Dual-platform dirs)
                                              │
Epic 4 (Installer) ────── depends on ────────┤
Epic 5 (Category READMEs) ─── depends on ────┤
Epic 6 (Root README) ───── depends on ───────┤
Epic 7 (CONTRIBUTING) ─────────────────────┐ │
                                            ▼ ▼
                                    Epic 8 (Validation)
```

Epics 1 and 2 are fully independent and can be done in parallel. Epic 3 depends on Epics 1 and 2 completing (needs clean source). Epics 4–7 can overlap after Epic 3 completes. Epic 8 is final gate.

---

## Summary

| Epic | Work type | Agent file changes | Script changes | Docs changes |
|---|---|---|---|---|
| 1 | Delete 53 agent files + 3 category dirs | ✓ | — | Category READMEs |
| 2 | Delete Claude infra files | ✓ (frontmatter) | — | CONTRIBUTING |
| 3 | Create 84 new platform-specific files | ✓ (42×2) | — | — |
| 4 | Rewrite install script | — | ✓ | — |
| 5 | Rewrite 7 category READMEs | — | — | ✓ |
| 6 | Rewrite root README | — | — | ✓ |
| 7 | Update CONTRIBUTING | — | — | ✓ |
| 8 | Test & validate | — | — | — |

**Total net agent files after completion:** 42 source + 42 Copilot + 42 OpenCode = **126 files** (down from 130+ source-only)
