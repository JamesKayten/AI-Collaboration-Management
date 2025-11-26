#!/bin/bash
# AICM Install Script - adds claude wrapper function to shell

SHELL_CONFIG="$HOME/.zshrc"
[[ "$SHELL" == *"bash"* ]] && SHELL_CONFIG="$HOME/.bashrc"

FUNCTION_CODE='
# AICM: Auto-detect TCC projects and trigger auto-response
claude() {
    if [ -f "./tcc" ]; then
        ./tcc
    else
        command claude "$@"
    fi
}'

# Check if already installed
if grep -q "AICM: Auto-detect TCC" "$SHELL_CONFIG" 2>/dev/null; then
    echo "AICM already installed in $SHELL_CONFIG"
    exit 0
fi

# Add to shell config
echo "$FUNCTION_CODE" >> "$SHELL_CONFIG"
echo "Installed AICM claude wrapper to $SHELL_CONFIG"
echo "Run: source $SHELL_CONFIG"
echo ""
echo "Now 'claude' will auto-respond in AICM projects."
