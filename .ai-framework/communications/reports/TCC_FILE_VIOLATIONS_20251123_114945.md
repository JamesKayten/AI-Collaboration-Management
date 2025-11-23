# TCC File Size Compliance Report

**Date:** Sun Nov 23 11:49:45 PST 2025
**Branch:** main → main
**Status:** ❌ **COMPLIANCE FAILED**
**Violations:** 0
0

---

## 🚨 **MERGE BLOCKED - ACTION REQUIRED**

The following files exceed the maximum size limits and **MUST be refactored before merge:**


---

## 🔧 **OCC REFACTORING INSTRUCTIONS**

### **File Size Limits:**
- **Python (.py):** 250 lines max
- **JavaScript/TypeScript (.js/.ts):** 150 lines max
- **Java (.java):** 400 lines max
- **Go/Swift/Rust:** 300 lines max
- **Markdown (.md):** 500 lines max
- **Shell scripts (.sh):** 200 lines max
- **Other formats:** See TCC documentation

### **Refactoring Strategies:**
1. **Split large functions** into smaller, focused functions
2. **Extract utility functions** to separate files
3. **Break large components** into smaller modules
4. **Move constants/configs** to dedicated files
5. **Use composition** over large inheritance hierarchies

### **Testing Your Changes:**
```bash
# Run compliance check again
curl -sSL https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/tcc-setup/tcc-file-compliance-simple.sh > check-compliance.sh
chmod +x check-compliance.sh
./check-compliance.sh main

# Should show: ✅ FILE SIZE COMPLIANCE: PASSED
```

---

## 📋 **TCC Validation Results**

- **Files Scanned:**        1
- **Violations Found:** 0
0
- **Compliance Status:** ❌ FAILED
- **Merge Status:** 🚫 BLOCKED until violations resolved

---

**⚠️  IMPORTANT:** This branch cannot be merged until all file size violations are resolved.

