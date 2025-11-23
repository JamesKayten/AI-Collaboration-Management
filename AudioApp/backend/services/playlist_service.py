"""
Enhanced playlist service with comprehensive playlist management.
"""

import logging
from typing import List, Optional, Dict
from datetime import datetime
from ..models.playlist import PlaylistDB
from ..models.track import TrackDB
from .database import DatabaseService

logger = logging.getLogger(__name__)


class PlaylistService:
    """
    Service for managing playlists with advanced features.
    """

    def __init__(self, db_service: DatabaseService):
        """
        Initialize playlist service.

        Args:
            db_service: Database service instance
        """
        self.db = db_service
        logger.info("PlaylistService initialized")

    def create_playlist(self, name: str, description: str = None) -> Optional[Dict]:
        """
        Create a new playlist.

        Args:
            name: Playlist name
            description: Optional description

        Returns:
            Playlist dictionary or None
        """
        try:
            playlist = self.db.create_playlist(name, description)
            if playlist:
                return playlist.to_dict()
            return None

        except Exception as e:
            logger.error(f"Error creating playlist: {e}")
            return None

    def get_playlist_with_tracks(self, playlist_id: int) -> Optional[Dict]:
        """
        Get playlist with full track listing.

        Args:
            playlist_id: Playlist ID

        Returns:
            Dictionary with playlist info and tracks
        """
        try:
            with self.db.get_session() as session:
                playlist = session.query(PlaylistDB).filter_by(id=playlist_id).first()
                if not playlist:
                    return None

                return {
                    **playlist.to_dict(),
                    'tracks': [track.to_dict() for track in playlist.tracks]
                }

        except Exception as e:
            logger.error(f"Error getting playlist with tracks: {e}")
            return None

    def add_track_to_playlist(self, playlist_id: int, track_id: int) -> bool:
        """
        Add a track to a playlist.

        Args:
            playlist_id: Playlist ID
            track_id: Track ID to add

        Returns:
            True if successful
        """
        try:
            with self.db.get_session() as session:
                playlist = session.query(PlaylistDB).filter_by(id=playlist_id).first()
                track = session.query(TrackDB).filter_by(id=track_id).first()

                if not playlist or not track:
                    return False

                # Check if track already in playlist
                if track in playlist.tracks:
                    logger.warning(f"Track {track_id} already in playlist {playlist_id}")
                    return True

                playlist.tracks.append(track)
                playlist.date_modified = datetime.utcnow()
                session.commit()

                logger.info(f"Added track {track_id} to playlist {playlist_id}")
                return True

        except Exception as e:
            logger.error(f"Error adding track to playlist: {e}")
            return False

    def remove_track_from_playlist(self, playlist_id: int, track_id: int) -> bool:
        """
        Remove a track from a playlist.

        Args:
            playlist_id: Playlist ID
            track_id: Track ID to remove

        Returns:
            True if successful
        """
        try:
            with self.db.get_session() as session:
                playlist = session.query(PlaylistDB).filter_by(id=playlist_id).first()
                track = session.query(TrackDB).filter_by(id=track_id).first()

                if not playlist or not track:
                    return False

                if track in playlist.tracks:
                    playlist.tracks.remove(track)
                    playlist.date_modified = datetime.utcnow()
                    session.commit()

                    logger.info(f"Removed track {track_id} from playlist {playlist_id}")
                    return True

                return False

        except Exception as e:
            logger.error(f"Error removing track from playlist: {e}")
            return False

    def reorder_playlist(self, playlist_id: int, track_ids: List[int]) -> bool:
        """
        Reorder tracks in a playlist.

        Args:
            playlist_id: Playlist ID
            track_ids: List of track IDs in desired order

        Returns:
            True if successful
        """
        try:
            with self.db.get_session() as session:
                playlist = session.query(PlaylistDB).filter_by(id=playlist_id).first()
                if not playlist:
                    return False

                # Clear current tracks
                playlist.tracks.clear()

                # Add tracks in new order
                for track_id in track_ids:
                    track = session.query(TrackDB).filter_by(id=track_id).first()
                    if track:
                        playlist.tracks.append(track)

                playlist.date_modified = datetime.utcnow()
                session.commit()

                logger.info(f"Reordered playlist {playlist_id}")
                return True

        except Exception as e:
            logger.error(f"Error reordering playlist: {e}")
            return False

    def update_playlist(self, playlist_id: int, name: str = None, description: str = None) -> Optional[Dict]:
        """
        Update playlist metadata.

        Args:
            playlist_id: Playlist ID
            name: New name (optional)
            description: New description (optional)

        Returns:
            Updated playlist dictionary or None
        """
        try:
            with self.db.get_session() as session:
                playlist = session.query(PlaylistDB).filter_by(id=playlist_id).first()
                if not playlist:
                    return None

                if name:
                    playlist.name = name
                if description is not None:
                    playlist.description = description

                playlist.date_modified = datetime.utcnow()
                session.commit()
                session.refresh(playlist)

                logger.info(f"Updated playlist {playlist_id}")
                return playlist.to_dict()

        except Exception as e:
            logger.error(f"Error updating playlist: {e}")
            return None

    def duplicate_playlist(self, playlist_id: int, new_name: str = None) -> Optional[Dict]:
        """
        Create a copy of a playlist.

        Args:
            playlist_id: Playlist ID to duplicate
            new_name: Name for the new playlist

        Returns:
            New playlist dictionary or None
        """
        try:
            # Get original playlist with tracks
            original = self.get_playlist_with_tracks(playlist_id)
            if not original:
                return None

            # Create new playlist
            name = new_name or f"{original['name']} (Copy)"
            new_playlist = self.create_playlist(name, original.get('description'))

            if not new_playlist:
                return None

            # Add all tracks
            for track in original['tracks']:
                self.add_track_to_playlist(new_playlist['id'], track['id'])

            logger.info(f"Duplicated playlist {playlist_id} to {new_playlist['id']}")
            return self.get_playlist_with_tracks(new_playlist['id'])

        except Exception as e:
            logger.error(f"Error duplicating playlist: {e}")
            return None

    def get_smart_playlists(self) -> Dict[str, List[Dict]]:
        """
        Generate smart playlists based on criteria.

        Returns:
            Dictionary of smart playlist categories
        """
        try:
            all_tracks = self.db.get_all_tracks()

            # Recently added (last 30 days)
            recently_added = sorted(
                [t for t in all_tracks if t.date_added],
                key=lambda t: t.date_added,
                reverse=True
            )[:50]

            # Most played
            most_played = sorted(
                all_tracks,
                key=lambda t: t.play_count or 0,
                reverse=True
            )[:50]

            # Favorites
            favorites = [t for t in all_tracks if t.favorite]

            # Recently played
            recently_played = sorted(
                [t for t in all_tracks if t.last_played],
                key=lambda t: t.last_played,
                reverse=True
            )[:50]

            return {
                'recently_added': [t.to_dict() for t in recently_added],
                'most_played': [t.to_dict() for t in most_played],
                'favorites': [t.to_dict() for t in favorites],
                'recently_played': [t.to_dict() for t in recently_played]
            }

        except Exception as e:
            logger.error(f"Error generating smart playlists: {e}")
            return {}
