#!/bin/bash

# AI Collaboration Framework - Migration Script
# Usage: ./migrate-to-self-contained.sh
# Purpose: Migrate from master-repository-dependent framework to self-contained

set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR=".ai-framework-backup-${TIMESTAMP}"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🔄 AI COLLABORATION FRAMEWORK MIGRATION${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${BLUE}📋 Migration:${NC} Master-dependent → Self-contained"
echo -e "${BLUE}📁 Repository:${NC} $(basename $(pwd))"
echo -e "${BLUE}📅 Migration Time:${NC} $(date)"
echo ""

# Check if framework exists
if [ ! -d ".ai-framework" ]; then
    echo -e "${RED}❌ No .ai-framework directory found${NC}"
    echo -e "${YELLOW}💡 This repository doesn't have the framework installed${NC}"
    echo -e "${YELLOW}💡 Use install-framework-complete.sh instead${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Existing framework detected${NC}"
echo ""

# Get repository URL
REPO_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [ -z "$REPO_URL" ]; then
    echo -e "${RED}❌ No git remote origin found${NC}"
    echo -e "${YELLOW}Please provide repository URL:${NC}"
    read -p "Repository URL: " REPO_URL

    if [ -z "$REPO_URL" ]; then
        echo -e "${RED}❌ No repository URL provided${NC}"
        exit 1
    fi
fi

echo -e "${BLUE}🔗 Repository URL:${NC} $REPO_URL"
echo ""

# Create backup
echo -e "${YELLOW}💾 Creating backup...${NC}"
cp -r .ai-framework "$BACKUP_DIR"
if [ -f "BOARD.md" ]; then
    cp BOARD.md "$BACKUP_DIR/BOARD.md.backup"
fi
echo -e "${GREEN}✅ Backup created:${NC} $BACKUP_DIR"
echo ""

# Analyze existing framework
echo -e "${YELLOW}🔍 Analyzing existing framework...${NC}"

OLD_FRAMEWORK_TYPE="unknown"
MASTER_REPO_DEPENDENCY=false

if [ -f "BOARD.md" ]; then
    if grep -q "curl.*githubusercontent" BOARD.md; then
        OLD_FRAMEWORK_TYPE="master-dependent"
        MASTER_REPO_DEPENDENCY=true
        echo -e "${YELLOW}⚠️  Detected master repository dependency${NC}"
    fi
fi

if [ -d ".ai-framework/tools" ]; then
    TOOL_COUNT=$(find .ai-framework/tools -name "*.sh" 2>/dev/null | wc -l)
    if [ "$TOOL_COUNT" -gt 0 ]; then
        echo -e "${BLUE}📊 Found $TOOL_COUNT embedded tools${NC}"
        OLD_FRAMEWORK_TYPE="partially-self-contained"
    fi
else
    echo -e "${YELLOW}⚠️  No tools directory found${NC}"
fi

echo -e "${BLUE}🔧 Framework Type:${NC} $OLD_FRAMEWORK_TYPE"
echo ""

# Preserve existing communications and project state
echo -e "${YELLOW}📋 Preserving existing data...${NC}"

PRESERVED_ITEMS=()

if [ -d ".ai-framework/communications" ]; then
    echo -e "${GREEN}✅ Preserving communications${NC}"
    PRESERVED_ITEMS+=("communications")
fi

if [ -d ".ai-framework/project-state" ]; then
    echo -e "${GREEN}✅ Preserving project state${NC}"
    PRESERVED_ITEMS+=("project-state")
fi

if [ -d ".ai-framework/rules" ]; then
    echo -e "${GREEN}✅ Preserving rules${NC}"
    PRESERVED_ITEMS+=("rules")
fi

echo ""

# Install self-contained framework
echo -e "${YELLOW}🚀 Installing self-contained framework...${NC}"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if installer exists
if [ ! -f "$SCRIPT_DIR/install-framework-complete.sh" ]; then
    echo -e "${RED}❌ Installer not found: $SCRIPT_DIR/install-framework-complete.sh${NC}"
    echo -e "${YELLOW}💡 Please ensure install-framework-complete.sh is in the same directory${NC}"
    exit 1
fi

# Run installer (this will overwrite framework files)
"$SCRIPT_DIR/install-framework-complete.sh" "$REPO_URL"

echo ""
echo -e "${YELLOW}🔄 Restoring preserved data...${NC}"

# Restore preserved items
for item in "${PRESERVED_ITEMS[@]}"; do
    if [ -d "$BACKUP_DIR/$item" ]; then
        # Merge instead of replace to keep both old and new files
        cp -rn "$BACKUP_DIR/$item"/* ".ai-framework/$item/" 2>/dev/null || true
        echo -e "${GREEN}✅ Restored:${NC} $item"
    fi
done

echo ""

# Migration report
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}📊 MIGRATION REPORT${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${BLUE}🎯 Migration Status:${NC} Complete"
echo -e "${BLUE}📦 Framework Version:${NC} v2.0 Self-Contained"
echo -e "${BLUE}💾 Backup Location:${NC} $BACKUP_DIR"
echo ""

echo -e "${GREEN}✅ Changes Made:${NC}"

if [ "$MASTER_REPO_DEPENDENCY" = true ]; then
    echo "   • BOARD.md updated (curl commands → local tools)"
fi

echo "   • Tools embedded in .ai-framework/tools/"
echo "   • Self-contained installer added"
echo "   • OCC discovery file created"
echo "   • Project state updated"
echo "   • Validation rules embedded"
echo ""

if [ "${#PRESERVED_ITEMS[@]}" -gt 0 ]; then
    echo -e "${GREEN}✅ Preserved Data:${NC}"
    for item in "${PRESERVED_ITEMS[@]}"; do
        echo "   • $item (merged with new framework)"
    done
    echo ""
fi

echo -e "${YELLOW}⚠️  Key Differences:${NC}"
echo "   • BOARD.md now references LOCAL tools (.ai-framework/tools/)"
echo "   • No external curl commands"
echo "   • Framework works completely offline"
echo "   • All tools customizable per repository"
echo ""

echo -e "${BLUE}🧪 Testing:${NC}"
echo "   # Test fast board check"
echo "   ./.ai-framework/tools/tcc-board-check-fast.sh $REPO_URL"
echo ""
echo "   # Test file compliance"
echo "   ./.ai-framework/tools/tcc-file-compliance.sh main"
echo ""

echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. Review changes:"
echo "   git status"
echo "   git diff BOARD.md"
echo ""
echo "2. Test framework:"
echo "   ./.ai-framework/tools/tcc-board-check-fast.sh $REPO_URL"
echo ""
echo "3. Commit migration:"
echo "   git add ."
echo "   git commit -m \"Migrate to self-contained AI collaboration framework v2.0\""
echo "   git push"
echo ""
echo "4. Verify backup (keep for safety):"
echo "   ls -la $BACKUP_DIR"
echo ""
echo "5. Optional: Remove backup after verification"
echo "   rm -rf $BACKUP_DIR"
echo ""

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ MIGRATION TO SELF-CONTAINED FRAMEWORK COMPLETE${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}🎉 Your framework is now self-contained and independent!${NC}"
echo -e "${GREEN}🔒 Repository can now be private without breaking framework users${NC}"
echo -e "${GREEN}📦 All tools work offline with no external dependencies${NC}"
