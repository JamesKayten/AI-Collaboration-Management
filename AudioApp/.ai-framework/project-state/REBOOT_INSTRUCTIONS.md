# Reboot Instructions for AI Collaboration Framework

**Emergency Recovery Documentation**
**Framework:** Avery's AI Collaboration Hack v1.0
**Last Updated:** November 18, 2025

---

## 🚨 **IMMEDIATE REBOOT PROTOCOL**

### **Step 1: Location and Context Recovery**
```bash
# Navigate to project directory
cd /Volumes/User_Smallfavor/Users/Smallfavor/Documents/ai-collaboration-test/

# Verify project structure
ls -la .ai-framework/

# Check current project state
cat .ai-framework/project-state/PROJECT_STATE.md
```

### **Step 2: Current Status Assessment**
```bash
# Check git status
git status
git log --oneline -5

# Verify AI framework integrity
tree .ai-framework/ || ls -la .ai-framework/

# Check for pending AI communications
ls .ai-framework/communications/reports/
ls .ai-framework/communications/responses/
```

### **Step 3: Resume Point Identification**
**Read the PROJECT_STATE.md to determine:**
- ✅ **Completed phases**
- 🔄 **Current phase in progress**
- ❓ **Next steps required**
- 🧪 **Active tests or workflows**

---

## 📋 **QUICK STATUS COMMANDS**

### **Project Health Check:**
```bash
# Repository status
echo "=== REPOSITORY STATUS ==="
pwd
git status --porcelain
echo ""

# Framework structure
echo "=== FRAMEWORK STRUCTURE ==="
find .ai-framework -type f | head -10
echo ""

# Latest communications
echo "=== LATEST AI COMMUNICATIONS ==="
ls -lt .ai-framework/communications/reports/ | head -5
ls -lt .ai-framework/communications/responses/ | head -5
echo ""

# Source and test files
echo "=== PROJECT FILES ==="
ls src/
ls tests/
```

### **Active Test Identification:**
```bash
# Check for broken code awaiting fixes
find src/ -name "*.py" -exec python3 -m py_compile {} \; 2>&1 | head -5

# Check validation status
cd /Volumes/User_Smallfavor/Users/Smallfavor/Documents/ai-collaboration-test/
python3 -m flake8 src/ || echo "Style violations present"
python3 -m pytest tests/ || echo "Test failures present"
```

---

## 🔄 **COMMON RESUME SCENARIOS**

### **Scenario A: Mid-Validation Process**
**Indicators:** Reports in `reports/` but no corresponding responses
**Action:**
1. Read latest report in `.ai-framework/communications/reports/`
2. Continue with Online AI testing using browser Claude
3. Process fixes and complete validation cycle

### **Scenario B: Awaiting Online AI Response**
**Indicators:** Report created, waiting for Browser Claude fixes
**Action:**
1. Navigate to latest report: `cat .ai-framework/communications/reports/AI_REPORT_*.md`
2. Execute Browser Claude test protocol
3. Implement fixes and create response documentation

### **Scenario C: Post-Fix Validation**
**Indicators:** Responses present, need re-validation
**Action:**
1. Run Local AI validation: `"work ready"`
2. Verify all checks pass
3. Complete merge if successful

### **Scenario D: Fresh Framework Testing**
**Indicators:** Clean repository, ready for new test
**Action:**
1. Create test scenario or use existing broken code
2. Start new validation cycle
3. Generate fresh AI collaboration test

---

## 📂 **CRITICAL FILE LOCATIONS**

### **Project State Files:**
- **Main state:** `.ai-framework/project-state/PROJECT_STATE.md`
- **Reboot guide:** `.ai-framework/project-state/REBOOT_INSTRUCTIONS.md`
- **Framework config:** `.ai-framework/project-state/FRAMEWORK_CONFIG.md`

