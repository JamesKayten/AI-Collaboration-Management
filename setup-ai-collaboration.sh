#!/bin/bash

# AI COLLABORATION FRAMEWORK SETUP
# Purpose: Set up cross-environment AI-to-AI collaboration for any project
# Features: Repository-based communication, validation rules, universal compatibility
# Compatible: React, Python, Java, Data Science, and more

set -e

echo "🚀 AI COLLABORATION FRAMEWORK SETUP"
echo "===================================="
echo "📋 Sets up cross-environment AI-to-AI collaboration for your project"
echo

# Default values
PROJECT_TYPE=""
MAX_FILE_SIZE=""
TEST_COVERAGE=""
USE_PRESET=""
INTERACTIVE="true"
LANGUAGE=""
VALIDATION_TOOLS=""

# Help function
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "🎯 WHAT THIS DOES:"
    echo "   • Sets up cross-environment AI-to-AI collaboration (Local AI, OCC, Claude Code, etc.)"
    echo "   • Deploys repository-based communication system (works in any environment)"
    echo "   • Creates project validation rules and communication structure"
    echo "   • Enables universal AI workflow with immediate task execution"
    echo ""
    echo "📋 CONFIGURE WITH:"
    echo ""
    echo "OPTIONS:"
    echo "  --preset TYPE          Use preset configuration (react, python, java, mobile, data-science)"
    echo "  --language LANG        Primary language (python, javascript, typescript, java, go, rust)"
    echo "  --max-file-size SIZE   Maximum file size in lines (e.g., 200, 300, 500)"
    echo "  --test-coverage PCT    Minimum test coverage percentage (e.g., 80, 90, 95)"
    echo "  --validation-tools LIST Comma-separated tools (eslint,prettier,pytest,black,etc.)"
    echo "  --non-interactive      Skip interactive setup wizard"
    echo "  --help                 Show this help message"
    echo ""
    echo "EXAMPLES:"
    echo "  $0 --preset react --max-file-size 150 --test-coverage 85"
    echo "  $0 --language python --validation-tools black,flake8,pytest"
    echo "  $0 --preset data-science --max-file-size 500 --test-coverage 90"
    echo ""
    echo "PRESETS:"
    echo "  react         Web app with React frontend (150 lines, 85% coverage)"
    echo "  python        Python backend/API (300 lines, 90% coverage)"
    echo "  java          Enterprise Java app (400 lines, 85% coverage)"
    echo "  mobile        Mobile backend API (200 lines, 95% coverage)"
    echo "  data-science  ML/Analytics project (500 lines, 80% coverage)"
    echo ""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --preset)
            USE_PRESET="$2"
            INTERACTIVE="false"
            shift 2
            ;;
        --language)
            LANGUAGE="$2"
            shift 2
            ;;
        --max-file-size)
            MAX_FILE_SIZE="$2"
            shift 2
            ;;
        --test-coverage)
            TEST_COVERAGE="$2"
            shift 2
            ;;
        --validation-tools)
            VALIDATION_TOOLS="$2"
            shift 2
            ;;
        --non-interactive)
            INTERACTIVE="false"
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option $1"
            show_help
            exit 1
            ;;
    esac
done

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository. Please run from your project root."
    exit 1
fi

# Get repository root and project name
REPO_ROOT=$(git rev-parse --show-toplevel)
PROJECT_NAME=$(basename "$REPO_ROOT")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

echo "📍 Repository: $REPO_ROOT"
echo "📝 Project: $PROJECT_NAME"

