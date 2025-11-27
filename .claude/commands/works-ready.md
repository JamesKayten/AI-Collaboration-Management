---
description: TCC validates, merges to main, and updates local files
aliases: ["Works Ready", "works ready", "validate", "merge"]
---

**EXECUTE IMMEDIATELY. DO NOT SHOW PLAN. DO NOT ASK. JUST DO IT.**

You are TCC. Complete ALL steps below without pausing or asking for confirmation.

## Step 1: Validate OCC's Branch

```bash
git fetch origin
git checkout <occ-branch>
```

### File Size Compliance Check (MANDATORY)

Run the file size compliance checker:

```bash
./scripts/tcc-file-compliance.sh main
```

**File Size Limits (lines per file):**
- Python (`.py`): 250 lines
- JavaScript/TypeScript (`.js`, `.ts`, `.jsx`, `.tsx`): 150 lines
- Java (`.java`): 400 lines
- Go/Swift (`.go`, `.swift`): 300 lines
- Markdown (`.md`): 500 lines
- Shell scripts (`.sh`): 200 lines
- YAML/JSON (`.yaml`, `.json`): 300 lines

**If ANY file exceeds limits:**
1. STOP - do not merge
2. Post violation report to BOARD.md for OCC
3. List each violation with file path and line count
4. Wait for OCC to fix and re-submit

### Other Validation
- Run tests if available: `npm test` or `make test`
- Check for linter errors
- Verify build passes

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

- [ ] File size compliance checked (no violations)
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
