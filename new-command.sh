#!/bin/bash
# Quick command creator - makes custom Claude commands in 10 seconds

if [ $# -lt 1 ]; then
    echo "Usage: ./new-command.sh COMMANDNAME"
    echo "Example: ./new-command.sh verify"
    exit 1
fi

COMMAND_NAME="$1"
COMMAND_FILE=".claude/commands/${COMMAND_NAME}.md"

mkdir -p .claude/commands

cat > "$COMMAND_FILE" << 'EOF'
---
description: [EDIT: Describe what this command does]
---

[EDIT: Add instructions for Claude here]

Example:
```bash
./your-script.sh
```

Or give high-level instructions like:
"Fix all validation violations and push to GitHub"
EOF

echo "✅ Created: $COMMAND_FILE"
echo
echo "Edit the file to customize your command:"
echo "  nano $COMMAND_FILE"
echo
echo "Then use it with: /$COMMAND_NAME"
