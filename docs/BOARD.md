# BOARD - AI-Collaboration-Management

**Last Updated:** 2025-11-26 19:30 PST

---

## Tasks FOR OCC (TCC writes here, OCC reads)

### 🔴 CRITICAL BUG: TCC Role Awareness Broken

**Repository:** AI-Collaboration-Management
**Date:** 2025-11-26
**Time spent:** 6+ hours debugging
**Status:** UNRESOLVED

#### Problem
TCC sessions do not acknowledge their role. Claude starts blank, doesn't identify as TCC, doesn't check the board, doesn't act on pending branches.

#### What Was Tried (ALL FAILED)

1. **Session-start hook with plain text echo statements**
   - Hook at `.claude/hooks/session-start.sh`
   - Outputs sync status, board contents, TCC directive
   - Hook executes (terminal shows output) but Claude doesn't receive/acknowledge it
   - Suspected cause: Claude Code bug where SessionStart hook stdout is discarded

2. **Session-start hook with JSON additionalContext format**
   - Rewrote hook to output JSON: `{"hookSpecificOutput": {"additionalContext": "..."}}`
   - Based on research suggesting this format injects context into Claude
   - Also failed - Claude still doesn't receive hook output

3. **Added explicit TCC role to CLAUDE.md**
   - Added "## YOUR ROLE: TCC" section at top of CLAUDE.md
   - Says "You ARE TCC. Not OCC."
   - Includes directive to identify on session start
   - Merged to main (commit 426e1dd)
   - **Still doesn't work** - Claude ignores it

4. **Restored old hook from backup repo**
   - Copied `.claude/hooks/session-start.sh` from AI-Collaboration-Management-OLD
   - No improvement

#### Files Modified During Debugging
- `.claude/hooks/session-start.sh` - Multiple rewrites (JSON format, plain text)
- `CLAUDE.md` - Added TCC role section
- `.claude/commands/works-ready.md` - Strengthened branch deletion mandate
- `scripts/watch-branches.sh` - Disabled voice alerts

