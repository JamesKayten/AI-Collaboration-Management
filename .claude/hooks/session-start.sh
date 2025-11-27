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

echo ""
echo -e "${BOLD}================================================================================${RESET}"
echo -e "${BOLD}SYNCING WITH GITHUB...${RESET}"
echo -e "${BOLD}================================================================================${RESET}"

# Fetch and pull latest from GitHub
git fetch origin main --quiet 2>/dev/null

LOCAL_HASH=$(git rev-parse HEAD 2>/dev/null | cut -c1-7)
REMOTE_HASH=$(git rev-parse origin/main 2>/dev/null | cut -c1-7)

if [[ "$LOCAL_HASH" != "$REMOTE_HASH" ]]; then
    echo -e "${YELLOW}Local is behind remote. Pulling latest...${RESET}"
    git pull origin main --quiet 2>/dev/null
    LOCAL_HASH=$(git rev-parse HEAD 2>/dev/null | cut -c1-7)
fi

# Display sync status prominently
echo ""
echo -e "${BOLD}┌─────────────────────────────────────┐${RESET}"
echo -e "${BOLD}│         ✅ SYNC STATUS              │${RESET}"
echo -e "${BOLD}├─────────────────────────────────────┤${RESET}"
echo -e "${BOLD}│${RESET}  Local main:  ${CYAN}${LOCAL_HASH}${RESET}                 ${BOLD}│${RESET}"
echo -e "${BOLD}│${RESET}  Remote main: ${CYAN}${REMOTE_HASH}${RESET}                 ${BOLD}│${RESET}"

if [[ "$LOCAL_HASH" == "$REMOTE_HASH" ]]; then
    echo -e "${BOLD}│${RESET}  Status: ${GREEN}${BOLD}IN SYNC ✓${RESET}                  ${BOLD}│${RESET}"
else
    echo -e "${BOLD}│${RESET}  Status: ${RED}${BOLD}OUT OF SYNC ✗${RESET}              ${BOLD}│${RESET}"
fi
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

# Detect role based on OS: macOS = TCC (local), Linux = OCC (remote)
if [[ "$OSTYPE" == "darwin"* ]]; then
    ROLE="TCC"
    ROLE_DESC="Project Manager"
else
    ROLE="OCC"
    ROLE_DESC="Developer"
fi

# Watchers - macOS: run ./scripts/aim-launcher.sh manually AFTER Claude starts
# Linux: background watchers
if [[ "$OSTYPE" != "darwin"* ]]; then
    if [ -f "$BRANCH_WATCHER" ]; then
        nohup "$BRANCH_WATCHER" > /tmp/branch-watcher.log 2>&1 &
    fi
    if [ -f "$BOARD_WATCHER" ]; then
        nohup "$BOARD_WATCHER" > /tmp/board-watcher.log 2>&1 &
    fi
fi

echo ""
echo -e "${BOLD}================================================================================${RESET}"
echo -e "${BOLD}SESSION START - MANDATORY CONTEXT${RESET}"
echo -e "${BOLD}================================================================================${RESET}"
echo ""
echo -e "REPOSITORY: ${GREEN}${BOLD}$REPO_NAME${RESET}"
echo -e "BRANCH:     ${CYAN}${BOLD}$BRANCH${RESET}"
if [ "$ROLE" = "TCC" ]; then
    echo -e "ROLE:       ${YELLOW}${BOLD}$ROLE${RESET} ($ROLE_DESC)"
else
    echo -e "ROLE:       ${BLUE}${BOLD}$ROLE${RESET} ($ROLE_DESC)"
fi
echo ""
echo -e "${BOLD}CRITICAL RULES${RESET} (from CLAUDE.md):"
echo "1. ALWAYS specify repository name in every message"
echo "2. ALWAYS specify branch name when discussing git operations"
echo "3. ALWAYS give completion reports when finishing tasks"
echo "4. NEVER say vague things like \"two merges remain\" without context"
echo ""
echo -e "${BOLD}================================================================================${RESET}"
echo -e "${BOLD}CURRENT BOARD STATUS${RESET} ($REPO_NAME/docs/BOARD.md):"
echo -e "${BOLD}================================================================================${RESET}"

# Show board contents if it exists
if [ -f "$BOARD_FILE" ]; then
    cat "$BOARD_FILE"
else
    echo -e "${RED}No BOARD.md found at $BOARD_FILE${RESET}"
fi

echo ""
echo -e "${BOLD}================================================================================${RESET}"
echo -e "${BOLD}YOUR DIRECTIVE${RESET}"
echo -e "${BOLD}================================================================================${RESET}"
echo ""
if [ "$ROLE" = "TCC" ]; then
    echo "You are TCC (Project Manager) in $REPO_NAME."
    echo "Say: 'I am TCC in $REPO_NAME, ready to work.'"
    echo "Then check BOARD.md for tasks. If OCC branches exist, run /works-ready."
    echo "If nothing pending, say 'No work pending, standing by.'"
else
    echo "You are OCC (Developer) in $REPO_NAME."
    echo "Say: 'I am OCC in $REPO_NAME, ready to work.'"
    echo "Then check BOARD.md for tasks. Work on any tasks in 'Tasks FOR OCC'."
    echo "If nothing pending, say 'No work pending, standing by.'"
fi
echo ""
echo -e "${BOLD}================================================================================${RESET}"

exit 0
