#!/bin/bash
# watch-branches.sh - Monitors GitHub for new/updated OCC branches
#
# Usage: ./scripts/watch-branches.sh [interval_seconds]
# Default interval: 30 seconds

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

INTERVAL=${1:-30}
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
REPO_NAME=$(basename "$REPO_ROOT" 2>/dev/null || echo "UNKNOWN")
BRANCH_PATTERN="claude/*"  # OCC branch naming convention
STATE_FILE="/tmp/branch-watcher-${REPO_NAME}.state"
PENDING_FILE="/tmp/branch-watcher-${REPO_NAME}.pending"

# Set to false once sounds are working to disable desktop notifications
DESKTOP_NOTIFICATIONS=true

# Audio alert function (cross-platform)
# SOUND: Hero (triumphant) - OCC completed work, ready for TCC review
play_alert() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Hero sound = OCC branch ready (triumphant fanfare)
        afplay /System/Library/Sounds/Hero.aiff 2>/dev/null &
    elif command -v paplay &>/dev/null; then
        paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null &
    elif command -v aplay &>/dev/null; then
        aplay /usr/share/sounds/alsa/Front_Center.wav 2>/dev/null &
    else
        echo -e "\a"
    fi
}

# Desktop notification (macOS) - disable once sounds work
show_notification() {
    local branch="$1"
    if [[ "$DESKTOP_NOTIFICATIONS" == true ]] && [[ "$OSTYPE" == "darwin"* ]]; then
        osascript -e "display notification \"Branch: $branch\" with title \"🌿 OCC Branch Ready\" subtitle \"TCC: Run /works-ready to process\"" 2>/dev/null
    fi
}

# Voice alert (macOS) - DISABLED
# speak_alert() {
#     local branch="$1"
#     if [[ "$OSTYPE" == "darwin"* ]]; then
#         say "OCC has pushed branch $branch ready for TCC review" 2>/dev/null &
#     fi
# }

echo -e "${BOLD}==================================${RESET}"
echo -e "${BOLD}BRANCH WATCHER${RESET} - ${GREEN}$REPO_NAME${RESET}"
echo -e "${BOLD}==================================${RESET}"
echo -e "Monitoring for OCC branch activity (pattern: ${CYAN}$BRANCH_PATTERN${RESET})"
echo "Polling every ${INTERVAL}s"
echo "Desktop notifications: $DESKTOP_NOTIFICATIONS"
echo "Press Ctrl+C to stop"
echo ""

cd "$REPO_ROOT" || exit 1

# Get initial state of remote branches
git fetch origin --quiet 2>/dev/null
git for-each-ref --format='%(refname:short) %(objectname:short)' refs/remotes/origin/$BRANCH_PATTERN 2>/dev/null > "$STATE_FILE"

# Clear any old pending file
rm -f "$PENDING_FILE"

while true; do
    sleep "$INTERVAL"

    # Fetch latest from GitHub
    if ! git fetch origin --quiet 2>/dev/null; then
        echo -e "[$(date +%H:%M:%S)] ${YELLOW}⚠️  Network error - retrying...${RESET}"
        continue
    fi

    # Get current state of remote branches
    CURRENT_STATE=$(git for-each-ref --format='%(refname:short) %(objectname:short)' refs/remotes/origin/$BRANCH_PATTERN 2>/dev/null)
    PREVIOUS_STATE=$(cat "$STATE_FILE" 2>/dev/null)

    if [[ "$CURRENT_STATE" != "$PREVIOUS_STATE" ]]; then
        echo ""
        echo -e "${BOLD}${GREEN}════════════════════════════════════════════════════════════${RESET}"
        echo -e "${BOLD}${GREEN}🔔 [$(date +%H:%M:%S)] OCC BRANCH ACTIVITY DETECTED!${RESET}"
        echo -e "${BOLD}${GREEN}════════════════════════════════════════════════════════════${RESET}"
        echo ""

        # Show what changed
        echo -e "${BOLD}Current branches:${RESET}"
        echo "$CURRENT_STATE" | while read branch hash; do
            branch_short=$(echo "$branch" | sed 's|origin/||')
            echo -e "  → ${CYAN}$branch_short${RESET} (${YELLOW}$hash${RESET})"
        done
        echo ""

        # Find new or updated branches and notify
        NEW_BRANCHES=""
        echo "$CURRENT_STATE" | while read branch hash; do
            if ! grep -q "$hash" "$STATE_FILE" 2>/dev/null; then
                branch_short=$(echo "$branch" | sed 's|origin/||')
                echo -e "  ${BOLD}${GREEN}⭐ NEW/UPDATED: $branch_short${RESET}"

                # Write to pending file for TCC session-start to detect
                echo "$branch_short $hash $(date +%Y-%m-%d_%H:%M:%S)" >> "$PENDING_FILE"

                # Desktop notification
                show_notification "$branch_short"

                # Voice alert - DISABLED
                # speak_alert "$branch_short"
            fi
        done

        echo ""
        echo -e "${BOLD}TCC Action:${RESET} Run ${CYAN}/works-ready${RESET} to validate and merge"
        echo -e "${BOLD}${GREEN}════════════════════════════════════════════════════════════${RESET}"
        echo ""

        play_alert
        echo "$CURRENT_STATE" > "$STATE_FILE"
    else
        echo -n "."  # Heartbeat
    fi
done
