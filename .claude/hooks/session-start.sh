#!/bin/bash
# SessionStart hook - outputs JSON additionalContext for Claude
# Terminal output goes to stderr (user sees it), JSON goes to stdout (Claude sees it)

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
REPO_NAME=$(basename "$REPO_ROOT" 2>/dev/null || echo "UNKNOWN")
BOARD_FILE="$REPO_ROOT/docs/BOARD.md"
PENDING_FILE="/tmp/branch-watcher-${REPO_NAME}.pending"
ROLE_FILE="$REPO_ROOT/.claude/role.local"

cd "$REPO_ROOT" || exit 1

# Read role configuration (TCC or OCC)
# Priority: 1) Explicit role.local file  2) Auto-detect by environment
ROLE=""
if [ -f "$ROLE_FILE" ]; then
    # Explicit configuration takes priority
    ROLE=$(cat "$ROLE_FILE" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
else
    # Auto-detect: macOS = TCC (local supervisor), otherwise = OCC (remote developer)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ROLE="TCC"
    else
        ROLE="OCC"
    fi
fi

# --- Terminal output (stderr) for user to see ---
exec 3>&1  # Save stdout
exec 1>&2  # Redirect stdout to stderr for user-visible output

echo "================================================================================"
echo "AICM SESSION START"
echo "================================================================================"

# Display role status
if [ -f "$ROLE_FILE" ]; then
    ROLE_SOURCE="(configured)"
else
    ROLE_SOURCE="(auto-detected)"
fi

if [ "$ROLE" = "TCC" ]; then
    echo "ROLE: TCC (Project Manager) $ROLE_SOURCE"
else
    echo "ROLE: OCC (Developer) $ROLE_SOURCE"
fi

echo ""
echo "Syncing with GitHub..."

git fetch origin main --quiet 2>/dev/null

LOCAL_HASH=$(git rev-parse HEAD 2>/dev/null | cut -c1-7)
REMOTE_HASH=$(git rev-parse origin/main 2>/dev/null | cut -c1-7)

if [[ "$LOCAL_HASH" != "$REMOTE_HASH" ]]; then
    echo "Local is behind remote. Pulling latest..."
    git pull origin main --quiet 2>/dev/null
    LOCAL_HASH=$(git rev-parse HEAD 2>/dev/null | cut -c1-7)
fi

SYNC_STATUS="IN SYNC"
[[ "$LOCAL_HASH" != "$REMOTE_HASH" ]] && SYNC_STATUS="OUT OF SYNC"

echo "Local: $LOCAL_HASH | Remote: $REMOTE_HASH | $SYNC_STATUS"

# Check pending branches
PENDING_BRANCHES=""
if [ -f "$PENDING_FILE" ] && [ -s "$PENDING_FILE" ]; then
    PENDING_BRANCHES=$(cat "$PENDING_FILE")
    echo "PENDING OCC BRANCHES:"
    echo "$PENDING_BRANCHES"
fi

BRANCH=$(git branch --show-current 2>/dev/null || echo "main")

# Launch watchers (macOS only)
AIM_LAUNCHER="$REPO_ROOT/scripts/aim-launcher.sh"
AIM_PID_FILE="/tmp/aim-launcher-${REPO_NAME}.pid"

if [ -f "$AIM_LAUNCHER" ]; then
    if [ -f "$AIM_PID_FILE" ] && ps -p "$(cat "$AIM_PID_FILE")" > /dev/null 2>&1; then
        echo "Watchers already running"
    else
        if [[ "$OSTYPE" == "darwin"* ]] && [ -d "/Applications/iTerm.app" ]; then
            "$AIM_LAUNCHER" "$REPO_ROOT" > /dev/null 2>&1 &
            echo $! > "$AIM_PID_FILE"
            echo "Launched iTerm2 watchers"
        fi
    fi
fi

echo "================================================================================"
echo "Hook complete. Context sent to Claude."
echo "================================================================================"

# --- JSON output (stdout) for Claude ---
exec 1>&3  # Restore stdout

# Get board content
BOARD_CONTENT=""
if [ -f "$BOARD_FILE" ]; then
    BOARD_CONTENT=$(cat "$BOARD_FILE")
fi

# Build context string based on role
if [ "$ROLE" = "TCC" ]; then
    CONTEXT="YOU ARE TCC (Project Manager) in repository: $REPO_NAME
Branch: $BRANCH
Local: $LOCAL_HASH | Remote: $REMOTE_HASH | Status: $SYNC_STATUS

"
    if [ -n "$PENDING_BRANCHES" ]; then
        CONTEXT+="⚠️ PENDING OCC BRANCHES WAITING FOR REVIEW:
$PENDING_BRANCHES

ACTION REQUIRED: Check if these branches are already in COMPLETED section below.
- If already completed: delete stale branch (git push origin --delete <branch>) and clear pending file (rm -f /tmp/branch-watcher-*.pending)
- If NOT completed: run /works-ready to validate and merge

"
    fi
    CONTEXT+="=== BOARD STATUS ===
$BOARD_CONTENT
=== END BOARD ===

DIRECTIVE: You are TCC. Do this NOW:
1. Say: 'I am TCC in $REPO_NAME, ready to work.'
2. If pending branches above exist and are NOT in COMPLETED section, run /works-ready
3. If pending branches are already COMPLETED, delete the stale branch and clear pending file
4. If no pending work, say 'No work pending, standing by.'

DO NOT ASK PERMISSION. ACT IMMEDIATELY."

else
    # OCC (Developer) - default for non-macOS or explicit config
    CONTEXT="YOU ARE OCC (Developer) in repository: $REPO_NAME
Branch: $BRANCH
Local: $LOCAL_HASH | Remote: $REMOTE_HASH | Status: $SYNC_STATUS

=== BOARD STATUS ===
$BOARD_CONTENT
=== END BOARD ===

DIRECTIVE: You are OCC. Do this NOW:
1. Say: 'I am OCC in $REPO_NAME, ready to work.'
2. Check the board for tasks assigned to OCC (Tasks FOR OCC section)
3. If tasks exist, acknowledge them and ask what to work on first
4. If no tasks, say 'No tasks assigned. What would you like me to build?'

You write code and commit to feature branches. You do NOT merge to main."
fi

# Escape for JSON
CONTEXT_ESCAPED=$(echo "$CONTEXT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')

# Output JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": $CONTEXT_ESCAPED
  }
}
EOF

exit 0
