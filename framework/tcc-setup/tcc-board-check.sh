#!/bin/bash

# TCC Board Check - Automated Collaboration Framework Status
# Usage: ./tcc-board-check.sh <repository_url> [branch]
# Purpose: Single command to get complete framework status and pending work

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
NC='\033[0m' # No Color

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🎯 TCC BOARD CHECK - AUTOMATED STATUS REPORT${NC}"
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
echo -e "${GREEN}✅ TCC BOARD CHECK COMPLETE${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"