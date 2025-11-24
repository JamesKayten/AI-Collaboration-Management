# OCC (Online Claude Copilot) Guide

Complete guide for activating and using Online Claude with the AI Collaboration Framework.

---

## 🎯 Quick Start: Two Activation Methods

### Method 1: Activation Code (Recommended)

**Just type:**
```
framework check
```

**Requirements:** One-time setup of Claude custom instructions (see below)

### Method 2: Standard Prompt

**Copy and paste:**
```
Check the AI Collaboration Framework in the repository for new instructions and reports in framework/communications/. Pull latest changes, address any validation reports, commit your response, and push back to GitHub.
```

**Requirements:** None - works immediately in any session

---

## 🔧 Method 1 Setup: Activation Code

Make OCC respond to just "framework check" (two words!) instead of a long prompt.

### One-Time Setup

Add this to **Claude Custom Instructions** in your browser:

**What would you like Claude to know about you?**
```
I use the AI Collaboration Framework (AICH) for GitHub-based collaboration
between you (Online Claude) and Terminal Claude Code (TCC).
```

**How would you like Claude to respond?**
```
When I say "framework check", you should:
1. Pull latest changes from the current GitHub repository
2. Check framework/communications/ for:
   - Validation reports in reports/
   - Work notifications in updates/
   - Previous responses in responses/
3. Read any reports or instructions you find
4. Take appropriate action (fix issues, respond to requests, etc.)
5. Commit your changes and responses to framework/communications/responses/
6. Push everything back to GitHub
7. Confirm what you did

This is part of the AI Collaboration Hub (AICH) workflow where TCC validates
code and leaves instructions for you in the repository.
```

### Using the Activation Code

After setup, just type:
```
framework check
```

OCC will automatically:
- Pull from GitHub
- Check framework communications
- Read reports
- Fix issues
- Push response

**Alternative Activation Codes:**
- `collab sync` - Short, implies synchronization
- `aich check` - Explicit framework reference
- `work sync` - Focuses on work being synchronized
- `fc` - Ultra-short alias

---

## 📋 Method 2: Standard Prompt

No setup required - works in any OCC session immediately.

### The Universal Command

```
Check the AI Collaboration Framework in the repository for new instructions and reports in framework/communications/. Pull latest changes, address any validation reports, commit your response, and push back to GitHub.
```

### When to Use

- First time using the framework
- One-off collaboration sessions
- Don't want to set up custom instructions
- Using someone else's Claude account
- Testing the framework

### Getting the Prompt Quickly

In your terminal:
```bash
./ai activate
```

This displays the repository info and standard prompt to copy.

---

## 🚀 Complete Workflow Example

```bash
# ==========================================
# Step 1: OCC implements feature
# ==========================================
You in Browser: "Add user profile component to SimpleCP"
OCC: *implements feature, commits, pushes to GitHub*

# ==========================================
# Step 2: TCC validates
# ==========================================
You in Terminal: "work ready"
TCC: *validates, finds issues, creates report, pushes to GitHub*

# ==========================================
# Step 3: Activate OCC
# ==========================================
You in Browser: "framework check"  (or paste standard prompt)
OCC: *pulls, reads report, fixes issues, commits response, pushes*

# ==========================================
# Step 4: TCC re-validates
# ==========================================
You in Terminal: "work ready"
TCC: *pulls, validates, merges if clean*
```

---

## 📖 What OCC Does Automatically

When activated, OCC:

1. **Pulls Latest from GitHub**
   - Gets all recent changes
   - Ensures current with TCC's work

2. **Checks `framework/communications/`**
   - Looks in `reports/` for validation reports
   - Looks in `updates/` for other instructions
   - Checks `responses/` for conversation history

3. **Reads Latest Report**
   - Understands what needs fixing
   - Identifies all violations

4. **Fixes All Issues**
   - Addresses each violation
   - Writes tests if needed
   - Updates documentation

5. **Creates Response**
   - Documents what was fixed
   - Saves to `framework/communications/responses/`

6. **Commits and Pushes**
   - Commits all changes
   - Pushes to GitHub
   - Makes changes available to TCC

