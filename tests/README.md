# Testing Framework

This directory contains automated tests for the AI-Collaboration-Management framework.

## Overview

We use **BATS** (Bash Automated Testing System) for testing our shell scripts. This provides a simple, readable way to write unit and integration tests for bash code.

## Installation

### Installing BATS

**macOS:**
```bash
brew install bats-core
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install bats
```

**Linux (from source):**
```bash
git clone https://github.com/bats-core/bats-core.git
cd bats-core
sudo ./install.sh /usr/local
```

**Verify Installation:**
```bash
bats --version
```

### Installing Test Helpers

```bash
# Install bats-support and bats-assert for better assertions
git clone https://github.com/bats-core/bats-support test/test_helper/bats-support
git clone https://github.com/bats-core/bats-assert test/test_helper/bats-assert
```

## Running Tests

### Run All Tests

```bash
# From repository root
bats tests/

# Verbose output
bats --tap tests/

# Pretty formatter
bats --formatter pretty tests/
```

### Run Specific Test File

```bash
bats tests/test_setup.bats
bats tests/test_ai_command.bats
```

### Run Specific Test

```bash
# Use -f flag to filter by test name
bats tests/test_setup.bats -f "validates project type"
```

## Test Structure

```
tests/
├── README.md                    # This file
├── test_helper/                 # Test utilities
│   ├── bats-support/            # BATS support library
│   ├── bats-assert/             # BATS assertion library
│   └── common.bash              # Common test functions
├── test_setup.bats              # Tests for setup-ai-collaboration.sh
├── test_ai_command.bats         # Tests for ai master command
├── test_rules.bats              # Tests for update-claude-rules.sh
├── test_presets.bats            # Tests for preset configurations
├── test_session_recovery.bats   # Tests for session recovery
└── integration/                 # Integration tests
    ├── test_python_project.bats
    ├── test_react_project.bats
    └── test_end_to_end.bats
```

## Writing Tests

### Basic Test Structure

```bash
#!/usr/bin/env bats

# Load test helpers
load test_helper/bats-support/load
load test_helper/bats-assert/load
load test_helper/common

# Setup function runs before each test
setup() {
    # Create temporary directory
    TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
}

# Teardown function runs after each test
teardown() {
    # Clean up
    rm -rf "$TEST_DIR"
}

# Test case
@test "validates project type correctly" {
    run validate_project_type "python"
    assert_success

    run validate_project_type "invalid"
    assert_failure
}
```

### Test Naming Conventions

- Use descriptive names that explain what is being tested
- Start with a verb: "validates", "creates", "handles", "rejects"
- Be specific about expected behavior
- Group related tests together

**Good test names:**
```bash
@test "creates .ai-framework directory structure"
@test "validates project type with valid preset"
@test "handles missing git repository gracefully"
@test "rejects invalid preset names with error message"
```

**Bad test names:**
```bash
@test "test setup"
@test "it works"
@test "check validation"
```

### Common Test Patterns

#### Testing Command Success/Failure

```bash
@test "command succeeds with valid input" {
    run ./ai status
    assert_success
    assert_output --partial "Status"
}

@test "command fails with invalid input" {
    run ./ai invalid-command
    assert_failure
    assert_output --partial "Error"
}
```

#### Testing File Creation

```bash
@test "creates configuration files" {
    run ./setup-ai-collaboration.sh --preset python
    assert_success
    assert [ -f ".ai-framework/FRAMEWORK_CONFIG.md" ]
    assert [ -d ".ai-framework/communications" ]
}
```

#### Testing Output Content

```bash
@test "displays correct help message" {
    run ./ai --help
    assert_success
    assert_line --partial "Usage: ai [command]"
    assert_line --partial "setup"
    assert_line --partial "status"
}
```

#### Testing Error Messages

```bash
@test "shows error for missing git repository" {
    rm -rf .git
    run ./setup-ai-collaboration.sh
    assert_failure
    assert_output --regexp "Error.*git repository"
}
```

#### Testing Environment Variables

```bash
@test "respects DEBUG environment variable" {
    DEBUG=true run ./ai status
    assert_success
    assert_output --partial "[DEBUG]"
}
```

## Test Coverage Goals

### Coverage Targets

- **Core Scripts**: 80% minimum
- **Utility Functions**: 90% minimum
- **Critical Paths**: 100% (setup, installation, validation)
- **Error Handling**: 100% (all error paths tested)

### What to Test

**Must Test:**
- ✅ All command-line arguments and options
- ✅ Input validation (valid and invalid inputs)
- ✅ Error handling and error messages
- ✅ File creation and modification
- ✅ Configuration parsing and generation
- ✅ Edge cases (empty values, special characters, etc.)
- ✅ Backward compatibility with previous versions

