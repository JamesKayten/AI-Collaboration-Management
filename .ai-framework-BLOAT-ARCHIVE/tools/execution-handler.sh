#!/bin/bash

# Execution Mode Handler
# Manages framework execution mode configuration and behavior

set -e

FRAMEWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONFIG_FILE="$FRAMEWORK_ROOT/.ai-framework/config/execution-mode.json"
DEFAULTS_FILE="$FRAMEWORK_ROOT/.ai-framework/config/framework-defaults.json"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get current execution mode
get_execution_mode() {
    if [ -f "$CONFIG_FILE" ]; then
        if command -v jq >/dev/null 2>&1; then
            jq -r '.execution_mode' "$CONFIG_FILE" 2>/dev/null || echo "AUTO_EXECUTE"
        else
            grep -o '"execution_mode"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4 || echo "AUTO_EXECUTE"
        fi
    else
        echo "AUTO_EXECUTE"
    fi
}

# Set execution mode
set_execution_mode() {
    local mode="$1"

    if [ -z "$mode" ]; then
        echo -e "${RED}Error: Mode not specified${NC}"
        echo "Valid modes: AUTO_EXECUTE, PERMISSION_REQUIRED, REVIEW_FIRST"
        return 1
    fi

    # Validate mode
    if [[ ! "$mode" =~ ^(AUTO_EXECUTE|PERMISSION_REQUIRED|REVIEW_FIRST)$ ]]; then
        echo -e "${RED}Error: Invalid mode '$mode'${NC}"
        echo "Valid modes: AUTO_EXECUTE, PERMISSION_REQUIRED, REVIEW_FIRST"
        return 1
    fi

    # Update configuration
    if command -v jq >/dev/null 2>&1; then
        local temp_file=$(mktemp)
        jq --arg mode "$mode" '.execution_mode = $mode | .last_updated = now | strftime("%Y-%m-%dT%H:%M:%SZ")' "$CONFIG_FILE" > "$temp_file"
        mv "$temp_file" "$CONFIG_FILE"
        echo -e "${GREEN}✅ Execution mode set to: $mode${NC}"
    else
        echo -e "${YELLOW}⚠️  jq not available, manual update required${NC}"
        return 1
    fi
}

# Show current configuration
show_config() {
    echo -e "${BLUE}🔧 FRAMEWORK EXECUTION CONFIGURATION${NC}"
    echo ""

    if [ -f "$CONFIG_FILE" ]; then
        if command -v jq >/dev/null 2>&1; then
            local mode=$(jq -r '.execution_mode' "$CONFIG_FILE")
            local threshold=$(jq -r '.implementation_threshold' "$CONFIG_FILE")
            local auto_budget=$(jq -r '.budget_limits.auto_execute_max' "$CONFIG_FILE")
            local permission_budget=$(jq -r '.budget_limits.require_permission_above' "$CONFIG_FILE")
            local show_plan=$(jq -r '.notification_preferences.show_execution_plan' "$CONFIG_FILE")

            echo -e "${GREEN}Execution Mode:${NC} $mode"
            echo -e "${GREEN}Implementation Threshold:${NC} $threshold"
            echo -e "${GREEN}Auto-Execute Budget Limit:${NC} \$$auto_budget"
            echo -e "${GREEN}Permission Required Above:${NC} \$$permission_budget"
            echo -e "${GREEN}Show Execution Plan:${NC} $show_plan"
            echo ""

            local description=$(jq -r ".mode_descriptions.$mode" "$CONFIG_FILE")
            echo -e "${BLUE}Mode Description:${NC}"
            echo "$description"
        else
            cat "$CONFIG_FILE"
        fi
    else
        echo -e "${YELLOW}Configuration file not found${NC}"
        return 1
    fi
}

# Validate execution authority
validate_execution_authority() {
    local estimated_cost=${1:-0}
    local priority=${2:-MEDIUM}

    local mode=$(get_execution_mode)
    local auto_budget=500

    if [ -f "$CONFIG_FILE" ] && command -v jq >/dev/null 2>&1; then
        auto_budget=$(jq -r '.budget_limits.auto_execute_max' "$CONFIG_FILE")
    fi

    case "$mode" in
        AUTO_EXECUTE)
            if [ "$estimated_cost" -le "$auto_budget" ]; then
                echo "AUTHORIZED"
                return 0
            else
                echo "PERMISSION_REQUIRED"
                return 1
            fi
            ;;
        PERMISSION_REQUIRED)
            echo "PERMISSION_REQUIRED"
            return 1
            ;;
        REVIEW_FIRST)
            echo "REVIEW_REQUIRED"
            return 1
            ;;
        *)
            echo "PERMISSION_REQUIRED"
            return 1
            ;;
    esac
}

# Generate handoff document based on mode
generate_handoff_document() {
    local task_name="$1"
    local priority="$2"
    local budget_estimate="$3"

    local mode=$(get_execution_mode)
    local template_file="$FRAMEWORK_ROOT/.ai-framework/templates/handoff-${mode,,}.md"

    if [ -f "$template_file" ]; then
        # Template exists, use it
        sed -e "s/{{TASK_NAME}}/$task_name/g" \
            -e "s/{{PRIORITY}}/$priority/g" \
            -e "s/{{BUDGET_ESTIMATE}}/$budget_estimate/g" \
            -e "s/{{EXECUTION_MODE}}/$mode/g" \
            "$template_file"
    else
        # Default generic handoff
        echo "# TCC → OCC Handoff: $task_name"
        echo ""
        echo "**Priority:** $priority"
        echo "**Estimated Budget:** \$$budget_estimate"
        echo "**Execution Mode:** $mode"
        echo ""
        echo "## Implementation Required"
        echo "Proceed with implementation based on current execution mode: $mode"
    fi
}

# Main command handler
case "${1:-}" in
    --get-mode)
        get_execution_mode
        ;;
    --set-mode)
        set_execution_mode "$2"
        ;;
    --show-config)
        show_config
        ;;
    --validate-authority)
        validate_execution_authority "$2" "$3"
        ;;
    --generate-handoff)
        generate_handoff_document "$2" "$3" "$4"
        ;;
    --help|*)
        echo "Execution Mode Handler"
        echo ""
        echo "Usage:"
        echo "  $0 --get-mode                           Get current execution mode"
        echo "  $0 --set-mode <MODE>                    Set execution mode"
        echo "  $0 --show-config                        Show current configuration"
        echo "  $0 --validate-authority <cost> <priority>  Validate execution authority"
        echo "  $0 --generate-handoff <task> <priority> <budget>  Generate handoff document"
        echo ""
        echo "Execution Modes:"
        echo "  AUTO_EXECUTE         - Immediate implementation without interruption"
        echo "  PERMISSION_REQUIRED  - Always ask before implementation"
        echo "  REVIEW_FIRST         - Show plan, wait for approval, then proceed"
        ;;
esac
