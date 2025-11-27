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

# State file that Claude will read
STATE_FILE="$REPO_ROOT/.claude/session-state.md"

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

# Detect role: Check .claude/role.local first, then fall back to OS detection
ROLE_LOCAL_FILE="$REPO_ROOT/.claude/role.local"

if [[ -f "$ROLE_LOCAL_FILE" && -r "$ROLE_LOCAL_FILE" ]]; then
    # Read role from local override file
    ROLE_OVERRIDE=$(cat "$ROLE_LOCAL_FILE" 2>/dev/null | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
    if [[ "$ROLE_OVERRIDE" == "TCC" || "$ROLE_OVERRIDE" == "OCC" ]]; then
        ROLE="$ROLE_OVERRIDE"
        if [[ "$ROLE" == "TCC" ]]; then
            ROLE_DESC="Project Manager (via role.local)"
        else
            ROLE_DESC="Developer (via role.local)"
        fi
    else
        # Invalid role in file, fall back to OS detection
        ROLE_DESC_SUFFIX=" (role.local invalid: '$ROLE_OVERRIDE', using OS detection)"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            ROLE="TCC"
            ROLE_DESC="Project Manager${ROLE_DESC_SUFFIX}"
        else
            ROLE="OCC"
            ROLE_DESC="Developer${ROLE_DESC_SUFFIX}"
        fi
    fi
else
    # No override file, use OS detection (original behavior)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ROLE="TCC"
        ROLE_DESC="Project Manager"
    else
        ROLE="OCC"
        ROLE_DESC="Developer"
    fi
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

# Check for OCC branches
OCC_BRANCHES=$(git branch -r 2>/dev/null | grep "origin/claude/" | grep -v "HEAD" | sed 's/origin\///' | tr -d ' ')
OCC_BRANCH_COUNT=$(echo "$OCC_BRANCHES" | grep -c "claude/" 2>/dev/null || echo "0")

# Determine sync status
if [[ "$LOCAL_HASH" == "$REMOTE_HASH" ]]; then
    SYNC_STATUS="IN SYNC ✓"
else
    SYNC_STATUS="OUT OF SYNC ✗"
fi

# Write state file for Claude to read
cat > "$STATE_FILE" << STATEEOF
# Session State (Auto-generated)

**Read this file on startup. Act immediately based on contents.**

## Current Context
- **Repository:** $REPO_NAME
- **Branch:** $BRANCH
- **Role:** $ROLE ($ROLE_DESC)
- **Sync:** $SYNC_STATUS (local: $LOCAL_HASH, remote: $REMOTE_HASH)
- **Generated:** $(date '+%Y-%m-%d %H:%M:%S')

## Pending Work

STATEEOF

# Add OCC branches if any exist
if [[ "$OCC_BRANCH_COUNT" -gt 0 && -n "$OCC_BRANCHES" ]]; then
    cat >> "$STATE_FILE" << BRANCHEOF
### ⚠️ OCC BRANCHES WAITING FOR REVIEW
\`\`\`
$OCC_BRANCHES
\`\`\`
**ACTION REQUIRED:** Run \`/works-ready\` immediately to validate and merge.

BRANCHEOF
fi

# Add pending file contents if exists
if [ -f "$PENDING_FILE" ] && [ -s "$PENDING_FILE" ]; then
    cat >> "$STATE_FILE" << PENDINGEOF
### Pending Branch Details (from watcher)
\`\`\`
$(cat "$PENDING_FILE")
\`\`\`

PENDINGEOF
fi

# Add directive based on role
if [ "$ROLE" = "TCC" ]; then
    cat >> "$STATE_FILE" << TCCEOF
## Your Directive (TCC)
1. Say: "I am TCC in $REPO_NAME, ready to work. [CLAUDE.md verified ✓]"
2. If OCC branches listed above → Run \`/works-ready\` NOW
3. If tasks in BOARD.md "FOR TCC" → Start working
4. If nothing pending → Say "No work pending, standing by."

**DO NOT ASK PERMISSION. ACT.**
TCCEOF
else
    cat >> "$STATE_FILE" << OCCEOF
## Your Directive (OCC)
1. Say: "I am OCC in $REPO_NAME, ready to work. [CLAUDE.md verified ✓]"
2. If tasks in BOARD.md "FOR OCC" → Start working
3. If nothing pending → Say "No work pending, standing by."

**DO NOT ASK PERMISSION. ACT.**
OCCEOF
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
