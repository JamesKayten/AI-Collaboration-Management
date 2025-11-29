#!/bin/bash
# watch-all.sh - Combined Branch and Board watcher in single terminal
#
# Usage: ./scripts/watch-all.sh [interval_seconds]
# Default interval: 30 seconds

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

INTERVAL=${1:-30}
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
REPO_NAME=$(basename "$REPO_ROOT" 2>/dev/null || echo "UNKNOWN")
BRANCH_PATTERN="claude/*"
BOARD_FILE="docs/BOARD.md"
STATE_FILE="/tmp/branch-watcher-${REPO_NAME}.state"
PENDING_FILE="/tmp/branch-watcher-${REPO_NAME}.pending"

# Audio alerts (macOS)
play_branch_alert() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        afplay /System/Library/Sounds/Hero.aiff 2>/dev/null &
    else
        echo -e "\a"
    fi
}

play_board_alert() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        afplay /System/Library/Sounds/Glass.aiff 2>/dev/null &
        sleep 0.3
        afplay /System/Library/Sounds/Glass.aiff 2>/dev/null &
    else
        echo -e "\a"
    fi
}

show_notification() {
    local title="$1"
    local message="$2"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        osascript -e "display notification \"$message\" with title \"$title\"" 2>/dev/null
    fi
}

clear
echo -e "${BOLD}${CYAN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║              AIM UNIFIED WATCHER                          ║"
echo "║         Branch + Board Monitoring                         ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${RESET}"
echo -e "Repository: ${GREEN}${BOLD}$REPO_NAME${RESET}"
echo -e "Polling:    Every ${INTERVAL}s"
echo ""
echo -e "${BOLD}Monitoring:${RESET}"
echo -e "  🌿 OCC Branches (${CYAN}claude/*${RESET}) → ${GREEN}Hero${RESET} sound"
echo -e "  📋 Board Changes (${CYAN}BOARD.md${RESET}) → ${YELLOW}Glass${RESET} sound"
echo ""
echo -e "Press ${BOLD}Ctrl+C${RESET} to stop"
echo ""
echo -e "${BOLD}════════════════════════════════════════════════════════════${RESET}"

cd "$REPO_ROOT" || exit 1

# Initialize states
git fetch origin --quiet 2>/dev/null
git for-each-ref --format='%(refname:short) %(objectname:short)' refs/remotes/origin/$BRANCH_PATTERN 2>/dev/null > "$STATE_FILE"
LAST_BOARD_HASH=$(git rev-parse origin/main:$BOARD_FILE 2>/dev/null)

# Clear pending file at start
rm -f "$PENDING_FILE"

CYCLE=0
while true; do
    sleep "$INTERVAL"
    CYCLE=$((CYCLE + 1))

    # Fetch from GitHub
    if ! git fetch origin --quiet 2>/dev/null; then
        echo -e "\n[$(date +%H:%M:%S)] ${YELLOW}⚠️  Network error - retrying...${RESET}"
        continue
    fi

    CHANGES_FOUND=false

    # ═══════════════════════════════════════════════════════════
    # CHECK BRANCHES
    # ═══════════════════════════════════════════════════════════
    CURRENT_STATE=$(git for-each-ref --format='%(refname:short) %(objectname:short)' refs/remotes/origin/$BRANCH_PATTERN 2>/dev/null)
    PREVIOUS_STATE=$(cat "$STATE_FILE" 2>/dev/null)

    if [[ "$CURRENT_STATE" != "$PREVIOUS_STATE" ]]; then
        CHANGES_FOUND=true
        echo ""
        echo -e "${BOLD}${GREEN}┌─────────────────────────────────────────────────────────────┐${RESET}"
        echo -e "${BOLD}${GREEN}│  🌿 [$(date +%H:%M:%S)] OCC BRANCH ACTIVITY                        │${RESET}"
        echo -e "${BOLD}${GREEN}└─────────────────────────────────────────────────────────────┘${RESET}"

        # Show current branches
        echo "$CURRENT_STATE" | while read branch hash; do
            branch_short=$(echo "$branch" | sed 's|origin/||')
            if ! grep -q "$hash" "$STATE_FILE" 2>/dev/null; then
                echo -e "  ${BOLD}${GREEN}⭐ NEW:${RESET} ${CYAN}$branch_short${RESET} (${YELLOW}$hash${RESET})"
                echo "$branch_short $hash $(date +%Y-%m-%d_%H:%M:%S)" >> "$PENDING_FILE"
                show_notification "🌿 OCC Branch Ready" "$branch_short"
            else
                echo -e "  → ${CYAN}$branch_short${RESET} (${YELLOW}$hash${RESET})"
            fi
        done

        echo -e "  ${BOLD}Action:${RESET} Start TCC session or run ${CYAN}/works-ready${RESET}"
        echo ""
        play_branch_alert
        echo "$CURRENT_STATE" > "$STATE_FILE"
    fi

    # ═══════════════════════════════════════════════════════════
    # CHECK BOARD
    # ═══════════════════════════════════════════════════════════
    CURRENT_BOARD_HASH=$(git rev-parse origin/main:$BOARD_FILE 2>/dev/null)

    if [[ "$CURRENT_BOARD_HASH" != "$LAST_BOARD_HASH" ]]; then
        CHANGES_FOUND=true
        echo ""
        echo -e "${BOLD}${YELLOW}┌─────────────────────────────────────────────────────────────┐${RESET}"
        echo -e "${BOLD}${YELLOW}│  📋 [$(date +%H:%M:%S)] BOARD.MD UPDATED                           │${RESET}"
        echo -e "${BOLD}${YELLOW}└─────────────────────────────────────────────────────────────┘${RESET}"
        echo -e "  ${BOLD}Action:${RESET} git pull && check ${CYAN}docs/BOARD.md${RESET}"
        echo ""
        play_board_alert
        LAST_BOARD_HASH="$CURRENT_BOARD_HASH"
    fi

    # Show heartbeat if no changes
    if [[ "$CHANGES_FOUND" == false ]]; then
        # Show status every 10 cycles (5 min at 30s interval)
        if [[ $((CYCLE % 10)) -eq 0 ]]; then
            PENDING_COUNT=$(cat "$PENDING_FILE" 2>/dev/null | wc -l | tr -d ' ')
            BRANCH_COUNT=$(echo "$CURRENT_STATE" | grep -c "claude/" 2>/dev/null || echo "0")
            echo -e "\n[$(date +%H:%M:%S)] ${BOLD}Status:${RESET} ${GREEN}$BRANCH_COUNT${RESET} branches, ${YELLOW}$PENDING_COUNT${RESET} pending"
        else
            echo -n "."
        fi
    fi
done
