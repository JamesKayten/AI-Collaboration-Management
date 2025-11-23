#!/bin/bash

# Fix SlashCommand permission error
# Run this in any repository having SlashCommand issues

mkdir -p .claude/commands

cat > .claude/commands/check-the-board.md << 'EOF'
---
description: Get current framework status by reading board status files (no command execution)
aliases: ["Check the Board", "check the board", "check board", "board check", "tcc board", "status check"]
---

Read `.ai-framework/CURRENT_BOARD_STATUS.md` and report the framework status. No commands needed.
EOF

echo "✅ SlashCommand fixed"