# TCC (Terminal Control Center) Setup

Persistent framework access for terminal-based AI agents like Claude Code.

---

## 📋 Overview

TCC provides **automatic framework access** for AI agents working in terminal sessions. This ensures terminal-based AIs always know where to find rules, protocols, and project context across all sessions and projects.

### The Problem TCC Solves

When AI agents start fresh terminal sessions, they don't know:
- Where the AI Collaboration Management framework is located
- How to access `GENERAL_AI_RULES.md`, `STARTUP_PROTOCOL.md`
- Where to find project `BOARD.md` files
- What environment variables to use

### The Solution

**One-command installation** that provides persistent configuration across all terminal sessions.

---

## ⚡ Quick Installation

### For Users

Tell your terminal AI:

```
"Please install the TCC configuration system on my local machine.
Follow the instructions in tcc-setup/INSTRUCTIONS_FOR_TCC.md"
```

### For TCC (AI Agent)

See [INSTRUCTIONS_FOR_TCC.md](INSTRUCTIONS_FOR_TCC.md) for complete installation instructions.

### Direct Installation

```bash
curl -sSL https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/tcc-setup/install-tcc.sh | bash
```

---

## 📦 What Gets Installed

### Configuration Files

**On your machine (`~/`):**
```
~/.tccrc                              # Environment variables and configuration
~/tcc-init.sh                         # Session initialization script
~/.bashrc                             # Updated to auto-load TCC config
```

**Framework Repository:**
```
~/AI-Collaboration-Management/        # Framework with all rules and templates
    ├── rules/
    │   ├── GENERAL_AI_RULES.md
    │   ├── STARTUP_PROTOCOL.md
    │   └── RULE_IMPROVEMENTS.md
    ├── templates/
    └── [all framework files]
```

---

## 🚀 Using TCC

### First Command in Every Session

TCC runs this automatically when starting a new terminal:

```bash
source ~/tcc-init.sh
```

This provides immediate access to:
- ✅ All framework rules and protocols
- ✅ Project BOARD.md files
- ✅ Environment variables for all paths
- ✅ Helper commands (`tcc-status`, `tcc-board`, etc.)

### Available Commands

After installation, TCC has these commands:

```bash
tcc-status   # Display framework and project status
tcc-board    # View current project's BOARD.md
tcc-rules    # Display GENERAL_AI_RULES.md
tcc-startup  # Display STARTUP_PROTOCOL.md
tcc-setup    # Configure TCC for current project
tcc-sync     # Update framework with latest changes
```

---

## ✅ Benefits

- **No Manual Path Lookup** - TCC always knows where framework files are
- **Persistent Configuration** - Survives terminal restarts
- **Auto-Updates** - Init script checks for framework updates
- **Project Awareness** - Automatically detects current project context
- **Holistic Approach Enabled** - Follows startup protocol automatically
- **Works Across All Projects** - One installation, universal access

---

## 📖 Documentation

- **[INSTRUCTIONS_FOR_TCC.md](INSTRUCTIONS_FOR_TCC.md)** - Detailed installation instructions for TCC
- **[INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md)** - Integration with other systems
- **[MONITORING.md](MONITORING.md)** - Monitoring and maintenance guide
- **[install-tcc.sh](install-tcc.sh)** - Automated installation script

---

## 🔧 Configuration Details

### Environment Variables (in `~/.tccrc`)

```bash
AI_FRAMEWORK_ROOT="${HOME}/AI-Collaboration-Management"
AI_RULES_DIR="${AI_FRAMEWORK_ROOT}/rules"
AI_TEMPLATES_DIR="${AI_FRAMEWORK_ROOT}/templates"
CURRENT_PROJECT_ROOT="$(pwd)"
```

### Helper Functions

```bash
tcc-status()   # Check framework and project status
tcc-board()    # Display project BOARD.md
tcc-rules()    # Show GENERAL_AI_RULES.md
tcc-startup()  # Show STARTUP_PROTOCOL.md
tcc-setup()    # Configure for current project
tcc-sync()     # Update framework
```

---

## 🆘 Troubleshooting

### TCC Commands Not Found

```bash
# Re-initialize in current session
source ~/tcc-init.sh

# Or reload shell configuration
source ~/.bashrc
```

### Framework Not Found

```bash
# Verify framework exists
ls -la ~/AI-Collaboration-Management/

# If missing, re-clone
cd ~
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git
```

### Init Script Errors

```bash
# Check for syntax errors
bash -n ~/tcc-init.sh

# Reinstall if needed
curl -sSL https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/tcc-setup/install-tcc.sh | bash
```

For complete troubleshooting, see [TROUBLESHOOTING.md](../TROUBLESHOOTING.md#tcc-terminal-control-center-issues).

---

## 🔄 Updates

### Manual Update

```bash
tcc-sync
```

### Auto-Updates

TCC init script automatically checks for updates when sourced.

---

## 📊 Installation Status

- ✅ Installation script created
- ✅ Configuration files prepared
- ✅ Documentation completed
- ✅ Ready for installation

---

## 🎯 Next Steps

1. **Install:** Run the installation command above
2. **Initialize:** `source ~/tcc-init.sh` (or start new terminal)
3. **Verify:** Run `tcc-status` to confirm installation
4. **Use:** TCC now has framework access in every session

---

**Questions?**

- See [FAQ.md](../FAQ.md#tcc-terminal-control-center) for common questions
- See [INSTRUCTIONS_FOR_TCC.md](INSTRUCTIONS_FOR_TCC.md) for detailed setup
- See parent [README.md](../README.md#tcc-terminal-control-center-setup) for framework overview

---

**Created for seamless AI collaboration across terminal sessions** 🤖
