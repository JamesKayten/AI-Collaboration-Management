#!/bin/bash

# AudioApp Backend Launcher
# This script starts the Python backend server

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🎵 AudioApp Backend Launcher${NC}"
echo ""

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python 3 is not installed${NC}"
    echo "Please install Python 3.9 or later"
    exit 1
fi

# Check Python version
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
REQUIRED_VERSION="3.9"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo -e "${RED}Error: Python $REQUIRED_VERSION or higher is required${NC}"
    echo "Current version: $PYTHON_VERSION"
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}Virtual environment not found. Creating...${NC}"
    python3 -m venv venv
    echo -e "${GREEN}✓ Virtual environment created${NC}"
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Check if dependencies are installed
if [ ! -f "venv/bin/uvicorn" ]; then
    echo -e "${YELLOW}Installing dependencies...${NC}"
    pip install -r backend/requirements.txt
    echo -e "${GREEN}✓ Dependencies installed${NC}"
fi

# Create app directory if it doesn't exist
mkdir -p ~/.audioapp

# Start the backend server
echo ""
echo -e "${GREEN}Starting AudioApp Backend Server...${NC}"
echo "Server will be available at: http://127.0.0.1:8765"
echo "API Documentation: http://127.0.0.1:8765/docs"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop the server${NC}"
echo ""

python -m backend.main
