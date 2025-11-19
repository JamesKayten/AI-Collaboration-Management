# React Web Application - Validation Rules

These validation rules ensure high-quality React applications with good performance, maintainability, and user experience.

## Component Quality Standards

### File Size Limits

**Rule**: React components should not exceed 150 lines (excluding imports and exports)

**Check Command**:
```bash
find src/components -name "*.tsx" -o -name "*.jsx" | while read file; do
  lines=$(sed '/^import/d; /^export/d; /^$/d' "$file" | wc -l)
  if [ $lines -gt 150 ]; then
    echo "❌ $file: $lines lines (max 150)"
  fi
done
```

**Severity**: Warning

**Fix Suggestion**: Split large components into smaller, focused sub-components

### Component Complexity

**Rule**: Cyclomatic complexity should not exceed 15

**Check Command**:
```bash
npx eslint src/ --ext .ts,.tsx --rule 'complexity: ["error", 15]'
```

**Severity**: Error

**Fix Suggestion**: Extract complex logic into custom hooks or utility functions

### PropTypes/TypeScript

**Rule**: All props must have proper TypeScript types (no `any`)

**Check Command**:
```bash
grep -r "any" src/components --include="*.tsx" --include="*.ts"
```

**Severity**: Error

**Fix Suggestion**: Define explicit interfaces for all component props

## Bundle Size Requirements

### Main Bundle

**Rule**: Main JavaScript bundle should not exceed 500KB (gzipped)

**Check Command**:
```bash
size=$(du -k build/static/js/main.*.js | cut -f1)
if [ $size -gt 500 ]; then
  echo "❌ Main bundle: ${size}KB (max 500KB)"
fi
```

**Severity**: Error

**Fix Suggestion**:
- Implement code splitting
- Lazy load heavy components
- Remove unused dependencies

### Total Bundle

**Rule**: Total JavaScript size should not exceed 2MB (gzipped)

**Check Command**:
```bash
total=$(du -sk build/static/js | cut -f1)
if [ $total -gt 2048 ]; then
  echo "❌ Total bundle: ${total}KB (max 2MB)"
fi
```

**Severity**: Warning

**Fix Suggestion**: Use webpack-bundle-analyzer to identify large dependencies

## Test Coverage

### Line Coverage

**Rule**: Minimum 80% line coverage

**Check Command**:
```bash
npm test -- --coverage --coverageThreshold='{"global": {"lines": 80}}'
```

**Severity**: Error

**Fix Suggestion**: Add tests for uncovered components and functions

### Branch Coverage

**Rule**: Minimum 75% branch coverage

**Check Command**:
```bash
npm test -- --coverage --coverageThreshold='{"global": {"branches": 75}}'
```

**Severity**: Warning

**Fix Suggestion**: Test all conditional logic branches

### Component Testing

**Rule**: All components must have corresponding test files

**Check Command**:
```bash
for comp in src/components/**/*.tsx; do
  test_file="${comp%.tsx}.test.tsx"
  if [ ! -f "$test_file" ]; then
    echo "❌ Missing test: $test_file"
  fi
done
```

**Severity**: Error

**Fix Suggestion**: Create test file with at least basic rendering test

## Code Quality

### ESLint Compliance

**Rule**: Zero ESLint errors

**Check Command**:
```bash
npx eslint src/ --ext .ts,.tsx,.js,.jsx --max-warnings 0
```

**Severity**: Error

**Fix Suggestion**: Fix all linting errors and warnings

### Prettier Formatting

**Rule**: All files must be properly formatted

**Check Command**:
```bash
npx prettier --check "src/**/*.{ts,tsx,js,jsx,css,scss,json}"
```

**Severity**: Warning

**Fix Suggestion**: Run `npm run format` or `prettier --write`

### TypeScript Strict Mode

**Rule**: TypeScript strict mode must be enabled

**Check File**: `tsconfig.json`

**Required Settings**:
```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true
  }
}
```

**Severity**: Error

## Security

### Dependency Vulnerabilities

**Rule**: Zero npm audit vulnerabilities

