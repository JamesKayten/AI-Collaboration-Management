# AI Collaboration Management (AICM)

**Lightweight framework for AI-assisted development with audio notifications**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/Version-4.0-blue.svg)](https://github.com/JamesKayten/AI-Collaboration-Management/releases)

---

## What Is This?

A framework enabling **two AI sessions** to collaborate on a codebase with minimal human intervention. Audio alerts notify you when action is needed.

**Philosophy:** Simple is better.

---

## Roles

| Role | Responsibility | Cannot |
|------|---------------|--------|
| **OCC** (Online Claude Code) | Developer - writes code, commits to feature branches | Push to main |
| **TCC** (Terminal Claude Code) | Project Manager - tests, reviews, merges to main | Write implementation code |

The human oversees both sessions and relays when prompted by audio alerts.

---

## Quick Start

### 1. Clone and Enter
```bash
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git
cd AI-Collaboration-Management
```

### 2. Start a Session
Open Claude Code in the repo directory. The SessionStart hook automatically:
- Establishes TCC (Project Manager) role on macOS
- **Checks for OCC branches and declares readiness status**
- Shows "TCC STANDING BY" when ready for work
- Alerts if OCC branches are waiting for review
- Launches monitoring watchers (Hero/Glass/Basso sounds)
- Writes session context to `.claude/session-state.md`
- Manual sync available via: `git fetch origin && git pull origin main`

### 3. Work
- **OCC**: Complete tasks, push branches
- **TCC**: Review branches, merge, update board
- **You**: Relay when you hear audio alerts

---

## Components

### Core Files

| File | Purpose |
|------|---------|
| `CLAUDE.md` | TCC session rules auto-read at startup |
| `docs/BOARD.md` | Two-way task queue |
| `.claude/hooks/session-start.sh` | Fast TCC role establishment (0.04s) |
| `.claude/settings.json` | Minimal hook configuration |
| `.claude/commands/works-ready.md` | TCC merge workflow |

### Watcher Scripts

| Script | Monitors | Sound | Meaning |
|--------|----------|-------|---------|
| `scripts/watch-branches.sh` | OCC branches | **Hero** (fanfare) | OCC pushed work |
| `scripts/watch-board.sh` | BOARD.md | **Glass** (chime) | TCC updated board |

---

## Audio Alerts

| Sound | You Hear | Action |
|-------|----------|--------|
| **Hero** (triumphant fanfare) | OCC pushed a branch | Tell TCC: "Check for new branches" |
| **Glass** (soft double-chime) | Board was updated | Tell OCC: "Check the board" |

### Sound Files (macOS)
- Hero: `/System/Library/Sounds/Hero.aiff`
- Glass: `/System/Library/Sounds/Glass.aiff`

Linux falls back to freedesktop/ALSA sounds, then terminal bell.

---

## Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                         USER                                 │
│                    (oversees both)                           │
└──────────────────────┬──────────────────────────────────────┘
                       │
        ┌──────────────┴──────────────┐
        ▼                             ▼
┌───────────────┐             ┌───────────────┐
│     OCC       │             │     TCC       │
│  (Developer)  │             │   (Manager)   │
│               │   GitHub    │               │
│ Push branch ──┼────────────►│ Hero sound    │
│               │             │ Review/Merge  │
│               │             │               │
│ Glass sound ◄─┼─────────────┼─ Update board │
│ Check board   │   GitHub    │               │
└───────────────┘             └───────────────┘
```

1. **OCC** completes work → pushes branch
2. **Hero sound** → user tells TCC to check branches
3. **TCC** reviews → merges to main → updates board
4. **Glass sound** → user tells OCC to check board
5. Repeat

---

## Board Format

`docs/BOARD.md` has two sections:

```markdown
## Tasks FOR OCC (TCC writes here, OCC reads)
[Bug fixes, refactoring tasks]

## Tasks FOR TCC (OCC writes here, TCC reads)
[Merge requests, test requests]
```

---

## Rules (CLAUDE.md)

Key rules enforced at session start:

1. **Context required** - Repo, branch, file paths in every message
2. **Completion reports** - Structured format when finishing tasks
3. **Merge verification** - TCC reports commit hash to prevent stale merges
4. **Board updates** - TCC updates board after completing tasks

**Performance Notes:**
- Minimal session hook for fast TCC role establishment (0.04s)
- No network operations during startup to prevent hangs
- Watcher auto-launch disabled (manual: `./scripts/aim-launcher.sh`)
- Manual sync: `git fetch origin && git pull origin main`

---

## Extension Points (GUI Development)

### Data Sources
- `docs/BOARD.md` - Task state (parse markdown)
- `/tmp/branch-watcher-*.log` - Branch activity
- `/tmp/board-watcher.log` - Board changes
- `/tmp/*-watcher-*.pid` - Process tracking

### Events
- Board file changes
- New branch detection
- Watcher process status

### Future GUI Features
- Visual kanban board
- Sound customization
- Session status dashboard
- Git branch visualization
- One-click session relay

### Potential API
```
GET  /board           # Board state
POST /board/task      # Create task
PUT  /board/task/:id  # Update task
GET  /branches        # OCC branches
GET  /watchers        # Watcher status
```

---


---

## Utility Tools

### `claude-release`

AI-powered git release automation for OCC workflow.

**Usage:**
```bash
cd your-project
claude-release
```

**Features:**
- Analyzes git changes via Claude
- Generates descriptive commit messages
- Auto-increments version tags (v1.2024.12.04)
- Interactive approval/editing
- Pushes to main with tags

**Installation:**
Automatically available when AICM is in PATH. Requires `ANTHROPIC_API_KEY`.

**Example:**
```bash
# Make changes to code
# Run release automation
claude-release

# Output:
# 🤖 AICM: Analyzing git changes with Claude...
# 📊 Changes detected: 3 files changed, 42 insertions(+)
# 🤖 Claude suggests: Add file export with smart extensions
# [y] Use / [e] Edit / [n] Cancel
# ✅ AICM: Released v2.2024.12.04
```

## What This Is NOT

- ❌ No proof-of-completion systems
- ❌ No natural language parsers
- ❌ No complex state tracking
- ❌ No 6,000 lines of scripts

**~200 lines total.** Simple file-based collaboration.

---

## Requirements

- Git repository
- Claude Code CLI
- Bash shell
- macOS or Linux

---

## Contributing

Contributions that **reduce complexity** are welcome.

Contributions that **add complexity** will be rejected.

---

## License

MIT

---

## Version History

### v4.1 (November 2025)
- **Hard disconnect protocol** - AICM remains standalone only
- Removed deployment instructions to prevent repository contamination
- Framework exists exclusively in dedicated AICM repository
- Established "first do no harm" principle for framework development

### v4.0 (November 2025)
- Added SessionStart hooks with auto-context injection
- Added audio watchers (Hero/Glass sounds)
- Symmetric alerts for both OCC and TCC
- Board update rule for closed-loop workflow

### v3.0
- Major simplification from 6,000 lines to ~200 lines
- Removed over-engineered systems

---

**Simple is better.**

*If you find yourself adding complexity, you're doing it wrong.*
