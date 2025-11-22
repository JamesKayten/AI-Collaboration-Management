# Frontend Testing Rules - Terminal Claude Code (TCC)

## 🎯 Purpose
Prevent systematic errors in frontend testing that lead to false conclusions and wasted development time.

## 🚨 Critical Problem This Solves
**Systematic Error Pattern:** Testing old builds while believing you're testing new code changes.

**Root Cause:** Failure to properly kill existing processes before launching updated builds.

**Impact:**
- False "fixes don't work" conclusions
- Wasted debugging time on working code
- Poor development methodology
- User frustration with seemingly broken features

---

## 📋 MANDATORY FRONTEND TESTING PROTOCOL

### ✅ Rule 1: Process Management BEFORE Testing
**ALWAYS execute these steps IN ORDER:**

#### Step 1: Kill ALL Existing Processes
```bash
# Kill by application name
pkill -f [AppName]

# Verify clean state
ps aux | grep [AppName] | grep -v grep
# MUST return empty (no processes) before proceeding
```

#### Step 2: Wait for Complete Shutdown
```bash
sleep 2  # Allow process cleanup time
```

#### Step 3: Verify Clean State
```bash
# Double-check no processes remain
ps aux | grep -i [appname]
# MUST show only grep process, no application processes
```

### ✅ Rule 2: Build Verification
```bash
# Check build timestamp
stat .build/release/[AppName]
# Ensure modification time is AFTER your code changes
```

### ✅ Rule 3: Controlled Launch
```bash
# Launch new build
open .build/release/[AppName]

# Verify new process started
sleep 3
ps aux | grep [AppName] | grep -v grep
# Note new PID for verification
```

### ✅ Rule 4: Testing Verification
- **CONFIRM** you're testing the correct version
- **CHECK** build timestamp vs code change time
- **VERIFY** new PID vs previous PID

---

## 🚫 VIOLATIONS & ENFORCEMENT

### Automatic Violations
- **VIOLATION:** Testing without killing existing processes
- **VIOLATION:** Launching new build while old process runs
- **VIOLATION:** Concluding "fixes don't work" without process verification

### Enforcement Actions
1. **STOP** current testing immediately
2. **RESTART** from Step 1 (kill processes)
3. **DOCUMENT** the violation in testing log
4. **RE-TEST** with proper methodology

---

## 📊 SPECIFIC APPLICATION PROTOCOLS

### SimpleCP (macOS Swift App)
```bash
# Kill existing processes
pkill -f SimpleCP

# Verify clean state
ps aux | grep -i simplecp | grep -v grep
# MUST be empty

# Build if needed
swift build -c release

# Launch new version
open ./.build/release/SimpleCP

# Verify new process
sleep 3
ps aux | grep SimpleCP | grep -v grep
# Note new PID
```

### Web Applications
```bash
# Kill development server
kill [PID] or Ctrl+C

# Kill browser processes if testing locally
pkill -f "Chrome.*localhost"

# Restart server
npm start # or equivalent

# Open fresh browser session
```

### React/Node Applications
```bash
# Kill Node processes
pkill -f node

# Clear Node cache if needed
rm -rf node_modules/.cache

# Restart development server
npm start

# Verify port is clear before restart
lsof -ti:3000 | xargs kill -9
```

---

## 🔍 DEBUGGING METHODOLOGY

### When "Fixes Don't Work"
**BEFORE** concluding code is broken:

1. **VERIFY** process management was followed
2. **CHECK** you're testing the right build
3. **CONFIRM** code changes were actually included in build
4. **VALIDATE** you're testing new version, not cached/old version

### Testing Checklist
- [ ] Killed all existing processes
- [ ] Verified clean state (no old processes)
- [ ] Built new version (if applicable)
- [ ] Launched fresh build
- [ ] Confirmed new PID
- [ ] Tested actual new version

---

## 📈 SUCCESS METRICS

### Before Rules (Bad Pattern)
- ❌ Test old versions unknowingly
- ❌ Waste time debugging "broken" working code
- ❌ False negative conclusions
- ❌ Poor development velocity

### After Rules (Good Pattern)
- ✅ Always test correct version
- ✅ Accurate testing results
- ✅ Faster development cycle
- ✅ Reliable fix validation

---

## 🎯 INTEGRATION WITH AI COLLABORATION

### Framework Enforcement
- **TCC (Terminal Claude Code)** MUST follow these rules
- **OCC (Online Claude Code)** should reference these rules when delegating testing
- **Violation alerts** should trigger framework notification

### Cross-Platform Consistency
- **Local Testing:** Follow process management protocols
- **Remote Testing:** Ensure clean deployment environments
- **CI/CD Integration:** Implement automated process cleanup

---

## 📝 RULE HISTORY

### Version 1.0 - 2025-11-22
- **Created in response to:** Systematic TCC testing errors
- **Specific incident:** SimpleCP rename testing false negatives
- **Root cause:** Testing old builds while believing fixes were broken
- **Solution:** Mandatory process management before testing

### Rule Effectiveness
- **Problem frequency:** 100% of frontend testing sessions before rules
- **Expected improvement:** 0% process management errors after implementation
- **Monitoring:** Track testing methodology compliance

---

## 🚨 EMERGENCY PROCEDURES

### If You Suspect You're Testing Wrong Version
1. **IMMEDIATELY STOP** current test
2. **EXECUTE** full process cleanup protocol
3. **VERIFY** build timestamps and versions
4. **RESTART** testing from clean state
5. **DOCUMENT** the incident for pattern analysis

### If Multiple Versions Are Running
```bash
# Find all instances
ps aux | grep [AppName]

# Kill ALL instances
pkill -f [AppName]

# Wait for cleanup
sleep 5

# Verify completely clean
ps aux | grep [AppName]  # Should show nothing

# Start fresh single instance
[launch command]
```

---

**MANDATORY COMPLIANCE:** These rules are NOT optional for TCC frontend testing.

**FRAMEWORK INTEGRATION:** Violations trigger automatic framework alerts and require testing restart.

**CONTINUOUS IMPROVEMENT:** Update these rules based on new systematic error patterns discovered.