#!/bin/bash

# AI Collaboration Framework - Package Creator
# Usage: ./create-framework-package.sh [output_directory]
# Purpose: Create distributable package of self-contained framework

set -e

OUTPUT_DIR="${1:-./ai-framework-package}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PACKAGE_NAME="ai-collaboration-framework-v2.0-${TIMESTAMP}"
PACKAGE_DIR="$OUTPUT_DIR/$PACKAGE_NAME"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}📦 AI COLLABORATION FRAMEWORK - PACKAGE CREATOR${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${BLUE}📋 Package Name:${NC} $PACKAGE_NAME"
echo -e "${BLUE}📁 Output Directory:${NC} $PACKAGE_DIR"
echo -e "${BLUE}📅 Creation Time:${NC} $(date)"
echo ""

# Create package directory structure
echo -e "${YELLOW}📁 Creating package structure...${NC}"
mkdir -p "$PACKAGE_DIR"/{installer,tools,templates,docs}

# Copy installer
echo -e "${YELLOW}📦 Packaging installer...${NC}"
cp install-framework-complete.sh "$PACKAGE_DIR/installer/"
chmod +x "$PACKAGE_DIR/installer/install-framework-complete.sh"
echo -e "${GREEN}✅ Installer packaged${NC}"

# Copy all tools
echo -e "${YELLOW}🔧 Packaging tools...${NC}"
cp tcc-board-check-fast.sh "$PACKAGE_DIR/tools/"
cp tcc-board-check.sh "$PACKAGE_DIR/tools/"
cp tcc-file-compliance.sh "$PACKAGE_DIR/tools/" 2>/dev/null || true
cp tcc-file-compliance-simple.sh "$PACKAGE_DIR/tools/" 2>/dev/null || true
chmod +x "$PACKAGE_DIR/tools/"*.sh
echo -e "${GREEN}✅ Tools packaged${NC}"

# Copy templates
echo -e "${YELLOW}📄 Packaging templates...${NC}"
if [ -f "BOARD_CHECK_TEMPLATE.md" ]; then
    cp BOARD_CHECK_TEMPLATE.md "$PACKAGE_DIR/templates/"
fi
if [ -f "CHECK_THE_BOARD.md" ]; then
    cp CHECK_THE_BOARD.md "$PACKAGE_DIR/templates/"
fi
echo -e "${GREEN}✅ Templates packaged${NC}"

# Create documentation
echo -e "${YELLOW}📚 Creating documentation...${NC}"

# Create README
cat > "$PACKAGE_DIR/README.md" << 'EOF'
# AI Collaboration Framework v2.0 (Self-Contained)

**Complete AI collaboration framework with embedded tools - no external dependencies**

## 🎯 Overview

This package contains a complete, self-contained AI Collaboration Framework designed for seamless OCC (Online Claude Code) and TCC (Terminal Claude Code) collaboration.

### Key Features

- ✅ **Self-Contained** - All tools embedded locally
- ✅ **No External Dependencies** - Works completely offline
- ✅ **Customizable** - Modify tools per repository needs
- ✅ **Portable** - Framework moves with repository
- ✅ **Fast** - No remote downloads during operations
- ✅ **Reliable** - No single points of failure

## 🚀 Quick Start

### Installation

To install the framework in your repository:

```bash
cd your-repository
/path/to/ai-framework-package/installer/install-framework-complete.sh https://github.com/your-username/your-repository
```

### Verify Installation

```bash
# Check if framework is installed
test -f BOARD.md && echo "✅ Framework installed" || echo "❌ Not installed"

# Test fast board check
./.ai-framework/tools/tcc-board-check-fast.sh $(git remote get-url origin)
```

## 📋 What Gets Installed

### File Structure

```
your-repository/
├── BOARD.md                           # TCC discovery entry point
└── .ai-framework/
    ├── tools/                         # All embedded tools
    │   ├── tcc-board-check-fast.sh    # Fast status check
    │   ├── tcc-board-check.sh         # Detailed status check
    │   ├── tcc-file-compliance.sh     # File size enforcement
    │   └── install-framework-complete.sh  # Self-installer
    ├── communications/                # OCC/TCC communication
    │   ├── reports/                   # TCC validation reports
    │   └── updates/                   # OCC handoff updates
    ├── project-state/                 # Project configuration
    ├── rules/                         # Validation rules
    ├── scripts/                       # Helper scripts
    └── OCC_NEW_FEATURES.md           # OCC discovery file
```

### Tools Included

1. **tcc-board-check-fast.sh** - Fast framework status check (3-5 seconds)
2. **tcc-board-check.sh** - Detailed framework analysis with file-level detail
3. **tcc-file-compliance.sh** - File size compliance enforcement
4. **install-framework-complete.sh** - Self-installer for replication

## 🔄 OCC/TCC Workflow

### Phase 1: OCC Development

1. Develop features in your repository
2. Commit and push to feature branch
3. Framework is ready for TCC discovery

### Phase 2: TCC Testing

User says: "TCC: Check the board"

TCC automatically:
- Finds BOARD.md in repository
- Runs local tools
- Gets complete framework context
- Starts testing/validation

### Phase 3: OCC Response

- Read TCC reports from `.ai-framework/communications/reports/`
- Fix issues and push responses
- Use framework tools to verify state

## 🔧 Usage Commands

### For TCC (Terminal Claude Code)

```bash
# Fast board check
./.ai-framework/tools/tcc-board-check-fast.sh https://github.com/user/repo

# Detailed board check
./.ai-framework/tools/tcc-board-check.sh https://github.com/user/repo

# Check file compliance before merge
./.ai-framework/tools/tcc-file-compliance.sh main
```

### For OCC (Online Claude Code)

```bash
# Discover framework features
cat .ai-framework/OCC_NEW_FEATURES.md

# Check current project state
cat .ai-framework/project-state/PROJECT_STATE.md

# Verify TCC readiness
test -f BOARD.md && echo "✅ TCC Ready" || echo "❌ Not configured"
```

## 📐 File Size Limits

The framework enforces these file size limits:

- **Python (.py):** 250 lines maximum
- **JavaScript/TypeScript (.js/.ts/.jsx/.tsx):** 150 lines maximum
- **Java (.java):** 400 lines maximum
- **Go/Swift/Rust (.go/.swift/.rs):** 300 lines maximum
- **Markdown (.md):** 500 lines maximum
- **Shell scripts (.sh):** 200 lines maximum

## 🎯 Benefits

### No External Dependencies
- Everything works offline
- No master repository dependency
- No network access required for core operations

### Fully Customizable
- Modify tools per repository needs
- Adapt rules for project requirements
- Extend functionality as needed

### Portable
- Framework moves with repository
- Self-contained and independent
- Easy to distribute

### Fast & Reliable
- No remote downloads during operations
- Instant board checking
- No single points of failure

## 📚 Documentation

See the `docs/` directory for:
- Installation guide
- Usage examples
- Troubleshooting tips
- Migration from older versions

## 🆘 Support

For issues or questions:
1. Check the documentation in `docs/`
2. Review the installation output
3. Verify file permissions on tools

## 📝 License

This framework is provided as-is for collaborative AI development.

---

**AI Collaboration Framework v2.0 - Self-Contained Edition**
**Complete, portable, reliable AI collaboration for any repository**
EOF

# Create installation guide
cat > "$PACKAGE_DIR/docs/INSTALLATION_GUIDE.md" << 'EOF'
# Installation Guide

## Prerequisites

- Git repository (initialized)
- Bash shell (Linux/macOS/WSL)
- Write access to repository

## Installation Steps

### Step 1: Download Package

Extract the framework package to a location on your system:

```bash
unzip ai-collaboration-framework-v2.0.zip
cd ai-collaboration-framework-v2.0-*/
```

### Step 2: Navigate to Repository

```bash
cd /path/to/your/repository
```

### Step 3: Run Installer

```bash
/path/to/package/installer/install-framework-complete.sh https://github.com/your-username/your-repository
```

### Step 4: Verify Installation

```bash
# Check BOARD.md exists
ls -la BOARD.md

# Check tools are installed
ls -la .ai-framework/tools/

# Test fast board check
./.ai-framework/tools/tcc-board-check-fast.sh $(git remote get-url origin)
```

### Step 5: Commit Framework

```bash
git add .
git commit -m "Add self-contained AI collaboration framework"
git push
```

## Post-Installation

### Test TCC Integration

Ask TCC: "Check the board"

TCC should automatically:
1. Find BOARD.md
2. Run local tools
3. Get complete framework context

### Test OCC Discovery

OCC can read `.ai-framework/OCC_NEW_FEATURES.md` to discover available features.

## Troubleshooting

### Tools Not Executable

```bash
chmod +x .ai-framework/tools/*.sh
```

### BOARD.md Not Found

Re-run installer with correct repository URL.

### Framework Not Discovered

Check `.ai-framework/` directory exists and contains all subdirectories.

## Migration from Old Framework

If you have an old framework with external dependencies, see `MIGRATION_GUIDE.md`.

---

**Installation complete! Your repository is now ready for AI collaboration.**
EOF

# Create usage guide
cat > "$PACKAGE_DIR/docs/USAGE_GUIDE.md" << 'EOF'
# Usage Guide

## For TCC (Terminal Claude Code)

### Quick Board Check

```bash
./.ai-framework/tools/tcc-board-check-fast.sh https://github.com/user/repo
```

**Use When:**
- Starting new TCC session
- Quick status check needed
- Verifying framework is working

**Output:**
- Repository metadata
- Framework detection status
- Branch counts
- Latest commit info

### Detailed Board Check

```bash
./.ai-framework/tools/tcc-board-check.sh https://github.com/user/repo
```

**Use When:**
- Need complete framework analysis
- Looking for pending work
- Starting comprehensive testing
- Need file-level details

**Output:**
- Complete framework structure
- All communications (reports/updates)
- Feature branches
- Pending action items
- Work directory for testing

### File Compliance Check

```bash
./.ai-framework/tools/tcc-file-compliance.sh main
```

**Use When:**
- Before merging to main
- Validating file sizes
- Pre-merge validation

**Output:**
- File-by-file compliance status
- Violation report (if any)
- Merge approval/blocking status

## For OCC (Online Claude Code)

### Discover Framework Features

```bash
cat .ai-framework/OCC_NEW_FEATURES.md
```

Lists all available framework features and commands.

### Check Project State

```bash
cat .ai-framework/project-state/PROJECT_STATE.md
```

Shows current project configuration and framework status.

### Read TCC Reports

```bash
ls .ai-framework/communications/reports/
cat .ai-framework/communications/reports/TCC_*.md
```

View TCC validation reports and findings.

### Create OCC Updates

Create new files in `.ai-framework/communications/updates/`:

```bash
cat > .ai-framework/communications/updates/OCC_RESPONSE_$(date +%Y%m%d).md << EOF
# OCC Response

## Addressed Issues
...
EOF
```

## Common Workflows

### Workflow 1: New TCC Session

1. User: "TCC: Check the board"
2. TCC reads BOARD.md
3. TCC runs fast board check
4. TCC gets full context
5. TCC starts work

### Workflow 2: Pre-Merge Validation

1. OCC completes feature
2. TCC runs file compliance check
3. If violations: OCC refactors
4. If pass: Ready for merge

### Workflow 3: OCC/TCC Collaboration

1. OCC develops feature
2. TCC validates and tests
3. TCC creates report
4. OCC reads report and fixes
5. Repeat until complete

## File Size Limits

Automatically enforced by `tcc-file-compliance.sh`:

| File Type | Max Lines |
|-----------|-----------|
| Python | 250 |
| JavaScript/TypeScript | 150 |
| Java | 400 |
| Go/Swift/Rust | 300 |
| Markdown | 500 |
| Shell | 200 |

## Tips

- Use fast board check for quick status
- Use detailed check when starting work
- Always run compliance before merge
- Keep communications organized
- Commit framework changes regularly

---

**Self-contained framework - all tools work offline**
EOF

# Create changelog
cat > "$PACKAGE_DIR/CHANGELOG.md" << 'EOF'
# Changelog

## Version 2.0 - Self-Contained Edition

**Release Date:** $(date +%Y-%m-%d)

### Major Changes

- **Self-Contained Architecture** - All tools embedded locally
- **No External Dependencies** - Complete offline functionality
- **Embedded Installer** - Framework can self-replicate
- **Complete Violation Reporting** - Full file compliance reports

### Features Added

- Fast board check tool (3-5 seconds)
- Detailed board check tool (comprehensive analysis)
- File size compliance checker with full reporting
- Self-replicating installer
- OCC discovery file
- Project state tracking
- Validation rules embedded

### Breaking Changes

- **BOARD.md format changed** - Now references local tools instead of curl commands
- **No master repository** - Framework works independently
- **Tools location** - All tools in `.ai-framework/tools/`

### Migration

- Existing frameworks need migration (see MIGRATION_GUIDE.md)
- curl-based commands replaced with local tool execution
- All external URLs removed from framework files

### Benefits

- ✅ Repository can be private without breaking framework users
- ✅ Complete offline functionality
- ✅ Customizable per repository
- ✅ No single point of failure
- ✅ Fast and reliable operations

---

## Version 1.0 - Master Repository Edition

**Deprecated** - Use v2.0 Self-Contained Edition instead

### Issues with v1.0

- ❌ Master repository dependency
- ❌ Single point of failure
- ❌ Network required for operations
- ❌ Not customizable
- ❌ Repository must be public

---

**v2.0 Self-Contained Edition is the recommended version**
EOF

echo -e "${GREEN}✅ Documentation created${NC}"

# Create distribution script
echo -e "${YELLOW}📦 Creating distribution script...${NC}"

cat > "$PACKAGE_DIR/DISTRIBUTE.sh" << 'EOF'
#!/bin/bash

# Quick distribution script
# Usage: ./DISTRIBUTE.sh /path/to/target/repository

TARGET_REPO="$1"

if [ -z "$TARGET_REPO" ]; then
    echo "Usage: $0 /path/to/target/repository"
    exit 1
fi

if [ ! -d "$TARGET_REPO" ]; then
    echo "Error: $TARGET_REPO is not a directory"
    exit 1
fi

echo "Installing framework to: $TARGET_REPO"
cd "$TARGET_REPO"

REPO_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [ -z "$REPO_URL" ]; then
    echo "Error: Not a git repository or no remote origin"
    exit 1
fi

# Run installer
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/installer/install-framework-complete.sh" "$REPO_URL"

echo ""
echo "Framework installed successfully!"
echo "Next: git add . && git commit -m 'Add AI collaboration framework' && git push"
EOF

chmod +x "$PACKAGE_DIR/DISTRIBUTE.sh"
echo -e "${GREEN}✅ Distribution script created${NC}"

# Create archive
echo ""
echo -e "${YELLOW}📦 Creating archive...${NC}"
cd "$OUTPUT_DIR"
tar -czf "${PACKAGE_NAME}.tar.gz" "$PACKAGE_NAME"
zip -r "${PACKAGE_NAME}.zip" "$PACKAGE_NAME" >/dev/null 2>&1

ARCHIVE_SIZE=$(du -h "${PACKAGE_NAME}.tar.gz" | cut -f1)
echo -e "${GREEN}✅ Archive created: ${PACKAGE_NAME}.tar.gz ($ARCHIVE_SIZE)${NC}"

# Summary
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}📦 PACKAGE CREATION COMPLETE${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${BLUE}📦 Package:${NC} $PACKAGE_NAME"
echo -e "${BLUE}📁 Location:${NC} $OUTPUT_DIR"
echo -e "${BLUE}📊 Size:${NC} $ARCHIVE_SIZE"
echo ""

echo -e "${GREEN}✅ Package Contents:${NC}"
echo "   📦 installer/ - Framework installer"
echo "   🔧 tools/ - All framework tools"
echo "   📄 templates/ - Configuration templates"
echo "   📚 docs/ - Complete documentation"
echo "   📝 README.md - Overview and quick start"
echo "   📝 CHANGELOG.md - Version history"
echo "   🚀 DISTRIBUTE.sh - Quick distribution script"
echo ""

echo -e "${YELLOW}📋 Distribution Options:${NC}"
echo ""
echo -e "${BLUE}Option 1: Direct Installation${NC}"
echo "   cd /path/to/repository"
echo "   $OUTPUT_DIR/$PACKAGE_NAME/installer/install-framework-complete.sh \$(git remote get-url origin)"
echo ""
echo -e "${BLUE}Option 2: Use Distribution Script${NC}"
echo "   $OUTPUT_DIR/$PACKAGE_NAME/DISTRIBUTE.sh /path/to/repository"
echo ""
echo -e "${BLUE}Option 3: Share Archive${NC}"
echo "   Share: $OUTPUT_DIR/${PACKAGE_NAME}.tar.gz"
echo "   or: $OUTPUT_DIR/${PACKAGE_NAME}.zip"
echo ""

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🎉 SELF-CONTAINED FRAMEWORK PACKAGE READY${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
