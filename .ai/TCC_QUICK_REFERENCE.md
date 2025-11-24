# TCC Quick Reference - Task Assignment

## 🚨 CRITICAL: Always Include Context

**EVERY message to user must include:**
- **Repository:** Which repo (SimpleCP, AICM, etc.)
- **Branch:** Full branch name if applicable
- **File paths:** Full path (e.g., SimpleCP/docs/BOARD.md)

❌ WRONG: "Two merges remain"
✅ RIGHT: "Two merges remain in **AI-Collaboration-Management**: branch `claude/fix-xyz`"

---

## Assign a Task in 60 Seconds

### 1. Edit STATUS file (5 fields)
```bash
nano .ai/STATUS
```
Set:
- `TASK_STATE=PENDING`
- `SUMMARY="Your task summary"`
- `PRIORITY=1` (1-4)
- `ASSIGNED_TO=OCC` (or ANY)
- `EFFORT_HOURS=4`

### 2. Edit CURRENT_TASK.md (top section only)
```bash
nano .ai/CURRENT_TASK.md
```
Fill in **ACTIVE ASSIGNMENT** section:
- What to do
- Which files
- How to verify

### 3. Done ✅
AI detects automatically at next session start.

---

## Check Current Status
```bash
source .ai/STATUS && echo "State: $TASK_STATE | Assigned to: $ASSIGNED_TO"
```

## Files Explained
- **STATUS** = Machine-readable state (IDLE/PENDING/etc)
- **CURRENT_TASK.md** = Human-readable instructions
- **FRAMEWORK_USAGE.md** = Full documentation
- **CURRENT_TASK.md.TEMPLATE** = Template to copy from

## Task States
- `IDLE` = No work pending
- `PENDING` = Task assigned, waiting for AI to start
- `IN_PROGRESS` = AI currently working on it
- `BLOCKED` = Task stuck, needs attention

---

**Full guide:** `.ai/FRAMEWORK_USAGE.md`
