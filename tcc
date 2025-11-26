#!/bin/bash
# TCC Launcher - starts Claude Code and triggers auto-response
# Usage: ./tcc [path/to/project]

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR" || exit 1

command claude -p "go"
