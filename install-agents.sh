#!/usr/bin/env bash
# Awesome Code Agents — Installer
# Installs agents for GitHub Copilot (.agent.md) or OpenCode (.md)
#
# Local usage:
#   ./install-agents.sh --platform copilot --scope local
#   ./install-agents.sh --platform opencode --scope global
#   ./install-agents.sh --uninstall --platform copilot --scope local
#
# Remote (curl) usage — no clone required:
#   bash <(curl -sSL https://raw.githubusercontent.com/m13ha/awesome-code-subagents/main/install-agents.sh) \
#     --platform copilot --scope local
#
#   Or pipe-friendly (pass args after --):
#   curl -sSL https://raw.githubusercontent.com/m13ha/awesome-code-subagents/main/install-agents.sh | \
#     bash -s -- --platform opencode --scope global

set -euo pipefail

# ---------------------------------------------------------------------------
# Colours
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ---------------------------------------------------------------------------
# Remote source configuration
# ---------------------------------------------------------------------------
GITHUB_RAW="https://raw.githubusercontent.com/m13ha/awesome-code-subagents/main"

# All 42 agent names (used in remote mode to build download URLs)
ALL_AGENTS=(
  api-designer backend-developer design-bridge electron-pro frontend-developer
  fullstack-developer graphql-architect microservices-architect mobile-developer
  ui-designer websocket-engineer
  expo-react-native-expert flutter-expert golang-pro javascript-pro
  react-specialist typescript-pro
  cloud-architect deployment-engineer devops-engineer network-engineer
  platform-engineer security-engineer
  architect-reviewer chaos-engineer code-reviewer compliance-auditor
  penetration-tester performance-engineer qa-expert security-auditor test-automator
  postgres-pro prompt-engineer reinforcement-learning-engineer
  cli-developer documentation-engineer readme-generator refactoring-specialist
  game-developer mobile-app-developer payment-integration
)

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COPILOT_SRC="$SCRIPT_DIR/.github/agents"
OPENCODE_SRC="$SCRIPT_DIR/.opencode/agents"

# Detect remote mode: source dirs absent (script piped from curl or run standalone)
REMOTE_MODE=false
if [[ ! -d "$COPILOT_SRC" && ! -d "$OPENCODE_SRC" ]]; then
  REMOTE_MODE=true
  command -v curl &>/dev/null || { echo -e "${RED}curl is required for remote installation but was not found.${NC}"; exit 1; }
fi

COPILOT_LOCAL=".github/agents"
COPILOT_GLOBAL="$HOME/.copilot/agents"

OPENCODE_LOCAL=".opencode/agents"
OPENCODE_GLOBAL="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/agents"

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
PLATFORM=""   # copilot | opencode
SCOPE=""      # local | global
UNINSTALL=false
FILTER=""     # optional agent name filter (substring)

while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform)  PLATFORM="$2"; shift 2 ;;
    --scope)     SCOPE="$2";    shift 2 ;;
    --filter)    FILTER="$2";   shift 2 ;;
    --uninstall) UNINSTALL=true; shift  ;;
    --help|-h)
      echo "Usage: $0 [--platform copilot|opencode] [--scope local|global] [--filter NAME] [--uninstall]"
      exit 0 ;;
    *) echo -e "${RED}Unknown option: $1${NC}"; exit 1 ;;
  esac
done

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
info()    { echo -e "${CYAN}${BOLD}$*${NC}"; }
success() { echo -e "${GREEN}✔  $*${NC}"; }
warn()    { echo -e "${YELLOW}⚠  $*${NC}"; }
err()     { echo -e "${RED}✘  $*${NC}"; }

pick_option() {
  local prompt="$1"; shift
  local options=("$@")
  echo -e "${BOLD}${prompt}${NC}"
  for i in "${!options[@]}"; do
    echo "  $((i+1))) ${options[$i]}"
  done
  local choice
  while true; do
    read -rp "Enter choice [1-${#options[@]}]: " choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#options[@]} )); then
      echo "${options[$((choice-1))]}"
      return
    fi
    warn "Invalid choice, try again."
  done
}

# ---------------------------------------------------------------------------
# Interactive prompts (only if args not supplied)
# ---------------------------------------------------------------------------
if [[ -z "$PLATFORM" ]]; then
  echo ""
  info "=== Awesome Code Agents Installer ==="
  echo ""
  PLATFORM=$(pick_option "Which platform?" "copilot" "opencode")
fi

if [[ -z "$SCOPE" ]]; then
  echo ""
  SCOPE=$(pick_option "Install scope?" "local (project .github/ or .opencode/)" "global (user home)")
  SCOPE="${SCOPE%% *}"   # trim description
fi

