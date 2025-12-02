# AIM Getting Started Guide

## Overview

AIM (AI-Collaboration-Management) is a tool for coordinating AI collaboration on software projects using the TCC/OCC workflow.

---

## Installation

### Step 1: Create directory structure

```bash
mkdir -p ~/Code/{ACTIVE,UTILITIES,ARCHIVED,LEARNING,FORKED,REFERENCE}
```

### Step 2: Clone AIM

**During active development:**
```bash
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git ~/Code/ACTIVE/ai-collaboration-management
```

**When stable:**
```bash
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git ~/Code/UTILITIES/ai-collaboration-management
```

### Step 3: Add to PATH

Edit `~/.zshrc` (macOS) or `~/.bashrc` (Linux):

```bash
export PATH="$HOME/Code/ACTIVE/ai-collaboration-management:$PATH"
```

Reload:
```bash
source ~/.zshrc
```

### Step 4: Verify

```bash
aim help
```

---

## Recommended Directory Structure

```
~/Code/
├── ACTIVE/                         # Current projects
│   ├── ai-collaboration-management/   # AIM (during development)
│   ├── my-app/                        # Your main project
│   └── my-app-test/                   # Test copy for AIM experiments
│
├── UTILITIES/                      # Stable tools
│   └── ai-collaboration-management/   # AIM (when stable)
│
├── ARCHIVED/                       # Completed/paused projects
├── LEARNING/                       # Tutorials and experiments
├── FORKED/                         # Third-party repos
└── REFERENCE/                      # Documentation
```

---

## Project Lifecycle

### Phase 1: Active Development

- AIM lives in `~/Code/ACTIVE/`
- Heavy development and feature addition
- Breaking changes expected
- Full git workflow and experimentation

### Phase 2: Mature Utility

- Move AIM to `~/Code/UTILITIES/`
- Stable, well-tested tool
- Minimal changes, mostly maintenance
- Update PATH in shell config

---

## Safety Practices

1. **Isolated Testing** - Always test AIM changes in a test copy first
2. **Clean Interfaces** - AIM only adds files, never modifies existing project files
3. **Easy Removal** - AIM integration can be completely removed without trace
4. **Protected Originals** - Keep main projects separate from test copies

---

## Quick Start with a Project

### Option A: Initialize existing project

```bash
aim init ~/Code/ACTIVE/my-project
```

---

## Creating a Test Copy

If you want to test AIM without risking your main project:

### Step 1: Create new repo on GitHub

Name it `my-project-test`

### Step 2: Clone and redirect

```bash
git clone https://github.com/you/my-project.git ~/Code/ACTIVE/my-project-test
cd ~/Code/ACTIVE/my-project-test
git remote set-url origin https://github.com/you/my-project-test.git
git push -u origin main
```

### Step 3: Initialize AIM

```bash
aim init ~/Code/ACTIVE/my-project-test
```

---

## Local Configuration (Optional)

Create `~/.claude/CLAUDE.md` for personal preferences that apply to all sessions:

```markdown
# My Preferences

- One command at a time
- Wait for confirmation before next step
- Direct language

## My Development Structure

~/Code/
├── ACTIVE/           # Current projects
├── UTILITIES/        # Stable tools
└── ...

## Active Projects
- project-a
- project-b
```

This keeps personal settings out of shared repos.

---

## Next Steps

- Check `CLAUDE.md` for TCC/OCC workflow details
- Run `aim help` for available commands
