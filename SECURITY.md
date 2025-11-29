# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly:

1. **Do not** open a public issue for security vulnerabilities
2. Email the maintainers directly with details of the vulnerability
3. Include steps to reproduce the issue if possible
4. Allow reasonable time for a fix before public disclosure

## Security Considerations

### Script Execution

This project contains shell scripts that execute with user permissions. Before running:

- Review script contents before execution
- Ensure scripts are from trusted sources
- Do not run scripts with elevated privileges unless necessary

### File Permissions

- Scripts should be executable only by intended users
- Sensitive configuration files should have restricted read access
- Avoid storing credentials in repository files

### Git Hooks

If using git hooks from this project:

- Review hook contents before installation
- Hooks run automatically on git operations
- Malicious hooks could compromise your system

## Best Practices

1. Keep your local copy updated with security patches
2. Review changes before merging to your projects
3. Use branch protection rules on main branches
4. Enable signed commits when possible