#### Environment Details
- User's Mac: macOS with iTerm2
- This debugging session: Linux container (NOT user's Mac)
- Claude Code version: Unknown
- Hooks configured in `.claude/settings.json`

#### Suspected Root Cause
Claude Code has a known bug (GitHub issue #12151) where SessionStart hook output is not passed to Claude's context. The hook runs, produces output, but stdout is silently discarded.

CLAUDE.md should work independently of hooks, but Claude still isn't reading/following the TCC role directive in CLAUDE.md. Unknown why.

#### What Might Work (Untested)
1. Different Claude Code version
2. Different hook event type (not SessionStart)
3. User manually typing "You are TCC" at session start
4. Completely different approach to role assignment

#### Files to Check
- `/home/user/AI-Collaboration-Management/CLAUDE.md` - Has TCC role section
- `/home/user/AI-Collaboration-Management/.claude/settings.json` - Hook config
- `/home/user/AI-Collaboration-Management/.claude/hooks/session-start.sh` - Current hook
- User's backup: `~/Documents/AI-Collaboration-Management-OLD/` - Working version from earlier

---

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

_None pending_

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

### ✅ COMPLETED: Disable voice alerts in watch-branches.sh (via /works-ready)
**Completed by:** TCC on 2025-11-26
**Commit:** `f03a90c` (merged to main)
**What was done:**
- ✅ Validated OCC branch claude/inspect-repo-issues-01FrvBsm4pqG8Zp6Nov3qAK1
- ✅ Successfully merged voice alert disable changes to main
- ✅ Disabled macOS `say` command voice notifications in watch-branches.sh
- ✅ Preserved sound alerts (Hero.aiff) for TCC notifications
- ✅ Deleted merged branch from origin and locally (per CLAUDE.md mandate)
- ✅ Updated BOARD.md with completion record

**Repository:** AI-Collaboration-Management main branch synchronized ✓

---

### ✅ COMPLETED: Restore working scripts from v3.1-workflow-tested
**Completed by:** TCC on 2025-11-26
**Commit:** `04c56cf` (merged to main)
**What was done:**
- ✅ Merged branch claude/add-branch-cleanup-mandate-01UMTXzkXSBRAKb8igQkYhcn (restoration commit)
- ✅ Restored working session-start.sh hook (removed broken auto-role detection)
- ✅ Restored voice alerts in watch-branches.sh (TCC notifications for OCC pushes)
- ✅ Deleted merged branch from origin and locally (per CLAUDE.md mandate)
- ✅ Updated BOARD.md with completion record

**Repository:** AI-Collaboration-Management main branch synchronized ✓

---

### ✅ COMPLETED: Merge branch cleanup mandate fix
**Completed by:** TCC on 2025-11-26
**Commit:** `48ddcaf` (merged to main)
**What was done:**
- ✅ Merged branch claude/add-branch-cleanup-mandate-01UMTXzkXSBRAKb8igQkYhcn
- ✅ Fixed syntax error in watch-branches.sh script (empty if block)
- ✅ Deleted merged branch from origin and locally (per CLAUDE.md mandate)
- ✅ Updated BOARD.md with completion record

**Repository:** AI-Collaboration-Management main branch synchronized ✓

---

### ✅ COMPLETED: Merge workflow test #3 (via /works-ready)
**Completed by:** TCC on 2025-11-26
**Commit:** `a6f34c7` (merged to main)
**What was done:**
- ✅ Validated OCC branch claude/workflow-test3-01VveR6bBWQUtBwZSTkoXWuD
- ✅ Successfully merged final workflow reliability test to main
- ✅ Deleted merged branch from origin and locally
- ✅ Confirmed OCC→TCC workflow automation is fully reliable across multiple tests

**Repository:** AI-Collaboration-Management main branch synchronized ✓

---

### ✅ COMPLETED: Merge workflow test #2 (via /works-ready)
**Completed by:** TCC on 2025-11-26
**Commit:** `dff2e05` (merged to main)
**What was done:**
- ✅ Validated OCC branch claude/workflow-test2-01VveR6bBWQUtBwZSTkoXWuD
- ✅ Successfully merged workflow reliability test #2 to main
- ✅ Deleted merged branch from origin and locally
- ✅ Confirmed OCC→TCC workflow automation remains reliable

**Repository:** AI-Collaboration-Management main branch synchronized ✓

---

### ✅ COMPLETED: Merge workflow test (via /works-ready)
**Completed by:** TCC on 2025-11-26
**Commit:** `96ad416` (merged to main)
**What was done:**
- ✅ Validated OCC branch claude/workflow-test-01VveR6bBWQUtBwZSTkoXWuD
- ✅ Successfully merged workflow test documentation to main
- ✅ Deleted merged branch from origin and locally
- ✅ Verified OCC→TCC workflow automation functioning correctly

**Repository:** AI-Collaboration-Management main branch synchronized ✓

---

### ✅ COMPLETED: Merge TCC auto-alerts and workflow improvements
**Completed by:** TCC on 2025-11-26
**Commit:** `fc5bbf6` (merged to main)
**What was done:**
- ✅ Merged final commits from claude/ai-collaboration-setup-01VveR6bBWQUtBwZSTkoXWuD
- ✅ Added TCC auto-alert system for pending OCC branches (desktop + voice notifications)
- ✅ Enhanced /works-ready command with branch deletion step
- ✅ Removed unused PR watcher system and cleaned up aim-launcher.sh
- ✅ Streamlined watcher ecosystem to 3 core watchers: build, branches, board

**Repository:** AI-Collaboration-Management main branch synchronized ✓

---

### ✅ COMPLETED: Merge /works-ready command enhancements
**Completed by:** TCC on 2025-11-26
**Commit:** `bac7224` (merged to main)
**What was done:**
- ✅ Merged additional commits from claude/ai-collaboration-setup-01VveR6bBWQUtBwZSTkoXWuD
- ✅ Enhanced /works-ready command with mandatory checklist functionality
- ✅ Strengthened workflow validation in .claude/commands/works-ready.md
- ✅ Updated command structure for better project management

**Repository:** AI-Collaboration-Management main branch synchronized ✓

---

### ✅ COMPLETED: Merge AI collaboration setup cleanup
**Completed by:** TCC on 2025-11-26
**Commit:** `7beacf58` (merged to main)
**What was done:**
- ✅ Merged branch claude/ai-collaboration-setup-01VveR6bBWQUtBwZSTkoXWuD to main
- ✅ Removed 2,131 lines of deprecated scripts and validation tools
- ✅ Cleaned up old activation scripts, role enforcement, and test utilities
- ✅ Streamlined repository structure for better maintainability

**Repository:** AI-Collaboration-Management main branch synchronized ✓

---

### ✅ COMPLETED: Merge board watcher feature
**Completed by:** TCC on 2025-11-25
**Commit:** `93471cb` (already merged to main)
**What was done:**
- ✅ Merged branch claude/check-build-output-01QdQBFDw91Tyym9sJBmNf9Z to main
- ✅ Deployed updated CLAUDE.md and .claude/ to SimpleCP
- ✅ Created SimpleCP/docs/BOARD.md with queue format
- ✅ Updated AICM framework copy in SimpleCP
- ✅ Deleted abandoned branches

**SimpleCP commit:** `709b2e3` - Successfully deployed to SimpleCP main

---

### ✅ COMPLETED: Deploy AICM to SimpleCP
**Completed by:** TCC on 2025-11-24
**Commit:** `3e264de` (merged to SimpleCP main)
**What was done:**
- Merged AICM branch to main
- Deployed CLAUDE.md and .claude/ to SimpleCP root
- Created SimpleCP/docs/BOARD.md

**Next:** TCC should test the system by starting a fresh session in a local SimpleCP clone to verify hooks fire correctly.

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