# Apply preset configurations
apply_preset() {
    local preset=$1
    case $preset in
        react)
            PROJECT_TYPE="React Web Application"
            LANGUAGE="javascript"
            MAX_FILE_SIZE="${MAX_FILE_SIZE:-150}"
            TEST_COVERAGE="${TEST_COVERAGE:-85}"
            VALIDATION_TOOLS="${VALIDATION_TOOLS:-eslint,prettier,jest}"
            ;;
        python)
            PROJECT_TYPE="Python Backend/API"
            LANGUAGE="python"
            MAX_FILE_SIZE="${MAX_FILE_SIZE:-300}"
            TEST_COVERAGE="${TEST_COVERAGE:-90}"
            VALIDATION_TOOLS="${VALIDATION_TOOLS:-black,flake8,pytest}"
            ;;
        java)
            PROJECT_TYPE="Enterprise Java Application"
            LANGUAGE="java"
            MAX_FILE_SIZE="${MAX_FILE_SIZE:-400}"
            TEST_COVERAGE="${TEST_COVERAGE:-85}"
            VALIDATION_TOOLS="${VALIDATION_TOOLS:-checkstyle,spotbugs,junit}"
            ;;
        mobile)
            PROJECT_TYPE="Mobile Backend API"
            LANGUAGE="auto-detect"
            MAX_FILE_SIZE="${MAX_FILE_SIZE:-200}"
            TEST_COVERAGE="${TEST_COVERAGE:-95}"
            VALIDATION_TOOLS="${VALIDATION_TOOLS:-auto-detect}"
            ;;
        data-science)
            PROJECT_TYPE="Data Science/ML Project"
            LANGUAGE="python"
            MAX_FILE_SIZE="${MAX_FILE_SIZE:-500}"
            TEST_COVERAGE="${TEST_COVERAGE:-80}"
            VALIDATION_TOOLS="${VALIDATION_TOOLS:-black,pylint,pytest,jupyter}"
            ;;
        *)
            echo "❌ Unknown preset: $preset"
            echo "Available presets: react, python, java, mobile, data-science"
            exit 1
            ;;
    esac
}

# Interactive configuration wizard
interactive_setup() {
    echo ""
    echo "🧙 Interactive Configuration Wizard"
    echo "==================================="

    # Project type selection
    echo ""
    echo "What type of project is this?"
    echo "1) React/Vue Web App"
    echo "2) Python Backend/API"
    echo "3) Java Enterprise App"
    echo "4) Mobile Backend"
    echo "5) Data Science/ML"
    echo "6) Custom Configuration"

    read -p "Select option (1-6): " project_choice

    case $project_choice in
        1) apply_preset "react" ;;
        2) apply_preset "python" ;;
        3) apply_preset "java" ;;
        4) apply_preset "mobile" ;;
        5) apply_preset "data-science" ;;
        6)
            echo ""
            read -p "Primary language: " LANGUAGE
            read -p "Max file size (lines): " MAX_FILE_SIZE
            read -p "Min test coverage (%): " TEST_COVERAGE
            read -p "Validation tools (comma-separated): " VALIDATION_TOOLS
            PROJECT_TYPE="Custom Project"
            ;;
        *)
            echo "Invalid choice, using defaults"
            PROJECT_TYPE="Custom Project"
            ;;
    esac
}

