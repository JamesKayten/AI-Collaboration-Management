# Version History

Track development versions for safe rollback points.

## Current Version
**v4.6** - Repository cleanup (2025-11-29)

## Version Log

| Version | Date | Commit | Description |
|---------|------|--------|-------------|
| v4.6 | 2025-11-29 | 356837a | Repository cleanup - removed test files, unified watchers |
| v4.5 | 2025-11-29 | da3723f | Works-ready auto-execution |
| v4.4 | 2025-11-29 | d9d48ba | Repo fixes and board updates |
| v4.3 | 2025-11-29 | 9a84e54 | TCC automatic readiness |
| v4.2 | 2025-11-29 | e9181d4 | TCC protocol complete |
| v4.1 | 2025-11-29 | eddf2d6 | Claude startup fixed |
| v4.0 | 2025-11-29 | - | AIM Docker setup |

## Rollback Instructions

To rollback to a specific version:
```bash
git checkout <commit-hash>
# or create a branch from that point
git checkout -b rollback-vX.X <commit-hash>
```

## Tagging Convention

TCC increments version on significant merges:
- **Major (vX.0)**: Breaking changes or major features
- **Minor (vX.Y)**: New features, enhancements
- **Patch (vX.Y.Z)**: Bug fixes (optional)
