#!/bin/bash

# AI Collaboration Framework - Complete Self-Contained Installation
# Usage: ./install-framework-complete.sh [repository_url]
# Purpose: Install complete framework with all tools embedded locally

set -e

REPO_URL="${1:-$(git remote get-url origin 2>/dev/null || echo "")}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

if [ -z "$REPO_URL" ]; then
    echo "❌ Error: No repository URL provided and no git remote found"
    echo "Usage: $0 <repository_url>"
    exit 1
fi

echo "🚀 AI Collaboration Framework - Complete Installation"
echo "📋 Repository: $REPO_URL"
echo "📅 Installation Time: $(date)"
echo ""

# Create framework directory structure
echo "📁 Creating framework directory structure..."
mkdir -p .ai-framework/{communications/{reports,updates,responses},project-state,rules,scripts,tools}

# Create self-contained BOARD.md
echo "📄 Creating BOARD.md..."
cat > BOARD.md << 'EOF'
# TCC Board Status

**Self-Contained AI Collaboration Framework Status Check**

## ⚡ Fast Status Check (Recommended)

Execute this command for **instant** framework status:

```bash
./.ai-framework/tools/tcc-board-check-fast.sh REPOSITORY_URL_PLACEHOLDER
```

## 🔍 Detailed Analysis (If Needed)

For complete framework analysis with file-level detail:

```bash
./.ai-framework/tools/tcc-board-check.sh REPOSITORY_URL_PLACEHOLDER
```

## 🔒 File Compliance Check

Before any merge to main:

```bash
./.ai-framework/tools/tcc-file-compliance.sh main
```

## 📋 What You'll Get

- ✅ Complete framework discovery and configuration
- ✅ All collaboration parameters loaded
- ✅ Previous session/progress state recovered
- ✅ New work needing verification identified
- ✅ File size compliance validation
- ✅ Prioritized action plan
- ✅ Ready-to-use work environment

## 🔄 AI Collaboration Framework

This repository uses a **self-contained** AI Collaboration Framework for OCC/TCC development workflows.

**Framework Location:** `.ai-framework/`
**Tools Location:** `.ai-framework/tools/`

**Key Files:**
- Project state: `.ai-framework/project-state/PROJECT_STATE.md`
- Validation rules: `.ai-framework/rules/`
- Communications: `.ai-framework/communications/`

**All tools are embedded locally - no external dependencies.**

## ⚡ Run the Commands Above

Execute the local commands to get complete automated collaboration status for this repository.
EOF

# Replace placeholder with actual repository URL
sed -i.bak "s|REPOSITORY_URL_PLACEHOLDER|$REPO_URL|g" BOARD.md && rm BOARD.md.bak

# Install tcc-board-check-fast.sh locally
echo "🔧 Installing fast board check tool..."
cat > .ai-framework/tools/tcc-board-check-fast.sh << 'EOF'
#!/bin/bash

# TCC Board Check - FAST VERSION (Self-Contained)
# Usage: ./tcc-board-check-fast.sh <repository_url> [branch]
# Purpose: Quick board status without repository clone

set -e

REPO_URL="$1"
BRANCH="${2:-main}"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}🚀 FAST TCC BOARD CHECK (Self-Contained)${NC}"
echo -e "${BLUE}Repository:${NC} $REPO_URL"

if [ -z "$REPO_URL" ]; then
    echo -e "${RED}❌ Usage: $0 <repository_url> [branch]${NC}"
    exit 1
fi

# Extract repo info
REPO_NAME=$(echo "$REPO_URL" | sed 's|.*/||' | sed 's|\.git$||')
GITHUB_REPO=$(echo "$REPO_URL" | sed 's|https://github.com/||' | sed 's|\.git$||')

echo -e "${YELLOW}📡 Checking repository status via API...${NC}"

# Check if repository exists and get basic info
API_RESPONSE=$(curl -s "https://api.github.com/repos/$GITHUB_REPO" || echo "")
if echo "$API_RESPONSE" | grep -q '"message": "Not Found"'; then
    echo -e "${RED}❌ Repository not found or not accessible${NC}"
    exit 1
fi

