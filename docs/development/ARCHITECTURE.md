# Framework Architecture

This document explains the internal architecture of the AI Collaboration Framework to help contributors understand how it works.

## Overview

The AI Collaboration Framework is a file-based communication system that enables different AI instances (Local and Online) to collaborate on code development without requiring direct API connections.

## Core Principles

### 1. Repository-Based Communication

AIs communicate through structured markdown files in the repository:
- **Reports**: Local AI creates validation reports
- **Responses**: Online AI provides responses to reports
- **Updates**: General status updates and notifications

### 2. Zero-Configuration Compatibility

The framework works with:
- Any git repository (GitHub, GitLab, Bitbucket, etc.)
- Any AI tool that can read/write files
- Any programming language or project type

### 3. Non-Intrusive Installation

All framework files are stored in `.ai-framework/` to avoid cluttering the project root.

## System Components

### Directory Structure

```
.ai-framework/
├── communications/          # AI-to-AI communication hub
│   ├── reports/            # Validation reports from Local AI
│   ├── responses/          # Fix responses from Online AI
│   └── updates/            # General communications
├── project-state/          # Project continuity & recovery
│   ├── PROJECT_STATE.md         # Current project status
│   ├── REBOOT_INSTRUCTIONS.md   # Emergency recovery guide
│   └── FRAMEWORK_CONFIG.md      # Framework settings
├── rules/                  # Validation and sync rules
│   ├── VALIDATION_RULES.md      # Project quality standards
│   └── REPOSITORY_SYNC_RULES.md # Cross-platform sync protocol
├── framework-docs/         # Framework documentation
└── installation/           # Installation scripts & templates
    ├── scripts/            # Helper scripts
    └── templates/          # File templates
```

### Component Responsibilities

#### 1. Communications System

**Location**: `.ai-framework/communications/`

**Purpose**: Facilitate structured AI-to-AI communication

**File Naming Conventions**:
```
AI_REPORT_YYYYMMDD_HHMMSS.md      # Validation reports
AI_RESPONSE_YYYYMMDD_HHMMSS.md    # Response to reports
AI_UPDATE_YYYYMMDD_HHMMSS.md      # General updates
```

**File Structure**:
```markdown
# [Report Type]

## Summary
Brief overview of findings

## Details
Detailed information

## Action Items
- Item 1
- Item 2

## Metadata
- Timestamp: YYYY-MM-DD HH:MM:SS
- AI: [Local/Online]
- Branch: [branch-name]
```

#### 2. Project State Management

**Location**: `.ai-framework/project-state/`

**Purpose**: Track project progress and enable session recovery

**Key Files**:

- **PROJECT_STATE.md**: Current state, completed features, in-progress work
- **REBOOT_INSTRUCTIONS.md**: How to recover from interruptions
- **FRAMEWORK_CONFIG.md**: Framework configuration and settings

#### 3. Rules System

**Location**: `.ai-framework/rules/`

**Purpose**: Define validation standards and sync protocols

**Key Files**:

- **VALIDATION_RULES.md**: Project-specific quality standards
- **REPOSITORY_SYNC_RULES.md**: Cross-platform file sync rules

#### 4. Installation System

**Location**: Root directory and `.ai-framework/installation/`

**Purpose**: Install framework into target projects

**Key Components**:

- **setup-ai-collaboration.sh**: Main installer script
- **templates/**: Template files for new installations
- **scripts/**: Helper utilities

## Data Flow

### Validation Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                     User Request                            │
│                 "work ready" or "validate"                  │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    Local AI                                 │
│  1. Read VALIDATION_RULES.md                               │
│  2. Scan project files                                     │
│  3. Run validation checks                                  │
│  4. Generate report                                        │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│           Create AI_REPORT_*.md                            │
│  - Write to .ai-framework/communications/reports/          │
│  - Include violations, affected files, suggestions         │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                Git Commit & Push                           │
│  - Commit report to branch                                 │
│  - Push to remote repository                               │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                User Notifies Online AI                     │
│  "Check .ai-framework/communications/ for latest report"   │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                   Online AI                                │
│  1. Pull latest changes                                    │
│  2. Read AI_REPORT_*.md                                    │
│  3. Analyze violations                                     │
│  4. Implement fixes                                        │
│  5. Create AI_RESPONSE_*.md                                │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                Git Commit & Push                           │
│  - Commit fixes and response                               │
│  - Push to remote repository                               │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                   Repeat Cycle                             │
│  User: "work ready" → validates fixes → merge or iterate  │
└─────────────────────────────────────────────────────────────┘
```

### Installation Workflow

```
User runs: ./setup-ai-collaboration.sh
                     │
                     ▼
        Check if git repository exists
                     │
            ┌────────┴────────┐
            │                 │
           YES               NO
            │                 │
            ▼                 ▼
    Continue install    Show error & exit
            │
            ▼
    Create .ai-framework/ directory
            │
            ▼
    Copy template files from framework repo
            │
            ├── communications/ (empty structure)
            ├── project-state/ (templates)
            ├── rules/ (default rules)
            └── framework-docs/ (documentation)
            │
            ▼
    Customize templates for project
            │
            ├── PROJECT_STATE.md
            ├── VALIDATION_RULES.md
            └── FRAMEWORK_CONFIG.md
            │
            ▼
    Set up git hooks (optional)
            │
            ▼
    Create initial commit (optional)
            │
            ▼
    Display success message & next steps
```

## Key Algorithms

### File Naming Algorithm

```javascript
function generateCommunicationFileName(type) {
  const timestamp = new Date().toISOString()
    .replace(/[-:]/g, '')
    .replace('T', '_')
    .split('.')[0];

  return `AI_${type}_${timestamp}.md`;
}

// Examples:
// AI_REPORT_20250119_143022.md
// AI_RESPONSE_20250119_143530.md
// AI_UPDATE_20250119_144102.md
```

### Validation Rules Parsing

```bash
# Pseudo-code for validation rule processing
function parseValidationRules() {
  read VALIDATION_RULES.md

  extract rules by section:
    - Code Quality
    - File Organization
    - Security
    - Performance
    - Documentation

  for each rule:
    parse:
      - rule_name
      - threshold
      - check_command
      - severity (error/warning)

  return structured_rules
}

function validateProject(rules) {
  violations = []

  for each rule in rules:
    result = execute(rule.check_command)

    if result exceeds threshold:
      violations.append({
        rule: rule.rule_name,
        severity: rule.severity,
        details: result.details,
        suggestion: rule.fix_suggestion
      })

  return violations
}
```

## Extension Points

### Adding New Validation Types

1. **Update VALIDATION_RULES.md template**
   - Location: `templates/validation_rules_template.md`
   - Add new rule section
   - Define check command and threshold

2. **Create validator script** (optional)
   - Location: `scripts/validators/`
   - Implement custom validation logic
   - Return structured results

3. **Update documentation**
   - Add example to README.md
   - Document in ARCHITECTURE.md

### Adding New Communication Types

1. **Define file naming convention**
   - Pattern: `AI_[TYPE]_YYYYMMDD_HHMMSS.md`
   - Document in communication guide

2. **Create file structure template**
   - Define required sections
   - Add to templates directory

3. **Update AI workflow instructions**
   - When to use new type
   - How to create and read

### Adding Platform Integrations

1. **Create integration script**
   - Location: `scripts/integrations/`
   - Handle platform-specific API calls

2. **Add configuration options**
   - Update FRAMEWORK_CONFIG.md template
   - Document settings

3. **Update setup script**
   - Add integration detection
   - Offer to install during setup

## Security Considerations

### File Permissions

- All framework files are readable by all AIs
- No sensitive credentials stored in framework files
- Use environment variables for secrets

### Git Ignore Patterns

Certain files should be gitignored:
```
.ai-framework/communications/drafts/
.ai-framework/.cache/
.ai-framework/.temp/
```

### Validation Safety

- Validation scripts run with limited permissions
- No automatic code execution without review
- All changes require explicit user approval

## Performance Optimization

### File Reading Strategy

```javascript
// Instead of reading all files:
// ❌ files = glob('.ai-framework/**/*.md')

// Read only latest files:
// ✅ files = glob('.ai-framework/communications/reports/*')
//           .sort(by: 'timestamp', order: 'desc')
//           .limit(10)
```

### Caching Strategy

- Cache parsed validation rules
- Cache project structure scan
- Invalidate cache on rule changes

### Parallel Processing

```bash
# Validate multiple file types in parallel
validate_js &
validate_python &
validate_tests &
wait
```

## Testing Strategy

### Unit Tests

- Test individual validator functions
- Test file naming utilities
- Test rule parsing logic

### Integration Tests

- Test full installation process
- Test validation workflow end-to-end
- Test communication file creation

### Platform Tests

- Test on different operating systems
- Test with different git providers
- Test with different project structures

## Future Enhancements

### Planned Features

1. **Dashboard UI**: Visual interface for collaboration metrics
2. **Webhook Integration**: Real-time notifications
3. **Multi-Repository Support**: Collaborate across multiple repos
4. **AI Performance Metrics**: Track AI collaboration effectiveness
5. **Advanced Caching**: Improve performance for large projects

### Extensibility Goals

- Plugin system for custom validators
- Template marketplace for different tech stacks
- Integration marketplace for tools and services

## Contributing to Architecture

When proposing architectural changes:

1. **Open an issue** describing the change
2. **Discuss design** with maintainers
3. **Create RFC** (Request for Comments) if major
4. **Implement incrementally** with backward compatibility
5. **Update this document** with new architecture details

## Resources

- **Main README**: Overview and quick start
- **CONTRIBUTING.md**: How to contribute
- **API Documentation**: Detailed API reference
- **Examples**: Real-world usage examples

---

**Questions about architecture?** Open a discussion on GitHub!
