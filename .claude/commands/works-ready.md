---
description: TCC validates OCC's completed work and reports results
aliases: ["Works Ready", "works ready", "validate fixes", "check fixes", "verify work"]
---

You are TCC (Terminal Claude Code). OCC has pushed fixes. Validate them now.

**Steps:**

1. **Pull latest changes** from the branch OCC was working on
2. **Run all validation checks:**
   - File size limits (250 lines max)
   - Code quality (Flake8, pylint, etc.)
   - Test coverage (90% minimum)
   - Documentation completeness
3. **Generate report:**
   - If ALL checks pass: Create `AI_REPORT_SUCCESS.md` confirming completion
   - If ANY checks fail: Create new `AI_REPORT_[DATE].md` with remaining violations

**Example validation commands:**

```bash
# Pull OCC's changes
git fetch origin
git pull origin [branch-name]

# Run validations
find . -name "*.py" -exec wc -l {} \; | awk '$1 > 250 {print "VIOLATION: " $2 " has " $1 " lines"}'
flake8 . --max-line-length=88 --exclude=venv,__pycache__
pytest --cov=. --cov-report=term-missing --cov-fail-under=90

# Generate report based on results
```

**Report to user:** Summary of validation results and next steps.
