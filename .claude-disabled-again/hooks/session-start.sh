#!/bin/bash
# SessionStart hook - forces context awareness and shows board status

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
REPO_NAME=$(basename "$REPO_ROOT" 2>/dev/null || echo "UNKNOWN")
BOARD_FILE="$REPO_ROOT/docs/BOARD.md"
PENDING_FILE="/tmp/branch-watcher-${REPO_NAME}.pending"

# Watcher scripts and PID files
BRANCH_WATCHER="$REPO_ROOT/scripts/watch-branches.sh"
BRANCH_PID_FILE="/tmp/branch-watcher-${REPO_NAME}.pid"
BOARD_WATCHER="$REPO_ROOT/scripts/watch-board.sh"
BOARD_PID_FILE="/tmp/board-watcher-${REPO_NAME}.pid"

cd "$REPO_ROOT" || exit 1

# Skip slow network sync for fast startup
# To manually sync: git fetch origin && git pull origin main
LOCAL_HASH=$(git rev-parse HEAD 2>/dev/null | cut -c1-7)

# Display local status only (fast startup)
echo ""
echo -e "${BOLD}┌─────────────────────────────────────┐${RESET}"
echo -e "${BOLD}│         📍 LOCAL STATUS             │${RESET}"
echo -e "${BOLD}├─────────────────────────────────────┤${RESET}"
echo -e "${BOLD}│${RESET}  Current:     ${CYAN}${LOCAL_HASH}${RESET}               ${BOLD}│${RESET}"
echo -e "${BOLD}│${RESET}  Sync check:  ${YELLOW}Manual only${RESET}          ${BOLD}│${RESET}"
echo -e "${BOLD}└─────────────────────────────────────┘${RESET}"
echo ""

# Check for pending OCC branches (TCC alert)
if [ -f "$PENDING_FILE" ] && [ -s "$PENDING_FILE" ]; then
    echo -e "${BOLD}${YELLOW}┌─────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${BOLD}${YELLOW}│  ⚠️  TCC ALERT: OCC BRANCHES WAITING FOR REVIEW            │${RESET}"
    echo -e "${BOLD}${YELLOW}├─────────────────────────────────────────────────────────────┤${RESET}"
    while read -r branch hash timestamp; do
        echo -e "${BOLD}${YELLOW}│${RESET}  Branch: ${CYAN}$branch${RESET}"
        echo -e "${BOLD}${YELLOW}│${RESET}  Commit: ${YELLOW}$hash${RESET}  Time: $timestamp"
    done < "$PENDING_FILE"
    echo -e "${BOLD}${YELLOW}├─────────────────────────────────────────────────────────────┤${RESET}"
    echo -e "${BOLD}${YELLOW}│${RESET}  ${BOLD}ACTION: Run /works-ready to validate and merge${RESET}"
    echo -e "${BOLD}${YELLOW}└─────────────────────────────────────────────────────────────┘${RESET}"
    echo ""
fi

# Get branch after pull
BRANCH=$(git branch --show-current 2>/dev/null || echo "UNKNOWN")

# Launch AIM with visible iTerm2 tabs
AIM_LAUNCHER="$REPO_ROOT/scripts/aim-launcher.sh"
AIM_PID_FILE="/tmp/aim-launcher-${REPO_NAME}.pid"

# NOTE: Watcher auto-launch disabled to prevent Claude startup hanging
# To manually start watchers: ./scripts/aim-launcher.sh
echo -e "📺 ${YELLOW}Watcher auto-launch disabled${RESET} (to prevent startup hang)"
echo -e "   To manually start: ${CYAN}./scripts/aim-launcher.sh${RESET}"

# Write context to session state file for Claude to read
cat > "$REPO_ROOT/.claude/session-state.md" << EOF
# Session Context

- **Repo:** $REPO_NAME
- **Branch:** $BRANCH
- **Role:** Check if you are OCC (developer) or TCC (project manager)
- **Commit:** $LOCAL_HASH
- **Board:** docs/BOARD.md $([ -f "$BOARD_FILE" ] && echo "(exists)" || echo "(missing)")

## Critical Rules (from CLAUDE.md)
1. ALWAYS specify repository name in every message
2. ALWAYS specify branch name when discussing git operations
3. ALWAYS give completion reports when finishing tasks
4. NEVER say vague things like "two merges remain" without context

## Manual Operations Available
- Sync: \`git fetch origin && git pull origin main\`
- Watchers: \`./scripts/aim-launcher.sh\`
EOF

# Minimal startup output
echo "📍 AICM Context: $REPO_NAME/$BRANCH ($LOCAL_HASH) - Check .claude/session-state.md for details"

exit 0
