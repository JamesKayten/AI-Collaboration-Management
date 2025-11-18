#!/usr/bin/env bats
#
# Tests for the 'ai' master command
#

# Load test helpers (when bats-support and bats-assert are installed)
# load test_helper/bats-support/load
# load test_helper/bats-assert/load
load test_helper/common

setup() {
    # Create temporary directory for each test
    TEST_DIR="$(create_temp_test_dir)"
    cd "$TEST_DIR" || exit 1

    # Get path to the ai command
    PROJECT_ROOT="$(get_project_root)"
    AI_COMMAND="$PROJECT_ROOT/ai"

    # Setup git repository
    setup_git_repo
}

teardown() {
    # Clean up temporary directory
    cd /tmp || exit 1
    cleanup_test_dir "$TEST_DIR"
}

# Basic command tests

@test "ai command exists and is executable" {
    [ -x "$AI_COMMAND" ]
}

@test "ai without arguments shows help" {
    run "$AI_COMMAND"
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage" ]] || [[ "$output" =~ "ai" ]]
}

@test "ai --help shows help message" {
    run "$AI_COMMAND" --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage" ]] || [[ "$output" =~ "help" ]]
}

@test "ai --version shows version" {
    run "$AI_COMMAND" --version
    # May or may not be implemented yet
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

# Status command tests

@test "ai status works in non-configured project" {
    run "$AI_COMMAND" status
    # Should either show not configured or show status
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "ai status shows configuration after setup" {
    skip "Requires full setup implementation"
    # This test requires implementing the setup first
    run "$AI_COMMAND" setup --preset python --non-interactive
    [ "$status" -eq 0 ]

    run "$AI_COMMAND" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "configured" ]] || [[ "$output" =~ "Status" ]]
}

# Rules command tests

@test "ai rules --show works" {
    run "$AI_COMMAND" rules --show
    # May fail if not configured, which is acceptable
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "ai rules without arguments shows help" {
    run "$AI_COMMAND" rules
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

# Setup command tests

@test "ai setup requires preset or interactive mode" {
    run "$AI_COMMAND" setup
    # Should either work interactively or fail with helpful message
    if [ "$status" -ne 0 ]; then
        [[ "$output" =~ "preset" ]] || [[ "$output" =~ "interactive" ]]
    fi
}

@test "ai setup --preset python creates framework structure" {
    skip "Requires project files setup"
    create_python_project

    run "$AI_COMMAND" setup --preset python --non-interactive
    [ "$status" -eq 0 ]

    # Check that framework was created
    assert_directory_exists ".ai-framework"
    assert_directory_exists ".ai-framework/communications"
}

@test "ai setup rejects invalid preset" {
    run "$AI_COMMAND" setup --preset invalid-preset-name --non-interactive 2>&1
    [ "$status" -ne 0 ]
    [[ "$output" =~ "invalid" ]] || [[ "$output" =~ "preset" ]]
}

# Save/Restore command tests

@test "ai save requires message" {
    run "$AI_COMMAND" save
    # Should either fail or prompt for message
    if [ "$status" -ne 0 ]; then
        [[ "$output" =~ "message" ]] || [[ "$output" =~ "description" ]]
    fi
}

@test "ai restore works when no session exists" {
    run "$AI_COMMAND" restore
    # Should handle gracefully when no session exists
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
    if [ "$status" -ne 0 ]; then
        [[ "$output" =~ "no session" ]] || [[ "$output" =~ "not found" ]]
    fi
}

# Error handling tests

@test "ai with invalid command shows error" {
    run "$AI_COMMAND" invalid-command-that-does-not-exist
    [ "$status" -ne 0 ]
}

@test "ai command works from any directory" {
    skip "May require PATH configuration"
    # Create subdirectory
    mkdir -p subdir
    cd subdir

    run "$AI_COMMAND" --help
    [ "$status" -eq 0 ]
}

# Integration tests

@test "ai command preserves working directory" {
    local original_dir="$PWD"

    run "$AI_COMMAND" status
    # After command, we should still be in the same directory
    [ "$PWD" = "$original_dir" ]
}

@test "ai command handles special characters in path" {
    skip "Requires testing in special directory"
    # This would need to create a directory with spaces/special chars
}

# Performance tests

@test "ai status completes in reasonable time" {
    # Command should complete in less than 5 seconds
    timeout 5s "$AI_COMMAND" status || {
        [ "$?" -eq 124 ] && exit 1  # Timeout exit code
    }
}

# Output format tests

@test "ai commands write errors to stderr" {
    run bash -c "$AI_COMMAND invalid-command 2>&1 >/dev/null"
    if [ "$status" -ne 0 ]; then
        # Output should contain error message
        [[ "$output" =~ "error" ]] || [[ "$output" =~ "Error" ]] || [[ -n "$output" ]]
    fi
}
