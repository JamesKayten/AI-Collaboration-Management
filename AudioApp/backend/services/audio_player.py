"""
Audio playback service using pygame mixer.
Handles audio file playback, volume control, and playback state.
"""

import pygame
import threading
import time
from pathlib import Path
from typing import Optional, Callable
import logging

logger = logging.getLogger(__name__)


class AudioPlayer:
    """
    Audio player using pygame mixer for cross-platform audio playback.
    Supports MP3, OGG, WAV, and other formats supported by SDL_mixer.
    """

    def __init__(self):
        """Initialize the audio player."""
        pygame.mixer.init(frequency=44100, size=-16, channels=2, buffer=2048)
        self.current_file: Optional[str] = None
        self.is_playing: bool = False
        self.is_paused: bool = False
        self.volume: float = 0.7
        self.duration: float = 0.0
        self._position_offset: float = 0.0
        self._on_track_end: Optional[Callable] = None
        self._monitor_thread: Optional[threading.Thread] = None
        self._stop_monitor = threading.Event()

        pygame.mixer.music.set_volume(self.volume)
        logger.info("AudioPlayer initialized")

    def load(self, file_path: str) -> bool:
        """
        Load an audio file for playback.

        Args:
            file_path: Path to the audio file

        Returns:
            True if loaded successfully, False otherwise
        """
        try:
            path = Path(file_path)
            if not path.exists():
                logger.error(f"File not found: {file_path}")
                return False

            pygame.mixer.music.load(str(path))
            self.current_file = file_path
            self.is_playing = False
            self.is_paused = False
            self._position_offset = 0.0

            # Get duration (note: pygame doesn't provide duration directly)
            # We'll need to use mutagen for this in metadata service

            logger.info(f"Loaded audio file: {file_path}")
            return True

        except Exception as e:
            logger.error(f"Error loading audio file: {e}")
            return False

    def play(self, start_position: float = 0.0) -> bool:
        """
        Start playback from the current or specified position.

        Args:
            start_position: Position in seconds to start from

        Returns:
            True if playback started successfully
        """
        try:
            if self.current_file is None:
                logger.warning("No file loaded")
                return False

            if self.is_paused:
                pygame.mixer.music.unpause()
                self.is_paused = False
            else:
                pygame.mixer.music.play(start=start_position)
                self._position_offset = start_position

            self.is_playing = True
            self._start_monitor()

            logger.info(f"Started playback: {self.current_file}")
            return True

        except Exception as e:
            logger.error(f"Error starting playback: {e}")
            return False

    def pause(self) -> bool:
        """
        Pause playback.

        Returns:
            True if paused successfully
        """
        try:
            if self.is_playing and not self.is_paused:
                pygame.mixer.music.pause()
                self.is_paused = True
                logger.info("Playback paused")
                return True
            return False

        except Exception as e:
            logger.error(f"Error pausing playback: {e}")
            return False

    def stop(self) -> bool:
        """
        Stop playback completely.

        Returns:
            True if stopped successfully
        """
        try:
            pygame.mixer.music.stop()
            self.is_playing = False
            self.is_paused = False
            self._position_offset = 0.0
            self._stop_monitor_thread()

            logger.info("Playback stopped")
            return True

        except Exception as e:
            logger.error(f"Error stopping playback: {e}")
            return False

    def seek(self, position: float) -> bool:
        """
        Seek to a specific position in the track.

        Args:
            position: Position in seconds

        Returns:
            True if seek was successful
        """
        try:
            was_playing = self.is_playing and not self.is_paused

            # Stop current playback
            pygame.mixer.music.stop()

            # Start from new position
            if was_playing:
                pygame.mixer.music.play(start=position)
                self._position_offset = position
                self.is_playing = True
                self.is_paused = False
            else:
                self._position_offset = position

            logger.info(f"Seeked to position: {position}s")
            return True

        except Exception as e:
            logger.error(f"Error seeking: {e}")
            return False

    def set_volume(self, volume: float) -> bool:
        """
        Set playback volume.

        Args:
            volume: Volume level (0.0 to 1.0)

        Returns:
            True if volume was set successfully
        """
        try:
            volume = max(0.0, min(1.0, volume))
            pygame.mixer.music.set_volume(volume)
            self.volume = volume
            logger.info(f"Volume set to: {volume}")
            return True

        except Exception as e:
            logger.error(f"Error setting volume: {e}")
            return False

    def get_position(self) -> float:
        """
        Get current playback position.

        Returns:
            Current position in seconds
        """
        if not self.is_playing:
            return self._position_offset

        # pygame.mixer.music.get_pos() returns milliseconds since start
        pos_ms = pygame.mixer.music.get_pos()
        if pos_ms >= 0:
            return self._position_offset + (pos_ms / 1000.0)
        return self._position_offset

    def set_on_track_end(self, callback: Callable):
        """
        Set callback to be called when track ends.

        Args:
            callback: Function to call when track finishes
        """
        self._on_track_end = callback

    def _start_monitor(self):
        """Start monitoring thread for track end detection."""
        if self._monitor_thread is None or not self._monitor_thread.is_alive():
            self._stop_monitor.clear()
            self._monitor_thread = threading.Thread(target=self._monitor_playback, daemon=True)
            self._monitor_thread.start()

    def _stop_monitor_thread(self):
        """Stop the monitoring thread."""
        self._stop_monitor.set()
        if self._monitor_thread is not None:
            self._monitor_thread.join(timeout=1.0)

    def _monitor_playback(self):
        """Monitor playback to detect when track ends."""
        while not self._stop_monitor.is_set():
            if self.is_playing and not self.is_paused:
                if not pygame.mixer.music.get_busy():
                    # Track has ended
                    self.is_playing = False
                    if self._on_track_end:
                        try:
                            self._on_track_end()
                        except Exception as e:
                            logger.error(f"Error in track end callback: {e}")
                    break
            time.sleep(0.1)

    def cleanup(self):
        """Clean up resources."""
        self.stop()
        pygame.mixer.quit()
        logger.info("AudioPlayer cleaned up")
