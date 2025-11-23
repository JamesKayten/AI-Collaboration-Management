#!/bin/bash

# Simple Rule Toggle Script
# Usage: ./toggle-rule.sh [--enable|--disable|--status] RULE_NAME

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULE_ENFORCEMENT_SCRIPT="$SCRIPT_DIR/rule-enforcement.sh"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

show_usage() {
    echo -e "${BLUE}🔧 Framework Rule Toggle${NC}"
    echo "Usage: $0 [OPTION] RULE_NAME"
    echo ""
    echo "Options:"
    echo "  --enable, -e    Enable rule"
    echo "  --disable, -d   Disable rule"
    echo "  --status, -s    Show rule status"
    echo ""
    echo "Available Rules:"
    echo "  auto_execution_directive     Auto-display OCC execution directives"
    echo "  development_state_prompts    Show development state prominently"
    echo "  merge_conflict_prevention    Prevent problematic merge scenarios"
    echo ""
    echo "Examples:"
    echo "  $0 --enable auto_execution_directive"
    echo "  $0 --disable auto_execution_directive"
    echo "  $0 --status auto_execution_directive"
}

case "${1:-}" in
    "--enable"|"-e")
        if [[ -n "${2:-}" ]]; then
            echo -e "${CYAN}🔄 Enabling rule: $2${NC}"
            "$RULE_ENFORCEMENT_SCRIPT" --toggle "$2" enable
        else
            echo "Error: Rule name required"
            show_usage
            exit 1
        fi
        ;;
    "--disable"|"-d")
        if [[ -n "${2:-}" ]]; then
            echo -e "${CYAN}🔄 Disabling rule: $2${NC}"
            "$RULE_ENFORCEMENT_SCRIPT" --toggle "$2" disable
        else
            echo "Error: Rule name required"
            show_usage
            exit 1
        fi
        ;;
    "--status"|"-s")
        if [[ -n "${2:-}" ]]; then
            "$RULE_ENFORCEMENT_SCRIPT" --toggle "$2" status
        else
            # Show all rules status
            "$RULE_ENFORCEMENT_SCRIPT" --status
        fi
        ;;
    "--help"|"-h")
        show_usage
        ;;
    *)
        if [[ -n "${1:-}" ]]; then
            # Default to status if just rule name provided
            "$RULE_ENFORCEMENT_SCRIPT" --toggle "$1" status
        else
            show_usage
        fi
        ;;
esac