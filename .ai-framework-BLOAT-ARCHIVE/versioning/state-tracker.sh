#!/bin/bash

# State Tracker - Development state management
# Usage: ./state-tracker.sh [action] [args...]
# Actions: get-phase, set-phase, get-cycle, update-feature, get-status

set -e

STATE_DIR="$(dirname "$0")/../state"
DEV_STATE="$STATE_DIR/DEVELOPMENT_STATE.json"

# Ensure jq is available
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required for JSON processing"
    exit 1
fi

# Get current development phase
get_phase() {
    if [ -f "$DEV_STATE" ]; then
        jq -r '.phase' "$DEV_STATE"
    else
        echo "UNKNOWN"
    fi
}

# Set development phase
set_phase() {
    local phase="$1"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    if [ -f "$DEV_STATE" ]; then
        local temp_file=$(mktemp)
        jq --arg phase "$phase" \
           --arg ts "$timestamp" \
           '.phase = $phase | .last_updated = $ts' \
           "$DEV_STATE" > "$temp_file"
        mv "$temp_file" "$DEV_STATE"
        echo "Phase updated to: $phase"
    fi
}

# Get current development cycle
get_cycle() {
    if [ -f "$DEV_STATE" ]; then
        jq -r '.development_cycle' "$DEV_STATE"
    else
        echo "DC-UNKNOWN"
    fi
}

# Update feature status
update_feature() {
    local feature_name="$1"
    local status="$2"
    local progress="${3:-0}"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    if [ -f "$DEV_STATE" ]; then
        local temp_file=$(mktemp)
        jq --arg name "$feature_name" \
           --arg status "$status" \
           --argjson progress "$progress" \
           --arg ts "$timestamp" \
           '(.active_features[] | select(.name == $name)) |= (
               .status = $status |
               .progress = $progress |
               if $progress == 100 then .completion_date = $ts else . end
           ) | .last_updated = $ts' \
           "$DEV_STATE" > "$temp_file"
        mv "$temp_file" "$DEV_STATE"
        echo "Feature '$feature_name' updated: $status ($progress%)"
    fi
}

# Get full status
get_status() {
    if [ -f "$DEV_STATE" ]; then
        cat "$DEV_STATE"
    else
        echo "{\"error\": \"No development state found\"}"
    fi
}

# Get current position summary
get_position() {
    if [ -f "$DEV_STATE" ]; then
        local version=$(jq -r '.framework_version' "$DEV_STATE")
        local cycle=$(jq -r '.development_cycle' "$DEV_STATE")
        local phase=$(jq -r '.phase' "$DEV_STATE")
        local board_checks=$(jq -r '.board_check_count' "$DEV_STATE")
        local merge_cycle=$(jq -r '.merge_cycle' "$DEV_STATE")

        echo "🎯 CURRENT POSITION"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Framework: $version"
        echo "Cycle: $cycle"
        echo "Phase: $phase"
        echo "Board Checks: $board_checks"
        echo "Merge Status: $merge_cycle"
        echo ""

        # Show active features
        echo "🔄 ACTIVE FEATURES:"
        jq -r '.active_features[] | "  \(if .status == "COMPLETED" then "✅" elif .status == "IN_PROGRESS" then "🔄" else "⏳" end) \(.name) (\(.progress)%) - \(.status)"' "$DEV_STATE"
    fi
}

# Main action handler
ACTION="${1:-get-status}"
shift || true

case "$ACTION" in
    get-phase)
        get_phase
        ;;
    set-phase)
        set_phase "$@"
        ;;
    get-cycle)
        get_cycle
        ;;
    update-feature)
        update_feature "$@"
        ;;
    get-status)
        get_status
        ;;
    get-position)
        get_position
        ;;
    *)
        echo "Usage: $0 {get-phase|set-phase|get-cycle|update-feature|get-status|get-position}"
        exit 1
        ;;
esac
