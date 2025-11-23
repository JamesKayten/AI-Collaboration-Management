---
description: TCC validates OCC's completed work and reports results
aliases: ["Works Ready", "works ready", "validate fixes", "check fixes", "verify work"]
---

You are TCC (Terminal Claude Code). OCC has pushed fixes. Validate and integrate them.

**Complete Workflow:**

1. **Pull OCC's changes** from the feature branch
2. **Run all validation checks:**
   - File size limits (language-specific)
   - Code quality (Flake8, ESLint, SwiftLint, etc.)
   - Test coverage (if applicable)
   - Build verification (if applicable)
3. **If validation PASSES:**
   - Merge to main branch
   - **Update local working directory** (checkout main and pull)
   - Create `AI_REPORT_SUCCESS.md` confirming completion
   - Report: "✅ Repo and local files synced"
4. **If validation FAILS:**
   - Create new `AI_REPORT_[DATE].md` with remaining violations
   - Keep local on current branch
   - Report: "❌ Validation failed - see AI_REPORT"

**Example workflow:**

```bash
# 1. Pull OCC's changes
git fetch origin
BRANCH=$(git branch -r | grep "claude/" | head -1 | tr -d ' ')
git checkout -B temp-validate origin/${BRANCH}

# 2. Run validations (adapt to project type)
# Python:
find . -name "*.py" -exec wc -l {} \; | awk '$1 > 250 {print "VIOLATION: " $2}'
flake8 . --max-line-length=88 --exclude=venv,__pycache__

# Swift:
cd frontend && xcodebuild -scheme SimpleCP -destination 'platform=macOS' clean build

# JavaScript:
npm run lint && npm run build

# 3. If ALL validations pass:
git checkout main
git merge temp-validate --no-ff -m "Merge validated fixes from OCC"
git push origin main

# 4. CRITICAL: Update local working directory
# (So user can immediately test in Xcode/IDE)
git pull origin main

# Clean up temp branch
git branch -D temp-validate

# 5. Report success
echo "✅ Validated, merged to main, and synced local repository"
```

**IMPORTANT - Local Sync:**
After merging to main on GitHub, ALWAYS update the local working directory:
```bash
git checkout main
git pull origin main
```

This ensures the user's local files match GitHub, so they can:
- Open Xcode and see the latest code
- Run builds immediately
- Test the fixes without manual git commands

**Report Format:**

Success:
```
✅ Repo and local files synced
```

Detailed Success (if user asks for details):
```
✅ VALIDATION PASSED
- All checks completed successfully
- Merged to main branch
- Local repository synced
- Ready for testing in Xcode/IDE
```

Failure:
```
❌ VALIDATION FAILED
- [List specific violations]
- See AI_REPORT_[DATE].md for details
- Local kept on feature branch
- Waiting for OCC fixes
```

**Report to user:**
- On success: Simply "✅ Repo and local files synced"
- On failure: Detailed list of validation errors
