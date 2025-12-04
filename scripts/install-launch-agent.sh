#!/bin/bash
# Install AIM Watcher Launch Agent for macOS
# This starts iTerm watcher windows automatically on login

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PLIST_NAME="com.aim.watcher.plist"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_PATH="$LAUNCH_AGENTS_DIR/$PLIST_NAME"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
echo -e "${CYAN}   AIM Watcher Launch Agent Installer${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
echo ""

# Check for macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}ERROR: This script is for macOS only${NC}"
    exit 1
fi

# Check for iTerm
if [ ! -d "/Applications/iTerm.app" ]; then
    echo -e "${RED}ERROR: iTerm2 not found at /Applications/iTerm.app${NC}"
    exit 1
fi

# Create LaunchAgents directory if needed
mkdir -p "$LAUNCH_AGENTS_DIR"

# Unload existing agent if present
if [ -f "$PLIST_PATH" ]; then
    echo "Unloading existing agent..."
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
fi

# Create the plist file
cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.aim.watcher</string>
    <key>ProgramArguments</key>
    <array>
        <string>$REPO_ROOT/scripts/aim-launcher.sh</string>
        <string>$REPO_ROOT</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>StandardOutPath</key>
    <string>/tmp/aim-launcher.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/aim-launcher.err</string>
</dict>
</plist>
EOF

echo -e "${GREEN}✓${NC} Created Launch Agent: $PLIST_PATH"

# Load the agent
launchctl load "$PLIST_PATH"
echo -e "${GREEN}✓${NC} Loaded Launch Agent"

# Start it now
launchctl start com.aim.watcher
echo -e "${GREEN}✓${NC} Started Launch Agent"

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}   Installation Complete${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""
echo "AIM watchers will now start automatically on login."
echo ""
echo "Commands:"
echo "  Stop:    launchctl stop com.aim.watcher"
echo "  Start:   launchctl start com.aim.watcher"
echo "  Unload:  launchctl unload $PLIST_PATH"
echo "  Logs:    tail -f /tmp/aim-launcher.log"
echo ""
