#!/bin/bash
# Create a custom phrase command in 3 questions

echo "🎯 CREATE YOUR CUSTOM PHRASE"
echo "============================="
echo

# Question 1: What phrase?
read -p "What phrase do you want to use? (e.g., 'shit's ready'): " PHRASE

# Question 2: What should it do?
echo
echo "What should it do? Examples:"
echo "  - Run a script: /path/to/script.sh"
echo "  - Give instructions: 'Fix all validation violations'"
echo "  - Multiple steps: 'Run tests, then deploy'"
echo
read -p "Enter command or instructions: " ACTION

# Question 3: Short description
read -p "Short description (optional): " DESC
DESC="${DESC:-Run custom command}"

# Generate filename from phrase
FILENAME=$(echo "$PHRASE" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '-' | tr -d "'" | sed 's/[^a-z0-9-]//g')
COMMAND_FILE=".claude/commands/${FILENAME}.md"

# Create command file
mkdir -p .claude/commands

cat > "$COMMAND_FILE" << EOF
---
description: ${DESC}
aliases: ["${PHRASE}"]
---

${ACTION}
EOF

echo
echo "✅ Created command: $COMMAND_FILE"
echo
echo "NOW YOU CAN SAY: \"${PHRASE}\""
echo "And Claude will: ${ACTION}"
echo
echo "To add more phrases that trigger the same action:"
echo "  Edit: $COMMAND_FILE"
echo "  Add to aliases: [\"${PHRASE}\", \"phrase 2\", \"phrase 3\"]"
