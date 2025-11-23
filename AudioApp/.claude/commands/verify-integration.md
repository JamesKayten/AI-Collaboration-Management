---
description: Verify AudioApp frontend/backend integration
---

# Integration Verification Protocol

Test the complete integration between SwiftUI frontend and Python backend.

## Pre-checks
1. Backend server running on http://127.0.0.1:8765
2. Frontend app built successfully in Xcode
3. Database initialized at ~/.audioapp/library.db

## Integration Tests

### 1. API Connectivity
- [ ] Health endpoint responds
- [ ] Player state endpoint returns data
- [ ] Library endpoints accessible
- [ ] Error responses well-formed

### 2. Data Flow
- [ ] Import music file → appears in library
- [ ] Play track → backend starts playback
- [ ] Seek position → backend responds
- [ ] Volume change → backend updates

### 3. Real-time Features
- [ ] WebSocket connection established
- [ ] Playback state updates received
- [ ] Library updates propagate

### 4. Advanced Features
- [ ] Artwork extraction works
- [ ] Playlist operations succeed
- [ ] Search returns results
- [ ] Smart playlists generate

## Report Format
For each test:
- ✅ Pass: Describe expected behavior confirmed
- ⚠️ Partial: What works, what doesn't
- ❌ Fail: Error details and reproduction steps

## OCC Review Required
- UI/UX issues
- Animation problems
- Design inconsistencies
- Architecture changes needed