# Auto-detect project characteristics
auto_detect() {
    echo "🔍 Auto-detecting project characteristics..."

    # Detect language
    if [[ -f "package.json" ]]; then
        LANGUAGE="${LANGUAGE:-javascript}"
        if grep -q "react" package.json; then
            PROJECT_TYPE="${PROJECT_TYPE:-React Application}"
        elif grep -q "vue" package.json; then
            PROJECT_TYPE="${PROJECT_TYPE:-Vue Application}"
        else
            PROJECT_TYPE="${PROJECT_TYPE:-Node.js Application}"
        fi
    elif [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]] || [[ -f "pyproject.toml" ]]; then
        LANGUAGE="${LANGUAGE:-python}"
        PROJECT_TYPE="${PROJECT_TYPE:-Python Application}"
    elif [[ -f "pom.xml" ]] || [[ -f "build.gradle" ]]; then
        LANGUAGE="${LANGUAGE:-java}"
        PROJECT_TYPE="${PROJECT_TYPE:-Java Application}"
    elif [[ -f "go.mod" ]]; then
        LANGUAGE="${LANGUAGE:-go}"
        PROJECT_TYPE="${PROJECT_TYPE:-Go Application}"
    elif [[ -f "Cargo.toml" ]]; then
        LANGUAGE="${LANGUAGE:-rust}"
        PROJECT_TYPE="${PROJECT_TYPE:-Rust Application}"
    fi

    # Set defaults based on detected language
    case $LANGUAGE in
        javascript|typescript)
            MAX_FILE_SIZE="${MAX_FILE_SIZE:-200}"
            TEST_COVERAGE="${TEST_COVERAGE:-85}"
            ;;
        python)
            MAX_FILE_SIZE="${MAX_FILE_SIZE:-300}"
            TEST_COVERAGE="${TEST_COVERAGE:-90}"
            ;;
        java)
            MAX_FILE_SIZE="${MAX_FILE_SIZE:-400}"
            TEST_COVERAGE="${TEST_COVERAGE:-85}"
            ;;
        *)
            MAX_FILE_SIZE="${MAX_FILE_SIZE:-250}"
            TEST_COVERAGE="${TEST_COVERAGE:-80}"
            ;;
    esac
}

# Generate validation commands based on project type
generate_validation_commands() {
    case $LANGUAGE in
        javascript|typescript)
            echo "npm run lint"
            echo "npm test -- --coverage --coverageThreshold='{\"global\":{\"branches\":$TEST_COVERAGE,\"functions\":$TEST_COVERAGE,\"lines\":$TEST_COVERAGE}}'"
            ;;
        python)
            echo "black --check ."
            echo "flake8 --max-line-length=88 ."
            echo "pytest --cov=. --cov-report=term-missing --cov-fail-under=$TEST_COVERAGE"
            ;;
        java)
            echo "./gradlew checkstyleMain"
            echo "./gradlew test"
            echo "./gradlew jacocoTestCoverageVerification"
            ;;
        *)
            echo "# Add validation commands for $LANGUAGE"
            echo "# Example: run your linter, tests, etc."
            ;;
    esac
}

# Generate project-specific rules
generate_project_specific_rules() {
    case $PROJECT_TYPE in
        *React*)
            echo "- Components should be under $MAX_FILE_SIZE lines"
            echo "- Bundle size should be under 1MB"
            echo "- All components should have propTypes or TypeScript"
            ;;
        *Python*)
            echo "- Functions should be under 50 lines"
            echo "- Classes should be under 200 lines"
            echo "- All public functions need docstrings"
            ;;
        *Java*)
            echo "- Classes should be under $MAX_FILE_SIZE lines"
            echo "- Methods should be under 100 lines"
            echo "- All public methods need JavaDoc"
            ;;
        *)
            echo "- Add project-specific rules here"
            echo "- Customize based on your team's standards"
            ;;
    esac
}

# Run configuration logic
if [[ -n "$USE_PRESET" ]]; then
    echo "📋 Applying preset: $USE_PRESET"
    apply_preset "$USE_PRESET"
elif [[ "$INTERACTIVE" == "true" ]]; then
    interactive_setup
else
    auto_detect
fi

# Display final configuration
echo ""
echo "📊 Final Configuration:"
echo "======================="
echo "Project Type: $PROJECT_TYPE"
echo "Language: $LANGUAGE"
echo "Max File Size: $MAX_FILE_SIZE lines"
echo "Test Coverage: $TEST_COVERAGE%"
echo "Validation Tools: $VALIDATION_TOOLS"

# Create framework structure
echo ""
echo "📁 Creating framework structure..."
mkdir -p "$REPO_ROOT/docs/ai_communication"

