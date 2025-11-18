#!/usr/bin/env bash
#
# Common test helper functions for BATS tests
#

# Initialize a test git repository
setup_git_repo() {
    git init --quiet
    git config user.name "Test User"
    git config user.email "test@example.com"
}

# Create a mock Python project
create_python_project() {
    cat > setup.py <<EOF
from setuptools import setup
setup(name='test-project', version='1.0.0')
EOF

    cat > requirements.txt <<EOF
pytest>=7.0.0
black>=22.0.0
flake8>=4.0.0
EOF

    mkdir -p src tests
    touch src/__init__.py tests/__init__.py
}

# Create a mock React project
create_react_project() {
    cat > package.json <<EOF
{
  "name": "test-react-app",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "eslint": "^8.0.0",
    "prettier": "^2.8.0"
  }
}
EOF

    mkdir -p src public
    touch src/App.js public/index.html
}

# Create a mock Java project
create_java_project() {
    cat > pom.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.test</groupId>
    <artifactId>test-project</artifactId>
    <version>1.0.0</version>
</project>
EOF

    mkdir -p src/main/java src/test/java
}

# Assert file exists and is not empty
assert_file_exists_and_not_empty() {
    local file="$1"
    [ -f "$file" ] || return 1
    [ -s "$file" ] || return 1
}

# Assert directory exists
assert_directory_exists() {
    local dir="$1"
    [ -d "$dir" ] || return 1
}

# Assert file contains specific text
assert_file_contains() {
    local file="$1"
    local text="$2"
    grep -q "$text" "$file"
}

# Assert file does not contain text
assert_file_not_contains() {
    local file="$1"
    local text="$2"
    ! grep -q "$text" "$file"
}

# Get the project root directory
get_project_root() {
    # Assumes tests are in $PROJECT_ROOT/tests/
    dirname "$(dirname "${BASH_SOURCE[0]}")"
}

# Source a script for testing functions
source_script() {
    local script="$1"
    local project_root
    project_root="$(get_project_root)"

    # shellcheck source=/dev/null
    source "$project_root/$script"
}

# Create temporary test directory
create_temp_test_dir() {
    mktemp -d -t ai-collab-test.XXXXXX
}

# Cleanup function
cleanup_test_dir() {
    local dir="$1"
    if [[ -d "$dir" ]] && [[ "$dir" =~ ai-collab-test ]]; then
        rm -rf "$dir"
    fi
}

# Mock git command for testing
mock_git_command() {
    local exit_code="${1:-0}"
    local output="${2:-}"

    # Create a mock git function
    git() {
        if [[ -n "$output" ]]; then
            echo "$output"
        fi
        return "$exit_code"
    }
    export -f git
}

# Restore real git command
restore_git_command() {
    unset -f git
}

# Assert command output contains line
assert_output_contains_line() {
    local expected="$1"
    echo "$output" | grep -q "$expected"
}

# Count lines in output
count_output_lines() {
    echo "$output" | wc -l | tr -d ' '
}

# Get specific line from output
get_output_line() {
    local line_number="$1"
    echo "$output" | sed -n "${line_number}p"
}

# Print test context for debugging
print_test_context() {
    echo "=== Test Context ===" >&3
    echo "Working Directory: $PWD" >&3
    echo "Files:" >&3
    ls -la >&3
    echo "Git Status:" >&3
    git status 2>&1 >&3 || echo "Not a git repository" >&3
    echo "===================" >&3
}

# Wait for file to exist (useful for async operations)
wait_for_file() {
    local file="$1"
    local timeout="${2:-5}"
    local elapsed=0

    while [[ ! -f "$file" ]] && [[ $elapsed -lt $timeout ]]; do
        sleep 0.1
        elapsed=$((elapsed + 1))
    done

    [[ -f "$file" ]]
}

# Compare file content with expected
assert_file_equals() {
    local file="$1"
    local expected="$2"

    local actual
    actual="$(cat "$file")"

    [[ "$actual" == "$expected" ]]
}

# Assert exit code
assert_exit_code() {
    local expected="$1"
    local actual="$status"

    [[ "$actual" -eq "$expected" ]]
}
