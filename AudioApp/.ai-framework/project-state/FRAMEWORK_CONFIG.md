# Framework Configuration

**Project:** ai-collaboration-test
**Framework:** Avery's AI Collaboration Hack v1.0
**Configuration Date:** November 18, 2025
**Professional Structure Version:** 2.0

---

## 🏗️ **PROJECT STRUCTURE**

### **Root Directory Layout:**
```
ai-collaboration-test/
├── .ai-framework/              # AI Framework operational files (HIDDEN)
│   ├── project-state/          # Project continuity and reboot documentation
│   │   ├── PROJECT_STATE.md         # Current project status and progress
│   │   ├── REBOOT_INSTRUCTIONS.md   # Emergency recovery documentation
│   │   └── FRAMEWORK_CONFIG.md      # This file - configuration details
│   ├── communications/         # AI-to-AI communication files
│   │   ├── README.md                # Communication protocol guide
│   │   ├── reports/                 # Local AI validation reports
│   │   │   └── AI_REPORT_*.md       # Validation failure reports
│   │   ├── responses/               # Online AI fix responses
│   │   │   └── AI_RESPONSE_*.md     # Fix completion documentation
│   │   └── updates/                 # General AI updates and messages
│   │       └── AI_UPDATE_*.md       # Status updates and communications
│   ├── rules/                  # Framework operational rules
│   │   ├── VALIDATION_RULES.md      # Project-specific validation standards
│   │   ├── REPOSITORY_SYNC_RULES.md # Repository synchronization protocol
│   │   └── WORKFLOW_RULES.md        # AI collaboration workflow rules
│   └── docs/                   # Framework documentation
│       ├── AI_COLLABORATION_FRAMEWORK.md  # Framework overview
│       └── AI_WORKFLOW.md               # Detailed workflow instructions
├── src/                        # Source code files
│   ├── main.py                      # Original project file
│   ├── task_api.py                  # Task Management API
│   └── simple_test.py               # Test files for validation
├── tests/                      # Test files
│   └── test_task_api.py             # Comprehensive test suite
├── docs/                       # Project documentation (user-facing)
└── README.md                   # Project readme
```

---

## ⚙️ **FRAMEWORK CONFIGURATION**

### **Project Type:** Python Backend/API
### **Language:** python
### **Max File Size:** 250 lines per file
### **Test Coverage Required:** 90% minimum
### **Validation Tools:** black, flake8, pytest, pyperclip

### **Quality Standards:**
```yaml
code_quality:
  formatting: black
  style_checking: flake8
  max_line_length: 88
  test_framework: pytest
  coverage_minimum: 90

security_requirements:
  password_hashing: bcrypt (not MD5)
  input_validation: required
  session_management: secure tokens
  vulnerability_scanning: enabled

file_organization:
  source_directory: "src/"
  test_directory: "tests/"
  framework_directory: ".ai-framework/"
  max_file_lines: 250
```

---

## 🔄 **WORKFLOW CONFIGURATION**

### **Local AI (TCC) Commands:**
- **Validation trigger:** `"work ready"`
- **Report location:** `.ai-framework/communications/reports/`
- **Validation sequence:** File size → Style → Format → Tests → Security

### **Online AI (OCC) Commands:**
- **Activation command:** `"Check .ai-framework/communications/ for latest report and address the issues"`
- **Response location:** `.ai-framework/communications/responses/`
- **Fix requirements:** Address all violations in validation report

### **Communication Protocol:**
1. **Local AI** detects violations → Creates report
2. **User** triggers Online AI with repository files
3. **Online AI** reads report → Implements fixes → Creates response
4. **Local AI** re-validates → Merges if successful

---

## 📂 **DIRECTORY RESPONSIBILITIES**

### **.ai-framework/ (Framework Operational Files)**
- **Owner:** AI Collaboration Framework
- **Purpose:** All framework-related files and communications
- **Backup:** Critical - contains project continuity information
- **Access:** Framework automation and manual review

