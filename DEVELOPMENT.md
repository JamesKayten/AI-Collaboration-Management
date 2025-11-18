# Development Guide

## Overview

This document outlines the development standards, practices, and workflows for the AI-Collaboration-Management framework. All contributors should familiarize themselves with these guidelines before making changes.

## Development Philosophy

### Core Principles

1. **Simplicity First** - Maintain zero external dependencies; use pure Bash where possible
2. **Backward Compatibility** - Never break existing installations without migration path
3. **AI-Agnostic Design** - Work with any AI tool, not just Claude
4. **Production Ready** - Every commit should maintain production-ready state
5. **Documentation Driven** - Document before implementing, update docs with changes

## Development Environment Setup

### Prerequisites

```bash
# Required tools
git --version          # Git 2.x or higher
bash --version         # Bash 4.0 or higher
shellcheck --version   # For linting (recommended)

# Optional but recommended
shfmt --version        # For shell formatting
bats --version         # For testing (Bash Automated Testing System)
```

### Setting Up Your Development Environment

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/AI-Collaboration-Management.git
cd AI-Collaboration-Management

# Create a feature branch
git checkout -b feature/your-feature-name

# Test the installation
./scripts/test_installation.sh

# Make the ai command available locally (optional)
export PATH="$PWD:$PATH"
```

## Project Structure

```
AI-Collaboration-Management/
├── ai                          # Master command (entry point)
├── setup-ai-collaboration.sh   # Main setup script
├── update-claude-rules.sh      # Rules management
│
├── .ai-framework/              # Framework internals (hidden)
│   ├── project-state/          # Project tracking
│   ├── communications/         # AI-to-AI protocol
│   ├── rules/                  # Validation rules
│   ├── framework-docs/         # Internal documentation
│   └── project-templates/      # Reusable templates
│
├── docs/                       # Public documentation
├── scripts/                    # Utility scripts
├── templates/                  # User-facing templates
├── test_examples/              # Test cases
└── tests/                      # Automated tests (future)
```

## Coding Standards

### Shell Script Standards

#### File Headers

All shell scripts must include:

```bash
#!/usr/bin/env bash
#
# Script Name: descriptive-name.sh
# Description: Brief description of what this script does
# Version: 1.0.0
# Author: Your Name
# License: MIT
#
# Usage: script-name.sh [options] [arguments]
#

set -euo pipefail  # Exit on error, undefined vars, pipe failures
```

#### Naming Conventions

- **Files**: Use lowercase with hyphens (e.g., `setup-ai-collaboration.sh`)
- **Functions**: Use snake_case (e.g., `validate_installation`)
- **Variables**: Use lowercase with underscores (e.g., `project_root`)
- **Constants**: Use UPPERCASE (e.g., `DEFAULT_PRESET`)
- **Private Functions**: Prefix with underscore (e.g., `_internal_helper`)

#### Code Style

```bash
# Good: Clear, defensive coding
validate_project_type() {
    local project_type="${1:-}"

    if [[ -z "$project_type" ]]; then
        echo "Error: Project type is required" >&2
        return 1
    fi

    case "$project_type" in
        python|react|java|mobile|data-science)
            return 0
            ;;
        *)
            echo "Error: Invalid project type: $project_type" >&2
            return 1
            ;;
    esac
}

# Bad: No validation, unclear
validate() {
    case "$1" in
        python|react|java|mobile|data-science) return 0;;
        *) return 1;;
    esac
}
```

#### Error Handling

```bash
# Always handle errors explicitly
if ! command_that_might_fail; then
    echo "Error: Command failed" >&2
    cleanup_resources
    exit 1
fi

# Use meaningful exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_INVALID_ARGS=1
readonly EXIT_MISSING_DEPENDENCY=2
readonly EXIT_OPERATION_FAILED=3
```

#### Function Documentation

```bash
#######################################
# Validates and sets up project configuration
# Globals:
#   PROJECT_ROOT
#   CONFIG_FILE
# Arguments:
#   $1 - Project type (python|react|java|mobile|data-science)
#   $2 - Optional: Config file path
# Outputs:
#   Writes configuration to CONFIG_FILE
# Returns:
#   0 on success, 1 on validation error, 2 on write error
#######################################
setup_project_config() {
    # Implementation
}
```

### Code Review Checklist

Before submitting code, verify:

- [ ] All functions have documentation comments
- [ ] Error handling is comprehensive
- [ ] No hardcoded paths (use variables)
- [ ] shellcheck passes with no warnings
- [ ] Code follows naming conventions
- [ ] Backward compatibility maintained
- [ ] Documentation updated
- [ ] Manual testing completed
- [ ] No breaking changes (or documented in CHANGELOG)

## Testing Guidelines

### Manual Testing

Every change must be tested manually:

```bash
# Test basic installation
./scripts/test_installation.sh

# Test specific presets
./setup-ai-collaboration.sh --preset python
./setup-ai-collaboration.sh --preset react

# Test the master command
./ai setup --preset python
./ai status
./ai rules --show
```

### Automated Testing

We use BATS (Bash Automated Testing System) for unit tests:

```bash
# Run all tests
bats tests/

# Run specific test file
bats tests/test_setup.bats

# Run with verbose output
bats --tap tests/
```

### Test Coverage Requirements

- **Core Scripts**: 80% coverage minimum
- **Utility Functions**: 90% coverage minimum
- **Edge Cases**: Must have explicit tests
- **Breaking Changes**: Must have migration tests

## Git Workflow

### Branch Naming

```
feature/descriptive-name      # New features
fix/bug-description           # Bug fixes
docs/documentation-update     # Documentation only
refactor/code-improvement     # Code refactoring
test/test-addition            # Test additions
release/v1.2.3                # Release branches
```

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `chore`: Maintenance tasks

**Examples:**

```
feat(setup): Add support for Go projects

