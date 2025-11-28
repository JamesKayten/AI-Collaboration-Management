# AICM Hard Disconnect Protocol

**🚨 CRITICAL: AICM Must Remain Standalone 🚨**

## Problem Discovered

The AICM framework was accidentally integrated into production project repositories (primarily SimpleCP), causing:
- **Days of lost work** due to workflow confusion
- **Hidden integrations** that went undiscovered
- **Repository entanglement** that made it unclear which rules applied
- **Cross-contamination** between AICM development and actual project work

## Hard Disconnect Completed (2025-11-28)

### Removed From:
- ✅ `/Documents/SimpleCP/` - Complete .aicm directory removed
- ✅ `/SimpleCP/` - All AICM components removed, 'aicm' git remote removed
- ✅ `/SimpleCP-correct/` - Directory completely removed
- ✅ `/Desktop/SimpleCP/` - Directory completely removed
- ✅ `/AI-Collaboration-Management-OLD/` - Archive removed
- ✅ `/AI-Collaboration-Management_OLD_ARCHIVE/` - Archive removed
- ✅ `/AICM/` - Shortcut removed
- ✅ `/Documents/GitHub/AI-Collaboration-Management/` - Duplicate removed

### GitHub Cleanup:
- ✅ SimpleCP repository force-pushed to remove all AICM integration
- ✅ All AICM components permanently removed from SimpleCP main branch

## Prevention Protocol

### ❌ NEVER DO:
- Install AICM components in production project repositories
- Add 'aicm' git remotes to other repositories
- Copy .claude/, .aicm/, or tcc-* files to other projects
- Create BOARD.md files outside of AICM repository
- Set up "bidirectional sync" between AICM and other repos

### ✅ PROPER USAGE:
- AICM exists ONLY in `/Documents/AI-Collaboration-Management/`
- Other projects use standard Claude Code (no AICM integration)
- AICM framework development happens exclusively in AICM repository
- Testing AICM improvements happens in AICM repository only

## Emergency Disconnect Commands

If AICM integration is accidentally created again:

```bash
# Remove AICM components
rm -rf .aicm .claude tcc-* BOARD.md .ai-framework

# Remove AICM git remote (if present)
git remote remove aicm 2>/dev/null

# Commit cleanup
git add -A
git commit -m "🚨 EMERGENCY: Remove accidental AICM integration"
git push origin main --force-with-lease
```

## Single Source of Truth

**AICM Framework Location:** `/Documents/AI-Collaboration-Management/` ONLY

**All other repositories:** Standard Claude Code projects with no AICM components

This hard disconnect prevents future workflow disasters and ensures clean separation between framework development and project work.