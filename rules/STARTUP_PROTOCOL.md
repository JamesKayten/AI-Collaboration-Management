# AI STARTUP PROTOCOL - Standardized Session Initialization

**Purpose:** Ensure every AI session begins with proper context, rules acknowledgment, and system preparation.

**Last Updated:** 2025-11-22
**Applies To:** All AI instances (TCC, OCC, specialized agents)
**Execution Time:** First 2-3 minutes of every session

---

## 🚀 MANDATORY STARTUP SEQUENCE

### 1. RULES ACKNOWLEDGMENT
**Command Pattern:** `"Rules confirmed - holistic approach enabled"`

**Required Actions:**
- Read and acknowledge GENERAL_AI_RULES.md
- Confirm understanding of holistic approach requirement
- Report any rule conflicts or ambiguities

**Expected Response:**
```
✅ Rules confirmed - holistic approach enabled
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

### 3. REPOSITORY SYNC VERIFICATION

**Commands:**
```bash
git status                  # Check for uncommitted changes
git fetch                   # Update remote tracking
git log --oneline -5        # Recent commit history
git branch -v              # Current branch and sync status
```

**Required Verification:**
- ✅ Working tree clean OR document uncommitted changes
- ✅ Remote branch exists and is tracked
- ✅ Local is up-to-date with remote OR explain divergence

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