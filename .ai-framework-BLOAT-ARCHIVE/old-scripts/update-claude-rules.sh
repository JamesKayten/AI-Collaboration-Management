#!/bin/bash
# UPDATE CLAUDE BEHAVIOR RULES
# Usage: ~/update-claude-rules.sh "new rule text"

RULES_FILE="/Volumes/User_Smallfavor/Users/Smallfavor/Documents/AI-Collaboration-Management/CLAUDE_BEHAVIOR_RULES.md"

if [ "$1" = "--edit" ]; then
    # Interactive edit
    nano "$RULES_FILE"
elif [ "$1" = "--add" ] && [ -n "$2" ]; then
    # Add new rule
    echo "- $2" >> "$RULES_FILE"
    echo "✅ Added rule: $2"
elif [ "$1" = "--show" ]; then
    # Show current rules
    cat "$RULES_FILE"
else
    echo "Usage:"
    echo "  ~/update-claude-rules.sh --add 'new rule'"
    echo "  ~/update-claude-rules.sh --edit"
    echo "  ~/update-claude-rules.sh --show"
    exit 1
fi

# Auto-commit changes
cd "/Volumes/User_Smallfavor/Users/Smallfavor/Documents/AI-Collaboration-Management"
git add CLAUDE_BEHAVIOR_RULES.md
git commit -m "Update Claude behavior rules

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>" 2>/dev/null

echo "✅ Rules updated and committed"
echo "💡 Next ./restore_session.sh will show updated rules to Claude"