"""
Track model for music library management.
"""

from sqlalchemy import Column, Integer, String, Float, DateTime, Boolean
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
from pydantic import BaseModel
from typing import Optional

Base = declarative_base()


class TrackDB(Base):
    """SQLAlchemy model for music tracks."""

    __tablename__ = "tracks"

    id = Column(Integer, primary_key=True, index=True)
    file_path = Column(String, unique=True, nullable=False, index=True)
    title = Column(String, index=True)
    artist = Column(String, index=True)
    album = Column(String, index=True)
    genre = Column(String)
    year = Column(Integer)
    duration = Column(Float)  # in seconds
    track_number = Column(Integer)
    bitrate = Column(Integer)
    sample_rate = Column(Integer)
    file_size = Column(Integer)
    date_added = Column(DateTime, default=datetime.utcnow)
    last_played = Column(DateTime, nullable=True)
    play_count = Column(Integer, default=0)
    favorite = Column(Boolean, default=False)

    def to_dict(self):
        """Convert track to dictionary."""
        return {
            "id": self.id,
            "file_path": self.file_path,
            "title": self.title,
            "artist": self.artist,
            "album": self.album,
            "genre": self.genre,
            "year": self.year,
            "duration": self.duration,
            "track_number": self.track_number,
            "bitrate": self.bitrate,
            "sample_rate": self.sample_rate,
            "file_size": self.file_size,
            "date_added": self.date_added.isoformat() if self.date_added else None,
            "last_played": self.last_played.isoformat() if self.last_played else None,
            "play_count": self.play_count,
            "favorite": self.favorite,
        }


class Track(BaseModel):
    """Pydantic model for API requests/responses."""

    id: Optional[int] = None
    file_path: str
    title: Optional[str] = None
    artist: Optional[str] = None
    album: Optional[str] = None
    genre: Optional[str] = None
    year: Optional[int] = None
    duration: Optional[float] = None
    track_number: Optional[int] = None
    bitrate: Optional[int] = None
    sample_rate: Optional[int] = None
    file_size: Optional[int] = None
    date_added: Optional[datetime] = None
    last_played: Optional[datetime] = None
    play_count: int = 0
    favorite: bool = False

    class Config:
        from_attributes = True


class PlaybackState(BaseModel):
    """Current playback state."""

    is_playing: bool = False
    current_track: Optional[Track] = None
    position: float = 0.0  # Current position in seconds
    volume: float = 1.0  # 0.0 to 1.0
    is_shuffled: bool = False
    repeat_mode: str = "none"  # none, one, all
