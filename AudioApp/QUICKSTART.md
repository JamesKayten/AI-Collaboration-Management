# QuickStart Guide - AudioApp

Get up and running with AudioApp in 5 minutes!

## Step 1: Clone and Setup (2 minutes)

```bash
# Clone the repository
git clone https://github.com/JamesKayten/AudioApp.git
cd AudioApp

# Run the automated setup script
./run.sh
```

The `run.sh` script will automatically:
- Check for Python 3.9+
- Create a virtual environment
- Install all dependencies
- Start the backend server

## Step 2: Launch the App (1 minute)

While the backend is running, open a new terminal:

```bash
# Open the Xcode project
open AudioApp.xcodeproj

# Or use Xcode command line tools
xcodebuild -project AudioApp.xcodeproj -scheme AudioApp -configuration Debug
```

In Xcode:
1. Select your Mac as the build target
2. Press ⌘R to build and run

## Step 3: Import Your Music (2 minutes)

1. Click the **Import** button in the toolbar
2. Select a folder containing your music files
3. Wait for the import to complete
4. Your music library is ready!

## Troubleshooting

### Backend won't start

```bash
# Make sure Python 3.9+ is installed
python3 --version

# If needed, install Python from python.org or use Homebrew
brew install python@3.11
```

### Missing dependencies

```bash
# Reinstall dependencies
source venv/bin/activate
pip install -r backend/requirements.txt
```

### Frontend build errors in Xcode

1. Clean build folder: Product → Clean Build Folder (⌘⇧K)
2. Restart Xcode
3. Rebuild the project

### Can't connect to backend

1. Check backend is running on http://127.0.0.1:8765
2. Visit http://127.0.0.1:8765/health to test
3. Check firewall settings

## Next Steps

- **Import music**: Use the Import button to add your music collection
- **Create playlists**: Organize your favorite tracks (coming soon)
- **Keyboard shortcuts**: Learn shortcuts for quick navigation (coming soon)
- **Customize**: Check the settings for appearance options (coming soon)

## Quick Commands

```bash
# Start backend
./run.sh

# Run tests
source venv/bin/activate
pytest backend/tests/

# Format code
black backend/

# View API docs
open http://127.0.0.1:8765/docs
```

## Getting Help

- **Documentation**: See [README.md](README.md) for full documentation
- **Contributing**: Read [CONTRIBUTING.md](CONTRIBUTING.md) to contribute
- **Issues**: Report bugs on [GitHub Issues](https://github.com/JamesKayten/AudioApp/issues)

---

🎵 **Enjoy your music!**
