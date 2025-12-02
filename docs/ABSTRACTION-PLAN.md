# AIM Abstraction Plan

**Status:** Planned (not yet implemented)
**Created:** December 2, 2025
**Purpose:** Make AIM framework generic for any AI assistant and terminal application

---

## Current State

AIM is currently designed specifically for:
- **AI Assistant:** Claude Code (Anthropic CLI)
- **Terminal:** iTerm2 (macOS)

## Goal

Enable users to choose their preferred AI assistant and terminal application.

---

## Dependency Audit

### iTerm-Specific (3 files)

| File | Dependency |
|------|------------|
| `scripts/aim-launcher.sh` | AppleScript, `/Applications/iTerm.app` check |
| `.claude/hooks/session-start-display.sh` | iTerm detection, launcher call |
| `docs/BOARD.md` | Historical mentions only |

### Claude Code-Specific (20 files)

| Category | Files |
|----------|-------|
| Core Config | `.claude/settings.json` |
| Hooks | `.claude/hooks/*.sh` |
| Commands | `.claude/commands/*.md` |
| Docs | `CLAUDE.md`, `README.md`, etc. |

---

## Implementation Phases

### Phase 1: Configuration System

Create `aim.config.json`:
```json
{
  "terminal": {
    "app": "iterm2",
    "fallback": "tmux"
  },
  "ai_assistant": {
    "type": "claude-code",
    "config_dir": ".claude"
  },
  "notifications": {
    "sound": true,
    "desktop": false
  }
}
```

**Supported terminals:**
- `iterm2` - macOS iTerm2
- `terminal-app` - macOS Terminal.app
- `gnome-terminal` - Linux GNOME
- `konsole` - Linux KDE
- `tmux` - Cross-platform (fallback)
- `background` - No GUI, background processes only

**Supported AI assistants:**
- `claude-code` - Anthropic Claude Code CLI
- `cursor` - Cursor IDE
- `aider` - Aider CLI
- `generic` - Manual workflow, no hooks

### Phase 2: Terminal Abstraction Layer

Create `scripts/terminal-adapters/`:
```
terminal-adapters/
  iterm.sh          # macOS iTerm2
  terminal-app.sh   # macOS Terminal.app
  gnome-terminal.sh # Linux GNOME
  tmux.sh           # Cross-platform
  generic.sh        # Background processes
```

Each adapter implements:
- `open_window()`
- `open_tab()`
- `run_in_tab(command)`
- `notify(message)`

### Phase 3: AI Assistant Abstraction

Create `adapters/ai/`:
```
ai/
  claude-code/
    settings.template.json
    hooks/
  cursor/
    settings.template.json
  aider/
    config.template.yaml
  generic/
    README.md
```

Update `aim init` to:
1. Detect or prompt for AI assistant
2. Copy appropriate adapter templates
3. Create symlinks if needed (e.g., `.claude` -> `.aim`)

### Phase 4: Platform Detection

Add to `aim`:
```bash
detect_platform() {
  case "$OSTYPE" in
    darwin*)  echo "macos" ;;
    linux*)   echo "linux" ;;
    msys*|cygwin*) echo "windows" ;;
    *)        echo "unknown" ;;
  esac
}

detect_terminal() {
  local platform=$(detect_platform)
  case "$platform" in
    macos)
      [[ -d "/Applications/iTerm.app" ]] && echo "iterm2" && return
      echo "terminal-app"
      ;;
    linux)
      command -v gnome-terminal &>/dev/null && echo "gnome-terminal" && return
      command -v konsole &>/dev/null && echo "konsole" && return
      echo "tmux"
      ;;
    *)
      echo "tmux"
      ;;
  esac
}
```

---

## Migration Path

For existing users:
1. Run `aim upgrade` to generate `aim.config.json`
2. Config auto-detects current setup (Claude Code + iTerm2)
3. No breaking changes for current workflow

For new users:
1. Run `aim init`
2. Prompted to select AI assistant and terminal
3. Appropriate adapters installed

---

## Files to Modify

| File | Changes |
|------|---------|
| `aim` | Add config loading, adapter selection |
| `scripts/aim-launcher.sh` | Refactor to use terminal adapter |
| `.claude/hooks/session-start-display.sh` | Use config for terminal choice |
| `install.sh` | Add adapter installation |

## New Files to Create

| File | Purpose |
|------|---------|
| `aim.config.json` | User preferences |
| `scripts/terminal-adapters/*.sh` | Terminal-specific code |
| `adapters/ai/*/` | AI assistant templates |
| `docs/CONFIGURATION.md` | User documentation |

---

## Priority

This is a **future enhancement** for public release. Current implementation works well for Claude Code + iTerm2 users.

Implement when:
- Preparing for public release
- Users request support for other tools
- Contributing guidelines established
