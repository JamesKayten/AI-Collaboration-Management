#!/bin/bash
# SessionStart hook - forces context awareness and shows board status

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
REPO_NAME=$(basename "$REPO_ROOT" 2>/dev/null || echo "UNKNOWN")
BRANCH=$(git branch --show-current 2>/dev/null || echo "UNKNOWN")
BOARD_FILE="$REPO_ROOT/docs/BOARD.md"

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