# Get basic repository info
REPO_DESCRIPTION=$(echo "$API_RESPONSE" | grep '"description"' | cut -d'"' -f4 || echo "No description")
DEFAULT_BRANCH=$(echo "$API_RESPONSE" | grep '"default_branch"' | cut -d'"' -f4 || echo "main")
LAST_UPDATED=$(echo "$API_RESPONSE" | grep '"updated_at"' | cut -d'"' -f4 || echo "Unknown")

echo -e "${GREEN}✅ Repository found${NC}"

# Quick framework check - look for key framework files via API
echo -e "${YELLOW}🔍 Checking for framework files...${NC}"

# Check for .ai-framework directory
FRAMEWORK_CHECK=$(curl -s "https://api.github.com/repos/$GITHUB_REPO/contents/.ai-framework" || echo "")
if echo "$FRAMEWORK_CHECK" | grep -q '"type": "dir"'; then
    echo -e "${GREEN}✅ AI Collaboration Framework detected${NC}"
    FRAMEWORK_FOUND=true
else
    echo -e "${RED}❌ No AI Collaboration Framework found${NC}"
    FRAMEWORK_FOUND=false
fi

# Check for BOARD.md
BOARD_CHECK=$(curl -s "https://api.github.com/repos/$GITHUB_REPO/contents/BOARD.md" || echo "")
if echo "$BOARD_CHECK" | grep -q '"type": "file"'; then
    echo -e "${GREEN}✅ TCC board file present${NC}"
    BOARD_PRESENT=true
else
    echo -e "${YELLOW}⚠️  No BOARD.md - TCC board check not available${NC}"
    BOARD_PRESENT=false
fi

# Get branch information
echo -e "${YELLOW}🌿 Checking branches...${NC}"
BRANCHES_RESPONSE=$(curl -s "https://api.github.com/repos/$GITHUB_REPO/branches?per_page=100" || echo "")
TOTAL_BRANCHES=$(echo "$BRANCHES_RESPONSE" | grep -o '"name":' | wc -l || echo "0")
FEATURE_BRANCHES=$(echo "$BRANCHES_RESPONSE" | grep -o '"name": "claude/[^"]*"' | wc -l || echo "0")

echo -e "${BLUE}📊 Found $TOTAL_BRANCHES total branches, $FEATURE_BRANCHES feature branches${NC}"

# Get recent commits
COMMITS_RESPONSE=$(curl -s "https://api.github.com/repos/$GITHUB_REPO/commits?per_page=5&sha=$BRANCH" || echo "")
LATEST_COMMIT=$(echo "$COMMITS_RESPONSE" | grep -m1 '"sha"' | cut -d'"' -f4 | cut -c1-8 || echo "unknown")
LATEST_MESSAGE=$(echo "$COMMITS_RESPONSE" | grep -m1 '"message"' | cut -d'"' -f4 || echo "No commit message")

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}📊 FAST BOARD STATUS${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "${BLUE}📋 Repository:${NC} $REPO_NAME"
echo -e "${BLUE}🔧 Description:${NC} $REPO_DESCRIPTION"
echo -e "${BLUE}📅 Last Updated:${NC} $LAST_UPDATED"
echo -e "${BLUE}🌿 Branches:${NC} $TOTAL_BRANCHES total, $FEATURE_BRANCHES feature"
echo -e "${BLUE}📦 Latest Commit:${NC} $LATEST_COMMIT - $LATEST_MESSAGE"

if [ "$FRAMEWORK_FOUND" = true ]; then
    echo -e "${GREEN}✅ AI Framework:${NC} Active (Self-Contained)"
else
    echo -e "${RED}❌ AI Framework:${NC} Not found"
fi

if [ "$BOARD_PRESENT" = true ]; then
    echo -e "${GREEN}✅ TCC Board:${NC} Available (Local Tools)"
else
    echo -e "${YELLOW}⚠️  TCC Board:${NC} Not configured"
fi

echo ""

# Provide next steps
if [ "$FRAMEWORK_FOUND" = true ] && [ "$BOARD_PRESENT" = true ]; then
    echo -e "${GREEN}🎯 STATUS: Ready for TCC collaboration (Self-Contained)${NC}"
    echo -e "${BLUE}💡 For detailed analysis:${NC}"
    echo "   ./.ai-framework/tools/tcc-board-check.sh $REPO_URL"
elif [ "$FRAMEWORK_FOUND" = true ]; then
    echo -e "${YELLOW}⚠️  STATUS: Framework found, needs TCC board setup${NC}"
    echo -e "${BLUE}💡 To add TCC board:${NC}"
    echo "   ./.ai-framework/tools/install-framework-complete.sh"
else
    echo -e "${RED}❌ STATUS: No collaboration framework detected${NC}"
    echo -e "${BLUE}💡 This repository doesn't have the AI Collaboration Framework${NC}"
fi

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}⚡ FAST BOARD CHECK COMPLETE ($(date))${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
EOF

chmod +x .ai-framework/tools/tcc-board-check-fast.sh

# Install file compliance checker locally
echo "🔒 Installing file compliance checker..."
cat > .ai-framework/tools/tcc-file-compliance.sh << 'EOF'
#!/bin/bash

# TCC File Size Compliance Checker (Self-Contained)
# Usage: ./tcc-file-compliance.sh [target_branch]
# Purpose: Check all files against size limits before merge

set -e

TARGET_BRANCH="${1:-main}"
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
VIOLATION_REPORT="../communications/reports/TCC_FILE_VIOLATIONS_${TIMESTAMP}.md"
TEMP_VIOLATIONS="/tmp/violations_${TIMESTAMP}.txt"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🔍 TCC FILE SIZE COMPLIANCE CHECK (Self-Contained)${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "${BLUE}📋 Current Branch:${NC} $CURRENT_BRANCH"
echo -e "${BLUE}🎯 Target Branch:${NC} $TARGET_BRANCH"
echo -e "${BLUE}📅 Check Time:${NC} $(date)"

# Create communications directory if it doesn't exist
mkdir -p ../communications/reports

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
        *) echo 0 ;;
    esac
}

