# TCC Workflow Guide - Enhanced with File Compliance

**Complete TCC workflow including automatic file size compliance checking**

---

## 🎯 **TCC Role & Responsibilities**

### **Primary Functions:**
1. **Board Checking** - Instant project status via "check the board"
2. **File Compliance** - Enforce file size limits before merges
3. **Testing & Validation** - Comprehensive project testing
4. **Communication** - Report findings to OCC via framework

### **Enhanced Workflow:**
- ✅ **Fast board checks** (3-5 seconds vs 30+ seconds)
- ✅ **Automatic file compliance** before any merge
- ✅ **Violation reporting** with actionable OCC instructions
- ✅ **Merge blocking** until compliance achieved

---

## ⚡ **TCC Commands (Updated)**

### **1. Fast Board Check (Recommended)**
```bash
curl -sSL https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/tcc-setup/tcc-board-check-fast.sh | bash -s REPO_URL
```
**Result:** Instant status in 3-5 seconds using GitHub API

### **2. Detailed Board Analysis**
```bash
curl -sSL https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/tcc-setup/tcc-board-check.sh | bash -s REPO_URL
```
**Result:** Complete analysis with full repository clone

### **3. File Size Compliance Check**
```bash
./tcc-setup/tcc-file-compliance.sh [target_branch]
```
**Result:** Validates all files against size limits, blocks merge if violations

### **4. Complete Pre-Merge Validation**
```bash
./tcc-setup/tcc-pre-merge-check.sh [target_branch]
```
**Result:** Full validation including compliance, conflicts, and framework checks

---

## 🔄 **Enhanced TCC Workflow**

### **Phase 1: Initial Board Check**
```
User: "TCC: Check the board for SimpleCP repository"

TCC Actions:
1. Clone repository (if needed)
2. Find BOARD.md
3. Execute FAST board check (3-5 seconds)
4. Get instant project status
5. Identify pending work
```

### **Phase 2: Pre-Merge Compliance**
```
Before any merge to main, TCC MUST run:
./tcc-setup/tcc-pre-merge-check.sh main

This automatically:
1. ✅ Checks file size compliance
2. ✅ Validates no uncommitted changes
3. ✅ Checks for merge conflicts
4. ✅ Verifies framework sync
5. 🚫 BLOCKS merge if any failures
```

### **Phase 3: Violation Reporting**
```
If file compliance fails:
1. TCC creates detailed violation report
2. Report saved to .ai-framework/communications/reports/
3. Report includes exact file paths, sizes, and refactoring instructions
4. OCC automatically discovers report on next session
5. Merge blocked until violations resolved
```

---

## 📋 **File Size Limits (Enforced by TCC)**

```
Python (.py):        250 lines
JavaScript (.js):    150 lines
TypeScript (.ts):    150 lines
JSX/TSX:             150 lines
Java (.java):        400 lines
Go (.go):            300 lines
Swift (.swift):      300 lines
Rust (.rs):          300 lines
C/C++ (.c/.cpp):     300/400 lines
Markdown (.md):      500 lines
Shell (.sh):         200 lines
YAML/JSON:           300 lines
CSS/SCSS:            200 lines
```

### **Enforcement Policy:**
- ❌ **MERGE BLOCKED** if any file exceeds limits
- 📝 **Violation report** created for OCC with refactoring instructions
- ✅ **Merge allowed** only after compliance achieved

---

## 🚨 **TCC Compliance Workflow**

### **When TCC Detects Violations:**

#### **1. Immediate Actions:**
```bash
# TCC runs (automatically before merge):
./tcc-setup/tcc-file-compliance.sh main

# If violations found:
❌ FILE SIZE COMPLIANCE: FAILED
🚫 MERGE BLOCKED until violations resolved
📝 Violation report: .ai-framework/communications/reports/TCC_FILE_VIOLATIONS_[timestamp].md
```

#### **2. Violation Report Contents:**
- **Exact file paths** with current vs max line counts
- **Overage calculations** (how many lines to remove)
- **Refactoring strategies** (split functions, extract modules, etc.)
- **Re-validation commands** for OCC to verify fixes
- **Success criteria** for merge approval

#### **3. OCC Notification Process:**
```
1. TCC creates violation report in framework communications
2. OCC discovers report when working with repository
3. OCC reads detailed refactoring instructions
4. OCC fixes violations and commits changes
5. OCC re-runs: ./tcc-setup/tcc-file-compliance.sh main
6. TCC validates fixes: ✅ FILE SIZE COMPLIANCE: PASSED
7. Merge approved and executed
```

---

## 🔧 **TCC Pre-Merge Checklist**

**Before ANY merge to main, TCC must verify:**

- [ ] ✅ **File compliance passed** - No oversized files
- [ ] ✅ **No uncommitted changes** - Clean working tree
- [ ] ✅ **No merge conflicts** - Clean merge possible
- [ ] ✅ **Framework sync verified** - All validations pass
- [ ] ✅ **Branch validation complete** - Target branch accessible

**Only if ALL checks pass → Merge approved**

---

## 📊 **TCC Reporting Standards**

### **Violation Reports Must Include:**
1. **Specific file paths** and exact line counts
2. **Actionable refactoring instructions**
3. **Success criteria** (exactly what needs to be achieved)
4. **Re-validation commands** for OCC to test fixes
5. **Merge approval process** (how to proceed after fixes)

### **Success Reports Must Include:**
1. **Compliance status confirmation**
2. **Files validated count**
3. **Merge approval statement**
4. **Next steps** (actual merge commands)

---

## 🎯 **TCC Best Practices**

### **Board Checking:**
- **Use fast check first** for quick status
- **Use detailed analysis** only when needed
- **Update status** after significant changes

### **Compliance Checking:**
- **Always run before merges** - No exceptions
- **Create detailed reports** for violations
- **Block merges** until compliance achieved
- **Re-validate** after OCC fixes

### **Communication:**
- **Use framework communications** for all reports
- **Be specific** in violation descriptions
- **Provide actionable** refactoring guidance
- **Confirm success** explicitly after fixes

---

## ⚡ **Quick Reference**

```bash
# Fast board check (recommended)
curl -sSL .../tcc-board-check-fast.sh | bash -s REPO_URL

# Pre-merge validation (required)
./tcc-setup/tcc-pre-merge-check.sh main

# File compliance only
./tcc-setup/tcc-file-compliance.sh main

# Emergency detailed analysis
curl -sSL .../tcc-board-check.sh | bash -s REPO_URL
```

---

**TCC Workflow Version:** 2.0 Enhanced
**Last Updated:** November 23, 2025
**Key Enhancement:** Automatic file size compliance with merge blocking