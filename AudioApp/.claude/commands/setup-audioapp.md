---
description: Initial setup and installation of AudioApp for testing
---

# AudioApp Setup Protocol

Complete setup of AudioApp for local testing and development.

## Step 1: Repository Setup
```bash
# If not already cloned
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git
cd AI-Collaboration-Management
git checkout claude/quadview-four-panel-editor-01J2v3zV7xqgvCWtYJ4haq1b

# Navigate to AudioApp
cd AudioApp
```

## Step 2: Python Backend Setup
```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r backend/requirements.txt

# Verify installation
python -c "
import fastapi
import pygame
import mutagen
import sqlalchemy
print('✓ All core dependencies installed')
"
```

## Step 3: Initialize Application
```bash
# Create app directory
mkdir -p ~/.audioapp

# Start backend to initialize database
python -m backend.main &

# Wait for startup
sleep 3

# Verify health
curl http://127.0.0.1:8765/health

# Stop for now
pkill -f "backend.main"
```

## Step 4: Frontend Setup (macOS only)
```bash
# Open Xcode project
open AudioApp.xcodeproj

# In Xcode:
# 1. Select "My Mac" as run destination
# 2. Product > Build (⌘B)
# 3. Verify build succeeds
```

## Step 5: Verification
```bash
# Run tests
pytest backend/tests/ -v

# Check structure
ls -la backend/
ls -la AudioApp/

# Verify framework installed
ls .ai-framework/
ls .claude/commands/
```

## Expected Results
- ✓ Virtual environment created
- ✓ All dependencies installed
- ✓ Database initialized
- ✓ Backend starts without errors
- ✓ Tests pass
- ✓ Frontend builds successfully

## Troubleshooting

### Python version issues
```bash
python3 --version  # Should be 3.9+
```

### Missing dependencies
```bash
pip install --upgrade pip
pip install -r backend/requirements.txt --force-reinstall
```

### Database errors
```bash
rm ~/.audioapp/library.db
# Restart backend to recreate
```

### Xcode build errors
- Clean build folder (⌘⇧K)
- Restart Xcode
- Check macOS version (11.0+ required)

## Next Steps
After setup:
1. Run `/test-backend` to verify backend
2. Use `/verify-integration` for full stack testing
3. See TCC_TESTING_GUIDE.md for detailed protocols
