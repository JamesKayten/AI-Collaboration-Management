#!/bin/bash

# Auto Check Board - Zero Copy/Paste Workflow
# When user says "check the board", this script handles everything automatically

set -e

FRAMEWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Find latest OCC work
echo "🔍 Finding latest OCC work..."
LATEST_BRANCH=$(git for-each-ref --format='%(refname:short)' refs/remotes/origin/claude/ --sort=-committerdate | head -1)

if [ -z "$LATEST_BRANCH" ]; then
    echo "✅ No OCC work pending"
    exit 0
fi

echo "📋 Found: $LATEST_BRANCH"

# Check for new commits
NEW_COMMITS=$(git log main..${LATEST_BRANCH} --oneline)
if [ -z "$NEW_COMMITS" ]; then
    echo "✅ No new commits to merge"
    exit 0
fi

# Quick compliance check
echo "🔍 Checking compliance..."
git checkout ${LATEST_BRANCH} -q 2>/dev/null || git checkout ${LATEST_BRANCH#origin/} -q
./tcc-setup/tcc-file-compliance-simple.sh HEAD > /dev/null

if [ $? -eq 0 ]; then
    echo "✅ Compliance passed"

    # Merge automatically
    git checkout main -q
    git merge ${LATEST_BRANCH} --no-edit -q

    # Update board
    ./.ai-framework/tools/update-board-status.sh > /dev/null

    # Simple commit
    git add .ai-framework/CURRENT_BOARD_STATUS.md
    git commit -m "Auto-merge OCC work" -q
    git push -q

    echo "✅ Work merged automatically"
else
    echo "❌ Compliance failed - manual review required"
    exit 1
fi