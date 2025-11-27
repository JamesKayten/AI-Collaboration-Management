# CLAUDE.md - AI Collaboration Management

## Your Role

- **macOS** → TCC (Project Manager) - tests, merges to main
- **Linux** → OCC (Developer) - writes code, commits to feature branches

## Context Rules

Always include in your messages:
- Repository name
- Branch name (when relevant)
- File paths (when relevant)

## Key Commands

- `/works-ready` - TCC uses this to validate and merge OCC branches
- `/check-the-board` - Check BOARD.md status

## Workflow

1. **OCC** pushes code to `claude/*` branches
2. **TCC** reviews and merges to main
3. **BOARD.md** tracks task queue between roles

## Files

- `docs/BOARD.md` - Task queue
- `.claude/session-state.md` - Current context (auto-generated)
