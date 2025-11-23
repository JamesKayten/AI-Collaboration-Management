"""
Playlist models for library management.
"""

from sqlalchemy import Column, Integer, String, DateTime, Table, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from pydantic import BaseModel
from typing import List, Optional
from .track import Base

# Association table for many-to-many relationship
playlist_tracks = Table(
    'playlist_tracks',
    Base.metadata,
    Column('playlist_id', Integer, ForeignKey('playlists.id')),
    Column('track_id', Integer, ForeignKey('tracks.id')),
    Column('position', Integer, nullable=False),
    Column('date_added', DateTime, default=datetime.utcnow)
)


class PlaylistDB(Base):
    """SQLAlchemy model for playlists."""

    __tablename__ = "playlists"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False, index=True)
    description = Column(String, nullable=True)
    date_created = Column(DateTime, default=datetime.utcnow)
    date_modified = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Many-to-many relationship with tracks
    tracks = relationship("TrackDB", secondary=playlist_tracks, backref="playlists")

    def to_dict(self):
        """Convert playlist to dictionary."""
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "date_created": self.date_created.isoformat() if self.date_created else None,
            "date_modified": self.date_modified.isoformat() if self.date_modified else None,
            "track_count": len(self.tracks),
        }


class Playlist(BaseModel):
    """Pydantic model for API requests/responses."""

    id: Optional[int] = None
    name: str
    description: Optional[str] = None
    date_created: Optional[datetime] = None
    date_modified: Optional[datetime] = None
    track_count: int = 0

    class Config:
        from_attributes = True


class PlaylistWithTracks(Playlist):
    """Playlist model with full track listing."""

    track_ids: List[int] = []
