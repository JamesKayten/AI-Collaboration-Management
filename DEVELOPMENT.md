# Development Guide

## Getting Started

### Prerequisites

- Bash 4.0+ (macOS users may need to install via Homebrew)
- Git 2.20+
- Standard Unix utilities (sed, awk, grep)

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/JamesKayten/AI-Collaboration-Management.git
   cd AI-Collaboration-Management
   ```

2. Make scripts executable:
   ```bash
   chmod +x scripts/*.sh
   chmod +x ai
   chmod +x setup-ai-collaboration.sh
   ```

## Project Structure

```
AI-Collaboration-Management/
├── scripts/                 # Utility scripts
│   ├── tcc-file-compliance.sh    # File size checker
│   └── tcc-pre-merge-check.sh    # Pre-merge validation
├── .claude/                 # Claude Code configuration
│   ├── commands/            # Custom slash commands
│   └── settings.json        # Claude settings
├── docs/                    # Documentation
│   ├── BOARD.md            # Task board
│   └── WORKFLOW_TEST.md    # Workflow tests
├── tests/                   # Test files
├── CLAUDE.md               # AI assistant instructions
└── README.md               # Project overview
```

## Development Workflow

### Branch Naming

- Feature branches: `claude/<description>-<session-id>`
- Use descriptive names that indicate the work being done

### File Size Limits

All source files must comply with size limits:

| File Type | Max Lines |
|-----------|-----------|
| Python (.py) | 250 |
| JavaScript/TypeScript (.js, .ts, .jsx, .tsx) | 150 |
| Java (.java) | 400 |
| Swift (.swift) | 300 |
| Shell (.sh) | 200 |
| Markdown (.md) | 500 |

Run compliance check:
```bash
./scripts/tcc-file-compliance.sh main
```

### Pre-Merge Checks

Before merging to main:
```bash
./scripts/tcc-pre-merge-check.sh main
```

## Testing

Run the test suite:
```bash
bats tests/
```

Run installation tests:
```bash
./scripts/test_installation.sh
```

## Contributing

1. Create a feature branch from main
2. Make your changes
3. Ensure all tests pass
4. Run file compliance checks
5. Submit for review

## Code Style

- Use consistent indentation (2 spaces for shell scripts)
- Add comments for complex logic
- Follow existing patterns in the codebase
