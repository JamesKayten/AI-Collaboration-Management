#!/bin/bash
# AICM Update Script - updates existing claude wrapper function with new auto-TCC functionality

SHELL_CONFIG="$HOME/.zshrc"
[[ "$SHELL" == *"bash"* ]] && SHELL_CONFIG="$HOME/.bashrc"

echo "🔄 Updating AICM claude wrapper..."

# Check if AICM is installed
if ! grep -q "AICM:" "$SHELL_CONFIG" 2>/dev/null; then
    echo "❌ AICM not found in $SHELL_CONFIG"
    echo "Run ./install.sh to install AICM"
    exit 1
fi

# Backup current shell config
cp "$SHELL_CONFIG" "$SHELL_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
echo "✅ Backed up $SHELL_CONFIG"

# Remove old AICM function
sed -i.tmp '/# AICM:/,/^}/d' "$SHELL_CONFIG" && rm "$SHELL_CONFIG.tmp"
echo "✅ Removed old AICM function"

# Add new function code
NEW_FUNCTION_CODE='
# AICM: Auto-detect TCC projects with automatic TCC initialization
claude() {
    if [ -f "./tcc" ]; then
        # Get repository name for session identification
        REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || echo "UNKNOWN")

        echo "🚀 Initializing TCC session for $REPO_NAME..."

        # Check for pending OCC branches to determine what to auto-execute
        PENDING_FILE="/tmp/branch-watcher-${REPO_NAME}.pending"
        if [ -f "$PENDING_FILE" ] && [ -s "$PENDING_FILE" ]; then
            PENDING_COUNT=$(wc -l < "$PENDING_FILE" | tr -d ' ')
            echo "📋 Found $PENDING_COUNT pending branch(es) - auto-executing works-ready workflow..."
            TCC_PROMPT="/works-ready"
        else
            echo "📋 No pending branches - initializing as TCC..."
            TCC_PROMPT="You are starting in an AICM TCC project. Initialize as TCC (Project Manager) and respond only with: TCC - Role and Rules Confirmed. Standing by."
        fi

        # Auto-submit appropriate command in headless mode
        SESSION_OUTPUT=$(command claude -p "$TCC_PROMPT" --output-format json 2>/dev/null)

        if [ $? -eq 0 ] && [ -n "$SESSION_OUTPUT" ]; then
            # Extract session ID - try multiple methods for robustness
            SESSION_ID=$(echo "$SESSION_OUTPUT" | python3 -c "import sys, json; print(json.loads(sys.stdin.read()).get('session_id', ''))" 2>/dev/null)
            [ -z "$SESSION_ID" ] && SESSION_ID=$(echo "$SESSION_OUTPUT" | grep -o '"session_id":"[^"]*"' | cut -d'"' -f4)

            if [ -n "$SESSION_ID" ]; then
                if [ "$TCC_PROMPT" = "/works-ready" ]; then
                    echo "✅ Works-ready workflow completed - resuming session $SESSION_ID"
                else
                    echo "✅ TCC initialized - resuming session $SESSION_ID"
                fi
                echo ""
                command claude --resume "$SESSION_ID"
            else
                echo "⚠️  Session management failed - starting normally"
                command claude
            fi
        else
            echo "⚠️  Auto-initialization failed - starting normally"
            command claude
        fi
    else
        command claude "$@"
    fi
}'

echo "$NEW_FUNCTION_CODE" >> "$SHELL_CONFIG"
echo "✅ Installed new AICM function with auto-TCC initialization"

echo ""
echo "🎉 AICM Update Complete!"
echo ""
echo "Run: source $SHELL_CONFIG"
echo "Then: cd to your AICM project and type 'claude'"
echo ""
echo "The new claude wrapper will automatically:"
echo "  1. Check for pending OCC branches"
echo "  2. If branches pending → Auto-execute /works-ready workflow"
echo "  3. If no branches → Initialize as TCC normally"
echo "  4. Resume session interactively with full context"