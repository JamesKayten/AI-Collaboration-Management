# CLAUDE.md - Mandatory Session Instructions

**This file is read automatically at session start. These rules are NON-NEGOTIABLE.**

---

## TCC AUTO-INITIALIZATION (macOS only)

**On session start, TCC is ALREADY INITIALIZED by the hook. Do NOT re-explain your role.**

The hook has already:
- Synced with GitHub
- Detected OCC branches (shown in hook output)
- Started watchers
- Displayed board status

**TCC startup response must be ONE LINE ONLY:**
> "TCC - Role and Rules Confirmed. [N] branch(es) pending." (or "TCC - Role and Rules Confirmed. Standing by.")

**When user says "works ready":** Execute /works-ready IMMEDIATELY. No preamble, no explanation - just DO IT.

---

## CRITICAL: Always Include Context

Every message to the user MUST include:

| Required | Example |
|----------|---------|
| **Repository** | "In **ProjectName**..." or "In **current-project**..." |
| **Branch** | "On branch `claude/fix-xyz-01abc...`" |
| **File paths** | "Updated **project-name/docs/BOARD.md**" |

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
- **Commit hash:** [hash of merged commit - REQUIRED for verification]

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

## TCC: Merge Verification (CRITICAL)

Before reporting a merge complete, TCC MUST:
1. `git fetch origin [branch]` to get latest
2. Check branch HEAD hash
3. Merge
4. Report the **exact commit hash** that was merged

This prevents stale merges where OCC pushed new commits during TCC's work.

---

## TCC: Sync Confirmation (CRITICAL)

After ANY merge or sync operation, TCC MUST explicitly confirm:

```
✅ SYNC STATUS
- Local main:  [commit hash]
- Remote main: [commit hash]
- Status: IN SYNC ✓ (or OUT OF SYNC ✗)
```

**Run these commands to verify:**
```bash
git rev-parse HEAD              # Local HEAD
git rev-parse origin/main       # Remote HEAD (after fetch)
git status                      # Should show "up to date with origin/main"
```

**The user MUST see clear confirmation that local and remote are synchronized.**
Do NOT assume sync is complete - VERIFY and REPORT explicitly.

---

## TCC: Board Update Required

After completing ANY task from the board, TCC MUST:
1. Update BOARD.md - mark task as ✅ COMPLETED or remove it
2. Commit and push to main
3. This triggers the board watcher alert so OCC knows work is done

**Do not leave stale tasks on the board.** Close the loop.

---

## TCC: Pull Request Template (MANDATORY)

When creating PRs, TCC MUST use this format:

```markdown
## Summary
- [What this branch does in 1-2 sentences]

## Commits Included
- 'abc123' - Fix widget layout
- 'def456' - Add error handling

## Files Changed
- `src/Views/Widget.swift` (refactored, 45 lines)
- `src/Models/Data.swift` (new file, 80 lines)

## Testing Done
- ✓ Build passes
- ✓ File size checks pass
- ✓ Ran on simulator

## Ready to Merge
**Branch:** `claude/feature-xyz-01abc...`
**Into:** `main`
```

### Review Process for Human
1. TCC creates PR with summary above
2. Open PR in browser
3. Click "Files changed" tab - see every diff
4. If it looks right → Approve → Merge
5. If something's wrong → Comment → TCC or OCC fixes

### Extra Safety (Optional)
You can review locally before approving:
```bash
git fetch origin
git diff main...origin/claude/branch-name
```

---

## Session Start Checklist

1. Read this file (you just did)
2. Check `docs/BOARD.md` for current status
3. Identify which repository you're in
4. Acknowledge your role (OCC or TCC)

---

## Pattern Propagation Rule

When fixing ANY pattern (paths, APIs, configs):
1. `grep -rn "<pattern>" .` to find ALL instances
2. Fix ALL occurrences, not just the one encountered
3. If pattern came from AIM init, fix the SOURCE TEMPLATE

### Common Patterns to Check:
- Hardcoded paths: `/home/user`, `/Users/`, `/Volumes/`
- Hardcoded project names in templates
- Absolute paths that should be relative

### Standard Path Detection (use in ALL shell scripts):
```bash
# Use relative paths - detect repo root from script location
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
```

---

**If you don't follow these rules, you're wasting the user's time.**
