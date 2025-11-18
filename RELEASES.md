# Release Management

This document describes the release process for AI-Collaboration-Management.

## Versioning

We follow [Semantic Versioning](https://semver.org/) (SemVer):

```
MAJOR.MINOR.PATCH

Example: 2.1.3
```

### Version Components

- **MAJOR** - Incompatible API changes
- **MINOR** - Backward-compatible new functionality
- **PATCH** - Backward-compatible bug fixes

### Version Examples

| Change Type | Old Version | New Version | Example |
|-------------|-------------|-------------|---------|
| Breaking change | 2.1.3 | 3.0.0 | Remove deprecated command |
| New feature | 2.1.3 | 2.2.0 | Add new preset type |
| Bug fix | 2.1.3 | 2.1.4 | Fix path handling bug |
| Security fix | 2.1.3 | 2.1.4 | Patch security vulnerability |

### Pre-release Versions

```
1.0.0-alpha.1    # Alpha release
1.0.0-beta.2     # Beta release
1.0.0-rc.1       # Release candidate
```

## Release Types

### Patch Release (2.1.3 → 2.1.4)

**When:**
- Bug fixes
- Security patches
- Documentation updates
- Minor improvements

**Process:**
1. Create fix branch from main
2. Implement fix
3. Update CHANGELOG.md
4. Test thoroughly
5. Tag and release

**Timeline:** 1-3 days

### Minor Release (2.1.3 → 2.2.0)

**When:**
- New features
- New presets
- Enhanced functionality
- Non-breaking improvements

**Process:**
1. Feature development on feature branch
2. Merge to develop
3. Testing period (1-2 weeks)
4. Update CHANGELOG.md
5. Merge to main
6. Tag and release

**Timeline:** 2-4 weeks

### Major Release (2.1.3 → 3.0.0)

**When:**
- Breaking changes
- Major refactoring
- Significant architectural changes
- Removed deprecated features

**Process:**
1. Development on major version branch
2. Extended beta testing
3. Migration guide creation
4. Comprehensive documentation update
5. Community announcement
6. Tag and release

**Timeline:** 1-3 months

## Release Schedule

### Regular Releases

- **Patch releases**: As needed (security fixes immediately)
- **Minor releases**: Monthly (first week of month)
- **Major releases**: Quarterly or as needed

### Emergency Releases

Security vulnerabilities trigger immediate patch releases:
- Critical: Within 24 hours
- High: Within 1 week
- Medium: Next scheduled patch

## Release Process

### 1. Pre-Release Checklist

#### Code Quality

- [ ] All tests pass (`bats tests/`)
- [ ] shellcheck passes with no warnings
- [ ] Installation test succeeds (`./scripts/test_installation.sh`)
- [ ] Manual testing completed on all supported platforms
- [ ] No known critical bugs

#### Documentation

- [ ] CHANGELOG.md updated with all changes
- [ ] README.md reflects new features/changes
- [ ] Documentation updated for new features
- [ ] Migration guide created (for breaking changes)
- [ ] Version numbers updated in all files

#### Testing

- [ ] Tested on Ubuntu (latest)
- [ ] Tested on macOS (latest)
- [ ] Tested on Windows/WSL (if applicable)
- [ ] Tested with Python projects
- [ ] Tested with React projects
- [ ] Tested with other supported project types
- [ ] Session recovery tested
- [ ] Fresh installation tested

### 2. Version Update

Update version numbers in:

```bash
# Update version in files
VERSION="2.1.0"

# Update in ai command
sed -i "s/VERSION=.*/VERSION=\"$VERSION\"/" ai

# Update in setup script
sed -i "s/VERSION=.*/VERSION=\"$VERSION\"/" setup-ai-collaboration.sh

# Update in CHANGELOG.md (add new section)
# Update in README.md (if showing version)
```

### 3. Update CHANGELOG

Follow [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

## [2.1.0] - 2025-11-18

### Added
- New Go language preset
- Support for custom validation rules
- Command completion for bash and zsh

### Changed
- Improved error messages for missing dependencies
- Updated documentation with more examples

### Fixed
- Fixed issue with spaces in project paths
- Corrected session recovery for nested git repos

## [2.0.0] - 2025-10-15

### Added
- Complete framework restructuring
- Hidden `.ai-framework/` directory
- Master `ai` command

### Changed
- **BREAKING**: Renamed project to AI-Collaboration-Management
- **BREAKING**: Changed command structure

### Removed
- **BREAKING**: Removed deprecated `install.sh` in favor of `ai setup`

[Unreleased]: https://github.com/USER/REPO/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/USER/REPO/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/USER/REPO/releases/tag/v2.0.0
```

### 4. Create Release Branch

```bash
# For minor/major releases
git checkout -b release/v2.1.0

# Make version updates
# ... update files ...

# Commit changes
git add .
git commit -m "chore(release): prepare for v2.1.0"

# Push branch
git push -u origin release/v2.1.0
```

### 5. Testing Phase

**Automated Testing:**
```bash
# Run all tests
bats tests/

# Run installation test
./scripts/test_installation.sh

# Run shellcheck
shellcheck *.sh scripts/*.sh
```

**Manual Testing:**
```bash
# Test on clean repository
cd /tmp
mkdir test-project && cd test-project
git init

# Test installation
bash /path/to/setup-ai-collaboration.sh --preset python

# Test ai command
/path/to/ai status
/path/to/ai rules --show

# Test session recovery
/path/to/ai save "Test session"
/path/to/ai restore
```

### 6. Create Git Tag

```bash
# Create annotated tag
git tag -a v2.1.0 -m "Release version 2.1.0

## Changes
- Added Go preset support
- Fixed path handling bug
- Updated documentation

See CHANGELOG.md for full details."

# Push tag
git push origin v2.1.0
```

### 7. Create GitHub Release

The GitHub Actions workflow (`.github/workflows/release.yml`) automatically:
1. Builds release assets
2. Creates checksums
3. Publishes GitHub release
4. Generates release notes from CHANGELOG

**Manual release (if needed):**

1. Go to GitHub Releases
2. Click "Draft a new release"
3. Choose the tag
4. Use CHANGELOG section as release notes
5. Upload assets:
   - `ai-collaboration-management-X.Y.Z.tar.gz`
   - `ai-collaboration-management-X.Y.Z.tar.gz.sha256`
6. Publish release

### 8. Post-Release

#### Update Main Branch

```bash
# Merge release branch to main
git checkout main
git merge --no-ff release/v2.1.0
git push origin main

# Merge back to develop
git checkout develop
git merge --no-ff release/v2.1.0
git push origin develop

# Delete release branch
git branch -d release/v2.1.0
git push origin --delete release/v2.1.0
```

#### Announcements

- [ ] Post release announcement on GitHub Discussions
- [ ] Update project website (if applicable)
- [ ] Social media announcements (if applicable)
- [ ] Notify major users/contributors

#### Monitor

- [ ] Watch for bug reports
- [ ] Monitor GitHub issues
- [ ] Check CI/CD status
- [ ] Verify download stats

## Release Artifacts

### What to Include

**Core Files:**
- `ai` - Master command
- `setup-ai-collaboration.sh` - Setup script
- `update-claude-rules.sh` - Rules management
- `.ai-framework/` - Framework directory
- `templates/` - Template files
- `scripts/` - Utility scripts

**Documentation:**
- `README.md`
- `LICENSE`
- `CHANGELOG.md`
- `QUICK_START.md`

**Exclude:**
- `.git/` and `.github/`
- `tests/` (not needed for release)
- `test_examples/`
- Development documentation

### Creating Release Archive

```bash
VERSION="2.1.0"

tar -czf "ai-collaboration-management-${VERSION}.tar.gz" \
    --exclude='.git' \
    --exclude='.github' \
    --exclude='tests' \
    --exclude='test_examples' \
    ai \
    setup-ai-collaboration.sh \
    update-claude-rules.sh \
    .ai-framework/ \
    templates/ \
    scripts/ \
    README.md \
    LICENSE \
    CHANGELOG.md \
    QUICK_START.md

# Create checksum
sha256sum "ai-collaboration-management-${VERSION}.tar.gz" > \
    "ai-collaboration-management-${VERSION}.tar.gz.sha256"
```

## Hotfix Process

For critical bugs in production:

### 1. Create Hotfix Branch

```bash
# Branch from main (latest release)
git checkout main
git checkout -b hotfix/fix-critical-bug

# Fix the issue
# ... make changes ...

# Bump patch version
# 2.1.0 → 2.1.1
```

### 2. Test Fix

```bash
# Run tests
bats tests/
./scripts/test_installation.sh

# Manual testing
```

### 3. Update CHANGELOG

```markdown
## [2.1.1] - 2025-11-19

### Fixed
- Critical bug in path handling that caused data loss
- Security vulnerability in input validation
```

### 4. Merge and Release

```bash
# Commit fix
git add .
git commit -m "fix(critical): resolve path handling issue

This fixes a critical bug where special characters in paths
could cause data loss.

Fixes #123"

# Merge to main
git checkout main
git merge --no-ff hotfix/fix-critical-bug

# Tag release
git tag -a v2.1.1 -m "Hotfix: Critical bug fix"

# Push
git push origin main
git push origin v2.1.1

# Merge to develop
git checkout develop
git merge --no-ff hotfix/fix-critical-bug
git push origin develop

# Delete hotfix branch
git branch -d hotfix/fix-critical-bug
```

## Release Checklist Template

Copy this for each release:

```markdown
## Release vX.Y.Z Checklist

### Pre-Release
- [ ] All tests pass
- [ ] shellcheck passes
- [ ] Manual testing complete
- [ ] CHANGELOG.md updated
- [ ] Version bumped in all files
- [ ] Documentation updated
- [ ] Migration guide (if needed)

### Testing
- [ ] Ubuntu latest
- [ ] macOS latest
- [ ] Windows/WSL
- [ ] Python projects
- [ ] React projects
- [ ] Java projects
- [ ] Fresh install
- [ ] Session recovery

### Release
- [ ] Create release branch
- [ ] Final testing
- [ ] Create git tag
- [ ] Push tag
- [ ] GitHub release published
- [ ] Assets uploaded
- [ ] Release notes published

### Post-Release
- [ ] Merge to main
- [ ] Merge to develop
- [ ] Delete release branch
- [ ] Announcements posted
- [ ] Monitor for issues
- [ ] Update documentation site
```

## Version History

### Notable Releases

- **v2.0.0** (2025-10-15) - Major restructuring, hidden framework directory
- **v1.0.0** (2025-09-01) - Initial stable release

## Rollback Procedure

If a release has critical issues:

### 1. Identify Issue

- Determine severity
- Assess impact
- Decide on rollback vs hotfix

### 2. Communicate

```markdown
## Critical Issue Alert

We've identified a critical issue in version X.Y.Z:

**Issue:** Brief description
**Impact:** Who is affected
**Action:** Rollback to X.Y.Z-1 or wait for hotfix
**Timeline:** ETA for fix

**Workaround:** If available
```

### 3. Rollback Release

```bash
# Delete problematic tag
git tag -d vX.Y.Z
git push origin :refs/tags/vX.Y.Z

# Delete GitHub release
# (Done via GitHub UI)

# Revert commit if needed
git revert <commit-hash>
git push origin main
```

### 4. Hotfix

Create and release patched version immediately.

## Resources

- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github)

---

**Maintainers:** Follow this process carefully to ensure smooth, reliable releases.
