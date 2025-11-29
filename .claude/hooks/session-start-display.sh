#!/bin/bash
# SessionStart display script - handles all startup display and processes
# Outputs everything to stderr so it doesn't interfere with hook JSON

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

echo "" >&2
echo -e "${BOLD}================================================================================${RESET}" >&2
echo -e "${BOLD}SYNCING WITH GITHUB...${RESET}" >&2
echo -e "${BOLD}================================================================================${RESET}" >&2

# Fetch and pull latest from GitHub
git fetch origin main --quiet 2>/dev/null

LOCAL_HASH=$(git rev-parse HEAD 2>/dev/null | cut -c1-7)
REMOTE_HASH=$(git rev-parse origin/main 2>/dev/null | cut -c1-7)

if [[ "$LOCAL_HASH" != "$REMOTE_HASH" ]]; then
    echo -e "${YELLOW}Local is behind remote. Pulling latest...${RESET}" >&2
    git pull origin main --quiet 2>/dev/null
    LOCAL_HASH=$(git rev-parse HEAD 2>/dev/null | cut -c1-7)
fi

# Display sync status prominently
echo "" >&2
echo -e "${BOLD}┌─────────────────────────────────────┐${RESET}" >&2
echo -e "${BOLD}│         ✅ SYNC STATUS              │${RESET}" >&2
echo -e "${BOLD}├─────────────────────────────────────┤${RESET}" >&2
echo -e "${BOLD}│${RESET}  Local main:  ${CYAN}${LOCAL_HASH}${RESET}                 ${BOLD}│${RESET}" >&2
echo -e "${BOLD}│${RESET}  Remote main: ${CYAN}${REMOTE_HASH}${RESET}                 ${BOLD}│${RESET}" >&2

if [[ "$LOCAL_HASH" == "$REMOTE_HASH" ]]; then
    echo -e "${BOLD}│${RESET}  Status: ${GREEN}${BOLD}IN SYNC ✓${RESET}                  ${BOLD}│${RESET}" >&2
else
    echo -e "${BOLD}│${RESET}  Status: ${RED}${BOLD}OUT OF SYNC ✗${RESET}              ${BOLD}│${RESET}" >&2
fi
echo -e "${BOLD}└─────────────────────────────────────┘${RESET}" >&2
echo "" >&2

# Check for pending OCC branches (TCC alert)
if [ -f "$PENDING_FILE" ] && [ -s "$PENDING_FILE" ]; then
    echo -e "${BOLD}${YELLOW}┌─────────────────────────────────────────────────────────────┐${RESET}" >&2
    echo -e "${BOLD}${YELLOW}│  ⚠️  TCC ALERT: OCC BRANCHES WAITING FOR REVIEW            │${RESET}" >&2
    echo -e "${BOLD}${YELLOW}├─────────────────────────────────────────────────────────────┤${RESET}" >&2
    while read -r branch hash timestamp; do
        echo -e "${BOLD}${YELLOW}│${RESET}  Branch: ${CYAN}$branch${RESET}" >&2
        echo -e "${BOLD}${YELLOW}│${RESET}  Commit: ${YELLOW}$hash${RESET}  Time: $timestamp" >&2
    done < "$PENDING_FILE"
    echo -e "${BOLD}${YELLOW}├─────────────────────────────────────────────────────────────┤${RESET}" >&2
    echo -e "${BOLD}${YELLOW}│${RESET}  ${BOLD}AUTO-PROCESSING ENABLED - branches will be validated${RESET}" >&2
    echo -e "${BOLD}${YELLOW}└─────────────────────────────────────────────────────────────┘${RESET}" >&2
    echo "" >&2
fi

# Get branch after pull
BRANCH=$(git branch --show-current 2>/dev/null || echo "UNKNOWN")

# Launch AIM with visible iTerm2 tabs
AIM_LAUNCHER="$REPO_ROOT/scripts/aim-launcher.sh"
AIM_PID_FILE="/tmp/aim-launcher-${REPO_NAME}.pid"

