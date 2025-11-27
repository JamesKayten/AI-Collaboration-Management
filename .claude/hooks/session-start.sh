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

# TCC Readiness Assessment - Check for OCC work and establish status
echo ""
git fetch origin --quiet 2>/dev/null || true

# Check for OCC branches (claude/* pattern)
OCC_BRANCHES=$(git branch -r 2>/dev/null | grep "origin/claude/" | grep -v HEAD | wc -l | tr -d ' ')

# Check pending file for branch watcher alerts
PENDING_ALERTS=""
if [ -f "$PENDING_FILE" ] && [ -s "$PENDING_FILE" ]; then
    PENDING_ALERTS=$(cat "$PENDING_FILE")
fi

if [ "$OCC_BRANCHES" -gt 0 ] || [ -n "$PENDING_ALERTS" ]; then
    echo -e "${BOLD}${YELLOW}⚠️  TCC ALERT: OCC BRANCHES WAITING FOR REVIEW${RESET}"

    if [ -n "$PENDING_ALERTS" ]; then
        while read -r branch hash timestamp; do
            echo -e "   Branch: ${CYAN}$branch${RESET} (${YELLOW}$hash${RESET}) - $timestamp"
        done < "$PENDING_FILE"
    else
        git branch -r 2>/dev/null | grep "origin/claude/" | grep -v HEAD | while read -r branch; do
            branch_name=$(echo "$branch" | sed 's/origin\///')
            echo -e "   Branch: ${CYAN}$branch_name${RESET} - Ready for review"
        done
    fi
    echo -e "   ${BOLD}ACTION: Run /works-ready to validate and merge${RESET}"
else
    echo -e "${BOLD}${GREEN}✅ TCC READY - NO PENDING WORK${RESET}"
    echo -e "${GREEN}No OCC branches or pending tasks found. TCC is ready for new work.${RESET}"
    echo ""
    echo -e "${CYAN}Monitoring for new submissions:${RESET}"
    echo -e "  • Branch submissions will trigger ${CYAN}Hero${RESET} sound alert"
    echo -e "  • Use ${BOLD}/check-the-board${RESET} to review current tasks"
    echo -e "  • Ready to accept new work assignments"
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

# Write detailed session state with current readiness status
READINESS_STATUS="READY"
READINESS_DETAIL="TCC ready for new work assignments"

if [ "$OCC_BRANCHES" -gt 0 ] || [ -n "$PENDING_ALERTS" ]; then
    READINESS_STATUS="OCC WORK PENDING"
    READINESS_DETAIL="$OCC_BRANCHES OCC branch(es) waiting for review - auto-initializing TCC"
fi

cat > "$REPO_ROOT/.claude/session-state.md" << EOF
# TCC Session Context

- **Repository:** $REPO_NAME
- **Branch:** $BRANCH
- **Role:** TCC (Project Manager)
- **Commit:** $LOCAL_HASH
- **Platform:** macOS
- **Board:** docs/BOARD.md $([ -f "$BOARD_FILE" ] && echo "(exists)" || echo "(missing)")
- **Status:** $READINESS_STATUS

## Current Readiness
$READINESS_DETAIL

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

## TCC Auto-Initialization Required
TCC should automatically complete initialization checklist from CLAUDE.md:
1. ✅ Read CLAUDE.md (done by session start)
2. 🔄 Check docs/BOARD.md for current status
3. 🔄 Identify repository location and branch
4. 🔄 Acknowledge TCC role and proceed with work
EOF

echo ""
echo -e "${BOLD}🎯 TCC AUTO-INITIALIZING${RESET}"
echo -e "${GREEN}Completing TCC initialization checklist automatically...${RESET}"
echo ""
echo -e "${CYAN}✅ Step 1/4: CLAUDE.md read (session start)${RESET}"
echo -e "${CYAN}🔄 Step 2/4: Checking board status...${RESET}"

# Check board for actual tasks (not just status lines)
BOARD_TASKS=""
if [ -f "$BOARD_FILE" ]; then
    # Look for actual task items - lines that aren't headers, status, or "No pending" messages
    BOARD_CONTENT=$(grep -E "^[[:space:]]*[-*+] .+|^[[:digit:]]+\. .+" "$BOARD_FILE" 2>/dev/null || true)
    # Also check for any non-empty lines in task sections that aren't the "No pending" placeholders
    TASK_LINES=$(grep -A 20 "Tasks FOR" "$BOARD_FILE" 2>/dev/null | grep -v "^#\|^$\|^-\|^\*No pending\|^Tasks FOR\|^\*\*Board Status\|^\*\*Last Update" | grep -v "^---" | tr -d ' \t' | grep -v '^$' || true)

    if [ -n "$BOARD_CONTENT" ] || [ -n "$TASK_LINES" ]; then
        BOARD_TASKS="found"
    fi
fi

echo -e "${CYAN}✅ Step 3/4: Repository: $REPO_NAME, Branch: $BRANCH${RESET}"
echo -e "${CYAN}🔄 Step 4/4: Acknowledging TCC role and proceeding...${RESET}"

# Complete TCC initialization automatically
echo ""
if [ "$OCC_BRANCHES" -gt 0 ] || [ -n "$PENDING_ALERTS" ]; then
    echo -e "${YELLOW}📋 OCC BRANCHES DETECTED - Run /works-ready to process${RESET}"
    echo -e "${GREEN}✅ Step 4/4: TCC acknowledges role - READY${RESET}"
elif [ -n "$BOARD_TASKS" ]; then
    echo -e "${YELLOW}📋 BOARD TASKS DETECTED - Run /check-the-board to review${RESET}"
    echo -e "${GREEN}✅ Step 4/4: TCC acknowledges role - READY${RESET}"
else
    echo -e "${GREEN}✅ Step 4/4: TCC acknowledges role - INITIALIZATION COMPLETE${RESET}"
    echo -e "${GREEN}🎯 NO PENDING WORK - TCC monitoring for new submissions${RESET}"
fi

echo ""
echo -e "${BOLD}🎯 TCC INITIALIZATION COMPLETE${RESET} | Context: .claude/session-state.md"

exit 0