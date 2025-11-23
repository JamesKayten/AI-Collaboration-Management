#!/bin/bash

# Rule Manager - Dynamic Rule Management System
# Provides natural language interface for creating and managing framework rules

set -e

FRAMEWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RULES_DIR="$FRAMEWORK_ROOT/.ai-framework/rules"
ENGINE_DIR="$FRAMEWORK_ROOT/.ai-framework/rule-engine"
PARSER_SCRIPT="$ENGINE_DIR/rule-parser.py"

FRAMEWORK_RULES="$RULES_DIR/framework-rules.json"
CUSTOM_RULES="$RULES_DIR/user-custom-rules.json"
RULE_HISTORY="$RULES_DIR/rule-history.json"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Add a rule from natural language
add_rule() {
    local statement="$1"

    if [ -z "$statement" ]; then
        echo -e "${RED}Error: No rule statement provided${NC}"
        return 1
    fi

    echo -e "${CYAN}📝 Parsing rule statement...${NC}"
    echo "Statement: $statement"
    echo ""

    # Parse the rule using Python parser
    if [ -f "$PARSER_SCRIPT" ] && command -v python3 >/dev/null 2>&1; then
        local parsed_rule=$(python3 -c "
import sys
sys.path.insert(0, '$ENGINE_DIR')
from rule_parser import RuleParser
import json

parser = RuleParser()
rule = parser.parse_natural_language('$statement')

if rule:
    print(json.dumps(rule))
else:
    sys.exit(1)
")

        if [ $? -eq 0 ] && [ -n "$parsed_rule" ]; then
            echo -e "${GREEN}✅ Rule parsed successfully${NC}"
            echo ""

            # Display parsed rule
            if command -v jq >/dev/null 2>&1; then
                echo -e "${BLUE}Parsed Rule:${NC}"
                echo "$parsed_rule" | jq '.'
                echo ""

                # Ask for confirmation
                read -p "Add this rule to the framework? (y/n): " confirm

                if [[ "$confirm" =~ ^[Yy]$ ]]; then
                    # Add to custom rules
                    add_to_custom_rules "$parsed_rule"
                    log_rule_change "rule_created" "$statement"
                    echo -e "${GREEN}✅ Rule activated and integrated into framework${NC}"
                else
                    echo -e "${YELLOW}Rule creation cancelled${NC}"
                fi
            else
                echo "$parsed_rule"
            fi
        else
            echo -e "${RED}❌ Failed to parse rule statement${NC}"
            echo "Please try rephrasing your rule or use --help for examples"
            return 1
        fi
    else
        echo -e "${RED}❌ Rule parser not available${NC}"
        echo "Please ensure Python 3 is installed and rule-parser.py exists"
        return 1
    fi
}

# Add parsed rule to custom rules file
add_to_custom_rules() {
    local rule_json="$1"

    if [ ! -f "$CUSTOM_RULES" ]; then
        echo '{"custom_rules_version":"1.0","rules":{},"rule_count":0}' > "$CUSTOM_RULES"
    fi

    if command -v jq >/dev/null 2>&1; then
        local rule_id=$(echo "$rule_json" | jq -r '.rule_id')
        local temp_file=$(mktemp)

        jq --argjson rule "$rule_json" \
           --arg rule_id "$rule_id" \
           '.rules[$rule_id] = $rule |
            .rule_count += 1 |
            .active_rules += 1 |
            .last_updated = now | strftime("%Y-%m-%dT%H:%M:%SZ")' \
           "$CUSTOM_RULES" > "$temp_file"

        mv "$temp_file" "$CUSTOM_RULES"
    fi
}

# Log rule changes to history
log_rule_change() {
    local action="$1"
    local description="$2"

    if [ ! -f "$RULE_HISTORY" ]; then
        echo '{"history_version":"1.0","changes":[],"total_changes":0}' > "$RULE_HISTORY"
    fi

    if command -v jq >/dev/null 2>&1; then
        local temp_file=$(mktemp)
        local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

        jq --arg action "$action" \
           --arg desc "$description" \
           --arg ts "$timestamp" \
           '.changes += [{
               timestamp: $ts,
               action: $action,
               description: $desc,
               change_type: $action
           }] |
           .total_changes += 1 |
           .last_updated = $ts' \
           "$RULE_HISTORY" > "$temp_file"

        mv "$temp_file" "$RULE_HISTORY"
    fi
}

# List all active rules
list_rules() {
    echo -e "${CYAN}📋 ACTIVE FRAMEWORK RULES${NC}"
    echo ""

    if command -v jq >/dev/null 2>&1; then
        # List framework rules
        if [ -f "$FRAMEWORK_RULES" ]; then
            echo -e "${BLUE}System Rules:${NC}"
            local rule_count=$(jq -r '.rule_count' "$FRAMEWORK_RULES")
            echo "Total: $rule_count rules"
            echo ""

            jq -r '.rules | to_entries[] | .value | to_entries[] |
                   "\(.value.rule_id): \(.value.description) [\(.value.status)]"' \
                   "$FRAMEWORK_RULES" 2>/dev/null || echo "No rules found"
            echo ""
        fi

        # List custom rules
        if [ -f "$CUSTOM_RULES" ]; then
            echo -e "${BLUE}Custom Rules:${NC}"
            local custom_count=$(jq -r '.rule_count' "$CUSTOM_RULES")
            echo "Total: $custom_count rules"
            echo ""

            if [ "$custom_count" -gt 0 ]; then
                jq -r '.rules | to_entries[] |
                       "\(.value.rule_id): \(.value.description) [\(.value.status)]"' \
                       "$CUSTOM_RULES" 2>/dev/null || echo "No custom rules found"
            else
                echo "No custom rules added yet"
            fi
        fi
    else
        echo -e "${YELLOW}jq not available for rule listing${NC}"
    fi
}