---

## 💡 Pro Tips

### 1. Bookmark the Activation Code

If using Method 1, add "framework check" to text shortcuts:
- **macOS:** System Settings → Keyboard → Text Replacements
- **Windows:** AutoHotkey or TextExpander
- **Browser:** Chrome extension for text snippets

### 2. Voice Commands

If using Claude mobile or voice input:
```
"Hey Claude, framework check"
```

### 3. Project-Specific Codes

For multiple projects:
```
"simplecp check"  → Check SimpleCP framework
"project check"   → Check current project framework
"fc"              → Framework check (universal)
```

### 4. Save the Standard Prompt

Keep the standard prompt in your notes for quick access:
```
Check the AI Collaboration Framework in the repository for new instructions and reports in framework/communications/. Pull latest changes, address any validation reports, commit your response, and push back to GitHub.
```

---

## 🎯 Quick Reference

### Commands

| Command | What It Does | Requires Setup |
|---------|-------------|----------------|
| `framework check` | OCC checks framework, fixes issues, pushes | Yes (custom instructions) |
| Standard prompt | Same as above | No |
| `./ai activate` | Terminal shows activation info | No |
| `work ready` | TCC validates code | No |

### File Locations

| Path | Purpose |
|------|---------|
| `framework/communications/reports/` | TCC validation reports |
| `framework/communications/responses/` | OCC fix responses |
| `framework/communications/updates/` | Status notifications |

### When to Use OCC

- ✅ After TCC runs "work ready" and finds issues
- ✅ To check for new framework communications
- ✅ Start of any collaboration session
- ✅ After making changes that need validation

---

## 🔄 Method Comparison

| Feature | Activation Code | Standard Prompt |
|---------|----------------|-----------------|
| **Setup Required** | Yes (one-time) | No |
| **Activation Length** | 2 words | ~30 words |
| **Works Everywhere** | Only with your Claude | Any Claude session |
| **Speed** | Very fast | Copy/paste required |
| **Best For** | Regular use | Testing, one-off use |

**Recommendation:** Set up the activation code for regular use, keep the standard prompt bookmarked for backups.

---

## ✅ Setup Checklist

**For Activation Code Method:**
- [ ] Open Claude in browser
- [ ] Go to Settings → Custom Instructions
- [ ] Add "AICH framework" context
- [ ] Add "framework check" response instructions
- [ ] Save custom instructions
- [ ] Test with "framework check"
- [ ] Verify OCC knows what to do

**For Standard Prompt Method:**
- [ ] Bookmark the standard prompt
- [ ] Test by pasting into Claude
- [ ] Verify OCC activates correctly

---

## 🆘 Troubleshooting

### OCC doesn't respond to "framework check"
- Verify custom instructions are saved
- Check you're using the right Claude account
- Try re-adding the custom instructions

### OCC can't find the repository
- Ensure you mentioned the repository in the conversation
- Try specifying the repo explicitly: "In the JamesKayten/project-name repository, framework check"

### OCC doesn't find reports
- Verify TCC has run "work ready" first
- Check that reports exist in `framework/communications/reports/`
- Ensure reports were pushed to GitHub

### OCC makes changes but doesn't push
- OCC may not have GitHub access in current session
- You may need to provide GitHub authentication
- Try standard prompt with explicit "push to GitHub" instruction

---

## 🎉 Benefits

### With Activation Code
- **90% less typing** - Two words instead of paragraph
- **Faster workflow** - No copy/paste needed
- **Consistent** - Same command every time
- **Professional** - Clean, simple activation

### With Standard Prompt
- **No setup** - Works immediately
- **Portable** - Use on any account
- **Explicit** - Clear instructions every time
- **Reliable** - Always available

---

**Choose your method and start collaborating!** 🚀

For more information:
- See [AI_COLLABORATION_FRAMEWORK.md](../ai-collaboration/AI_COLLABORATION_FRAMEWORK.md)
- See [AI_WORKFLOW.md](../ai-collaboration/AI_WORKFLOW.md)
- See [QUICK_START.md](../guides/QUICK_START.md)
