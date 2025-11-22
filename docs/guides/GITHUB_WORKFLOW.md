# GitHub-Centric AI Collaboration Workflow

## 🎯 Overview

This framework uses **GitHub as the single source of truth** for AI-to-AI collaboration. All communication happens through the repository, making it work across any environment.

---

## 📋 The Correct Workflow

### **Phase 1: Online Claude Implements Feature**

In browser (you to me):
```
"Add a user authentication component to SimpleCP"
```

**I (OCC) will**:
1. Implement the feature
2. Create files, write tests
3. Commit to a feature branch
4. **Push to GitHub**

---

### **Phase 2: Local Claude Reviews & Publishes Report**

In terminal:
```bash
"work ready"
```

**Local Claude will**:
1. Pull latest changes from GitHub
2. Checkout the feature branch
3. Run validation rules
4. Create validation report in `.ai-framework/communications/reports/`
5. **Commit the report**
6. **Push to GitHub**
7. Tell you to notify OCC

---

### **Phase 3: User Notifies OCC**

In terminal:
```bash
cd /path/to/SimpleCP
./ai activate
```

**Script outputs**:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pull latest changes from GitHub branch feature/auth,
then check .ai-framework/communications/reports/AI_REPORT_20251119.md
and address all violations. When done, commit your fixes and
response to .ai-framework/communications/responses/ and push to GitHub.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

You **copy that green command** and paste it to me in browser.

---

### **Phase 4: OCC Fixes Issues via GitHub**

**I (OCC) will**:
1. **Pull latest changes from GitHub**
2. Read the validation report from `.ai-framework/communications/reports/`
3. Fix all violations
4. Create response file in `.ai-framework/communications/responses/`
5. **Commit all changes**
6. **Push to GitHub**
7. Confirm completion

---

### **Phase 5: Local Claude Re-validates & Merges**

In terminal:
```bash
"work ready"
```

**Local Claude will**:
1. **Pull latest changes from GitHub**
2. Read the response
3. Re-run validation
4. If clean: Merge to main and push
5. If issues remain: Create new report and repeat

---

## 🔄 Communication Flow Diagram

```
┌─────────────────┐                    ┌─────────────────┐
│  Local Claude   │                    │  Online Claude  │
│   (Terminal)    │                    │    (Browser)    │
└────────┬────────┘                    └────────┬────────┘
         │                                      │
         │ 1. Validate code                    │
         │ 2. Create report                    │
         │ 3. Commit + Push ─────────┐         │
         │                           │         │
         │                           ▼         │
         │                    ┌──────────────┐ │
         │                    │   GitHub     │ │
         │                    │ (Repository) │ │
         │                    └──────────────┘ │
         │                           │         │
         │                           │         │ 4. Pull latest
         │                           │         │ 5. Read report
         │                           │         │ 6. Fix issues
         │                           │         │ 7. Commit response
         │                           └─────────┤ 8. Push ────────┐
         │                                     │                 │
         │                                     │                 ▼
         │ 9. Pull latest ◄────────────────────┴──────────┌──────────────┐
         │ 10. Read response                              │   GitHub     │
         │ 11. Re-validate                                └──────────────┘
         │ 12. Merge if clean                                     ▲
         │ 13. Push ──────────────────────────────────────────────┘
         │
         ▼
```

---

## 📂 File Structure in GitHub

After a complete cycle, your GitHub repo will have:

```
your-project/
├── src/
│   └── [your code changes]
├── tests/
│   └── [your test changes]
└── .ai-framework/
    └── communications/
        ├── reports/
        │   └── AI_REPORT_20251119_143022.md     ← Local Claude
        └── responses/
            └── AI_RESPONSE_20251119_150134.md   ← Online Claude
```

All visible in GitHub commit history! ✅

---

## 🎯 Key Principles

### 1. **GitHub is the Source of Truth**
- Both AIs read/write through GitHub
- No local-only files
- Everything version controlled

