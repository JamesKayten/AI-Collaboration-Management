#!/bin/bash
# SessionStart hook - Displays startup context and launches monitoring
# No longer needs to trigger auto-response (handled by session management)

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
REPO_NAME=$(basename "$REPO_ROOT" 2>/dev/null || echo "UNKNOWN")

cd "$REPO_ROOT" || exit 1

# Execute the session-start display script
"$REPO_ROOT/.claude/hooks/session-start-display.sh"