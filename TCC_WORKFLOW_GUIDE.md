# TCC Workflow Guide

**Simple collaboration workflow for Terminal Claude Code**

---

## Overview

TCC (Terminal Claude Code) collaborates with OCC (Online Claude Code) using simple file-based communication.

**No complex scripts. Just files.**

---

## Core Workflow

### 1. Check Status
```bash
/check-the-board
```
Reads `BOARD.md` and `TASKS.md` - that's it.

### 2. Do Work
Make changes, write code, fix issues.

### 3. Update Status
```bash
edit TASKS.md  # Mark tasks complete
edit BOARD.md  # Update status
```

### 4. Commit & Push
```bash
git add .
git commit -m "Description of changes"
git push
```

### 5. Merge When Ready
```bash
/merge-to-main
```
Creates PR for merge.

---

## Available Commands

### `/check-the-board`
- Reads BOARD.md
- Reads TASKS.md
- Reports status

**No scripts executed. Just reads files.**

### `/fix-violations`
- Find issues reported
- Fix them
- Commit and push

### `/verify`
- Pull latest changes
- Run validation (tests, linters)
- Report results

### `/works-ready`
- Validate changes
- Merge if passing
- Report issues if failing

### `/merge-to-main`
- Check for uncommitted changes
- Push current branch
- Create PR with summary

---

## Collaboration Pattern

**TCC's Role:**
1. Validate code quality
2. Run tests and checks
3. Merge when passing
4. Report issues when failing

**OCC's Role:**
1. Read TCC's reports
2. Fix issues
3. Push changes
4. Respond with fixes

**Communication:**
- Through git commits
- Through BOARD.md updates
- Through simple files

**No complexity required.**

---

## What Changed from v2.0

**Old workflow:**
- Run 334-line shell scripts
- Update 6 different JSON state files
- Provide proof-of-completion with screenshots
- Execute monitoring and enforcement
- Parse natural language rules
- Manage caching systems

**New workflow:**
- Read 2 markdown files
- Make changes
- Commit and push
- Done

**97% simpler.**

---

## Troubleshooting

**Problem:** Command not working
**Solution:** Check that BOARD.md and TASKS.md exist

**Problem:** Can't find status
**Solution:** `cat BOARD.md`

**Problem:** Framework too complex
**Solution:** You're looking at v2.0 docs. Use v3.0.

---

## Philosophy

Keep it simple:
- Files over scripts
- Trust over verify
- Clarity over automation
- Minimal over comprehensive

**If it's getting complex, you're doing it wrong.**

---

**Version:** 3.0 Simple
**Last Updated:** November 23, 2025

**Simple file-based collaboration for TCC.**
