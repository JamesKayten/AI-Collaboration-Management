# OCC Activation Code System

## 🎯 The Simple Activation Code

Instead of pasting a long prompt, just type:

```
framework check
```

That's it! Two words.

---

## 🔧 Setup (One-Time)

To make this work, add this to your **Claude Custom Instructions** in the browser:

### Custom Instructions for Claude

**What would you like Claude to know about you?**
```
I use the AI Collaboration Framework (AICH) for GitHub-based collaboration
between you (Online Claude) and Terminal Claude Code (TCC).
```

**How would you like Claude to respond?**
```
When I say "framework check", you should:
1. Pull latest changes from the current GitHub repository
2. Check .ai-framework/communications/ for:
   - Validation reports in reports/
   - Work notifications in updates/
   - Previous responses in responses/
3. Read any reports or instructions you find
4. Take appropriate action (fix issues, respond to requests, etc.)
5. Commit your changes and responses to .ai-framework/communications/responses/
6. Push everything back to GitHub
7. Confirm what you did

This is part of the AI Collaboration Hub (AICH) workflow where TCC validates
code and leaves instructions for you in the repository.
```

---

## ✨ How to Use

### Once Setup is Complete

**In your project**, when TCC has validated and created a report:

**Terminal**:
```bash
./ai activate
```

**Shows**:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Simple Activation Code:
  framework check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Browser (paste to OCC)**:
```
framework check
```

**I (OCC) automatically**:
- Pull from GitHub
- Check AICH framework
- Read reports
- Fix issues
- Push response

---

## 🎯 Alternative Activation Codes

If you prefer different wording, you can use:

### Option 1: "framework check" (Recommended)
Simple, clear, technical

### Option 2: "collab sync"
Short, implies synchronization

### Option 3: "aich check"
Explicit reference to framework name

### Option 4: "work sync"
Focuses on the work being synchronized

**Pick one and add it to your custom instructions!**

---

## 📋 Full Custom Instructions Template

Copy this entire block into Claude's custom instructions:

```
PROJECT CONTEXT:
I use the AI Collaboration Framework (AICH) for GitHub-based AI-to-AI
collaboration. You (Online Claude/OCC) work with Terminal Claude Code (TCC)
through a repository.

ACTIVATION CODE: "framework check"

When I say "framework check":
1. Pull latest changes from the GitHub repository we're working on
2. Navigate to .ai-framework/communications/ directory
3. Check for:
   - Validation reports in reports/ (from TCC)
   - Work notifications in updates/ (status updates)
   - Previous responses in responses/ (your past work)
4. If you find a validation report:
   - Read it completely
   - Understand all violations and issues
   - Fix each issue mentioned
   - Create a response file in responses/ documenting fixes
5. If you find a work notification:
   - Acknowledge it
   - Provide status update
6. Always:
   - Commit all changes (code fixes + response files)
   - Push to GitHub
   - Confirm completion with summary

WORKFLOW CONTEXT:
- TCC validates code and creates reports when issues are found
- TCC merges to main when validation passes
- Reports contain specific violations to fix
- Your responses help TCC know what was fixed

RESPONSE FORMAT:
When I say "framework check", respond with:
- "Checking AICH framework..." (as you pull)
- Summary of what you found
- Actions you're taking
- Confirmation when pushed to GitHub
```

---

## 🚀 Example Session

### First Time (With Setup)

**You**:
```
I'm setting up the AICH framework. When I say "framework check",
you should pull from GitHub, check .ai-framework/communications/
for validation reports, fix any issues, and push your response back.
```

**OCC**:
```
Got it! I'll watch for "framework check" as your activation code...
```

### Every Time After

**You**:
```
framework check
```

**OCC**:
```
Checking AICH framework...
✅ Pulled from GitHub (branch: feature/auth)
📋 Found validation report: AI_REPORT_20251119_153500.md
📖 Reading report...

Issues found:
1. LoginForm.tsx exceeds 150 lines (187 lines)
2. Test coverage at 78% (need 85%)

Fixing...
✅ Split LoginForm into 3 components
✅ Added error handling tests
✅ Coverage now at 92%

Creating response...
✅ Committed fixes
✅ Pushed to GitHub

Ready for TCC re-validation!
```

---

## 💡 Pro Tips

### 1. **Bookmark the Code**
Add "framework check" to your text shortcuts:
- macOS: System Settings → Keyboard → Text Replacements
- Windows: AutoHotkey or TextExpander
- Browser: Chrome extension for text snippets

### 2. **Even Shorter Alias**
In your custom instructions, you could make it respond to just:
```
"fc"
```
(framework check)

### 3. **Project-Specific Codes**
For multiple projects:
```
"simplec check"  → Check SimpleCP framework
"project check"  → Check current project framework
"fc"             → Framework check (universal)
```

### 4. **Voice Commands**
If using Claude mobile or voice input:
```
"Hey Claude, framework check"
```

---

## 🔄 How It Works

### Without Custom Instructions
```
You: "Check the AI Collaboration Framework in the repository for
new instructions and reports in .ai-framework/communications/.
Pull latest changes, address any validation reports, commit your
response, and push back to GitHub."

OCC: [reads, processes, responds]
```

### With Custom Instructions
```
You: "framework check"

OCC: [knows exactly what to do, does it automatically]
```

**Same result, 90% less typing!** 🎉

---

## ✅ Setup Checklist

- [ ] Open Claude in browser
- [ ] Go to Settings → Custom Instructions
- [ ] Paste the template above
- [ ] Save
- [ ] Test with "framework check"
- [ ] Verify OCC knows what to do

---

## 📖 Reference

### Quick Commands

| Command | What It Does |
|---------|-------------|
| `framework check` | OCC checks AICH, fixes issues, pushes |
| `./ai activate` | Terminal shows activation code |
| `work ready` | TCC validates code |

### File Locations

| Path | Purpose |
|------|---------|
| `.ai-framework/communications/reports/` | TCC validation reports |
| `.ai-framework/communications/responses/` | OCC fix responses |
| `.ai-framework/communications/updates/` | Status notifications |

---

**Two words to activate the entire AI collaboration workflow!** 🚀

Set it up once, use it forever with just "framework check".
