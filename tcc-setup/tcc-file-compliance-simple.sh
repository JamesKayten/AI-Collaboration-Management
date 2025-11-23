#!/bin/bash

# TCC File Size Compliance Checker - Simple Version
# Usage: ./tcc-file-compliance-simple.sh [target_branch]
# Purpose: Check all files against size limits before merge

set -e

TARGET_BRANCH="${1:-main}"
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
VIOLATION_REPORT=".ai-framework/communications/reports/TCC_FILE_VIOLATIONS_${TIMESTAMP}.md"
TEMP_VIOLATIONS="/tmp/violations_${TIMESTAMP}.txt"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🔍 TCC FILE SIZE COMPLIANCE CHECK${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "${BLUE}📋 Current Branch:${NC} $CURRENT_BRANCH"
echo -e "${BLUE}🎯 Target Branch:${NC} $TARGET_BRANCH"
echo -e "${BLUE}📅 Check Time:${NC} $(date)"

# Create communications directory if it doesn't exist
mkdir -p .ai-framework/communications/reports

echo ""
echo -e "${YELLOW}🔍 Scanning files for size violations...${NC}"

# Function to get size limit for file extension
get_size_limit() {
    case "$1" in
        py) echo 250 ;;
        js|jsx|ts|tsx) echo 150 ;;
        java) echo 400 ;;
        go|swift|rs) echo 300 ;;
        cpp|c) echo 300 ;;
        h|hpp) echo 200 ;;
        md) echo 500 ;;
        sh) echo 200 ;;
        yaml|yml|json|xml) echo 300 ;;
        html|css|scss|vue) echo 200 ;;
        rb|php) echo 250 ;;
        dart) echo 200 ;;
        *) echo 0 ;;  # No limit for unknown extensions
    esac
}

# Initialize violation counter and file
VIOLATION_COUNT=0
> "$TEMP_VIOLATIONS"

# Get list of files that differ from target branch
if git rev-parse --verify "$TARGET_BRANCH" >/dev/null 2>&1; then
    FILES_TO_CHECK=$(git diff --name-only "$TARGET_BRANCH"...HEAD 2>/dev/null || git ls-files)
else
    FILES_TO_CHECK=$(git ls-files)
fi

# Check each file
echo "$FILES_TO_CHECK" | while IFS= read -r file; do
    if [[ -f "$file" ]]; then
        # Get file extension
        extension="${file##*.}"

        # Get size limit for this extension
        max_lines=$(get_size_limit "$extension")

        # Skip if no size limit defined for this extension
        if [[ $max_lines -eq 0 ]]; then
            continue
        fi

        # Count lines in file
        line_count=$(wc -l < "$file" 2>/dev/null || echo 0)

        # Check if violation
        if [[ $line_count -gt $max_lines ]]; then
            echo -e "${RED}❌ VIOLATION:${NC} $file ($line_count lines > $max_lines limit)"
            echo "VIOLATION|$file|$extension|$line_count|$max_lines" >> "$TEMP_VIOLATIONS"
        else
            echo -e "${GREEN}✅${NC} $file ($line_count lines ≤ $max_lines limit)"
        fi
    fi
done

# Count violations
if [[ -f "$TEMP_VIOLATIONS" ]]; then
    VIOLATION_COUNT=$(grep -c "VIOLATION" "$TEMP_VIOLATIONS" 2>/dev/null || echo 0)
else
    VIOLATION_COUNT=0
fi

# Ensure VIOLATION_COUNT is a number
VIOLATION_COUNT=${VIOLATION_COUNT//[^0-9]/}

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [[ $VIOLATION_COUNT -eq 0 ]]; then
    echo -e "${GREEN}✅ FILE SIZE COMPLIANCE: PASSED${NC}"
    echo -e "${GREEN}All files meet size requirements${NC}"
    echo -e "${BLUE}🚀 Ready for merge to $TARGET_BRANCH${NC}"

    # Clean up temp file
    rm -f "$TEMP_VIOLATIONS"

    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 0
fi

echo -e "${RED}❌ FILE SIZE COMPLIANCE: FAILED${NC}"
echo -e "${RED}$VIOLATION_COUNT violations found${NC}"
echo ""

# Create detailed violation report for OCC
cat > "$VIOLATION_REPORT" << EOF
# TCC File Size Compliance Report

**Date:** $(date)
**Branch:** $CURRENT_BRANCH → $TARGET_BRANCH
**Status:** ❌ **COMPLIANCE FAILED**
**Violations:** $VIOLATION_COUNT

---

## 🚨 **MERGE BLOCKED - ACTION REQUIRED**

The following files exceed the maximum size limits and **MUST be refactored before merge:**

EOF

# Add violation details
while IFS='|' read -r status file ext current max; do
    if [[ "$status" == "VIOLATION" ]]; then
        overage=$((current - max))
        percentage=$(( (current * 100) / max ))

        cat >> "$VIOLATION_REPORT" << EOF
### ❌ \`$file\`
- **File Type:** .$ext
- **Current Size:** $current lines
- **Max Allowed:** $max lines
- **Overage:** +$overage lines ($percentage% of limit)
- **Action:** Refactor to reduce by $overage+ lines

EOF
    fi
done < "$TEMP_VIOLATIONS"

cat >> "$VIOLATION_REPORT" << EOF

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
\`\`\`bash
# Run compliance check again
curl -sSL https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/tcc-setup/tcc-file-compliance-simple.sh > check-compliance.sh
chmod +x check-compliance.sh
./check-compliance.sh $TARGET_BRANCH

# Should show: ✅ FILE SIZE COMPLIANCE: PASSED
\`\`\`

---

## 📋 **TCC Validation Results**

- **Files Scanned:** $(echo "$FILES_TO_CHECK" | wc -l)
- **Violations Found:** $VIOLATION_COUNT
- **Compliance Status:** ❌ FAILED
- **Merge Status:** 🚫 BLOCKED until violations resolved

---

**⚠️  IMPORTANT:** This branch cannot be merged until all file size violations are resolved.

EOF

echo -e "${YELLOW}📝 Violation report created:${NC} $VIOLATION_REPORT"

# Display summary of violations for immediate feedback
echo ""
echo -e "${RED}🚨 VIOLATIONS SUMMARY:${NC}"
while IFS='|' read -r status file ext current max; do
    if [[ "$status" == "VIOLATION" ]]; then
        overage=$((current - max))
        echo -e "${RED}   $file${NC} ($current lines, needs -$overage)"
    fi
done < "$TEMP_VIOLATIONS"

echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo "1. Review violation report: $VIOLATION_REPORT"
echo "2. Refactor oversized files"
echo "3. Re-run: ./check-compliance.sh $TARGET_BRANCH"
echo "4. Merge only after: ✅ FILE SIZE COMPLIANCE: PASSED"

# Clean up temp file
rm -f "$TEMP_VIOLATIONS"

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}❌ MERGE BLOCKED - COMPLIANCE VIOLATIONS MUST BE FIXED${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

exit 1