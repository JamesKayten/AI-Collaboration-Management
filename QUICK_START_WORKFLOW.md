# Quick Start: AI Collaboration Workflow

**The script you were looking for**: `./ai activate` ✨

## Setup (One Time)

```bash
# In your project directory
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git ../AI-Collaboration-Management
bash ../AI-Collaboration-Management/setup-ai-collaboration.sh --preset react
```

This creates the `./ai` command in your project.

---

## Daily Workflow

### 1. Browser Claude Implements Feature

In your browser (FREE usage):
```
"Add a user profile component with avatar upload to SimpleCP"
```

I create the code, commit to a branch, and push.

### 2. Local Claude Validates

In your terminal (minimal token usage):
```bash
"work ready"
```

Local Claude:
- Checks for my updates
- Validates code against rules
- Creates report if violations found
- Merges if everything passes

### 3. Get OCC Activation Command ⭐

**This is the script you were asking about!**

In your terminal:
```bash
./ai activate
```

This shows:
- ✅ Latest validation report (if any)
- 📄 Report preview
- 📋 **Exact command to copy/paste to Browser Claude**
- 📊 Communication stats

### 4. I Fix the Issues

Copy the command from `./ai activate` and paste into browser Claude. I'll:
- Read the validation report
- Fix all violations
- Create a response file
- Push fixes

### 5. Re-validate

In terminal:
```bash
"work ready"
```

Local Claude re-validates and merges if clean!

---

## Quick Commands

```bash
./ai activate   # Get OCC activation command (THE SCRIPT YOU WANTED!)
./ai status     # Check for validation reports
./ai help       # Show all commands
```

---

## Example Session

```bash
# Terminal (Local Claude)
$ "work ready"
> ❌ Found violations in feature/user-profile
> Report created: .ai-framework/communications/reports/AI_REPORT_20251119.md

# Terminal (You)
$ ./ai activate
> 📋 Copy this command and paste into Browser Claude:
> ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
> Check .ai-framework/communications/reports/AI_REPORT_20251119.md and address all violations
> ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Browser (You paste command to me)
"Check .ai-framework/communications/reports/AI_REPORT_20251119.md and address all violations"

# Browser (Me - Online Claude)
> ✅ I've read the report and fixed all violations:
> - Split UserProfile component into 3 smaller files
> - Added comprehensive tests (92% coverage)
> - Fixed ESLint errors
> Response created: .ai-framework/communications/responses/AI_RESPONSE_20251119.md

# Terminal (Local Claude)
$ "work ready"
> ✅ All checks passed! Merging feature/user-profile to main
```

---

## Files Overview

### Framework generates this command for you:
```
./ai activate → Shows the OCC activation command
```

### Communication files:
```
.ai-framework/
├── communications/
│   ├── reports/        ← Local AI creates validation reports here
│   ├── responses/      ← I (Online Claude) put my responses here
│   └── updates/        ← General AI-to-AI communications
└── rules/
    └── VALIDATION_RULES.md  ← Project quality standards
```

---

## Why This Saves Money

**Without Framework:**
- Local Claude does everything → Burns through subscription

**With Framework:**
- Online Claude (Browser): 90% of work → FREE
- Local Claude (Terminal): Validation only → Minimal tokens
- **Result**: 80-90% reduction in local usage!

---

## The Script You Were Looking For

**Location**: Already installed in SimpleCP as `./ai`

**Direct script**: `/home/user/AI-Collaboration-Management/scripts/activate-occ.sh`

**What it does**:
1. Checks for validation reports
2. Shows report preview
3. Generates the exact OCC activation command
4. Displays communication stats

**Usage**:
```bash
cd /home/user/SimpleCP
./ai activate
```

Copy the green command it shows and paste to Browser Claude!

---

## Pro Tips

1. **After I complete work in browser**, run `./ai status` to see if there are reports
2. **Use `./ai activate`** instead of manually typing commands
3. **Keep the `./ai` command** - it's your quick access to the framework
4. **Local Claude only for validation** - saves your subscription

---

**You're all set!** The framework is installed in SimpleCP and ready to use.

Want to test it? Give me a feature to implement and we'll run through the full workflow!
