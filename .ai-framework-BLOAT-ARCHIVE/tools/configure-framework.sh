#!/bin/bash

# Framework Configuration Tool
# Unified interface for managing all framework settings

set -e

FRAMEWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONFIG_DIR="$FRAMEWORK_ROOT/.ai-framework/config"
TOOLS_DIR="$FRAMEWORK_ROOT/.ai-framework/tools"

EXECUTION_CONFIG="$CONFIG_DIR/execution-mode.json"
DEFAULTS_CONFIG="$CONFIG_DIR/framework-defaults.json"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Show complete configuration
show_config() {
    echo -e "${CYAN}⚙️ FRAMEWORK CONFIGURATION${NC}"
    echo ""

    # Execution mode
    if [ -f "$EXECUTION_CONFIG" ] && command -v jq >/dev/null 2>&1; then
        local mode=$(jq -r '.execution_mode' "$EXECUTION_CONFIG")
        local auto_budget=$(jq -r '.budget_limits.auto_execute_max' "$EXECUTION_CONFIG")

        echo -e "${BLUE}Execution Settings:${NC}"
        echo -e "  Mode: ${GREEN}$mode${NC}"
        echo -e "  Auto-Execute Budget: \$$auto_budget"
        echo ""
    fi

    # File compliance
    if [ -f "$DEFAULTS_CONFIG" ] && command -v jq >/dev/null 2>&1; then
        echo -e "${BLUE}File Compliance Defaults:${NC}"
        local default_lines=$(jq -r '.file_compliance_defaults.max_lines_per_file' "$DEFAULTS_CONFIG")
        echo -e "  Default Max Lines: $default_lines"

        echo -e "  File Type Limits:"
        jq -r '.file_compliance_defaults.file_type_limits | to_entries[] |
               "    \(.key): \(.value) lines"' "$DEFAULTS_CONFIG"
        echo ""
    fi

    # Caching
    if [ -f "$DEFAULTS_CONFIG" ] && command -v jq >/dev/null 2>&1; then
        local cache_enabled=$(jq -r '.caching_defaults.enabled' "$DEFAULTS_CONFIG")
        local cache_ttl=$(jq -r '.caching_defaults.default_ttl_seconds' "$DEFAULTS_CONFIG")

        echo -e "${BLUE}Caching Settings:${NC}"
        echo -e "  Enabled: $cache_enabled"
        echo -e "  Default TTL: $cache_ttl seconds"
        echo ""
    fi

    # Collaboration
    if [ -f "$DEFAULTS_CONFIG" ] && command -v jq >/dev/null 2>&1; then
        echo -e "${BLUE}Collaboration Pattern:${NC}"
        local tcc_role=$(jq -r '.collaboration_defaults.tcc_role' "$DEFAULTS_CONFIG")
        local occ_role=$(jq -r '.collaboration_defaults.occ_role' "$DEFAULTS_CONFIG")

        echo -e "  TCC Role: $tcc_role"
        echo -e "  OCC Role: $occ_role"
        echo ""
    fi
}

# Set execution mode
set_execution_mode() {
    local mode="$1"

    if [[ ! "$mode" =~ ^(AUTO_EXECUTE|PERMISSION_REQUIRED|REVIEW_FIRST)$ ]]; then
        echo -e "${RED}Invalid execution mode${NC}"
        echo "Valid modes: AUTO_EXECUTE, PERMISSION_REQUIRED, REVIEW_FIRST"
        return 1
    fi

    if [ -f "$TOOLS_DIR/execution-handler.sh" ]; then
        "$TOOLS_DIR/execution-handler.sh" --set-mode "$mode"
    else
        echo -e "${RED}Execution handler not found${NC}"
        return 1
    fi
}