# ---------------------------------------------------------------------------
# Resolve source + destination
# ---------------------------------------------------------------------------
case "$PLATFORM" in
  copilot)
    SRC="$COPILOT_SRC"
    EXT=".agent.md"
    if [[ "$SCOPE" == "local" ]]; then
      DEST="$COPILOT_LOCAL"
    else
      DEST="$COPILOT_GLOBAL"
    fi
    ;;
  opencode)
    SRC="$OPENCODE_SRC"
    EXT=".md"
    if [[ "$SCOPE" == "local" ]]; then
      DEST="$OPENCODE_LOCAL"
    else
      DEST="$OPENCODE_GLOBAL"
    fi
    ;;
  *)
    err "Unknown platform '$PLATFORM'. Use 'copilot' or 'opencode'."
    exit 1
    ;;
esac

if [[ ! -d "$SRC" ]] && ! $REMOTE_MODE; then
  err "Source directory not found: $SRC"
  err "Run this script from the repo root, or re-clone the repository."
  exit 1
fi

# ---------------------------------------------------------------------------
# Uninstall path
# ---------------------------------------------------------------------------
if $UNINSTALL; then
  echo ""
  info "Uninstalling $PLATFORM agents from: $DEST"
  if [[ ! -d "$DEST" ]]; then
    warn "Destination does not exist — nothing to remove."
    exit 0
  fi
  count=0
  while IFS= read -r -d '' f; do
    name="$(basename "$f")"
    if [[ -n "$FILTER" && "$name" != *"$FILTER"* ]]; then continue; fi
    rm -f "$f"
    success "Removed $name"
    (( count++ )) || true
  done < <(find "$DEST" -maxdepth 1 -name "*${EXT}" -print0)
  echo ""
  info "Removed $count agent file(s)."
  exit 0
fi

# ---------------------------------------------------------------------------
# Install
# ---------------------------------------------------------------------------
echo ""
info "Installing $PLATFORM agents → $DEST"
echo ""

mkdir -p "$DEST"

installed=0
skipped=0

if $REMOTE_MODE; then
  # Remote mode: download each agent file from GitHub raw CDN
  case "$PLATFORM" in
    copilot)   REMOTE_SUBDIR=".github/agents" ;;
    opencode)  REMOTE_SUBDIR=".opencode/agents" ;;
  esac

  for agent_name in "${ALL_AGENTS[@]}"; do
    name="${agent_name}${EXT}"
    if [[ -n "$FILTER" && "$name" != *"$FILTER"* ]]; then continue; fi

    dest_file="$DEST/$name"
    url="$GITHUB_RAW/$REMOTE_SUBDIR/$name"

    if [[ -f "$dest_file" ]]; then
      read -rp "  $(echo -e "${YELLOW}↻${NC}") $name already exists. Overwrite? [y/N] " yn
      case "$yn" in
        [Yy]*) ;;
        *) warn "Skipped $name"; (( skipped++ )) || true; continue ;;
      esac
    fi

    if curl -sSLf "$url" -o "$dest_file" 2>/dev/null; then
      success "$name"
      (( installed++ )) || true
    else
      err "Failed to download $name from $url"
      rm -f "$dest_file"
    fi
  done
else
  # Local mode: copy from repo source directories
  while IFS= read -r -d '' src_file; do
    name="$(basename "$src_file")"
    if [[ -n "$FILTER" && "$name" != *"$FILTER"* ]]; then continue; fi

    dest_file="$DEST/$name"

    if [[ -f "$dest_file" ]]; then
      read -rp "  $(echo -e "${YELLOW}↻${NC}") $name already exists. Overwrite? [y/N] " yn
      case "$yn" in
        [Yy]*) ;;
        *) warn "Skipped $name"; (( skipped++ )) || true; continue ;;
      esac
    fi

    cp "$src_file" "$dest_file"
    success "$name"
    (( installed++ )) || true
  done < <(find "$SRC" -maxdepth 1 -name "*${EXT}" -print0 | sort -z)
fi

echo ""
info "Done — $installed installed, $skipped skipped."
echo ""

# ---------------------------------------------------------------------------
# Post-install hints
# ---------------------------------------------------------------------------
case "$PLATFORM" in
  copilot)
    echo -e "${BOLD}GitHub Copilot:${NC}"
    if [[ "$SCOPE" == "local" ]]; then
      echo "  Agents are in ${CYAN}$DEST/${NC}"
      echo "  Open VS Code in this project — agents appear in the Chat agent picker."
    else
      echo "  Agents are in ${CYAN}$DEST/${NC}"
      echo "  They will be available in VS Code across all projects."
    fi
    echo "  Invoke with ${CYAN}@agent-name${NC} in GitHub Copilot Chat."
    ;;
  opencode)
    echo -e "${BOLD}OpenCode:${NC}"
    if [[ "$SCOPE" == "local" ]]; then
      echo "  Agents are in ${CYAN}$DEST/${NC}"
      echo "  Open OpenCode in this directory — subagents are available immediately."
    else
      echo "  Agents are in ${CYAN}$DEST/${NC}"
      echo "  Available in OpenCode across all projects."
    fi
    echo "  Invoke with ${CYAN}@agent-name${NC} inline."
    ;;
esac
echo ""
