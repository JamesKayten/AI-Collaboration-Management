#!/bin/bash
# SessionStart hook - forces context awareness and shows board status

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
REPO_NAME=$(basename "$REPO_ROOT" 2>/dev/null || echo "UNKNOWN")
BRANCH=$(git branch --show-current 2>/dev/null || echo "UNKNOWN")
BOARD_FILE="$REPO_ROOT/docs/BOARD.md"
WATCHER_SCRIPT="$REPO_ROOT/scripts/watch-board.sh"
WATCHER_PID_FILE="/tmp/board-watcher-${REPO_NAME}.pid"

# Start board watcher in background (if not already running)
if [ -f "$WATCHER_SCRIPT" ]; then
    # Check if already running
    if [ -f "$WATCHER_PID_FILE" ] && kill -0 "$(cat "$WATCHER_PID_FILE")" 2>/dev/null; then
        echo "📡 Board watcher already running (PID: $(cat "$WATCHER_PID_FILE"))"
    else
        nohup "$WATCHER_SCRIPT" > /tmp/board-watcher.log 2>&1 &
        echo $! > "$WATCHER_PID_FILE"
        echo "📡 Board watcher started (PID: $!) - Audio alert on BOARD.md changes"
    fi
fi

cat <<EOF
================================================================================
SESSION START - MANDATORY CONTEXT
================================================================================

REPOSITORY: $REPO_NAME
BRANCH: $BRANCH
ROLE: Check if you are OCC (developer) or TCC (project manager)

CRITICAL RULES (from CLAUDE.md):
1. ALWAYS specify repository name in every message
2. ALWAYS specify branch name when discussing git operations
3. ALWAYS give completion reports when finishing tasks
4. NEVER say vague things like "two merges remain" without context

================================================================================
CURRENT BOARD STATUS ($REPO_NAME/docs/BOARD.md):
================================================================================
EOF

# Show board contents if it exists
if [ -f "$BOARD_FILE" ]; then
    cat "$BOARD_FILE"
else
    echo "No BOARD.md found at $BOARD_FILE"
fi

cat <<EOF

================================================================================
END OF BOARD - Proceed with your role (OCC or TCC)
================================================================================
EOF

exit 0
