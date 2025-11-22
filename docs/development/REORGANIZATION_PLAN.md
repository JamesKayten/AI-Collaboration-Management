# Repository Reorganization Plan

## Current State Analysis

**Total Markdown Files:** 110
**Major Issues:**
1. Multiple duplicate files in different locations
2. Disorganized root directory (30+ markdown files)
3. Inconsistent naming conventions
4. Overlapping documentation
5. Test reports in root directory

---

## Identified Duplicates

### 1. CHANGELOG.md (3 copies)
- `./CHANGELOG.md` (128 lines) - **KEEP** (most complete)
- `./docs/CHANGELOG.md` (85 lines) - DELETE
- `./.ai-framework/framework-docs/CHANGELOG.md` (85 lines) - DELETE

### 2. CONTRIBUTING.md (3 copies)
- `./CONTRIBUTING.md` (418 lines, has TCC) - **KEEP**
- `./docs/CONTRIBUTING.md` (166 lines) - DELETE
- `./.ai-framework/framework-docs/CONTRIBUTING.md` (166 lines) - DELETE

### 3. FAQ.md (3 copies)
- `./FAQ.md` (has TCC section) - **KEEP**
- `./docs/FAQ.md` - DELETE
- `./.ai-framework/framework-docs/FAQ.md` - DELETE

### 4. GETTING_STARTED.md (2 copies)
- `./GETTING_STARTED.md` (has TCC) - **KEEP**
- `./.ai-framework/framework-docs/GETTING_STARTED.md` - DELETE

### 5. TROUBLESHOOTING.md (2 copies)
- `./TROUBLESHOOTING.md` (has TCC) - **KEEP**
- `./.ai-framework/framework-docs/TROUBLESHOOTING.md` - DELETE

### 6. DEPLOYMENT_GUIDE.md (2 copies)
- `./docs/DEPLOYMENT_GUIDE.md` - **KEEP**
- `./.ai-framework/framework-docs/DEPLOYMENT_GUIDE.md` - DELETE

### 7. PROJECT_STATE.md (2 copies)
- `./PROJECT_STATE.md` - DELETE (old)
- `./.ai-framework/project-state/PROJECT_STATE.md` - **KEEP**

---

## Files to Consolidate

### Connection Retry Fixes (2 files → 1)
- `CONNECTION_RETRY_FIX.md` (consolidate)
- `QUICK_FIX_CONNECTION_RETRY.md` (consolidate)
- **New:** `docs/troubleshooting/CONNECTION_ISSUES.md`

### Quick Start Files (2 files → 1)
- `QUICK_START.md` (240 lines, comprehensive) - **KEEP**
- `QUICK_START_WORKFLOW.md` (182 lines, workflow-focused) - MERGE INTO QUICK_START.md

### OCC Documentation (2 files → 1)
- `OCC_ACTIVATION_CODE.md` (6.5K)
- `OCC_STANDARD_PROMPT.md` (6.4K)
- **New:** `docs/occ/OCC_GUIDE.md` (consolidated)

### Test Reports (2 files → move to tests/)
- `TEST_REPORT_20251119.md` → `tests/reports/TEST_REPORT_20251119.md`
- `TEST_SUCCESS_REPORT.md` → `tests/reports/TEST_SUCCESS_REPORT.md`

### AI Behavior Documentation (consolidate)
- `CLAUDE_BEHAVIOR_RULES.md` (2.3K)
- `rules/GENERAL_AI_RULES.md` (comprehensive)
- **Action:** Merge CLAUDE_BEHAVIOR_RULES.md into rules/GENERAL_AI_RULES.md

### TCC Documentation (reorganize for clarity)
Current TCC files:
- `tcc-setup/README_TCC_INSTALLATION.md`
- `tcc-setup/USER_GUIDE_TCC_INSTALLATION.md`
- `tcc-setup/INSTRUCTIONS_FOR_TCC.md`
- `tcc-setup/TCC_INTEGRATION_GUIDE.md`
- `tcc-setup/TCC_SETUP.md`
- `tcc-setup/tcc-config-files/TCC_INITIALIZATION_GUIDE.md`
- `tcc-setup/tcc-config-files/TCC_QUICK_START.md`
- `docs/TCC_MONITORING.md`
- `docs/TCC_PERIODIC_MONITORING.md`

