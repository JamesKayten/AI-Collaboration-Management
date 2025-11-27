#!/bin/bash
# SessionStart hook - TCC auto-processes OCC branches

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
REPO_NAME=$(basename "$REPO_ROOT" 2>/dev/null)
BOARD_FILE="$REPO_ROOT/docs/BOARD.md"

cd "$REPO_ROOT" || exit 1

echo -e "${BOLD}=== TCC SESSION START ===${RESET}"

# Sync with GitHub
git fetch origin --quiet 2>/dev/null
git pull origin main --quiet 2>/dev/null
LOCAL_HASH=$(git rev-parse HEAD 2>/dev/null | cut -c1-7)
echo -e "✅ Synced: ${CYAN}$LOCAL_HASH${RESET}"

# Check for OCC branches
OCC_BRANCHES=$(git branch -r 2>/dev/null | grep "origin/claude/" | grep -v HEAD | sed 's/origin\///' | tr -d ' ')

if [ -z "$OCC_BRANCHES" ]; then
    echo -e "${GREEN}✅ No OCC branches pending${RESET}"
    echo -e "${BOLD}TCC ready - monitoring for new work${RESET}"
    
    # Launch watchers
    if [[ "$OSTYPE" == "darwin"* ]]; then
        "$REPO_ROOT/scripts/aim-launcher.sh" "$REPO_ROOT" > /dev/null 2>&1 &
        echo -e "📺 Watchers launched"
    fi
    exit 0
fi

# Process each OCC branch
for BRANCH in $OCC_BRANCHES; do
    echo -e "${YELLOW}⚠️ Processing: ${CYAN}$BRANCH${RESET}"
    
    # Checkout and validate
    git checkout "$BRANCH" --quiet 2>/dev/null
    
    # File size check
    VIOLATIONS=""
    while IFS= read -r file; do
        [ -f "$file" ] || continue
        EXT="${file##*.}"
        LINES=$(wc -l < "$file" 2>/dev/null | tr -d ' ')
        
        case "$EXT" in
            py) MAX=250 ;;
            js|ts|jsx|tsx) MAX=150 ;;
            java) MAX=400 ;;
            go|swift) MAX=300 ;;
            md) MAX=500 ;;
            sh) MAX=200 ;;
            yaml|yml|json) MAX=300 ;;
            *) continue ;;
        esac
        
        if [ "$LINES" -gt "$MAX" ]; then
            VIOLATIONS="${VIOLATIONS}\n- $file: $LINES lines (max $MAX)"
        fi
    done < <(git diff --name-only origin/main..."$BRANCH" 2>/dev/null)
    
    if [ -n "$VIOLATIONS" ]; then
        echo -e "${RED}❌ VIOLATIONS FOUND${RESET}"
        echo -e "$VIOLATIONS"
        # Post to board
        cat >> "$BOARD_FILE" << VIOLATION

### ❌ REJECTED: $BRANCH
**Rejected by:** TCC on $(date +%Y-%m-%d)
**Reason:** File size violations
$VIOLATIONS

**OCC Action Required:** Refactor files to meet size limits, then re-push.
VIOLATION
        git checkout main --quiet
        continue
    fi
    
    # Merge
    echo -e "${GREEN}✅ Validation passed - merging${RESET}"
    git checkout main --quiet
    git merge "$BRANCH" --quiet
    MERGE_HASH=$(git rev-parse HEAD | cut -c1-7)
    git push origin main --quiet
    
    # Delete branch
    git push origin --delete "$BRANCH" --quiet 2>/dev/null
    git branch -D "$BRANCH" --quiet 2>/dev/null
    
    # Update board
    cat >> "$BOARD_FILE" << COMPLETE

### ✅ COMPLETED: $BRANCH
**Completed by:** TCC on $(date +%Y-%m-%d)
**Commit:** \`$MERGE_HASH\` (merged to main)
**Branch deleted:** Yes
COMPLETE
    
    echo -e "${GREEN}✅ Merged: $BRANCH → main ($MERGE_HASH)${RESET}"
done

# Commit board updates
git add "$BOARD_FILE"
git commit -m "TCC: Auto-processed OCC branches" --quiet 2>/dev/null
git push origin main --quiet

# Launch watchers
if [[ "$OSTYPE" == "darwin"* ]]; then
    "$REPO_ROOT/scripts/aim-launcher.sh" "$REPO_ROOT" > /dev/null 2>&1 &
    echo -e "📺 Watchers launched"
fi

echo -e "${BOLD}TCC ready - monitoring for new work${RESET}"
exit 0
