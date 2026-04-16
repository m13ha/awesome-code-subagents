# Awesome Code Agents

[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)
![Agent Count](https://img.shields.io/badge/agents-42-blue?style=flat-square)
![Platforms](https://img.shields.io/badge/platforms-GitHub%20Copilot%20%7C%20OpenCode-blueviolet?style=flat-square)

A curated collection of **42 specialized agents** for [GitHub Copilot](https://docs.github.com/en/copilot/customizing-copilot/reusing-prompts-and-instructions-in-github-copilot#creating-a-coding-guidelines-file) and [OpenCode](https://opencode.ai). Each agent carries a focused system prompt and platform-correct tool permissions so it excels at one job.

> Forked and adapted from [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents).

---

## Quick Install

### Without cloning — one-liner (recommended)

**GitHub Copilot**

```bash
# Install to the current project
bash <(curl -sSL https://raw.githubusercontent.com/m13ha/awesome-code-subagents/main/install-agents.sh) \
  --platform copilot --scope local

# Install globally (all VS Code workspaces)
bash <(curl -sSL https://raw.githubusercontent.com/m13ha/awesome-code-subagents/main/install-agents.sh) \
  --platform copilot --scope global
```

**OpenCode**

```bash
# Install to the current project
bash <(curl -sSL https://raw.githubusercontent.com/m13ha/awesome-code-subagents/main/install-agents.sh) \
  --platform opencode --scope local

# Install globally
bash <(curl -sSL https://raw.githubusercontent.com/m13ha/awesome-code-subagents/main/install-agents.sh) \
  --platform opencode --scope global
```

> The script auto-detects it is running remotely and downloads only the 42 agent files — nothing else is fetched. `curl` must be available.

### After cloning

```bash
git clone https://github.com/m13ha/awesome-code-subagents.git
cd awesome-code-subagents

# GitHub Copilot — current project
./install-agents.sh --platform copilot --scope local

# OpenCode — globally
./install-agents.sh --platform opencode --scope global
```

### Destination directories

| Platform | Scope | Path |
|----------|-------|------|
| GitHub Copilot | local | `.github/agents/` |
| GitHub Copilot | global | `~/.copilot/agents/` |
| OpenCode | local | `.opencode/agents/` |
| OpenCode | global | `~/.config/opencode/agents/` |

Invoke agents with `@agent-name` in Copilot Chat or OpenCode.

### All options

```
install-agents.sh [--platform copilot|opencode] [--scope local|global]
                  [--filter NAME] [--uninstall]
```

| Flag | Description |
|------|-------------|
| `--platform` | `copilot` or `opencode` |
| `--scope` | `local` (project) or `global` (user home) |
| `--filter` | Install only agents whose filename contains NAME |
| `--uninstall` | Remove previously installed agents |

---

## Agent Catalogue

### 01 · Core Development (11)

| Agent | When to use |
|-------|-------------|
| `api-designer` | Design REST/GraphQL APIs, write OpenAPI specs |
| `backend-developer` | Build server-side APIs, microservices, DB layers |
| `design-bridge` | Translate DESIGN.md into implementation instructions |
| `electron-pro` | Build cross-platform desktop apps with Electron |
| `frontend-developer` | React, Vue, Angular — responsive, accessible UIs |
| `fullstack-developer` | End-to-end features across the whole stack |
| `graphql-architect` | Schema design, federation, resolver optimisation |
| `microservices-architect` | Service decomposition, distributed system design |
| `mobile-developer` | Cross-platform mobile (React Native / Flutter) |
| `ui-designer` | Design systems, visual design, interaction patterns |
| `websocket-engineer` | Real-time bidirectional communication at scale |

### 02 · Language Specialists (6)

| Agent | When to use |
|-------|-------------|
| `expo-react-native-expert` | Expo + React Native native features and deployment |
| `flutter-expert` | Flutter 3+ — custom UI, state management, platform integration |
| `golang-pro` | Idiomatic Go, concurrency, performance-critical systems |
| `javascript-pro` | ES2023+, async patterns, Node.js and browser targets |
| `react-specialist` | React 18+, hooks, state management, performance optimisation |
| `typescript-pro` | Advanced type system, generics, end-to-end type safety |

### 03 · Infrastructure (6)

| Agent | When to use |
|-------|-------------|
| `cloud-architect` | Multi-cloud design, migrations, cost/security posture |
| `deployment-engineer` | CI/CD pipelines, release automation, GitOps |
| `devops-engineer` | Containerisation, IaC, ops automation |
| `network-engineer` | Cloud/hybrid networking, VPCs, connectivity |
| `platform-engineer` | Internal developer platforms, golden paths, self-service infra |
| `security-engineer` | Infrastructure hardening, zero-trust, shift-left security |

### 04 · Quality & Security (9)

| Agent | When to use |
|-------|-------------|
| `architect-reviewer` | Review system design decisions and trade-offs |
| `chaos-engineer` | Failure injection, resilience validation, game days |
| `code-reviewer` | Code quality, correctness, best practices |
| `compliance-auditor` | GDPR, HIPAA, PCI DSS, SOC 2, ISO compliance |
| `penetration-tester` | Authorised pen testing, exploit validation |
| `performance-engineer` | Bottleneck diagnosis, load testing, optimisation |
| `qa-expert` | QA strategy, test planning, quality metrics |
| `security-auditor` | Vulnerability assessment, risk evaluation, audit reports |
| `test-automator` | Automated test suites, CI integration |

### 05 · Data & AI (3)

| Agent | When to use |
|-------|-------------|
| `postgres-pro` | Schema design, query optimisation, replication, tuning |
| `prompt-engineer` | LLM prompt design, evaluation, A/B testing |
| `reinforcement-learning-engineer` | RL environments, policy training, reward design |

### 06 · Developer Experience (4)

| Agent | When to use |
|-------|-------------|
| `cli-developer` | CLI tool design — UX, flags, cross-platform compatibility |
| `documentation-engineer` | API docs, tutorials, developer guides |
| `readme-generator` | README and project docs from actual codebase |
| `refactoring-specialist` | Safe code modernisation, pattern extraction |

### 07 · Specialized Domains (3)

| Agent | When to use |
|-------|-------------|
| `game-developer` | Game systems, engine integration, gameplay mechanics |
| `mobile-app-developer` | Native iOS / Android app development |
| `payment-integration` | Payment gateways, PCI compliance, fraud prevention |

---

## Platform Details

### GitHub Copilot

Pre-built files live in `.github/agents/` as `<name>.agent.md`.  
Frontmatter schema:

```yaml
---
name: backend-developer
description: "When to invoke this agent"
tools: ['read', 'edit', 'create', 'findFiles', 'search', 'runCommand']
---
```

Tool sets are scoped by agent role — audit/review agents receive read-only tools; dev agents receive the full set.

### OpenCode

Pre-built files live in `.opencode/agents/` as `<name>.md`.  
Frontmatter schema:

```yaml
---
description: "When to invoke this agent"
mode: subagent
model: anthropic/claude-sonnet-4-5
temperature: 0.7
permission:
  edit: allow
  bash: allow
  write: allow
---
```

Deep-reasoning agents (`architect-reviewer`, `compliance-auditor`, `penetration-tester`, `security-auditor`) use `anthropic/claude-opus-4-5`.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add or improve agents.

## License

MIT
