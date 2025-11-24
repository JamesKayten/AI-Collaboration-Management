#!/bin/bash
# watch-board.sh - Polls GitHub for BOARD.md changes and plays audio alert
#
# Usage: ./scripts/watch-board.sh [interval_seconds]
# Default interval: 30 seconds

INTERVAL=${1:-30}
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
BOARD_FILE="docs/BOARD.md"

# Audio alert function (cross-platform)
play_alert() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - use system sound
        afplay /System/Library/Sounds/Ping.aiff 2>/dev/null &
        # Play twice for emphasis
        sleep 0.3
        afplay /System/Library/Sounds/Ping.aiff 2>/dev/null &
    elif command -v paplay &>/dev/null; then
        # Linux with PulseAudio
        paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null &
    elif command -v aplay &>/dev/null; then
        # Linux with ALSA
        aplay /usr/share/sounds/alsa/Front_Center.wav 2>/dev/null &
    else
        # Fallback: terminal bell
        echo -e "\a"
    fi
}

echo "=================================="
echo "BOARD WATCHER - AI-Collaboration-Management"
echo "=================================="
echo "Polling GitHub every ${INTERVAL}s for BOARD.md changes"
echo "Press Ctrl+C to stop"
echo ""

cd "$REPO_ROOT" || exit 1

# Get initial state
git fetch origin main --quiet 2>/dev/null
LAST_HASH=$(git rev-parse origin/main:$BOARD_FILE 2>/dev/null)

while true; do
    sleep "$INTERVAL"

    # Fetch latest from GitHub
    if ! git fetch origin main --quiet 2>/dev/null; then
        echo "[$(date +%H:%M:%S)] ⚠️  Network error - retrying..."
        continue
    fi

    # Check if board changed
    CURRENT_HASH=$(git rev-parse origin/main:$BOARD_FILE 2>/dev/null)

    if [[ "$CURRENT_HASH" != "$LAST_HASH" ]]; then
        echo ""
        echo "🔔 [$(date +%H:%M:%S)] BOARD.MD CHANGED!"
        echo "   Run 'git pull origin main' to see updates"
        echo ""
        play_alert
        LAST_HASH="$CURRENT_HASH"
    else
        echo -n "."  # Heartbeat indicator
    fi
done
