#!/bin/bash
# watch-branches.sh - Monitors GitHub for new/updated OCC branches
#
# Usage: ./scripts/watch-branches.sh [interval_seconds]
# Default interval: 30 seconds

INTERVAL=${1:-30}
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
REPO_NAME=$(basename "$REPO_ROOT" 2>/dev/null || echo "UNKNOWN")
BRANCH_PATTERN="claude/*"  # OCC branch naming convention
STATE_FILE="/tmp/branch-watcher-${REPO_NAME}.state"

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

echo "=================================="
echo "BRANCH WATCHER - $REPO_NAME"
echo "=================================="
echo "Monitoring for OCC branch activity (pattern: $BRANCH_PATTERN)"
echo "Polling every ${INTERVAL}s"
echo "Press Ctrl+C to stop"
echo ""

cd "$REPO_ROOT" || exit 1

# Get initial state of remote branches
git fetch origin --quiet 2>/dev/null
git for-each-ref --format='%(refname:short) %(objectname:short)' refs/remotes/origin/$BRANCH_PATTERN 2>/dev/null > "$STATE_FILE"

while true; do
    sleep "$INTERVAL"

    # Fetch latest from GitHub
    if ! git fetch origin --quiet 2>/dev/null; then
        echo "[$(date +%H:%M:%S)] ⚠️  Network error - retrying..."
        continue
    fi

    # Get current state of remote branches
    CURRENT_STATE=$(git for-each-ref --format='%(refname:short) %(objectname:short)' refs/remotes/origin/$BRANCH_PATTERN 2>/dev/null)
    PREVIOUS_STATE=$(cat "$STATE_FILE" 2>/dev/null)

    if [[ "$CURRENT_STATE" != "$PREVIOUS_STATE" ]]; then
        echo ""
        echo "🔔 [$(date +%H:%M:%S)] OCC BRANCH ACTIVITY DETECTED!"
        echo ""

        # Show what changed
        echo "Current branches:"
        echo "$CURRENT_STATE" | while read branch hash; do
            branch_short=$(echo "$branch" | sed 's|origin/||')
            echo "  → $branch_short ($hash)"
        done
        echo ""

        # Find new or updated branches
        echo "$CURRENT_STATE" | while read branch hash; do
            if ! grep -q "$hash" "$STATE_FILE" 2>/dev/null; then
                branch_short=$(echo "$branch" | sed 's|origin/||')
                echo "  ⭐ NEW/UPDATED: $branch_short"
            fi
        done

        echo ""
        echo "Run: git merge origin/<branch-name> to review"
        echo ""

        play_alert
        echo "$CURRENT_STATE" > "$STATE_FILE"
    else
        echo -n "."  # Heartbeat
    fi
done