**Check Command**:
```bash
npm audit --audit-level=moderate
```

**Severity**: Error

**Fix Suggestion**: Run `npm audit fix` or update vulnerable packages

### Hardcoded Secrets

**Rule**: No API keys, tokens, or secrets in source code

**Check Command**:
```bash
grep -r -E "api[_-]?key|secret|token|password" src/ --include="*.ts" --include="*.tsx" | grep -v "process.env"
```

**Severity**: Error

**Fix Suggestion**: Move secrets to environment variables

### Security Headers

**Rule**: Server must set security headers

**Required Headers**:
- Content-Security-Policy
- X-Frame-Options
- X-Content-Type-Options
- Strict-Transport-Security

**Check Command**:
```bash
curl -I http://localhost:3000 | grep -E "Content-Security-Policy|X-Frame-Options"
```

**Severity**: Error

## Performance

### Lighthouse Score

**Rule**: Lighthouse performance score must be 90+

**Check Command**:
```bash
npx lighthouse http://localhost:3000 --only-categories=performance --quiet
```

**Severity**: Warning

**Fix Suggestion**: Follow Lighthouse suggestions for improvements

### Time to Interactive

**Rule**: Time to Interactive (TTI) should be under 3 seconds

**Check Command**:
```bash
npx lighthouse http://localhost:3000 --quiet | grep "Time to Interactive"
```

**Severity**: Warning

**Fix Suggestion**:
- Reduce JavaScript bundle size
- Implement code splitting
- Optimize render-blocking resources

### First Contentful Paint

**Rule**: First Contentful Paint (FCP) should be under 1.5 seconds

**Severity**: Warning

**Fix Suggestion**:
- Optimize images
- Minimize CSS
- Use CDN for static assets

## Accessibility

### ARIA Labels

**Rule**: Interactive elements must have proper ARIA labels

**Check Command**:
```bash
npx eslint src/ --rule 'jsx-a11y/aria-role: error' --rule 'jsx-a11y/aria-props: error'
```

**Severity**: Error

**Fix Suggestion**: Add appropriate aria-label, aria-labelledby, or aria-describedby

### Semantic HTML

**Rule**: Use semantic HTML elements instead of generic divs

**Severity**: Warning

**Fix Suggestion**: Replace divs with `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<footer>`

### Keyboard Navigation

**Rule**: All interactive elements must be keyboard accessible

**Check Command**:
```bash
npx eslint src/ --rule 'jsx-a11y/click-events-have-key-events: error'
```

**Severity**: Error

## File Organization

### Component Structure

**Rule**: Components must follow standard structure

**Expected Structure**:
```
src/
├── components/
│   ├── Button/
│   │   ├── Button.tsx
│   │   ├── Button.test.tsx
│   │   ├── Button.styles.ts
│   │   └── index.ts
```

**Severity**: Warning

### Naming Conventions

**Rule**:
- Components: PascalCase (UserProfile.tsx)
- Utilities: camelCase (formatDate.ts)
- Constants: UPPER_SNAKE_CASE (API_URL)
- CSS Modules: kebab-case (button-styles.module.css)

**Severity**: Warning

## Custom Project Rules

Add your project-specific rules below:

### API Response Time

**Rule**: API endpoints should respond within 200ms

**Check Command**:
```bash
# Add your API performance test
```

### Custom Business Logic

**Rule**: [Your custom rule here]

**Check Command**:
```bash
# Your validation command
```

---

## Validation Workflow

1. **Run all checks**: Local AI executes each validation rule
2. **Collect violations**: Any rule that fails is reported
3. **Generate report**: Create detailed report with:
   - Rule violated
   - Affected files
   - Severity level
   - Fix suggestions
4. **Save report**: Write to `.ai-framework/communications/reports/`

## Notes for AI

- **Prioritize errors** over warnings
- **Be specific** in reports - include file names, line numbers, exact violations
- **Suggest fixes** that are actionable and specific
- **Group similar violations** to avoid repetition
- **Track progress** between validation cycles
