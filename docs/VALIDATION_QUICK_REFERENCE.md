# Validation Framework - Quick Reference Guide

**Fast commands for checking repository quality and AI work validation**

---

## 🚀 Quick Start

### Run All Validation Tests
```bash
cd /home/user/AI-Collaboration-Management
./scripts/validation/run_all_tests.sh
```

**What it does:**
- Runs all 3 test suites
- Generates detailed report
- Shows pass/fail with colors
- Creates `VALIDATION_REPORT.md`

**When to use:**
- Before pushing changes
- After AI makes modifications
- When something feels broken
- Daily quality check

---

## 📋 Individual Test Commands

### Test 1: Repository Structure
```bash
./scripts/validation/test_repository_structure.sh
```

**Checks:**
- ✅ Core directories exist (docs/, scripts/, framework/)
- ✅ Files in correct locations
- ✅ Scripts are executable
- ✅ Old files removed from root
- ✅ Clean organization

**Use when:**
- Files were moved or reorganized
- New directories added
- Checking if structure is correct

---

### Test 2: Documentation Integrity
```bash
./scripts/validation/test_documentation_integrity.sh
```

**Checks:**
- ✅ README links work
- ✅ Documentation cross-references valid
- ✅ Technical information accurate
- ✅ Port numbers correct
- ✅ Script paths updated

**Use when:**
- Documentation was updated
- Links might be broken
- Files were renamed/moved

---

### Test 3: Git & Sync Status
```bash
./scripts/validation/test_git_status.sh
```

**Checks:**
- ✅ Repository initialized
- ✅ Working tree clean
- ✅ Recent commits exist
- ✅ Sync scripts present
- ✅ AICM integration working

**Use when:**
- Before committing
- Checking git status
- Verifying AICM sync setup

---

## 📊 View Reports

### View Latest Validation Report
```bash
cat VALIDATION_REPORT.md
```

**Or use your editor:**
```bash
# VS Code
code VALIDATION_REPORT.md

# macOS
open VALIDATION_REPORT.md

# Less (scrollable)
less VALIDATION_REPORT.md
```

### View Project Status
```bash
cat docs/BOARD.md
cat docs/TASKS.md
```

---

## 🎯 Common Workflows

### Workflow 1: Before Pushing Changes

```bash
# 1. Run validation
./scripts/validation/run_all_tests.sh

# 2. Check if passed
cat VALIDATION_REPORT.md | grep "Verdict"

# 3. If errors = 0, push
git push origin your-branch
```

---

### Workflow 2: After AI Makes Changes

```bash
# 1. Let AI finish work
# 2. Run validation immediately
./scripts/validation/run_all_tests.sh

# 3. Check for errors
cat VALIDATION_REPORT.md

# 4. If failed, ask AI to fix issues mentioned in report
# 5. Re-run validation
./scripts/validation/run_all_tests.sh
```

---

### Workflow 3: Daily Quality Check

```bash
# Morning check
cd /home/user/AI-Collaboration-Management
cat docs/BOARD.md                          # See status
./scripts/validation/run_all_tests.sh     # Validate
git status                                 # Check uncommitted work
```

---

### Workflow 4: TCC Board Check

**Just say to TCC:**
```
Check the board
```

**Or manually:**
```bash
cat docs/BOARD.md
cat docs/TASKS.md
git status
# If changes exist:
git add .
git commit -m "Update board status"
git push
```

---

## 🔍 Troubleshooting Commands

### Check What Changed
```bash
git status
git diff
git log --oneline -5
```

### Find Broken Files
```bash
# Find files not in correct locations
find . -maxdepth 1 -name "BOARD.md"  # Should be empty (file should be in docs/)
find . -maxdepth 1 -name "*.md" -type f  # Should only be README.md
```

### Verify Directory Structure
```bash
ls -la docs/
ls -la scripts/
ls -la framework/
```

### Check Script Permissions
```bash
ls -la scripts/validation/
# All should have 'x' permission (executable)
```

### Fix Script Permissions
```bash
chmod +x scripts/validation/*.sh
chmod +x scripts/utilities/*
```

---

## 🎨 Understanding Output Colors

When you run validation tests:

**Green (✓):**
```
✓ All tests passed!
```
→ Everything is good. Safe to push.

**Yellow (⚠):**
```
⚠ Tests passed with warnings
Warnings: 18
```
→ Minor issues. Usually safe to push if errors = 0.

**Red (✗):**
```
✗ Tests failed with 5 errors
```
→ **DO NOT PUSH!** Fix errors first.

---

## 📈 Interpreting Results

### Perfect Result
```
Tests Passed:    3
Tests Failed:    0
Total Errors:    0
Total Warnings:  0

Status: 🟢 PRODUCTION READY
```
**Action:** Push with confidence!

### Good Result (Minor Warnings)
```
Tests Passed:    3
Tests Failed:    0
Total Errors:    0
Total Warnings:  18

Status: 🟡 READY WITH MINOR ISSUES
```
**Action:** Review warnings in `VALIDATION_REPORT.md`. Usually broken links in old docs (non-critical). Safe to push.

