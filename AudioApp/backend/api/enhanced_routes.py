"""
Enhanced API routes with WebSocket, artwork, and advanced playlist features.
"""

from fastapi import APIRouter, HTTPException, WebSocket, WebSocketDisconnect
from typing import List

router = APIRouter()

# Services will be injected by main.py
artwork_service = None
playlist_service = None
ws_manager = None


# WebSocket endpoint for real-time updates
@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    """
    WebSocket endpoint for real-time playback and library updates.
    """
    await ws_manager.connect(websocket)
    try:
        while True:
            # Keep connection alive and handle incoming messages
            data = await websocket.receive_text()
            # Echo back or process client messages if needed
            await websocket.send_json({"status": "connected"})
    except WebSocketDisconnect:
        await ws_manager.disconnect(websocket)


# Artwork endpoints
@router.get("/artwork/{track_id}")
async def get_track_artwork(track_id: int):
    """Get artwork for a specific track."""
    try:
        from ..services.database import DatabaseService
        # Get track file path
        track = db_service.get_track(track_id)
        if not track:
            raise HTTPException(status_code=404, detail="Track not found")

        artwork = artwork_service.get_artwork(track.file_path)
        if not artwork:
            raise HTTPException(status_code=404, detail="No artwork found")

        return artwork

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/artwork/cache")
async def clear_artwork_cache():
    """Clear all cached artwork."""
    try:
        count = artwork_service.clear_cache()
        return {"status": "success", "cleared": count}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/artwork/cache/stats")
async def get_cache_stats():
    """Get artwork cache statistics."""
    try:
        size = artwork_service.get_cache_size()
        return {
            "size_bytes": size,
            "size_mb": round(size / 1024 / 1024, 2)
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# Enhanced playlist endpoints
@router.get("/playlists/{playlist_id}/tracks")
async def get_playlist_tracks(playlist_id: int):
    """Get playlist with full track listing."""
    try:
        playlist = playlist_service.get_playlist_with_tracks(playlist_id)
        if not playlist:
            raise HTTPException(status_code=404, detail="Playlist not found")
        return playlist
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/playlists/{playlist_id}/tracks/{track_id}")
async def add_track_to_playlist(playlist_id: int, track_id: int):
    """Add a track to a playlist."""
    try:
        success = playlist_service.add_track_to_playlist(playlist_id, track_id)
        if not success:
            raise HTTPException(status_code=400, detail="Failed to add track")

        # Notify via WebSocket
        await ws_manager.send_library_update("playlist_updated", {"playlist_id": playlist_id})

        return {"status": "success"}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/playlists/{playlist_id}/tracks/{track_id}")
async def remove_track_from_playlist(playlist_id: int, track_id: int):
    """Remove a track from a playlist."""
    try:
        success = playlist_service.remove_track_from_playlist(playlist_id, track_id)
        if not success:
            raise HTTPException(status_code=400, detail="Failed to remove track")

        # Notify via WebSocket
        await ws_manager.send_library_update("playlist_updated", {"playlist_id": playlist_id})

        return {"status": "success"}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.put("/playlists/{playlist_id}")
async def update_playlist(
    playlist_id: int,
    name: str = None,
    description: str = None
):
    """Update playlist metadata."""
    try:
        playlist = playlist_service.update_playlist(playlist_id, name, description)
        if not playlist:
            raise HTTPException(status_code=404, detail="Playlist not found")

        await ws_manager.send_library_update("playlist_updated", {"playlist_id": playlist_id})

        return playlist
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/playlists/{playlist_id}/duplicate")
async def duplicate_playlist(playlist_id: int, new_name: str = None):
    """Duplicate a playlist."""
    try:
        playlist = playlist_service.duplicate_playlist(playlist_id, new_name)
        if not playlist:
            raise HTTPException(status_code=404, detail="Playlist not found")

        await ws_manager.send_library_update("playlist_created", {"playlist_id": playlist['id']})

        return playlist
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.put("/playlists/{playlist_id}/reorder")
async def reorder_playlist(playlist_id: int, track_ids: List[int]):
    """Reorder tracks in a playlist."""
    try:
        success = playlist_service.reorder_playlist(playlist_id, track_ids)
        if not success:
            raise HTTPException(status_code=400, detail="Failed to reorder playlist")

        await ws_manager.send_library_update("playlist_updated", {"playlist_id": playlist_id})

        return {"status": "success"}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/playlists/smart")
async def get_smart_playlists():
    """Get automatically generated smart playlists."""
    try:
        playlists = playlist_service.get_smart_playlists()
        return playlists
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# Track favorites
@router.post("/tracks/{track_id}/favorite")
async def toggle_favorite(track_id: int):
    """Toggle favorite status for a track."""
    try:
        track = db_service.get_track(track_id)
        if not track:
            raise HTTPException(status_code=404, detail="Track not found")

        updated = db_service.update_track(track_id, {'favorite': not track.favorite})
        if not updated:
            raise HTTPException(status_code=400, detail="Failed to update track")

        await ws_manager.send_library_update("track_updated", {"track_id": track_id})

        return {"status": "success", "favorite": updated.favorite}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# Advanced search
@router.get("/library/search/advanced")
async def advanced_search(
    query: str = None,
    artist: str = None,
    album: str = None,
    genre: str = None,
    year: int = None,
    favorite: bool = None,
    sort_by: str = "title",
    sort_order: str = "asc"
):
    """Advanced search with multiple filters."""
    try:
        all_tracks = db_service.get_all_tracks()

        # Apply filters
        filtered = all_tracks

        if query:
            filtered = [
                t for t in filtered
                if query.lower() in (t.title or "").lower() or
                   query.lower() in (t.artist or "").lower() or
                   query.lower() in (t.album or "").lower()
            ]

        if artist:
            filtered = [t for t in filtered if t.artist and artist.lower() in t.artist.lower()]

        if album:
            filtered = [t for t in filtered if t.album and album.lower() in t.album.lower()]

        if genre:
            filtered = [t for t in filtered if t.genre and genre.lower() in t.genre.lower()]

        if year:
            filtered = [t for t in filtered if t.year == year]

        if favorite is not None:
            filtered = [t for t in filtered if t.favorite == favorite]

        # Sort results
        sort_key = {
            "title": lambda t: (t.title or "").lower(),
            "artist": lambda t: (t.artist or "").lower(),
            "album": lambda t: (t.album or "").lower(),
            "year": lambda t: t.year or 0,
            "date_added": lambda t: t.date_added or "",
            "play_count": lambda t: t.play_count or 0
        }.get(sort_by, lambda t: (t.title or "").lower())

        filtered.sort(key=sort_key, reverse=(sort_order == "desc"))

        return [t.to_dict() for t in filtered]

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# Update injection point for services
def inject_services(**services):
    """Inject service instances into module globals."""
    global artwork_service, playlist_service, ws_manager, db_service
    artwork_service = services.get('artwork_service')
    playlist_service = services.get('playlist_service')
    ws_manager = services.get('ws_manager')
    db_service = services.get('db_service')
