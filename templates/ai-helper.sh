#!/bin/bash

# AI COLLABORATION HELPER
# Quick access to framework commands
# Install this in your project root as './ai'

# Determine framework location
if [ -f "$(dirname "$0")/setup-ai-collaboration.sh" ]; then
    # We're in the framework repo
    FRAMEWORK_DIR="$(dirname "$0")"
else
    # Look for framework in parent directories or standard locations
    if [ -d "../AI-Collaboration-Management" ]; then
        FRAMEWORK_DIR="../AI-Collaboration-Management"
    elif [ -d "../../AI-Collaboration-Management" ]; then
        FRAMEWORK_DIR="../../AI-Collaboration-Management"
    else
        echo "❌ Cannot find AI-Collaboration-Management framework"
        echo "   Expected in ../AI-Collaboration-Management or ../../AI-Collaboration-Management"
        exit 1
    fi
fi

# Parse command
COMMAND="${1:-help}"

case "$COMMAND" in
    "activate"|"occ"|"prompt")
        # Run OCC activation helper
        bash "$FRAMEWORK_DIR/scripts/activate-occ.sh"
        ;;

    "install")
        # Install/reinstall framework
        bash "$FRAMEWORK_DIR/setup-ai-collaboration.sh"
        ;;

    "status"|"check")
        # Show framework status
        echo "🔍 AI Framework Status"
        echo "━━━━━━━━━━━━━━━━━━━━━━"

        if [ -d ".ai-framework" ]; then
            echo "✅ Framework installed"

            # Show reports
            REPORT_COUNT=$(find .ai-framework/communications/reports -name "AI_REPORT_*.md" 2>/dev/null | wc -l)
            RESPONSE_COUNT=$(find .ai-framework/communications/responses -name "AI_RESPONSE_*.md" 2>/dev/null | wc -l)

            echo "📊 Reports: $REPORT_COUNT"
            echo "📬 Responses: $RESPONSE_COUNT"

            # Show latest activity
            LATEST_REPORT=$(find .ai-framework/communications/reports -name "AI_REPORT_*.md" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)

            if [ -n "$LATEST_REPORT" ]; then
                REPORT_NAME=$(basename "$LATEST_REPORT")
                echo "📋 Latest: $REPORT_NAME"
            fi
        else
            echo "❌ Framework not installed"
            echo "   Run: ./ai install"
        fi
        ;;

    "help"|"-h"|"--help"|*)
        echo "🤖 AI Collaboration Helper"
        echo ""
        echo "Usage: ./ai <command>"
        echo ""
        echo "Commands:"
        echo "  activate, occ, prompt  - Get OCC activation command"
        echo "  install                - Install/reinstall framework"
        echo "  status, check          - Show framework status"
        echo "  help                   - Show this help"
        echo ""
        echo "Examples:"
        echo "  ./ai activate          - Get command to paste to Browser Claude"
        echo "  ./ai status            - Check for validation reports"
        echo "  ./ai install           - Set up framework in this project"
        ;;
esac
