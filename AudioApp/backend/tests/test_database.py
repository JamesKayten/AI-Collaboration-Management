"""
Tests for database service.
"""

import pytest
import tempfile
from pathlib import Path
from backend.services.database import DatabaseService


@pytest.fixture
def db_service():
    """Create a temporary database for testing."""
    with tempfile.NamedTemporaryFile(suffix=".db", delete=False) as tmp:
        db_path = tmp.name

    service = DatabaseService(db_path=db_path)
    yield service

    # Cleanup
    Path(db_path).unlink(missing_ok=True)


class TestDatabaseService:
    """Test suite for DatabaseService."""

    def test_add_track(self, db_service):
        """Test adding a track to the database."""
        track_data = {
            'file_path': '/test/path/song.mp3',
            'title': 'Test Song',
            'artist': 'Test Artist',
            'album': 'Test Album',
            'duration': 180.5,
        }

        track = db_service.add_track(track_data)

        assert track is not None
        assert track.id is not None
        assert track.title == 'Test Song'
        assert track.artist == 'Test Artist'

    def test_add_duplicate_track(self, db_service):
        """Test that duplicate tracks are handled correctly."""
        track_data = {
            'file_path': '/test/path/song.mp3',
            'title': 'Test Song',
        }

        track1 = db_service.add_track(track_data)
        track2 = db_service.add_track(track_data)

        # Should return the existing track
        assert track1.id == track2.id

    def test_get_track(self, db_service):
        """Test retrieving a track by ID."""
        track_data = {
            'file_path': '/test/path/song.mp3',
            'title': 'Test Song',
        }

        added_track = db_service.add_track(track_data)
        retrieved_track = db_service.get_track(added_track.id)

        assert retrieved_track is not None
        assert retrieved_track.id == added_track.id
        assert retrieved_track.title == 'Test Song'

    def test_get_nonexistent_track(self, db_service):
        """Test retrieving a nonexistent track."""
        track = db_service.get_track(99999)
        assert track is None

    def test_get_all_tracks(self, db_service):
        """Test retrieving all tracks."""
        # Add multiple tracks
        for i in range(5):
            track_data = {
                'file_path': f'/test/path/song{i}.mp3',
                'title': f'Test Song {i}',
            }
            db_service.add_track(track_data)

        tracks = db_service.get_all_tracks()
        assert len(tracks) == 5

    def test_search_tracks(self, db_service):
        """Test searching for tracks."""
        # Add test tracks
        tracks_data = [
            {'file_path': '/test/1.mp3', 'title': 'Rock Song', 'artist': 'Rock Band'},
            {'file_path': '/test/2.mp3', 'title': 'Jazz Song', 'artist': 'Jazz Band'},
            {'file_path': '/test/3.mp3', 'title': 'Blues Song', 'artist': 'Blues Band'},
        ]

        for data in tracks_data:
            db_service.add_track(data)

        # Search for "Rock"
        results = db_service.search_tracks('Rock')
        assert len(results) == 1
        assert results[0].title == 'Rock Song'

        # Search for "Song"
        results = db_service.search_tracks('Song')
        assert len(results) == 3

    def test_update_track(self, db_service):
        """Test updating track metadata."""
        track_data = {
            'file_path': '/test/path/song.mp3',
            'title': 'Original Title',
        }

        track = db_service.add_track(track_data)

        # Update title
        updated = db_service.update_track(track.id, {'title': 'Updated Title'})

        assert updated is not None
        assert updated.title == 'Updated Title'

    def test_delete_track(self, db_service):
        """Test deleting a track."""
        track_data = {
            'file_path': '/test/path/song.mp3',
            'title': 'Test Song',
        }

        track = db_service.add_track(track_data)
        assert db_service.delete_track(track.id) is True

        # Verify it's deleted
        assert db_service.get_track(track.id) is None

    def test_create_playlist(self, db_service):
        """Test creating a playlist."""
        playlist = db_service.create_playlist('My Playlist', 'Test description')

        assert playlist is not None
        assert playlist.id is not None
        assert playlist.name == 'My Playlist'
        assert playlist.description == 'Test description'

    def test_get_all_playlists(self, db_service):
        """Test retrieving all playlists."""
        db_service.create_playlist('Playlist 1')
        db_service.create_playlist('Playlist 2')

        playlists = db_service.get_all_playlists()
        assert len(playlists) == 2

    def test_delete_playlist(self, db_service):
        """Test deleting a playlist."""
        playlist = db_service.create_playlist('Test Playlist')

        assert db_service.delete_playlist(playlist.id) is True
        assert db_service.get_playlist(playlist.id) is None
