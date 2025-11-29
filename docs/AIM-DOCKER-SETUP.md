# AIM Docker Setup Guide

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

### 3. Example: Working on SimpleCP

```bash
docker run -it \
  -v /Users/yourname/Documents/SimpleCP:/project \
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

Then use: `aim /path/to/SimpleCP` or just `aim` in a project directory.
