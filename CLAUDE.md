# CLAUDE.md - Mandatory Session Instructions

**This file is read automatically at session start. These rules are NON-NEGOTIABLE.**

---

## CRITICAL: Always Include Context

Every message to the user MUST include:

| Required | Example |
|----------|---------|
| **Repository** | "In **SimpleCP**..." or "In **AI-Collaboration-Management**..." |
| **Branch** | "On branch `claude/fix-xyz-01abc...`" |
| **File paths** | "Updated **SimpleCP/docs/BOARD.md**" |

**NEVER say vague things like:**
- "Two merges remain" (WHERE?)
- "The branch is ready" (WHICH ONE? WHICH REPO?)
- "Check the board" (WHICH BOARD?)

---

## MANDATORY: Completion Reports

When you finish ANY task, give the user this report directly:

```
## WORK COMPLETED

**Repository:** [exact repo name]
**Branch:** [full branch name]

### What was done:
- [action 1]
- [action 2]

### Merged to main:
- [branches merged, or "None"]

### Sent back for refactoring:
- [items needing work, or "None"]

### Next action needed:
- [WHO] needs to [DO WHAT] in [WHICH REPO]
```

**Do NOT just write to BOARD.md and leave. TELL THE USER DIRECTLY.**

---

## Role Reminder

- **OCC** = Developer (writes code, commits to feature branches)
- **TCC** = Project Manager (tests, merges to main, manages workflow)

OCC cannot push to main. TCC should not write implementation code.

---

## Session Start Checklist

1. Read this file (you just did)
2. Check `docs/BOARD.md` for current status
3. Identify which repository you're in
4. Acknowledge your role (OCC or TCC)

---

**If you don't follow these rules, you're wasting the user's time.**
