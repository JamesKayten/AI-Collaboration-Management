#!/bin/bash
# SessionStart hook - sync repo and provide context

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
REPO_NAME=$(basename "$REPO_ROOT" 2>/dev/null || echo "UNKNOWN")

cd "$REPO_ROOT" || exit 1

# Sync with GitHub
git fetch origin --quiet 2>/dev/null
git pull origin main --quiet 2>/dev/null

# Get current state
LOCAL_HASH=$(git rev-parse HEAD 2>/dev/null | cut -c1-7)
BRANCH=$(git branch --show-current 2>/dev/null || echo "main")

# Detect role
if [[ -f "$REPO_ROOT/.claude/role.local" ]]; then
    ROLE=$(cat "$REPO_ROOT/.claude/role.local" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
else
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ROLE="TCC"
    else
        ROLE="OCC"
    fi
fi

# Check for OCC branches
OCC_BRANCHES=$(git branch -r 2>/dev/null | grep "origin/claude/" | grep -v HEAD | wc -l | tr -d ' ')

# Write state file
cat > "$REPO_ROOT/.claude/session-state.md" << EOF
# Session Context

- **Repo:** $REPO_NAME
- **Branch:** $BRANCH
- **Role:** $ROLE
- **Commit:** $LOCAL_HASH
- **OCC branches pending:** $OCC_BRANCHES
EOF

exit 0