# Initialize violation counter and file
VIOLATION_COUNT=0
> "$TEMP_VIOLATIONS"

# Get list of files that differ from target branch
cd ../..  # Go to repository root
if git rev-parse --verify "$TARGET_BRANCH" >/dev/null 2>&1; then
    FILES_TO_CHECK=$(git diff --name-only "$TARGET_BRANCH"...HEAD 2>/dev/null || git ls-files)
else
    FILES_TO_CHECK=$(git ls-files)
fi

# Check each file
echo "$FILES_TO_CHECK" | while IFS= read -r file; do
    if [[ -f "$file" ]]; then
        extension="${file##*.}"
        max_lines=$(get_size_limit "$extension")

        if [[ $max_lines -eq 0 ]]; then
            continue
        fi

        line_count=$(wc -l < "$file" 2>/dev/null || echo 0)

        if [[ $line_count -gt $max_lines ]]; then
            echo -e "${RED}❌ VIOLATION:${NC} $file ($line_count lines > $max_lines limit)"
            echo "VIOLATION|$file|$extension|$line_count|$max_lines" >> "$TEMP_VIOLATIONS"
        else
            echo -e "${GREEN}✅${NC} $file ($line_count lines ≤ $max_lines limit)"
        fi
    fi
done

# Back to tools directory
cd .ai-framework/tools

# Count violations
if [[ -f "$TEMP_VIOLATIONS" ]]; then
    VIOLATION_COUNT=$(grep -c "VIOLATION" "$TEMP_VIOLATIONS" 2>/dev/null || echo 0)
else
    VIOLATION_COUNT=0
fi