### **src/ (Source Code)**
- **Owner:** Development team and AI collaborators
- **Purpose:** All application source code
- **Backup:** Version controlled in git
- **Access:** Read/write by both Local and Online AI

### **tests/ (Test Files)**
- **Owner:** Development team and AI collaborators
- **Purpose:** All test files and test data
- **Backup:** Version controlled in git
- **Access:** Read/write for test coverage validation

### **docs/ (Project Documentation)**
- **Owner:** Development team
- **Purpose:** User-facing project documentation
- **Backup:** Version controlled in git
- **Access:** Primarily human-readable documentation

---

## 🛡️ **SECURITY CONFIGURATION**

### **Framework File Protection:**
- **Hidden directory:** `.ai-framework/` not visible in normal listings
- **Git tracking:** All framework files version controlled
- **Access control:** Framework files readable by both AI systems

### **Repository Security:**
- **Sensitive data:** Never commit secrets or credentials
- **File permissions:** Standard Unix permissions
- **Backup strategy:** Git repository with full history

### **AI Communication Security:**
- **Report validation:** All reports include timestamp and source
- **Response verification:** Responses must reference original report
- **Audit trail:** Complete communication history preserved

---

## 📊 **MONITORING CONFIGURATION**

### **Health Check Indicators:**
```bash
# Framework integrity
ls .ai-framework/project-state/ | wc -l  # Should be 3+ files

# Communication status
ls .ai-framework/communications/reports/ | wc -l    # Reports created
ls .ai-framework/communications/responses/ | wc -l  # Responses received

# Code quality status
python3 -m flake8 src/ --count              # Style violations
python3 -m pytest tests/ --cov=src --cov-report=term-missing  # Test coverage
```

### **Failure Indicators:**
- Missing framework directories
- Validation reports without responses
- Responses without corresponding reports
- Git working directory not clean during collaboration

---

## 🎯 **COLLABORATION TARGETS**

### **Quality Metrics:**
- **Zero critical syntax errors** in production code
- **90% minimum test coverage** for all source files
- **100% PEP 8 compliance** via flake8 validation
- **100% black formatting compliance**
- **Zero security vulnerabilities** (bcrypt passwords, input validation)

### **Collaboration Metrics:**
- **Response time:** Online AI responds to reports within user session
- **Fix effectiveness:** All reported violations addressed in single cycle
- **Communication completeness:** Reports and responses properly documented

### **Workflow Metrics:**
- **Merge success rate:** Clean merges after validation passes
- **Automation level:** Minimal manual intervention required
- **Audit trail completeness:** Full history of AI collaboration preserved

---

## 🔧 **MAINTENANCE CONFIGURATION**

### **Regular Tasks:**
```bash
# Weekly framework health check
.ai-framework/project-state/health-check.sh

# Monthly repository cleanup
git gc --prune=now
find .ai-framework -name "*.md" -mtime +30 -type f  # Archive old communications

# Quarterly configuration review
review .ai-framework/rules/VALIDATION_RULES.md
review .ai-framework/project-state/FRAMEWORK_CONFIG.md
```

### **Upgrade Procedures:**
1. **Backup current framework state**
2. **Test new framework version in branch**
3. **Migrate configuration and rules**
4. **Validate workflow with test scenarios**
5. **Deploy to main branch if successful**

---

## 📈 **PERFORMANCE CONFIGURATION**

### **Optimization Settings:**
- **Validation parallelization:** Run multiple checks simultaneously
- **Cache management:** Preserve test coverage and validation results
- **File watching:** Monitor source changes for incremental validation

### **Resource Limits:**
- **Max file size:** 250 lines (configurable per project type)
- **Max test execution time:** 60 seconds per test suite
- **Max validation report size:** 10KB (for efficient communication)

---

**This configuration ensures professional, scalable, and maintainable AI collaboration workflow.**

**Configuration Version:** 2.0 Professional Structure
**Last Verified:** November 18, 2025
**Next Review:** December 18, 2025