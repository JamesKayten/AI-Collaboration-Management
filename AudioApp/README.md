# AudioApp 🎵

A modern, cross-platform music player with a native macOS frontend and robust Python backend.

## Architecture

AudioApp uses a hybrid architecture that combines the best of both worlds:

- **Frontend**: Native macOS app built with SwiftUI for beautiful, performant UI
- **Backend**: Python-powered audio engine with FastAPI REST API
- **Communication**: RESTful API over HTTP (localhost)

This architecture provides:
- Native macOS look and feel
- Robust audio processing with Python's mature libraries
- Clean separation of concerns
- Easy extensibility for other platforms

## Features

### 🎵 Audio Playback
- High-quality audio playback using pygame
- Support for multiple formats: MP3, FLAC, M4A, OGG, WAV, AIFF
- Playback controls: Play, Pause, Stop, Next, Previous
- Seek functionality with progress bar
- Volume control

### 📚 Music Library
- Automatic metadata extraction (ID3 tags, Vorbis comments, etc.)
- SQLite-based library management
- Fast search across title, artist, and album
- Browse by artists and albums
- Library statistics and insights
- Cleanup tool for missing files

### 🎶 Queue Management
- Playback queue with position tracking
- Shuffle mode
- Repeat modes: None, One, All
- Add to queue functionality

### 📦 Import
- Import individual audio files
- Batch import from directories (recursive)
- Automatic metadata extraction on import

## Installation

### Prerequisites

- **macOS** 11.0 or later
- **Python** 3.9 or later
- **Xcode** 15.0 or later (for building the macOS app)

### Backend Setup

1. Clone the repository:
```bash
git clone https://github.com/JamesKayten/AudioApp.git
cd AudioApp
```

2. Create a Python virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate
```

3. Install Python dependencies:
```bash
pip install -r backend/requirements.txt
```

### Frontend Setup

1. Open `AudioApp.xcodeproj` in Xcode
2. Build and run the project (⌘R)

## Running the Application

### 1. Start the Backend Server

```bash
cd AudioApp
source venv/bin/activate
python -m backend.main
```

The backend will start on `http://127.0.0.1:8765`

### 2. Launch the macOS App

- Open the app in Xcode and click Run, or
- Build the app and run it from `/Applications`

## API Documentation

Once the backend is running, visit:
- **Swagger UI**: http://127.0.0.1:8765/docs
- **ReDoc**: http://127.0.0.1:8765/redoc

### Key API Endpoints

#### Player Control
- `POST /api/v1/player/play` - Start playback
- `POST /api/v1/player/pause` - Pause playback
- `POST /api/v1/player/next` - Next track
- `POST /api/v1/player/seek` - Seek to position
- `GET /api/v1/player/state` - Get playback state

#### Library Management
- `GET /api/v1/library/tracks` - Get all tracks
- `GET /api/v1/library/search?q=query` - Search tracks
- `POST /api/v1/library/import/directory` - Import directory
- `GET /api/v1/library/stats` - Library statistics

## Development

### Project Structure

```
AudioApp/
├── AudioApp/                    # macOS SwiftUI app
│   ├── Models/                  # Data models
│   ├── ViewModels/             # View models (MVVM)
│   ├── Views/                  # SwiftUI views
│   ├── Services/               # API client
│   └── AudioAppApp.swift       # App entry point
│
├── backend/                    # Python backend
│   ├── api/                    # FastAPI routes
│   ├── models/                 # Data models
│   ├── services/               # Business logic
│   │   ├── audio_player.py    # pygame audio engine
│   │   ├── metadata_service.py # Metadata extraction
│   │   ├── database.py        # SQLAlchemy DB
│   │   ├── library_manager.py # Library management
│   │   └── player_manager.py  # Playback coordination
│   └── main.py                # FastAPI app
│
├── requirements.txt           # Python dependencies
└── README.md                 # This file
```

### Backend Development

The backend uses:
- **FastAPI** - Modern web framework
- **pygame** - Audio playback
- **mutagen** - Metadata extraction
- **SQLAlchemy** - Database ORM
- **SQLite** - Database storage

Run with auto-reload:
```bash
python -m backend.main
```

### Frontend Development

The frontend uses:
- **SwiftUI** - Native UI framework
- **Combine** - Reactive programming
- **MVVM** architecture pattern

Open in Xcode and use live preview for rapid development.

### Running Tests

```bash
# Backend tests
cd AudioApp
source venv/bin/activate
pytest backend/tests/

# Frontend tests (in Xcode)
# Product > Test (⌘U)
```

## Configuration

### Backend Configuration

The backend stores data in `~/.audioapp/`:
- `library.db` - SQLite database
- `backend.log` - Application logs

### Supported Audio Formats

- MP3 (.mp3)
- FLAC (.flac)
- M4A/MP4 (.m4a, .mp4)
- OGG Vorbis (.ogg, .oga)
- WAV (.wav)
- AIFF (.aiff, .aif)

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Roadmap

- [ ] Playlist management
- [ ] Audio visualizations
- [ ] Last.fm scrobbling
- [ ] Equalizer
- [ ] Crossfade between tracks
- [ ] Gapless playback
- [ ] Album artwork from online sources
- [ ] Dark mode support
- [ ] Keyboard shortcuts
- [ ] Mini player mode
- [ ] Cross-platform support (Linux, Windows)

## Acknowledgments

- Built with [FastAPI](https://fastapi.tiangolo.com/)
- Audio playback powered by [pygame](https://www.pygame.org/)
- Metadata extraction using [mutagen](https://mutagen.readthedocs.io/)
- UI built with SwiftUI

## Support

For issues, questions, or contributions, please open an issue on GitHub.

---

Made with ❤️ for music lovers
