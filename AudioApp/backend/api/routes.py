"""
FastAPI routes for AudioApp backend.
Provides REST API endpoints for the SwiftUI frontend.
"""

from fastapi import APIRouter, HTTPException, Query
from typing import List, Optional
from pydantic import BaseModel

from ..models.track import Track, PlaybackState
from ..models.playlist import Playlist, PlaylistWithTracks
from ..services.player_manager import RepeatMode

router = APIRouter()

# These will be injected by main.py
player_manager = None
library_manager = None
db_service = None


# Request models

class PlayRequest(BaseModel):
    """Request to play a track."""
    track_id: Optional[int] = None
    position: float = 0.0


class SeekRequest(BaseModel):
    """Request to seek to a position."""
    position: float


class VolumeRequest(BaseModel):
    """Request to set volume."""
    volume: float


class QueueRequest(BaseModel):
    """Request to set playback queue."""
    track_ids: List[int]
    start_index: int = 0


class ShuffleRequest(BaseModel):
    """Request to set shuffle mode."""
    enabled: bool


class RepeatRequest(BaseModel):
    """Request to set repeat mode."""
    mode: str  # "none", "one", "all"


class ImportFileRequest(BaseModel):
    """Request to import a file."""
    file_path: str


class ImportDirectoryRequest(BaseModel):
    """Request to import a directory."""
    directory_path: str
    recursive: bool = True


class CreatePlaylistRequest(BaseModel):
    """Request to create a playlist."""
    name: str
    description: Optional[str] = None


# Player endpoints

