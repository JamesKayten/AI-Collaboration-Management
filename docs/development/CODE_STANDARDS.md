# Code Standards and Style Guide

This document defines the coding standards and style guidelines for the AI-Collaboration-Management project.

## Table of Contents

- [Philosophy](#philosophy)
- [Shell Script Standards](#shell-script-standards)
- [Documentation Standards](#documentation-standards)
- [File Organization](#file-organization)
- [Git Practices](#git-practices)
- [Code Review Guidelines](#code-review-guidelines)

## Philosophy

### Core Values

1. **Simplicity** - Write simple, straightforward code
2. **Clarity** - Code should be self-documenting when possible
3. **Robustness** - Handle errors explicitly and gracefully
4. **Compatibility** - Support multiple platforms and bash versions
5. **Zero Dependencies** - Avoid external dependencies when possible

### Design Principles

- **KISS** (Keep It Simple, Stupid) - Prefer simple solutions
- **DRY** (Don't Repeat Yourself) - Extract common functionality
- **YAGNI** (You Aren't Gonna Need It) - Don't add unused features
- **Defensive Programming** - Validate inputs, handle errors
- **Convention Over Configuration** - Provide sensible defaults

## Shell Script Standards

### File Structure

Every shell script should follow this structure:

```bash
#!/usr/bin/env bash
#
# Script Name: descriptive-name.sh
# Description: What this script does
# Version: 1.0.0
# Author: Your Name
# License: MIT
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Optional: Enable debug mode
# set -x

#######################################
# Constants
#######################################
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "$0")"
readonly VERSION="1.0.0"

#######################################
# Global Variables
#######################################
DEBUG="${DEBUG:-false}"

#######################################
# Functions
#######################################

# Function implementations...

#######################################
# Main
#######################################

main() {
    # Main script logic
}

# Run main function
main "$@"
```

### Naming Conventions

#### Files

- Use lowercase with hyphens: `setup-ai-collaboration.sh`
- Extension `.sh` for scripts
- Make scripts executable: `chmod +x script.sh`

#### Functions

```bash
# Use snake_case for function names
validate_input() {
    # Function body
}

# Private functions start with underscore
_internal_helper() {
    # Private function
}

# Use descriptive names
# Good: validate_project_type, create_directory_structure
# Bad: validate, create, do_stuff
```

#### Variables

```bash
# Constants: UPPERCASE
readonly DEFAULT_PRESET="python"
readonly MAX_RETRIES=3

# Global variables: lowercase with underscores
project_root="/path/to/project"
user_input=""

# Local variables: lowercase with underscores
local file_path="/tmp/file"
local -r readonly_local="value"

# Environment variables: UPPERCASE (when exporting)
export PROJECT_TYPE="python"
```

### Shebang and Options

#### Always Use

```bash
#!/usr/bin/env bash
set -euo pipefail
```

**Explanation:**
- `#!/usr/bin/env bash` - Portable bash shebang
- `set -e` - Exit on error
- `set -u` - Exit on undefined variable
- `set -o pipefail` - Pipe failures cause exit

#### Optional Debug Mode

```bash
# Enable with: DEBUG=true ./script.sh
DEBUG="${DEBUG:-false}"

if [[ "$DEBUG" == "true" ]]; then
    set -x  # Print commands as executed
fi
```

### Error Handling

#### Always Handle Errors

```bash
# Good: Explicit error handling
if ! command_that_might_fail; then
    echo "Error: Command failed" >&2
    return 1
fi

# Good: With error message
create_directory() {
    local dir="$1"

    if ! mkdir -p "$dir"; then
        echo "Error: Failed to create directory: $dir" >&2
        return 1
    fi

    return 0
}

# Bad: No error handling
command_that_might_fail
mkdir "$dir"
```

#### Error Messages

```bash
# Always write errors to stderr
echo "Error: Something went wrong" >&2

# Include context in error messages
echo "Error: Failed to read file: $file_path" >&2

# Use consistent error format
error_msg() {
    echo "Error: $*" >&2
}

error_msg "Failed to validate input: $input"
```

#### Exit Codes

```bash
# Define meaningful exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_INVALID_ARGS=1
readonly EXIT_MISSING_DEPENDENCY=2
readonly EXIT_OPERATION_FAILED=3
readonly EXIT_PERMISSION_DENIED=4

# Use appropriate exit codes
if [[ $# -lt 1 ]]; then
    echo "Error: Missing required argument" >&2
    exit $EXIT_INVALID_ARGS
fi
```

### Input Validation

#### Always Validate Inputs

```bash
validate_project_type() {
    local project_type="${1:-}"

    # Check if empty
    if [[ -z "$project_type" ]]; then
        echo "Error: Project type is required" >&2
        return 1
    fi

    # Whitelist validation
    case "$project_type" in
        python|react|java|mobile|data-science)
            return 0
            ;;
        *)
            echo "Error: Invalid project type: $project_type" >&2
            echo "Valid types: python, react, java, mobile, data-science" >&2
            return 1
            ;;
    esac
}
```

#### Sanitize User Input

```bash
sanitize_filename() {
    local filename="$1"

    # Remove dangerous characters
    filename="${filename//[^a-zA-Z0-9._-]/}"

    # Remove leading dots and dashes
    filename="${filename#[.-]}"

    echo "$filename"
}

# Example usage
user_filename="$(sanitize_filename "$user_input")"
```

### String Handling

#### Quoting

```bash
# Always quote variables
echo "$variable"
cd "$directory"
command --arg="$value"

# Quote arrays correctly
files=("file1.txt" "file2.txt")
for file in "${files[@]}"; do
    echo "$file"
done

# Don't quote when word splitting is intended
# shellcheck disable=SC2086
command $options  # Only if $options should be split
```

#### String Comparisons

```bash
# Use [[ ]] for string comparisons
if [[ "$var" == "value" ]]; then
    # Do something
fi

# Check if empty
if [[ -z "$var" ]]; then
    echo "Variable is empty"
fi

# Check if not empty
if [[ -n "$var" ]]; then
    echo "Variable has value"
fi

# Pattern matching
if [[ "$filename" == *.sh ]]; then
    echo "Shell script"
fi
```

### Functions

#### Function Documentation

```bash
#######################################
# Brief description of function
# Globals:
#   GLOBAL_VAR_1
#   GLOBAL_VAR_2
# Arguments:
#   $1 - Description of first argument
#   $2 - Description of second argument (optional)
# Outputs:
#   Writes description to stdout
#   Writes errors to stderr
# Returns:
#   0 on success, non-zero on error
#######################################
function_name() {
    local arg1="$1"
    local arg2="${2:-default_value}"

    # Function implementation
}
```

#### Return Values

```bash
# Use return for status codes
check_condition() {
    if [[ condition ]]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Use echo for output
get_project_root() {
    local current_dir
    current_dir="$(pwd)"

    # Find project root...

    echo "$project_root"  # Output result
}

# Usage
if check_condition; then
    project_root="$(get_project_root)"
fi
```

#### Local Variables

```bash
# Always use local for function variables
my_function() {
    local file_path="$1"
    local -r readonly_var="constant"
    local -a array_var=()
    local -i integer_var=0

    # Function body
}
```

### File Operations

#### Check Before Operating

```bash
# Check file exists and is readable
if [[ -f "$file" ]] && [[ -r "$file" ]]; then
    content="$(cat "$file")"
fi

# Check directory exists
if [[ ! -d "$directory" ]]; then
    mkdir -p "$directory"
fi

# Check if executable
if [[ -x "$script" ]]; then
    "$script"
fi
```

#### Safe File Creation

```bash
# Create file safely
create_config_file() {
    local file="$1"
    local content="$2"

    # Check if file already exists
    if [[ -f "$file" ]]; then
        echo "Warning: File already exists: $file" >&2
        read -p "Overwrite? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi

    # Write content
    if ! echo "$content" > "$file"; then
        echo "Error: Failed to write file: $file" >&2
        return 1
    fi

    return 0
}
```

#### Temporary Files

```bash
# Create temporary file
temp_file="$(mktemp)"
trap 'rm -f "$temp_file"' EXIT

# Create temporary directory
temp_dir="$(mktemp -d)"
trap 'rm -rf "$temp_dir"' EXIT
```

### Command Execution

#### Use Command Substitution

```bash
# Good: $() is preferred
current_dir="$(pwd)"
file_count="$(ls -1 | wc -l)"

# Avoid: backticks (deprecated)
# current_dir=`pwd`
```

#### Check Command Availability

```bash
# Check if command exists
if ! command -v git &>/dev/null; then
    echo "Error: git is required but not installed" >&2
    exit 1
fi

# Function to check dependencies
check_dependencies() {
    local -a deps=("git" "bash" "awk")

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            echo "Error: Required command not found: $dep" >&2
            return 1
        fi
    done

    return 0
}
```

### Arrays

#### Array Usage

```bash
# Define arrays
declare -a files=()
local -a options=("--verbose" "--color=auto")

# Add elements
files+=("file1.txt")
files+=("file2.txt")

# Iterate over arrays
for file in "${files[@]}"; do
    echo "$file"
done

# Array length
echo "Array has ${#files[@]} elements"

# Check if array contains element
if [[ " ${files[*]} " =~ " file1.txt " ]]; then
    echo "Array contains file1.txt"
fi
```

### Logging and Output

#### Structured Logging

```bash
# Log levels
readonly LOG_ERROR=0
readonly LOG_WARN=1
readonly LOG_INFO=2
readonly LOG_DEBUG=3

LOG_LEVEL="${LOG_LEVEL:-$LOG_INFO}"

log() {
    local level="$1"
    shift
    local message="$*"

    if [[ $level -le $LOG_LEVEL ]]; then
        case "$level" in
            $LOG_ERROR)
                echo "[ERROR] $message" >&2
                ;;
            $LOG_WARN)
                echo "[WARN] $message" >&2
                ;;
            $LOG_INFO)
                echo "[INFO] $message"
                ;;
            $LOG_DEBUG)
                echo "[DEBUG] $message"
                ;;
        esac
    fi
}

# Usage
log $LOG_INFO "Starting installation"
log $LOG_ERROR "Failed to create directory"
log $LOG_DEBUG "Variable value: $var"
```

#### User-Facing Messages

```bash
# Success messages
echo "✓ Installation completed successfully"

# Error messages
echo "✗ Installation failed" >&2

# Progress indicators
echo "Processing files..."
echo "  [1/5] Validating configuration"
echo "  [2/5] Creating directory structure"
```

### Performance

#### Minimize Subshells

```bash
# Good: Use built-in parameter expansion
filename="${path##*/}"
dirname="${path%/*}"
extension="${filename##*.}"

# Avoid: Unnecessary subshells
# filename="$(basename "$path")"
# dirname="$(dirname "$path")"
```

#### Efficient Loops

```bash
# Good: Process in single loop
while IFS= read -r line; do
    process "$line"
done < file.txt

# Avoid: Multiple passes over same file
# lines="$(cat file.txt)"
# for line in $lines; do
#     process "$line"
# done
```

## Documentation Standards

### Inline Comments

```bash
# Good comments explain WHY, not WHAT

# Workaround for macOS sed compatibility issue
sed -i.bak 's/pattern/replacement/' file

# Initialize empty array to collect error messages
local -a errors=()

# Bad comments (explain obvious)
# Set variable to value
var="value"

# Loop through files
for file in *.txt; do
    # ...
done
```

### Function Comments

See [Function Documentation](#function-documentation) above.

### File Headers

See [File Structure](#file-structure) above.

## File Organization

### Directory Structure

```
project/
├── script-name.sh          # Main executable scripts
├── lib/                    # Shared library functions (if needed)
│   ├── common.sh
│   └── validators.sh
├── templates/              # Template files
├── docs/                   # Documentation
├── tests/                  # Test files
└── scripts/                # Utility scripts
```

### Code Organization

- Keep scripts focused and single-purpose
- Extract common functionality into functions
- Consider creating library files for shared code
- Limit file length (aim for < 500 lines per file)

## Git Practices

### Commit Messages

See [DEVELOPMENT.md](./DEVELOPMENT.md) for detailed commit message guidelines.

### Branch Naming

```
feature/add-go-support
fix/handle-spaces-in-paths
docs/update-readme
refactor/extract-validation
test/add-bats-tests
```

## Code Review Guidelines

### Checklist for Reviewers

- [ ] Code follows style guide
- [ ] Error handling is comprehensive
- [ ] Variables are properly quoted
- [ ] Functions have documentation
- [ ] No hardcoded values
- [ ] shellcheck passes
- [ ] Tests are included
- [ ] Documentation is updated
- [ ] No security issues
- [ ] Backward compatible

### What to Look For

**Good:**
- Clear, descriptive names
- Comprehensive error handling
- Defensive programming
- Good documentation
- Efficient code

**Bad:**
- Global variables without readonly
- Missing error handling
- Unquoted variables
- Unclear function names
- Hardcoded values
- No input validation

## Tools and Automation

### ShellCheck

Always run shellcheck:

```bash
shellcheck script.sh
shellcheck -x script.sh  # Follow sourced files
```

### Formatting

Use consistent formatting:

```bash
# Install shfmt
brew install shfmt

# Format file
shfmt -w -i 4 -ci script.sh
```

### Pre-commit Hooks

```bash
# .git/hooks/pre-commit
#!/bin/bash
shellcheck *.sh scripts/*.sh || exit 1
```

## Resources

- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck Wiki](https://www.shellcheck.net/wiki/)
- [Bash Hackers Wiki](https://wiki.bash-hackers.org/)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)

---

**Remember: Consistency is key. Follow these standards to maintain high code quality and make the codebase accessible to all contributors.**
