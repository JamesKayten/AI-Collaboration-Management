# Troubleshooting Guide

This guide covers common issues and solutions for Avery's AI Collaboration Hack.

## Installation Issues

### "Not a git repository" Error

**Problem**: Installation fails with error about not being in a git repository.

**Solutions**:
1. Make sure you're in a git-initialized directory:
   ```bash
   git init
   ```
2. If you already have a git repository, make sure you're in the root directory:
   ```bash
   cd /path/to/your/project-root
   ls -la .git  # Should exist
   ```

### Permission Denied Errors

**Problem**: Cannot write to `docs/` directory.

**Solutions**:
1. Check directory permissions:
   ```bash
   ls -la docs/
   chmod 755 docs/  # If needed
   ```
2. Make sure you own the directory:
   ```bash
   sudo chown -R $USER:$USER docs/
   ```

### Install Script Won't Execute

**Problem**: `./install.sh: Permission denied`

**Solution**:
```bash
chmod +x install.sh
./install.sh
```

### Windows Installation Issues

**Problem**: Script fails on Windows.

**Solutions**:
1. Use WSL (Windows Subsystem for Linux):
   ```bash
   wsl
   cd /mnt/c/path/to/your/project
   ```
2. Use Git Bash (comes with Git for Windows)
3. Use PowerShell with Unix-like commands enabled

## Validation Issues

### Validation Commands Not Found

**Problem**: Commands like `black`, `flake8`, `pytest` not found.

**Solutions**:
1. Install project dependencies:
   ```bash
   # Python projects
   pip install black flake8 pytest pytest-cov

   # Node.js projects
   npm install eslint prettier jest

   # Java projects
   # Install Maven/Gradle dependencies
   ```

2. Update validation commands in `docs/ai_communication/VALIDATION_RULES.md` to match your tools

### Placeholders Not Replaced

**Problem**: Files still contain `{{PROJECT_NAME}}` or other placeholders.

**Solutions**:
1. Re-run the installer:
   ```bash
   rm -rf docs/ai_communication docs/AI_*.md
   ../Averys-AI-Collaboration-Hack/install.sh
   ```
2. Manually replace placeholders:
   ```bash
   # Find all placeholder files
   grep -r "{{" docs/

   # Replace manually or with sed
   sed -i 's/{{PROJECT_NAME}}/MyProject/g' docs/ai_communication/VALIDATION_RULES.md
   ```

### AI Can't Find Communication Files

**Problem**: AI reports it can't find `docs/ai_communication/` files.

**Solutions**:
1. Verify files exist:
   ```bash
   ls -la docs/ai_communication/
   ```
2. Check file permissions:
   ```bash
   chmod 644 docs/ai_communication/*
   ```
3. Ensure you're in the project root when running AI commands

## Git Integration Issues

### Branch Conflicts

**Problem**: AI tries to merge conflicting branches.

**Solutions**:
1. Manually resolve conflicts:
   ```bash
   git status
   git diff
   # Resolve conflicts in your editor
   git add .
   git commit -m "Resolve merge conflicts"
   ```
2. Reset to a clean state:
   ```bash
   git reset --hard HEAD
   git clean -fd
   ```

### Remote Repository Sync Issues

**Problem**: Local and remote repositories out of sync.

**Solutions**:
1. Pull latest changes:
   ```bash
   git fetch origin
   git pull origin main
   ```
2. Force sync (use carefully):
   ```bash
   git fetch origin
   git reset --hard origin/main
   ```

## AI Tool Integration

### Local AI Not Recognizing "work ready" Command

**Problem**: Local AI doesn't respond to the workflow trigger.

**Solutions**:
1. Make sure you've read the `AI_WORKFLOW.md` file in your project
2. Try alternative phrasing: "Check for code validation" or "Run quality checks"
3. Manually point AI to the workflow: "Check docs/AI_WORKFLOW.md and follow the instructions"

### Online AI Can't Access Repository Files

**Problem**: Online AI says it can't read local files.

**Solutions**:
1. Copy file contents manually:
   ```bash
   cat docs/ai_communication/AI_REPORT_*.md
   ```
2. Upload files to cloud storage temporarily
3. Use git repository on a platform like GitHub for shared access

### Communication Files Not Being Created

**Problem**: No AI_REPORT_*.md files being generated.

**Solutions**:
1. Check if validation is actually running:
   ```bash
   # Test validation commands manually
   black --check .
   flake8 .
   ```
2. Verify AI has write permissions:
   ```bash
   touch docs/ai_communication/test.md
   rm docs/ai_communication/test.md
   ```

## Platform-Specific Issues

### macOS

**Problem**: "Operation not permitted" errors.

**Solutions**:
1. Give terminal full disk access in System Preferences → Privacy
2. Use `sudo` for system-level operations (use carefully)

### Linux

**Problem**: Package manager conflicts.

**Solutions**:
1. Update package manager:
   ```bash
   sudo apt update  # Ubuntu/Debian
   sudo yum update  # CentOS/RHEL
   ```
2. Install missing dependencies:
   ```bash
   sudo apt install git python3-pip nodejs npm  # Common tools
   ```

### Windows

**Problem**: Path separators and line endings.

**Solutions**:
1. Configure git for Windows line endings:
   ```bash
   git config --global core.autocrlf true
   ```
2. Use forward slashes in paths when possible
3. Install Windows Subsystem for Linux (WSL) for full compatibility

## Performance Issues

### Slow Validation

**Problem**: Validation takes too long to run.

**Solutions**:
1. Reduce scope in validation rules:
   ```bash
   # Edit docs/ai_communication/VALIDATION_RULES.md
   # Add file/directory exclusions
   ```
2. Use faster tools:
   ```bash
   # Replace slow linters with faster alternatives
   # Use parallel execution where possible
   ```

### Large Repository Problems

**Problem**: Framework struggles with very large codebases.

**Solutions**:
1. Exclude large directories:
   ```bash
   echo "node_modules/\n.git/\nbuild/\ndist/" >> .gitignore
   ```
2. Use file-specific validation instead of whole-repository scans
3. Split large files before using framework

## Getting More Help

If these solutions don't help:

1. **Search existing issues**: [GitHub Issues](https://github.com/JamesKayten/Averys-AI-Collaboration-Hack/issues)
2. **Check discussions**: [GitHub Discussions](https://github.com/JamesKayten/Averys-AI-Collaboration-Hack/discussions)
3. **Create new issue**: Include your OS, AI tools, error messages, and steps to reproduce
4. **Review FAQ**: [FAQ.md](FAQ.md) for common questions

## Debug Information to Include

When reporting issues, please include:

```bash
# System information
uname -a
git --version
python --version  # If using Python tools
node --version    # If using Node.js tools

# Project information
pwd
ls -la docs/
cat docs/ai_communication/VALIDATION_RULES.md

# Error output
# Include full error messages and command output
```

## Quick Fixes Checklist

Before asking for help, try these quick fixes:

- [ ] Re-run the installation script
- [ ] Check you're in the project root directory
- [ ] Verify git repository is properly initialized
- [ ] Ensure all validation tools are installed
- [ ] Check file permissions (read/write access)
- [ ] Try with a fresh test project first
- [ ] Review the validation rules for typos
- [ ] Test validation commands manually

Most issues are resolved by one of these steps! 🚀