**Should Test:**
- ⚠️ Integration between components
- ⚠️ Different preset configurations
- ⚠️ Platform-specific behavior (if applicable)
- ⚠️ Performance with large inputs

**Nice to Have:**
- 💡 Output formatting
- 💡 Help message content
- 💡 Debug output

## Test Helpers

### Common Test Functions

Located in `test_helper/common.bash`:

```bash
# Initialize a test git repository
setup_git_repo() {
    git init
    git config user.name "Test User"
    git config user.email "test@example.com"
}

# Create a mock project structure
create_mock_project() {
    local project_type="$1"
    case "$project_type" in
        python)
            touch setup.py requirements.txt
            ;;
        react)
            touch package.json
            mkdir -p src
            ;;
        # ... more project types
    esac
}

# Assert file contains text
assert_file_contains() {
    local file="$1"
    local text="$2"
    run grep -q "$text" "$file"
    assert_success
}
```

## Continuous Integration

Tests run automatically on:
- Every push to any branch
- Every pull request
- Scheduled nightly builds

### CI Configuration

See `.github/workflows/test.yml` for GitHub Actions configuration.

**CI runs:**
1. Shellcheck linting
2. BATS test suite
3. Installation tests on multiple platforms
4. Integration tests with real projects

## Debugging Tests

### Enable Verbose Output

```bash
# Show test output even on success
bats --show-output-of-passing-tests tests/

# Use -x for bash debug mode
bats -x tests/test_setup.bats
```

### Debug Individual Tests

```bash
# Add debug output in tests
@test "debug example" {
    echo "Debug: variable value is $MY_VAR" >&3
    run command_to_test
    assert_success
}
```

### Run Tests with Debugging

```bash
# Enable bash debugging
DEBUG=true bats tests/test_setup.bats

# Run bash in debug mode
bash -x ./setup-ai-collaboration.sh --preset python
```

## Manual Testing

While automated tests are important, manual testing is still necessary:

### Manual Test Checklist

**Before Every Release:**
- [ ] Test installation on fresh repository (Python)
- [ ] Test installation on fresh repository (React)
- [ ] Test installation on fresh repository (Java)
- [ ] Test ai command suite (setup, status, rules, save, restore)
- [ ] Test on macOS
- [ ] Test on Linux
- [ ] Test on Windows/WSL
- [ ] Test with non-English characters in paths
- [ ] Test with spaces in paths
- [ ] Test with very long paths
- [ ] Test with nested git repositories

### Testing Specific Features

**Session Recovery:**
```bash
# Create session snapshot
./ai save "Test session"

# Modify project state
# ... make changes ...

# Restore session
./ai restore
# Verify state is restored
```

**Validation Rules:**
```bash
# Setup with preset
./ai setup --preset python

# Verify rules file
cat .ai-framework/rules/VALIDATION_RULES.md

# Test rule updates
./ai rules --add "New custom rule"
```

## Performance Testing

### Benchmarking

```bash
# Time command execution
time ./setup-ai-collaboration.sh --preset python

# Profile with detailed timing
bash -x ./setup-ai-collaboration.sh 2>&1 | ts -i '%.s'
```

### Performance Targets

- Installation: < 5 seconds
- Status check: < 1 second
- Rule addition: < 2 seconds
- Session save: < 3 seconds
- Session restore: < 5 seconds

## Contributing Tests

When contributing code, include tests:

1. **New Features**: Add tests in appropriate test file
2. **Bug Fixes**: Add regression test that would have caught the bug
3. **Refactoring**: Ensure existing tests still pass
4. **Documentation**: Update this README if adding new test patterns

### Test Review Checklist

- [ ] Tests are focused and test one thing
- [ ] Test names are descriptive
- [ ] Tests use appropriate assertions
- [ ] Tests clean up after themselves
- [ ] Tests are independent (don't rely on other tests)
- [ ] Tests are deterministic (same result every time)
- [ ] Edge cases are covered
- [ ] Error conditions are tested

## Resources

### BATS Documentation

- [BATS Core](https://github.com/bats-core/bats-core)
- [BATS Support](https://github.com/bats-core/bats-support)
- [BATS Assert](https://github.com/bats-core/bats-assert)

### Bash Testing Best Practices

- [Google Shell Style Guide - Testing](https://google.github.io/styleguide/shellguide.html#s7-testing)
- [Bash Testing with BATS](https://opensource.com/article/19/2/testing-bash-bats)

### CI/CD Testing

- [GitHub Actions for Bash](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-bash)

## Support

Questions about testing? Open an issue or discussion on GitHub.

---

**Remember: Good tests make confident refactoring possible. Test early, test often!**
