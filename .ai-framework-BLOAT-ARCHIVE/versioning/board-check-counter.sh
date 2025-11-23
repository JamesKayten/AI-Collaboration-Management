#!/bin/bash

# Board Check Counter - Track board check events
# Usage: ./board-check-counter.sh [action]
# Actions: increment, get-current, get-next

set -e

STATE_DIR="$(dirname "$0")/../state"
BOARD_CHECK_LOG="$STATE_DIR/BOARD_CHECK_LOG.json"
DEV_STATE="$STATE_DIR/DEVELOPMENT_STATE.json"

# Ensure jq is available (for JSON parsing)
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required for JSON processing"
    exit 1
fi

# Get current board check count
get_current() {
    if [ -f "$BOARD_CHECK_LOG" ]; then
        jq -r '.total_checks' "$BOARD_CHECK_LOG"
    else
        echo "0"
    fi
}

# Get next board check event ID
get_next() {
    if [ -f "$BOARD_CHECK_LOG" ]; then
        jq -r '.next_event_id' "$BOARD_CHECK_LOG"
    else
        echo "BC-001"
    fi
}

# Increment board check counter
increment() {
    local current_count=$(get_current)
    local next_count=$((current_count + 1))
    local next_id=$(printf "BC-%03d" $next_count)
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Update board check log
    if [ -f "$BOARD_CHECK_LOG" ]; then
        # Create new entry
        local temp_file=$(mktemp)
        jq --arg id "$next_id" \
           --arg ts "$timestamp" \
           --argjson count "$next_count" \
           '.board_check_log += [{
               "event_id": $id,
               "timestamp": $ts,
               "phase": "ACTIVE",
               "actions_taken": "Board check executed"
           }] | .total_checks = $count | .next_event_id = "BC-\(($count + 1) | tostring | if length == 1 then "00" + . elif length == 2 then "0" + . else . end)" | .last_check = $ts' \
           "$BOARD_CHECK_LOG" > "$temp_file"
        mv "$temp_file" "$BOARD_CHECK_LOG"
    fi

    # Update development state
    if [ -f "$DEV_STATE" ]; then
        local temp_file=$(mktemp)
        jq --argjson count "$next_count" \
           --arg ts "$timestamp" \
           '.board_check_count = $count | .last_board_check = $ts | .last_updated = $ts' \
           "$DEV_STATE" > "$temp_file"
        mv "$temp_file" "$DEV_STATE"
    fi

    echo "$next_id"
}

# Main action handler
ACTION="${1:-get-current}"

case "$ACTION" in
    increment)
        increment
        ;;
    get-current)
        get_current
        ;;
    get-next)
        get_next
        ;;
    *)
        echo "Usage: $0 {increment|get-current|get-next}"
        exit 1
        ;;
esac
