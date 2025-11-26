---
description: TCC validates, merges to main, and updates local files
aliases: ["Works Ready", "works ready", "validate", "merge"]
---

You are TCC. Complete ALL steps below. Do not skip any.

## Step 1: Validate OCC's Branch

```bash
git fetch origin
git checkout <occ-branch>
# Run validation: tests, linters, build checks
```

If validation fails → stop and post issues to BOARD.md for OCC.

## Step 2: Merge to Main

```bash
git checkout main
git merge <occ-branch>
git push origin main
```

Record the **commit hash** - you'll need it for the board.

## Step 3: Delete Merged Branch (MANDATORY)

**YOU MUST DO THIS. DO NOT SKIP.**

```bash
git push origin --delete <occ-branch>
git branch -D <occ-branch>
```

Also clear the pending file so branch watcher stops alerting:

```bash
rm -f /tmp/branch-watcher-*.pending
```

Failure to delete branches breaks the workflow. Do it now.

## Step 4: Update BOARD.md

Add a ✅ COMPLETED section:

```markdown
### ✅ COMPLETED: [Task name]
**Completed by:** TCC on [date]
**Commit:** `[hash]` (merged to main)
**What was done:**
- ✅ [what was merged]
- ✅ [any other actions]
```

## Step 5: Sync Local & Push

```bash
git pull origin main          # Sync local files for OCC testing
git add docs/BOARD.md
git commit -m "Update board - [task] complete"
git push origin main
```

---

## MANDATORY CHECKLIST

Before ending session, confirm ALL:

- [ ] Branch validated and merged to main
- [ ] Commit hash recorded
- [ ] Merged branch deleted from GitHub
- [ ] BOARD.md updated with ✅ COMPLETED section
- [ ] Local repo synced (`git pull origin main`)
- [ ] Board changes committed and pushed

**Do not close session until all boxes are checked.**

---

## Report Format

```
✅ MERGE COMPLETE
- Branch: [branch name] (deleted)
- Commit: [hash]
- Board: Updated with completion record
- Local: Synced with remote
- Status: Ready for OCC testing
```
