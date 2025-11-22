# AI STARTUP PROTOCOL - Standardized Session Initialization

**Purpose:** Ensure every AI session begins with proper context, rules acknowledgment, and system preparation.

**Last Updated:** 2025-11-22
**Applies To:** All AI instances (TCC, OCC, specialized agents)
**Execution Time:** First 2-3 minutes of every session

---

## 🚀 MANDATORY STARTUP SEQUENCE

### 0. SESSION CONTINUITY CHECK (FIRST - Before anything else)

**REQUIRED COMMANDS:**
```bash
source .ai-framework/scripts/session-logging.sh
check_incomplete_session
```

**Purpose:** Check for incomplete session from today (disconnection recovery)

**If incomplete session found:**
```bash
get_last_state 50  # Show last 50 lines of session log
```

**Then ask user:**
"Incomplete session detected. Options:
1. Resume from last checkpoint
2. View full log
3. Start fresh

Which would you like?"

**If no incomplete session:** Proceed to step 1

---

### 1. RULES ACKNOWLEDGMENT
**Command Pattern:** `"Rules confirmed - holistic approach enabled"`

**Required Actions:**
- Read and acknowledge GENERAL_AI_RULES.md (VERIFICATION-FIRST section)
- Read and acknowledge REPOSITORY_SYNC_PROTOCOL.md
- Confirm understanding of mandatory verification requirements
- Report any rule conflicts or ambiguities

**Expected Response:**
```
✅ Rules confirmed - holistic approach enabled
✅ Verification-first protocol acknowledged
📋 Startup protocol: [PROJECT_NAME] - [STATUS]
```

---

### 2. PROJECT CONTEXT DISCOVERY

#### A. Identify Current Project
**Commands:**
```bash
pwd                          # Current directory
ls -la                      # Directory structure
ls .ai/                     # Check for AI framework files
```

#### B. Check Project Status (if .ai/ exists)
**Commands:**
```bash
cat .ai/STATUS              # Current task state
cat .ai/CURRENT_TASK.md     # Task details
cat .ai/communication.log   # Recent AI activity
```

#### C. Natural Language Commands (if available)
**Commands:**
```bash
cat .ai/NATURAL_LANGUAGE_COMMANDS.md  # Check available shortcuts
```
- Use `check the board` for quick status overview
- Use `works ready` for OCC collaboration workflow

---

### 3. REPOSITORY SYNC VERIFICATION (MANDATORY SCRIPT EXECUTION)

**REQUIRED COMMAND:**
```bash
bash .ai-framework/scripts/pre-work-sync.sh
```

**MUST SHOW COMPLETE OUTPUT** including:
- All verification steps (1-8)
- Final status: "PRE-WORK SYNC COMPLETE"
- Sync status: SYNCED or NEW_BRANCH
- Commit hash

**Example Required Output:**
```
$ bash .ai-framework/scripts/pre-work-sync.sh
==========================================
PRE-WORK SYNC PROTOCOL
==========================================

Step 1: Verifying git repository...
✅ Git repository confirmed

Step 2: Checking current status...
On branch main
Your branch is up to date with 'origin/main'.

...
[FULL OUTPUT REQUIRED]
...

==========================================
PRE-WORK SYNC COMPLETE
==========================================
Status: ✅ SUCCESS
```

**NON-COMPLIANCE:**
- ❌ Saying "I synced the repository" without showing script output
- ❌ Running script but not showing complete output
- ❌ Skipping sync because "I'll do it later"

**BLOCKING RULE:**
If pre-work-sync.sh fails, TCC/OCC CANNOT proceed with work.
Must show error and request user intervention.

---

### 4. PROCESS ENVIRONMENT CHECK

**Commands:**
```bash
lsof -ti:8000              # Check backend port
lsof -ti:8080              # Check frontend port
ps aux | grep -E "(python3|SimpleCP)" | grep -v grep  # Check running processes
```

**Actions:**
- Kill conflicting processes if found
- Document any persistent services
- Prepare clean testing environment

---

### 5. PROJECT-SPECIFIC RULES INTEGRATION

**Check for Local Rules:**
```bash
cat .ai/PROJECT_RULES.md    # Project-specific overrides
```

**Integration Logic:**
- GENERAL_AI_RULES.md = Base requirements (cannot be overridden)
- PROJECT_RULES.md = Additional or more specific requirements
- Conflicts resolved in favor of more restrictive/comprehensive approach

---

## 🔧 FRAMEWORK INTEGRATION PROTOCOLS

### For AI Collaboration Projects:

#### OCC Startup (Online Claude Code):
1. Execute standard startup sequence
2. Check for pending OCC tasks: `cat .ai/STATUS | grep "ASSIGNED_TO=OCC"`
3. If tasks found, load task details and begin execution
4. Use "works ready" workflow for TCC integration

#### TCC Startup (Terminal Claude Code):
1. Execute standard startup sequence
2. Check for OCC completed work: `cat .ai/communication.log`
3. Verify file size restrictions on any new OCC files
4. Execute merge workflow if OCC work is ready

#### Specialized Agents:
1. Execute relevant portions of startup sequence based on agent scope
2. Report specialized capabilities and limitations
3. Coordinate with primary AI if collaborative work detected

---

## 📊 SUCCESS INDICATORS

### Startup Complete Checklist:
- [ ] Rules confirmed and acknowledged
- [ ] Project context understood (structure, purpose, current state)
- [ ] Repository sync verified and documented
- [ ] Process environment prepared
- [ ] Project-specific rules integrated
- [ ] Framework collaboration protocols activated (if applicable)

### Startup Report Template:
```
✅ Rules confirmed - holistic approach enabled
📂 Project: [PROJECT_NAME] ([TYPE]: Frontend/Backend/Full-Stack/Framework)
📊 Status: [IDLE/PENDING/IN_PROGRESS/BLOCKED]
🔄 Repository: [SYNCED/NEEDS_PUSH/DIVERGED] - [BRANCH_NAME]
🎯 Ready to: [PRIMARY_CAPABILITY_SUMMARY]
```

---

## 🚫 STARTUP FAILURES

### Common Issues and Resolutions:

#### 1. Rules Not Found
- **Symptom:** Cannot locate GENERAL_AI_RULES.md
- **Action:** Report to user, request framework update
- **Fallback:** Proceed with basic holistic principles

#### 2. Repository Desync
- **Symptom:** Local changes not pushed, remote ahead
- **Action:** Document state, ask user for merge/pull strategy
- **Never:** Assume and auto-merge without confirmation

#### 3. Process Conflicts
- **Symptom:** Ports occupied, processes running
- **Action:** Identify processes, get permission before killing
- **Safety:** Never force-kill unknown processes

#### 4. Framework Conflicts
- **Symptom:** Multiple AIs trying to work simultaneously
- **Action:** Coordinate through communication.log, establish priority
- **Protocol:** Newer AI defers to AI already in progress

---

## 🔄 CONTINUOUS IMPROVEMENT

### Startup Metrics to Track:
- Time to complete startup sequence
- Number of issues found and resolved
- User satisfaction with preparedness
- Success rate of first-attempt problem solving

### Improvement Process:
1. Document startup issues in RULE_IMPROVEMENTS.md
2. Update protocol based on common failure patterns
3. Share improvements across framework
4. Validate changes don't break existing workflows

---

**Validation:** Every AI must demonstrate completed startup protocol before beginning substantive work. Users should see clear evidence of systematic preparation.