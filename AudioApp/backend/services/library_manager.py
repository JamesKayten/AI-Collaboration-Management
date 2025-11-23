"""
Library manager service that coordinates database and metadata extraction.
Handles bulk import, scanning, and library management operations.
"""

import logging
from typing import List, Optional, Dict
from pathlib import Path
from .database import DatabaseService
from .metadata_service import MetadataService
from ..models.track import TrackDB

logger = logging.getLogger(__name__)


class LibraryManager:
    """
    High-level service for managing the music library.
    Coordinates between metadata extraction and database storage.
    """

    def __init__(self, db_service: DatabaseService):
        """
        Initialize library manager.

        Args:
            db_service: DatabaseService instance
        """
        self.db = db_service
        self.metadata_service = MetadataService()
        logger.info("LibraryManager initialized")

    def import_file(self, file_path: str) -> Optional[Dict]:
        """
        Import a single audio file into the library.

        Args:
            file_path: Path to audio file

        Returns:
            Track dictionary if successful, None otherwise
        """
        try:
            # Check if file exists
            if not Path(file_path).exists():
                logger.error(f"File not found: {file_path}")
                return None

            # Check if supported
            if not self.metadata_service.is_supported(file_path):
                logger.warning(f"Unsupported file format: {file_path}")
                return None

            # Extract metadata
            metadata = self.metadata_service.extract_metadata(file_path)
            if not metadata:
                logger.error(f"Failed to extract metadata: {file_path}")
                return None

            # Add to database
            track = self.db.add_track(metadata)
            if not track:
                logger.error(f"Failed to add track to database: {file_path}")
                return None

            logger.info(f"Imported: {track.title} by {track.artist}")
            return track.to_dict()

        except Exception as e:
            logger.error(f"Error importing file {file_path}: {e}")
            return None

    def import_directory(self, directory: str, recursive: bool = True) -> Dict[str, int]:
        """
        Import all audio files from a directory.

        Args:
            directory: Path to directory
            recursive: Whether to scan subdirectories

        Returns:
            Dictionary with import statistics
        """
        stats = {
            'total_found': 0,
            'imported': 0,
            'skipped': 0,
            'failed': 0
        }

        try:
            # Scan directory for audio files
            if recursive:
                audio_files = self.metadata_service.scan_directory(directory)
            else:
                # Non-recursive scan
                path = Path(directory)
                audio_files = [
                    str(f.absolute())
                    for f in path.iterdir()
                    if f.is_file() and self.metadata_service.is_supported(str(f))
                ]

            stats['total_found'] = len(audio_files)
            logger.info(f"Found {len(audio_files)} audio files in {directory}")

            # Import each file
            for file_path in audio_files:
                result = self.import_file(file_path)
                if result:
                    stats['imported'] += 1
                elif result is None:
                    stats['failed'] += 1
                else:
                    stats['skipped'] += 1

            logger.info(f"Import complete: {stats}")
            return stats

        except Exception as e:
            logger.error(f"Error importing directory {directory}: {e}")
            return stats

    def get_library_stats(self) -> Dict:
        """
        Get library statistics.

        Returns:
            Dictionary with library stats
        """
        try:
            all_tracks = self.db.get_all_tracks()

            # Calculate stats
            total_tracks = len(all_tracks)
            total_duration = sum(t.duration or 0 for t in all_tracks)
            total_size = sum(t.file_size or 0 for t in all_tracks)

            artists = set(t.artist for t in all_tracks if t.artist)
            albums = set(t.album for t in all_tracks if t.album)

            stats = {
                'total_tracks': total_tracks,
                'total_duration_seconds': total_duration,
                'total_size_bytes': total_size,
                'unique_artists': len(artists),
                'unique_albums': len(albums),
            }

            return stats

        except Exception as e:
            logger.error(f"Error getting library stats: {e}")
            return {}

    def refresh_metadata(self, track_id: int) -> Optional[Dict]:
        """
        Re-extract and update metadata for a track.

        Args:
            track_id: Track ID

        Returns:
            Updated track dictionary or None
        """
        try:
            # Get track from database
            track = self.db.get_track(track_id)
            if not track:
                logger.error(f"Track not found: {track_id}")
                return None

            # Re-extract metadata
            metadata = self.metadata_service.extract_metadata(track.file_path)
            if not metadata:
                logger.error(f"Failed to extract metadata: {track.file_path}")
                return None

            # Update database
            updated = self.db.update_track(track_id, metadata)
            if not updated:
                logger.error(f"Failed to update track: {track_id}")
                return None

            logger.info(f"Refreshed metadata for track: {track_id}")
            return updated.to_dict()

        except Exception as e:
            logger.error(f"Error refreshing metadata for track {track_id}: {e}")
            return None

    def cleanup_missing_files(self) -> int:
        """
        Remove tracks from library whose files no longer exist.

        Returns:
            Number of tracks removed
        """
        removed = 0

        try:
            all_tracks = self.db.get_all_tracks()

            for track in all_tracks:
                if not Path(track.file_path).exists():
                    if self.db.delete_track(track.id):
                        removed += 1
                        logger.info(f"Removed missing file: {track.file_path}")

            logger.info(f"Cleanup complete: removed {removed} tracks")
            return removed

        except Exception as e:
            logger.error(f"Error during cleanup: {e}")
            return removed

    def get_artists(self) -> List[str]:
        """
        Get list of all unique artists in library.

        Returns:
            List of artist names
        """
        try:
            all_tracks = self.db.get_all_tracks()
            artists = sorted(set(t.artist for t in all_tracks if t.artist))
            return artists

        except Exception as e:
            logger.error(f"Error getting artists: {e}")
            return []

    def get_albums(self, artist: str = None) -> List[str]:
        """
        Get list of albums, optionally filtered by artist.

        Args:
            artist: Optional artist name to filter by

        Returns:
            List of album names
        """
        try:
            all_tracks = self.db.get_all_tracks()

            if artist:
                albums = [t.album for t in all_tracks if t.artist == artist and t.album]
            else:
                albums = [t.album for t in all_tracks if t.album]

            return sorted(set(albums))

        except Exception as e:
            logger.error(f"Error getting albums: {e}")
            return []

    def get_tracks_by_artist(self, artist: str) -> List[Dict]:
        """
        Get all tracks by a specific artist.

        Args:
            artist: Artist name

        Returns:
            List of track dictionaries
        """
        try:
            all_tracks = self.db.get_all_tracks()
            tracks = [t.to_dict() for t in all_tracks if t.artist == artist]
            return tracks

        except Exception as e:
            logger.error(f"Error getting tracks by artist: {e}")
            return []

    def get_tracks_by_album(self, album: str) -> List[Dict]:
        """
        Get all tracks from a specific album.

        Args:
            album: Album name

        Returns:
            List of track dictionaries
        """
        try:
            all_tracks = self.db.get_all_tracks()
            tracks = [t.to_dict() for t in all_tracks if t.album == album]

            # Sort by track number
            tracks.sort(key=lambda t: t.get('track_number') or 999)
            return tracks

        except Exception as e:
            logger.error(f"Error getting tracks by album: {e}")
            return []
