# Framework Configuration - AudioApp

**Project:** AudioApp - Modern Music Player
**Framework:** AI Collaboration Framework v2.0
**Configuration Date:** November 23, 2025
**OCC Assignment:** Initial development and frontend oversight
**TCC Assignment:** Local testing and backend validation

---

## 🏗️ **PROJECT STRUCTURE**

### **AudioApp Directory Layout:**
```
AudioApp/
├── .ai-framework/              # AI Framework operational files
│   ├── project-state/          # Project continuity and state
│   │   ├── PROJECT_STATE.md         # Current status and progress
│   │   ├── REBOOT_INSTRUCTIONS.md   # Recovery documentation
│   │   └── FRAMEWORK_CONFIG.md      # This configuration file
│   ├── communications/         # TCC ↔ OCC communication
│   │   ├── reports/                 # TCC validation reports
│   │   ├── responses/               # OCC fix responses
│   │   └── updates/                 # Status updates
│   ├── rules/                  # Framework rules
│   │   ├── audioapp-testing-rules.md
│   │   ├── VALIDATION_RULES.md
│   │   └── REPOSITORY_SYNC_RULES.md
│   └── session-logs/           # Session tracking
├── .claude/commands/           # Custom slash commands
│   ├── setup-audioapp.md
│   ├── test-backend.md
│   ├── verify-integration.md
│   └── occ-review.md
├── backend/                    # Python backend
│   ├── api/                    # FastAPI routes
│   ├── models/                 # Data models
│   ├── services/               # Business logic
│   ├── tests/                  # Backend tests
│   └── main.py                 # App entry point
├── AudioApp/                   # SwiftUI macOS frontend
│   ├── Models/                 # Swift data models
│   ├── ViewModels/             # MVVM view models
│   ├── Views/                  # SwiftUI views
│   └── Services/               # API client
├── TCC_TESTING_GUIDE.md        # TCC testing protocol
├── OCC_DEVELOPMENT_NOTES.md    # OCC architecture notes
└── README.md                   # Project documentation
```

---

## ⚙️ **FRAMEWORK CONFIGURATION**

### **Project Type:** Hybrid - Python Backend + SwiftUI Frontend
### **Languages:** Python 3.9+, Swift 5.9+
### **Platform:** macOS 11.0+

### **Backend Configuration:**
```yaml
backend:
  framework: FastAPI
  language: python
  version: 3.9+
  testing: pytest
  coverage_minimum: 80%
  linting: black, flake8
  max_file_lines: 500

  services:
    - audio_player (pygame)
    - metadata_service (mutagen)
    - database (SQLAlchemy + SQLite)
    - websocket_manager (FastAPI WebSocket)
    - artwork_service (album art extraction)
    - playlist_service (CRUD operations)

  api:
    framework: FastAPI
    port: 8765
    host: 127.0.0.1
    documentation: /docs (Swagger UI)
```

### **Frontend Configuration:**
```yaml
frontend:
  framework: SwiftUI
  platform: macOS
  minimum_version: 11.0
  architecture: MVVM
  testing: XCTest

  components:
    - PlayerViewModel (playback state)
    - LibraryViewModel (library management)
    - Views (UI components)
    - AudioAppAPI (REST client)
```

### **Quality Standards:**
```yaml
code_quality:
  backend:
    formatting: black
    style_checking: flake8
    max_line_length: 100
    test_framework: pytest
    coverage_minimum: 80%

  frontend:
    style_guide: Swift API Design Guidelines
    architecture: MVVM
    testing: XCTest unit tests

security_requirements:
  api_security: CORS configured for localhost
  data_validation: Input validation on all endpoints
  file_access: Sandboxed with read-only user files

file_organization:
  backend_directory: "backend/"
  frontend_directory: "AudioApp/"
  tests_directory: "backend/tests/"
  framework_directory: ".ai-framework/"
```

---

## 🔄 **WORKFLOW CONFIGURATION**

### **TCC (Terminal Claude Code) Responsibilities:**
- **Testing:** Run pytest suite, validate all endpoints
- **Validation:** Backend code quality, database integrity
- **Reporting:** Create validation reports in communications/reports/
- **Bug Fixing:** Backend bugs (with documentation)
- **Integration Testing:** API endpoint verification

### **OCC (Online Claude Code) Responsibilities:**
- **Development:** Frontend implementation, UI/UX
- **Architecture:** System design decisions
- **Integration:** Frontend ↔ Backend connections
- **Code Review:** Approve all architectural changes
- **Oversight:** Final approval on TCC fixes

### **Communication Protocol:**
1. **TCC** runs tests → Creates report if issues found
2. **TCC** escalates frontend/architecture issues to OCC
3. **OCC** reviews reports → Implements fixes → Creates response
4. **TCC** re-validates → Updates project state
5. **Both** collaborate on integration issues

---

## 📂 **DIRECTORY RESPONSIBILITIES**