**Consolidation:**
- Merge `README_TCC_INSTALLATION.md` + `USER_GUIDE_TCC_INSTALLATION.md` → `tcc-setup/INSTALLATION.md`
- Merge `TCC_MONITORING.md` + `TCC_PERIODIC_MONITORING.md` → `tcc-setup/MONITORING.md`
- Keep: `INSTRUCTIONS_FOR_TCC.md`, `TCC_INTEGRATION_GUIDE.md`, `install-tcc.sh`

---

## New Directory Structure

```
AI-Collaboration-Management/
├── README.md                           # Main entry point
├── QUICK_START.md                      # Quick start guide (consolidated)
├── GETTING_STARTED.md                  # Complete getting started
├── CHANGELOG.md                        # Version history
├── LICENSE                             # MIT license
│
├── docs/                               # All documentation
│   ├── README.md                       # Documentation index
│   ├── CONTRIBUTING.md                 # How to contribute
│   ├── FAQ.md                          # Frequently asked questions
│   ├── TROUBLESHOOTING.md              # Troubleshooting guide
│   ├── CODE_OF_CONDUCT.md              # Community guidelines
│   ├── SECURITY.md                     # Security policy
│   ├── GOVERNANCE.md                   # Project governance
│   │
│   ├── guides/                         # User guides
│   │   ├── FRAMEWORK_UPGRADE_GUIDE.md
│   │   ├── SESSION_RECOVERY_SOP.md
│   │   ├── CREATE_CUSTOM_COMMANDS.md
│   │   ├── GITHUB_WORKFLOW.md
│   │   ├── GUI_QUICK_START.md
│   │   └── SYNC_LOCAL_TERMINAL.md
│   │
│   ├── development/                    # Developer documentation
│   │   ├── DEVELOPMENT.md
│   │   ├── CODE_STANDARDS.md
│   │   ├── ARCHITECTURE.md
│   │   └── RELEASES.md
│   │
│   ├── ai-collaboration/               # AI collaboration docs
│   │   ├── AI_COLLABORATION_FRAMEWORK.md
│   │   ├── AI_WORKFLOW.md
│   │   ├── COLLABORATION_ROADMAP.md
│   │   └── ai_communication/
│   │       ├── README.md
│   │       └── VALIDATION_RULES.md
│   │
│   ├── occ/                            # OCC (Online Claude Copilot)
│   │   └── OCC_GUIDE.md                # Consolidated OCC docs
│   │
│   ├── workflows/                      # Workflow documentation
│   │   ├── AICH_NOTIFICATION_WORKFLOW.md
│   │   └── BROWSER_CLAUDE_TASKS.md
│   │
│   └── PROJECT_MANIFESTO.md            # Vision and philosophy
│
├── tcc-setup/                          # TCC installation (streamlined)
│   ├── README.md                       # TCC overview
│   ├── INSTALLATION.md                 # User installation guide
│   ├── INSTRUCTIONS_FOR_TCC.md         # TCC AI instructions
│   ├── INTEGRATION_GUIDE.md            # Integration guide
│   ├── MONITORING.md                   # Monitoring guide
│   ├── install-tcc.sh                  # Installation script
│   └── tcc-config-files/               # Configuration templates
│       ├── tccrc.template
│       └── tcc-init.sh.template
│
├── rules/                              # AI behavior rules
│   ├── GENERAL_AI_RULES.md             # Consolidated AI rules
│   ├── STARTUP_PROTOCOL.md
│   └── RULE_IMPROVEMENTS.md
│
├── .ai/                                # AI task management
│   ├── README.md
│   ├── BEHAVIOR_RULES.md
│   ├── CURRENT_TASK.md
│   ├── FRAMEWORK_USAGE.md
│   └── TCC_QUICK_REFERENCE.md
│
├── .ai-framework/                      # Framework internals
│   ├── communications/
│   ├── installation/
│   ├── project-state/
│   ├── project-templates/
│   └── rules/
│
├── templates/                          # Project templates
│   ├── .ai/
│   ├── session-recovery/
│   └── [template files]
│
├── examples/                           # Example configurations
│   ├── README.md
│   ├── python-datascience/
│   └── react-webapp/
│
├── scripts/                            # Automation scripts
│
├── tests/                              # Testing framework
│   ├── README.md
│   └── reports/                        # Test reports
│       ├── TEST_REPORT_20251119.md
│       └── TEST_SUCCESS_REPORT.md
│
└── .claude/                            # Claude Code commands
    └── commands/
```

---

## Files to Delete (Duplicates & Obsolete)

