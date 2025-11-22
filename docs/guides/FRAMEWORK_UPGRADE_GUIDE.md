# Framework Upgrade Guide - OCC Enhanced Features

## 🎉 What's New (November 2025)

The AI Collaboration Framework has been significantly enhanced with **OCC's task detection improvements**. New projects automatically get these features, but existing projects need to upgrade manually.

---

## 🚀 New Features Added

### 1. **Machine-Readable Task Status** (`.ai/STATUS`)
- Instant task detection for AI agents
- Shell-sourceable key=value format
- States: `IDLE | PENDING | IN_PROGRESS | BLOCKED`
- Replaces manual task checking

### 2. **Enhanced Task Framework**
- **`.ai/FRAMEWORK_USAGE.md`** - Complete 225-line usage guide
- **`.ai/TCC_QUICK_REFERENCE.md`** - 60-second task assignment guide
- **`.ai/CURRENT_TASK.md.TEMPLATE`** - Structured task template
- **`.ai/check-tasks.sh`** - Automatic task detection script

### 3. **Improved Workflow**
- **60-second task assignment** for TCC users
- **Instant task detection** for AI agents
- **Structured task templates** with clear completion criteria
- **Historical task tracking** in organized sections

---

## 📋 For Existing Projects - Manual Upgrade

### Option 1: Quick Upgrade (Copy Files)

```bash
# From your project root directory:
cd .ai/

# Copy new framework files from SimpleCP (or any updated project):
cp /path/to/updated-project/.ai/STATUS ./
cp /path/to/updated-project/.ai/FRAMEWORK_USAGE.md ./
cp /path/to/updated-project/.ai/TCC_QUICK_REFERENCE.md ./
cp /path/to/updated-project/.ai/CURRENT_TASK.md.TEMPLATE ./
cp /path/to/updated-project/.ai/check-tasks.sh ./

# Make script executable:
chmod +x check-tasks.sh

# Update STATUS with your project name:
sed -i 's/SimpleCP/YourProjectName/g' STATUS
```

### Option 2: Full Reinstall (Recommended)

```bash
# Backup your existing .ai/ customizations
cp -r .ai .ai-backup

# Re-run setup script (preserves git history):
~/path/to/setup-ai-collaboration.sh --preset [your-preset]

# Merge back any custom changes from .ai-backup/
```

---

## 🎯 How to Use New Features

### For TCC (Task Assignment)

**Quick 60-second workflow:**

1. **Edit STATUS file:**
   ```bash
   nano .ai/STATUS
   # Set: TASK_STATE=PENDING, SUMMARY="task description"
   ```

2. **Edit CURRENT_TASK.md:**
   ```bash
   nano .ai/CURRENT_TASK.md
   # Fill in ACTIVE ASSIGNMENT section using template
   ```

3. **Done!** AI will auto-detect at next session

### For AI Agents (OCC/Others)

**Instant task detection:**
```bash
# Check for work:
./.ai/check-tasks.sh

# Read instructions if PENDING:
cat .ai/CURRENT_TASK.md

# Begin work immediately (no exploration needed)
```

---

## 🔧 Compatibility

### ✅ What Still Works
- All existing `.ai/` files (README.md, BEHAVIOR_RULES.md, CURRENT_TASK.md)
- Existing task assignment workflows
- Cross-environment compatibility
- Session recovery and handoff systems

### 🆕 What's Enhanced
- **Faster task detection** (instant vs. manual checking)
- **Structured workflows** (templates vs. freeform)
- **Machine-readable state** (scriptable vs. human-only)
- **Complete documentation** (self-documenting framework)

### 📦 New Project Features
- **All new projects** automatically get enhanced features
- **Existing projects** continue working without upgrade
- **Optional upgrade** for enhanced workflows

---

## 🚨 Breaking Changes

**None!** This is a **backward-compatible enhancement**.

- Existing workflows continue working
- New features are additive
- Upgrade is optional but recommended

---

## 📊 Feature Comparison

| Feature | Before | After (OCC Enhanced) |
|---------|--------|---------------------|
| Task Detection | Manual file reading | `.ai/check-tasks.sh` (instant) |
| Task Assignment | Freeform CURRENT_TASK.md | Structured template + STATUS |
| State Tracking | Human-readable only | Machine + human readable |
| Documentation | Basic README | Complete usage guide |
| Setup Time | "Figure it out" | 60-second workflow |

---

## 📚 Documentation

### Essential Reading (New Users)
1. **`.ai/FRAMEWORK_USAGE.md`** - Complete guide
2. **`.ai/TCC_QUICK_REFERENCE.md`** - 60-second summary

### Reference Files
- **`.ai/CURRENT_TASK.md.TEMPLATE`** - Task structure template
- **`.ai/STATUS`** - Machine-readable state example
- **`.ai/check-tasks.sh`** - Task detection script

---

## 🔗 Links

- **Framework Repository:** [AI-Collaboration-Management](https://github.com/JamesKayten/AI-Collaboration-Management)
- **Example Implementation:** [SimpleCP](https://github.com/JamesKayten/SimpleCP)
- **OCC Enhanced Features:** See `.ai/` directory in any updated project

---

## 💡 Migration Examples

### Example 1: Convert Existing Task

**Before (manual):**
```markdown
# Current Task: Add user authentication
Please implement OAuth login system...
```

**After (structured):**
```bash
# STATUS file:
TASK_STATE=PENDING
SUMMARY="Implement OAuth login system"
PRIORITY=1
ASSIGNED_TO=OCC

# CURRENT_TASK.md ACTIVE ASSIGNMENT section:
## 🎯 ACTIVE ASSIGNMENT
**Status:** PENDING
**Objective:** Implement OAuth2 authentication system
**Files to modify:** auth.py, routes.py, templates/login.html
**Definition of Done:**
- [ ] OAuth2 provider integration
- [ ] Login/logout routes
- [ ] Tests pass with 90% coverage
```

### Example 2: Quick Detection

**Before:**
```bash
cat .ai/CURRENT_TASK.md  # Read whole file, parse manually
```

**After:**
```bash
./.ai/check-tasks.sh     # Instant: "🎯 PENDING TASK DETECTED"
```

---

## 🎯 Recommendation

**For active projects:** Upgrade to enhanced framework for better productivity

**For stable projects:** Current framework continues working perfectly

**For new projects:** Enhanced features included automatically

---

**Questions?** Check `.ai/FRAMEWORK_USAGE.md` for complete documentation!