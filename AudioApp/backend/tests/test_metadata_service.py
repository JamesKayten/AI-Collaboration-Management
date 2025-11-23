"""
Tests for metadata extraction service.
"""

import pytest
from pathlib import Path
from backend.services.metadata_service import MetadataService


class TestMetadataService:
    """Test suite for MetadataService."""

    def test_is_supported_valid_formats(self):
        """Test that supported formats are recognized."""
        service = MetadataService()

        assert service.is_supported("test.mp3")
        assert service.is_supported("test.flac")
        assert service.is_supported("test.m4a")
        assert service.is_supported("test.ogg")
        assert service.is_supported("test.wav")
        assert service.is_supported("test.aiff")

    def test_is_supported_invalid_formats(self):
        """Test that unsupported formats are rejected."""
        service = MetadataService()

        assert not service.is_supported("test.txt")
        assert not service.is_supported("test.pdf")
        assert not service.is_supported("test.jpg")
        assert not service.is_supported("test.zip")

    def test_is_supported_case_insensitive(self):
        """Test that format detection is case insensitive."""
        service = MetadataService()

        assert service.is_supported("test.MP3")
        assert service.is_supported("test.FLAC")
        assert service.is_supported("test.M4A")

    def test_extract_metadata_nonexistent_file(self):
        """Test that extraction fails gracefully for nonexistent files."""
        service = MetadataService()

        result = service.extract_metadata("/nonexistent/path/to/file.mp3")
        assert result is None

    def test_scan_directory_empty(self):
        """Test scanning an empty directory."""
        service = MetadataService()
        import tempfile

        with tempfile.TemporaryDirectory() as tmpdir:
            files = service.scan_directory(tmpdir)
            assert files == []

    def test_scan_directory_nonexistent(self):
        """Test scanning a nonexistent directory."""
        service = MetadataService()

        files = service.scan_directory("/nonexistent/directory")
        assert files == []
