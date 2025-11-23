"""
Database service for managing music library persistence.
Uses SQLAlchemy with SQLite for local storage.
"""

import logging
from pathlib import Path
from typing import List, Optional
from sqlalchemy import create_engine, select
from sqlalchemy.orm import sessionmaker, Session
from ..models.track import TrackDB, Base
from ..models.playlist import PlaylistDB

logger = logging.getLogger(__name__)


class DatabaseService:
    """
    Service for managing the SQLite database.
    Handles track and playlist persistence.
    """

    def __init__(self, db_path: str = None):
        """
        Initialize database service.

        Args:
            db_path: Path to SQLite database file. If None, uses default location.
        """
        if db_path is None:
            # Default to user's home directory
            home = Path.home()
            db_dir = home / '.audioapp'
            db_dir.mkdir(exist_ok=True)
            db_path = str(db_dir / 'library.db')

        self.db_path = db_path
        self.engine = create_engine(f'sqlite:///{db_path}', echo=False)
        self.SessionLocal = sessionmaker(bind=self.engine)

        # Create tables if they don't exist
        Base.metadata.create_all(self.engine)
        logger.info(f"Database initialized at: {db_path}")

    def get_session(self) -> Session:
        """Get a new database session."""
        return self.SessionLocal()

    # Track operations

    def add_track(self, track_data: dict) -> Optional[TrackDB]:
        """
        Add a new track to the library.

        Args:
            track_data: Dictionary containing track metadata

        Returns:
            Created TrackDB object, or None if failed
        """
        try:
            with self.get_session() as session:
                # Check if track already exists
                existing = session.query(TrackDB).filter_by(
                    file_path=track_data['file_path']
                ).first()

                if existing:
                    logger.warning(f"Track already exists: {track_data['file_path']}")
                    return existing

                track = TrackDB(**track_data)
                session.add(track)
                session.commit()
                session.refresh(track)

                logger.info(f"Added track: {track.title} by {track.artist}")
                return track

        except Exception as e:
            logger.error(f"Error adding track: {e}")
            return None

    def get_track(self, track_id: int) -> Optional[TrackDB]:
        """
        Get a track by ID.

        Args:
            track_id: Track ID

        Returns:
            TrackDB object or None
        """
        try:
            with self.get_session() as session:
                track = session.query(TrackDB).filter_by(id=track_id).first()
                return track

        except Exception as e:
            logger.error(f"Error getting track: {e}")
            return None

    def get_all_tracks(self, limit: int = None, offset: int = 0) -> List[TrackDB]:
        """
        Get all tracks from the library.

        Args:
            limit: Maximum number of tracks to return
            offset: Number of tracks to skip

        Returns:
            List of TrackDB objects
        """
        try:
            with self.get_session() as session:
                query = session.query(TrackDB).offset(offset)
                if limit:
                    query = query.limit(limit)

                tracks = query.all()
                return tracks

        except Exception as e:
            logger.error(f"Error getting tracks: {e}")
            return []

    def search_tracks(self, query: str) -> List[TrackDB]:
        """
        Search for tracks by title, artist, or album.

        Args:
            query: Search query string

        Returns:
            List of matching TrackDB objects
        """
        try:
            with self.get_session() as session:
                search_pattern = f"%{query}%"
                tracks = session.query(TrackDB).filter(
                    (TrackDB.title.like(search_pattern)) |
                    (TrackDB.artist.like(search_pattern)) |
                    (TrackDB.album.like(search_pattern))
                ).all()

                return tracks

        except Exception as e:
            logger.error(f"Error searching tracks: {e}")
            return []

    def update_track(self, track_id: int, updates: dict) -> Optional[TrackDB]:
        """
        Update track metadata.

        Args:
            track_id: Track ID
            updates: Dictionary of fields to update

        Returns:
            Updated TrackDB object or None
        """
        try:
            with self.get_session() as session:
                track = session.query(TrackDB).filter_by(id=track_id).first()
                if not track:
                    return None

                for key, value in updates.items():
                    if hasattr(track, key):
                        setattr(track, key, value)

                session.commit()
                session.refresh(track)

                logger.info(f"Updated track: {track_id}")
                return track

        except Exception as e:
            logger.error(f"Error updating track: {e}")
            return None

    def delete_track(self, track_id: int) -> bool:
        """
        Delete a track from the library.

        Args:
            track_id: Track ID

        Returns:
            True if deleted successfully
        """
        try:
            with self.get_session() as session:
                track = session.query(TrackDB).filter_by(id=track_id).first()
                if not track:
                    return False

                session.delete(track)
                session.commit()

                logger.info(f"Deleted track: {track_id}")
                return True

        except Exception as e:
            logger.error(f"Error deleting track: {e}")
            return False

    # Playlist operations

    def create_playlist(self, name: str, description: str = None) -> Optional[PlaylistDB]:
        """
        Create a new playlist.

        Args:
            name: Playlist name
            description: Optional description

        Returns:
            Created PlaylistDB object or None
        """
        try:
            with self.get_session() as session:
                playlist = PlaylistDB(name=name, description=description)
                session.add(playlist)
                session.commit()
                session.refresh(playlist)

                logger.info(f"Created playlist: {name}")
                return playlist

        except Exception as e:
            logger.error(f"Error creating playlist: {e}")
            return None

    def get_all_playlists(self) -> List[PlaylistDB]:
        """
        Get all playlists.

        Returns:
            List of PlaylistDB objects
        """
        try:
            with self.get_session() as session:
                playlists = session.query(PlaylistDB).all()
                return playlists

        except Exception as e:
            logger.error(f"Error getting playlists: {e}")
            return []

    def get_playlist(self, playlist_id: int) -> Optional[PlaylistDB]:
        """
        Get a playlist by ID.

        Args:
            playlist_id: Playlist ID

        Returns:
            PlaylistDB object or None
        """
        try:
            with self.get_session() as session:
                playlist = session.query(PlaylistDB).filter_by(id=playlist_id).first()
                return playlist

        except Exception as e:
            logger.error(f"Error getting playlist: {e}")
            return None

    def delete_playlist(self, playlist_id: int) -> bool:
        """
        Delete a playlist.

        Args:
            playlist_id: Playlist ID

        Returns:
            True if deleted successfully
        """
        try:
            with self.get_session() as session:
                playlist = session.query(PlaylistDB).filter_by(id=playlist_id).first()
                if not playlist:
                    return False

                session.delete(playlist)
                session.commit()

                logger.info(f"Deleted playlist: {playlist_id}")
                return True

        except Exception as e:
            logger.error(f"Error deleting playlist: {e}")
            return False
