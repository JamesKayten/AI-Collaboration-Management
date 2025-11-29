#!/bin/bash
# Works Ready Hook - AUTO-EXECUTES validation and merge
# No longer just outputs instructions - actually does the work

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
    echo "═══════════════════════════════════════════════════════════════════════════════"
    exit 0
fi

echo "AUTO-EXECUTING: Processing $BRANCH" >&2
echo "" >&2

# Run validation
echo "Running validation..." >&2
VALIDATION_OUTPUT=$("$REPO_ROOT/scripts/tcc-validate-branch.sh" "$BRANCH" 2>&1)
VALIDATION_EXIT=$?

echo "$VALIDATION_OUTPUT" >&2

if echo "$VALIDATION_OUTPUT" | grep -q "RESULT: NOTHING TO MERGE\|already merged"; then
    # Already merged - just clean up
    echo "" >&2
    echo "✓ Branch already merged or no new commits" >&2

    # Remove from pending file
    if [ -f "$PENDING_FILE" ]; then
        grep -v "$BRANCH" "$PENDING_FILE" > "${PENDING_FILE}.tmp" 2>/dev/null || true
        mv "${PENDING_FILE}.tmp" "$PENDING_FILE" 2>/dev/null || true
    fi

    echo ""
    echo "AUTO-PROCESS RESULT: ALREADY_MERGED"
    echo "Branch: $BRANCH"
    echo "Status: Branch was already merged or has no new commits"
    echo "Action: Cleaned up pending list"
    echo "Report this to the user."

elif echo "$VALIDATION_OUTPUT" | grep -q "VALIDATION PASSED"; then
    # Validation passed - do the merge
    echo "" >&2
    echo "✓ Validation passed - merging..." >&2

    # Ensure on main
    git checkout main >&2 2>&1
    git pull origin main >&2 2>&1

    # Merge
    MERGE_OUTPUT=$(git merge --no-ff "origin/$BRANCH" -m "Auto-merge: $BRANCH" 2>&1)
    MERGE_EXIT=$?

    if [ $MERGE_EXIT -eq 0 ]; then
        # Push
        git push origin main >&2 2>&1
        MERGE_HASH=$(git rev-parse --short HEAD)

        # Delete remote branch
        git push origin --delete "$BRANCH" >&2 2>&1 || true

        # Remove from pending file
        if [ -f "$PENDING_FILE" ]; then
            grep -v "$BRANCH" "$PENDING_FILE" > "${PENDING_FILE}.tmp" 2>/dev/null || true
            mv "${PENDING_FILE}.tmp" "$PENDING_FILE" 2>/dev/null || true
        fi

        echo "" >&2
        echo "✓ AUTO-MERGE COMPLETE: $BRANCH → main ($MERGE_HASH)" >&2

        echo ""
        echo "AUTO-PROCESS RESULT: SUCCESS"
        echo "Branch: $BRANCH"
        echo "Merged: commit $MERGE_HASH"
        echo "Action: Validated, merged to main, deleted branch"
        echo "Report this completion to the user and update BOARD.md."
    else
        echo "" >&2
        echo "✗ Merge failed" >&2
        echo "$MERGE_OUTPUT" >&2

        echo ""
        echo "AUTO-PROCESS RESULT: MERGE_FAILED"
        echo "Branch: $BRANCH"
        echo "Error: $MERGE_OUTPUT"
        echo "Report this failure to the user."
    fi
else
    # Validation failed
    echo "" >&2
    echo "✗ Validation failed" >&2

    echo ""
    echo "AUTO-PROCESS RESULT: VALIDATION_FAILED"
    echo "Branch: $BRANCH"
    echo "Reason: Validation did not pass"
    echo "Report this failure to the user."
fi

echo "═══════════════════════════════════════════════════════════════════════════════"
