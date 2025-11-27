#!/bin/bash
# Works Ready Hook - Triggered when user says "works ready"
# Gathers validation info and outputs instructions for TCC

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
REPO_NAME=$(basename "$REPO_ROOT")
PENDING_FILE="/tmp/branch-watcher-${REPO_NAME}.pending"

cd "$REPO_ROOT" 2>/dev/null || exit 0

# Find OCC branch to validate
BRANCH=""
if [ -f "$PENDING_FILE" ] && [ -s "$PENDING_FILE" ]; then
    BRANCH=$(head -1 "$PENDING_FILE" | awk '{print $1}')
fi

if [ -z "$BRANCH" ]; then
    # Check for remote OCC branches
    git fetch origin --quiet 2>/dev/null
    CURRENT=$(git branch --show-current)
    BRANCH=$(git branch -r | grep 'origin/claude/' | grep -v "origin/$CURRENT" | head -1 | sed 's/.*origin\///' | xargs)
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════════════════"
echo "WORKS READY - AUTO-EXECUTE MODE"
echo "═══════════════════════════════════════════════════════════════════════════════"
echo ""

if [ -z "$BRANCH" ]; then
    echo "STATUS: No OCC branches found to merge."
    echo ""
    echo "INSTRUCTION: Report to user that there are no pending branches to validate."
    echo "Do NOT ask questions. Just report the status."
else
    echo "BRANCH TO PROCESS: $BRANCH"
    echo "REPOSITORY: $REPO_NAME"
    echo ""
    echo "INSTRUCTION: You are TCC. Execute ALL steps below WITHOUT asking for confirmation:"
    echo ""
    echo "1. Run: ./scripts/tcc-validate-branch.sh $BRANCH"
    echo "2. If validation passes, execute the merge commands shown"
    echo "3. Delete the merged branch (local and remote)"
    echo "4. Update docs/BOARD.md with completion record"
    echo "5. Commit and push board update"
    echo "6. Report completion to user"
    echo ""
    echo "DO NOT ASK QUESTIONS. DO NOT SHOW PLANS. JUST EXECUTE."
fi
echo "═══════════════════════════════════════════════════════════════════════════════"
