# React Web Application Example

Configuration for modern React applications with TypeScript, Node.js backend, and comprehensive quality standards.

## Tech Stack

- **Frontend**: React 18+, TypeScript, CSS-in-JS
- **Backend**: Node.js, Express
- **Build**: Webpack/Vite
- **Testing**: Jest, React Testing Library
- **Linting**: ESLint, Prettier

## Features

This configuration validates:

✅ Component size and complexity
✅ Bundle size budgets
✅ Test coverage thresholds
✅ TypeScript strict mode
✅ Accessibility standards
✅ Performance metrics
✅ Security vulnerabilities

## Installation

### 1. Install Framework

```bash
cd your-react-project
git clone https://github.com/JamesKayten/AI-Collaboration-Management.git ../ai-framework
../ai-framework/setup-ai-collaboration.sh
```

### 2. Copy This Configuration

```bash
cp ../ai-framework/examples/react-webapp/VALIDATION_RULES.md .ai-framework/rules/
```

### 3. Customize Rules

Edit `.ai-framework/rules/VALIDATION_RULES.md` to match your project:

```bash
# Adjust these values for your team
MAX_COMPONENT_LINES: 150  # Change to your preferred limit
MIN_TEST_COVERAGE: 80     # Your coverage goal
MAX_BUNDLE_SIZE: 500KB    # Your performance budget
```

## Validation Rules

### Component Quality

```yaml
max_component_lines: 150
max_component_complexity: 15
required_proptypes: true
accessibility_required: true
```

**Why**: Keeps components manageable, maintainable, and accessible.

### Bundle Size

```yaml
max_bundle_main: 500KB
max_bundle_vendor: 1MB
max_bundle_total: 2MB
code_splitting_required: true
```

**Why**: Ensures fast page loads and good user experience.

### Test Coverage

```yaml
min_coverage_lines: 80%
min_coverage_branches: 75%
min_coverage_functions: 80%
test_components: required
test_hooks: required
```

**Why**: Maintains code quality and prevents regressions.

### TypeScript

```yaml
strict_mode: true
no_any: error
no_explicit_any: error
unused_vars: error
```

**Why**: Catches type errors early and improves code safety.

### Security

```yaml
npm_audit: zero vulnerabilities
no_hardcoded_secrets: true
security_headers: required
xss_protection: required
```

**Why**: Protects application and user data.

### Performance

```yaml
lighthouse_performance: 90+
time_to_interactive: <3s
first_contentful_paint: <1.5s
cumulative_layout_shift: <0.1
```

**Why**: Ensures excellent user experience.

## Workflow Example

### Daily Development

1. **Online AI implements feature**:
   ```
   User: "Add a user profile component with avatar upload"
   Online AI: Creates component, tests, styles
   ```

2. **Validate with Local AI**:
   ```
   User: "work ready"
   Local AI: Checks component size, tests, bundle impact
   ```

3. **If issues found**:
   ```
   Local AI: Creates report in .ai-framework/communications/reports/
   User: "Check .ai-framework/communications/ for issues"
   Online AI: Reads report, fixes violations
   ```

4. **Re-validate and merge**:
   ```
   User: "work ready"
   Local AI: Validates fixes, approves merge
   ```

### Example Validation Report

See `sample-report.md` for a full example of what Local AI generates.

## Customization Guide

### Adjusting Component Limits

If 150 lines is too strict:

```yaml
# Relaxed for larger components
max_component_lines: 250

# Or differentiate by type
max_page_component_lines: 300
max_ui_component_lines: 150
```

### Bundle Size Budgets

Adjust based on your target audience:

```yaml
# For performance-critical apps (slow connections)
max_bundle_total: 1MB

# For internal enterprise apps (fast networks)
max_bundle_total: 5MB
```

### Test Coverage

Balance between quality and speed:

```yaml
# Stricter for critical paths
min_coverage_critical: 95%

# Relaxed for experimental features
min_coverage_experimental: 60%
```

## Integration with CI/CD

### GitHub Actions

```yaml
- name: AI Validation
  run: |
    # Have Local AI validate the PR
    claude "work ready"
```

### Pre-commit Hooks

```bash
#!/bin/bash
# .git/hooks/pre-commit
claude "validate changes before commit"
```

## Common Violations

### 1. Component Too Large

**Issue**: `UserProfile.tsx` has 250 lines (limit: 150)

**Fix**: Split into smaller components:
```
UserProfile.tsx (80 lines)
├── UserAvatar.tsx (30 lines)
├── UserInfo.tsx (40 lines)
└── UserSettings.tsx (50 lines)
```

### 2. Bundle Size Exceeded

**Issue**: Main bundle is 650KB (limit: 500KB)

**Fixes**:
- Code splitting for routes
- Lazy load heavy components
- Tree-shake unused dependencies
- Compress images

### 3. Low Test Coverage

**Issue**: Component has 60% coverage (target: 80%)

**Fix**: Add tests for:
- User interactions
- Edge cases
- Error states
- Loading states

### 4. Accessibility Issues

**Issue**: Button missing `aria-label`

**Fix**:
```tsx
// Before
<button onClick={handleClick}>×</button>

// After
<button onClick={handleClick} aria-label="Close dialog">×</button>
```

## Performance Tips

### Bundle Analysis

```bash
# Analyze bundle size
npm run build -- --analyze

# Check what's making bundles large
npx source-map-explorer 'build/static/js/*.js'
```

### Code Splitting

```tsx
// Lazy load routes
const UserProfile = lazy(() => import('./pages/UserProfile'));
const Dashboard = lazy(() => import('./pages/Dashboard'));

// Lazy load heavy components
const Chart = lazy(() => import('./components/Chart'));
```

## Tools Integration

### Required Dev Dependencies

```json
{
  "devDependencies": {
    "@testing-library/react": "^13.0.0",
    "@testing-library/jest-dom": "^5.16.0",
    "eslint": "^8.0.0",
    "prettier": "^2.8.0",
    "typescript": "^4.9.0",
    "webpack-bundle-analyzer": "^4.7.0"
  }
}
```

### Recommended VS Code Extensions

- ESLint
- Prettier
- TypeScript
- Jest Runner

## Success Metrics

Track these over time:

- **Component complexity**: Trending down
- **Test coverage**: Trending up
- **Bundle size**: Staying under budget
- **Build time**: Staying reasonable
- **AI collaboration cycles**: Fewer iterations needed

## Questions?

- Check [troubleshooting guide](../../docs/guides/TROUBLESHOOTING.md)
- Ask in [discussions](https://github.com/JamesKayten/AI-Collaboration-Management/discussions)
- Review [sample report](sample-report.md)

---

**Ready to start?** Copy the validation rules and run `"work ready"`!
