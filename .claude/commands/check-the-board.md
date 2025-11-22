---
description: Verify framework test is complete and working
aliases: ["Check the Board", "check the board", "verify test", "test ready", "check it", "ready"]
---

Check current project status and verify framework integration.

```bash
echo "📊 PROJECT STATUS CHECK"
echo "==============================="
echo

# 1. Git Status
echo "📂 Repository Status:"
git status --short
CURRENT_BRANCH=$(git branch --show-current)
echo "   Branch: $CURRENT_BRANCH"
echo

# 2. Framework Integration Check
echo "🔧 Framework Components:"
if [ -d .ai-framework ]; then
    echo "   ✅ .ai-framework/ directory present"

    # Check for key scripts
    [ -f .ai-framework/scripts/pre-work-sync.sh ] && echo "   ✅ Pre-work sync script" || echo "   ❌ Pre-work sync script missing"
    [ -f .ai-framework/scripts/post-work-sync.sh ] && echo "   ✅ Post-work sync script" || echo "   ❌ Post-work sync script missing"
    [ -f .ai-framework/scripts/session-logging.sh ] && echo "   ✅ Session logging script" || echo "   ❌ Session logging script missing"
    [ -f .ai-framework/scripts/check-file-sizes.sh ] && echo "   ✅ File size checker" || echo "   ❌ File size checker missing"
else
    echo "   ❌ .ai-framework/ directory not found"
fi
echo

# 3. Slash Commands Check
echo "⚡ Slash Commands:"
if [ -d .claude/commands ]; then
    echo "   ✅ .claude/commands/ directory present"
    COMMAND_COUNT=$(ls -1 .claude/commands/*.md 2>/dev/null | wc -l)
    echo "   📋 Available commands: $COMMAND_COUNT"
    ls -1 .claude/commands/*.md 2>/dev/null | sed 's|.claude/commands/||' | sed 's|.md$||' | sed 's/^/      - /'
else
    echo "   ❌ .claude/commands/ directory not found"
fi
echo

# 4. Rules Check
echo "📜 Rules Files:"
if [ -d rules ]; then
    echo "   ✅ rules/ directory present"
    [ -f rules/GENERAL_AI_RULES.md ] && echo "   ✅ General AI Rules" || echo "   ❌ General AI Rules missing"
    [ -f rules/STARTUP_PROTOCOL.md ] && echo "   ✅ Startup Protocol" || echo "   ❌ Startup Protocol missing"
    [ -f rules/REPOSITORY_SYNC_PROTOCOL.md ] && echo "   ✅ Repository Sync Protocol" || echo "   ❌ Repository Sync Protocol missing"
else
    echo "   ❌ rules/ directory not found"
fi
echo

# 5. Recent Session Activity
echo "🕐 Recent Activity:"
if [ -f .ai-framework/logs/sync.log ]; then
    echo "   Last 3 sync operations:"
    tail -3 .ai-framework/logs/sync.log | sed 's/^/   /'
else
    echo "   ℹ️  No sync log found"
fi
echo

# 6. Session Logs
if [ -d .ai-framework/session-logs ]; then
    SESSION_COUNT=$(ls -1 .ai-framework/session-logs/*.md 2>/dev/null | wc -l)
    if [ "$SESSION_COUNT" -gt 0 ]; then
        echo "   📝 Session logs: $SESSION_COUNT file(s)"
        ls -1t .ai-framework/session-logs/*.md 2>/dev/null | head -3 | sed 's|.ai-framework/session-logs/||' | sed 's/^/      - /'
    fi
fi
echo

echo "==============================="
echo "✅ Status check complete"
```

Report summary of project status and any issues found.
