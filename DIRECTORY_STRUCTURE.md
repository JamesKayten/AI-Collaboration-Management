# AI Collaboration Management Framework - Directory Structure

This document provides a complete overview of the directory structure for the AI Collaboration Management framework.

## Root Directory Structure

```
AI-Collaboration-Management/
├── .ai-framework/                          # AI framework core components
│   └── communications/
│       └── reports/                        # Communication reports storage
├── .archive/                               # Archived configurations
│   ├── .claude/
│   │   ├── commands/
│   │   │   ├── check-the-board.md
│   │   │   ├── fix-violations.md
│   │   │   ├── merge-to-main.md
│   │   │   ├── verify.md
│   │   │   └── works-ready.md
│   │   ├── hooks/
│   │   │   └── session-start.sh
│   │   ├── session-state.md
│   │   └── settings.json
│   ├── BOARD.md
│   └── CLAUDE.md
├── .claude/                                # Active Claude configuration
│   ├── commands/                           # Custom Claude commands
│   │   ├── check-the-board.md
│   │   ├── fix-violations.md
│   │   ├── merge-to-main.md
│   │   ├── verify.md
│   │   └── works-ready.md
│   ├── hooks/                              # Claude execution hooks
│   │   ├── session-start.sh
│   │   └── works-ready-hook.sh
│   ├── auto-action.signal                  # Auto-action trigger file
│   ├── role.local                          # Local role configuration
│   ├── session-state.md                    # Current session state
│   ├── settings.json                       # Claude settings
│   └── settings.local.json.backup          # Backup settings
├── .claude-disabled-again/                 # Disabled Claude configuration backup
│   ├── commands/
│   │   ├── check-the-board.md
│   │   ├── fix-violations.md
│   │   ├── merge-to-main.md
│   │   ├── verify.md
│   │   └── works-ready.md
│   ├── hooks/
│   │   ├── session-start.sh
│   │   └── session-start.sh.backup
│   ├── role.local
│   ├── session-state.md
│   ├── settings.json
│   └── settings.local.json
├── .github/                                # GitHub integration
│   ├── ISSUE_TEMPLATE/                     # Issue templates
│   │   ├── bug_report.md
│   │   ├── config.yml
│   │   └── feature_request.md
│   ├── workflows/                          # GitHub Actions workflows
│   │   ├── ci.yml                          # Continuous Integration
│   │   ├── markdown-link-check-config.json
│   │   └── release.yml                     # Release workflow
│   ├── markdown-link-check.json
│   └── pull_request_template.md
├── docs/                                   # Documentation
│   ├── BOARD.md                            # Project board documentation
│   ├── CHANGELOG.md                        # Version history
│   ├── CONTRIBUTING.md                     # Contribution guidelines
│   └── WORKFLOW_TEST.md                    # Workflow testing guide
├── scripts/                                # Automation scripts
│   ├── aim-launcher.sh                     # AIM launcher script
│   ├── cleanup-watchers.sh                 # Cleanup watcher processes
│   ├── tcc-file-compliance.sh              # File compliance checker
│   ├── tcc-pre-merge-check.sh              # Pre-merge validation
│   ├── tcc-validate-branch.sh              # Branch validation
│   ├── watch-board.sh                      # Board monitoring
│   ├── watch-branches.sh                   # Branch monitoring
│   └── watch-build.sh                      # Build monitoring
├── .DS_Store                               # macOS system file
├── AICM Trouble shooting.pages             # Troubleshooting guide (Pages format)
├── CLAUDE.md                               # Claude-specific documentation
├── install.sh                              # Installation script
├── LICENSE                                 # License file
├── README.md                               # Main project documentation
└── tcc.disabled                            # TCC (compliance) disabled flag
```

## Directory Categories

### Configuration Directories

- **`.claude/`** - Active Claude Code configuration with commands, hooks, and settings
- **`.claude-disabled-again/`** - Backup of disabled Claude configuration
- **`.archive/`** - Archived configurations and documentation

### Framework Components

- **`.ai-framework/`** - Core AI framework functionality
  - Contains communication systems and reporting mechanisms

### Development & CI/CD

- **`.github/`** - GitHub integration with workflows, issue templates, and PR templates
- **`scripts/`** - Automation scripts for validation, monitoring, and compliance

### Documentation

- **`docs/`** - Comprehensive project documentation
- Root level documentation files (README.md, LICENSE, etc.)

### Key Features

1. **Claude Code Integration**: Comprehensive Claude configuration with custom commands and hooks
2. **Automated Compliance**: TCC (The Compliance Checker) scripts for validation
3. **Monitoring Systems**: Watch scripts for boards, branches, and builds
4. **GitHub Integration**: Full CI/CD pipeline with automated workflows
5. **AI Framework**: Core framework for AI collaboration management

### Framework Startup Components

Based on the structure, the framework appears to start through:

1. **`install.sh`** - Main installation script
2. **`scripts/aim-launcher.sh`** - AIM (AI Management) launcher
3. **`.claude/hooks/session-start.sh`** - Claude session initialization
4. **Watch scripts** - Various monitoring components

This framework provides a comprehensive AI collaboration environment with automated compliance checking, continuous monitoring, and seamless Claude Code integration.