### Duplicates to Remove:
1. `docs/CHANGELOG.md`
2. `docs/CONTRIBUTING.md`
3. `.ai-framework/framework-docs/CHANGELOG.md`
4. `.ai-framework/framework-docs/CONTRIBUTING.md`
5. `.ai-framework/framework-docs/FAQ.md`
6. `.ai-framework/framework-docs/GETTING_STARTED.md`
7. `.ai-framework/framework-docs/TROUBLESHOOTING.md`
8. `.ai-framework/framework-docs/DEPLOYMENT_GUIDE.md`
9. `PROJECT_STATE.md` (root - keep .ai-framework version)

### Files to Consolidate/Move:
10. `CONNECTION_RETRY_FIX.md` → consolidate
11. `QUICK_FIX_CONNECTION_RETRY.md` → consolidate
12. `QUICK_START_WORKFLOW.md` → merge into QUICK_START.md
13. `OCC_ACTIVATION_CODE.md` → consolidate into docs/occ/
14. `OCC_STANDARD_PROMPT.md` → consolidate into docs/occ/
15. `CLAUDE_BEHAVIOR_RULES.md` → merge into rules/GENERAL_AI_RULES.md
16. `TEST_REPORT_20251119.md` → move to tests/reports/
17. `TEST_SUCCESS_REPORT.md` → move to tests/reports/
18. `BROWSER_CLAUDE_TASKS.md` → move to docs/workflows/
19. `AICH_NOTIFICATION_WORKFLOW.md` → move to docs/workflows/
20. `MANIFESTO.md` → rename to docs/PROJECT_MANIFESTO.md
21. `CODE_OF_CONDUCT.md` → move to docs/
22. `CODE_STANDARDS.md` → move to docs/development/
23. `COLLABORATION_ROADMAP.md` → move to docs/ai-collaboration/
24. `DEVELOPMENT.md` → move to docs/development/
25. `GOVERNANCE.md` → move to docs/
26. `RELEASES.md` → move to docs/development/
27. `SECURITY.md` → move to docs/
28. `SESSION_RECOVERY_SOP.md` → move to docs/guides/
29. `SESSION_STATE_REVIEW.md` → move to docs/guides/
30. `SYNC_LOCAL_TERMINAL.md` → move to docs/guides/
31. `FRAMEWORK_UPGRADE_GUIDE.md` → move to docs/guides/
32. `CREATE_CUSTOM_COMMANDS.md` → move to docs/guides/
33. `GITHUB_WORKFLOW.md` → move to docs/guides/
34. `GUI_QUICK_START.md` → move to docs/guides/

### TCC Files to Consolidate:
35. `tcc-setup/README_TCC_INSTALLATION.md` → merge into INSTALLATION.md
36. `tcc-setup/USER_GUIDE_TCC_INSTALLATION.md` → merge into INSTALLATION.md
37. `tcc-setup/TCC_SETUP.md` → merge into README.md
38. `tcc-setup/TCC_INTEGRATION_GUIDE.md` → rename to INTEGRATION_GUIDE.md
39. `docs/TCC_MONITORING.md` → move to tcc-setup/MONITORING.md
40. `docs/TCC_PERIODIC_MONITORING.md` → merge into tcc-setup/MONITORING.md

---

## Benefits of Reorganization

1. **Cleaner Root:** Only essential files (README, QUICK_START, GETTING_STARTED, CHANGELOG, LICENSE)
2. **Organized Docs:** All documentation in logical subdirectories
3. **No Duplicates:** Single source of truth for each document
4. **Better Discovery:** Clear directory names make finding docs easier
5. **Professional Structure:** Follows industry best practices
6. **Reduced File Count:** ~110 files → ~75-80 files (25-30% reduction)

---

## Implementation Steps

1. Create new directory structure
2. Move files to new locations
3. Consolidate duplicate content
4. Update all internal links
5. Update README.md with new structure
6. Delete obsolete files
7. Test all documentation links
8. Commit changes

---

## Link Updates Required

After reorganization, update links in:
- README.md
- All moved documentation files
- .ai/ files
- templates/
- GitHub templates (.github/)
- Any scripts that reference docs

---

## Total File Reduction

**Before:** 110 markdown files
**After:** ~75 files (estimated)
**Reduction:** ~35 files (32%)

**Root directory before:** 30+ markdown files
**Root directory after:** 5 core files (README, QUICK_START, GETTING_STARTED, CHANGELOG, LICENSE)
**Reduction:** 83% cleaner root directory
