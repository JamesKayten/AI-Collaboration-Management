#!/bin/bash
# TCC Session Start Hook - Full protocol with fast watcher launch

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
BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
LOCAL_HASH=$(git rev-parse HEAD 2>/dev/null | cut -c1-7)
BOARD_FILE="$REPO_ROOT/docs/BOARD.md"
PENDING_FILE="/tmp/branch-watcher-${REPO_NAME}.pending"

# Watcher scripts and PID files
BRANCH_WATCHER="$REPO_ROOT/scripts/watch-branches.sh"
BRANCH_PID_FILE="/tmp/branch-watcher-${REPO_NAME}.pid"
BOARD_WATCHER="$REPO_ROOT/scripts/watch-board.sh"
BOARD_PID_FILE="/tmp/board-watcher-${REPO_NAME}.pid"
AIM_LAUNCHER="$REPO_ROOT/scripts/aim-launcher.sh"
AIM_PID_FILE="/tmp/aim-launcher-${REPO_NAME}.pid"

cd "$REPO_ROOT" || exit 1

echo ""
echo -e "${BOLD}┌─────────────────────────────────────┐${RESET}"
echo -e "${BOLD}│      🎯 TCC SESSION ACTIVE          │${RESET}"
echo -e "${BOLD}├─────────────────────────────────────┤${RESET}"
echo -e "${BOLD}│${RESET}  Repository: ${GREEN}${REPO_NAME}${RESET}"
echo -e "${BOLD}│${RESET}  Branch:     ${CYAN}${BRANCH}${RESET}"
echo -e "${BOLD}│${RESET}  Role:       ${YELLOW}TCC (Project Manager)${RESET}"
echo -e "${BOLD}│${RESET}  Commit:     ${CYAN}${LOCAL_HASH}${RESET}"
echo -e "${BOLD}└─────────────────────────────────────┘${RESET}"

# Check for pending OCC branches (TCC alert)
if [ -f "$PENDING_FILE" ] && [ -s "$PENDING_FILE" ]; then
    echo ""
    echo -e "${BOLD}${YELLOW}⚠️  TCC ALERT: OCC BRANCHES WAITING FOR REVIEW${RESET}"
    while read -r branch hash timestamp; do
        echo -e "   Branch: ${CYAN}$branch${RESET} (${YELLOW}$hash${RESET}) - $timestamp"
    done < "$PENDING_FILE"
    echo -e "   ${BOLD}ACTION: Run /works-ready to validate and merge${RESET}"
fi

# Launch watchers for TCC monitoring
if [ -f "$AIM_LAUNCHER" ]; then
    if [ -f "$AIM_PID_FILE" ] && ps -p "$(cat "$AIM_PID_FILE")" > /dev/null 2>&1; then
        echo -e "📺 Watchers ${GREEN}already running${RESET}"
    else
        echo -e "📺 ${GREEN}Launching TCC watchers...${RESET}"
        if [[ "$OSTYPE" == "darwin"* ]] && [ -d "/Applications/iTerm.app" ]; then
            # Fast background launch - don't wait for iTerm
            nohup "$AIM_LAUNCHER" "$REPO_ROOT" >/dev/null 2>&1 &
            LAUNCHER_PID=$!
            echo $LAUNCHER_PID > "$AIM_PID_FILE"
            echo -e "   🔨 Build Watcher - ${BLUE}Basso${RESET} (error) / ${GREEN}Blow${RESET} (success)"
            echo -e "   🌿 Branch Watcher - ${CYAN}Hero${RESET} (OCC ready)"
            echo -e "   📋 Board Watcher - ${YELLOW}Glass${RESET} (tasks updated)"
        else
            echo -e "${YELLOW}⚠️  iTerm2 not available, using background watchers${RESET}"
        fi
    fi
fi

# Write detailed session state
cat > "$REPO_ROOT/.claude/session-state.md" << EOF
# TCC Session Context

- **Repository:** $REPO_NAME
- **Branch:** $BRANCH
- **Role:** TCC (Project Manager)
- **Commit:** $LOCAL_HASH
- **Platform:** macOS
- **Board:** docs/BOARD.md $([ -f "$BOARD_FILE" ] && echo "(exists)" || echo "(missing)")

## TCC Protocol Active
- Monitor for OCC branch submissions (Hero sound)
- Review and validate OCC work
- Merge approved branches to main
- Update BOARD.md after completing tasks
- Ensure repository sync and cleanup

## Commands Available
- \`/works-ready\` - Review and merge OCC branches
- \`/check-the-board\` - Check current task status

## Manual Operations
- Sync: \`git fetch origin && git pull origin main\`
- Manual watchers: \`./scripts/aim-launcher.sh\`
EOF

echo ""
echo -e "${BOLD}🎯 TCC READY${RESET} - Monitoring for OCC work | Context: .claude/session-state.md"

exit 0