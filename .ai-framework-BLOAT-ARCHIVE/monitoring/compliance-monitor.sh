#!/bin/bash

# AI Collaboration Framework - Compliance Monitor
# Purpose: Monitor TCC/OCC behavior and enforce production rules

set -e

FRAMEWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MONITOR_LOG="$FRAMEWORK_ROOT/monitoring/compliance.log"
VIOLATION_LOG="$FRAMEWORK_ROOT/monitoring/violations.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Create monitoring directory
mkdir -p "$FRAMEWORK_ROOT/monitoring"

log_event() {
    echo "[$(date)] $1" >> "$MONITOR_LOG"
}

log_violation() {
    echo "[$(date)] VIOLATION: $1" >> "$VIOLATION_LOG"
    echo -e "${RED}🚨 RULE VIOLATION: $1${NC}"
}

# Check TCC Compliance
check_tcc_compliance() {
    log_event "Checking TCC compliance..."

    # Rule 1: When user says "check the board", TCC must run auto-check-board.sh
    if [ -f "$FRAMEWORK_ROOT/tools/auto-check-board.sh" ]; then
        log_event "✅ Auto board check tool exists"
    else
        log_violation "TCC missing auto-check-board.sh tool"
    fi

    # Rule 2: SlashCommand must not have permission errors
    if [ -f "$FRAMEWORK_ROOT/../.claude/commands/check-the-board.md" ]; then
        if grep -q "no command execution" "$FRAMEWORK_ROOT/../.claude/commands/check-the-board.md"; then
            log_event "✅ SlashCommand configured correctly"
        else
            log_violation "SlashCommand still trying to execute commands"
        fi
    else
        log_violation "SlashCommand not configured"
    fi

    # Rule 3: Board status files must exist for OCC to read
    if [ -f "$FRAMEWORK_ROOT/CURRENT_BOARD_STATUS.md" ] && [ -f "$FRAMEWORK_ROOT/CHECK_THE_BOARD.md" ]; then
        log_event "✅ Board status files exist"
    else
        log_violation "Missing board status files for OCC"
    fi
}

# Check OCC Compliance
check_occ_compliance() {
    log_event "Checking OCC compliance..."

    # Rule 1: Must use task references
    if [ -f "$FRAMEWORK_ROOT/tools/task-reference-manager.sh" ]; then
        log_event "✅ Task reference system exists"
    else
        log_violation "OCC missing task reference system"
    fi

    # Rule 2: Recent commits must have task references or proper format
    RECENT_COMMITS=$(git log --oneline -5 | grep -v "Merge\|Auto-merge")
    if echo "$RECENT_COMMITS" | grep -qE "(TK-[0-9]+|📊|✅|🚨|feat:|fix:)"; then
        log_event "✅ Recent commits follow format rules"
    else
        log_violation "Recent commits missing task references or proper format"
    fi
}

# Check Framework Distribution
check_framework_distribution() {
    log_event "Checking framework distribution..."

    # Rule 1: install-framework-complete.sh must include SlashCommand fix
    if [ -f "$FRAMEWORK_ROOT/../tcc-setup/install-framework-complete.sh" ]; then
        if grep -q "no command execution" "$FRAMEWORK_ROOT/../tcc-setup/install-framework-complete.sh"; then
            log_event "✅ Framework installer includes SlashCommand fix"
        else
            log_violation "Framework installer missing SlashCommand fix"
        fi
    else
        log_violation "Framework installer missing"
    fi

    # Rule 2: Board status files created by installer
    if grep -q "CURRENT_BOARD_STATUS.md" "$FRAMEWORK_ROOT/../tcc-setup/install-framework-complete.sh"; then
        log_event "✅ Framework installer creates board status files"
    else
        log_violation "Framework installer doesn't create board status files"
    fi
}

# Main monitoring function
run_compliance_check() {
    echo -e "${YELLOW}🔍 Running AI Collaboration Framework Compliance Check${NC}"
    log_event "=== COMPLIANCE CHECK STARTED ==="

    check_tcc_compliance
    check_occ_compliance
    check_framework_distribution

    # Count violations
    VIOLATION_COUNT=0
    if [ -f "$VIOLATION_LOG" ]; then
        VIOLATION_COUNT=$(wc -l < "$VIOLATION_LOG")
    fi

    if [ "$VIOLATION_COUNT" -gt 0 ]; then
        echo -e "${RED}🚨 COMPLIANCE FAILURES: $VIOLATION_COUNT violations found${NC}"
        echo -e "${RED}Check: $VIOLATION_LOG${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ COMPLIANCE: All rules followed${NC}"
        log_event "=== COMPLIANCE CHECK PASSED ==="
    fi
}

# Auto-fix common violations
auto_fix_violations() {
    echo -e "${YELLOW}🔧 Auto-fixing common violations...${NC}"

    # Fix missing SlashCommand
    if [ ! -f "$FRAMEWORK_ROOT/../.claude/commands/check-the-board.md" ]; then
        echo "Auto-fixing SlashCommand..."
        "$FRAMEWORK_ROOT/../fix-slashcommand.sh" 2>/dev/null || true
    fi

    # Update board status if needed
    if [ -f "$FRAMEWORK_ROOT/tools/update-board-status.sh" ]; then
        "$FRAMEWORK_ROOT/tools/update-board-status.sh" >/dev/null
    fi

    echo -e "${GREEN}✅ Auto-fix complete${NC}"
}

case "${1:-check}" in
    "check")
        run_compliance_check
        ;;
    "fix")
        auto_fix_violations
        run_compliance_check
        ;;
    "violations")
        if [ -f "$VIOLATION_LOG" ]; then
            cat "$VIOLATION_LOG"
        else
            echo "No violations logged"
        fi
        ;;
    "clear")
        rm -f "$VIOLATION_LOG"
        echo "Violations cleared"
        ;;
    *)
        echo "Usage: $0 [check|fix|violations|clear]"
        exit 1
        ;;
esac