# TCC Initialization Template
**Purpose:** Generic instructions for TCC to connect to any repository with AI Collaboration Framework
**Version:** 1.0
**Last Updated:** November 23, 2025

---

## 📋 INSTRUCTIONS FOR TCC

Copy and paste this template, replacing the placeholders with actual values:

---

## 🚀 TCC SESSION INITIALIZATION

Hi TCC! I need you to review work in a repository using our AI Collaboration Framework.

**Repository:** `[PASTE_REPO_URL_HERE]`
**Branch:** `[PASTE_BRANCH_NAME_HERE]`

---

## ⚡ QUICK METHOD (If you have TCC framework installed)

If you've installed the TCC configuration system on your local machine, just run:

```bash
tcc-init-repo [PASTE_REPO_URL_HERE] [PASTE_BRANCH_NAME_HERE]
```

**This will automatically:**
- ✅ Clone the repository
- ✅ Checkout the branch
- ✅ Find and display all TCC documentation
- ✅ Read framework handoff documents
- ✅ Show project state
- ✅ Give you instant context to start working

**If this works, you're done! Skip to the "Begin Your Work" section below.**

---

## 📋 MANUAL METHOD (If TCC framework not installed)

### Your Mission:

1. **Clone and Setup**
   ```bash
   git clone [PASTE_REPO_URL_HERE]
   cd [REPO_NAME]
   git checkout [PASTE_BRANCH_NAME_HERE]
   ```

2. **Find the Framework**
   - Look for `.ai-framework/` directory (root level or project subdirectory)
   - Check for `.claude/commands/` (custom slash commands)

3. **Read Your Instructions**
   In priority order:
   - Any `TCC_*.md` files (your specific guides)
   - `.ai-framework/communications/updates/AI_UPDATE_*.md` (latest handoff docs)
   - `.ai-framework/project-state/PROJECT_STATE.md` (current project state)
   - `.ai-framework/rules/` (your responsibilities and validation rules)

4. **Understand Your Role**
   - You are **TCC** (Testing & Collaboration Claude)
   - **OCC** (Online Claude Code) develops features
   - **You** test, validate, and report issues
   - Framework documents explain the complete workflow

5. **Check for Custom Commands**
   ```bash
   ls .claude/commands/
   ```
   Use available slash commands like `/verify`, `/test-backend`, etc.

6. **Begin Your Work**
   Follow the protocols specified in the framework documents you read.

---

### Framework Structure You'll Find:

```
repository-root/
├── .ai-framework/
│   ├── communications/
│   │   ├── updates/           # OCC→TCC handoff documents
│   │   ├── reports/           # TCC→OCC issue reports
│   │   └── responses/         # OCC→TCC fix responses
│   ├── project-state/
│   │   ├── PROJECT_STATE.md   # Current project status
│   │   └── REBOOT_INSTRUCTIONS.md
│   └── rules/
│       └── VALIDATION_RULES.md
├── .claude/commands/          # Custom slash commands
└── [TCC_*.md files]          # Your testing guides
```

---

### Key Points:

- ✅ **DO** read all TCC-specific documentation first
- ✅ **DO** follow the validation rules in `.ai-framework/rules/`
- ✅ **DO** document your findings in `.ai-framework/communications/reports/`
- ✅ **DO** fix backend issues if authorized by framework rules
- ❌ **DON'T** modify code without understanding the framework protocols
- ❌ **DON'T** skip reading the handoff documents

---

**The framework documents will tell you everything you need to know. Start by reading them!**

---

## 📝 QUICK FILL TEMPLATES

### Option 1: If TCC has framework installed (RECOMMENDED)

```
TCC: Initialize this repository with the framework.

Run: tcc-init-repo [REPO_URL] [BRANCH_NAME]

This will clone the repo, checkout the branch, and automatically load all framework documentation.
```

### Option 2: Manual initialization (if framework not installed)

```
TCC: Review this repository using the AI Collaboration Framework.

Repo: [PASTE_URL]
Branch: [PASTE_BRANCH]

1. Clone and checkout the branch
2. Find all TCC_*.md files and read them
3. Read .ai-framework/communications/updates/ for handoff docs
4. Read .ai-framework/project-state/PROJECT_STATE.md
5. Read .ai-framework/rules/ for validation rules
6. Follow the protocols in those documents

You are TCC (testing role). The framework docs explain everything.
```

---

## 🔄 SESSION RECOVERY NOTES

If this project has session recovery enabled:
- Look for `restore_session.sh` in project root
- Check for `SESSION_EXIT_SNAPSHOT.md` for last session state
- Read `.ai-framework/session-recovery/REBOOT_QUICK_START.md` for instant context

---

## 📞 SUPPORT

If TCC doesn't find the framework:
- Verify the branch is correct
- Check if framework is in a subdirectory (e.g., `AudioApp/.ai-framework/`)
- Look for any README files that explain project structure

---

**This template works with any repository that has the AI Collaboration Framework installed.**
