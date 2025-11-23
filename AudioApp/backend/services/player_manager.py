"""
Player manager service that coordinates audio playback with library management.
Handles playback queue, state management, and playback logic.
"""

import logging
from typing import List, Optional, Dict, Callable
from enum import Enum
import random
from .audio_player import AudioPlayer
from .database import DatabaseService

logger = logging.getLogger(__name__)


class RepeatMode(str, Enum):
    """Repeat mode options."""
    NONE = "none"
    ONE = "one"
    ALL = "all"


class PlayerManager:
    """
    High-level player manager that coordinates playback.
    Manages queue, shuffle, repeat, and playback state.
    """

    def __init__(self, db_service: DatabaseService):
        """
        Initialize player manager.

        Args:
            db_service: DatabaseService instance
        """
        self.audio_player = AudioPlayer()
        self.db = db_service

        # Playback state
        self.current_track_id: Optional[int] = None
        self.queue: List[int] = []  # List of track IDs
        self.queue_position: int = -1
        self.is_shuffled: bool = False
        self.repeat_mode: RepeatMode = RepeatMode.NONE
        self.original_queue: List[int] = []  # For unshuffling

        # Callbacks
        self._on_track_change: Optional[Callable] = None

        # Set up audio player callbacks
        self.audio_player.set_on_track_end(self._handle_track_end)

        logger.info("PlayerManager initialized")

    def set_on_track_change(self, callback: Callable):
        """
        Set callback for when current track changes.

        Args:
            callback: Function to call when track changes
        """
        self._on_track_change = callback

    def load_track(self, track_id: int) -> bool:
        """
        Load a track for playback.

        Args:
            track_id: Track ID to load

        Returns:
            True if loaded successfully
        """
        try:
            track = self.db.get_track(track_id)
            if not track:
                logger.error(f"Track not found: {track_id}")
                return False

            if self.audio_player.load(track.file_path):
                self.current_track_id = track_id
                logger.info(f"Loaded track: {track.title}")

                if self._on_track_change:
                    self._on_track_change(track_id)

                return True

            return False

        except Exception as e:
            logger.error(f"Error loading track {track_id}: {e}")
            return False

    def play(self, track_id: int = None, position: float = 0.0) -> bool:
        """
        Start playback of a track.

        Args:
            track_id: Optional track ID to play. If None, plays current track.
            position: Position in seconds to start from

        Returns:
            True if playback started successfully
        """
        try:
            if track_id is not None:
                if not self.load_track(track_id):
                    return False

            if self.current_track_id is None:
                logger.warning("No track loaded")
                return False

            return self.audio_player.play(position)

        except Exception as e:
            logger.error(f"Error starting playback: {e}")
            return False

    def pause(self) -> bool:
        """Pause playback."""
        return self.audio_player.pause()

    def stop(self) -> bool:
        """Stop playback."""
        return self.audio_player.stop()

    def next(self) -> bool:
        """Skip to next track in queue."""
        try:
            if not self.queue or self.queue_position < 0:
                logger.warning("No queue available")
                return False

            # Handle repeat one mode
            if self.repeat_mode == RepeatMode.ONE:
                return self.play(position=0.0)

            # Move to next position
            next_position = self.queue_position + 1

            # Handle end of queue
            if next_position >= len(self.queue):
                if self.repeat_mode == RepeatMode.ALL:
                    next_position = 0
                else:
                    logger.info("End of queue reached")
                    self.stop()
                    return False

            self.queue_position = next_position
            next_track_id = self.queue[self.queue_position]

            return self.play(next_track_id)

        except Exception as e:
            logger.error(f"Error skipping to next track: {e}")
            return False

    def previous(self) -> bool:
        """Skip to previous track in queue."""
        try:
            if not self.queue or self.queue_position < 0:
                logger.warning("No queue available")
                return False

            # If more than 3 seconds into track, restart it
            if self.audio_player.get_position() > 3.0:
                return self.play(position=0.0)

            # Move to previous position
            prev_position = self.queue_position - 1

            # Handle beginning of queue
            if prev_position < 0:
                if self.repeat_mode == RepeatMode.ALL:
                    prev_position = len(self.queue) - 1
                else:
                    logger.info("Beginning of queue reached")
                    return self.play(position=0.0)

            self.queue_position = prev_position
            prev_track_id = self.queue[self.queue_position]

            return self.play(prev_track_id)

        except Exception as e:
            logger.error(f"Error skipping to previous track: {e}")
            return False

    def seek(self, position: float) -> bool:
        """
        Seek to a position in the current track.

        Args:
            position: Position in seconds

        Returns:
            True if seek was successful
        """
        return self.audio_player.seek(position)

    def set_volume(self, volume: float) -> bool:
        """
        Set playback volume.

        Args:
            volume: Volume level (0.0 to 1.0)

        Returns:
            True if volume was set
        """
        return self.audio_player.set_volume(volume)

    def set_queue(self, track_ids: List[int], start_index: int = 0) -> bool:
        """
        Set the playback queue.

        Args:
            track_ids: List of track IDs
            start_index: Index to start playback from

        Returns:
            True if queue was set
        """
        try:
            self.queue = track_ids.copy()
            self.original_queue = track_ids.copy()
            self.queue_position = start_index

            if self.is_shuffled:
                self._shuffle_queue()

            logger.info(f"Queue set with {len(track_ids)} tracks")
            return True

        except Exception as e:
            logger.error(f"Error setting queue: {e}")
            return False

    def add_to_queue(self, track_id: int) -> bool:
        """
        Add a track to the end of the queue.

        Args:
            track_id: Track ID to add

        Returns:
            True if added successfully
        """
        try:
            self.queue.append(track_id)
            self.original_queue.append(track_id)
            logger.info(f"Added track {track_id} to queue")
            return True

        except Exception as e:
            logger.error(f"Error adding to queue: {e}")
            return False

    def clear_queue(self) -> bool:
        """Clear the playback queue."""
        self.queue = []
        self.original_queue = []
        self.queue_position = -1
        logger.info("Queue cleared")
        return True

    def set_shuffle(self, enabled: bool) -> bool:
        """
        Enable or disable shuffle mode.

        Args:
            enabled: Whether to enable shuffle

        Returns:
            True if successful
        """
        try:
            if enabled == self.is_shuffled:
                return True

            self.is_shuffled = enabled

            if enabled:
                self._shuffle_queue()
            else:
                self._unshuffle_queue()

            logger.info(f"Shuffle {'enabled' if enabled else 'disabled'}")
            return True

        except Exception as e:
            logger.error(f"Error setting shuffle: {e}")
            return False

    def set_repeat_mode(self, mode: RepeatMode) -> bool:
        """
        Set repeat mode.

        Args:
            mode: Repeat mode (none, one, all)

        Returns:
            True if successful
        """
        try:
            self.repeat_mode = mode
            logger.info(f"Repeat mode set to: {mode}")
            return True

        except Exception as e:
            logger.error(f"Error setting repeat mode: {e}")
            return False

    def get_state(self) -> Dict:
        """
        Get current playback state.

        Returns:
            Dictionary containing playback state
        """
        current_track = None
        if self.current_track_id:
            track = self.db.get_track(self.current_track_id)
            if track:
                current_track = track.to_dict()

        return {
            'is_playing': self.audio_player.is_playing,
            'is_paused': self.audio_player.is_paused,
            'current_track': current_track,
            'position': self.audio_player.get_position(),
            'volume': self.audio_player.volume,
            'is_shuffled': self.is_shuffled,
            'repeat_mode': self.repeat_mode.value,
            'queue_length': len(self.queue),
            'queue_position': self.queue_position,
        }

    def _shuffle_queue(self):
        """Shuffle the queue while preserving current track."""
        if not self.queue:
            return

        current_track_id = None
        if 0 <= self.queue_position < len(self.queue):
            current_track_id = self.queue[self.queue_position]

        # Shuffle
        shuffled = self.queue.copy()
        random.shuffle(shuffled)

        # Move current track to front if it exists
        if current_track_id and current_track_id in shuffled:
            shuffled.remove(current_track_id)
            shuffled.insert(0, current_track_id)
            self.queue_position = 0

        self.queue = shuffled

    def _unshuffle_queue(self):
        """Restore original queue order."""
        self.queue = self.original_queue.copy()

        # Try to maintain current track position
        if self.current_track_id and self.current_track_id in self.queue:
            self.queue_position = self.queue.index(self.current_track_id)

    def _handle_track_end(self):
        """Handle when current track finishes."""
        logger.info("Track ended")

        # Update play count
        if self.current_track_id:
            from datetime import datetime
            self.db.update_track(self.current_track_id, {
                'play_count': self.db.get_track(self.current_track_id).play_count + 1,
                'last_played': datetime.utcnow()
            })

        # Auto-advance to next track
        self.next()

    def cleanup(self):
        """Clean up resources."""
        self.audio_player.cleanup()
        logger.info("PlayerManager cleaned up")
