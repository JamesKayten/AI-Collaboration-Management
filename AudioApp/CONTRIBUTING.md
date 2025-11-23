# Contributing to AudioApp

Thank you for your interest in contributing to AudioApp! This document provides guidelines and instructions for contributing.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior** vs **actual behavior**
- **Screenshots** if applicable
- **Environment details** (OS version, Python version, etc.)

### Suggesting Features

Feature suggestions are welcome! Please:

- Use a clear and descriptive title
- Provide detailed description of the proposed feature
- Explain why this feature would be useful
- Include mockups or examples if applicable

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following our coding standards
3. **Add tests** for new functionality
4. **Update documentation** as needed
5. **Ensure tests pass** before submitting
6. **Submit the pull request** with a clear description

## Development Setup

### Backend Development

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/AudioApp.git
cd AudioApp

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r backend/requirements.txt

# Install development dependencies
pip install pytest pytest-asyncio black flake8

# Run tests
pytest backend/tests/

# Format code
black backend/

# Lint code
flake8 backend/
```

### Frontend Development

```bash
# Open project in Xcode
open AudioApp.xcodeproj

# Run tests in Xcode
# Product > Test (⌘U)
```

## Coding Standards

### Python (Backend)

- Follow [PEP 8](https://pep8.org/) style guide
- Use [Black](https://black.readthedocs.io/) for code formatting
- Write docstrings for all public functions and classes
- Use type hints where applicable
- Maximum line length: 100 characters

**Example:**
```python
def process_audio_file(file_path: str, normalize: bool = False) -> Optional[Track]:
    """
    Process an audio file and extract metadata.

    Args:
        file_path: Path to the audio file
        normalize: Whether to normalize audio levels

    Returns:
        Track object if successful, None otherwise
    """
    # Implementation here
    pass
```

### Swift (Frontend)

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use SwiftUI best practices
- Use meaningful variable and function names
- Add comments for complex logic
- Use MVVM architecture pattern

**Example:**
```swift
/// Loads and plays a track from the library
/// - Parameters:
///   - trackId: The unique identifier of the track
///   - position: Starting position in seconds
/// - Returns: True if playback started successfully
func play(trackId: Int, position: Double = 0.0) async -> Bool {
    // Implementation here
}
```

## Project Architecture

### Backend (Python)

```
backend/
├── api/                    # FastAPI routes
│   └── routes.py          # API endpoints
├── models/                # Data models
│   ├── track.py          # Track and playback models
│   └── playlist.py       # Playlist models
├── services/             # Business logic
│   ├── audio_player.py   # Audio playback engine
│   ├── metadata_service.py # Metadata extraction
│   ├── database.py       # Database operations
│   ├── library_manager.py # Library management
│   └── player_manager.py # Playback coordination
├── utils/                # Utility functions
└── main.py              # Application entry point
```

### Frontend (SwiftUI)

```
AudioApp/
├── Models/              # Data models matching backend API
├── ViewModels/          # MVVM view models
├── Views/              # SwiftUI views
├── Services/           # API client and utilities
└── AudioAppApp.swift   # App entry point
```

## Testing

### Backend Tests

We use `pytest` for backend testing. Tests should cover:

- Unit tests for individual functions
- Integration tests for API endpoints
- Edge cases and error handling

**Example test:**
```python
import pytest
from backend.services.metadata_service import MetadataService

def test_extract_metadata_mp3():
    """Test metadata extraction from MP3 file."""
    service = MetadataService()
    metadata = service.extract_metadata("test_files/sample.mp3")

    assert metadata is not None
    assert metadata['title'] == "Sample Track"
    assert metadata['artist'] == "Test Artist"
```

Run tests:
```bash
pytest backend/tests/ -v
```

### Frontend Tests

Write XCTest unit tests for ViewModels and UI tests for key workflows.

## Adding New Features

### Adding a Backend Endpoint

1. Define the route in `backend/api/routes.py`
2. Add business logic in appropriate service
3. Update models if needed
4. Add tests
5. Update API documentation

### Adding a Frontend View

1. Create view in `AudioApp/Views/`
2. Create corresponding ViewModel if needed
3. Update navigation in `ContentView.swift`
4. Add tests
5. Update documentation

## Documentation

- Keep README.md up to date
- Document all public APIs
- Add inline comments for complex logic
- Update CHANGELOG.md for notable changes

## Commit Messages

Use clear, descriptive commit messages:

```
feat: Add playlist creation functionality
fix: Correct audio sync issue on seek
docs: Update API documentation
test: Add tests for metadata extraction
refactor: Simplify player state management
```

Prefixes:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `test:` - Test changes
- `refactor:` - Code refactoring
- `chore:` - Maintenance tasks

## Performance Guidelines

### Backend
- Use async/await for I/O operations
- Implement pagination for large datasets
- Cache frequently accessed data
- Profile code before optimization

### Frontend
- Minimize API calls with caching
- Use lazy loading for large lists
- Optimize image loading
- Profile with Instruments

## Security

- Never commit sensitive data (API keys, passwords, etc.)
- Validate all user input
- Use parameterized queries for database operations
- Keep dependencies up to date

## Questions?

If you have questions about contributing:

1. Check existing documentation
2. Search through issues
3. Create a new issue with the `question` label
4. Join our community discussions

## License

By contributing to AudioApp, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to AudioApp! 🎵
