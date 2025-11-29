---
description: Merge current branch to main with file size compliance and validation checks
aliases: ["Merge to Main", "merge to main", "merge branch", "ready to merge"]
---

You have been granted permission to merge the current branch to main.

**CRITICAL: This command includes mandatory file size compliance checks before merging.**

## 🚨 Pre-Merge Validation Protocol

Execute these checks IN ORDER. Any failure BLOCKS the merge.

### Step 1: File Size Compliance Check

**Default Limits (lines per file):**
- Python (`.py`): 250 lines
- JavaScript/TypeScript (`.js`, `.ts`, `.jsx`, `.tsx`): 150 lines
- Java (`.java`): 400 lines
- Go (`.go`): 300 lines
- Swift (`.swift`): 300 lines
- Markdown (`.md`): 500 lines
- Shell scripts (`.sh`): 200 lines
- YAML/JSON (`.yaml`, `.json`): 300 lines

**Commands:**
```bash
# Get current branch name
CURRENT_BRANCH=$(git branch --show-current)
echo "Checking file size compliance for branch: $CURRENT_BRANCH"
echo ""

# Run file size compliance checker
if ! ./scripts/tcc-file-compliance.sh main; then
  echo ""
  echo "❌ MERGE BLOCKED: File size violations detected"
  echo "Please fix violations before attempting merge"
  exit 1
fi

echo ""
echo "✅ All file size compliance checks passed"
```

**If ANY violations found:** STOP and report violations. DO NOT proceed with merge.

### Step 2: Show Merge Summary

```bash
echo "=== Merge Summary ==="
echo "Source Branch: $CURRENT_BRANCH"
echo "Target Branch: main"
echo ""
echo "Commits to be merged:"
git log origin/main..HEAD --oneline
echo ""
echo "File changes:"
git diff --stat origin/main...HEAD
```

### Step 3: Verify No Uncommitted Changes

```bash
if ! git diff-index --quiet HEAD --; then
  echo "❌ MERGE BLOCKED: Uncommitted changes detected"
  echo "Please commit or stash changes before merging"
  exit 1
fi
echo "✅ No uncommitted changes"
```

## 🔀 Merge Execution

**Only proceed if ALL validations passed.**

### Step 4: Execute Merge

```bash
# Record current branch for cleanup
FEATURE_BRANCH=$CURRENT_BRANCH

# Checkout main
git checkout main

# Pull latest main
git pull origin main

# Merge with no-ff to create merge commit
git merge --no-ff $FEATURE_BRANCH -m "Merge branch '$FEATURE_BRANCH'

$(git log origin/main..$FEATURE_BRANCH --pretty=format:'- %s' | head -10)

All validation checks passed:
- File size compliance verified
- Pre-work sync completed
- No uncommitted changes"

echo "✅ Merge completed locally"
```

### Step 5: Push to Remote

```bash
# Push merged main
git push origin main

echo "✅ Pushed to origin/main"
```

### Step 6: Verify Merge Success

```bash
# Verify local matches remote
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" = "$REMOTE" ]; then
  echo "✅ Merge verified: Local matches remote"
  echo "Commit: $LOCAL"
else
  echo "⚠️ WARNING: Local and remote differ"
  echo "Local:  $LOCAL"
  echo "Remote: $REMOTE"
fi
```

### Step 7: Clean Up Feature Branch

```bash
# Delete local feature branch
git branch -d $FEATURE_BRANCH
echo "✅ Deleted local branch: $FEATURE_BRANCH"

# Delete remote feature branch
git push origin --delete $FEATURE_BRANCH
echo "✅ Deleted remote branch: $FEATURE_BRANCH"
```

### Step 8: Final Verification

```bash
echo ""
echo "=========================================="
echo "MERGE TO MAIN COMPLETE"
echo "=========================================="
echo "✅ All validations passed"
echo "✅ Branch merged: $FEATURE_BRANCH → main"
echo "✅ Changes pushed to remote"
echo "✅ Feature branch deleted"
echo ""
git status
echo "=========================================="
```

## 🚫 Failure Handling

**If ANY step fails:**

1. **DO NOT proceed** with subsequent steps
2. **Show the error** with context
3. **Report to user:** "Merge blocked - [specific reason]"
4. **Remain on current branch**
5. **Wait for user guidance**

## 📊 Success Criteria

Merge is ONLY successful when:

- [ ] All file sizes within limits
- [ ] No uncommitted changes
- [ ] Merge completed without conflicts
- [ ] Pushed to origin/main successfully
- [ ] Local matches remote
- [ ] Feature branch deleted

## 🎯 Expected Output

```
✅ All validations passed
✅ Merged: claude/review-repo-documents-01JBiePsq239Z5ciXHirmR1x → main
✅ Pushed to origin/main
✅ Feature branch deleted
✅ Repository ready for next task
```

---

**Remember:** This command has merge authority. Use it responsibly and only when:
1. All work is complete and tested
2. All validations pass
3. User has confirmed merge is ready
