# 🚀 CLAUDE CODE SESSION QUICK START
**Project:** AI-Collaboration-Management
**Type:** AI Collaboration Framework Manager
**Created:** 2025-11-23
**Purpose:** IMMEDIATE session recovery without re-reading everything

---

## ⚡ INSTANT STATUS
- **Project:** AI-Collaboration-Management
- **Location:** `/home/user/AI-Collaboration-Management`
- **Type:** Framework repository for OCC/TCC collaboration
- **Status:** Active development
- **Framework:** Avery's AI Collaboration Hack

---

## 🎯 IMMEDIATE NEXT STEPS

### **RIGHT NOW:**
1. **Location:** You are in the AI-Collaboration-Management repository
2. **Status:** Framework is operational and ready
3. **Current Branch:** Check with `git branch --show-current`
4. **Action Required:** Continue with session work or review snapshot

### **Project Configuration:**
- **Project Type:** AI Collaboration Framework Manager
- **Max File Size:** 250 lines (recommended)
- **Main Branch:** main
- **Framework:** Supports multiple project types (AudioApp, SimpleCP, etc.)

---

## 📂 PROJECT CONTEXT (ESSENTIAL ONLY)

### **Repository Purpose:**
This is the **management repository** for the AI Collaboration Framework. It contains:
- Templates for framework installation
- TCC setup and initialization guides
- Session recovery system
- Documentation for OCC/TCC collaboration
- Example projects (AudioApp, SimpleCP, etc.)

### **Project Structure:**
```
AI-Collaboration-Management/
├── .ai-framework/              # Framework operations
│   ├── session-recovery/       # Session recovery system (THIS SYSTEM)
│   ├── scripts/                # Automation scripts
│   └── session-logs/           # Session history
├── .claude/commands/           # Custom slash commands
│   ├── merge-to-main.md        # PR creation workflow
│   ├── verify.md               # Framework test verification
│   └── fix-violations.md       # Issue fixing workflow
├── AudioApp/                   # Example: Music player project
├── templates/                  # Framework installation templates
├── tcc-setup/                  # TCC initialization guides
│   └── TCC_INITIALIZATION_TEMPLATE.md
├── docs/                       # Documentation
├── rules/                      # Framework rules
├── restore_session.sh          # Session restoration script
└── create_session_snapshot.sh  # Snapshot creator
```

---

## 🚨 CRITICAL FILES

```
SESSION_EXIT_SNAPSHOT.md                         # Exact session end state (if exists)
.ai-framework/session-recovery/CURRENT_SESSION_STATE.md  # Real-time work state
.ai-framework/session-recovery/REBOOT_QUICK_START.md     # This file - quick start
tcc-setup/TCC_INITIALIZATION_TEMPLATE.md                 # TCC init instructions
```

---

## ⚡ INSTANT COMMANDS

### **Check Current Session State:**
```bash
cat .ai-framework/session-recovery/CURRENT_SESSION_STATE.md
```

### **View Exact Exit State (if available):**
```bash
cat SESSION_EXIT_SNAPSHOT.md
```

### **Check Current Branch & Status:**
```bash
git branch --show-current
git status
```

### **View Framework Structure:**
```bash
ls -la .ai-framework/
tree -L 2 .ai-framework/ 2>/dev/null || find .ai-framework/ -type d -maxdepth 2
```

---

## 📊 PROJECT STATUS
- **Framework:** ✅ Installed and operational
- **Session Recovery:** ✅ Active and available
- **TCC Initialization:** ✅ Template created
- **Custom Commands:** ✅ Available in `.claude/commands/`
- **Documentation:** ✅ Comprehensive guides available

---

## 🎯 STANDARD WORKFLOW

### **For Session Management:**
1. **Start session** - Run `./restore_session.sh` to get context
2. **Work on project** - Make changes as needed
3. **Update state** - Edit `CURRENT_SESSION_STATE.md` during major changes
4. **End session** - Run `./create_session_snapshot.sh` before stopping

### **For TCC Collaboration:**
1. **Use TCC template** - `tcc-setup/TCC_INITIALIZATION_TEMPLATE.md`
2. **Initialize TCC** - Provide repo URL and branch
3. **TCC reads framework** - TCC finds `.ai-framework/` and reads guides
4. **Collaborate** - Follow OCC/TCC protocols in framework docs

### **For Framework Development:**
1. **Check current branch** - Ensure you're on correct feature branch
2. **Review PROJECT_STATE** - Check status in active project
3. **Make changes** - Update templates, scripts, or docs
4. **Test changes** - Verify in example projects
5. **Commit and push** - Follow git workflow

---

## ⚠️ IMPORTANT

- **Session recovery system** is now standard for all framework projects
- **Always create snapshot** before ending sessions (`./create_session_snapshot.sh`)
- **Use restore_session.sh** to resume exactly where you left off
- **TCC initialization** uses the template in `tcc-setup/`
- **Custom slash commands** available via `.claude/commands/`

---

## 🔧 AVAILABLE SLASH COMMANDS

Check `.claude/commands/` for available commands:
- `/merge-to-main` - Create PR for merging to main
- `/verify` - Verify framework test completion
- `/fix-violations` - OCC fixes issues from TCC report
- `/works-ready` - TCC validates OCC's work

---

## 📝 COMMON SCENARIOS

### **Scenario: Starting Fresh Session**
```bash
./restore_session.sh
# Read the output, then continue work
```

### **Scenario: Initializing TCC**
```bash
cat tcc-setup/TCC_INITIALIZATION_TEMPLATE.md
# Copy template, fill in repo URL and branch
# Send to TCC
```

### **Scenario: Checking Framework Status**
```bash
git status
git log --oneline -5
ls .ai-framework/
```

### **Scenario: Ending Session**
```bash
./create_session_snapshot.sh
# Snapshot created, ready to resume later
```

---

**IMMEDIATE ACTION:**

1. Run `./restore_session.sh` for exact state recovery
2. If no snapshot exists, check `CURRENT_SESSION_STATE.md`
3. Review git status to see current work
4. Continue with session work

**This is the AI Collaboration Framework management repository with full session recovery support.**

---

**Document Version:** 1.0
**Created:** 2025-11-23
**Framework:** Avery's AI Collaboration Hack
