#!/bin/bash
# TCC Launcher - starts Claude Code with auto-response
cd "$(dirname "$0")" || exit 1
command claude -p "go"
