# Repository Sync Protocol (MANDATORY)

**This protocol is REQUIRED before and after any repository work.**

**Last Updated:** 2025-11-22
**Applies To:** All AI agents (TCC, OCC)
**Priority:** CRITICAL - Blocks work if not executed

---

## 🚨 WHY THIS EXISTS

TCC repeatedly fails to sync repositories despite claiming to do so. This protocol **replaces vague sync instructions** with **executable scripts that provide verification**.

### The Problem

❌ **Old approach (doesn't work):**
```
Rule: "Always sync the local repository with GitHub"
Result: TCC says "I synced it" but didn't actually sync
```

✅ **New approach (works):**
```
Rule: "Execute bash .ai-framework/scripts/pre-work-sync.sh and show output"
Result: TCC must run script and cannot claim success without showing proof
```

---

## 📋 MANDATORY PROTOCOL STEPS

### Protocol 1: Pre-Work Sync (BEFORE any work)

**COMMAND:**
```bash
bash .ai-framework/scripts/pre-work-sync.sh
```

**WHEN TO RUN:**
- At the start of every work session
- Before reading any files for work
- Before making any changes to the repository
- After long periods of inactivity

**WHAT IT DOES:**
1. Verifies you're in a git repository
2. Checks for uncommitted changes (blocks if found)
3. Fetches from remote
4. Pulls latest changes
5. Verifies local matches remote
6. Logs sync completion

**REQUIRED OUTPUT:**
TCC/OCC MUST show the complete output including:
- All step confirmations (✅)
- Final sync status
- Commit hash verification

**FAILURE HANDLING:**
If script exits with error:
- DO NOT proceed with work
- Show the error message
- Report to user: "Pre-work sync failed - cannot proceed"
- Wait for user guidance

---

### Protocol 2: Post-Work Sync (AFTER completing work)

**COMMAND:**
```bash
bash .ai-framework/scripts/post-work-sync.sh "Description of work completed"
```

**WHEN TO RUN:**
- After completing any task
- Before ending a work session
- After making any file changes
- Before claiming task is "done"

**WHAT IT DOES:**
1. Stages all changes (`git add -A`)
2. Shows what files were changed
3. Commits with provided message
4. Pushes to remote branch
5. Verifies push succeeded
6. Logs sync completion

**REQUIRED OUTPUT:**
TCC/OCC MUST show the complete output including:
- List of staged files
- Commit confirmation
- Push confirmation
- Verification that local matches remote

**FAILURE HANDLING:**
If script exits with error:
- DO NOT claim work is complete
- Show the error message
- Report to user: "Post-work sync failed - work not pushed"
- Retry or request user intervention

---

## 🔄 SESSION CONTINUITY PROTOCOL

### For Uninterrupted Work Sessions

**SETUP (at start of session):**
```bash
source .ai-framework/scripts/session-logging.sh
init_session_log "TCC" "Task description here"
```

**DURING WORK (log every significant action):**
```bash
log_progress "Action Title" "What you're doing"
```

**CHECKPOINTS (every milestone):**
```bash
checkpoint "What you just completed"
```

**RECOVERY (after disconnection):**
```bash
source .ai-framework/scripts/session-logging.sh
check_incomplete_session
get_last_state
```

---

## 📖 USAGE EXAMPLES

### Example 1: Starting Work on Repository Cleanup

```bash
# Step 1: Sync before work
$ bash .ai-framework/scripts/pre-work-sync.sh
==========================================
PRE-WORK SYNC PROTOCOL
==========================================
...
✅ SYNC SUCCESS: Local matches remote
Commit: abc123

# Step 2: Initialize session logging
$ source .ai-framework/scripts/session-logging.sh
$ init_session_log "TCC" "Clean up root directory"
✅ Session log initialized

# Step 3: Do work with progress logging
$ log_progress "Moving Files" "Moving FAQ.md to docs/guides/"
$ git mv FAQ.md docs/guides/FAQ.md
$ checkpoint "Moved FAQ.md to docs/guides/"
✅ Checkpoint created

$ log_progress "Moving Files" "Moving GETTING_STARTED.md to docs/guides/"
$ git mv GETTING_STARTED.md docs/guides/GETTING_STARTED.md
$ checkpoint "Moved GETTING_STARTED.md to docs/guides/"
✅ Checkpoint created

# Step 4: Sync after work
$ bash .ai-framework/scripts/post-work-sync.sh "Cleaned up root directory - moved docs to guides/"
==========================================
POST-WORK SYNC COMPLETE
==========================================
✅ SUCCESS
```

### Example 2: Recovering After Disconnection

```bash
# Step 1: Check for incomplete session
$ source .ai-framework/scripts/session-logging.sh
$ check_incomplete_session
🔄 Detected session log from today: 2025-11-22

Last 10 actions:
### 14:30:45 - Checkpoint
**Status:** Moved FAQ.md to docs/guides/

### 14:31:12 - Moving Files
Moving GETTING_STARTED.md to docs/guides/

*DISCONNECTION HAPPENED HERE*

# Step 2: Review last state
$ get_last_state 30
[Shows last 30 lines of log]

# Step 3: Resume work
$ log_progress "Resuming Work" "Continuing from GETTING_STARTED.md move"
# Continue where you left off...
```

---

## 🚫 WHAT NOT TO DO

### ❌ DON'T: Claim sync without running script
```
"I synced the repository"  ← NO PROOF
```

### ❌ DON'T: Run script but not show output
```
"I ran the sync script"  ← NO VERIFICATION
```

### ❌ DON'T: Work without pre-sync
```
"I'll sync later" ← WRONG, sync FIRST
```

### ❌ DON'T: Skip post-sync after changes
```
"Changes made but not pushed yet" ← INCOMPLETE
```

### ✅ DO: Always run scripts and show output
```
$ bash .ai-framework/scripts/pre-work-sync.sh
[FULL OUTPUT SHOWN]
✅ Repository is ready for work
```

---

## 🎯 SUCCESS CRITERIA

A sync is ONLY successful when:

**Pre-Work Sync:**
- [ ] Script executed: `bash .ai-framework/scripts/pre-work-sync.sh`
- [ ] Complete output shown in conversation
- [ ] Final message: "PRE-WORK SYNC COMPLETE"
- [ ] Status: ✅ SUCCESS
- [ ] Sync Status: SYNCED or NEW_BRANCH

**Post-Work Sync:**
- [ ] Script executed: `bash .ai-framework/scripts/post-work-sync.sh "message"`
- [ ] Complete output shown in conversation
- [ ] Staged files listed
- [ ] Commit confirmed
- [ ] Push confirmed
- [ ] Final message: "POST-WORK SYNC COMPLETE"
- [ ] Status: ✅ SUCCESS

**Session Logging:**
- [ ] Session initialized with `init_session_log`
- [ ] Progress logged with `log_progress` for each significant action
- [ ] Checkpoints created with `checkpoint` at milestones
- [ ] Session log file exists in `.ai-framework/session-logs/`

---

## 🔧 SCRIPT LOCATIONS

All scripts are in `.ai-framework/scripts/`:

```
.ai-framework/scripts/
├── pre-work-sync.sh         ← MANDATORY before work
├── post-work-sync.sh        ← MANDATORY after work
└── session-logging.sh       ← For continuity across disconnections
```

All logs are in `.ai-framework/logs/` and `.ai-framework/session-logs/`:

```
.ai-framework/
├── logs/
│   └── sync.log             ← Sync history
└── session-logs/
    └── SESSION_LOG_*.md     ← Daily session logs
```

---

## 📞 ENFORCEMENT

**This is NOT optional. This is MANDATORY.**

- If TCC/OCC doesn't run these scripts: **RULE VIOLATION**
- If TCC/OCC doesn't show output: **RULE VIOLATION**
- If TCC/OCC claims sync without proof: **RULE VIOLATION**

**Consequences:**
- Work is considered INCOMPLETE
- User will request re-execution with verification
- Repeat violations indicate systemic failure requiring framework redesign

---

## 🎓 REMEMBER

**Scripts over instructions.**
**Verification over claims.**
**Proof over promises.**

If you can't show the output, you didn't do the work.

---

**Last Updated:** 2025-11-22
**Status:** ACTIVE - MANDATORY FOR ALL REPOSITORY WORK
