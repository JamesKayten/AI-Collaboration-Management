#!/bin/bash
# watch-pr.sh - Monitors GitHub for PRs awaiting review
#
# Usage: ./scripts/watch-pr.sh [interval_seconds]
# Default interval: 60 seconds
#
# Requires: gh CLI (GitHub CLI)

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
RESET='\033[0m'

INTERVAL=${1:-60}
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
REPO_NAME=$(basename "$REPO_ROOT" 2>/dev/null || echo "UNKNOWN")
STATE_FILE="/tmp/pr-watcher-${REPO_NAME}.state"

# Check if gh CLI is installed
if ! command -v gh &>/dev/null; then
    echo -e "${RED}ERROR: GitHub CLI (gh) not installed${RESET}"
    echo "Install: brew install gh"
    echo "Then authenticate: gh auth login"
    exit 1
fi

# Check if authenticated
if ! gh auth status &>/dev/null; then
    echo -e "${RED}ERROR: Not authenticated with GitHub CLI${RESET}"
    echo "Run: gh auth login"
    exit 1
fi

# Audio alert function - PR ready for review
# SOUND: Funk (funky, distinctive) - Different from Hero (OCC) and Glass (TCC)
play_alert() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Funk sound = PR awaiting review (distinctive, attention-getting)
        afplay /System/Library/Sounds/Funk.aiff 2>/dev/null &
    elif command -v paplay &>/dev/null; then
        paplay /usr/share/sounds/freedesktop/stereo/bell.oga 2>/dev/null &
    elif command -v aplay &>/dev/null; then
        aplay /usr/share/sounds/alsa/Front_Center.wav 2>/dev/null &
    else
        echo -e "\a"
    fi
}

echo -e "${BOLD}==================================${RESET}"
echo -e "${BOLD}PR WATCHER${RESET} - ${GREEN}$REPO_NAME${RESET}"
echo -e "${BOLD}==================================${RESET}"
echo -e "Monitoring for pull requests awaiting review"
echo "Polling every ${INTERVAL}s"
echo "Press Ctrl+C to stop"
echo ""

cd "$REPO_ROOT" || exit 1

# Get initial PR state
get_pr_state() {
    # Get PRs that are open and awaiting review
    # Format: PR_NUMBER|TITLE|AUTHOR|BRANCH
    gh pr list --state open --json number,title,author,headRefName \
        --jq '.[] | "\(.number)|\(.title)|\(.author.login)|\(.headRefName)"' 2>/dev/null
}

LAST_STATE=$(get_pr_state)
echo "$LAST_STATE" > "$STATE_FILE"

if [ -n "$LAST_STATE" ]; then
    echo -e "${YELLOW}⚠️  Open PRs detected at startup:${RESET}"
    echo "$LAST_STATE" | while IFS='|' read -r num title author branch; do
        echo -e "  → ${CYAN}#$num${RESET}: $title (by ${MAGENTA}$author${RESET})"
    done
    echo ""
fi

while true; do
    sleep "$INTERVAL"

    # Fetch latest from origin to detect push triggers
    git fetch origin --quiet 2>/dev/null

    # Get current PR state
    CURRENT_STATE=$(get_pr_state)

    if [[ "$CURRENT_STATE" != "$LAST_STATE" ]]; then
        # Something changed
        NEW_PRS=$(comm -13 <(echo "$LAST_STATE" | sort) <(echo "$CURRENT_STATE" | sort))
        CLOSED_PRS=$(comm -23 <(echo "$LAST_STATE" | sort) <(echo "$CURRENT_STATE" | sort))

        if [ -n "$NEW_PRS" ]; then
            echo ""
            echo -e "${BOLD}${MAGENTA}════════════════════════════════════════════════════════════${RESET}"
            echo -e "${BOLD}${MAGENTA}🔔 [$(date +%H:%M:%S)] NEW PR(S) AWAITING REVIEW!${RESET}"
            echo -e "${BOLD}${MAGENTA}════════════════════════════════════════════════════════════${RESET}"
            echo ""

            echo "$NEW_PRS" | while IFS='|' read -r num title author branch; do
                echo -e "  ${BOLD}${CYAN}#$num${RESET}: ${BOLD}$title${RESET}"
                echo -e "    Author: ${MAGENTA}$author${RESET}"
                echo -e "    Branch: ${CYAN}$branch${RESET}"
                echo ""
            done

            echo -e "${BOLD}Action:${RESET}"
            echo -e "  • View PR: ${CYAN}gh pr view <number>${RESET}"
            echo -e "  • Review in browser: ${CYAN}gh pr view <number> --web${RESET}"
            echo -e "  • Check diff: ${CYAN}git diff main...origin/$branch${RESET}"
            echo ""
            echo -e "${BOLD}${MAGENTA}════════════════════════════════════════════════════════════${RESET}"
            echo ""

            play_alert
        fi

        if [ -n "$CLOSED_PRS" ]; then
            echo -e "${GREEN}✅ [$(date +%H:%M:%S)] PR(s) closed/merged:${RESET}"
            echo "$CLOSED_PRS" | while IFS='|' read -r num title author branch; do
                echo -e "  → ${CYAN}#$num${RESET}: $title"
            done
            echo ""
        fi

        LAST_STATE="$CURRENT_STATE"
        echo "$CURRENT_STATE" > "$STATE_FILE"
    else
        echo -n "."  # Heartbeat
    fi
done
