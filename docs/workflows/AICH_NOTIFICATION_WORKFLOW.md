# AICH Framework Workflow (Notification-Based)

## 🎯 Overview

The AI Collaboration Hub (AICH) Framework uses a **notification-based workflow** where:
- OCC notifies TCC when work is ready
- TCC validates and either merges OR creates error report
- User activates OCC with simple standard prompt
- OCC checks AICH for instructions

---

## 🔄 Complete Workflow

### **Step 1: OCC Implements Feature**

**User to OCC** (Browser):
```
"Add user authentication component to SimpleCP"
```

**OCC Actions**:
1. ✅ Implements the feature
2. ✅ Writes tests
3. ✅ Commits to feature branch (e.g., `feature/auth`)
4. ✅ **Creates notification**: `.ai-framework/communications/updates/WORK_READY_FOR_VALIDATION.md`
5. ✅ Pushes everything to GitHub

**Notification File Content**:
```markdown
# Work Ready for Validation

**Date**: 2025-11-19 15:30:00
**Branch**: feature/auth
**Implemented By**: Online Claude (OCC)

## What Was Implemented
- User authentication component
- Login form with validation
- Auth context provider
- Protected route wrapper

## Files Changed
- src/components/Auth/LoginForm.tsx (new)
- src/contexts/AuthContext.tsx (new)
- src/components/ProtectedRoute.tsx (new)
- tests/Auth/LoginForm.test.tsx (new)

## Tests Added
- LoginForm rendering and validation
- AuthContext state management
- Protected route access control

## Next Steps
TCC should validate and merge or report issues.
```

---

### **Step 2: TCC Monitors & Validates**

**User to TCC** (Terminal):
```
"work ready"
```

**TCC Actions**:
1. 🔍 Checks `.ai-framework/communications/updates/` for notifications
2. 📥 Sees `WORK_READY_FOR_VALIDATION.md`
3. 📥 Pulls from GitHub
4. 🌿 Checks out `feature/auth` branch
5. ✅ Runs validation checks
6. 📊 Makes decision...

**Decision A: All Checks Pass ✅**

TCC:
```bash
✅ All validations passed!
✅ Merging feature/auth to main
✅ Cleaning up notification
✅ Pushed to GitHub
🎉 Done!
```

**Decision B: Issues Found ❌**

TCC creates detailed report:
```markdown
# Validation Report

**Status**: ❌ Issues Found
**Branch**: feature/auth
**Date**: 2025-11-19 15:35:00

## Violations

### 1. File Size Exceeded
- **File**: `src/components/Auth/LoginForm.tsx`
- **Issue**: 187 lines (limit: 150)
- **Severity**: Error

### 2. Test Coverage Below Threshold
- **Coverage**: 78% (target: 85%)
- **Missing**: Error handling tests
- **Severity**: Error

## Required Fixes
- [ ] Split LoginForm into smaller components
- [ ] Add error handling tests
- [ ] Increase coverage to 85%+

## Next Steps
OCC should address these violations and create response in
.ai-framework/communications/responses/
```

TCC then:
```bash
❌ Validation failed
📝 Created report: AI_REPORT_20251119_153500.md
✅ Pushed to GitHub
💬 Run './ai activate' to notify OCC
```

---

### **Step 3: User Notifies OCC**

**User in Terminal**:
```bash
./ai activate
```

**Script Shows**:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Standard OCC Activation Prompt:

Check the AI Collaboration Framework in the repository
for latest instructions.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 Repository: JamesKayten/SimpleCP
🌿 Branch: feature/auth
📋 Latest Report: AI_REPORT_20251119_153500.md
```

**User Copies and Pastes to Browser OCC**:
```
Check the AI Collaboration Framework in the repository for latest instructions.
```

---

### **Step 4: OCC Reads & Responds**

**OCC Actions**:
1. 📥 Pulls latest from GitHub
2. 📂 Checks `.ai-framework/communications/`
3. 📄 Finds and reads `reports/AI_REPORT_20251119_153500.md`
4. 🔧 Fixes all violations:
   - Splits `LoginForm.tsx` into 3 components (each <150 lines)
   - Adds error handling tests
   - Achieves 92% coverage
5. 📝 Creates response: `.ai-framework/communications/responses/AI_RESPONSE_20251119_154200.md`
6. ✅ Commits all changes
7. ✅ Pushes to GitHub
8. 💬 Confirms to user: "Fixed all violations. TCC can re-validate."

**Response File Content**:
```markdown
# Response to Validation Report

**Date**: 2025-11-19 15:42:00
**Responding To**: AI_REPORT_20251119_153500.md
**Status**: ✅ All Violations Fixed

## Fixes Implemented

### 1. File Size - Fixed ✅
Split `LoginForm.tsx` into:
- `LoginForm.tsx` (75 lines) - main component
- `LoginFormFields.tsx` (45 lines) - form fields
- `LoginFormValidation.tsx` (40 lines) - validation logic

### 2. Test Coverage - Fixed ✅
Added tests:
- Error handling for invalid credentials
- Network failure scenarios
- Form validation edge cases
Coverage now: 92% (exceeds 85% target)

## Ready for Re-validation
TCC can now re-run "work ready" to validate fixes.
```

---

### **Step 5: TCC Re-validates**

**User to TCC** (Terminal):
```
"work ready"
```

**TCC Actions**:
1. 📥 Pulls from GitHub
2. 📬 Sees response file
3. ✅ Re-runs validation
4. 🎉 All checks pass!
5. 🔀 Merges `feature/auth` to `main`
6. 🗑️ Deletes notification and report files
7. ✅ Pushes to GitHub

```bash
✅ All validations passed!
✅ Merging feature/auth to main
✅ Cleaned up AICH framework
✅ Pushed to GitHub
🎉 Feature complete!
```

---

## 📂 AICH Framework File Structure

```
.ai-framework/
└── communications/
    ├── updates/
    │   └── WORK_READY_FOR_VALIDATION.md    ← OCC creates (Step 1)
    ├── reports/
    │   └── AI_REPORT_20251119_153500.md    ← TCC creates (Step 2)
    └── responses/
        └── AI_RESPONSE_20251119_154200.md  ← OCC creates (Step 4)
```

**Lifecycle**:
1. OCC creates notification → TCC processes
2. TCC creates report (if issues) → OCC reads
3. OCC creates response → TCC validates
4. TCC merges → Cleans up all AICH files

---

## 🎯 Key Principles

### 1. **Notification-Based**
- OCC explicitly notifies TCC when ready
- No ambiguity about when to validate

### 2. **GitHub as Source of Truth**
- All communication through GitHub
- Works across any environment

### 3. **Simple User Commands**
- User runs "work ready" in terminal
- User pastes one simple prompt to OCC
- That's it!

### 4. **Self-Cleaning**
- TCC deletes notification after processing
- TCC deletes reports after successful merge
- AICH framework stays clean

---

## ✅ Benefits Over Old Approach

**Old Way**:
- ❌ User manually tells TCC to check
- ❌ Complex project-specific prompts
- ❌ Files accumulate in AICH
- ❌ Unclear when OCC is done

**New Way**:
- ✅ OCC notifies TCC automatically
- ✅ One simple standard prompt
- ✅ Self-cleaning AICH framework
- ✅ Clear workflow states

---

## 🚀 Standard Prompts

### For TCC (Terminal)
```
"work ready"
```

### For OCC (Browser - after TCC validation)
```
Check the AI Collaboration Framework in the repository for latest instructions.
```

**That's it!** Two simple commands for the entire workflow.

---

This is the **notification-based AICH workflow** you described! 🎉
