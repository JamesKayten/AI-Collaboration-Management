#!/bin/bash

# Fix SlashCommand permission error
# Run this in any repository having SlashCommand issues

mkdir -p .claude/commands

cat > .claude/commands/check-the-board.md << 'EOF'
---
description: Read framework status files and report current status (file reading only)
aliases: ["Check the Board", "check the board", "check board", "board check", "tcc board", "status check"]
---

Read these files directly and report the status:

1. Read `.ai-framework/CURRENT_BOARD_STATUS.md`
2. Read `.ai-framework/CHECK_THE_BOARD.md`

Report the framework status, pending tasks, and next steps based on the file contents.

Do not execute any commands or tools - only read and report the file contents.
EOF

echo "✅ SlashCommand fixed"