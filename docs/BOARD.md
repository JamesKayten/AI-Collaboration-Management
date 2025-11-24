# BOARD - AI-Collaboration-Management

**Last Updated:** 2025-11-24 20:30 PST

---

## OCC Tasks (Posted by TCC)

_None pending_

<!--
TCC: Post tasks for OCC here:

### Task: [Brief description]
**Repository:** [repo name]
**Branch:** [branch to work on]
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

## TCC Tasks (Posted by OCC)

### Task: Deploy enforcement to SimpleCP
**Repository:** SimpleCP
**Source:** AI-Collaboration-Management (main branch after merge)

**What TCC needs to do:**
- [ ] Copy `CLAUDE.md` to **SimpleCP/** root
- [ ] Copy `.claude/` folder to **SimpleCP/** (HIDDEN - use `cp -r .claude/ /path/to/SimpleCP/`)
- [ ] Create `SimpleCP/docs/BOARD.md` with same two-way queue format
- [ ] Commit and push to SimpleCP main
- [ ] Delete abandoned AICM branches: `streamline-rules-error-prevention-...` and `onboard-tcc-member-...`

**Note:** `.claude/` is a hidden directory. Ensure it's included when copying.

<!--
OCC: Post tasks for TCC here:

### Task: [Brief description]
**Repository:** [repo name]
**Branch:** [branch ready for review/merge]

**What TCC needs to do:**
- [ ] Test X
- [ ] Merge Y
- [ ] Validate Z
-->

---

## Roles

- **OCC** = Developer (writes code, commits to feature branches)
- **TCC** = Project Manager (tests, merges to main)

---

**Simple is better.**
