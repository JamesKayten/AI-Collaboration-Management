"""
AudioApp Backend - Main FastAPI application.
Provides REST API for the SwiftUI macOS frontend.
"""

import logging
import sys
from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

from .services import DatabaseService, LibraryManager, PlayerManager
from .api import routes

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler(Path.home() / '.audioapp' / 'backend.log')
    ]
)

logger = logging.getLogger(__name__)

# Create FastAPI app
app = FastAPI(
    title="AudioApp Backend",
    description="REST API for AudioApp music player",
    version="1.0.0"
)

# Configure CORS for local development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize services
db_service = None
library_manager = None
player_manager = None


@app.on_event("startup")
async def startup_event():
    """Initialize services on startup."""
    global db_service, library_manager, player_manager

    logger.info("Starting AudioApp Backend...")

    # Initialize database
    db_service = DatabaseService()
    logger.info("Database service initialized")

    # Initialize library manager
    library_manager = LibraryManager(db_service)
    logger.info("Library manager initialized")

    # Initialize player manager
    player_manager = PlayerManager(db_service)
    logger.info("Player manager initialized")

    # Inject services into routes
    routes.db_service = db_service
    routes.library_manager = library_manager
    routes.player_manager = player_manager

    logger.info("AudioApp Backend started successfully")


@app.on_event("shutdown")
async def shutdown_event():
    """Clean up resources on shutdown."""
    logger.info("Shutting down AudioApp Backend...")

    if player_manager:
        player_manager.cleanup()

    logger.info("AudioApp Backend shut down successfully")


# Include API routes
app.include_router(routes.router, prefix="/api/v1")


@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "name": "AudioApp Backend",
        "version": "1.0.0",
        "status": "running",
        "docs": "/docs"
    }


def main():
    """Main entry point for running the server."""
    # Ensure app directory exists
    app_dir = Path.home() / '.audioapp'
    app_dir.mkdir(exist_ok=True)

    # Run server
    uvicorn.run(
        "backend.main:app",
        host="127.0.0.1",
        port=8765,
        reload=True,  # Enable auto-reload during development
        log_level="info"
    )


if __name__ == "__main__":
    main()
