"""
WebSocket manager for real-time playback state updates.
Provides real-time communication between backend and frontend.
"""

import asyncio
import logging
from typing import Set, Dict, Any
from fastapi import WebSocket, WebSocketDisconnect

logger = logging.getLogger(__name__)


class ConnectionManager:
    """
    Manages WebSocket connections for real-time updates.
    """

    def __init__(self):
        self.active_connections: Set[WebSocket] = set()
        self._lock = asyncio.Lock()

    async def connect(self, websocket: WebSocket):
        """
        Accept and store a new WebSocket connection.

        Args:
            websocket: WebSocket connection to add
        """
        await websocket.accept()
        async with self._lock:
            self.active_connections.add(websocket)
        logger.info(f"New WebSocket connection. Total: {len(self.active_connections)}")

    async def disconnect(self, websocket: WebSocket):
        """
        Remove a WebSocket connection.

        Args:
            websocket: WebSocket connection to remove
        """
        async with self._lock:
            self.active_connections.discard(websocket)
        logger.info(f"WebSocket disconnected. Total: {len(self.active_connections)}")

    async def broadcast(self, message: Dict[str, Any]):
        """
        Broadcast a message to all connected clients.

        Args:
            message: Dictionary to send to all clients
        """
        if not self.active_connections:
            return

        async with self._lock:
            connections = list(self.active_connections)

        disconnected = []
        for connection in connections:
            try:
                await connection.send_json(message)
            except Exception as e:
                logger.error(f"Error broadcasting to client: {e}")
                disconnected.append(connection)

        # Remove disconnected clients
        if disconnected:
            async with self._lock:
                for conn in disconnected:
                    self.active_connections.discard(conn)

    async def send_playback_state(self, state: Dict[str, Any]):
        """
        Send playback state update to all clients.

        Args:
            state: Playback state dictionary
        """
        await self.broadcast({
            "type": "playback_state",
            "data": state
        })

    async def send_library_update(self, event: str, data: Dict[str, Any] = None):
        """
        Send library update notification to all clients.

        Args:
            event: Event type (e.g., "track_added", "track_deleted")
            data: Optional event data
        """
        await self.broadcast({
            "type": "library_update",
            "event": event,
            "data": data or {}
        })

    async def send_import_progress(self, progress: Dict[str, Any]):
        """
        Send import progress update to all clients.

        Args:
            progress: Progress information
        """
        await self.broadcast({
            "type": "import_progress",
            "data": progress
        })

    async def send_error(self, error: str):
        """
        Send error message to all clients.

        Args:
            error: Error message
        """
        await self.broadcast({
            "type": "error",
            "message": error
        })


# Global connection manager instance
manager = ConnectionManager()
