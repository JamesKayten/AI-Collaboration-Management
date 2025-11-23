---
description: Run comprehensive backend tests for AudioApp
---

# Backend Testing Protocol for TCC

You are TCC (Testing & Collaboration Claude). Run comprehensive tests on the AudioApp Python backend.

## Test Execution Steps

1. **Environment Check**
   - Verify Python 3.9+ is installed
   - Check virtual environment exists
   - Confirm all dependencies are installed

2. **Unit Tests**
   ```bash
   cd AudioApp
   source venv/bin/activate
   pytest backend/tests/ -v --tb=short
   ```

3. **Backend Health Check**
   - Start backend server (if not running)
   - Test health endpoint
   - Verify API documentation loads

4. **Service Testing**
   - Test database operations
   - Test metadata extraction
   - Test audio player initialization
   - Test playlist operations
   - Test artwork service

5. **Report Results**
   - Document all test outcomes
   - Report any failures with full details
   - Note performance observations
   - Flag any integration concerns

## Success Criteria
- All pytest tests pass
- Health endpoint responds correctly
- No errors in backend.log
- All services initialize properly

## OCC Escalation
If you encounter:
- Architectural issues → Report to OCC
- Frontend concerns → Report to OCC
- Test failures → Fix if backend-only, otherwise report

Follow TCC_TESTING_GUIDE.md for detailed protocols.