# Set auto-execute budget limit
set_auto_budget() {
    local budget="$1"

    if ! [[ "$budget" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Invalid budget value${NC}"
        return 1
    fi

    if [ -f "$EXECUTION_CONFIG" ] && command -v jq >/dev/null 2>&1; then
        local temp_file=$(mktemp)
        jq --arg budget "$budget" \
           '.budget_limits.auto_execute_max = ($budget | tonumber) |
            .last_updated = now | strftime("%Y-%m-%dT%H:%M:%SZ")' \
           "$EXECUTION_CONFIG" > "$temp_file"
        mv "$temp_file" "$EXECUTION_CONFIG"

        echo -e "${GREEN}✅ Auto-execute budget set to: \$$budget${NC}"
    fi
}

# Enable/disable caching
toggle_caching() {
    local enabled="$1"

    if [[ ! "$enabled" =~ ^(true|false)$ ]]; then
        echo -e "${RED}Invalid value. Use 'true' or 'false'${NC}"
        return 1
    fi

    if [ -f "$DEFAULTS_CONFIG" ] && command -v jq >/dev/null 2>&1; then
        local temp_file=$(mktemp)
        jq --arg enabled "$enabled" \
           '.caching_defaults.enabled = ($enabled == "true")' \
           "$DEFAULTS_CONFIG" > "$temp_file"
        mv "$temp_file" "$DEFAULTS_CONFIG"

        if [ "$enabled" = "true" ]; then
            echo -e "${GREEN}✅ Caching enabled${NC}"
        else
            echo -e "${YELLOW}⚠️  Caching disabled${NC}"
        fi
    fi
}

# Set file type line limit
set_file_limit() {
    local file_type="$1"
    local limit="$2"

    if [ -z "$file_type" ] || [ -z "$limit" ]; then
        echo -e "${RED}Usage: --set-file-limit <type> <limit>${NC}"
        return 1
    fi

    if ! [[ "$limit" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Invalid limit value${NC}"
        return 1
    fi

    if [ -f "$DEFAULTS_CONFIG" ] && command -v jq >/dev/null 2>&1; then
        local temp_file=$(mktemp)
        jq --arg type "$file_type" \
           --arg limit "$limit" \
           '.file_compliance_defaults.file_type_limits[$type] = ($limit | tonumber)' \
           "$DEFAULTS_CONFIG" > "$temp_file"
        mv "$temp_file" "$DEFAULTS_CONFIG"

        echo -e "${GREEN}✅ File limit for .$file_type set to: $limit lines${NC}"
    fi
}

# Reset to defaults
reset_to_defaults() {
    echo -e "${YELLOW}⚠️  This will reset all configuration to defaults${NC}"
    read -p "Are you sure? (y/n): " confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        # Reset execution mode
        if [ -f "$TOOLS_DIR/execution-handler.sh" ]; then
            "$TOOLS_DIR/execution-handler.sh" --set-mode AUTO_EXECUTE
        fi

        echo -e "${GREEN}✅ Configuration reset to defaults${NC}"
    else
        echo "Reset cancelled"
    fi
}

# Export configuration
export_config() {
    local output_file="${1:-framework-config-export.json}"

    if command -v jq >/dev/null 2>&1; then
        jq -n \
           --slurpfile exec "$EXECUTION_CONFIG" \
           --slurpfile defaults "$DEFAULTS_CONFIG" \
           '{execution: $exec[0], defaults: $defaults[0]}' \
           > "$output_file"

        echo -e "${GREEN}✅ Configuration exported to: $output_file${NC}"
    fi
}

# Main command handler
case "${1:-}" in
    --show-config)
        show_config
        ;;
    --execution-mode)
        set_execution_mode "$2"
        ;;
    --auto-budget)
        set_auto_budget "$2"
        ;;
    --toggle-caching)
        toggle_caching "$2"
        ;;
    --set-file-limit)
        set_file_limit "$2" "$3"
        ;;
    --reset)
        reset_to_defaults
        ;;
    --export)
        export_config "$2"
        ;;
    --help|*)
        echo "Framework Configuration Tool"
        echo ""
        echo "Usage:"
        echo "  $0 --show-config                           Show all configuration"
        echo "  $0 --execution-mode <MODE>                 Set execution mode"
        echo "  $0 --auto-budget <amount>                  Set auto-execute budget limit"
        echo "  $0 --toggle-caching <true|false>           Enable/disable caching"
        echo "  $0 --set-file-limit <type> <lines>         Set file type line limit"
        echo "  $0 --reset                                 Reset to default configuration"
        echo "  $0 --export [file]                         Export configuration to JSON"
        echo ""
        echo "Examples:"
        echo "  $0 --execution-mode AUTO_EXECUTE"
        echo "  $0 --auto-budget 500"
        echo "  $0 --toggle-caching true"
        echo "  $0 --set-file-limit py 200"
        echo ""
        echo "Execution Modes:"
        echo "  AUTO_EXECUTE         - Immediate implementation without interruption"
        echo "  PERMISSION_REQUIRED  - Always ask before implementation"
        echo "  REVIEW_FIRST         - Show plan, wait for approval, then proceed"
        ;;
esac
