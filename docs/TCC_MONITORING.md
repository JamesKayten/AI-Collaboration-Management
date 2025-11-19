# TCC Monitor Script

**Purpose**: Terminal Claude Code monitors AICH framework for OCC notifications

## What TCC Should Do

When you (TCC) see a notification file like `WORK_READY_FOR_VALIDATION.md`, you should:

### 1. Automatic Check
```bash
# TCC monitors .ai-framework/communications/updates/
# When new file appears, automatically:
git fetch
git checkout [branch-from-notification]
git pull
```

### 2. Run Validation
```bash
# Execute validation per VALIDATION_RULES.md
# Check file sizes, test coverage, code quality
```

### 3. Decision Point

**If All Checks Pass ✅**:
```bash
git checkout main
git merge [feature-branch]
git push origin main
# Delete notification file
rm .ai-framework/communications/updates/WORK_READY_FOR_VALIDATION.md
git add .
git commit -m "Merged [feature-branch] - all validations passed"
git push
```

**If Issues Found ❌**:
```bash
# Create detailed report
cat > .ai-framework/communications/reports/AI_REPORT_[TIMESTAMP].md << EOF
# Validation Report

**Status**: ❌ Issues Found
**Branch**: [branch-name]

## Violations

1. [Violation details]
2. [Violation details]

## Required Fixes

- [ ] Fix 1
- [ ] Fix 2

## Next Steps

OCC should address these violations and create response in
.ai-framework/communications/responses/
EOF

git add .
git commit -m "Validation failed - created report for OCC"
git push
```

### 4. User Notification

TCC tells user:
```
✅ "Validation complete - merged to main"
OR
❌ "Validation failed - report created for OCC"
   "Run './ai activate' to notify OCC"
```

---

## Monitoring Commands

### Check for OCC Notifications
```bash
ls -la .ai-framework/communications/updates/
```

### Process Notification
```bash
# Read the notification
cat .ai-framework/communications/updates/WORK_READY_*.md

# Extract branch name
BRANCH=$(grep "Branch:" .ai-framework/communications/updates/WORK_READY_*.md | cut -d' ' -f2)

# Validate
git checkout $BRANCH
# ... run validation ...
```

### Clean Up After Merge
```bash
# Remove notification after successful merge
rm .ai-framework/communications/updates/WORK_READY_*.md
```

---

## Automation Potential

This could be automated with:
- Git hooks (post-receive hook on server)
- GitHub Actions (on push, check for notification files)
- Cron job (TCC checks every N minutes)
- File watcher (inotify on Linux)

For now, TCC manually checks when user runs "work ready"
