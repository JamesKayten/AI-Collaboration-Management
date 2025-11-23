"""
Album artwork extraction and caching service.
Extracts cover art from audio files and provides caching.
"""

import logging
import hashlib
from pathlib import Path
from typing import Optional
import base64
from mutagen import File as MutagenFile
from mutagen.id3 import APIC
from mutagen.mp4 import MP4Cover
from mutagen.flac import Picture

logger = logging.getLogger(__name__)


class ArtworkService:
    """
    Service for extracting and caching album artwork.
    """

    def __init__(self, cache_dir: str = None):
        """
        Initialize artwork service.

        Args:
            cache_dir: Directory to cache artwork files
        """
        if cache_dir is None:
            cache_dir = str(Path.home() / '.audioapp' / 'artwork')

        self.cache_dir = Path(cache_dir)
        self.cache_dir.mkdir(parents=True, exist_ok=True)
        logger.info(f"Artwork cache directory: {self.cache_dir}")

    def extract_artwork(self, file_path: str) -> Optional[bytes]:
        """
        Extract album artwork from an audio file.

        Args:
            file_path: Path to audio file

        Returns:
            Artwork bytes if found, None otherwise
        """
        try:
            audio = MutagenFile(file_path)
            if audio is None:
                return None

            # MP3 files (ID3 tags)
            if hasattr(audio, 'tags') and audio.tags:
                # ID3 tags (MP3)
                if hasattr(audio.tags, 'getall'):
                    for tag in audio.tags.getall('APIC'):
                        if isinstance(tag, APIC):
                            return tag.data

                # MP4/M4A files
                if 'covr' in audio.tags:
                    cover = audio.tags['covr'][0]
                    if isinstance(cover, MP4Cover):
                        return bytes(cover)
                    return cover

            # FLAC files
            if hasattr(audio, 'pictures') and audio.pictures:
                return audio.pictures[0].data

            # Vorbis comments (OGG)
            if hasattr(audio, 'tags') and 'metadata_block_picture' in audio.tags:
                pic_data = base64.b64decode(audio.tags['metadata_block_picture'][0])
                picture = Picture(pic_data)
                return picture.data

            return None

        except Exception as e:
            logger.error(f"Error extracting artwork from {file_path}: {e}")
            return None

    def get_artwork_hash(self, file_path: str) -> str:
        """
        Generate a hash for the artwork cache key.

        Args:
            file_path: Path to audio file

        Returns:
            MD5 hash of the file path
        """
        return hashlib.md5(file_path.encode()).hexdigest()

    def get_cached_artwork(self, file_path: str) -> Optional[str]:
        """
        Get cached artwork path if it exists.

        Args:
            file_path: Path to audio file

        Returns:
            Path to cached artwork file, or None if not cached
        """
        cache_hash = self.get_artwork_hash(file_path)
        cache_file = self.cache_dir / f"{cache_hash}.jpg"

        if cache_file.exists():
            return str(cache_file)

        return None

    def cache_artwork(self, file_path: str, artwork_data: bytes) -> Optional[str]:
        """
        Cache artwork to disk.

        Args:
            file_path: Path to audio file
            artwork_data: Raw artwork bytes

        Returns:
            Path to cached file, or None if caching failed
        """
        try:
            cache_hash = self.get_artwork_hash(file_path)
            cache_file = self.cache_dir / f"{cache_hash}.jpg"

            cache_file.write_bytes(artwork_data)
            logger.info(f"Cached artwork for {file_path}")

            return str(cache_file)

        except Exception as e:
            logger.error(f"Error caching artwork: {e}")
            return None

    def get_artwork(self, file_path: str, use_cache: bool = True) -> Optional[dict]:
        """
        Get artwork for a file, using cache if available.

        Args:
            file_path: Path to audio file
            use_cache: Whether to use cached artwork

        Returns:
            Dictionary with artwork path and base64 data, or None
        """
        # Check cache first
        if use_cache:
            cached_path = self.get_cached_artwork(file_path)
            if cached_path:
                try:
                    artwork_data = Path(cached_path).read_bytes()
                    return {
                        'path': cached_path,
                        'data': base64.b64encode(artwork_data).decode('utf-8'),
                        'cached': True
                    }
                except Exception as e:
                    logger.error(f"Error reading cached artwork: {e}")

        # Extract from file
        artwork_data = self.extract_artwork(file_path)
        if not artwork_data:
            return None

        # Cache it
        cached_path = self.cache_artwork(file_path, artwork_data)

        return {
            'path': cached_path,
            'data': base64.b64encode(artwork_data).decode('utf-8'),
            'cached': False
        }

    def clear_cache(self) -> int:
        """
        Clear all cached artwork.

        Returns:
            Number of files deleted
        """
        count = 0
        try:
            for file in self.cache_dir.glob('*.jpg'):
                file.unlink()
                count += 1
            logger.info(f"Cleared {count} cached artwork files")
        except Exception as e:
            logger.error(f"Error clearing cache: {e}")

        return count

    def get_cache_size(self) -> int:
        """
        Get total size of cached artwork in bytes.

        Returns:
            Total cache size in bytes
        """
        total_size = 0
        try:
            for file in self.cache_dir.glob('*.jpg'):
                total_size += file.stat().st_size
        except Exception as e:
            logger.error(f"Error calculating cache size: {e}")

        return total_size
