#!/bin/bash

# AI Collaboration Framework - Behavior Enforcer
# Purpose: Enforce production development rules and prevent rule violations

set -e

FRAMEWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENFORCEMENT_LOG="$FRAMEWORK_ROOT/monitoring/enforcement.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_enforcement() {
    echo "[$(date)] $1" >> "$ENFORCEMENT_LOG"
}

# TCC Behavior Enforcement
enforce_tcc_behavior() {
    log_enforcement "Enforcing TCC behavior rules"

    # Rule: When checking board, must use auto-check-board.sh
    echo -e "${BLUE}📋 TCC BEHAVIOR RULES:${NC}"
    echo "1. When user says 'check the board': Run .ai-framework/tools/auto-check-board.sh"
    echo "2. Find OCC work → Review compliance → Merge or reject"
    echo "3. Use simple commits, no verbose explanations"
    echo "4. Update board status after actions"

    # Auto-create enforcement reminder
    cat > "$FRAMEWORK_ROOT/monitoring/TCC_BEHAVIOR_REMINDER.md" << 'EOF'
# 🚨 TCC BEHAVIOR ENFORCEMENT

## REQUIRED WORKFLOW:
1. User says "check the board" → Run `.ai-framework/tools/auto-check-board.sh`
2. Auto-check-board.sh finds OCC work → Reviews compliance → Merges or rejects
3. Simple commit messages only
4. Update board status after merge

## VIOLATIONS TO AVOID:
- ❌ Explaining what you're going to do instead of doing it
- ❌ Verbose commit messages with emojis
- ❌ Manual merge processes instead of using auto-check-board.sh
- ❌ Forgetting to update board status

## ENFORCEMENT: This reminder appears whenever TCC deviates from protocol
EOF

    log_enforcement "TCC behavior rules enforced"
}

# OCC Behavior Enforcement
enforce_occ_behavior() {
    log_enforcement "Enforcing OCC behavior rules"

    echo -e "${BLUE}💻 OCC BEHAVIOR RULES:${NC}"
    echo "1. Use task references (TK-XXX) in all work"
    echo "2. Follow file size compliance"
    echo "3. Create proper commit messages with references"
    echo "4. Complete assigned tasks fully"

    # Create OCC enforcement reminder
    cat > "$FRAMEWORK_ROOT/monitoring/OCC_BEHAVIOR_REMINDER.md" << 'EOF'
# 🚨 OCC BEHAVIOR ENFORCEMENT

## REQUIRED WORKFLOW:
1. Check pending tasks: `.ai-framework/tools/task-reference-manager.sh pending`
2. Work on highest priority task (TK-XXX)
3. Complete implementation fully
4. Commit with task reference: "TK-XXX: Description"
5. Mark task complete: `task-reference-manager.sh complete TK-XXX`

## VIOLATIONS TO AVOID:
- ❌ Working without task references
- ❌ Partial implementations
- ❌ File size violations
- ❌ Commits without TK-XXX references

## ENFORCEMENT: This reminder appears when OCC deviates from protocol
EOF

    log_enforcement "OCC behavior rules enforced"
}

# Framework Distribution Enforcement
enforce_framework_distribution() {
    log_enforcement "Enforcing framework distribution compliance"

    echo -e "${BLUE}📦 DISTRIBUTION RULES:${NC}"
    echo "1. install-framework-complete.sh must include all fixes"
    echo "2. SlashCommand must work without permission errors"
    echo "3. All new repositories must get working framework"

    # Check installer compliance
    if [ -f "$FRAMEWORK_ROOT/../tcc-setup/install-framework-complete.sh" ]; then
        if ! grep -q "no command execution" "$FRAMEWORK_ROOT/../tcc-setup/install-framework-complete.sh"; then
            echo -e "${RED}🚨 VIOLATION: Framework installer missing SlashCommand fix${NC}"
            log_enforcement "VIOLATION: Framework installer incomplete"
            return 1
        fi
    fi

    log_enforcement "Framework distribution compliance enforced"
}

# Git Hook Integration
install_git_hooks() {
    echo -e "${YELLOW}🔗 Installing Git hooks for behavior enforcement...${NC}"

    # Pre-commit hook - check compliance before commit
    cat > "$FRAMEWORK_ROOT/../.git/hooks/pre-commit" << 'EOF'
#!/bin/bash
# Compliance check before commit

.ai-framework/monitoring/compliance-monitor.sh check
if [ $? -ne 0 ]; then
    echo "🚨 COMPLIANCE VIOLATION - Commit blocked"
    echo "Run: .ai-framework/monitoring/compliance-monitor.sh fix"
    exit 1
fi
EOF

    chmod +x "$FRAMEWORK_ROOT/../.git/hooks/pre-commit"

    # Post-merge hook - check compliance after merge
    cat > "$FRAMEWORK_ROOT/../.git/hooks/post-merge" << 'EOF'
#!/bin/bash
# Compliance check after merge

.ai-framework/monitoring/compliance-monitor.sh check || \
.ai-framework/monitoring/compliance-monitor.sh fix
EOF

    chmod +x "$FRAMEWORK_ROOT/../.git/hooks/post-merge"

    log_enforcement "Git hooks installed for automatic compliance checking"
}

# Main enforcement function
run_behavior_enforcement() {
    echo -e "${YELLOW}🛡️  AI Collaboration Framework - Behavior Enforcer${NC}"
    log_enforcement "=== BEHAVIOR ENFORCEMENT STARTED ==="

    enforce_tcc_behavior
    enforce_occ_behavior
    enforce_framework_distribution

    echo -e "${GREEN}✅ Behavior enforcement rules activated${NC}"
    log_enforcement "=== BEHAVIOR ENFORCEMENT COMPLETE ==="
}

case "${1:-enforce}" in
    "enforce")
        run_behavior_enforcement
        ;;
    "install-hooks")
        install_git_hooks
        ;;
    "tcc")
        enforce_tcc_behavior
        ;;
    "occ")
        enforce_occ_behavior
        ;;
    "framework")
        enforce_framework_distribution
        ;;
    *)
        echo "Usage: $0 [enforce|install-hooks|tcc|occ|framework]"
        exit 1
        ;;
esac