if [ -f "$AIM_LAUNCHER" ]; then
    # Check if watchers are already running
    if [ -f "$AIM_PID_FILE" ] && ps -p "$(cat "$AIM_PID_FILE")" > /dev/null 2>&1; then
        echo -e "📺 AIM watchers ${GREEN}already running${RESET} in iTerm2 tabs" >&2
    else
        # Launch iTerm2 with all watchers in separate tabs
        if [[ "$OSTYPE" == "darwin"* ]] && [ -d "/Applications/iTerm.app" ]; then
            "$AIM_LAUNCHER" "$REPO_ROOT" > /dev/null 2>&1 &
            echo $! > "$AIM_PID_FILE"
            echo -e "📺 ${GREEN}Launching iTerm2 watchers...${RESET}" >&2
            echo -e "   🔨 Build Watcher - Basso (error) / Blow (success)" >&2
            echo -e "   🌿 Branch Watcher - ${CYAN}Hero${RESET} (OCC branch ready)" >&2
            echo -e "   📋 Board Watcher - ${YELLOW}Glass${RESET} (TCC posted task)" >&2
        else
            # Fallback to background processes if not on macOS
            echo -e "${YELLOW}⚠️  iTerm2 not available, using background watchers${RESET}" >&2
            if [ -f "$BRANCH_WATCHER" ]; then
                nohup "$BRANCH_WATCHER" > /tmp/branch-watcher.log 2>&1 &
                echo -e "📡 Branch watcher ${GREEN}started${RESET} (background) - ${CYAN}Hero sound${RESET}" >&2
            fi
            if [ -f "$BOARD_WATCHER" ]; then
                nohup "$BOARD_WATCHER" > /tmp/board-watcher.log 2>&1 &
                echo -e "📋 Board watcher ${GREEN}started${RESET} (background) - ${YELLOW}Glass sound${RESET}" >&2
            fi
        fi
    fi
fi

echo "" >&2
echo -e "${BOLD}================================================================================${RESET}" >&2
echo -e "${BOLD}SESSION START - MANDATORY CONTEXT${RESET}" >&2
echo -e "${BOLD}================================================================================${RESET}" >&2
echo "" >&2
echo -e "REPOSITORY: ${GREEN}${BOLD}$REPO_NAME${RESET}" >&2
echo -e "BRANCH:     ${CYAN}${BOLD}$BRANCH${RESET}" >&2
echo -e "ROLE:       Check if you are ${BLUE}OCC${RESET} (developer) or ${YELLOW}TCC${RESET} (project manager)" >&2
echo "" >&2
echo -e "${BOLD}CRITICAL RULES${RESET} (from CLAUDE.md):" >&2
echo "1. ALWAYS specify repository name in every message" >&2
echo "2. ALWAYS specify branch name when discussing git operations" >&2
echo "3. ALWAYS give completion reports when finishing tasks" >&2
echo "4. NEVER say vague things like \"two merges remain\" without context" >&2
echo "" >&2
echo -e "${BOLD}================================================================================${RESET}" >&2
echo -e "${BOLD}CURRENT BOARD STATUS${RESET} ($REPO_NAME/docs/BOARD.md):" >&2
echo -e "${BOLD}================================================================================${RESET}" >&2

# Show board contents if it exists
if [ -f "$BOARD_FILE" ]; then
    cat "$BOARD_FILE" >&2
else
    echo -e "${RED}No BOARD.md found at $BOARD_FILE${RESET}" >&2
fi

# Count pending OCC branches for TCC directive
PENDING_COUNT=0
if [ -f "$PENDING_FILE" ] && [ -s "$PENDING_FILE" ]; then
    PENDING_COUNT=$(wc -l < "$PENDING_FILE" | tr -d ' ')
fi

echo "" >&2
echo -e "${BOLD}================================================================================${RESET}" >&2
echo -e "${BOLD}END OF BOARD${RESET}" >&2
echo -e "${BOLD}================================================================================${RESET}" >&2

echo "" >&2
echo -e "${BOLD}${GREEN}  ████████╗ ██████╗ ██████╗     ██████╗ ███████╗ █████╗ ██████╗ ██╗   ██╗${RESET}" >&2
echo -e "${BOLD}${GREEN}  ╚══██╔══╝██╔════╝██╔════╝     ██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝${RESET}" >&2
echo -e "${BOLD}${GREEN}     ██║   ██║     ██║          ██████╔╝█████╗  ███████║██║  ██║ ╚████╔╝ ${RESET}" >&2
echo -e "${BOLD}${GREEN}     ██║   ██║     ██║          ██╔══██╗██╔══╝  ██╔══██║██║  ██║  ╚██╔╝  ${RESET}" >&2
echo -e "${BOLD}${GREEN}     ██║   ╚██████╗╚██████╗     ██║  ██║███████╗██║  ██║██████╔╝   ██║   ${RESET}" >&2
echo -e "${BOLD}${GREEN}     ╚═╝    ╚═════╝ ╚═════╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝    ╚═╝   ${RESET}" >&2
echo -e "${BOLD}================================================================================${RESET}" >&2

echo "" >&2
echo -e "${BOLD}${GREEN}TCC AUTO-INITIALIZED${RESET}" >&2
echo "" >&2

