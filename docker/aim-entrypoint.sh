#!/bin/bash
# AIM Container Entry Point

set -e

AIM_HOME="${AIM_HOME:-/aim}"
PROJECT_DIR="/project"
STATE_DIR="${AIM_HOME}/state"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

show_banner() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════╗"
    echo "║           AIM - AI-Collaboration-Management           ║"
    echo "║              Docker Isolated Environment              ║"
    echo "╚═══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

init_project() {
    local project_name=$(basename "$PROJECT_DIR")
    local board_file="${STATE_DIR}/boards/${project_name}.md"

    # Create board if doesn't exist
    if [[ ! -f "$board_file" ]]; then
        echo -e "${BLUE}Initializing AIM for project: ${project_name}${NC}"
        cat > "$board_file" << EOF
# AIM Task Board - ${project_name}

## Tasks FOR OCC (TCC writes here, OCC reads)

*No pending OCC tasks*

## Tasks FOR TCC (OCC writes here, TCC reads)

*No pending TCC tasks*

---

**Board Status:** Initialized
**Project:** ${project_name}
**Created:** $(date)
EOF
        echo -e "${GREEN}Created board: ${board_file}${NC}"
    fi

    # Symlink board to project-accessible location (but NOT in git)
    ln -sf "$board_file" "${AIM_HOME}/BOARD.md"
}

show_status() {
    echo -e "${BLUE}Project:${NC} $(basename $PROJECT_DIR)"
    echo -e "${BLUE}Git Branch:${NC} $(git branch --show-current 2>/dev/null || echo 'not a git repo')"
    echo -e "${BLUE}AIM Home:${NC} ${AIM_HOME}"
    echo ""

    # Show pending branches
    echo -e "${CYAN}Checking for OCC branches...${NC}"
    git fetch origin 2>/dev/null || true
    local branches=$(git branch -r 2>/dev/null | grep "origin/claude/" | wc -l)
    echo -e "${BLUE}Pending claude/* branches:${NC} ${branches}"

    # List pending branches if any
    if [[ $branches -gt 0 ]]; then
        echo -e "${CYAN}Branches to validate:${NC}"
        git branch -r 2>/dev/null | grep "origin/claude/" | sed 's/^/  /'
    fi
}

tcc_context() {
    # Output TCC context for Claude to read
    local project_name=$(basename "$PROJECT_DIR")
    local board_file="${STATE_DIR}/boards/${project_name}.md"
    local pending=$(git branch -r 2>/dev/null | grep "origin/claude/" | wc -l | tr -d ' ')

    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "TCC INITIALIZED - AI-Collaboration-Management"
    echo "═══════════════════════════════════════════════════════════════"
    echo "Project:  ${project_name}"
    echo "Board:    ${board_file}"
    echo "Branches: ${pending} pending claude/* branch(es)"
    echo ""
    echo "ROLE: You are TCC (Testing/Coordination Claude)"
    echo "  - Validate OCC branches before merge"
    echo "  - Run: ./aim/scripts/tcc-validate-branch.sh <branch>"
    echo "  - Merge validated work to main"
    echo "  - Update board after completing tasks"
    echo ""
    echo "Board contents:"
    echo "───────────────────────────────────────────────────────────────"
    cat "$board_file" 2>/dev/null || echo "(no board yet)"
    echo "───────────────────────────────────────────────────────────────"
    echo ""
}

case "${1:-shell}" in
    shell)
        show_banner
        init_project
        show_status
        tcc_context
        echo -e "${GREEN}AIM ready. Project mounted at /project${NC}"
        exec /bin/bash
        ;;

    validate)
        shift
        exec "${AIM_HOME}/scripts/tcc-validate-branch.sh" "$@"
        ;;

    merge)
        shift
        exec "${AIM_HOME}/scripts/tcc-pre-merge-check.sh" "$@"
        ;;

    watch)
        show_banner
        init_project
        echo -e "${CYAN}Starting branch watcher...${NC}"
        exec "${AIM_HOME}/scripts/watch-branches.sh"
        ;;

    *)
        echo "Usage: aim [shell|validate|merge|watch]"
        exit 1
        ;;
esac
