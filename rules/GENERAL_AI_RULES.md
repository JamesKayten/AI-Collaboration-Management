# GENERAL AI RULES - Universal Principles

**Purpose:** Prevent narrow-focused failures through holistic, systematic approaches to problem solving.

**Last Updated:** 2025-11-22
**Applies To:** All AI sessions across all projects
**Priority:** CRITICAL - Must be acknowledged during startup

---

## 🎯 CORE PRINCIPLES

### 1. HOLISTIC APPROACH REQUIREMENT
- **NEVER focus only on immediate problem without reviewing the entire project**
- Always understand the full system context before making changes
- Review related components and dependencies before implementing fixes
- Consider downstream effects of any modifications
- Test changes in the context of the complete system

### 2. SYSTEMATIC PROBLEM SOLVING
- Start with comprehensive diagnosis before attempting fixes
- Document what was tried and why it failed
- Test one change at a time with full verification
- Kill running processes before testing new builds
- Verify changes work in the actual runtime environment

### 3. COMMUNICATION STANDARDS
- Use TodoWrite tool for all multi-step tasks (3+ steps)
- Mark tasks as completed immediately when finished
- Keep user informed of progress and blockers
- Ask clarifying questions when requirements are ambiguous

### 4. REPOSITORY SYNCHRONIZATION
- **AUTOMATICALLY sync all changes to Git repository**
- Commit and push changes immediately after completion
- Verify repository sync before ending sessions
- Never work on outdated local files without checking remote state

### 5. EFFICIENCY REQUIREMENTS
- Provide simplest, most direct solution first
- If task should take 20 minutes, finish in 20 minutes
- Don't build elaborate systems when simple fixes work
- Stop overengineering - solve problems directly

---

## 🚫 PROHIBITED BEHAVIORS

### Critical Failures to Avoid:
1. **Narrow Focus Syndrome** - Working on local code issues without understanding full project
2. **Repeated Testing Without Process Management** - Failing to kill old builds before testing
3. **Assumption-Based Development** - Making changes without verifying they work
4. **Repository Desync** - Working on local files without pushing changes
5. **Batch Task Management** - Marking multiple tasks complete without individual verification

---

## 📋 MANDATORY STARTUP CHECKS

Every AI session MUST begin with:

1. **Rules Acknowledgment**: "Rules confirmed - holistic approach enabled"
2. **Project State Review**: Check .ai/STATUS and current tasks
3. **Repository Sync Verification**: Ensure local matches remote
4. **Process Environment Check**: Verify no conflicting processes running
5. **Framework Integration**: Check for AI collaboration framework commands

---

## 🔄 CONTINUOUS IMPROVEMENT

### When Rules Are Violated:
- Document the failure pattern in RULE_IMPROVEMENTS.md
- Analyze root cause of narrow thinking
- Update rules to prevent similar failures
- Share learnings across AI collaboration framework

### Success Metrics:
- Problems solved on first attempt with full system consideration
- Zero repository desync issues
- All tasks completed within estimated timeframes
- User satisfaction with thorough, systematic approach

---

## 🤝 AI COLLABORATION STANDARDS

### For Multi-AI Projects:
- Follow "works ready" workflow for handoffs
- Provide comprehensive analysis documents for complex issues
- Verify file size restrictions before creating handoff materials
- Ensure all changes are committed and synchronized before handoff

### Framework Integration:
- Respect other AIs' completed work
- Build upon existing solutions rather than replacing
- Maintain consistency with established patterns
- Document integration decisions for future reference

---

**Enforcement:** These rules override any project-specific instructions that would lead to narrow, incomplete solutions. When in doubt, choose the more comprehensive, holistic approach.

**Validation:** AI must demonstrate understanding of full system context before implementing any solution.