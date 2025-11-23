#!/bin/bash

# Add BOARD.md file to repository for TCC board checking
# Usage: ./add-board-file.sh [repository_url]

set -e

# Get repository URL from git remote if not provided
if [ -z "$1" ]; then
    REPO_URL=$(git remote get-url origin 2>/dev/null || echo "")
    if [ -z "$REPO_URL" ]; then
        echo "❌ Error: No repository URL provided and no git remote found"
        echo "Usage: $0 <repository_url>"
        exit 1
    fi
else
    REPO_URL="$1"
fi

echo "🔧 Adding BOARD.md file for TCC board checking..."
echo "📋 Repository: $REPO_URL"

# Create BOARD.md file
cat > BOARD.md << EOF
# TCC Board Status

**Automated AI Collaboration Framework Status Check**

## 🎯 Quick Status Command

Execute this single command for complete framework status:

\`\`\`bash
curl -sSL https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/tcc-setup/tcc-board-check.sh | bash -s $REPO_URL
\`\`\`

## 📋 What You'll Get

- ✅ Complete framework discovery and configuration
- ✅ All collaboration parameters loaded
- ✅ Previous session/progress state recovered
- ✅ New work needing verification identified
- ✅ Prioritized action plan
- ✅ Ready-to-use work environment

## 🚀 Expected Output

\`\`\`
🎯 TCC BOARD CHECK - AUTOMATED STATUS REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 TCC STATUS SUMMARY
✅ Framework discovered automatically
✅ All collaboration parameters loaded
✅ Session state recovered
✅ Pending work identified

⚡ IMMEDIATE ACTIONS REQUIRED:
1. Review and test feature branches
2. Process TCC validation reports
3. Read OCC handoff updates

🚀 QUICK REFERENCE
📁 Work Directory: /tmp/tcc-board-check-[timestamp]
🔧 Test Feature Branch: git checkout <branch_name>
\`\`\`

## 🔄 AI Collaboration Framework

This repository uses the AI Collaboration Framework for OCC/TCC development workflows.

**Framework Location:** \`.ai-framework/\`

**Key Files:**
- Project state: \`.ai-framework/project-state/PROJECT_STATE.md\`
- Validation rules: \`.ai-framework/rules/\`
- Communications: \`.ai-framework/communications/\`

## ⚡ Run the Command Above

Execute the curl command to get complete automated collaboration status for this repository.
EOF

echo "✅ BOARD.md file created successfully!"
echo ""
echo "🔍 File contents preview:"
head -10 BOARD.md
echo "..."
echo ""
echo "📋 Next steps:"
echo "1. Review the BOARD.md file"
echo "2. Commit and push: git add BOARD.md && git commit -m 'Add TCC board check file' && git push"
echo ""
echo "🎯 Now TCC can run 'check the board' and will automatically find this file!"