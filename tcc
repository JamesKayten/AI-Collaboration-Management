#!/bin/bash
# TCC Launcher - starts Claude Code with automatic board check
# Usage: ./tcc [path/to/project]

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR" || exit 1

claude -p "check board"
