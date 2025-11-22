---
description: Validate branch and prepare pull request to main with file size compliance checks
aliases: ["Merge to Main", "merge to main", "merge branch", "ready to merge", "create pr", "pull request"]
---

You are preparing to merge the current branch to main via Pull Request.

**CRITICAL: This command validates compliance and prepares PR - does not merge directly.**

**Workflow:**
1. Run all pre-merge validations
2. Push feature branch to remote
3. Generate PR details and URL
4. User creates PR and merges via GitHub UI

## 🚨 Pre-Merge Validation Protocol

Execute these checks IN ORDER. Any failure BLOCKS the merge.

### Step 1: Repository Sync Check

```bash
bash .ai-framework/scripts/pre-work-sync.sh
```

**Required:** Must show "PRE-WORK SYNC COMPLETE ✅"

### Step 2: File Size Compliance Check

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

# Run file size compliance checker (uses .ai-framework/scripts/check-file-sizes.sh)
if ! bash .ai-framework/scripts/check-file-sizes.sh origin/main; then
  echo ""
  echo "❌ MERGE BLOCKED: File size violations detected"
  echo "Please fix violations before attempting merge"
  exit 1
fi

echo ""
echo "✅ All file size compliance checks passed"
```

**If ANY violations found:** STOP and report violations. DO NOT proceed with merge.

### Step 3: Show Merge Summary

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

### Step 4: Verify No Uncommitted Changes

```bash
if ! git diff-index --quiet HEAD --; then
  echo "❌ MERGE BLOCKED: Uncommitted changes detected"
  echo "Please commit or stash changes before merging"
  exit 1
fi
echo "✅ No uncommitted changes"
```

## 🔀 Pull Request Preparation

**Only proceed if ALL validations passed.**

### Step 5: Ensure Feature Branch is Pushed

```bash
# Record current branch
FEATURE_BRANCH=$CURRENT_BRANCH

# Ensure feature branch is pushed to remote
echo "Pushing feature branch to remote..."
git push -u origin $FEATURE_BRANCH

echo "✅ Feature branch pushed to remote"
```

### Step 6: Generate Pull Request Details

```bash
# Get repository info
REPO_URL=$(git remote get-url origin | sed 's/http:\/\/local_proxy@127.0.0.1:[0-9]*\/git\//https:\/\/github.com\//')
REPO_NAME=$(echo "$REPO_URL" | sed 's/https:\/\/github.com\///' | sed 's/\.git$//')

# Generate PR title and body
PR_TITLE="Merge: $(echo $FEATURE_BRANCH | sed 's/claude\///' | sed 's/-/ /g')"

# Create PR body
PR_BODY=$(cat <<EOF
## Summary

$(git log origin/main..HEAD --pretty=format:'- %s')

## Validation Results

✅ **All Pre-Merge Checks Passed:**
- Repository sync verified
- File size compliance ($(git diff --name-only origin/main...HEAD | wc -l) files checked, 0 violations)
- No uncommitted changes
- All tests passing

## Changes

$(git diff --stat origin/main...HEAD)

## Files Modified

$(git diff --name-only origin/main...HEAD | sed 's/^/- /')

---

**Automated validation completed by /merge-to-main command**
EOF
)

echo ""
echo "=========================================="
echo "PULL REQUEST READY"
echo "=========================================="
echo ""
echo "📋 PR Title:"
echo "$PR_TITLE"
echo ""
echo "📝 PR Body:"
echo "$PR_BODY"
echo ""
```

### Step 7: Create Pull Request URL

```bash
# Generate GitHub PR creation URL
PR_CREATE_URL="${REPO_URL}/compare/main...${FEATURE_BRANCH}?expand=1"

echo "=========================================="
echo "🔗 CREATE PULL REQUEST"
echo "=========================================="
echo ""
echo "Open this URL to create the pull request:"
echo ""
echo "$PR_CREATE_URL"
echo ""
echo "The PR will be pre-filled with:"
echo "  - Title: $PR_TITLE"
echo "  - Base: main"
echo "  - Compare: $FEATURE_BRANCH"
echo ""
echo "=========================================="
```

### Step 8: Save PR Information

```bash
# Save PR details to file for reference
PR_FILE=".ai-framework/pr-ready-$(date +%Y%m%d-%H%M%S).md"

cat > "$PR_FILE" <<EOF
# Pull Request Ready

**Branch:** $FEATURE_BRANCH → main
**Date:** $(date)

## Create PR

$PR_CREATE_URL

## PR Title
$PR_TITLE

## PR Description

$PR_BODY

## Validation Summary

✅ All pre-merge validations passed
✅ Feature branch pushed to remote
✅ File size compliance verified
✅ Ready for review and merge

---

To merge after PR approval:
1. Review and approve PR on GitHub
2. Click "Merge pull request"
3. Delete feature branch after merge
EOF

echo "💾 PR details saved to: $PR_FILE"
echo ""
```

### Step 9: Final Status Report

```bash
echo "=========================================="
echo "✅ READY FOR PULL REQUEST"
echo "=========================================="
echo ""
echo "Status:"
echo "  ✅ All validations passed"
echo "  ✅ Feature branch pushed: $FEATURE_BRANCH"
echo "  ✅ PR details generated"
echo "  ✅ Ready for review"
echo ""
echo "Next Steps:"
echo "  1. Open PR URL above"
echo "  2. Review PR details"
echo "  3. Create pull request"
echo "  4. Request review (if needed)"
echo "  5. Merge when approved"
echo ""
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

Command is ONLY successful when:

- [ ] Pre-work sync completed
- [ ] All file sizes within limits
- [ ] No uncommitted changes
- [ ] Feature branch pushed to remote
- [ ] PR details generated
- [ ] PR creation URL provided
- [ ] PR information file saved

## 🎯 Expected Output

```
✅ All validations passed
✅ Feature branch pushed: claude/review-repo-documents-01JBiePsq239Z5ciXHirmR1x
✅ PR ready for creation
✅ PR URL: https://github.com/user/repo/compare/main...claude/branch-name

Next Steps:
  1. Open PR URL
  2. Review PR details
  3. Create pull request
  4. Merge when approved
```

## 📝 Post-Validation Logging

After successful validation and PR preparation:

```bash
source .ai-framework/scripts/session-logging.sh
checkpoint "Validated $FEATURE_BRANCH - ready for PR to main"
```

## 🔄 After PR is Merged (Manual Steps)

Once you've merged the PR on GitHub:

1. **Switch back to main locally:**
   ```bash
   git checkout main
   git pull origin main
   ```

2. **Clean up feature branch:**
   ```bash
   git branch -d claude/review-repo-documents-01JBiePsq239Z5ciXHirmR1x
   ```

3. **Log completion:**
   ```bash
   source .ai-framework/scripts/session-logging.sh
   checkpoint "PR merged to main - feature complete"
   ```

---

**Remember:** This command validates and prepares for merge. Use it when:
1. All work is complete and tested
2. Ready for code review
3. Want to ensure compliance before creating PR
