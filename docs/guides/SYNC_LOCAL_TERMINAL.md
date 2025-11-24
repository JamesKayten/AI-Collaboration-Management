# Sync Local Terminal with Framework Repository

## Current Status

**Repository**: `JamesKayten/AI-Collaboration-Management`
**Branch**: `claude/separate-framework-repo-01VmyghHhGWUoW8Usbi7RHRs`
**Latest Commits**:
- `53758a5` - Add Quick Start Workflow guide
- `a76c2f6` - Add OCC activation helper and AI command wrapper
- `a658952` - Update installer to use v2.0 professional structure
- `8e74cc8` - Add comprehensive framework installation test report
- `1a356b1` - Transform repository into professional open-source framework

---

## Steps to Sync Your Local Terminal

### Option 1: Fresh Clone (Recommended)

If you don't have the repository locally yet:

```bash
# In your local terminal
cd ~/Projects  # or wherever you keep repos

# Clone the repository
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git

cd AI-Collaboration-Management

# Fetch our working branch
git fetch origin claude/separate-framework-repo-01VmyghHhGWUoW8Usbi7RHRs

# Check out the branch
git checkout claude/separate-framework-repo-01VmyghHhGWUoW8Usbi7RHRs

# Verify you have latest
git log --oneline -5
```

Expected output:
```
53758a5 Add Quick Start Workflow guide
a76c2f6 Add OCC activation helper and AI command wrapper
a658952 Update installer to use v2.0 professional structure
...
```

### Option 2: Update Existing Clone

If you already have the repository locally:

```bash
# In your local terminal
cd /path/to/AI-Collaboration-Management

# Fetch all latest changes
git fetch --all

# Check out our working branch
git checkout claude/separate-framework-repo-01VmyghHhGWUoW8Usbi7RHRs

# Pull latest changes
git pull origin claude/separate-framework-repo-01VmyghHhGWUoW8Usbi7RHRs

# Verify sync
git log --oneline -5
```

### Option 3: If You Have Local Changes

If you have uncommitted changes:

```bash
# Save your changes
git stash

# Update
git checkout claude/separate-framework-repo-01VmyghHhGWUoW8Usbi7RHRs
git pull origin claude/separate-framework-repo-01VmyghHhGWUoW8Usbi7RHRs

# Restore your changes
git stash pop
```

---

## Verify Sync

After syncing, verify these files exist:

```bash
# Check for new scripts
ls -la scripts/activate-occ.sh
ls -la templates/ai-helper.sh

# Check for documentation
ls -la QUICK_START_WORKFLOW.md
ls -la CONTRIBUTING.md
ls -la CODE_OF_CONDUCT.md

# Check examples
ls -la examples/react-webapp/
ls -la examples/python-datascience/

# Check installer version
grep "v2.0" setup-ai-collaboration.sh
```

Expected results:
- ✅ All files should exist
- ✅ Installer should create `framework/` structure
- ✅ Should have `./ai` helper script

---

## What's New in This Sync

### 1. Professional Open-Source Structure ✅
- CONTRIBUTING.md
- CODE_OF_CONDUCT.md
- GitHub issue/PR templates
- CI/CD workflows
- Examples directory

### 2. Updated Framework Structure ✅
- Installer now creates `framework/` instead of `docs/ai_communication/`
- Proper subdirectories: `reports/`, `responses/`, `updates/`
- PROJECT_STATE.md auto-generation

### 3. OCC Activation Helper ✅
- `scripts/activate-occ.sh` - Generates OCC prompts
- `./ai activate` - Quick command wrapper
- `./ai status` - Check framework status

### 4. Complete Documentation ✅
- QUICK_START_WORKFLOW.md - Daily workflow guide
- Architecture documentation
- Real-world examples (React, Python)
- Test reports

---

## Test After Sync

Once synced, test the framework:

```bash
# Create test project
mkdir ~/test-framework
cd ~/test-framework
git init

# Install framework
bash ~/Projects/AI-Collaboration-Management/setup-ai-collaboration.sh \
  --preset react --max-file-size 150 --test-coverage 85

# Verify installation
ls -la framework/
ls -la ./ai

# Test helper
./ai status
./ai help
```

Expected output:
```
✅ Framework installed
📊 Reports: 0
📬 Responses: 0
```

---

## For SimpleCP Project

After syncing the framework, re-install in SimpleCP:

```bash
cd /path/to/SimpleCP

# Remove old structure (if exists)
rm -rf docs/ai_communication framework

# Install latest framework
bash /path/to/AI-Collaboration-Management/setup-ai-collaboration.sh \
  --preset react --max-file-size 150 --test-coverage 85

# Verify new structure
ls -la framework/communications/
ls -la ./ai

# Test commands
./ai status
./ai activate
```

---

## Troubleshooting

### "fatal: not a git repository"
```bash
# Make sure you're in the right directory
cd /path/to/AI-Collaboration-Management
git status
```

### "Branch not found"
```bash
# Fetch all branches first
git fetch --all
git branch -a  # Should see: remotes/origin/claude/separate-framework-repo-...
git checkout claude/separate-framework-repo-01VmyghHhGWUoW8Usbi7RHRs
```

### "Your local changes would be overwritten"
```bash
# Stash your changes
git stash
git pull
git stash pop
```

### "Permission denied"
```bash
# Make scripts executable
chmod +x scripts/activate-occ.sh
chmod +x templates/ai-helper.sh
chmod +x setup-ai-collaboration.sh
```

---

## Quick Verification Commands

```bash
# All in one verification
cd /path/to/AI-Collaboration-Management

echo "📍 Repository Check:"
git remote -v | grep "AI-Collaboration-Management"

echo -e "\n🌿 Branch Check:"
git branch --show-current

echo -e "\n📝 Latest Commits:"
git log --oneline -5

echo -e "\n📦 Key Files:"
ls -1 scripts/activate-occ.sh \
      templates/ai-helper.sh \
      QUICK_START_WORKFLOW.md \
      CONTRIBUTING.md \
      examples/react-webapp/ \
      2>/dev/null && echo "✅ All key files present" || echo "❌ Some files missing"

echo -e "\n✨ Sync Status:"
git status
```

---

## After Sync - Next Steps

1. **Test the Framework**:
   ```bash
   ./ai help
   ```

2. **Install in SimpleCP**:
   ```bash
   cd /path/to/SimpleCP
   bash /path/to/AI-Collaboration-Management/setup-ai-collaboration.sh --preset react
   ```

3. **Verify Installation**:
   ```bash
   ./ai status
   ./ai activate
   ```

4. **Start Using**:
   - Have Browser Claude implement features
   - Local Claude validates with "work ready"
   - Use `./ai activate` to get OCC prompt

---

**You're ready to start collaborating with AI once your local terminal is synced!** 🚀
