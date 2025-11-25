#!/bin/bash
# aim-launcher.sh - AI Collaboration Management Launcher
#
# Opens iTerm2 with multiple tabs running watcher scripts:
# - Tab 1: Build Watcher (monitors Swift/Xcode builds)
# - Tab 2: Branch Watcher (monitors OCC branches)
# - Tab 3: Board Watcher (monitors BOARD.md for TCC tasks)
# - Tab 4: PR Watcher (monitors GitHub PRs)
#
# Usage: ./scripts/aim-launcher.sh [project_path]

set -e

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════${RESET}"
echo -e "${BOLD}${CYAN}   AIM LAUNCHER - AI Collaboration Management${RESET}"
echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════${RESET}"
echo ""

# Determine project path
if [ -n "$1" ]; then
    PROJECT_PATH="$1"
else
    PROJECT_PATH=$(git rev-parse --show-toplevel 2>/dev/null) || {
        echo -e "${RED}ERROR: Not in a git repository${RESET}"
        echo "Usage: $0 [project_path]"
        exit 1
    }
fi

# Validate project path
if [ ! -d "$PROJECT_PATH" ]; then
    echo -e "${RED}ERROR: Project path does not exist: $PROJECT_PATH${RESET}"
    exit 1
fi

SCRIPTS_DIR="$PROJECT_PATH/scripts"
if [ ! -d "$SCRIPTS_DIR" ]; then
    echo -e "${RED}ERROR: Scripts directory not found: $SCRIPTS_DIR${RESET}"
    exit 1
fi

PROJECT_NAME=$(basename "$PROJECT_PATH")

echo -e "${GREEN}✓${RESET} Project: ${CYAN}$PROJECT_NAME${RESET}"
echo -e "${GREEN}✓${RESET} Path: ${CYAN}$PROJECT_PATH${RESET}"
echo ""

# Check if iTerm2 is available
if [ ! -d "/Applications/iTerm.app" ]; then
    echo -e "${RED}ERROR: iTerm2 not found${RESET}"
    echo "Install iTerm2 from https://iterm2.com/"
    exit 1
fi

# Check if required scripts exist
REQUIRED_SCRIPTS=(
    "watch-build.sh"
    "watch-branches.sh"
    "watch-board.sh"
    "watch-pr.sh"
)

for script in "${REQUIRED_SCRIPTS[@]}"; do
    if [ ! -f "$SCRIPTS_DIR/$script" ]; then
        echo -e "${YELLOW}⚠️  Warning: $script not found${RESET}"
    fi
done

echo -e "${CYAN}Launching iTerm2 with watchers...${RESET}"
echo ""

# Create iTerm2 AppleScript to open tabs
osascript <<EOF
tell application "iTerm"
    activate

    -- Create new window
    set newWindow to (create window with default profile)

    tell current session of newWindow
        -- Tab 1: Build Watcher
        set name to "🔨 Build Watcher"
        write text "cd '$PROJECT_PATH' && clear"
        write text "echo '═══════════════════════════════════════════════════'"
        write text "echo '🔨 BUILD WATCHER - Monitoring Swift/Xcode builds'"
        write text "echo '═══════════════════════════════════════════════════'"
        write text "echo ''"
        write text "'$SCRIPTS_DIR/watch-build.sh' '$PROJECT_PATH'"
    end tell

    -- Tab 2: Branch Watcher (OCC)
    tell newWindow
        set newTab to (create tab with default profile)
        tell current session of newTab
            set name to "🌿 OCC Branch Watcher"
            write text "cd '$PROJECT_PATH' && clear"
            write text "echo '═══════════════════════════════════════════════════'"
            write text "echo '🌿 BRANCH WATCHER - OCC Activity'"
            write text "echo '   Sound: Hero = OCC branch ready'"
            write text "echo '═══════════════════════════════════════════════════'"
            write text "echo ''"
            write text "'$SCRIPTS_DIR/watch-branches.sh'"
        end tell
    end tell

    -- Tab 3: Board Watcher (TCC)
    tell newWindow
        set newTab to (create tab with default profile)
        tell current session of newTab
            set name to "📋 TCC Board Watcher"
            write text "cd '$PROJECT_PATH' && clear"
            write text "echo '═══════════════════════════════════════════════════'"
            write text "echo '📋 BOARD WATCHER - TCC Task Updates'"
            write text "echo '   Sound: Glass = TCC posted task'"
            write text "echo '═══════════════════════════════════════════════════'"
            write text "echo ''"
            write text "'$SCRIPTS_DIR/watch-board.sh'"
        end tell
    end tell

    -- Tab 4: PR Watcher
    tell newWindow
        set newTab to (create tab with default profile)
        tell current session of newTab
            set name to "🔔 PR Watcher"
            write text "cd '$PROJECT_PATH' && clear"
            write text "echo '═══════════════════════════════════════════════════'"
            write text "echo '🔔 PR WATCHER - Pull Requests Awaiting Review'"
            write text "echo '   Sound: Funk = PR needs your review'"
            write text "echo '═══════════════════════════════════════════════════'"
            write text "echo ''"
            write text "'$SCRIPTS_DIR/watch-pr.sh'"
        end tell
    end tell

    -- Focus first tab
    tell newWindow
        select first session
    end tell

end tell
EOF

echo ""
echo -e "${BOLD}${GREEN}✨ AIM LAUNCHER COMPLETE${RESET}"
echo ""
echo -e "${CYAN}iTerm2 tabs opened:${RESET}"
echo -e "  1. ${BOLD}🔨 Build Watcher${RESET} - Monitors builds (Basso = error, Blow = success)"
echo -e "  2. ${BOLD}🌿 Branch Watcher${RESET} - OCC activity (Hero = branch ready)"
echo -e "  3. ${BOLD}📋 Board Watcher${RESET} - TCC tasks (Glass = task posted)"
echo -e "  4. ${BOLD}🔔 PR Watcher${RESET} - Pull requests (Funk = review needed)"
echo ""
echo -e "${YELLOW}Audio Alert Legend:${RESET}"
echo -e "  • ${BOLD}Hero${RESET} = OCC finished work, branch ready"
echo -e "  • ${BOLD}Glass${RESET} = TCC posted task to board"
echo -e "  • ${BOLD}Funk${RESET} = PR needs your review"
echo -e "  • ${BOLD}Basso${RESET} = Build error"
echo -e "  • ${BOLD}Blow${RESET} = Build success"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════${RESET}"
echo -e "${CYAN}All watchers are now monitoring in background${RESET}"
echo -e "${CYAN}═══════════════════════════════════════════════════${RESET}"
