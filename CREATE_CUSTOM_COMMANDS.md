# Create Custom Framework Commands

## Use ANY Phrase You Want

**Say whatever you want. Get instant results.**

Real examples you can use:
- "**shit's ready**" → runs verification
- "**fix it**" → fixes violations
- "**test this**" → runs tests
- "**deploy now**" → deploys to production
- "**check the code**" → runs linters
- **LITERALLY ANY PHRASE**

No slash commands. No remembering syntax. Just talk naturally.

---

## Add Your Own Phrase (3 Questions, Done)

**Run this script:**

```bash
./add-phrase.sh
```

**It asks 3 simple questions:**

1. What phrase do you want to use? → **"shit's ready"**
2. What should it do? → **"./verify_test.sh"**
3. Short description? → **"Verify framework test"**

**Done. Now say "shit's ready" and it runs.**

---

## Quick Start: Make Any Phrase Run Any Script (Manual Method)

**Create a command in 30 seconds:**

```bash
# 1. Create a new command file
nano .claude/commands/whatever.md

# 2. Add this content:
---
description: What this command does
aliases: ["shit's ready", "ready", "check it", "verify this"]
---

Your instructions for Claude here.
Can include bash commands, scripts, or high-level directions.

# 3. Save and exit (Ctrl+X, Y, Enter)
```

**Now you can say:** "shit's ready" OR "check it" OR "verify this" - any phrase in aliases triggers it.
**Or use slash command:** `/whatever` if you prefer.

---

## Examples

### Example 1: Simple Script Runner

**File:** `.claude/commands/test.md`
```markdown
---
description: Run all project tests
---

Run the test suite:
```bash
pytest tests/ -v
```
```

**Usage:** `/test`

---

### Example 2: Framework Automation

**File:** `.claude/commands/collab.md`
```markdown
---
description: Full OCC/TCC collaboration test
---

Execute complete framework test:
1. TCC validates code → creates AI_REPORT
2. OCC reads report → fixes violations → creates AI_RESPONSE
3. Verify all fixes passed
```

**Usage:** `/collab`

---

### Example 3: Complex Workflow

**File:** `.claude/commands/deploy.md`
```markdown
---
description: Deploy to production
---

Run deployment workflow:
```bash
./run_tests.sh
./build.sh
./deploy.sh production
```

Verify deployment succeeded and report status.
```

**Usage:** `/deploy`

---

## Command Locations

Commands can be in:
- `.claude/commands/` (project-specific)
- `~/.config/claude/commands/` (global)

---

## Tips

**Make it simple:**
- One word commands: `/fix`, `/test`, `/verify`
- No typing paths or arguments
- Let Claude handle the details

**What you can do:**
- Run scripts: `./your-script.sh`
- Give instructions: "Fix all validation violations"
- Complex workflows: Multi-step processes

**Framework commands you can create:**
- `/validate` - Run TCC validation
- `/fix` - OCC fixes violations
- `/verify` - Verify collaboration test
- `/snapshot` - Create session snapshot
- `/restore` - Restore session state
- Literally anything you want

---

## Your Turn

**Create your first custom command now:**

```bash
# Example: Create a "verify" command
cat > .claude/commands/verify.md << 'EOF'
---
description: Verify framework test worked
---

Run framework verification:
```bash
cd /tmp/SimpleCP
git fetch origin claude/fix-validation-issues-1763591690
git checkout claude/fix-validation-issues-1763591690
wc -l backend/clipboard_manager.py
flake8 backend/api/endpoints.py --max-line-length=88
```

Report results.
EOF
```

**Now type:** `/verify`

**That's it.**

---

## Advanced: Command with Arguments

**File:** `.claude/commands/check.md`
```markdown
---
description: Check file size compliance
---

User will provide filename. Check if it's under the size limit configured in framework settings. Report compliance status.
```

**Usage:** `/check backend/clipboard_manager.py`

---

**Create commands for EVERYTHING you do repeatedly.**
**One word = entire workflow automated.**