# Show rule details
show_rule() {
    local rule_id="$1"

    if [ -z "$rule_id" ]; then
        echo -e "${RED}Error: Rule ID required${NC}"
        return 1
    fi

    echo -e "${CYAN}📋 RULE DETAILS: $rule_id${NC}"
    echo ""

    if command -v jq >/dev/null 2>&1; then
        # Check framework rules
        local rule=$(jq -r ".rules[][] | select(.rule_id == \"$rule_id\")" "$FRAMEWORK_RULES" 2>/dev/null)

        # Check custom rules if not found
        if [ -z "$rule" ] && [ -f "$CUSTOM_RULES" ]; then
            rule=$(jq -r ".rules[\"$rule_id\"]" "$CUSTOM_RULES" 2>/dev/null)
        fi

        if [ -n "$rule" ] && [ "$rule" != "null" ]; then
            echo "$rule" | jq '.'
        else
            echo -e "${RED}Rule not found: $rule_id${NC}"
            return 1
        fi
    fi
}

# Disable a rule
disable_rule() {
    local rule_id="$1"

    if [ -z "$rule_id" ]; then
        echo -e "${RED}Error: Rule ID required${NC}"
        return 1
    fi

    echo -e "${YELLOW}Disabling rule: $rule_id${NC}"

    if command -v jq >/dev/null 2>&1 && [ -f "$CUSTOM_RULES" ]; then
        local temp_file=$(mktemp)

        jq --arg rule_id "$rule_id" \
           '.rules[$rule_id].status = "disabled" |
            .active_rules -= 1 |
            .disabled_rules += 1' \
           "$CUSTOM_RULES" > "$temp_file"

        mv "$temp_file" "$CUSTOM_RULES"
        log_rule_change "rule_disabled" "Disabled rule $rule_id"
        echo -e "${GREEN}✅ Rule disabled${NC}"
    fi
}

# Enable a rule
enable_rule() {
    local rule_id="$1"

    if [ -z "$rule_id" ]; then
        echo -e "${RED}Error: Rule ID required${NC}"
        return 1
    fi

    echo -e "${GREEN}Enabling rule: $rule_id${NC}"

    if command -v jq >/dev/null 2>&1 && [ -f "$CUSTOM_RULES" ]; then
        local temp_file=$(mktemp)

        jq --arg rule_id "$rule_id" \
           '.rules[$rule_id].status = "active" |
            .active_rules += 1 |
            .disabled_rules -= 1' \
           "$CUSTOM_RULES" > "$temp_file"

        mv "$temp_file" "$CUSTOM_RULES"
        log_rule_change "rule_enabled" "Enabled rule $rule_id"
        echo -e "${GREEN}✅ Rule enabled${NC}"
    fi
}

# Show examples
show_examples() {
    echo -e "${CYAN}📚 RULE CREATION EXAMPLES${NC}"
    echo ""

    cat <<'EOF'
File Limit Rules:
  "All Python files should be limited to 200 lines instead of 250"
  "JavaScript files should be limited to 120 lines"
  "Maximum 300 lines for shell scripts"

Workflow Requirement Rules:
  "Requires code review for any file over 100 lines"
  "Must run tests before any merge to main"
  "Framework should automatically run tests before any merge"

Notification Preference Rules:
  "Updates every 10 minutes"
  "Notify when merge is complete"
  "Progress reports every 5 minutes"

Collaboration Role Rules:
  "TCC should always provide progress updates every 10 minutes"
  "OCC should always include test results in handoff"
  "Framework should track all merge cycles"

Usage:
  ./rule-manager.sh --add "Your rule statement here"
EOF
}

# Main command handler
case "${1:-}" in
    --add)
        add_rule "$2"
        ;;
    --list)
        list_rules
        ;;
    --show)
        show_rule "$2"
        ;;
    --disable)
        disable_rule "$2"
        ;;
    --enable)
        enable_rule "$2"
        ;;
    --examples)
        show_examples
        ;;
    --help|*)
        echo "Rule Manager - Dynamic Rule Management System"
        echo ""
        echo "Usage:"
        echo "  $0 --add \"<natural language rule>\"   Add a new rule"
        echo "  $0 --list                              List all active rules"
        echo "  $0 --show <rule_id>                    Show rule details"
        echo "  $0 --disable <rule_id>                 Disable a rule"
        echo "  $0 --enable <rule_id>                  Enable a rule"
        echo "  $0 --examples                          Show example rules"
        echo ""
        echo "Examples:"
        echo "  $0 --add \"Python files should be limited to 200 lines\""
        echo "  $0 --add \"Requires code review for files over 100 lines\""
        echo "  $0 --list"
        echo "  $0 --show UR-20251123143000"
        ;;
esac