### **AI Communications:**
- **Reports:** `.ai-framework/communications/reports/AI_REPORT_*.md`
- **Responses:** `.ai-framework/communications/responses/AI_RESPONSE_*.md`
- **Updates:** `.ai-framework/communications/updates/AI_UPDATE_*.md`

### **Rules and Configuration:**
- **Validation rules:** `.ai-framework/rules/VALIDATION_RULES.md`
- **Sync rules:** `.ai-framework/rules/REPOSITORY_SYNC_RULES.md`
- **Workflow rules:** `.ai-framework/rules/WORKFLOW_RULES.md`

### **Framework Documentation:**
- **Main docs:** `.ai-framework/docs/`
- **Communication guide:** `.ai-framework/communications/README.md`

---

## ⚡ **EMERGENCY COMMANDS**

### **Full Project State Dump:**
```bash
#!/bin/bash
echo "=== FULL PROJECT STATE DUMP ==="
echo "Location: $(pwd)"
echo "Date: $(date)"
echo ""

echo "=== GIT STATUS ==="
git status
git log --oneline -3
echo ""

echo "=== LATEST AI COMMUNICATIONS ==="
echo "Reports:"
ls -la .ai-framework/communications/reports/ | tail -3
echo "Responses:"
ls -la .ai-framework/communications/responses/ | tail -3
echo ""

echo "=== FILE HEALTH ==="
echo "Source files:"
find src/ -name "*.py" | wc -l
echo "Test files:"
find tests/ -name "*.py" | wc -l
echo ""

echo "=== VALIDATION STATUS ==="
python3 -m flake8 src/ --count 2>/dev/null || echo "Style check failed"
python3 -m pytest tests/ --tb=no -q 2>/dev/null || echo "Tests failed"
echo ""

echo "=== PROJECT STATE ==="
head -20 .ai-framework/project-state/PROJECT_STATE.md
```

### **Framework Integrity Check:**
```bash
#!/bin/bash
echo "Checking AI Framework integrity..."

# Required directories
for dir in ".ai-framework" ".ai-framework/project-state" ".ai-framework/communications" ".ai-framework/rules" "src" "tests"; do
    if [ -d "$dir" ]; then
        echo "✅ $dir exists"
    else
        echo "❌ $dir missing"
    fi
done

# Required files
for file in ".ai-framework/project-state/PROJECT_STATE.md" ".ai-framework/rules/VALIDATION_RULES.md" "src/main.py"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
    fi
done
```

---

## 🎯 **REBOOT DECISION MATRIX**

### **If you see broken Python files in src/:**
→ **Resume validation workflow** - run `"work ready"` to detect issues

### **If you see reports but no responses:**
→ **Execute Browser Claude test** - test cross-platform communication

### **If you see responses but no validation:**
→ **Run re-validation** - execute `"work ready"` to verify fixes

### **If you see clean repository:**
→ **Start new test cycle** - create test scenario and begin validation

### **If framework structure is missing:**
→ **Reinstall framework** - run installation script from Avery's repository

---

## 📞 **SUPPORT INFORMATION**

### **Framework Source:**
- **Repository:** `https://github.com/JamesKayten/Averys-AI-Collaboration-Hack.git`
- **Local Installation:** `/Volumes/User_Smallfavor/Users/Smallfavor/Documents/Averys-AI-Collaboration-Hack/`

### **Test Project:**
- **Location:** `/Volumes/User_Smallfavor/Users/Smallfavor/Documents/ai-collaboration-test/`
- **Purpose:** Validate cross-platform AI collaboration framework

### **Critical Commands:**
- **Local AI Validation:** `"work ready"`
- **Online AI Command:** `"Check .ai-framework/communications/ for latest report and address the issues"`
- **Framework Test:** `../Averys-AI-Collaboration-Hack/scripts/test_installation.sh`

---

**Always start by reading PROJECT_STATE.md for the most current project status and next steps.**

**Emergency Contact:** Check git log for recent activity and framework state.