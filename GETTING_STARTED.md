# Getting Started with AI Collaboration Framework

## What You Need

- Git repository (any project)
- Local AI (Claude Code, Cursor, etc.) OR Online AI (Claude, GPT, etc.)
- 5 minutes

## Installation Options

You have two installation paths depending on your workflow:

### Option A: Standard Project Installation

For adding AI collaboration to your projects.

### Option B: TCC (Terminal Control Center) Installation

For terminal-based AI agents that need persistent framework access.

---

## Option A: Standard Project Installation

### Step 1: Clone the Framework

```bash
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git
```

### Step 2: Navigate to Your Project

```bash
cd /path/to/your/project
```

### Step 3: Run the Installer

```bash
../AI-Collaboration-Management/setup-ai-collaboration.sh
```

The installer will ask:
- **Project type**: Choose from React, Python, Java, Mobile, Data Science, or Custom
- **Max file size**: Recommended defaults shown for each type
- **Test coverage**: Recommended defaults shown for each type

### Step 4: Verify Installation

```bash
ls docs/
# Should show:
# AI_COLLABORATION_FRAMEWORK.md
# AI_WORKFLOW.md
# ai_communication/
```

---

## Option B: TCC (Terminal Control Center) Installation

### What is TCC?

TCC provides **persistent framework access** for AI agents working in terminal sessions (like Claude Code's Terminal Control Center). This ensures terminal-based AIs always know where to find rules, protocols, and project context.

### When to Use TCC

- You're using Claude Code or another terminal-based AI
- You want the AI to have automatic access to framework rules
- You work across multiple projects and want consistent AI behavior

### Quick TCC Installation

**Step 1: Tell your terminal AI to install:**

```
"Please install the TCC configuration system on my local machine.
Follow the instructions in tcc-setup/INSTRUCTIONS_FOR_TCC.md from the
AI-Collaboration-Management repository."
```

**Step 2: TCC runs this command:**

```bash
curl -sSL https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/tcc-setup/install-tcc.sh | bash
```

**Step 3: In every new session, TCC runs:**

```bash
source ~/tcc-init.sh
```

### What TCC Installation Provides

After installation, TCC will have:

- ✅ `~/.tccrc` - Environment variables and configuration
- ✅ `~/tcc-init.sh` - Session initialization script
- ✅ `~/AI-Collaboration-Management/` - Framework repository with all rules
- ✅ Updated `~/.bashrc` - Auto-loads TCC configuration

### TCC Helper Commands

```bash
tcc-status   # Display framework and project status
tcc-board    # View current project's BOARD.md
tcc-rules    # Display GENERAL_AI_RULES.md
tcc-startup  # Display STARTUP_PROTOCOL.md
tcc-setup    # Configure TCC for current project
tcc-sync     # Update framework with latest changes
```

### Benefits of TCC

- ✅ **No Manual Path Lookup** - AI always knows where framework files are
- ✅ **Persistent Configuration** - Survives terminal restarts
- ✅ **Auto-Updates** - Init script checks for framework updates
- ✅ **Project Awareness** - Automatically detects current project context
- ✅ **Holistic Approach Enabled** - Follows startup protocol automatically

### TCC Documentation

For complete TCC documentation, see:
- [tcc-setup/README_TCC_INSTALLATION.md](tcc-setup/README_TCC_INSTALLATION.md) - Installation guide
- [tcc-setup/USER_GUIDE_TCC_INSTALLATION.md](tcc-setup/USER_GUIDE_TCC_INSTALLATION.md) - User guide
- [tcc-setup/INSTRUCTIONS_FOR_TCC.md](tcc-setup/INSTRUCTIONS_FOR_TCC.md) - Detailed TCC instructions

---

## Your First AI Collaboration

### Using Local AI Validation

If you have Claude Code or similar:

1. Open your project in your editor
2. Make some code changes
3. Run: "work ready" (tells Local AI to validate)
4. Local AI will check your code against standards
5. If violations found, report created in `docs/ai_communication/`

### Using Online AI for Fixes

If you have Claude Web or ChatGPT:

1. Tell Online AI: "Check docs/ai_communication/ for latest report"
2. Online AI reads the report
3. Implements fixes based on violations
4. Responds with what was changed

### Validation Loop

1. Online AI makes changes → Creates branch
2. You: "work ready" → Local AI validates
3. Violations found → Report created
4. You tell Online AI about report → Implements fixes
5. You: "work ready" → Local AI validates again
6. No violations → Local AI merges to main

## Customizing for Your Project

### Edit Validation Rules

```bash
edit docs/ai_communication/VALIDATION_RULES.md
```

Customize:
- File size limits per file type
- Test coverage requirements
- Security scanning tools
- Performance benchmarks
- Project-specific standards

### Example: React Project

```yaml
file_size_limits:
  components: 150 lines
  hooks: 100 lines

validation:
  test_coverage: 85%
  bundle_size: 1MB max
  eslint: required
  prettier: required
```

### Example: Python Project

```yaml
file_size_limits:
  modules: 300 lines
  classes: 200 lines

validation:
  test_coverage: 90%
  black: required
  flake8: required
  mypy: required
```

## Troubleshooting

**Installation fails with "Not a git repository"**
- Make sure you're in a git repository
- Run `git init` if starting fresh

**Validation commands not found**
- Install project dependencies first (npm install, pip install, etc.)
- Update validation commands in VALIDATION_RULES.md to match your tools

**Placeholders not replaced**
- Check that install script completed successfully
- Manually replace {{PROJECT_NAME}} if needed

## Next Steps

- Read [AI_WORKFLOW.md](docs/AI_WORKFLOW.md) for detailed workflow
- Customize [VALIDATION_RULES.md](docs/ai_communication/VALIDATION_RULES.md)
- Join [GitHub Discussions](https://github.com/JamesKayten/Averys-AI-Collaboration-Hack/discussions) for questions
- Check [examples/](https://github.com/JamesKayten/Averys-AI-Collaboration-Hack/tree/main/examples) for project-specific configs

## Getting Help

- [FAQ](FAQ.md) - Common questions
- [Troubleshooting Guide](TROUBLESHOOTING.md) - Solutions to common issues
- [GitHub Discussions](https://github.com/JamesKayten/Averys-AI-Collaboration-Hack/discussions) - Ask the community
- [GitHub Issues](https://github.com/JamesKayten/Averys-AI-Collaboration-Hack/issues) - Report bugs

Welcome to AI collaboration! 🤖🤝🤖