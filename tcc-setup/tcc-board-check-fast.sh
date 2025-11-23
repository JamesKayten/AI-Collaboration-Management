#!/bin/bash

# TCC Board Check - FAST VERSION
# Usage: ./tcc-board-check-fast.sh <repository_url> [branch]
# Purpose: Quick board status without full repository clone

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

echo -e "${CYAN}🚀 FAST TCC BOARD CHECK${NC}"
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
    echo -e "${GREEN}✅ AI Framework:${NC} Active"
else
    echo -e "${RED}❌ AI Framework:${NC} Not found"
fi

if [ "$BOARD_PRESENT" = true ]; then
    echo -e "${GREEN}✅ TCC Board:${NC} Available"
else
    echo -e "${YELLOW}⚠️  TCC Board:${NC} Not configured"
fi

echo ""

# Provide next steps
if [ "$FRAMEWORK_FOUND" = true ] && [ "$BOARD_PRESENT" = true ]; then
    echo -e "${GREEN}🎯 STATUS: Ready for TCC collaboration${NC}"
    echo -e "${BLUE}💡 For detailed analysis:${NC}"
    echo "   curl -sSL https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/tcc-setup/tcc-board-check.sh | bash -s $REPO_URL"
elif [ "$FRAMEWORK_FOUND" = true ]; then
    echo -e "${YELLOW}⚠️  STATUS: Framework found, needs TCC board setup${NC}"
    echo -e "${BLUE}💡 To add TCC board:${NC}"
    echo "   curl -sSL https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/tcc-setup/add-board-file.sh | bash"
else
    echo -e "${RED}❌ STATUS: No collaboration framework detected${NC}"
    echo -e "${BLUE}💡 This repository doesn't have the AI Collaboration Framework${NC}"
fi

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}⚡ FAST BOARD CHECK COMPLETE ($(date))${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"