### 2. **Commit Everything**
- Reports get committed
- Responses get committed
- All changes get committed

### 3. **Always Pull First**
- Before reading reports: `git pull`
- Before writing responses: `git pull`
- Before re-validating: `git pull`

### 4. **Always Push After**
- After creating report: `git push`
- After fixing issues: `git push`
- After merging: `git push`

---

## 💡 Why This Works Better

### **Old Approach** (Filesystem-based)
❌ Both AIs need access to same files
❌ Doesn't work across machines
❌ No version history
❌ Hard to audit

### **New Approach** (GitHub-based)
✅ Works across any environment
✅ Local machine ↔ Cloud ↔ Different computers
✅ Complete version history
✅ Easy to audit in GitHub
✅ Natural collaboration workflow

---

## 🚀 Example Session

```bash
# ========================================
# You in Browser → Online Claude
# ========================================
"Implement user login component in SimpleCP"

# OCC: ✅ Implemented! Committed to feature/login branch
# OCC: ✅ Pushed to GitHub

# ========================================
# You in Terminal → Local Claude
# ========================================
$ cd ~/SimpleCP
$ "work ready"

# TCC: 🔍 Pulling from GitHub...
# TCC: 📋 Found feature/login branch
# TCC: ✅ Running validation...
# TCC: ❌ Found 2 violations:
#      - LoginForm.tsx exceeds 150 lines (175 found)
#      - Missing tests for LoginForm component
# TCC: 📝 Created report: AI_REPORT_20251119_143022.md
# TCC: ✅ Committed and pushed to GitHub
# TCC: 💬 Run './ai activate' to notify OCC

$ ./ai activate

# Script shows:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Pull latest changes from GitHub branch feature/login,
# then check .ai-framework/communications/reports/AI_REPORT_20251119_143022.md
# and address all violations. When done, commit your fixes and
# response to .ai-framework/communications/responses/ and push to GitHub.
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ========================================
# You copy/paste to Browser → Online Claude
# ========================================
"Pull latest changes from GitHub branch feature/login,
then check .ai-framework/communications/reports/AI_REPORT_20251119_143022.md
and address all violations..."

# OCC: 🔄 Pulling from GitHub...
# OCC: 📄 Read report: AI_REPORT_20251119_143022.md
# OCC: 🔧 Fixing violations:
#      1. Split LoginForm.tsx into 3 components (now under 150 lines each)
#      2. Added comprehensive tests (coverage: 92%)
# OCC: 📝 Created response: AI_RESPONSE_20251119_150134.md
# OCC: ✅ Committed all changes
# OCC: ✅ Pushed to GitHub
# OCC: 🎉 All violations addressed!

# ========================================
# You in Terminal → Local Claude
# ========================================
$ "work ready"

# TCC: 🔄 Pulling from GitHub...
# TCC: 📬 Found response: AI_RESPONSE_20251119_150134.md
# TCC: ✅ Re-running validation...
# TCC: ✅ All checks passed!
# TCC: 🔀 Merging feature/login to main
# TCC: ✅ Pushed to GitHub
# TCC: 🎉 Done!
```

---

## 🎯 Quick Reference

### **Local Claude Commands**
```bash
"work ready"           # Validate, create report, push to GitHub
```

### **User Commands**
```bash
./ai activate         # Get OCC notification command
./ai status          # Check for reports/responses
```

### **What OCC Does** (when you paste the command)
1. Pull from GitHub
2. Read report
3. Fix issues
4. Commit response
5. Push to GitHub

---

## ✅ Success Checklist

- [ ] Local Claude commits & pushes reports
- [ ] OCC pulls before reading reports
- [ ] OCC commits & pushes responses
- [ ] Local Claude pulls before re-validating
- [ ] All communication visible in GitHub
- [ ] Complete audit trail in git history

---

**This is the correct workflow!** 🎉

Everything flows through GitHub, making it work universally across any environment.
