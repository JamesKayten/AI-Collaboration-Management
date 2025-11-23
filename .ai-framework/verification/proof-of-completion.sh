#!/bin/bash

# Proof of Completion Verification System
# Forces TCC/OCC to provide actual evidence before marking tasks complete

set -e

FRAMEWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROOF_DIR="$FRAMEWORK_ROOT/verification/proof"
TASK_DB="$FRAMEWORK_ROOT/state/TASK_REFERENCES.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

mkdir -p "$PROOF_DIR"

# Require proof before completing any task
require_proof() {
    local task_ref="$1"
    local task_description="$2"

    echo -e "${YELLOW}🔍 PROOF REQUIRED: $task_ref${NC}"
    echo "Task: $task_description"
    echo ""

    # Determine proof requirements based on task type
    if [[ "$task_description" =~ "SlashCommand" ]]; then
        require_slashcommand_proof "$task_ref"
    elif [[ "$task_description" =~ "framework distribution" ]]; then
        require_framework_proof "$task_ref"
    elif [[ "$task_description" =~ "fix" || "$task_description" =~ "Fix" ]]; then
        require_fix_proof "$task_ref"
    else
        require_general_proof "$task_ref"
    fi
}

# SlashCommand fix proof requirements
require_slashcommand_proof() {
    local task_ref="$1"

    echo -e "${BLUE}📋 SLASHCOMMAND FIX PROOF REQUIREMENTS:${NC}"
    echo ""
    echo "🚨 BEFORE MARKING COMPLETE, PROVIDE:"
    echo ""
    echo "1. **Test Repository Setup:**"
    echo "   - Create fresh test repository OR use existing repository with SlashCommand errors"
    echo "   - Save repository URL for verification"
    echo ""
    echo "2. **Before Fix Evidence:**"
    echo "   - Screenshot of SlashCommand permission error"
    echo "   - OR copy/paste of exact error message"
    echo ""
    echo "3. **Fix Application:**"
    echo "   - Run: curl -s https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/EMERGENCY_SLASHCOMMAND_FIX.sh | bash"
    echo "   - OR manually apply the SlashCommand fix"
    echo ""
    echo "4. **After Fix Testing:**"
    echo "   - Screenshot of /check-the-board working WITHOUT permission errors"
    echo "   - Copy/paste of successful board check output"
    echo ""
    echo "5. **Evidence Files Required:**"
    echo "   - Before: error screenshot/message"
    echo "   - After: working screenshot/output"
    echo "   - Repository URL used for testing"
    echo ""

    create_proof_template "$task_ref" "slashcommand"
}

# Framework distribution proof requirements
require_framework_proof() {
    local task_ref="$1"

    echo -e "${BLUE}📋 FRAMEWORK DISTRIBUTION PROOF REQUIREMENTS:${NC}"
    echo ""
    echo "🚨 BEFORE MARKING COMPLETE, PROVIDE:"
    echo ""
    echo "1. **Fresh Repository Test:**"
    echo "   - Create completely new repository"
    echo "   - Run framework installer"
    echo "   - Save repository URL"
    echo ""
    echo "2. **Installation Evidence:**"
    echo "   - Screenshot of installer running successfully"
    echo "   - Copy/paste of installer output"
    echo ""
    echo "3. **Functionality Testing:**"
    echo "   - Screenshot of /check-the-board working in new repository"
    echo "   - Verify no permission errors"
    echo "   - Test board status file reading"
    echo ""
    echo "4. **File Verification:**"
    echo "   - Screenshot showing .claude/commands/check-the-board.md exists"
    echo "   - Screenshot showing .ai-framework/ directory structure"
    echo ""

    create_proof_template "$task_ref" "framework"
}

# General fix proof requirements
require_fix_proof() {
    local task_ref="$1"

    echo -e "${BLUE}📋 FIX PROOF REQUIREMENTS:${NC}"
    echo ""
    echo "🚨 BEFORE MARKING COMPLETE, PROVIDE:"
    echo ""
    echo "1. **Problem Demonstration:**"
    echo "   - Evidence the problem exists (screenshot/error message)"
    echo ""
    echo "2. **Fix Implementation:**"
    echo "   - Code changes made"
    echo "   - Files modified"
    echo ""
    echo "3. **Testing Evidence:**"
    echo "   - Screenshot/output showing fix works"
    echo "   - Problem no longer occurs"
    echo ""

    create_proof_template "$task_ref" "fix"
}

# General proof requirements
require_general_proof() {
    local task_ref="$1"

    echo -e "${BLUE}📋 COMPLETION PROOF REQUIREMENTS:${NC}"
    echo ""
    echo "🚨 BEFORE MARKING COMPLETE, PROVIDE:"
    echo ""
    echo "1. **Work Evidence:**"
    echo "   - Screenshot or copy/paste of completed work"
    echo ""
    echo "2. **Testing Results:**"
    echo "   - Evidence that implementation works as intended"
    echo ""
    echo "3. **Deliverables:**"
    echo "   - All promised deliverables completed and demonstrated"
    echo ""

    create_proof_template "$task_ref" "general"
}

