# AI COLLABORATION - START HERE

## NEW TO THIS PROJECT? READ THIS FIRST

**If you are TCC (Terminal Claude Code):**
1. Read `TCC_ONBOARDING.md` in this directory
2. Run `/check-the-board` command
3. Follow the instructions from BOARD.md

**If you are OCC (Online Claude Code):**
1. Read `.ai/CURRENT_TASK.md` for your assignment
2. Do the work
3. Update BOARD.md when complete

---

## TCC QUICK START

**FIRST COMMAND EVERY SESSION:**

```bash
/check-the-board
```

**This command will:**
1. Show you BOARD.md (current status)
2. Show you TASKS.md (what needs to be done)
3. Automatically commit and push any changes

**After checking the board:**
- If BOARD.md says "waiting for validation" → Run `/verify` or `/works-ready`
- If BOARD.md says "ready to merge" → Run `/works-ready`
- If BOARD.md says specific task → Do that task
- If BOARD.md says "all clear" → Read `.ai/CURRENT_TASK.md` for next assignment

## Working Style
1. **Read `.ai/BEHAVIOR_RULES.md`** - Understand working style requirements
2. **Execute tasks immediately** - No questions, no exploration
3. **Update BOARD.md** when tasks change status

## Quick Start
```bash
# ALWAYS start with this
/check-the-board

# Then follow the instructions from BOARD.md
```

## Project Info
- **Type:** Python Backend/API
- **Language:** python
- **File Size Limit:** 300 lines
- **Test Coverage:** 90%
- **Tools:** black,flake8,pytest

## File Structure
- `BEHAVIOR_RULES.md` - How to work
- `CURRENT_TASK.md` - What to work on
- `COMPLETED_TASKS.md` - Work history

**Environment Universal:** Works in any environment (macOS, Linux, containers)

**No setup required** - Just read and execute.