### **.ai-framework/ (Framework Operations)**
- **Owner:** Both TCC and OCC
- **Purpose:** Collaboration infrastructure
- **Backup:** Git version controlled
- **Critical Files:** PROJECT_STATE.md, communication reports

### **backend/ (Python Backend)**
- **Primary Owner:** TCC for testing, OCC for architecture
- **Testing:** TCC validates all changes
- **Modifications:** TCC can fix bugs, OCC approves features
- **Quality:** pytest, black, flake8 validation

### **AudioApp/ (SwiftUI Frontend)**
- **Primary Owner:** OCC exclusively
- **Testing:** TCC verifies API integration only
- **Modifications:** OCC only, TCC reports issues
- **Quality:** Swift style guide, XCTest

### **Documentation**
- **Shared:** Both TCC and OCC update
- **TCC Updates:** Testing results, backend changes
- **OCC Updates:** Architecture decisions, frontend changes

---

## 🛡️ **SECURITY CONFIGURATION**

### **Framework Protection:**
- Hidden directory (.ai-framework/) for operational files
- Git tracking of all framework files
- Communication files preserved for audit trail

### **Application Security:**
- Backend: CORS restricted to localhost
- Frontend: Sandboxed macOS app
- Database: Local SQLite with proper permissions
- No credentials in code or git

### **Testing Security:**
- Test database separate from production
- No real user data in tests
- Audio files for testing not committed

---

## 📊 **MONITORING CONFIGURATION**

### **Health Check Indicators:**
```bash
# Framework integrity
ls .ai-framework/project-state/ | wc -l  # Should be 3+ files

# Backend health
pytest backend/tests/ -v                  # All tests passing
curl http://127.0.0.1:8765/health        # Backend running

# Frontend build
xcodebuild -project AudioApp.xcodeproj -scheme AudioApp -configuration Debug build

# Communication status
ls .ai-framework/communications/reports/ | wc -l
```

### **Success Indicators:**
- ✅ All pytest tests passing
- ✅ Backend starts without errors
- ✅ Frontend builds successfully
- ✅ API endpoints respond correctly
- ✅ No critical issues in logs
- ✅ Integration tests pass

---

## 🎯 **COLLABORATION TARGETS**

### **Quality Metrics:**
- **Backend:** 80% test coverage minimum
- **API:** All endpoints documented in Swagger
- **Frontend:** Builds without warnings
- **Integration:** All features work end-to-end
- **Documentation:** Complete and accurate

### **Collaboration Metrics:**
- **Response time:** OCC responds to TCC reports same session
- **Fix effectiveness:** Issues resolved in single cycle
- **Communication:** All reports and responses documented
- **Handoff clarity:** Clean transitions between TCC and OCC

### **Workflow Metrics:**
- **Test success rate:** 95%+ passing
- **Build success rate:** 100% clean builds
- **Integration stability:** No breaking changes
- **Audit trail:** Complete history preserved

---

## 🔧 **MAINTENANCE CONFIGURATION**

### **TCC Regular Tasks:**
```bash
# Daily: Run backend tests
pytest backend/tests/ -v

# Daily: Check backend health
curl http://127.0.0.1:8765/health

# Weekly: Code quality check
black backend/ --check
flake8 backend/

# Weekly: Update PROJECT_STATE.md
```

### **OCC Regular Tasks:**
```bash
# Per session: Review TCC reports
cat .ai-framework/communications/reports/*.md

# Per session: Update frontend
# (SwiftUI development)

# Weekly: Architecture review
# Review OCC_DEVELOPMENT_NOTES.md

# Monthly: Documentation update
```

---

## 📈 **PERFORMANCE CONFIGURATION**

### **Backend Performance:**
- API response time: < 100ms for most endpoints
- Database queries: Optimized with indexes
- WebSocket: Real-time updates < 50ms latency
- Audio playback: No stuttering or lag

### **Frontend Performance:**
- UI responsiveness: 60fps animations
- API calls: Async with loading states
- Image caching: Artwork cached locally
- Memory usage: Efficient resource management

---

## 🚀 **DEPLOYMENT CONFIGURATION**

### **Development:**
- Backend: `python -m backend.main` or `./run.sh`
- Frontend: Xcode build and run
- Database: Auto-created at ~/.audioapp/library.db

### **Testing:**
- Backend: `pytest backend/tests/`
- Frontend: Xcode Test (⌘U)
- Integration: Manual testing with both running

### **Current Status:**
- **Version:** 1.0.0 (Initial development)
- **Branch:** claude/quadview-four-panel-editor-01J2v3zV7xqgvCWtYJ4haq1b
- **Backend:** Feature complete
- **Frontend:** Core features implemented, enhancements needed
- **Integration:** Partial (WebSocket pending)

---

**This configuration enables professional TCC/OCC collaboration on AudioApp.**

**Configuration Version:** 2.0 AudioApp
**Last Updated:** November 23, 2025
**Next Review:** December 23, 2025
