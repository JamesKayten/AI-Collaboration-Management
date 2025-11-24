# 🚀 AI COLLABORATION FRAMEWORK - QUICK START
**Get AI-to-AI collaboration + session recovery in any project in 2 minutes**

---

## 🎯 WHAT THIS FRAMEWORK DOES

### **Solves These Problems:**
- ❌ **Time-consuming session recovery** - figuring out where you left off
- ❌ **Manual AI coordination** - copying code between Terminal and Browser AI
- ❌ **Lost context** - forgetting what you were working on
- ❌ **Inconsistent validation** - different standards across projects

### **Gives You These Solutions:**
- ✅ **5-second session recovery** - instantly resume exactly where you left off
- ✅ **AI-to-AI collaboration** - Terminal AI and Browser AI work together automatically
- ✅ **Never lose context** - exact work state preserved between sessions
- ✅ **Professional validation** - consistent standards and quality checks

---

## 🏃 **2-MINUTE SETUP FOR ANY PROJECT**

### **Choose Your Setup Path:**

#### **Path A: Standard Project Setup** (Most Users)

**Step 1: Navigate to Your Project**
```bash
cd /path/to/your/project
git init  # (if not already a git repository)
```

**Step 2: Run Setup Command**
```bash
# For Python projects:
~/ai setup --preset python --max-file-size 250 --test-coverage 90 --validation-tools "black,flake8,pytest"

# For React/Web projects:
~/ai setup --preset react --max-file-size 150 --test-coverage 85 --validation-tools "eslint,prettier,jest"

# For Java projects:
~/ai setup --preset java --max-file-size 400 --test-coverage 85 --validation-tools "maven,junit"

# For Data Science projects:
~/ai setup --preset data-science --max-file-size 500 --test-coverage 80 --validation-tools "black,pytest,jupyter"
```

**Step 3: Start Using Immediately**
```bash
# Work on your project normally, then:

# End session (capture exact state):
~/ai save

# Start session (instant recovery):
~/ai restore
```

**That's it! AI collaboration + session recovery is now active.**

---

#### **Path B: TCC Setup** (Terminal-Based AI Like Claude Code)

**For Terminal AI that needs persistent framework access:**

**Step 1: One-Time TCC Installation**

Tell your terminal AI:
```
"Please install the TCC configuration system on my local machine.
Follow the instructions in tcc-setup/INSTRUCTIONS_FOR_TCC.md"
```

Or run directly:
```bash
curl -sSL https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/tcc-setup/install-tcc.sh | bash
```

**Step 2: In Every New Terminal Session**
```bash
source ~/tcc-init.sh
```

**Step 3: Use TCC Commands**
```bash
tcc-status   # Check framework status
tcc-board    # View project BOARD.md
tcc-rules    # View AI rules
tcc-setup    # Configure for current project
```

**Benefits:**
- ✅ AI always knows where framework files are
- ✅ Persistent across terminal restarts
- ✅ Works across all your projects
- ✅ Auto-loads framework rules

**See [tcc-setup/README_TCC_INSTALLATION.md](tcc-setup/README_TCC_INSTALLATION.md) for details.**

---

## 📋 **WHAT GETS CREATED IN YOUR PROJECT**

After running setup, you'll have:

### **Session Recovery System:**
```
your-project/
├── restore_session.sh              # ⚡ Instant session restoration
├── create_session_snapshot.sh      # 📸 Capture exact work state
└── framework/
    └── session-recovery/
        ├── REBOOT_QUICK_START.md   # Project quick start
        └── CURRENT_SESSION_STATE.md # Real-time work tracking
```

### **AI Collaboration Framework:**
```
your-project/
├── docs/
│   ├── ai_communication/
│   │   ├── VALIDATION_RULES.md     # Quality standards
│   │   └── README.md               # Communication guide
│   ├── AI_WORKFLOW.md              # "work ready" automation
│   └── AI_COLLABORATION_FRAMEWORK.md # How it works
```

---

## 🎯 **DAILY WORKFLOW**

### **1. During Work:**
- Code normally
- Update `framework/session-recovery/CURRENT_SESSION_STATE.md` with what you're working on

### **2. End Session:**
```bash
~/ai save
# Captures: current task, next action, files modified, exact state
```

### **3. Start Session:**
```bash
~/ai restore
# Displays: exactly where you left off, immediate next action
```

### **4. AI Collaboration:**
- **Terminal AI:** Run `"work ready"` to validate and generate reports
- **Browser AI:** `"Check docs/ai_communication/ for latest report"` to read and fix issues
- **Automatic:** AIs collaborate through repository files

---

## 🔧 **CUSTOMIZATION**

### **Available Presets:**
- **`react`** - Web apps (150 lines, 85% coverage, ESLint/Prettier/Jest)
- **`python`** - Backend/API (300 lines, 90% coverage, Black/Flake8/Pytest)
- **`java`** - Enterprise (400 lines, 85% coverage, Maven/JUnit)
- **`mobile`** - Mobile backend (200 lines, 95% coverage)
- **`data-science`** - ML/Analytics (500 lines, 80% coverage, Jupyter)

### **Custom Configuration:**
```bash
# See all options:
~/ai setup --help

# Custom setup:
~/ai setup --language go --max-file-size 300 --test-coverage 80 --validation-tools "golint,go test"
```

---

## 🚀 **ADVANCED USAGE**

### **Find All Your Projects:**
```bash
# From anywhere:
~/claude_session_recovery.sh
# Shows all projects with instant status and navigation
```

### **Team Collaboration:**
- Framework files get committed with your code
- Team members automatically get session recovery when they clone
- Consistent standards applied across entire team

### **Multiple Projects:**
- Same commands work in every project: `./restore_session.sh`
- Universal session recovery across all your work
- No learning curve - identical experience everywhere

---

## 🎯 **KEY BENEFITS**

| Before | After |
|--------|-------|
| 5-10 minutes figuring out where you left off | 5-10 seconds instant recovery |
| Manual copying between AI tools | Automatic AI-to-AI collaboration |
| Lost context and forgotten tasks | Perfect context preservation |
| Inconsistent code standards | Professional validation rules |
| Time wasted on recovery | Time focused on actual work |

---

## 📞 **NEED HELP?**

### **Documentation:**
- `README.md` - Complete framework guide
- `GETTING_STARTED.md` - Detailed setup instructions
- `FAQ.md` - Common questions
- `TROUBLESHOOTING.md` - Problem solutions

### **Quick Commands:**
```bash
# Help with setup:
~/ai setup --help

# Show system status:
~/ai status

# View/edit behavior rules:
~/ai rules --show
~/ai rules --add "new rule"

# Framework documentation:
cat README.md

# Session recovery guide:
cat SESSION_RECOVERY_SOP.md
```

---

**🎯 Bottom Line: Get professional AI collaboration + session recovery in any project with one command.**

**No more time wasted figuring out where you left off!**