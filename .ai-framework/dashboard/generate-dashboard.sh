#!/bin/bash

# Dashboard Generator - Create current state and progress dashboards
# Usage: ./generate-dashboard.sh

set -e

SCRIPT_DIR="$(dirname "$0")"
STATE_DIR="$SCRIPT_DIR/../state"
VERSIONING_DIR="$SCRIPT_DIR/../versioning"
DASHBOARD_DIR="$SCRIPT_DIR"

# Ensure jq is available
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required for JSON processing"
    exit 1
fi

DEV_STATE="$STATE_DIR/DEVELOPMENT_STATE.json"
BOARD_CHECK_LOG="$STATE_DIR/BOARD_CHECK_LOG.json"
MERGE_CYCLE_LOG="$STATE_DIR/MERGE_CYCLE_LOG.json"

# Generate current state dashboard
generate_current_state() {
    local OUTPUT="$DASHBOARD_DIR/current-state.md"

    cat > "$OUTPUT" << 'HEADER'
# Current Development State

**Auto-Generated Dashboard - Real-Time Development Position**

---

HEADER

    # Get current state
    local version=$(jq -r '.framework_version' "$DEV_STATE")
    local cycle=$(jq -r '.development_cycle' "$DEV_STATE")
    local phase=$(jq -r '.phase' "$DEV_STATE")
    local board_checks=$(jq -r '.board_check_count' "$DEV_STATE")
    local merge_cycle=$(jq -r '.merge_cycle' "$DEV_STATE")
    local last_updated=$(jq -r '.last_updated' "$DEV_STATE")

    cat >> "$OUTPUT" << EOF
## 🎯 **CURRENT POSITION**

\`\`\`
Framework: $version
Cycle: $cycle
Phase: $phase
Board Checks: $board_checks
Merge Status: $merge_cycle
Last Updated: $last_updated
\`\`\`

---

## 🔄 **ACTIVE FEATURES**

EOF

    # Add feature status
    jq -r '.active_features[] | "### \(if .status == "COMPLETED" then "✅" elif .status == "IN_PROGRESS" then "🔄" else "⏳" end) **\(.name | gsub("_"; " ") | ascii_upcase)**\n- **Status:** \(.status)\n- **Progress:** \(.progress)%\n- **Cycle Position:** \(.cycle_position)\n- **Started:** \(.start_date)\n\(if .completion_date then "- **Completed:** \(.completion_date)\n" else "" end)\n"' "$DEV_STATE" >> "$OUTPUT"

    echo "---" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    echo "## 📊 **DEVELOPMENT METRICS**" >> "$OUTPUT"
    echo "" >> "$OUTPUT"

    # Add metrics
    local commits=$(jq -r '.development_metrics.total_commits_today' "$DEV_STATE")
    local features_done=$(jq -r '.development_metrics.features_completed_today' "$DEV_STATE")
    local checks=$(jq -r '.development_metrics.board_checks_today' "$DEV_STATE")
    local merges=$(jq -r '.development_metrics.merge_cycles_today' "$DEV_STATE")

    echo "**Today's Activity:**" >> "$OUTPUT"
    echo "- **Commits:** $commits" >> "$OUTPUT"
    echo "- **Features Completed:** $features_done" >> "$OUTPUT"
    echo "- **Board Checks:** $checks" >> "$OUTPUT"
    echo "- **Merge Cycles:** $merges" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    echo "---" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    echo "## 🎯 **NEXT ACTIONS**" >> "$OUTPUT"
    echo "" >> "$OUTPUT"

    # Get pending and in-progress features
    echo "**In Progress:**" >> "$OUTPUT"
    jq -r '.active_features[] | select(.status == "IN_PROGRESS") | "- \(.name | gsub("_"; " ")) - \(.cycle_position)"' "$DEV_STATE" >> "$OUTPUT"

    echo "" >> "$OUTPUT"
    echo "**Pending Implementation:**" >> "$OUTPUT"
    jq -r '.active_features[] | select(.status | contains("PENDING")) | "- \(.name | gsub("_"; " ")) - \(.cycle_position)"' "$DEV_STATE" >> "$OUTPUT"

    echo "" >> "$OUTPUT"
    echo "---" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    echo "**Dashboard auto-generated from development state tracking system**" >> "$OUTPUT"

    echo "✅ Current state dashboard generated: $OUTPUT"
}

# Generate progress dashboard
generate_progress_dashboard() {
    local OUTPUT="$DASHBOARD_DIR/progress-dashboard.md"

    cat > "$OUTPUT" << 'HEADER'
# Progress Dashboard

**Auto-Generated Progress Tracking - Development Velocity & Completion**

---

HEADER

    # Calculate overall progress
    local total_features=$(jq '.active_features | length' "$DEV_STATE")
    local total_progress=$(jq '[.active_features[].progress] | add' "$DEV_STATE")
    local avg_progress=$(echo "scale=2; $total_progress / $total_features" | bc)

    local completed=$(jq '[.active_features[] | select(.status == "COMPLETED")] | length' "$DEV_STATE")
    local in_progress=$(jq '[.active_features[] | select(.status == "IN_PROGRESS")] | length' "$DEV_STATE")
    local pending=$(jq '[.active_features[] | select(.status | contains("PENDING"))] | length' "$DEV_STATE")

    cat >> "$OUTPUT" << EOF
## 📈 **OVERALL PROGRESS**

**Average Completion:** ${avg_progress}%

**Feature Breakdown:**
- ✅ **Completed:** $completed / $total_features
- 🔄 **In Progress:** $in_progress / $total_features
- ⏳ **Pending:** $pending / $total_features

EOF

    # Generate progress bar
    local bar_length=50
    local filled=$(echo "scale=0; $avg_progress * $bar_length / 100" | bc)
    local empty=$((bar_length - filled))

    echo "\`\`\`" >> "$OUTPUT"
    printf "Progress: [" >> "$OUTPUT"
    if [ "$filled" -gt 0 ]; then
        printf '█%.0s' $(seq 1 $filled) >> "$OUTPUT"
    fi
    if [ "$empty" -gt 0 ]; then
        printf '░%.0s' $(seq 1 $empty) >> "$OUTPUT"
    fi
    printf "] ${avg_progress}%%\n" >> "$OUTPUT"
    echo "\`\`\`" >> "$OUTPUT"

    cat >> "$OUTPUT" << 'EOF'

---

## 🔄 **FEATURE STATUS**

EOF

    # Add detailed feature status
    jq -r '.active_features[] | "### \(.name | gsub("_"; " ") | ascii_upcase)\n\n**Progress:** \(.progress)%\n\n**Status:** \(.status)\n\n**Position:** \(.cycle_position)\n\n---\n"' "$DEV_STATE" >> "$OUTPUT"

    cat >> "$OUTPUT" << 'FOOTER'

## 📊 **DEVELOPMENT VELOCITY**

EOF

    # Add velocity metrics
    local commits=$(jq -r '.development_metrics.total_commits_today' "$DEV_STATE")
    local features=$(jq -r '.development_metrics.features_completed_today' "$DEV_STATE")

    cat >> "$OUTPUT" << EOF
**Today's Velocity:**
- **Commits per Day:** $commits
- **Features per Day:** $features
- **Average Progress:** ${avg_progress}% across all features

EOF

    # Board check frequency
    if [ -f "$BOARD_CHECK_LOG" ]; then
        local total_checks=$(jq -r '.total_checks' "$BOARD_CHECK_LOG")
        local avg_freq=$(jq -r '.average_frequency' "$BOARD_CHECK_LOG")

        cat >> "$OUTPUT" << EOF
**Board Check Frequency:**
- **Total Checks:** $total_checks
- **Average Frequency:** $avg_freq

EOF
    fi

    cat >> "$OUTPUT" << 'FOOTER'
---

**Dashboard auto-generated from development state tracking system**
FOOTER

    echo "✅ Progress dashboard generated: $OUTPUT"
}

# Main execution
echo "🔄 Generating development dashboards..."
echo ""

generate_current_state
generate_progress_dashboard

echo ""
echo "✅ All dashboards generated successfully"
echo ""
echo "📋 View dashboards:"
echo "   - Current State: $DASHBOARD_DIR/current-state.md"
echo "   - Progress: $DASHBOARD_DIR/progress-dashboard.md"
