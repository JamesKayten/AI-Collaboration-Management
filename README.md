# AI Collaboration Management

**Simple file-based AI collaboration framework**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Framework Version](https://img.shields.io/badge/Version-3.0_Simple-blue.svg)](https://github.com/JamesKayten/AI-Collaboration-Management/releases)

---

## What Is This?

A **minimal framework** for AI collaboration using simple file-based communication.

**Philosophy:** Simple is better.

---

## TCC's Three Responsibilities

**TCC (Terminal Claude Code) has exactly three jobs:**

### 1. File Verification
Validate OCC's changes:
- Run tests (pytest, npm test, etc.)
- Check linters (flake8, eslint, etc.)
- Verify builds work
- Ensure quality standards met

### 2. Merge to Main Branch
If validation passes:
- Merge OCC's branch to main
- Push to GitHub

### 3. Duplicate Everything Locally
**CRITICAL** - Update local working directory:
- Pull latest from main
- Ensure local files match GitHub
- User can immediately test/use the code

**All three steps must complete. Never skip step 3.**

---

## New TCC Session? Start Here

**If you're TCC starting a new session:**

1. Read `.ai/TCC_ONBOARDING.md` for complete onboarding
2. Run `/check-the-board` to see current status
3. Follow the instructions from BOARD.md

**First command every session:**
```bash
/check-the-board
```

---

## Quick Start

### Install
```bash
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git
cd AI-Collaboration-Management
```

### Use
```bash
# TCC checks status
/check-the-board

# OCC makes changes and pushes

# TCC validates, merges, updates local
/works-ready
```

**That's it.**

---

## How It Works

**Two files run everything:**
- `BOARD.md` - Current status
- `TASKS.md` - Task list

**Core TCC command:**
- `/works-ready` - Verify → Merge → Update Local

**No scripts. No complexity. Just files and git.**

---

## Workflow

### TCC Workflow
```bash
# 1. Verify
git fetch && git checkout <occ-branch>
# Run tests/validation

# 2. Merge to main (if passing)
git checkout main && git merge <branch> && git push origin main

# 3. Update local
git pull origin main
```

### OCC Workflow
1. Read BOARD.md for status
2. Fix reported issues
3. Commit and push
4. Wait for TCC validation

**Communication through git commits and BOARD.md updates.**

---

## What This Is NOT

- ❌ No proof-of-completion systems
- ❌ No caching layers
- ❌ No monitoring/enforcement
- ❌ No natural language parsers
- ❌ No complex state tracking
- ❌ No excessive documentation
- ❌ No 6,000 lines of scripts

**We removed all that nonsense.**

---

## Design Principles

1. **KISS** - Keep It Simple, Stupid
2. **Files over scripts** - Read markdown, not JSON
3. **Trust over verify** - If it works, it's done
4. **Clarity over automation** - Simple beats clever
5. **Minimal over comprehensive** - Less is more

---

## Framework Structure

```
AI-Collaboration-Management/
├── BOARD.md                    # Current status (30 lines)
├── TASKS.md                    # Task list (31 lines)
├── .ai-framework/
│   └── README.md               # Framework docs (63 lines)
└── .claude/commands/
    ├── check-the-board.md      # Read status
    ├── works-ready.md          # TCC main: Verify→Merge→Update
    ├── verify.md               # Validation only
    └── merge-to-main.md        # Create PR
```

**Total: 185 lines** (vs 6,000 lines in old framework)

**Reduction: 97%**

---

## Critical Rule for TCC

**ALWAYS complete all 3 steps:**
1. ✅ Verify files
2. ✅ Merge to main
3. ✅ Update local working directory

**Never skip step 3.** Local files must match GitHub after merge.

---

## Documentation

- **TCC_WORKFLOW_GUIDE.md** - TCC's three responsibilities explained
- **CHANGELOG.md** - Version history and changes
- **CONTRIBUTING.md** - How to contribute (reduce complexity)

All documentation emphasizes simplicity.

---

## What Changed

### Version 3.0 (November 2025)
**MAJOR SIMPLIFICATION:**
- Removed 6,000 lines of over-engineered complexity
- Replaced with 185 lines of simple, clear code
- Eliminated proof systems, caching, monitoring, parsers
- Framework now just reads 2 markdown files

### Why?
The framework had become absurdly complex:
- 331-line proof-of-completion bureaucracy
- 334-line natural language parser
- 293-line caching system
- 6 different state tracking files
- Behavior enforcement scripts
- 1,508 lines of handoff docs

**All unnecessary for simple file collaboration.**

### Previous Versions
Old bloated framework archived in `.ai-framework-BLOAT-ARCHIVE/` for reference.

---

## Contributing

Keep it simple:
1. Fork the repo
2. Make improvements (that reduce complexity)
3. Create PR
4. Explain why it's simpler

**Contributions that add complexity will be rejected.**

---

## License

MIT License - Use freely.

---

## Acknowledgments

**Created by Avery** - Original framework concept

**Simplified by reality** - When the framework became more complex than the problems it solved, simplification became necessary.

---

## Support

- **Issues**: [GitHub Issues](https://github.com/JamesKayten/AI-Collaboration-Management/issues)
- **Discussions**: [GitHub Discussions](https://github.com/JamesKayten/AI-Collaboration-Management/discussions)

---

**Simple file-based AI collaboration. Nothing more, nothing less.**

**TCC: Verify → Merge → Update Local. Always.**

*If you find yourself adding complexity, you're doing it wrong.*
