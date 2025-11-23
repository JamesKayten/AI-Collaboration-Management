"""
Metadata extraction service using mutagen.
Extracts ID3 tags and audio properties from music files.
"""

import os
from pathlib import Path
from typing import Dict, Optional
import logging
from mutagen import File as MutagenFile
from mutagen.mp3 import MP3
from mutagen.flac import FLAC
from mutagen.mp4 import MP4
from mutagen.oggvorbis import OggVorbis
from mutagen.wave import WAVE

logger = logging.getLogger(__name__)


class MetadataService:
    """
    Service for extracting metadata from audio files.
    Supports MP3, FLAC, MP4/M4A, OGG, WAV, and other formats.
    """

    SUPPORTED_FORMATS = {
        '.mp3', '.flac', '.m4a', '.mp4', '.ogg', '.oga', '.wav', '.aiff', '.aif'
    }

    @staticmethod
    def is_supported(file_path: str) -> bool:
        """
        Check if file format is supported.

        Args:
            file_path: Path to audio file

        Returns:
            True if format is supported
        """
        ext = Path(file_path).suffix.lower()
        return ext in MetadataService.SUPPORTED_FORMATS

    @staticmethod
    def extract_metadata(file_path: str) -> Optional[Dict]:
        """
        Extract metadata from an audio file.

        Args:
            file_path: Path to the audio file

        Returns:
            Dictionary containing metadata, or None if extraction failed
        """
        try:
            path = Path(file_path)
            if not path.exists():
                logger.error(f"File not found: {file_path}")
                return None

            if not MetadataService.is_supported(file_path):
                logger.warning(f"Unsupported file format: {file_path}")
                return None

            # Load file with mutagen
            audio = MutagenFile(file_path)
            if audio is None:
                logger.error(f"Could not read audio file: {file_path}")
                return None

            # Extract basic info
            metadata = {
                'file_path': str(path.absolute()),
                'file_size': path.stat().st_size,
                'duration': getattr(audio.info, 'length', 0.0),
                'bitrate': getattr(audio.info, 'bitrate', 0),
                'sample_rate': getattr(audio.info, 'sample_rate', 0),
            }

            # Extract tags based on file type
            tags = {}

            # Common tag mappings
            if isinstance(audio, MP3):
                tags = MetadataService._extract_id3_tags(audio)
            elif isinstance(audio, FLAC):
                tags = MetadataService._extract_vorbis_tags(audio)
            elif isinstance(audio, MP4):
                tags = MetadataService._extract_mp4_tags(audio)
            elif isinstance(audio, OggVorbis):
                tags = MetadataService._extract_vorbis_tags(audio)
            elif isinstance(audio, WAVE):
                tags = MetadataService._extract_wave_tags(audio)
            else:
                # Generic tag extraction
                tags = MetadataService._extract_generic_tags(audio)

            metadata.update(tags)

            # Use filename as title fallback
            if not metadata.get('title'):
                metadata['title'] = path.stem

            logger.info(f"Extracted metadata from: {file_path}")
            return metadata

        except Exception as e:
            logger.error(f"Error extracting metadata from {file_path}: {e}")
            return None

    @staticmethod
    def _extract_id3_tags(audio: MP3) -> Dict:
        """Extract ID3 tags from MP3 file."""
        tags = {}

        if audio.tags:
            tags['title'] = str(audio.tags.get('TIT2', [''])[0]) or None
            tags['artist'] = str(audio.tags.get('TPE1', [''])[0]) or None
            tags['album'] = str(audio.tags.get('TALB', [''])[0]) or None
            tags['genre'] = str(audio.tags.get('TCON', [''])[0]) or None

            # Year
            year_tag = audio.tags.get('TDRC') or audio.tags.get('TYER')
            if year_tag:
                try:
                    tags['year'] = int(str(year_tag[0])[:4])
                except (ValueError, IndexError):
                    pass

            # Track number
            track_tag = audio.tags.get('TRCK')
            if track_tag:
                try:
                    track_str = str(track_tag[0]).split('/')[0]
                    tags['track_number'] = int(track_str)
                except (ValueError, IndexError):
                    pass

        return tags

    @staticmethod
    def _extract_vorbis_tags(audio) -> Dict:
        """Extract Vorbis comments (FLAC, OGG)."""
        tags = {}

        if hasattr(audio, 'tags') and audio.tags:
            tags['title'] = audio.tags.get('title', [None])[0]
            tags['artist'] = audio.tags.get('artist', [None])[0]
            tags['album'] = audio.tags.get('album', [None])[0]
            tags['genre'] = audio.tags.get('genre', [None])[0]

            # Year
            date_tag = audio.tags.get('date', [None])[0]
            if date_tag:
                try:
                    tags['year'] = int(str(date_tag)[:4])
                except (ValueError, IndexError):
                    pass

            # Track number
            track_tag = audio.tags.get('tracknumber', [None])[0]
            if track_tag:
                try:
                    track_str = str(track_tag).split('/')[0]
                    tags['track_number'] = int(track_str)
                except (ValueError, IndexError):
                    pass

        return tags

    @staticmethod
    def _extract_mp4_tags(audio: MP4) -> Dict:
        """Extract MP4/M4A tags."""
        tags = {}

        if audio.tags:
            tags['title'] = audio.tags.get('\xa9nam', [None])[0]
            tags['artist'] = audio.tags.get('\xa9ART', [None])[0]
            tags['album'] = audio.tags.get('\xa9alb', [None])[0]
            tags['genre'] = audio.tags.get('\xa9gen', [None])[0]

            # Year
            year_tag = audio.tags.get('\xa9day', [None])[0]
            if year_tag:
                try:
                    tags['year'] = int(str(year_tag)[:4])
                except (ValueError, IndexError):
                    pass

            # Track number
            track_tag = audio.tags.get('trkn', [None])[0]
            if track_tag and isinstance(track_tag, tuple):
                try:
                    tags['track_number'] = int(track_tag[0])
                except (ValueError, IndexError):
                    pass

        return tags

    @staticmethod
    def _extract_wave_tags(audio: WAVE) -> Dict:
        """Extract WAVE file tags."""
        tags = {}

        if hasattr(audio, 'tags') and audio.tags:
            tags['title'] = audio.tags.get('title', [None])[0]
            tags['artist'] = audio.tags.get('artist', [None])[0]
            tags['album'] = audio.tags.get('album', [None])[0]

        return tags

    @staticmethod
    def _extract_generic_tags(audio) -> Dict:
        """Extract tags from unknown format."""
        tags = {}

        if hasattr(audio, 'tags') and audio.tags:
            # Try common tag names
            for key in audio.tags.keys():
                key_lower = key.lower()
                if 'title' in key_lower:
                    tags['title'] = str(audio.tags[key])
                elif 'artist' in key_lower:
                    tags['artist'] = str(audio.tags[key])
                elif 'album' in key_lower:
                    tags['album'] = str(audio.tags[key])
                elif 'genre' in key_lower:
                    tags['genre'] = str(audio.tags[key])

        return tags

    @staticmethod
    def scan_directory(directory: str) -> list:
        """
        Recursively scan directory for audio files.

        Args:
            directory: Path to directory to scan

        Returns:
            List of paths to audio files
        """
        audio_files = []

        try:
            path = Path(directory)
            if not path.exists() or not path.is_dir():
                logger.error(f"Invalid directory: {directory}")
                return []

            for file_path in path.rglob('*'):
                if file_path.is_file() and MetadataService.is_supported(str(file_path)):
                    audio_files.append(str(file_path.absolute()))

            logger.info(f"Found {len(audio_files)} audio files in {directory}")
            return audio_files

        except Exception as e:
            logger.error(f"Error scanning directory {directory}: {e}")
            return []
