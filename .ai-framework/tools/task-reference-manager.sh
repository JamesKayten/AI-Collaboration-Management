#!/bin/bash

# Task Reference Manager - Track numbered tasks
# Usage: ./task-reference-manager.sh [add|complete|list|status] [task_description]

FRAMEWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TASK_DB="$FRAMEWORK_ROOT/state/TASK_REFERENCES.json"

# Initialize task database if it doesn't exist
if [ ! -f "$TASK_DB" ]; then
    cat > "$TASK_DB" << 'EOF'
{
    "next_task_id": 1,
    "tasks": []
}
EOF
fi

case "$1" in
    "add")
        DESCRIPTION="$2"
        TASK_ID=$(jq -r '.next_task_id' "$TASK_DB")
        REF_NUM="TK-$(printf "%03d" $TASK_ID)"

        # Add task
        jq --arg ref "$REF_NUM" --arg desc "$DESCRIPTION" '.tasks += [{"ref": $ref, "description": $desc, "status": "PENDING", "created": "'$(date -Iseconds)'"}] | .next_task_id += 1' "$TASK_DB" > tmp.json && mv tmp.json "$TASK_DB"

        echo "$REF_NUM"
        ;;

    "complete")
        REF_NUM="$2"

        # Check if proof verification system exists
        if [ -f "$FRAMEWORK_ROOT/verification/proof-of-completion.sh" ]; then
            # Check if proof exists for this task
            if ! "$FRAMEWORK_ROOT/verification/proof-of-completion.sh" check "$REF_NUM" >/dev/null 2>&1; then
                echo "❌ COMPLETION BLOCKED: No proof provided for $REF_NUM"
                echo ""
                echo "🔍 PROOF REQUIRED before marking task complete."
                echo "Run: .ai-framework/verification/proof-of-completion.sh require $REF_NUM"
                echo ""
                echo "Provide evidence that the task was actually completed successfully."
                exit 1
            fi
        fi

        jq --arg ref "$REF_NUM" '(.tasks[] | select(.ref == $ref) | .status) = "COMPLETE" | (.tasks[] | select(.ref == $ref) | .completed) = "'$(date -Iseconds)'"' "$TASK_DB" > tmp.json && mv tmp.json "$TASK_DB"
        echo "✅ $REF_NUM marked complete"
        ;;

    "list")
        echo "## TASK REFERENCES"
        jq -r '.tasks[] | "\(.ref): \(.status) - \(.description)"' "$TASK_DB"
        ;;

    "pending")
        jq -r '.tasks[] | select(.status == "PENDING") | "\(.ref): \(.description)"' "$TASK_DB"
        ;;

    *)
        echo "Usage: $0 [add|complete|list|pending] [description|ref_number]"
        exit 1
        ;;
esac