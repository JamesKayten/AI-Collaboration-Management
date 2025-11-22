---
description: Verify OCC/TCC framework collaboration test results
---

Verify that framework validation and collaboration workflows are functioning correctly.

## Verification Steps

### 1. Repository Sync Verification

```bash
# Verify pre-work sync
bash .ai-framework/scripts/pre-work-sync.sh
```

Expected: Shows "PRE-WORK SYNC COMPLETE ✅"

### 2. File Size Compliance Check

```bash
# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Check file size compliance against main
bash .ai-framework/scripts/check-file-sizes.sh origin/main
```

Expected: Shows "✅ All files comply with size limits"

### 3. Verify Session Logging

```bash
# Check for session logs
source .ai-framework/scripts/session-logging.sh
check_incomplete_session
```

### 4. Check Recent AI Communication

```bash
# Show recent collaboration logs (if they exist)
if [ -f .ai-framework/logs/sync.log ]; then
  echo "Recent sync activity:"
  tail -10 .ai-framework/logs/sync.log
fi

# Show session logs if available
if [ -d .ai-framework/session-logs ]; then
  echo ""
  echo "Recent session logs:"
  ls -lt .ai-framework/session-logs/ | head -5
fi
```

### 5. Verify Slash Commands

```bash
# List available slash commands
echo "Available slash commands:"
ls -1 .claude/commands/*.md | sed 's|.claude/commands/||' | sed 's|.md$||'
```

## Success Criteria

✅ All checks pass with no errors
✅ Repository is synced with remote
✅ All files comply with size limits
✅ Framework scripts are functional
✅ Collaboration infrastructure is in place

Report results to user with specific pass/fail status for each check.
