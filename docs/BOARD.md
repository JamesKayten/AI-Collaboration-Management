# BOARD - AI-Collaboration-Management

**Last Updated:** 2025-11-24 21:00 PST

---

## Tasks FOR OCC (TCC writes here, OCC reads)

_None pending_

<!--
TCC: Post bug fixes, refactoring, and coding tasks here for OCC.

### Task: [Brief description]
**Repository:** [repo name]
**Files affected:**
- `path/to/file.swift`

**Issue found:**
[Error messages, test failures, what you observed]

**What OCC needs to do:**
- [ ] Fix X
- [ ] Update Y

**Logs:**
```
[paste error output]
```
-->

---

## Tasks FOR TCC (OCC writes here, TCC reads)

### Task: Re-merge latest commit, then deploy to SimpleCP
**Repository:** AI-Collaboration-Management → SimpleCP
**Branch:** `claude/check-build-output-01QdQBFDw91Tyym9sJBmNf9Z`

**Step 1 - Re-merge AICM branch:**
- [ ] Merge branch to main (ensure latest commits included)

**Step 2 - Deploy to SimpleCP root:**
- [ ] Copy `CLAUDE.md` to **SimpleCP/** root
- [ ] Copy `.claude/` folder to **SimpleCP/** (HIDDEN - use `cp -r .claude/ /path/to/SimpleCP/`)
- [ ] Create `SimpleCP/docs/BOARD.md` with same two-way queue format

**Step 3 - Update AICM framework copy inside SimpleCP:**
- [ ] Update the AICM framework that resides within SimpleCP with same changes

**Step 4 - Finalize:**
- [ ] Commit and push to SimpleCP main
- [ ] Delete abandoned AICM branches: `streamline-rules-error-prevention-...` and `onboard-tcc-member-...`

**Note:** `.claude/` is a hidden directory. Ensure it's included when copying.

<!--
OCC: Post merge requests, testing requests here for TCC.

### Task: [Brief description]
**Repository:** [repo name]
**Branch:** [branch ready for review/merge]

**What TCC needs to do:**
- [ ] Test X
- [ ] Merge Y
-->

---

## Roles

- **OCC** = Developer (writes code, commits to feature branches)
- **TCC** = Project Manager (tests, merges to main)

---

**Simple is better.**