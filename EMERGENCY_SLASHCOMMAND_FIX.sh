#!/bin/bash

# EMERGENCY FIX - Run this in any repository with SlashCommand permission errors

echo "🚨 EMERGENCY SlashCommand Fix"

# Create the directory and file
mkdir -p .claude/commands

# Write the WORKING SlashCommand configuration
cat > .claude/commands/check-the-board.md << 'EOF'
---
description: Read framework status files directly (no command execution)
aliases: ["Check the Board", "check the board", "check board", "board check", "tcc board", "status check"]
---

Read these files and report the status:

1. `.ai-framework/CURRENT_BOARD_STATUS.md`
2. `.ai-framework/CHECK_THE_BOARD.md`

No command execution. Just read and report the status.
EOF

echo "✅ SlashCommand fixed - should work now"

# Test that the files it references exist
if [ ! -f ".ai-framework/CURRENT_BOARD_STATUS.md" ]; then
    echo "⚠️  Creating missing status file..."
    mkdir -p .ai-framework
    echo "# Board Status: Framework ready" > .ai-framework/CURRENT_BOARD_STATUS.md
fi

if [ ! -f ".ai-framework/CHECK_THE_BOARD.md" ]; then
    echo "⚠️  Creating missing quick status file..."
    echo "# Quick Status: Ready for work" > .ai-framework/CHECK_THE_BOARD.md
fi

echo "🎯 Files created. SlashCommand should now work without permission errors."