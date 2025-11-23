#!/bin/bash

# Progress Calculator - Feature completion tracking
# Usage: ./progress-calculator.sh [action] [args...]
# Actions: overall, feature, velocity, estimate

set -e

STATE_DIR="$(dirname "$0")/../state"
DEV_STATE="$STATE_DIR/DEVELOPMENT_STATE.json"

# Ensure jq is available
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required for JSON processing"
    exit 1
fi

# Calculate overall progress
overall_progress() {
    if [ -f "$DEV_STATE" ]; then
        local total_features=$(jq '.active_features | length' "$DEV_STATE")
        local total_progress=$(jq '[.active_features[].progress] | add' "$DEV_STATE")

        if [ "$total_features" -gt 0 ]; then
            local avg_progress=$(echo "scale=2; $total_progress / $total_features" | bc)
            echo "$avg_progress"
        else
            echo "0"
        fi
    else
        echo "0"
    fi
}

# Get feature progress
feature_progress() {
    local feature_name="$1"

    if [ -f "$DEV_STATE" ]; then
        jq -r --arg name "$feature_name" \
            '.active_features[] | select(.name == $name) | .progress' \
            "$DEV_STATE"
    else
        echo "0"
    fi
}

# Calculate development velocity
velocity() {
    if [ -f "$DEV_STATE" ]; then
        local features_today=$(jq '.development_metrics.features_completed_today' "$DEV_STATE")
        local commits_today=$(jq '.development_metrics.total_commits_today' "$DEV_STATE")

        echo "Features completed today: $features_today"
        echo "Commits today: $commits_today"
        echo "Velocity: $(echo "scale=2; $features_today / 1" | bc) features/day"
    fi
}

# Estimate time to completion
estimate() {
    if [ -f "$DEV_STATE" ]; then
        local overall=$(overall_progress)
        local remaining=$(echo "scale=2; 100 - $overall" | bc)

        echo "Overall Progress: ${overall}%"
        echo "Remaining: ${remaining}%"

        # Simple estimate: if current velocity is known
        local velocity=$(echo "scale=2; $(jq '.development_metrics.features_completed_today' "$DEV_STATE") / 1" | bc)
        if [ "$(echo "$velocity > 0" | bc)" -eq 1 ]; then
            local total_features=$(jq '.active_features | length' "$DEV_STATE")
            local completed=$(jq '[.active_features[] | select(.status == "COMPLETED")] | length' "$DEV_STATE")
            local remaining_features=$(echo "$total_features - $completed" | bc)
            local days=$(echo "scale=1; $remaining_features / $velocity" | bc)

            echo "Estimated completion: ${days} development cycles"
        fi
    fi
}

# Generate progress dashboard
dashboard() {
    echo "📊 PROGRESS DASHBOARD"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    if [ -f "$DEV_STATE" ]; then
        # Overall progress
        local overall=$(overall_progress)
        local completed=$(jq '[.active_features[] | select(.status == "COMPLETED")] | length' "$DEV_STATE")
        local in_progress=$(jq '[.active_features[] | select(.status == "IN_PROGRESS")] | length' "$DEV_STATE")
        local pending=$(jq '[.active_features[] | select(.status | contains("PENDING"))] | length' "$DEV_STATE")
        local total=$(jq '.active_features | length' "$DEV_STATE")

        echo "Overall Progress: ${overall}%"
        echo "Features: $completed completed, $in_progress in progress, $pending pending (Total: $total)"
        echo ""

        # Progress bar
        local bar_length=40
        local filled=$(echo "scale=0; $overall * $bar_length / 100" | bc)
        local empty=$((bar_length - filled))

        printf "["
        printf "█%.0s" $(seq 1 $filled 2>/dev/null || echo "")
        printf "░%.0s" $(seq 1 $empty 2>/dev/null || echo "")
        printf "] ${overall}%%\n"
        echo ""

        # Feature breakdown
        echo "Feature Status:"
        jq -r '.active_features[] | "  \(if .status == "COMPLETED" then "✅" elif .status == "IN_PROGRESS" then "🔄" else "⏳" end) \(.name): \(.progress)% - \(.cycle_position)"' "$DEV_STATE"
        echo ""

        # Development metrics
        echo "📈 Today's Metrics:"
        jq -r '.development_metrics | "  Commits: \(.total_commits_today)\n  Features Completed: \(.features_completed_today)\n  Board Checks: \(.board_checks_today)\n  Merge Cycles: \(.merge_cycles_today)"' "$DEV_STATE"
    fi
}

# Main action handler
ACTION="${1:-dashboard}"
shift || true

case "$ACTION" in
    overall)
        overall_progress
        ;;
    feature)
        feature_progress "$@"
        ;;
    velocity)
        velocity
        ;;
    estimate)
        estimate
        ;;
    dashboard)
        dashboard
        ;;
    *)
        echo "Usage: $0 {overall|feature|velocity|estimate|dashboard}"
        exit 1
        ;;
esac
