#!/bin/bash

# Commit Labeler - Auto-label commits with version and cycle info
# Usage: ./commit-labeler.sh [commit-message]

set -e

STATE_DIR="$(dirname "$0")/../state"
DEV_STATE="$STATE_DIR/DEVELOPMENT_STATE.json"
VERSION_HISTORY="$STATE_DIR/VERSION_HISTORY.json"

# Ensure jq is available
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required for JSON processing"
    exit 1
fi

# Get version labels
get_version_labels() {
    if [ -f "$DEV_STATE" ]; then
        local version=$(jq -r '.framework_version' "$DEV_STATE")
        local cycle=$(jq -r '.development_cycle' "$DEV_STATE")
        local merge=$(jq -r '.merge_cycle' "$DEV_STATE")

        echo "[$version] [$cycle] [$merge]"
    else
        echo "[v0.0.0] [DC-UNKNOWN] [MG-000]"
    fi
}

# Generate labeled commit message
generate_labeled_message() {
    local original_message="$1"
    local labels=$(get_version_labels)

    # Extract first line (summary)
    local summary=$(echo "$original_message" | head -n 1)

    # Get remaining lines (body)
    local body=$(echo "$original_message" | tail -n +2)

    # Create labeled message
    echo "$summary"
    echo ""
    echo "$labels"
    if [ -n "$body" ]; then
        echo "$body"
    fi
}

# Update development metrics after commit
update_commit_metrics() {
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    if [ -f "$DEV_STATE" ]; then
        local temp_file=$(mktemp)
        jq --arg ts "$timestamp" \
           '.development_metrics.total_commits_today += 1 | .last_updated = $ts' \
           "$DEV_STATE" > "$temp_file"
        mv "$temp_file" "$DEV_STATE"
    fi
}

# Show current version context
show_context() {
    if [ -f "$DEV_STATE" ]; then
        echo "📋 Current Development Context:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        jq -r '"  Framework: \(.framework_version)\n  Cycle: \(.development_cycle)\n  Phase: \(.phase)\n  Merge: \(.merge_cycle)"' "$DEV_STATE"
        echo ""
    fi
}

# Main action
ACTION="${1:-get-labels}"

case "$ACTION" in
    get-labels)
        get_version_labels
        ;;
    label-message)
        shift
        generate_labeled_message "$*"
        ;;
    update-metrics)
        update_commit_metrics
        ;;
    show-context)
        show_context
        ;;
    *)
        # If first arg doesn't match a command, treat it as a message to label
        generate_labeled_message "$*"
        ;;
esac