# Auto-process if branches are pending - ACTUALLY EXECUTE, don't just instruct
if [[ $PENDING_COUNT -gt 0 ]]; then
    FIRST_BRANCH=$(head -1 "$PENDING_FILE" | cut -d' ' -f1)

    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════════════════════${RESET}" >&2
    echo -e "${BOLD}${CYAN}AUTO-EXECUTING: Processing $FIRST_BRANCH${RESET}" >&2
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════════════════════${RESET}" >&2
    echo "" >&2

    # Run validation
    echo -e "${YELLOW}Running validation...${RESET}" >&2
    VALIDATION_OUTPUT=$("$REPO_ROOT/scripts/tcc-validate-branch.sh" "$FIRST_BRANCH" 2>&1)
    VALIDATION_EXIT=$?

    echo "$VALIDATION_OUTPUT" >&2

    if [[ $VALIDATION_EXIT -eq 0 ]] && echo "$VALIDATION_OUTPUT" | grep -q "RESULT: NOTHING TO MERGE\|already merged"; then
        # Already merged - just clean up
        echo "" >&2
        echo -e "${GREEN}✓ Branch already merged or no new commits${RESET}" >&2

        # Remove from pending file
        if [[ -f "$PENDING_FILE" ]]; then
            grep -v "$FIRST_BRANCH" "$PENDING_FILE" > "${PENDING_FILE}.tmp" 2>/dev/null || true
            mv "${PENDING_FILE}.tmp" "$PENDING_FILE" 2>/dev/null || true
        fi

        # Output for Claude to report (stdout, not stderr)
        echo ""
        echo "AUTO-PROCESS RESULT: ALREADY_MERGED"
        echo "Branch: $FIRST_BRANCH"
        echo "Status: Branch was already merged or has no new commits"
        echo "Action: Cleaned up pending list"
        echo "Report this to the user."

    elif [[ $VALIDATION_EXIT -eq 0 ]]; then
        # Validation passed - do the merge
        echo "" >&2
        echo -e "${GREEN}✓ Validation passed - merging...${RESET}" >&2

        # Ensure on main
        git checkout main >&2 2>&1
        git pull origin main >&2 2>&1

        # Merge
        MERGE_OUTPUT=$(git merge --no-ff "origin/$FIRST_BRANCH" -m "Auto-merge: $FIRST_BRANCH" 2>&1)
        MERGE_EXIT=$?

        if [[ $MERGE_EXIT -eq 0 ]]; then
            # Push
            git push origin main >&2 2>&1
            MERGE_HASH=$(git rev-parse --short HEAD)

            # Delete remote branch
            git push origin --delete "$FIRST_BRANCH" >&2 2>&1 || true

            # Remove from pending file
            if [[ -f "$PENDING_FILE" ]]; then
                grep -v "$FIRST_BRANCH" "$PENDING_FILE" > "${PENDING_FILE}.tmp" 2>/dev/null || true
                mv "${PENDING_FILE}.tmp" "$PENDING_FILE" 2>/dev/null || true
            fi

            echo "" >&2
            echo -e "${GREEN}✓ AUTO-MERGE COMPLETE: $FIRST_BRANCH → main (${MERGE_HASH})${RESET}" >&2

            # Output for Claude to report (stdout)
            echo ""
            echo "AUTO-PROCESS RESULT: SUCCESS"
            echo "Branch: $FIRST_BRANCH"
            echo "Merged: commit $MERGE_HASH"
            echo "Action: Validated, merged to main, deleted branch"
            echo "Report this completion to the user and update BOARD.md."
        else
            echo "" >&2
            echo -e "${RED}✗ Merge failed${RESET}" >&2
            echo "$MERGE_OUTPUT" >&2

            # Output for Claude
            echo ""
            echo "AUTO-PROCESS RESULT: MERGE_FAILED"
            echo "Branch: $FIRST_BRANCH"
            echo "Error: $MERGE_OUTPUT"
            echo "Report this failure to the user."
        fi
    else
        # Validation failed
        echo "" >&2
        echo -e "${RED}✗ Validation failed${RESET}" >&2

        # Output for Claude
        echo ""
        echo "AUTO-PROCESS RESULT: VALIDATION_FAILED"
        echo "Branch: $FIRST_BRANCH"
        echo "Reason: Validation script returned non-zero exit"
        echo "Report this failure to the user."
    fi
else
    echo -e "${GREEN}✓${RESET} No pending branches - standing by" >&2

    # Output for Claude
    echo ""
    echo "AUTO-PROCESS RESULT: NO_BRANCHES"
    echo "Status: No pending OCC branches to process"
    echo "Action: Standing by for user requests"
fi

echo "" >&2
echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════════════════════${RESET}" >&2
echo -e "${BOLD}${CYAN}SESSION READY${RESET}" >&2
echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════════════════════${RESET}" >&2