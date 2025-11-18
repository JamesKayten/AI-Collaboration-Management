# AI Collaboration Framework - JavaScript/TypeScript Validation Rules

**Project:** {{PROJECT_NAME}}
**Language:** JavaScript/TypeScript
**Framework Version:** 2.0 Professional Enhanced

---

## 🎯 **JavaScript/TypeScript Quality Standards**

### **File Size Limits**
- **Components**: 150 lines maximum
- **Hooks/Utilities**: 100 lines maximum
- **Services/APIs**: 200 lines maximum
- **Configuration**: 50 lines maximum

### **Code Quality Requirements**

#### **ESLint Standards**
```bash
# Validation command for Terminal Claude Code (TCC)
npx eslint src/ --ext .js,.jsx,.ts,.tsx --max-warnings 0
```

#### **Prettier Formatting**
```bash
# Validation command for Terminal Claude Code (TCC)
npx prettier --check "src/**/*.{js,jsx,ts,tsx,json,css,md}"
```

#### **TypeScript Compliance** (if using TypeScript)
```bash
# Validation command for Terminal Claude Code (TCC)
npx tsc --noEmit --strict
```

---

## 🚨 **Critical Violations That Block Merge**

### **Syntax Errors**
- **Uncaught TypeScript errors**
- **ESLint errors (not warnings)**
- **Prettier formatting violations**

### **Security Vulnerabilities**
- **Hardcoded API keys or secrets**
- **Unvalidated user inputs**
- **Unsafe innerHTML usage**
- **Missing authentication checks**

### **Performance Issues**
- **Unused imports/variables**
- **Console.log statements in production**
- **Bundle size > 1MB without justification**
- **Memory leaks in useEffect/event listeners**

---

## 📋 **Standard Fixes Required**

### **React/JavaScript Best Practices**
1. **Component Structure**:
   ```javascript
   // ✅ Good
   const MyComponent = ({ prop1, prop2 }) => {
     return <div>{prop1}</div>;
   };

   // ❌ Bad
   function MyComponent(props) {
     return <div>{props.prop1}</div>
   }
   ```

2. **State Management**:
   ```javascript
   // ✅ Good - useState with proper destructuring
   const [count, setCount] = useState(0);

   // ❌ Bad - direct state manipulation
   let count = 0;
   ```

3. **Effect Cleanup**:
   ```javascript
   // ✅ Good
   useEffect(() => {
     const timer = setInterval(() => {}, 1000);
     return () => clearInterval(timer);
   }, []);
   ```

### **TypeScript Specific**
1. **Proper Typing**:
   ```typescript
   // ✅ Good
   interface UserProps {
     name: string;
     age: number;
   }

   // ❌ Bad
   const user: any = { name: "John", age: 30 };
   ```

### **Security Requirements**
1. **API Key Protection**:
   ```javascript
   // ✅ Good
   const apiKey = process.env.REACT_APP_API_KEY;

   // ❌ Bad
   const apiKey = "sk-1234567890abcdef";
   ```

---

## 🛠️ **Auto-Fix Commands**

### **Formatting**
```bash
npx prettier --write "src/**/*.{js,jsx,ts,tsx,json,css,md}"
```

### **Linting**
```bash
npx eslint src/ --ext .js,.jsx,.ts,.tsx --fix
```

### **TypeScript Issues**
```bash
npx tsc --noEmit --strict --listFiles
```

---

## 📊 **Test Coverage Requirements**

### **Minimum Standards**
- **Unit Tests**: 85% code coverage
- **Component Tests**: All components tested
- **Integration Tests**: Critical user flows covered

### **Testing Commands**
```bash
# Run tests with coverage
npm test -- --coverage --watchAll=false

# E2E tests (if applicable)
npm run test:e2e
```

---

## 🔄 **AI Collaboration Workflow**

### **Validation Report Format**
When issues are found, Terminal Claude Code creates:
```
docs/ai_communication/AI_REPORT_[DATE]_JS_VALIDATION.md
```

### **Expected Response**
Online AI should create:
```
docs/ai_communication/AI_RESPONSE_[DATE]_JS_FIXES.md
```

### **Fix Requirements**
1. Address all ESLint errors
2. Apply Prettier formatting
3. Fix TypeScript compilation errors
4. Ensure test coverage meets requirements
5. Remove security vulnerabilities

---

**Framework:** Avery's AI Collaboration Hack - JavaScript/TypeScript Enhanced
**Ready for:** Cross-platform AI collaboration on JavaScript/TypeScript projects