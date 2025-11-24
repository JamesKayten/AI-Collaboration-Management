#!/bin/bash
# SessionStart hook - forces context awareness

REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" || echo "UNKNOWN")
BRANCH=$(git branch --show-current 2>/dev/null || echo "UNKNOWN")

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

Read CLAUDE.md and docs/BOARD.md before proceeding.

================================================================================
EOF

exit 0
