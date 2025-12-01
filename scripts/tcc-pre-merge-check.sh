#!/bin/bash

# TCC Pre-Merge Compliance Check
# Usage: ./tcc-pre-merge-check.sh [target_branch]
# Purpose: Complete pre-merge validation including file compliance

set -e

# Detect repo root and ensure we're working from there
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
cd "$REPO_ROOT"

TARGET_BRANCH="${1:-main}"
CURRENT_BRANCH=$(git branch --show-current)

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🔒 TCC PRE-MERGE VALIDATION${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "${BLUE}🔧 Branch:${NC} $CURRENT_BRANCH → $TARGET_BRANCH"
echo -e "${BLUE}📅 Time:${NC} $(date)"
echo ""

# Step 1: Check if target branch exists
echo -e "${YELLOW}🔍 Step 1: Validating target branch...${NC}"
if ! git rev-parse --verify "$TARGET_BRANCH" >/dev/null 2>&1; then
    echo -e "${RED}❌ Target branch '$TARGET_BRANCH' not found${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Target branch exists${NC}"

# Step 2: Check for uncommitted changes
echo -e "${YELLOW}🔍 Step 2: Checking for uncommitted changes...${NC}"
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}❌ Uncommitted changes detected${NC}"
    echo -e "${YELLOW}Please commit or stash changes before merge validation${NC}"
    exit 1
fi
echo -e "${GREEN}✅ No uncommitted changes${NC}"

# Step 3: File size compliance check
echo -e "${YELLOW}🔍 Step 3: Running file size compliance check...${NC}"
if ! ./scripts/tcc-file-compliance.sh "$TARGET_BRANCH"; then
    echo ""
    echo -e "${RED}🚫 MERGE BLOCKED: File size compliance failed${NC}"
    echo -e "${YELLOW}📝 Violation report created in reports/${NC}"
    echo -e "${BLUE}🔧 Action Required: Fix file size violations before merge${NC}"
    exit 1
fi

# Step 4: Skipped (framework sync removed per Hard Disconnect Protocol)

# Step 5: Check for merge conflicts
echo -e "${YELLOW}🔍 Step 5: Checking for potential merge conflicts...${NC}"
git fetch origin "$TARGET_BRANCH" >/dev/null 2>&1 || true
if ! git merge-tree $(git merge-base HEAD origin/$TARGET_BRANCH) HEAD origin/$TARGET_BRANCH >/dev/null 2>&1; then
    echo -e "${RED}❌ Potential merge conflicts detected${NC}"
    echo -e "${YELLOW}Resolve conflicts before merge${NC}"
    exit 1
fi
echo -e "${GREEN}✅ No merge conflicts detected${NC}"

# Step 6: Generate merge summary
echo ""
echo -e "${YELLOW}📋 Step 6: Generating merge summary...${NC}"

COMMITS_TO_MERGE=$(git rev-list --count origin/$TARGET_BRANCH..HEAD 2>/dev/null || echo "0")
FILES_CHANGED=$(git diff --name-only origin/$TARGET_BRANCH...HEAD 2>/dev/null | wc -l || echo "0")

echo -e "${BLUE}📊 Merge Summary:${NC}"
echo -e "${BLUE}   Commits to merge:${NC} $COMMITS_TO_MERGE"
echo -e "${BLUE}   Files changed:${NC} $FILES_CHANGED"

if [[ $COMMITS_TO_MERGE -gt 0 ]]; then
    echo -e "${BLUE}   Recent commits:${NC}"
    git log --oneline origin/$TARGET_BRANCH..HEAD | head -5 | sed 's/^/     /'
fi

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ PRE-MERGE VALIDATION PASSED${NC}"
echo -e "${GREEN}🚀 Branch ready for merge to $TARGET_BRANCH${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo ""
echo -e "${BLUE}🔄 Recommended merge commands:${NC}"
echo "   git checkout $TARGET_BRANCH"
echo "   git pull origin $TARGET_BRANCH"
echo "   git merge $CURRENT_BRANCH --no-ff"
echo "   git push origin $TARGET_BRANCH"

echo ""
echo -e "${GREEN}✅ TCC PRE-MERGE VALIDATION COMPLETE${NC}"