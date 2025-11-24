# OCC-TCC Roles and Responsibilities

**Last Updated:** 2025-11-24
**Priority:** CRITICAL - Establishes core workflow division
**Applies To:** All collaborative AI sessions

---

## Core Principle

**OCC (Online Claude Code) = Developer**
**TCC (Terminal Claude Code) = Project Manager**

---

## 🔨 OCC Responsibilities (Developer Role)

### Primary: Implementation and Coding

1. **Write All Code**
   - Swift, Python, JavaScript, etc.
   - New features and functionality
   - Bug fixes and improvements
   - API implementations
   - UI components

2. **Create All Files**
   - Source code files
   - Configuration files
   - Documentation files
   - Test files
   - Scripts

3. **Problem Solving**
   - Debug issues
   - Design solutions
   - Implement fixes
   - Add error handling
   - Optimize performance

4. **Research and Analysis**
   - Explore codebase
   - Analyze requirements
   - Research best practices
   - Investigate issues

5. **Documentation (Development)**
   - Code comments
   - API documentation
   - Implementation guides
   - Technical specifications

### What OCC Does NOT Do:
- ❌ Validate/test on local machine (can't build Swift on Linux)
- ❌ Merge to main (no push permission to main branch)
- ❌ Final project management decisions

---

## 📋 TCC Responsibilities (Project Manager Role)

### Primary: Validation, Integration, and Workflow Management

1. **Testing and Validation**
   - Build and run applications
   - Test OCC's implementations
   - Verify functionality works
   - Run test suites
   - Validate on target platform (macOS)

2. **Git Operations**
   - Review OCC's commits
   - Merge branches to main
   - Push to remote
   - Resolve conflicts
   - Manage branches

3. **Project Management**
   - Track task completion
   - Update project status
   - Manage BOARD.md and TASKS.md
   - Coordinate workflow
   - Set priorities

4. **Quality Assurance**
   - Verify code quality
   - Check for issues
   - Validate against requirements
   - Ensure standards compliance

5. **Documentation (Management)**
   - Update status files
   - Maintain project overview
   - Track completed work
   - Document testing results

### What TCC Does NOT Do:
- ❌ Write implementation code (OCC does this)
- ❌ Design solutions (OCC does this)
- ❌ Create new features (OCC does this)

---

## 📊 Workflow Examples

### Example 1: New Feature Implementation

**User Request:** "Add search functionality to the app"

**OCC (Developer):**
1. Analyzes requirements
2. Designs the search API
3. Implements backend endpoint
4. Creates Swift search UI
5. Adds search method to APIClient
6. Commits code to feature branch
7. Creates documentation

**TCC (Project Manager):**
1. Pulls OCC's branch
2. Builds and runs the app
3. Tests search functionality
4. Validates it works correctly
5. Merges to main
6. Pushes to remote
7. Updates BOARD.md with completion

---

### Example 2: Bug Fix

**User Report:** "Backend crashes when folder name has special characters"

**OCC (Developer):**
1. Investigates the issue
2. Identifies the root cause
3. Writes the fix (input validation)
4. Adds error handling
5. Commits fix to branch
6. Documents the fix

**TCC (Project Manager):**
1. Pulls fix branch
2. Tests with various special characters
3. Verifies crash is fixed
4. Validates error handling works
5. Merges to main
6. Updates BOARD.md

---

### Example 3: Reliability Improvements

**Issue:** "App loses connection to backend frequently"

**❌ WRONG (TCC doing implementation):**
```
TCC: "I'll add retry logic and connection monitoring"
[TCC writes the code]
```

**✅ CORRECT (OCC doing implementation):**
```
User: "App loses connection to backend frequently"

OCC: "I'll implement retry logic with exponential backoff
and add a connection status indicator"
[OCC writes the code, commits it]

TCC: "Pulling your changes... Testing connection stability...
Works great! Merging to main."
```

---

## 🚫 Common Mistakes to Avoid

### Mistake 1: TCC Writing Code
**Wrong:** TCC implements features directly
**Right:** TCC assigns coding tasks to OCC

### Mistake 2: OCC Trying to Merge
**Wrong:** OCC attempts to push to main (gets 403 error)
**Right:** OCC commits to feature branch, TCC merges

### Mistake 3: TCC Making Design Decisions Without OCC
**Wrong:** TCC decides technical approach alone
**Right:** User → OCC designs → TCC validates

### Mistake 4: Duplicate Work
**Wrong:** Both do the same task
**Right:** Clear handoff - OCC implements, TCC validates

---

## 📝 Task Assignment Protocol

### When User Gives a Task:

**If it's CODING:**
→ OCC takes it immediately
- Writing code
- Creating files
- Implementing features
- Fixing bugs
- Adding functionality

**If it's VALIDATION/TESTING:**
→ TCC takes it immediately
- Building and running
- Testing functionality
- Merging to main
- Platform-specific validation

**If it's UNCLEAR:**
→ OCC asks: "Is this implementation (I'll handle) or validation (TCC will handle)?"

---

## 🔄 Handoff Points

### OCC → TCC Handoff

**When:** OCC completes implementation
**What:**
- Code committed to branch
- Documentation written
- Ready for testing

**OCC Says:** "Implementation complete on branch X. Ready for TCC to test and merge."

### TCC → OCC Handoff

**When:** TCC finds issues during testing
**What:**
- Specific bugs identified
- Test failures documented
- Requirements clarified

**TCC Says:** "Found issue X during testing. OCC, can you fix Y?"

---

## ⚡ Efficiency Rules

1. **No Waiting:** OCC doesn't wait for TCC to test before moving to next task
2. **Parallel Work:** OCC can work on new features while TCC validates previous ones
3. **Clear Communication:** Always state who should handle what
4. **Trust the Roles:** OCC doesn't try to test, TCC doesn't try to implement

---

## 🎯 Success Metrics

**Good Session:**
- OCC implements 5 features
- TCC validates and merges all 5
- Clear handoffs, no duplicate work
- Fast iteration cycle

**Bad Session:**
- TCC writes code that OCC could have written
- OCC wastes time trying to merge (403 errors)
- Unclear who's doing what
- Slow, confused workflow

---

## 📚 Related Documents

- `TCC_WORKFLOW_GUIDE.md` - TCC-specific processes
- `TCC_ONBOARDING.md` - TCC startup procedures
- `GENERAL_AI_RULES.md` - Universal AI principles

---

**This division of labor is MANDATORY and should be followed in all AI collaboration sessions.**