# Create proof template file
create_proof_template() {
    local task_ref="$1"
    local proof_type="$2"

    cat > "$PROOF_DIR/${task_ref}_PROOF_REQUIRED.md" << EOF
# 🔍 PROOF OF COMPLETION REQUIRED: $task_ref

## STATUS: ❌ PROOF PENDING

**Task cannot be marked complete until proof is provided.**

## PROOF REQUIREMENTS:

### Before Fix:
- [ ] Screenshot/evidence of problem existing
- [ ] Error messages or broken functionality documented

### Fix Implementation:
- [ ] Code changes documented
- [ ] Files modified listed
- [ ] Repository/location where fix applied

### After Fix Testing:
- [ ] Screenshot/evidence of fix working
- [ ] Problem resolved and no longer occurs
- [ ] Full functionality tested and verified

## SUBMIT PROOF:

Replace this section with actual proof:

\`\`\`
BEFORE FIX EVIDENCE:
[Screenshot/error message here]

FIX IMPLEMENTATION:
[What was changed/where]

AFTER FIX EVIDENCE:
[Screenshot/success message here]

TESTING VERIFICATION:
[Proof it actually works]
\`\`\`

## VERIFICATION CHECKLIST:

- [ ] Problem clearly demonstrated before fix
- [ ] Fix implementation documented
- [ ] Success clearly demonstrated after fix
- [ ] Independent testing confirms fix works
- [ ] All deliverables completed as promised

**DO NOT MARK TASK COMPLETE WITHOUT COMPLETING THIS PROOF.**
EOF

    echo -e "${RED}📄 Proof template created: $PROOF_DIR/${task_ref}_PROOF_REQUIRED.md${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  TASK COMPLETION BLOCKED UNTIL PROOF PROVIDED${NC}"
}

# Check if proof exists for a task
check_proof_exists() {
    local task_ref="$1"

    if [ -f "$PROOF_DIR/${task_ref}_PROOF_COMPLETED.md" ]; then
        echo -e "${GREEN}✅ Proof exists for $task_ref${NC}"
        return 0
    elif [ -f "$PROOF_DIR/${task_ref}_PROOF_REQUIRED.md" ]; then
        echo -e "${YELLOW}⚠️  Proof required but not provided for $task_ref${NC}"
        return 1
    else
        echo -e "${RED}❌ No proof process started for $task_ref${NC}"
        return 1
    fi
}

# Verify proof and allow task completion
verify_proof() {
    local task_ref="$1"
    local proof_file="$PROOF_DIR/${task_ref}_PROOF_REQUIRED.md"

    if [ ! -f "$proof_file" ]; then
        echo -e "${RED}❌ No proof template found for $task_ref${NC}"
        return 1
    fi

    echo -e "${YELLOW}🔍 Reviewing proof for $task_ref...${NC}"
    echo ""
    echo "Proof file location: $proof_file"
    echo ""
    echo "Review the proof and confirm it demonstrates:"
    echo "1. Problem existed before fix"
    echo "2. Fix was properly implemented"
    echo "3. Problem is resolved after fix"
    echo "4. Testing confirms it works"
    echo ""

    read -p "Does the proof demonstrate task completion? (y/N): " confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        mv "$proof_file" "$PROOF_DIR/${task_ref}_PROOF_COMPLETED.md"
        echo -e "${GREEN}✅ Proof verified - task can be marked complete${NC}"
        return 0
    else
        echo -e "${RED}❌ Proof insufficient - task remains incomplete${NC}"
        return 1
    fi
}

# Main proof checking function
check_task_proof() {
    local task_ref="$1"

    if [ -z "$task_ref" ]; then
        echo "Usage: $0 check <task_ref>"
        return 1
    fi

    # Get task description
    local task_desc
    if [ -f "$TASK_DB" ] && command -v jq >/dev/null 2>&1; then
        task_desc=$(jq -r --arg ref "$task_ref" '.tasks[] | select(.ref == $ref) | .description' "$TASK_DB")
    fi

    if [ -z "$task_desc" ]; then
        echo -e "${RED}❌ Task $task_ref not found${NC}"
        return 1
    fi

    require_proof "$task_ref" "$task_desc"
}

# List all pending proof requirements
list_pending_proofs() {
    echo -e "${YELLOW}📋 PENDING PROOF REQUIREMENTS:${NC}"
    echo ""

    for proof_file in "$PROOF_DIR"/*_PROOF_REQUIRED.md; do
        if [ -f "$proof_file" ]; then
            local task_ref=$(basename "$proof_file" | sed 's/_PROOF_REQUIRED.md//')
            echo "❌ $task_ref - Proof required"
        fi
    done

    echo ""
    echo -e "${GREEN}📋 COMPLETED PROOFS:${NC}"
    echo ""

    for proof_file in "$PROOF_DIR"/*_PROOF_COMPLETED.md; do
        if [ -f "$proof_file" ]; then
            local task_ref=$(basename "$proof_file" | sed 's/_PROOF_COMPLETED.md//')
            echo "✅ $task_ref - Proof verified"
        fi
    done
}

case "${1:-help}" in
    "require")
        check_task_proof "$2"
        ;;
    "verify")
        verify_proof "$2"
        ;;
    "check")
        check_proof_exists "$2"
        ;;
    "list")
        list_pending_proofs
        ;;
    "help")
        echo "Usage: $0 [require|verify|check|list] [task_ref]"
        echo ""
        echo "  require <task_ref> - Generate proof requirements for task"
        echo "  verify <task_ref>  - Verify submitted proof"
        echo "  check <task_ref>   - Check if proof exists"
        echo "  list               - List all pending/completed proofs"
        ;;
    *)
        echo "Unknown command. Use: $0 help"
        exit 1
        ;;
esac