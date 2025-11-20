# Standard OCC Activation Prompt

## 🎯 The Universal Command

Copy and paste this into **any** OCC (Online Claude) session:

```
Check the AI Collaboration Framework in the repository for new instructions and reports in .ai-framework/communications/. Pull latest changes, address any validation reports, commit your response, and push back to GitHub.
```

That's it! This single command activates OCC for any project using the framework.

---

## 📋 What This Command Tells OCC

When you paste this, I (OCC) will automatically:

1. **Pull latest from GitHub**
   - Get all recent changes
   - Ensure I have latest reports

2. **Check `.ai-framework/communications/`**
   - Look in `reports/` for validation reports
   - Look in `updates/` for other instructions

3. **Read latest report**
   - Understand what needs to be fixed
   - Identify all violations

4. **Fix all issues**
   - Address each violation
   - Write tests if needed
   - Update documentation

5. **Create response**
   - Document what was fixed
   - Save to `.ai-framework/communications/responses/`

6. **Commit and push**
   - Commit all changes
   - Push to GitHub
   - Make changes available to Local Claude

---

## 🚀 Usage

### In Local Terminal (After "work ready")

```bash
cd /path/to/your-project
./ai activate
```

This will display the repository info and the standard prompt to copy.

### Or Just Copy This

If you don't have `./ai activate`, just copy this:

```
Check the AI Collaboration Framework in the repository for new instructions and reports in .ai-framework/communications/. Pull latest changes, address any validation reports, commit your response, and push back to GitHub.
```

Paste it into Browser Claude → I'll handle the rest!

---

## 💡 Why This Works

### Universal
- Works for **any project** using the framework
- Works in **any OCC session** (new or existing)
- No project-specific details needed

### Complete
- Contains all instructions I need
- Tells me where to look
- Tells me what to do
- Tells me how to respond

### Simple
- One command for everything
- Easy to remember
- Easy to copy/paste

---

## 🎯 Full Workflow Example

```bash
# ==========================================
# Step 1: You ask OCC to implement feature
# ==========================================
You in Browser: "Add user profile component to SimpleCP"
Me (OCC): *implements feature, commits, pushes to GitHub*

# ==========================================
# Step 2: Local Claude validates
# ==========================================
You in Terminal: "work ready"
Local Claude: *validates, finds issues, creates report, pushes to GitHub*

# ==========================================
# Step 3: You activate OCC with standard prompt
# ==========================================
You in Browser: "Check the AI Collaboration Framework in the repository for new instructions and reports in .ai-framework/communications/. Pull latest changes, address any validation reports, commit your response, and push back to GitHub."

Me (OCC): *pulls, reads report, fixes issues, commits response, pushes*

# ==========================================
# Step 4: Local Claude re-validates
# ==========================================
You in Terminal: "work ready"
Local Claude: *pulls, validates, merges if clean*
```

---

## 🔧 Advanced: Project-Specific Variants

For specific scenarios, you can slightly modify:

### **Initial Check (No Issues Yet)**
```
Check the AI Collaboration Framework in the repository for updates in .ai-framework/communications/.
```

### **After Making Changes**
```
Pull latest changes from GitHub and check .ai-framework/communications/reports/ for validation feedback on my recent work.
```

### **Urgent Fix**
```
Pull from GitHub immediately and check .ai-framework/communications/reports/ for critical validation issues that need immediate attention.
```

But honestly, the standard prompt works for everything!

---

## 📖 What Makes This Better

### Old Way (Complex)
```
Pull latest changes from GitHub branch feature/auth, then check .ai-framework/communications/reports/AI_REPORT_20251119_143022.md and address all violations. When done, commit your fixes and response to .ai-framework/communications/responses/ and push to GitHub.
```

### New Way (Simple)
```
Check the AI Collaboration Framework in the repository for new instructions and reports in .ai-framework/communications/. Pull latest changes, address any validation reports, commit your response, and push back to GitHub.
```

**Same effect, much simpler!**

---

## ✨ Save This Command

Add this to your notes/shortcuts:

**Standard OCC Activation:**
```
Check the AI Collaboration Framework in the repository for new instructions and reports in .ai-framework/communications/. Pull latest changes, address any validation reports, commit your response, and push back to GitHub.
```

Paste it whenever you need to activate OCC after Local Claude has run validation.

---

## 🎯 Quick Reference Card

```
┌─────────────────────────────────────────────────────────┐
│          STANDARD OCC ACTIVATION PROMPT                 │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Check the AI Collaboration Framework in the           │
│  repository for new instructions and reports in        │
│  .ai-framework/communications/. Pull latest changes,   │
│  address any validation reports, commit your           │
│  response, and push back to GitHub.                    │
│                                                         │
└─────────────────────────────────────────────────────────┘

WHEN TO USE:
• After Local Claude runs "work ready"
• When you want OCC to check for updates
• Start of any collaboration session

WHAT IT DOES:
• Pulls latest from GitHub
• Reads validation reports
• Fixes all issues
• Commits and pushes response

WORKS FOR:
• Any project with the framework
• Any OCC session
• Any time
```

---

**This is your universal activation command!** 🎉

Save it, bookmark it, and use it every time you need OCC to check the framework.