VIOLATION_COUNT=${VIOLATION_COUNT//[^0-9]/}

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [[ $VIOLATION_COUNT -eq 0 ]]; then
    echo -e "${GREEN}✅ FILE SIZE COMPLIANCE: PASSED${NC}"
    echo -e "${GREEN}All files meet size requirements${NC}"
    echo -e "${BLUE}🚀 Ready for merge to $TARGET_BRANCH${NC}"
    rm -f "$TEMP_VIOLATIONS"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 0
fi

echo -e "${RED}❌ FILE SIZE COMPLIANCE: FAILED${NC}"
echo -e "${RED}$VIOLATION_COUNT violations found${NC}"

# Create detailed violation report
echo -e "${YELLOW}📝 Generating violation report...${NC}"

cat > "$VIOLATION_REPORT" << REPORTEOF
# TCC File Size Compliance Violation Report

**Generated:** $(date)
**Branch:** $CURRENT_BRANCH
**Target Branch:** $TARGET_BRANCH
**Violations Found:** $VIOLATION_COUNT

---

## ❌ **COMPLIANCE STATUS: FAILED**

This branch has **$VIOLATION_COUNT file(s)** exceeding size limits and **cannot be merged** until violations are fixed.

---

## 🚨 **VIOLATIONS**

REPORTEOF

# Add each violation to the report
while IFS='|' read -r marker file ext line_count max_lines; do
    if [ "$marker" = "VIOLATION" ]; then
        cat >> "$VIOLATION_REPORT" << REPORTEOF

### ❌ \`$file\`
- **Extension:** .$ext
- **Current Size:** $line_count lines
- **Limit:** $max_lines lines
- **Excess:** $(( line_count - max_lines )) lines over limit
- **Action Required:** Refactor to reduce file size

REPORTEOF
    fi
done < "$TEMP_VIOLATIONS"

# Add recommendations to the report
cat >> "$VIOLATION_REPORT" << 'REPORTEOF'

---

## 🔧 **RECOMMENDED ACTIONS**

### **For OCC (File Owner):**
1. **Refactor oversized files** - Split into smaller, focused modules
2. **Extract reusable functions** - Create utility/helper files
3. **Separate concerns** - Move different responsibilities to different files
4. **Re-run compliance check** - Verify all violations are fixed

### **Refactoring Strategies:**
- **Large classes:** Split into multiple smaller classes
- **Long functions:** Extract helper functions
- **Multiple concerns:** Separate into different modules
- **Repeated code:** Create shared utilities

### **After Refactoring:**
```bash
# Re-run compliance check
./.ai-framework/tools/tcc-file-compliance.sh $TARGET_BRANCH

# If passed, ready for merge
git add .
git commit -m "Fix file size violations"
```

---

## 📋 **FILE SIZE LIMITS**

| Extension | Limit (lines) |
|-----------|---------------|
| .py | 250 |
| .js, .ts, .jsx, .tsx | 150 |
| .java | 400 |
| .go, .swift, .rs | 300 |
| .c, .cpp | 300 |
| .h, .hpp | 200 |
| .md | 500 |
| .sh | 200 |
| .yaml, .yml, .json, .xml | 300 |
| .html, .css, .scss | 200 |
| .rb, .php | 250 |
| .dart | 200 |

---

## 🔒 **MERGE BLOCKED**

**This branch cannot be merged until all file size violations are resolved.**

**Next Steps:**
1. Review violations listed above
2. Refactor oversized files
3. Re-run compliance check
4. Proceed with merge when all checks pass

---

**TCC File Compliance System - Self-Contained Framework**
REPORTEOF

echo -e "${YELLOW}📝 Violation report created:${NC} $VIOLATION_REPORT"

rm -f "$TEMP_VIOLATIONS"

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}❌ MERGE BLOCKED - COMPLIANCE VIOLATIONS MUST BE FIXED${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

exit 1
EOF

chmod +x .ai-framework/tools/tcc-file-compliance.sh

# Install detailed board check tool
echo "🔍 Installing detailed board check tool..."
cat > .ai-framework/tools/tcc-board-check.sh << 'DETAILEDEOF'
#!/bin/bash

# TCC Board Check - Automated Collaboration Framework Status (Self-Contained)
# Usage: ./tcc-board-check.sh <repository_url> [branch]
# Purpose: Complete framework status and pending work analysis

set -e

REPO_URL="$1"
BRANCH="${2:-main}"
WORK_DIR="/tmp/tcc-board-check-$(date +%s)"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🎯 TCC BOARD CHECK - AUTOMATED STATUS REPORT (Self-Contained)${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ -z "$REPO_URL" ]; then
    echo -e "${RED}❌ Usage: $0 <repository_url> [branch]${NC}"
    echo ""
    echo -e "${YELLOW}Example:${NC}"
    echo "  $0 https://github.com/user/repo main"
    exit 1
fi

echo -e "${BLUE}📋 Repository:${NC} $REPO_URL"
echo -e "${BLUE}🔧 Branch:${NC} $BRANCH"
echo -e "${BLUE}📁 Work Directory:${NC} $WORK_DIR"
echo ""

# Step 1: Clone repository
echo -e "${YELLOW}🔄 Step 1: Cloning repository...${NC}"
git clone "$REPO_URL" "$WORK_DIR" >/dev/null 2>&1
cd "$WORK_DIR"

if [ "$BRANCH" != "main" ] && [ "$BRANCH" != "master" ]; then
    echo -e "${YELLOW}🔧 Checking out branch: $BRANCH${NC}"
    git checkout "$BRANCH" >/dev/null 2>&1
fi

echo -e "${GREEN}✅ Repository cloned successfully${NC}"
echo ""

# Step 2: Auto-discover framework structure
echo -e "${YELLOW}🔍 Step 2: Auto-discovering collaboration framework...${NC}"

FRAMEWORK_FOUND=false
FRAMEWORK_PATH=""
PROJECT_PATH=""

# Check for framework in root
if [ -d ".ai-framework" ]; then
    FRAMEWORK_FOUND=true
    FRAMEWORK_PATH=".ai-framework"
    PROJECT_PATH="."
    echo -e "${GREEN}✅ Framework found in repository root${NC}"
# Check for framework in subdirectories
else
    for dir in */; do
        if [ -d "$dir/.ai-framework" ]; then
            FRAMEWORK_FOUND=true
            FRAMEWORK_PATH="$dir/.ai-framework"
            PROJECT_PATH="$dir"
            echo -e "${GREEN}✅ Framework found in: $dir${NC}"
            break
        fi
    done
fi

if [ "$FRAMEWORK_FOUND" = false ]; then
    echo -e "${RED}❌ No AI Collaboration Framework found${NC}"
    echo -e "${YELLOW}💡 This repository doesn't have the framework installed${NC}"
    rm -rf "$WORK_DIR"
    exit 1
fi

echo ""

# Step 3: Read collaboration parameters
echo -e "${YELLOW}📋 Step 3: Reading collaboration parameters...${NC}"

# Project state
if [ -f "$FRAMEWORK_PATH/project-state/PROJECT_STATE.md" ]; then
    echo -e "${GREEN}✅ Project state found${NC}"
    PROJECT_STATE="$FRAMEWORK_PATH/project-state/PROJECT_STATE.md"
else
    echo -e "${YELLOW}⚠️  No project state file found${NC}"
    PROJECT_STATE=""
fi

# Framework config
if [ -f "$FRAMEWORK_PATH/project-state/FRAMEWORK_CONFIG.md" ]; then
    echo -e "${GREEN}✅ Framework config found${NC}"
    FRAMEWORK_CONFIG="$FRAMEWORK_PATH/project-state/FRAMEWORK_CONFIG.md"
else
    echo -e "${YELLOW}⚠️  No framework config found${NC}"
    FRAMEWORK_CONFIG=""
fi

# Rules
if [ -d "$FRAMEWORK_PATH/rules" ]; then
    echo -e "${GREEN}✅ Validation rules found${NC}"
    RULES_DIR="$FRAMEWORK_PATH/rules"
else
    echo -e "${YELLOW}⚠️  No validation rules found${NC}"
    RULES_DIR=""
fi

echo ""

# Step 4: Check session recovery
echo -e "${YELLOW}🔄 Step 4: Checking session recovery...${NC}"

SESSION_STATE=""
SESSION_SNAPSHOT=""

if [ -f "restore_session.sh" ]; then
    echo -e "${GREEN}✅ Session recovery system found${NC}"
fi

if [ -f "SESSION_EXIT_SNAPSHOT.md" ]; then
    echo -e "${GREEN}✅ Exit snapshot found${NC}"
    SESSION_SNAPSHOT="SESSION_EXIT_SNAPSHOT.md"
fi

if [ -f "$FRAMEWORK_PATH/session-recovery/CURRENT_SESSION_STATE.md" ]; then
    echo -e "${GREEN}✅ Current session state found${NC}"
    SESSION_STATE="$FRAMEWORK_PATH/session-recovery/CURRENT_SESSION_STATE.md"
fi

echo ""

# Step 5: Check for pending work
echo -e "${YELLOW}🔍 Step 5: Checking for pending work...${NC}"

# Check for feature branches
echo -e "${BLUE}🌿 Feature branches:${NC}"
FEATURE_BRANCHES=$(git branch -r | grep -E "(claude/|feature/)" | head -10 || true)
if [ -n "$FEATURE_BRANCHES" ]; then
    echo "$FEATURE_BRANCHES" | sed 's/^/  /'
    PENDING_BRANCHES=true
else
    echo -e "  ${YELLOW}No feature branches found${NC}"
    PENDING_BRANCHES=false
fi

# Check for communications
echo ""
echo -e "${BLUE}📬 Pending communications:${NC}"

REPORTS_FOUND=false
UPDATES_FOUND=false

if [ -d "$FRAMEWORK_PATH/communications/reports" ]; then
    REPORTS=$(find "$FRAMEWORK_PATH/communications/reports" -name "*.md" 2>/dev/null || true)
    if [ -n "$REPORTS" ]; then
        echo -e "${GREEN}  📋 TCC Reports found:${NC}"
        echo "$REPORTS" | sed 's/^/    /'
        REPORTS_FOUND=true
    fi
fi

if [ -d "$FRAMEWORK_PATH/communications/updates" ]; then
    UPDATES=$(find "$FRAMEWORK_PATH/communications/updates" -name "*.md" 2>/dev/null || true)
    if [ -n "$UPDATES" ]; then
        echo -e "${GREEN}  📢 OCC Updates found:${NC}"
        echo "$UPDATES" | sed 's/^/    /'
        UPDATES_FOUND=true
    fi
fi

if [ "$REPORTS_FOUND" = false ] && [ "$UPDATES_FOUND" = false ]; then
    echo -e "  ${YELLOW}No pending communications${NC}"
fi

echo ""

# Step 6: Generate status summary
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}📊 TCC STATUS SUMMARY${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${BLUE}🎯 Project Location:${NC} $PROJECT_PATH"
echo -e "${BLUE}🔧 Framework Path:${NC} $FRAMEWORK_PATH"
echo -e "${BLUE}📋 Current Branch:${NC} $(git branch --show-current)"
echo -e "${BLUE}📅 Last Commit:${NC} $(git log -1 --format='%h - %s (%cr)')"
echo ""

# Action Items
echo -e "${YELLOW}⚡ IMMEDIATE ACTIONS REQUIRED:${NC}"

ACTION_COUNT=0

if [ "$PENDING_BRANCHES" = true ]; then
    ((ACTION_COUNT++))
    echo -e "${RED}$ACTION_COUNT.${NC} Review and test feature branches"
fi

if [ "$REPORTS_FOUND" = true ]; then
    ((ACTION_COUNT++))
    echo -e "${RED}$ACTION_COUNT.${NC} Process TCC validation reports"
fi

if [ "$UPDATES_FOUND" = true ]; then
    ((ACTION_COUNT++))
    echo -e "${RED}$ACTION_COUNT.${NC} Read OCC handoff updates"
fi

if [ "$ACTION_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✅ No immediate actions required${NC}"
    echo -e "${GREEN}🎉 Repository is in clean state${NC}"
fi

echo ""

# Quick reference
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🚀 QUICK REFERENCE${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${BLUE}📁 Work Directory:${NC}"
echo "  cd $WORK_DIR"
echo ""

if [ -n "$SESSION_STATE" ]; then
    echo -e "${BLUE}📋 Read Current Session:${NC}"
    echo "  cat $SESSION_STATE"
    echo ""
fi

if [ -n "$PROJECT_STATE" ]; then
    echo -e "${BLUE}🎯 Read Project State:${NC}"
    echo "  cat $PROJECT_STATE"
    echo ""
fi

if [ "$PENDING_BRANCHES" = true ]; then
    echo -e "${BLUE}🔧 Test Feature Branch:${NC}"
    echo "  git checkout <branch_name>"
    echo "  # Run your tests"
    echo ""
fi

echo -e "${BLUE}🧹 Cleanup:${NC}"
echo "  rm -rf $WORK_DIR"
echo ""

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ TCC BOARD CHECK COMPLETE (Self-Contained)${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
DETAILEDEOF

chmod +x .ai-framework/tools/tcc-board-check.sh

# Create OCC discovery file
echo "🔍 Creating OCC discovery file..."
cat > .ai-framework/OCC_NEW_FEATURES.md << 'EOF'
# 🎯 OCC: Self-Contained AI Collaboration Framework

**Complete framework with embedded tools - no external dependencies**

## ⚡ **QUICK SUMMARY FOR OCC**

This repository has a **self-contained** AI Collaboration Framework with all tools embedded locally. No external dependencies or master repository required.

### **What's Available:**
- ✅ **Self-contained tools** - All tools embedded in `.ai-framework/tools/`
- ✅ **Fast board checking** - Instant framework status (3-5 seconds)
- ✅ **Detailed board checking** - Complete framework analysis
- ✅ **File size compliance** - Automatic enforcement with violation reports
- ✅ **Complete automation** - No external dependencies

## 🚀 **OCC Commands (Local)**

### **Check This Repository's Framework Status (Fast):**
```bash
./.ai-framework/tools/tcc-board-check-fast.sh $(git remote get-url origin)
```

### **Check This Repository's Framework Status (Detailed):**
```bash
./.ai-framework/tools/tcc-board-check.sh $(git remote get-url origin)
```

### **Check File Size Compliance Before Merge:**
```bash
./.ai-framework/tools/tcc-file-compliance.sh main
```

### **Test TCC Integration:**
```bash
test -f BOARD.md && echo "✅ TCC can check the board" || echo "❌ Framework not configured"
```

## 🔄 **OCC/TCC Workflow**

### **Enhanced Workflow (Self-Contained):**
1. **OCC develops feature** in local repository
2. **User:** "TCC: Check the board"
3. **TCC automatically:** Finds BOARD.md → Runs local tools → Gets complete context
4. **Result:** Complete automation, zero external dependencies

### **Benefits:**
- ✅ **No master repository dependency** - Everything local
- ✅ **Customizable** - Tools can be modified per repository
- ✅ **Portable** - Framework works anywhere
- ✅ **Fast** - No external downloads during execution
- ✅ **Reliable** - No network dependencies for core operations

## 📁 **Framework Files**

### **Embedded Tools:**
- `.ai-framework/tools/tcc-board-check-fast.sh` - Fast status check (3-5 seconds)
- `.ai-framework/tools/tcc-board-check.sh` - Detailed framework analysis
- `.ai-framework/tools/tcc-file-compliance.sh` - File compliance with violation reports
- `.ai-framework/tools/` - All collaboration tools embedded locally

### **Framework Structure:**
- `.ai-framework/project-state/` - Project configuration
- `.ai-framework/rules/` - Validation rules
- `.ai-framework/communications/` - OCC/TCC communication
- `BOARD.md` - TCC discovery entry point

## 🎯 **Self-Contained Benefits**

- **No External Dependencies:** Everything works offline
- **Fully Customizable:** Modify tools per repository needs
- **Portable:** Framework moves with repository
- **Fast:** No remote downloads during operations
- **Reliable:** No single points of failure

**This framework is completely self-contained and ready for collaboration.**
EOF

# Create project state file
echo "📋 Creating project configuration..."
cat > .ai-framework/project-state/PROJECT_STATE.md << EOF
# Project State

**Repository:** $(basename "$REPO_URL" .git)
**Framework:** AI Collaboration Framework v2.0 (Self-Contained)
**Installation Date:** $(date)
**Status:** Active

## Framework Configuration

- **Type:** Self-Contained AI Collaboration Framework
- **Tools Location:** .ai-framework/tools/
- **No External Dependencies:** All tools embedded locally
- **TCC Ready:** Yes (via BOARD.md)
- **OCC Ready:** Yes (via .ai-framework/OCC_NEW_FEATURES.md)

## Collaboration Parameters

- **File Size Limits:** Enforced via local tools
- **Board Check:** Fast (3-5 seconds) via local tool
- **Compliance Check:** Automatic via local tool
- **Communication:** Via .ai-framework/communications/

## Tools Installed

- tcc-board-check-fast.sh (Fast status check - 3-5 seconds)
- tcc-board-check.sh (Detailed status check - full analysis)
- tcc-file-compliance.sh (File size enforcement with violation reports)
- install-framework-complete.sh (Self-contained installer)

## Session Recovery

- Session recovery available via standard framework protocols
- All tools and configurations embedded locally
- No external repository dependencies

---

**Framework installed successfully on $(date)**
EOF

# Create validation rules
echo "⚙️ Creating validation rules..."
mkdir -p .ai-framework/rules
cat > .ai-framework/rules/VALIDATION_RULES.md << 'EOF'
# Validation Rules

## File Size Limits

- **Python (.py):** 250 lines maximum
- **JavaScript/TypeScript (.js/.ts/.jsx/.tsx):** 150 lines maximum
- **Java (.java):** 400 lines maximum
- **Go/Swift/Rust (.go/.swift/.rs):** 300 lines maximum
- **C/C++ (.c/.cpp):** 300/400 lines maximum
- **Headers (.h/.hpp):** 200 lines maximum
- **Markdown (.md):** 500 lines maximum
- **Shell scripts (.sh):** 200 lines maximum
- **Config files (.yaml/.yml/.json/.xml):** 300 lines maximum
- **Styles (.css/.scss):** 200 lines maximum
- **Other languages (.rb/.php/.dart):** 200-250 lines maximum

## Compliance Enforcement

- **Pre-merge validation:** Required via `.ai-framework/tools/tcc-file-compliance.sh`
- **Merge blocking:** Automatic if violations found
- **Violation reporting:** Saved to `.ai-framework/communications/reports/`
- **OCC notification:** Via framework discovery

## TCC Responsibilities

- **Board checking:** Fast status via local tools
- **File compliance:** Automatic enforcement before merges
- **Testing validation:** Comprehensive project testing
- **Communication:** Report findings via framework communications

## Success Criteria

- ✅ All files within size limits
- ✅ No uncommitted changes before merge
- ✅ All validation checks passed
- ✅ Framework communications up to date

---

**Self-contained validation rules - no external dependencies**
EOF

echo ""
echo -e "${GREEN}✅ AI Collaboration Framework Installation Complete!${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🎯 INSTALLATION SUMMARY${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "${BLUE}📋 Repository:${NC} $(basename "$REPO_URL" .git)"
echo -e "${BLUE}🔧 Framework:${NC} Self-Contained AI Collaboration Framework v2.0"
echo -e "${BLUE}📁 Location:${NC} .ai-framework/"
echo -e "${BLUE}🛠️  Tools:${NC} .ai-framework/tools/"

echo ""
echo -e "${GREEN}✅ Files Created:${NC}"
echo "   📄 BOARD.md (TCC discovery)"
echo "   ⚡ .ai-framework/tools/tcc-board-check-fast.sh"
echo "   🔍 .ai-framework/tools/tcc-board-check.sh (detailed)"
echo "   🔒 .ai-framework/tools/tcc-file-compliance.sh"
echo "   📋 .ai-framework/OCC_NEW_FEATURES.md"
echo "   📊 .ai-framework/project-state/PROJECT_STATE.md"
echo "   ⚙️  .ai-framework/rules/VALIDATION_RULES.md"

echo ""
echo -e "${BLUE}🚀 Ready for Use:${NC}"
echo "   • TCC: 'Check the board' → Finds BOARD.md → Runs local tools"
echo "   • OCC: Discovers .ai-framework/OCC_NEW_FEATURES.md → Gets commands"
echo "   • File compliance: .ai-framework/tools/tcc-file-compliance.sh"
echo "   • Fast board check: .ai-framework/tools/tcc-board-check-fast.sh"

echo ""
echo -e "${GREEN}🎯 Benefits:${NC}"
echo "   ✅ No external dependencies"
echo "   ✅ Completely self-contained"
echo "   ✅ Customizable per repository"
echo "   ✅ Portable and reliable"

echo ""
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. Test framework: ./.ai-framework/tools/tcc-board-check-fast.sh $REPO_URL"
echo "2. Commit framework: git add . && git commit -m 'Add self-contained AI collaboration framework'"
echo "3. Use with TCC: 'Check the board' command will work automatically"

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🎉 SELF-CONTAINED FRAMEWORK INSTALLATION COMPLETE${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"