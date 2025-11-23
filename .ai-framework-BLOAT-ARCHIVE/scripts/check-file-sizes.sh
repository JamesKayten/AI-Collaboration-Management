#!/bin/bash
# File Size Compliance Checker
# Validates changed files against language-specific size limits
# Usage: bash check-file-sizes.sh [base-branch]
# Exit code 0 = All files compliant, Exit code 1 = Violations found

set -e

BASE_BRANCH="${1:-origin/main}"

echo "=========================================="
echo "FILE SIZE COMPLIANCE CHECK"
echo "=========================================="
echo ""
echo "Comparing against: $BASE_BRANCH"
echo ""

# Fetch latest to ensure accurate comparison
git fetch origin main --quiet 2>/dev/null || true

# Get all changed files compared to base branch
CHANGED_FILES=$(git diff --name-only $BASE_BRANCH...HEAD 2>/dev/null || git diff --name-only HEAD)

if [ -z "$CHANGED_FILES" ]; then
    echo "ℹ️  No files changed from base branch"
    exit 0
fi

echo "Files to validate:"
echo "$CHANGED_FILES" | sed 's/^/  - /'
echo ""

# Track violations
VIOLATIONS=0

# Define limits
declare -A FILE_LIMITS=(
    [".py"]=250
    [".js"]=150
    [".ts"]=150
    [".jsx"]=150
    [".tsx"]=150
    [".java"]=400
    [".go"]=300
    [".swift"]=300
    [".sh"]=200
    [".md"]=500
    [".yaml"]=300
    [".yml"]=300
    [".json"]=300
)

# Function to check file size
check_file_size() {
    local file="$1"
    local extension="${file##*.}"

    # Add dot prefix for lookup
    extension=".$extension"

    # Get limit for this extension
    local limit="${FILE_LIMITS[$extension]}"

    # Skip if no limit defined for this extension
    if [ -z "$limit" ]; then
        return 0
    fi

    # Check if file exists
    if [ ! -f "$file" ]; then
        return 0
    fi

    # Count lines
    local lines=$(wc -l < "$file" 2>/dev/null || echo "0")

    # Check against limit
    if [ "$lines" -gt "$limit" ]; then
        echo "❌ VIOLATION: $file"
        echo "   Lines: $lines (max: $limit for $extension files)"
        VIOLATIONS=$((VIOLATIONS + 1))
        return 1
    else
        echo "✅ $file ($lines/$limit lines)"
        return 0
    fi
}

# Check each changed file
echo "=== Validating Changed Files ==="
echo ""

while IFS= read -r file; do
    check_file_size "$file" || true
done <<< "$CHANGED_FILES"

echo ""
echo "=========================================="

if [ $VIOLATIONS -eq 0 ]; then
    echo "✅ ALL FILES COMPLIANT"
    echo "   Total files checked: $(echo "$CHANGED_FILES" | wc -l)"
    echo "   Violations found: 0"
    echo "=========================================="
    exit 0
else
    echo "❌ FILE SIZE VIOLATIONS FOUND"
    echo "   Total violations: $VIOLATIONS"
    echo "=========================================="
    echo ""
    echo "REQUIRED ACTION:"
    echo "  1. Split large files into smaller modules"
    echo "  2. Extract reusable components/functions"
    echo "  3. Follow single responsibility principle"
    echo ""
    echo "File size limits by type:"
    for ext in "${!FILE_LIMITS[@]}"; do
        printf "  %s files: %d lines\n" "$ext" "${FILE_LIMITS[$ext]}"
    done | sort
    echo ""
    exit 1
fi
