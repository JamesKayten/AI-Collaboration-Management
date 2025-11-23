# AI Collaboration Management

**Simple file-based AI collaboration framework**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Framework Version](https://img.shields.io/badge/Version-3.0_Simple-blue.svg)](https://github.com/JamesKayten/AI-Collaboration-Management/releases)

---

## What Is This?

A **minimal framework** for AI collaboration using simple file-based communication.

**Philosophy:** Simple is better.

---

## Quick Start

### Install
```bash
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git
cd AI-Collaboration-Management
```

### Use
```bash
# Check current status
/check-the-board

# View tasks
cat TASKS.md

# Update status
edit BOARD.md
```

**That's it.**

---

## How It Works

**Two files run everything:**
- `BOARD.md` - Current status
- `TASKS.md` - Task list

**Five simple commands:**
- `/check-the-board` - Read status and tasks
- `/fix-violations` - Fix reported issues
- `/verify` - Check that fixes work
- `/works-ready` - Validate and merge
- `/merge-to-main` - Create PR

**No scripts. No complexity. Just files.**

---

## Workflow

1. Check `BOARD.md` for status
2. Make changes
3. Update `TASKS.md`
4. Commit and push
5. Create PR and merge

**Simple git workflow. No bureaucracy.**

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
    ├── check-the-board.md      # Simple status check
    ├── fix-violations.md       # Fix issues
    ├── verify.md               # Verify fixes
    ├── works-ready.md          # Validate & merge
    └── merge-to-main.md        # Create PR
```

**Total: 185 lines** (vs 6,000 lines in old framework)

**Reduction: 97%**

---

## Documentation

All documentation is in this README. If you need more, you're overthinking it.

See `.ai-framework/README.md` for framework philosophy.

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

*If you find yourself adding complexity, you're doing it wrong.*
