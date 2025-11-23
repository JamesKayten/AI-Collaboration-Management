# AI Communication Protocol

**Framework:** Avery's AI Collaboration Hack v2.0 Professional
**Purpose:** Cross-platform AI collaboration communication

---

## 📁 **COMMUNICATION DIRECTORIES**

### **reports/**
- **Purpose:** Local AI validation reports
- **Created by:** Terminal Claude Code (TCC)
- **Format:** `AI_REPORT_YYYY-MM-DD.md` or `AI_REPORT_YYYY-MM-DD_DESCRIPTION.md`
- **Content:** Validation failures, violations, required fixes

### **responses/**
- **Purpose:** Online AI fix responses
- **Created by:** Browser Claude (OCC)
- **Format:** `AI_RESPONSE_YYYY-MM-DD.md` or `AI_RESPONSE_YYYY-MM-DD_DESCRIPTION.md`
- **Content:** Fix implementations, completed changes, documentation

### **updates/**
- **Purpose:** General AI status updates
- **Created by:** Either Local AI or Online AI
- **Format:** `AI_UPDATE_YYYY-MM-DD.md` or `AI_UPDATE_YYYY-MM-DD_DESCRIPTION.md`
- **Content:** Project status, questions, general communications

---

## 🔄 **COMMUNICATION WORKFLOW**

1. **Local AI (TCC)** runs validation → Creates report in `reports/`
2. **User** triggers Online AI with repository access
3. **Online AI (OCC)** reads report → Implements fixes → Creates response in `responses/`
4. **Local AI (TCC)** detects response → Re-validates → Continues workflow

---

## 📋 **FILE NAMING CONVENTIONS**

### **Standard Format:**
```
AI_[TYPE]_YYYY-MM-DD_[OPTIONAL-DESCRIPTION].md
```

### **Examples:**
```
AI_REPORT_2025-11-18.md
AI_REPORT_2025-11-18_TASK-API.md
AI_RESPONSE_2025-11-18_FIXES-COMPLETED.md
AI_UPDATE_2025-11-18_STATUS-CHECK.md
```

---

## 🔧 **INTEGRATION WITH FRAMEWORK**

### **Local AI Commands:**
- `"work ready"` - Triggers validation and report generation
- Reports automatically created in `reports/` directory

### **Online AI Commands:**
- `"Check .ai-framework/communications/ for latest report and address the issues"`
- Responses should be created in `responses/` directory

---

**This communication system enables seamless AI-to-AI collaboration through repository-based file exchange.**