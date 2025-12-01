# AIM Docker Deployment Guide

## Why Docker?

**The Problem:** When AIM framework files (`.claude/`, `BOARD.md`, scripts) get copied into project repositories, they contaminate the project git history and cause confusion about which rules apply where.

**The Solution:** Run AIM in a Docker container. Your project is mounted read/write, but AIM framework files stay isolated - they can never accidentally get committed to your project.

## Prerequisites

- Docker Desktop installed ([docker.com](https://docker.com))
- Git configured with SSH or HTTPS credentials
- The AIM repository cloned locally

## Overview

AIM (AI-Collaboration-Management) runs in a Docker container to prevent framework contamination of your project repositories. Your project files are mounted read/write, but AIM framework files stay isolated in the container.

## Quick Start

### 1. Build the AIM Image (One Time)

```bash
cd /path/to/AI-Collaboration-Management
docker build -t aim .
```

### 2. Start AIM on a Project

```bash
# Basic usage
docker run -it -v /path/to/your/project:/project aim

# With persistent state (recommended)
docker run -it \
  -v /path/to/your/project:/project \
  -v aim-state:/aim/state \
  aim
```

### 3. Example: Working on Your Project

```bash
docker run -it \
  -v /path/to/your-project:/project \
  -v aim-state:/aim/state \
  aim
```

## Architecture

```
┌─────────────────────────────────────────────────┐
│  AIM Container                                  │
│                                                 │
│  /aim/                 (AIM framework)          │
│    ├── scripts/        validation, watchers    │
│    ├── .claude/        commands, settings      │
│    ├── state/          boards (persistent)     │
│    └── CLAUDE.md       AI instructions         │
│                                                 │
│  /project/             (YOUR CODE - mounted)   │
│    └── [your files]    read/write access       │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Key Benefits

| Feature | Without Docker | With Docker |
|---------|----------------|-------------|
| AIM files in project git | Risk of contamination | Never happens |
| BOARD.md location | In project repo | In AIM state volume |
| Framework updates | Copy to each project | Rebuild image once |
| Isolation | Manual discipline | Enforced by container |

## Commands Inside Container

Once inside the container:

```bash
# Show project status
aim-status

# Validate a branch
aim-validate claude/feature-xyz

# Check before merge
aim-merge main

# View/edit board
cat $AIM_HOME/BOARD.md
```

## Sharing Between OCC and TCC

Both OCC (developer) and TCC (validator) containers share state via the named volume:

```bash
# OCC container
docker run -it -v /path/to/project:/project -v aim-state:/aim/state --name occ aim

# TCC container (separate terminal)
docker run -it -v /path/to/project:/project -v aim-state:/aim/state --name tcc aim
```

Both see the same BOARD.md via the shared `aim-state` volume.

## Git Workflow

Project git operations work normally inside the container:

```bash
# Inside container
cd /project
git status
git checkout -b claude/new-feature
# ... make changes ...
git add .
git commit -m "Add feature"
git push origin claude/new-feature
```

Your commits only include project files - never AIM framework files.

## Updating AIM

When AIM framework is updated:

```bash
cd /path/to/AI-Collaboration-Management
git pull
docker build -t aim .  # Rebuild with updates
```

Your project and state are unaffected - they're in volumes.

## Convenience Script (Optional)

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
aim() {
  local project="${1:-$(pwd)}"
  docker run -it \
    -v "$project":/project \
    -v aim-state:/aim/state \
    aim
}
```

Then use: `aim /path/to/your-project` or just `aim` in a project directory.

## Complete Deployment Workflow

### Step 1: Clone AIM Repository

```bash
cd ~/Documents
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git
cd AI-Collaboration-Management
```

### Step 2: Build the Docker Image

```bash
docker build -t aim .
```

### Step 3: Create the State Volume

```bash
docker volume create aim-state
```

### Step 4: Add Shell Alias (Recommended)

Add to `~/.zshrc` (macOS) or `~/.bashrc` (Linux):

```bash
# AIM launcher
aim() {
  local project="${1:-$(pwd)}"
  if [[ ! "$project" = /* ]]; then
    project="$(cd "$project" 2>/dev/null && pwd)"
  fi
  docker run -it --rm \
    -v "$project":/project \
    -v aim-state:/aim/state \
    aim "${@:2}"
}
```

Reload: `source ~/.zshrc`

### Step 5: Use on Any Project

```bash
# Start AIM on a project
aim ~/Documents/my-project

# Or from within project directory
cd ~/Documents/my-project
aim
```

## Typical Session

```bash
$ aim ~/Documents/my-project

╔═══════════════════════════════════════════════════════╗
║           AIM - AI-Collaboration-Management           ║
║              Docker Isolated Environment              ║
╚═══════════════════════════════════════════════════════╝

Project: my-project
Git Branch: main
AIM Home: /aim

Checking for OCC branches...
Pending claude/* branches: 2

AIM ready. Project mounted at /project
Commands: aim-validate, aim-merge, aim-board

$ # Now work normally - git, validate, merge, etc.
```

## Troubleshooting

### Docker not running
```
Cannot connect to the Docker daemon
```
**Fix:** Start Docker Desktop

### Permission denied on project files
```
Permission denied: /project/...
```
**Fix:** Check file ownership. Docker may need access in System Preferences > Security & Privacy > Files and Folders

### Git push fails inside container
```
Permission denied (publickey)
```
**Fix:** Mount your SSH keys:
```bash
docker run -it \
  -v /path/to/project:/project \
  -v aim-state:/aim/state \
  -v ~/.ssh:/root/.ssh:ro \
  aim
```

### Image outdated
```bash
cd ~/Documents/AI-Collaboration-Management
git pull
docker build -t aim .
```

## File Locations Summary

| What | Location | Persists? |
|------|----------|-----------|
| AIM scripts | `/aim/scripts/` (container) | Rebuilt with image |
| AIM commands | `/aim/.claude/` (container) | Rebuilt with image |
| Project files | `/project/` (mounted) | Yes (your disk) |
| Board files | `/aim/state/boards/` (volume) | Yes (Docker volume) |
| Git credentials | Mounted from host | Yes (your disk) |

## Security Notes

- Container runs as root by default
- Project mount is read/write (necessary for git operations)
- SSH keys should be mounted read-only (`:ro`)
- State volume contains only board files (no secrets)
