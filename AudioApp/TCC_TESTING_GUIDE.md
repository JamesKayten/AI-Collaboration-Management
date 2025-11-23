# TCC Testing Guide - AudioApp

## Overview
This guide is for TCC (Testing & Collaboration Claude) to test the AudioApp implementation locally.

## Prerequisites Check
Before starting, verify:
- [ ] Python 3.9+ installed
- [ ] macOS 11.0+ (for frontend testing)
- [ ] Xcode 15.0+ installed
- [ ] Git configured

## Setup Instructions

### 1. Clone Repository
```bash
cd ~/workspace
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git
cd AI-Collaboration-Management
git checkout claude/quadview-four-panel-editor-01J2v3zV7xqgvCWtYJ4haq1b
```

### 2. Backend Setup
```bash
cd AudioApp

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r backend/requirements.txt

# Verify installation
python -c "import fastapi; import pygame; import mutagen; print('✓ All dependencies installed')"
```

### 3. Start Backend Server
```bash
# From AudioApp directory
./run.sh

# Or manually:
source venv/bin/activate
python -m backend.main
```

Expected output:
```
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://127.0.0.1:8765
```

### 4. Verify Backend Health
```bash
# In a new terminal
curl http://127.0.0.1:8765/health
# Expected: {"status":"healthy","service":"AudioApp Backend"}

# Check API docs
open http://127.0.0.1:8765/docs
```

## Testing Protocol

### Backend Testing Priority

#### Phase 1: Core Services
1. **Database Service** (`backend/tests/test_database.py`)
   ```bash
   pytest backend/tests/test_database.py -v
   ```
   - Verify all track operations
   - Test playlist CRUD
   - Check search functionality

2. **Metadata Service** (`backend/tests/test_metadata_service.py`)
   ```bash
   pytest backend/tests/test_metadata_service.py -v
   ```
   - Test format detection
   - Verify metadata extraction

3. **Audio Player Service**
   ```bash
   # Manual test - requires audio file
   python -c "
   from backend.services.audio_player import AudioPlayer
   player = AudioPlayer()
   # Test basic initialization
   print('✓ Audio player initialized')
   player.cleanup()
   "
   ```

#### Phase 2: API Endpoints
Test each endpoint using curl or the Swagger UI at http://127.0.0.1:8765/docs

**Critical Endpoints to Test:**
```bash
# Health check
curl http://127.0.0.1:8765/api/v1/health

# Library stats
curl http://127.0.0.1:8765/api/v1/library/stats

# Player state
curl http://127.0.0.1:8765/api/v1/player/state

# Create playlist
curl -X POST http://127.0.0.1:8765/api/v1/playlists \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Playlist","description":"TCC test"}'

# Get smart playlists
curl http://127.0.0.1:8765/api/v1/playlists/smart
```

#### Phase 3: Advanced Features
1. **WebSocket Connection**
   ```python
   # Test WebSocket (create test_websocket.py)
   import asyncio
   import websockets
   import json

   async def test_ws():
       uri = "ws://127.0.0.1:8765/api/v1/ws"
       async with websockets.connect(uri) as websocket:
           print("✓ WebSocket connected")
           # Wait for messages
           message = await websocket.recv()
           print(f"Received: {message}")

   asyncio.run(test_ws())
   ```

2. **Artwork Service**
   - Import a music file with album art
   - Verify artwork extraction
   - Check cache creation in `~/.audioapp/artwork/`

3. **Import Functionality**
   ```bash
   # Test directory import
   curl -X POST http://127.0.0.1:8765/api/v1/library/import/directory \
     -H "Content-Type: application/json" \
     -d '{"directory_path":"/path/to/music","recursive":true}'
   ```

### Frontend Testing (Optional)

**Note**: Frontend refinement is OCC's responsibility. TCC should focus on:
- Verifying app builds successfully
- Testing API integration points
- Reporting any build errors

```bash
# From AudioApp directory
open AudioApp.xcodeproj

# In Xcode:
# 1. Select "My Mac" as target
# 2. Product > Build (⌘B)
# 3. Check for build errors only
# 4. DO NOT modify SwiftUI code without OCC oversight
```

## Expected Test Results

### Backend Tests
All pytest tests should pass:
```
======================== test session starts =========================
collected 15 items

backend/tests/test_database.py ............ [ 80%]
backend/tests/test_metadata_service.py ... [100%]

======================== 15 passed in 2.34s =========================
```

### Runtime Verification
1. ✓ Backend starts without errors
2. ✓ Health endpoint responds
3. ✓ Database created at `~/.audioapp/library.db`
4. ✓ Log file created at `~/.audioapp/backend.log`
5. ✓ All API endpoints respond correctly

## Known Issues & Limitations

### Audio Playback
- Requires actual audio files to test
- pygame may need SDL libraries on some systems
- Test with common formats: MP3, FLAC, M4A

### Frontend
- Requires macOS to build and test
- SwiftUI preview may not work without backend running
- Some features require backend API to be active

## Reporting Issues

When reporting issues to OCC, include:

1. **Environment Info**
   ```bash
   python --version
   sw_vers  # macOS version
   pip list | grep -E 'fastapi|pygame|mutagen'
   ```

2. **Error Logs**
   ```bash
   # Backend logs
   tail -50 ~/.audioapp/backend.log

   # Database info
   sqlite3 ~/.audioapp/library.db "SELECT COUNT(*) FROM tracks;"
   ```

3. **Test Output**
   - Full pytest output
   - Curl responses
   - Any stack traces

4. **Steps to Reproduce**
   - Exact commands run
   - Expected vs actual behavior

## TCC Responsibilities

### ✅ TCC Should:
- Run all backend tests
- Verify API endpoints work
- Test database operations
- Check import functionality
- Report bugs with details
- Test backend services thoroughly
- Validate data persistence

### ❌ TCC Should NOT:
- Modify SwiftUI frontend code
- Change UI design or styling
- Alter ViewModels without consultation
- Make architectural changes alone
- Refactor frontend without OCC approval

## OCC Oversight Areas

OCC maintains control over:
- SwiftUI interface design
- Frontend animations and UX
- ViewModel architecture
- API client implementation
- UI/UX decisions
- Visual design choices

## Collaboration Workflow

1. **TCC**: Tests backend, reports findings
2. **OCC**: Reviews reports, makes decisions
3. **TCC**: Implements approved backend fixes
4. **OCC**: Handles all frontend changes
5. **Both**: Verify integration works

## Success Criteria

Before marking testing complete:
- [ ] All pytest tests pass
- [ ] All API endpoints respond correctly
- [ ] Database operations work
- [ ] Audio playback functional (with sample file)
- [ ] Import process works
- [ ] WebSocket connection established
- [ ] Artwork extraction works
- [ ] No errors in backend.log
- [ ] Frontend builds successfully

## Contact Points

**Issues with:**
- Backend logic → TCC can fix
- Frontend design → Escalate to OCC
- Integration → Both collaborate
- Architecture → OCC decides

---

**Remember**: This is a collaborative project. TCC excels at backend testing and validation, while OCC handles frontend refinement and architectural decisions. Work together for best results!