- Add go preset with golint and go test
- Update documentation with Go examples
- Add Go validation rules template

Closes #123

---

fix(ai-command): Handle spaces in project paths

Previously the ai command would fail when project paths
contained spaces. This fix properly quotes all path variables.

Fixes #456

---

docs(readme): Update installation instructions

- Clarify system requirements
- Add troubleshooting section for macOS
- Fix broken links
```

### Pull Request Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature
   ```

2. **Make Changes**
   - Write code following standards
   - Add/update tests
   - Update documentation

3. **Test Thoroughly**
   ```bash
   ./scripts/test_installation.sh
   shellcheck *.sh scripts/*.sh
   ```

4. **Commit with Conventional Commits**
   ```bash
   git add .
   git commit -m "feat(scope): descriptive message"
   ```

5. **Push and Create PR**
   ```bash
   git push -u origin feature/your-feature
   ```

6. **PR Description Template**
   ```markdown
   ## Description
   Brief description of changes

   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Breaking change
   - [ ] Documentation update

   ## Testing
   - [ ] Manual testing completed
   - [ ] Automated tests pass
   - [ ] Documentation updated

   ## Checklist
   - [ ] Code follows style guidelines
   - [ ] Self-review completed
   - [ ] Comments added for complex code
   - [ ] Documentation updated
   - [ ] No new warnings
   - [ ] Tests added/updated
   - [ ] Backward compatible (or migration provided)
   ```

## Release Process

### Versioning

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Incompatible API changes
- **MINOR**: Backward-compatible functionality
- **PATCH**: Backward-compatible bug fixes

### Release Checklist

1. **Pre-release**
   - [ ] All tests pass
   - [ ] Documentation updated
   - [ ] CHANGELOG.md updated
   - [ ] Version bumped in all locations

2. **Release**
   - [ ] Create release branch
   - [ ] Tag with version number
   - [ ] Generate release notes
   - [ ] Publish to GitHub releases

3. **Post-release**
   - [ ] Announce on relevant channels
   - [ ] Monitor for issues
   - [ ] Update social media templates

## Documentation Standards

### Documentation Files

All documentation should:
- Use clear, concise language
- Include code examples
- Provide troubleshooting tips
- Be updated with code changes
- Use consistent formatting

### README Structure

Every significant directory should have a README explaining:
- Purpose of the directory
- What files it contains
- How to use/modify contents
- Related documentation links

### Code Comments

```bash
# Good: Explains WHY, not WHAT
# Workaround for macOS sed compatibility issue
sed -i.bak 's/pattern/replacement/' file

# Bad: Explains obvious WHAT
# Replace pattern with replacement
sed -i.bak 's/pattern/replacement/' file
```

## Performance Guidelines

### Script Performance

- Minimize subshells (use `$()` sparingly)
- Prefer built-in commands over external utilities
- Cache expensive operations
- Use arrays for multiple values
- Avoid unnecessary file I/O

### Example: Performance Optimization

```bash
# Good: Single grep operation
mapfile -t matches < <(grep -r "pattern" .)

# Bad: Multiple grep operations in loop
for file in $(find . -type f); do
    grep "pattern" "$file"
done
```

## Security Considerations

### Input Validation

```bash
# Always validate user input
validate_input() {
    local input="$1"

    # Check for command injection attempts
    if [[ "$input" =~ [;\&\|] ]]; then
        echo "Error: Invalid characters in input" >&2
        return 1
    fi

    # Whitelist validation when possible
    if [[ ! "$input" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "Error: Input contains invalid characters" >&2
        return 1
    fi
}
```

### File Operations

```bash
# Good: Safe file operations
if [[ -f "$config_file" ]] && [[ -r "$config_file" ]]; then
    source "$config_file"
fi

# Bad: Unsafe file operations
source "$config_file"  # No validation
```

### Credential Handling

- Never commit secrets or tokens
- Use environment variables for sensitive data
- Document required credentials clearly
- Provide `.env.example` templates

## Debugging

### Debug Mode

Enable debug output:

```bash
# In your script
DEBUG="${DEBUG:-false}"

debug_log() {
    if [[ "$DEBUG" == "true" ]]; then
        echo "[DEBUG] $*" >&2
    fi
}

# Usage
DEBUG=true ./script.sh
```

### Common Debugging Techniques

```bash
# Trace execution
set -x  # Enable
set +x  # Disable

# Check variable expansion
declare -p variable_name

# Verify function exists
declare -f function_name
```

## Continuous Integration

### Pre-commit Hooks

Install pre-commit hooks:

```bash
# .git/hooks/pre-commit
#!/bin/bash
shellcheck *.sh scripts/*.sh || exit 1
./scripts/test_installation.sh || exit 1
```

### GitHub Actions

See `.github/workflows/` for CI configuration.

Every push should:
- Run shellcheck
- Execute test suite
- Validate documentation links
- Check for security issues

## Getting Help

### Resources

- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [BATS Testing](https://github.com/bats-core/bats-core)

### Community

- GitHub Issues: Bug reports and feature requests
- GitHub Discussions: Questions and ideas
- Pull Requests: Code contributions

### Maintainer Contact

See GOVERNANCE.md for maintainer information and decision-making process.

## License

All contributions are subject to the MIT License. See LICENSE file for details.

---

**Version:** 1.0.0
**Last Updated:** 2025-11-18
**Maintainer:** AI Collaboration Management Team