@router.get("/player/state", response_model=dict)
async def get_player_state():
    """Get current playback state."""
    try:
        state = player_manager.get_state()
        return state
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/player/play")
async def play_track(request: PlayRequest):
    """Start playback of a track."""
    try:
        success = player_manager.play(request.track_id, request.position)
        if not success:
            raise HTTPException(status_code=400, detail="Failed to start playback")
        return {"status": "playing"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/player/pause")
async def pause_playback():
    """Pause playback."""
    try:
        success = player_manager.pause()
        if not success:
            raise HTTPException(status_code=400, detail="Failed to pause")
        return {"status": "paused"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/player/stop")
async def stop_playback():
    """Stop playback."""
    try:
        success = player_manager.stop()
        if not success:
            raise HTTPException(status_code=400, detail="Failed to stop")
        return {"status": "stopped"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/player/next")
async def next_track():
    """Skip to next track."""
    try:
        success = player_manager.next()
        if not success:
            raise HTTPException(status_code=400, detail="Failed to skip to next track")
        return {"status": "success"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/player/previous")
async def previous_track():
    """Skip to previous track."""
    try:
        success = player_manager.previous()
        if not success:
            raise HTTPException(status_code=400, detail="Failed to skip to previous track")
        return {"status": "success"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/player/seek")
async def seek_position(request: SeekRequest):
    """Seek to a position in the current track."""
    try:
        success = player_manager.seek(request.position)
        if not success:
            raise HTTPException(status_code=400, detail="Failed to seek")
        return {"status": "success"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/player/volume")
async def set_volume(request: VolumeRequest):
    """Set playback volume."""
    try:
        success = player_manager.set_volume(request.volume)
        if not success:
            raise HTTPException(status_code=400, detail="Failed to set volume")
        return {"status": "success", "volume": request.volume}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/player/queue")
async def set_queue(request: QueueRequest):
    """Set the playback queue."""
    try:
        success = player_manager.set_queue(request.track_ids, request.start_index)
        if not success:
            raise HTTPException(status_code=400, detail="Failed to set queue")
        return {"status": "success", "queue_length": len(request.track_ids)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/player/queue/add/{track_id}")
async def add_to_queue(track_id: int):
    """Add a track to the queue."""
    try:
        success = player_manager.add_to_queue(track_id)
        if not success:
            raise HTTPException(status_code=400, detail="Failed to add to queue")
        return {"status": "success"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/player/queue/clear")
async def clear_queue():
    """Clear the playback queue."""
    try:
        success = player_manager.clear_queue()
        if not success:
            raise HTTPException(status_code=400, detail="Failed to clear queue")
        return {"status": "success"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/player/shuffle")
async def set_shuffle(request: ShuffleRequest):
    """Set shuffle mode."""
    try:
        success = player_manager.set_shuffle(request.enabled)
        if not success:
            raise HTTPException(status_code=400, detail="Failed to set shuffle")
        return {"status": "success", "shuffled": request.enabled}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/player/repeat")
async def set_repeat(request: RepeatRequest):
    """Set repeat mode."""
    try:
        mode = RepeatMode(request.mode)
        success = player_manager.set_repeat_mode(mode)
        if not success:
            raise HTTPException(status_code=400, detail="Failed to set repeat mode")
        return {"status": "success", "repeat_mode": request.mode}
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid repeat mode")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# Library endpoints

@router.get("/library/tracks", response_model=List[dict])
async def get_all_tracks(
    limit: Optional[int] = Query(None, ge=1),
    offset: int = Query(0, ge=0)
):
    """Get all tracks in the library."""
    try:
        tracks = db_service.get_all_tracks(limit=limit, offset=offset)
        return [track.to_dict() for track in tracks]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/library/tracks/{track_id}", response_model=dict)
async def get_track(track_id: int):
    """Get a specific track by ID."""
    try:
        track = db_service.get_track(track_id)
        if not track:
            raise HTTPException(status_code=404, detail="Track not found")
        return track.to_dict()
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/library/search", response_model=List[dict])
async def search_tracks(q: str = Query(..., min_length=1)):
    """Search for tracks by title, artist, or album."""
    try:
        tracks = db_service.search_tracks(q)
        return [track.to_dict() for track in tracks]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/library/import/file")
async def import_file(request: ImportFileRequest):
    """Import a single audio file."""
    try:
        result = library_manager.import_file(request.file_path)
        if not result:
            raise HTTPException(status_code=400, detail="Failed to import file")
        return {"status": "success", "track": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/library/import/directory")
async def import_directory(request: ImportDirectoryRequest):
    """Import all audio files from a directory."""
    try:
        stats = library_manager.import_directory(
            request.directory_path,
            recursive=request.recursive
        )
        return {"status": "success", "stats": stats}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/library/stats")
async def get_library_stats():
    """Get library statistics."""
    try:
        stats = library_manager.get_library_stats()
        return stats
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/library/artists", response_model=List[str])
async def get_artists():
    """Get list of all artists."""
    try:
        artists = library_manager.get_artists()
        return artists
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/library/albums", response_model=List[str])
async def get_albums(artist: Optional[str] = None):
    """Get list of albums, optionally filtered by artist."""
    try:
        albums = library_manager.get_albums(artist)
        return albums
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/library/artists/{artist}/tracks", response_model=List[dict])
async def get_tracks_by_artist(artist: str):
    """Get all tracks by a specific artist."""
    try:
        tracks = library_manager.get_tracks_by_artist(artist)
        return tracks
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/library/albums/{album}/tracks", response_model=List[dict])
async def get_tracks_by_album(album: str):
    """Get all tracks from a specific album."""
    try:
        tracks = library_manager.get_tracks_by_album(album)
        return tracks
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/library/tracks/{track_id}")
async def delete_track(track_id: int):
    """Delete a track from the library."""
    try:
        success = db_service.delete_track(track_id)
        if not success:
            raise HTTPException(status_code=404, detail="Track not found")
        return {"status": "success"}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/library/cleanup")
async def cleanup_library():
    """Remove tracks whose files no longer exist."""
    try:
        removed = library_manager.cleanup_missing_files()
        return {"status": "success", "removed_count": removed}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# Playlist endpoints

@router.get("/playlists", response_model=List[dict])
async def get_playlists():
    """Get all playlists."""
    try:
        playlists = db_service.get_all_playlists()
        return [p.to_dict() for p in playlists]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/playlists")
async def create_playlist(request: CreatePlaylistRequest):
    """Create a new playlist."""
    try:
        playlist = db_service.create_playlist(request.name, request.description)
        if not playlist:
            raise HTTPException(status_code=400, detail="Failed to create playlist")
        return playlist.to_dict()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/playlists/{playlist_id}", response_model=dict)
async def get_playlist(playlist_id: int):
    """Get a specific playlist."""
    try:
        playlist = db_service.get_playlist(playlist_id)
        if not playlist:
            raise HTTPException(status_code=404, detail="Playlist not found")
        return playlist.to_dict()
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/playlists/{playlist_id}")
async def delete_playlist(playlist_id: int):
    """Delete a playlist."""
    try:
        success = db_service.delete_playlist(playlist_id)
        if not success:
            raise HTTPException(status_code=404, detail="Playlist not found")
        return {"status": "success"}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# Health check

@router.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy", "service": "AudioApp Backend"}