### Bad Result (Errors Detected)
```
Tests Passed:    1
Tests Failed:    2
Total Errors:    5
Total Warnings:  10

Status: 🔴 NOT READY - REQUIRES FIXES
```
**Action:**
1. Read `VALIDATION_REPORT.md`
2. Find the 5 errors listed
3. Fix each one
4. Re-run validation
5. Only push when errors = 0

---

## 🏢 Repository-Specific Commands

### For AI-Collaboration-Management (AICM)
```bash
cd /home/user/AI-Collaboration-Management
./scripts/validation/run_all_tests.sh
cat VALIDATION_REPORT.md
cat docs/BOARD.md
```

### For SimpleCP
```bash
cd /home/user/SimpleCP
./scripts/validation/run_all_tests.sh
cat VALIDATION_REPORT.md
cat docs/BOARD.md
```

**Both repos have identical validation systems!**

---

## 🔧 Advanced Usage

### Run Tests Silently (No Output)
```bash
./scripts/validation/run_all_tests.sh > /dev/null 2>&1
echo $?  # 0 = passed, 1 = failed
```

### Get Just The Summary
```bash
./scripts/validation/run_all_tests.sh 2>&1 | tail -20
```

### Save Output to File
```bash
./scripts/validation/run_all_tests.sh > validation_output.txt 2>&1
cat validation_output.txt
```

### Run Tests in Background
```bash
./scripts/validation/run_all_tests.sh &
# Continue working
# Check when done:
cat VALIDATION_REPORT.md
```

---

## 📚 Related Documentation

**Full Explanation:**
- `docs/AI_MANAGEMENT_HIERARCHY.md` - How the 4-level system works

**Technical Details:**
- `scripts/validation/test_repository_structure.sh` - Structure test source
- `scripts/validation/test_documentation_integrity.sh` - Documentation test source
- `scripts/validation/test_git_status.sh` - Git test source
- `scripts/validation/run_all_tests.sh` - Master runner source

**Project Status:**
- `docs/BOARD.md` - Current project status
- `docs/TASKS.md` - Active tasks
- `VALIDATION_REPORT.md` - Latest test results (auto-generated)

---

## 🎯 One-Liner Cheat Sheet

```bash
# Quick validate
./scripts/validation/run_all_tests.sh && echo "✅ PASSED" || echo "❌ FAILED"

# Validate + view report
./scripts/validation/run_all_tests.sh && cat VALIDATION_REPORT.md

# Validate + show only verdict
./scripts/validation/run_all_tests.sh && grep -A 5 "Verdict" VALIDATION_REPORT.md

# Check if safe to push
./scripts/validation/run_all_tests.sh && grep "Total Errors" VALIDATION_REPORT.md

# Morning routine
cat docs/BOARD.md && ./scripts/validation/run_all_tests.sh && git status
```

---

## ⚡ Emergency Commands

### Something's Broken - Quick Diagnosis
```bash
# 1. Check structure
ls -la | head -20

# 2. Verify key files exist
ls docs/BOARD.md docs/TASKS.md

# 3. Check scripts work
ls -la scripts/validation/

# 4. Run tests
./scripts/validation/run_all_tests.sh

# 5. Read what failed
cat VALIDATION_REPORT.md | grep "FAILED" -A 10
```

### Reset to Clean State
```bash
# Check what changed
git status

# Discard all changes (DANGEROUS!)
git reset --hard HEAD

# Re-run validation
./scripts/validation/run_all_tests.sh
```

---

## 💡 Pro Tips

1. **Run validation BEFORE asking TCC to commit**
   ```bash
   ./scripts/validation/run_all_tests.sh
   # Only if passed: tell TCC to commit
   ```

2. **Alias for convenience** (add to ~/.bashrc or ~/.zshrc)
   ```bash
   alias aicm-validate='cd /home/user/AI-Collaboration-Management && ./scripts/validation/run_all_tests.sh'
   alias simplecp-validate='cd /home/user/SimpleCP && ./scripts/validation/run_all_tests.sh'
   ```

3. **Check validation before every push**
   ```bash
   # Create git hook (optional)
   echo '#!/bin/bash' > .git/hooks/pre-push
   echo './scripts/validation/run_all_tests.sh || exit 1' >> .git/hooks/pre-push
   chmod +x .git/hooks/pre-push
   ```

4. **Use validation as quality gate**
   - Errors = 0 → Push ✅
   - Errors > 0 → Fix first ❌

---

## 📞 Need Help?

**If validation fails and you don't know why:**

1. Read the full report:
   ```bash
   cat VALIDATION_REPORT.md
   ```

2. Look for "FAILED" sections with red ✗ marks

3. Find the specific error message (they're descriptive!)

4. Fix the issue mentioned

5. Re-run validation

**If you're stuck:** Check `docs/AI_MANAGEMENT_HIERARCHY.md` for full explanation.

---

**Last Updated:** 2025-11-24
**Version:** 1.0
**Framework:** AI Collaboration Management (AICM)