# Generate customized AI_WORKFLOW.md with project-specific configuration
echo "📄 Generating AI_WORKFLOW.md..."
cat > "$REPO_ROOT/docs/AI_WORKFLOW.md" << EOF
# AI Collaboration Workflow for $PROJECT_NAME

## Project Configuration
**Type:** $PROJECT_TYPE
**Language:** $LANGUAGE
**Max File Size:** $MAX_FILE_SIZE lines
**Test Coverage:** $TEST_COVERAGE%
**Validation Tools:** $VALIDATION_TOOLS

## "Work Ready" Command Workflow

When you say **"work ready"**, Local AI should execute this automated workflow:

### 1. Check AI Communications
**FIRST:** Check for communications from Online AI
- Check \`docs/ai_communication/\` for new files since last run
- Process any \`AI_RESPONSE_*.md\` files (fixes completed)
- Process any \`AI_UPDATE_*.md\` files (general updates/questions)
- Report AI communications to user

### 2. Repository Branch Inspection
- Check for new branches created by Online AI
- Use \`git fetch\` to get latest remote branches
- Identify branches that aren't \`main\` or previously known

### 3. Validation Check
Apply $PROJECT_NAME-specific validation rules:

**File Size Limits:**
- Maximum: $MAX_FILE_SIZE lines per file
- Check with: \`find . -name "*.py" -o -name "*.js" -o -name "*.java" | xargs wc -l | awk '\$1 > $MAX_FILE_SIZE {print "VIOLATION: " \$2 " has " \$1 " lines (limit: $MAX_FILE_SIZE)"}'\`

**Test Coverage:**
- Minimum: $TEST_COVERAGE% coverage required

**Code Quality Tools:**
- Configured: $VALIDATION_TOOLS

### 4. Violation Response
If violations found:
- **STOP** merge process immediately
- Create \`docs/ai_communication/AI_REPORT_YYYY-MM-DD.md\`
- Include specific remediation instructions
- Notify user with OCC activation command

### 5. Clean Merge
If all validations pass:
- Merge branch to main
- Push to remote
- Clean up branches
- Report success

## Project-Specific Validation Commands

\`\`\`bash
$(generate_validation_commands)
\`\`\`

---
**Project**: $PROJECT_NAME ($PROJECT_TYPE)
**Configuration**: Auto-generated by Avery's AI Collaboration Hack
**Parameters**: File size: $MAX_FILE_SIZE lines, Coverage: $TEST_COVERAGE%, Tools: $VALIDATION_TOOLS
EOF

# Generate customized VALIDATION_RULES.md
echo "📄 Generating VALIDATION_RULES.md..."
cat > "$REPO_ROOT/docs/ai_communication/VALIDATION_RULES.md" << EOF
# Validation Rules for $PROJECT_NAME

## Project Configuration
- **Type:** $PROJECT_TYPE
- **Language:** $LANGUAGE
- **Generated:** $(date)

## File Size Limits
**Maximum file size:** $MAX_FILE_SIZE lines

\`\`\`bash
# Check file sizes
find . -name "*.py" -o -name "*.js" -o -name "*.java" -o -name "*.go" -o -name "*.rs" | xargs wc -l | awk '\$1 > $MAX_FILE_SIZE {print "VIOLATION: " \$2 " has " \$1 " lines (limit: $MAX_FILE_SIZE)"}'
\`\`\`

## Test Coverage Requirements
**Minimum coverage:** $TEST_COVERAGE%

## Validation Tools
**Configured tools:** $VALIDATION_TOOLS

\`\`\`bash
$(generate_validation_commands)
\`\`\`

## Custom Rules for $PROJECT_TYPE
$(generate_project_specific_rules)

## Override Instructions
To modify these rules:
1. Edit this file directly
2. Run \`git add docs/\` and \`git commit -m "Update validation rules"\`
3. The AIs will use your updated rules immediately

---
**Auto-generated by Avery's AI Collaboration Hack**
**Customizable**: Feel free to modify these rules for your project needs
EOF

# Copy remaining template files with customization
echo "📄 Installing remaining framework files..."
cp "$SCRIPT_DIR/templates/ai_communication_README.md" "$REPO_ROOT/docs/ai_communication/README.md"
cp "$SCRIPT_DIR/templates/FRAMEWORK_OVERVIEW.md" "$REPO_ROOT/docs/AI_COLLABORATION_FRAMEWORK.md"

# Replace placeholders in copied files
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$REPO_ROOT/docs/ai_communication/README.md"
else
    sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$REPO_ROOT/docs/ai_communication/README.md"
fi

# Deploy Repository-Based AI Collaboration (Cross-Environment)
echo "🤖 Installing repository-based AI collaboration..."
mkdir -p "$REPO_ROOT/.ai"

# Deploy repository-based AI collaboration files
cp "$SCRIPT_DIR/templates/.ai/README_TEMPLATE.md" "$REPO_ROOT/.ai/README.md"
cp "$SCRIPT_DIR/templates/.ai/BEHAVIOR_RULES_TEMPLATE.md" "$REPO_ROOT/.ai/BEHAVIOR_RULES.md"
cp "$SCRIPT_DIR/templates/.ai/CURRENT_TASK_TEMPLATE.md" "$REPO_ROOT/.ai/CURRENT_TASK.md"

# Deploy enhanced task framework files (OCC improvements)
cp "$SCRIPT_DIR/templates/.ai/STATUS_TEMPLATE" "$REPO_ROOT/.ai/STATUS"
cp "$SCRIPT_DIR/templates/.ai/FRAMEWORK_USAGE.md" "$REPO_ROOT/.ai/FRAMEWORK_USAGE.md"
cp "$SCRIPT_DIR/templates/.ai/TCC_QUICK_REFERENCE.md" "$REPO_ROOT/.ai/TCC_QUICK_REFERENCE.md"
cp "$SCRIPT_DIR/templates/.ai/CURRENT_TASK.md.TEMPLATE" "$REPO_ROOT/.ai/CURRENT_TASK.md.TEMPLATE"
cp "$SCRIPT_DIR/templates/.ai/check-tasks.sh" "$REPO_ROOT/.ai/check-tasks.sh"
chmod +x "$REPO_ROOT/.ai/check-tasks.sh"

# Replace placeholders in AI collaboration files
# Escape special characters for sed
PROJECT_TYPE_ESCAPED=$(echo "$PROJECT_TYPE" | sed 's/[\/&]/\\&/g')
PROJECT_NAME_ESCAPED=$(echo "$PROJECT_NAME" | sed 's/[\/&]/\\&/g')
VALIDATION_TOOLS_ESCAPED=$(echo "$VALIDATION_TOOLS" | sed 's/[\/&]/\\&/g')

if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/{{PROJECT_NAME}}/$PROJECT_NAME_ESCAPED/g" "$REPO_ROOT/.ai/README.md"
    sed -i '' "s/{{PROJECT_TYPE}}/$PROJECT_TYPE_ESCAPED/g" "$REPO_ROOT/.ai/README.md"
    sed -i '' "s/{{LANGUAGE}}/$LANGUAGE/g" "$REPO_ROOT/.ai/README.md"
    sed -i '' "s/{{MAX_FILE_SIZE}}/$MAX_FILE_SIZE/g" "$REPO_ROOT/.ai/README.md"
    sed -i '' "s/{{TEST_COVERAGE}}/$TEST_COVERAGE/g" "$REPO_ROOT/.ai/README.md"
    sed -i '' "s/{{VALIDATION_TOOLS}}/$VALIDATION_TOOLS_ESCAPED/g" "$REPO_ROOT/.ai/README.md"

    sed -i '' "s/{{PROJECT_TYPE}}/$PROJECT_TYPE_ESCAPED/g" "$REPO_ROOT/.ai/BEHAVIOR_RULES.md"
    sed -i '' "s/{{MAX_FILE_SIZE}}/$MAX_FILE_SIZE/g" "$REPO_ROOT/.ai/BEHAVIOR_RULES.md"
    sed -i '' "s/{{TEST_COVERAGE}}/$TEST_COVERAGE/g" "$REPO_ROOT/.ai/BEHAVIOR_RULES.md"
    sed -i '' "s/{{VALIDATION_TOOLS}}/$VALIDATION_TOOLS_ESCAPED/g" "$REPO_ROOT/.ai/BEHAVIOR_RULES.md"

    sed -i '' "s/{{PROJECT_NAME}}/$PROJECT_NAME_ESCAPED/g" "$REPO_ROOT/.ai/CURRENT_TASK.md"
    sed -i '' "s/{{PROJECT_TYPE}}/$PROJECT_TYPE_ESCAPED/g" "$REPO_ROOT/.ai/CURRENT_TASK.md"
    sed -i '' "s/{{LANGUAGE}}/$LANGUAGE/g" "$REPO_ROOT/.ai/CURRENT_TASK.md"
    sed -i '' "s/{{MAX_FILE_SIZE}}/$MAX_FILE_SIZE/g" "$REPO_ROOT/.ai/CURRENT_TASK.md"
    sed -i '' "s/{{TEST_COVERAGE}}/$TEST_COVERAGE/g" "$REPO_ROOT/.ai/CURRENT_TASK.md"
    sed -i '' "s/{{VALIDATION_TOOLS}}/$VALIDATION_TOOLS_ESCAPED/g" "$REPO_ROOT/.ai/CURRENT_TASK.md"

    # Replace placeholders in STATUS file (OCC framework enhancement)
    sed -i '' "s/{{PROJECT_NAME}}/$PROJECT_NAME_ESCAPED/g" "$REPO_ROOT/.ai/STATUS"
    sed -i '' "s/{{TIMESTAMP}}/$(date -u +%Y-%m-%dT%H:%M:%SZ)/g" "$REPO_ROOT/.ai/STATUS"
else
    sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME_ESCAPED/g" "$REPO_ROOT/.ai/README.md"
    sed -i "s/{{PROJECT_TYPE}}/$PROJECT_TYPE_ESCAPED/g" "$REPO_ROOT/.ai/README.md"
    sed -i "s/{{LANGUAGE}}/$LANGUAGE/g" "$REPO_ROOT/.ai/README.md"
    sed -i "s/{{MAX_FILE_SIZE}}/$MAX_FILE_SIZE/g" "$REPO_ROOT/.ai/README.md"
    sed -i "s/{{TEST_COVERAGE}}/$TEST_COVERAGE/g" "$REPO_ROOT/.ai/README.md"
    sed -i "s/{{VALIDATION_TOOLS}}/$VALIDATION_TOOLS_ESCAPED/g" "$REPO_ROOT/.ai/README.md"

    sed -i "s/{{PROJECT_TYPE}}/$PROJECT_TYPE_ESCAPED/g" "$REPO_ROOT/.ai/BEHAVIOR_RULES.md"
    sed -i "s/{{MAX_FILE_SIZE}}/$MAX_FILE_SIZE/g" "$REPO_ROOT/.ai/BEHAVIOR_RULES.md"
    sed -i "s/{{TEST_COVERAGE}}/$TEST_COVERAGE/g" "$REPO_ROOT/.ai/BEHAVIOR_RULES.md"
    sed -i "s/{{VALIDATION_TOOLS}}/$VALIDATION_TOOLS_ESCAPED/g" "$REPO_ROOT/.ai/BEHAVIOR_RULES.md"

    sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME_ESCAPED/g" "$REPO_ROOT/.ai/CURRENT_TASK.md"
    sed -i "s/{{PROJECT_TYPE}}/$PROJECT_TYPE_ESCAPED/g" "$REPO_ROOT/.ai/CURRENT_TASK.md"
    sed -i "s/{{LANGUAGE}}/$LANGUAGE/g" "$REPO_ROOT/.ai/CURRENT_TASK.md"
    sed -i "s/{{MAX_FILE_SIZE}}/$MAX_FILE_SIZE/g" "$REPO_ROOT/.ai/CURRENT_TASK.md"
    sed -i "s/{{TEST_COVERAGE}}/$TEST_COVERAGE/g" "$REPO_ROOT/.ai/CURRENT_TASK.md"
    sed -i "s/{{VALIDATION_TOOLS}}/$VALIDATION_TOOLS_ESCAPED/g" "$REPO_ROOT/.ai/CURRENT_TASK.md"

    # Replace placeholders in STATUS file (OCC framework enhancement)
    sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME_ESCAPED/g" "$REPO_ROOT/.ai/STATUS"
    sed -i "s/{{TIMESTAMP}}/$(date -u +%Y-%m-%dT%H:%M:%SZ)/g" "$REPO_ROOT/.ai/STATUS"
fi

# Deploy session recovery system
echo "📸 Deploying session recovery system..."
mkdir -p "$REPO_ROOT/.ai-framework/session-recovery"

# Escape PROJECT_PATH for sed
PROJECT_PATH_ESCAPED=$(echo "$REPO_ROOT" | sed 's/[\/&]/\\&/g')

# Copy and customize session recovery templates
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS version (BSD sed)
    sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME_ESCAPED/g" \
        -e "s/{{PROJECT_TYPE}}/$PROJECT_TYPE_ESCAPED/g" \
        -e "s/{{MAX_FILE_SIZE}}/$MAX_FILE_SIZE/g" \
        -e "s/{{TEST_COVERAGE}}/$TEST_COVERAGE/g" \
        -e "s/{{VALIDATION_TOOLS}}/$VALIDATION_TOOLS_ESCAPED/g" \
        -e "s|{{PROJECT_PATH}}|$PROJECT_PATH_ESCAPED|g" \
        "$SCRIPT_DIR/templates/session-recovery/create_session_snapshot_template.sh" \
        > "$REPO_ROOT/create_session_snapshot.sh"

    sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME_ESCAPED/g" \
        -e "s/{{PROJECT_TYPE}}/$PROJECT_TYPE_ESCAPED/g" \
        "$SCRIPT_DIR/templates/session-recovery/restore_session_template.sh" \
        > "$REPO_ROOT/restore_session.sh"

    sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME_ESCAPED/g" \
        -e "s/{{PROJECT_TYPE}}/$PROJECT_TYPE_ESCAPED/g" \
        -e "s/{{MAX_FILE_SIZE}}/$MAX_FILE_SIZE/g" \
        -e "s/{{TEST_COVERAGE}}/$TEST_COVERAGE/g" \
        -e "s/{{VALIDATION_TOOLS}}/$VALIDATION_TOOLS_ESCAPED/g" \
        -e "s|{{PROJECT_PATH}}|$PROJECT_PATH_ESCAPED|g" \
        "$SCRIPT_DIR/templates/session-recovery/CURRENT_SESSION_STATE_TEMPLATE.md" \
        > "$REPO_ROOT/.ai-framework/session-recovery/CURRENT_SESSION_STATE.md"
else
    # Linux version (GNU sed)
    sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME_ESCAPED/g" \
        -e "s/{{PROJECT_TYPE}}/$PROJECT_TYPE_ESCAPED/g" \
        -e "s/{{MAX_FILE_SIZE}}/$MAX_FILE_SIZE/g" \
        -e "s/{{TEST_COVERAGE}}/$TEST_COVERAGE/g" \
        -e "s/{{VALIDATION_TOOLS}}/$VALIDATION_TOOLS_ESCAPED/g" \
        -e "s|{{PROJECT_PATH}}|$PROJECT_PATH_ESCAPED|g" \
        "$SCRIPT_DIR/templates/session-recovery/create_session_snapshot_template.sh" \
        > "$REPO_ROOT/create_session_snapshot.sh"

    sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME_ESCAPED/g" \
        -e "s/{{PROJECT_TYPE}}/$PROJECT_TYPE_ESCAPED/g" \
        "$SCRIPT_DIR/templates/session-recovery/restore_session_template.sh" \
        > "$REPO_ROOT/restore_session.sh"

    sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME_ESCAPED/g" \
        -e "s/{{PROJECT_TYPE}}/$PROJECT_TYPE_ESCAPED/g" \
        -e "s/{{MAX_FILE_SIZE}}/$MAX_FILE_SIZE/g" \
        -e "s/{{TEST_COVERAGE}}/$TEST_COVERAGE/g" \
        -e "s/{{VALIDATION_TOOLS}}/$VALIDATION_TOOLS_ESCAPED/g" \
        -e "s|{{PROJECT_PATH}}|$PROJECT_PATH_ESCAPED|g" \
        "$SCRIPT_DIR/templates/session-recovery/CURRENT_SESSION_STATE_TEMPLATE.md" \
        > "$REPO_ROOT/.ai-framework/session-recovery/CURRENT_SESSION_STATE.md"
fi

# Make scripts executable
chmod +x "$REPO_ROOT/create_session_snapshot.sh"
chmod +x "$REPO_ROOT/restore_session.sh"

echo "✅ Session recovery system deployed!"
echo "✅ Repository-based AI collaboration installed!"
echo "✅ Enhanced task framework (OCC improvements) installed!"
echo "✅ Installation complete!"
echo ""
echo "📋 Your Custom Configuration:"
echo "   Project: $PROJECT_NAME ($PROJECT_TYPE)"
echo "   Language: $LANGUAGE"
echo "   Max File Size: $MAX_FILE_SIZE lines"
echo "   Test Coverage: $TEST_COVERAGE%"
echo "   Tools: $VALIDATION_TOOLS"
echo ""
echo "🚀 Ready for cross-environment AI collaboration with:"
echo "   'work ready' (Local AI command)"
echo "   'Check docs/ai_communication/ for latest report' (Online AI)"
echo ""
echo "📁 Repository-Based AI Communication:"
echo "   .ai/README.md - Start here for any AI instance"
echo "   .ai/BEHAVIOR_RULES.md - Working style requirements"
echo "   .ai/CURRENT_TASK.md - Current assignment"
echo "   Works in any environment (macOS, Linux, containers)"
echo ""
echo "🔧 Customize further by editing:"
echo "   docs/ai_communication/VALIDATION_RULES.md"
echo "   .ai/BEHAVIOR_RULES.md"
echo "   .ai/CURRENT_TASK.md"
echo ""
echo "💡 Pro tip: Use presets next time with:"
echo "   $0 --preset python --max-file-size 250"
echo ""
echo "⚡ Cross-Environment AI Workflow:"
echo "   1. Any AI reads .ai/README.md and .ai/CURRENT_TASK.md"
echo "   2. AI executes tasks immediately - no exploration required"
echo "   3. AI updates .ai/CURRENT_TASK.md when completed"
echo "   4. Universal compatibility across all environments"
echo ""
echo "📸 Session Recovery System:"
echo "   ./restore_session.sh - Restore work state in 5-10 seconds"
echo "   ./create_session_snapshot.sh - Capture session state when ending work"
echo "   .ai-framework/session-recovery/CURRENT_SESSION_STATE.md - Real-time state tracking"
echo "   60x faster recovery than manual session restoration"
echo ""
echo "🎯 Avery's AI Collaboration Framework configured for $PROJECT_NAME!"
echo "🌍 Universal: Works with Local AI, OCC, Claude Code, and more!"