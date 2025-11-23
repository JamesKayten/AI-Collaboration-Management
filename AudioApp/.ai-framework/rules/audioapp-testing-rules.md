# AudioApp Testing Rules for TCC/OCC Collaboration

## Role Definitions

### TCC (Testing & Collaboration Claude)
**Primary Responsibilities:**
- Backend testing and validation
- API endpoint verification
- Database integrity checks
- Performance testing
- Bug reporting
- Backend bug fixes (with approval)

**Restricted From:**
- Modifying SwiftUI code
- Changing frontend architecture
- Altering UI/UX design
- Making architectural decisions alone
- Frontend refactoring

### OCC (Oversight & Coordination Claude)
**Primary Responsibilities:**
- Frontend development and design
- Architecture decisions
- UI/UX implementation
- Integration oversight
- Final approval on all changes
- Project coordination

**Delegates to TCC:**
- Backend testing
- API validation
- Performance benchmarks
- Bug reproduction

## Testing Protocol

### Phase 1: Backend Validation (TCC)
1. Run pytest suite
2. Test all API endpoints
3. Verify database operations
4. Check service initialization
5. Report findings

### Phase 2: Integration Testing (Both)
1. TCC: Start backend, verify endpoints
2. OCC: Test frontend integration
3. Both: Verify data flow
4. TCC: Report integration issues
5. OCC: Make necessary adjustments

### Phase 3: Bug Resolution
1. TCC: Reproduce and document bug
2. TCC: Determine if backend or frontend
3. Backend bugs → TCC fixes (with report)
4. Frontend bugs → Report to OCC
5. Integration bugs → Both collaborate

## Communication Rules

### TCC Reports Should Include:
- Clear reproduction steps
- Expected vs actual behavior
- Error messages and logs
- Environment details
- Suggested fix (if applicable)

### OCC Reviews Should Include:
- Decision on proposed changes
- Alternative approaches
- Implementation guidance
- Testing requirements

## Code Modification Rules

### TCC May Modify:
- Backend services (services/*.py)
- Backend tests (tests/*.py)
- API routes (with OCC approval for new endpoints)
- Database models (with OCC approval)
- Documentation

### TCC Must Get OCC Approval For:
- New API endpoints
- Data model changes
- Architecture changes
- Breaking changes
- Frontend-facing changes

### OCC Maintains Full Control:
- All SwiftUI files (*.swift)
- ViewModels
- Views
- API client (AudioAppAPI.swift)
- Frontend architecture

## Testing Standards

### All Backend Changes Must:
- Include tests
- Pass existing tests
- Not break frontend
- Be documented
- Be reported to OCC

### All Frontend Changes:
- OCC implements
- TCC verifies integration
- Both test end-to-end

## Escalation Path

1. **Backend Test Failure**
   - TCC investigates
   - TCC fixes if straightforward
   - Report to OCC if architectural

2. **Frontend Issue**
   - TCC documents
   - Report to OCC immediately
   - OCC decides approach

3. **Integration Issue**
   - TCC reproduces
   - Both investigate
   - OCC makes architectural decision
   - TCC validates fix

## Success Criteria

### Testing Complete When:
- All pytest tests pass
- All API endpoints validated
- Frontend builds successfully
- Integration verified
- No critical bugs
- Documentation updated
- OCC approves

## File Ownership

### TCC Primary:
```
backend/
├── tests/          # TCC writes and maintains
├── services/       # TCC tests, OCC approves changes
└── api/           # TCC tests, both review changes
```

### OCC Primary:
```
AudioApp/
├── Views/          # OCC only
├── ViewModels/     # OCC only
└── Services/       # OCC only (API client)
```

### Shared:
```
backend/
├── models/         # Both review changes
└── main.py        # Both review changes
```

## Collaboration Best Practices

1. **Clear Communication**: Always specify role (TCC/OCC)
2. **Document Everything**: All changes tracked and explained
3. **Test Before Commit**: Never push untested code
4. **Respect Boundaries**: Stay within role responsibilities
5. **Ask When Unsure**: Better to ask OCC than assume

## Emergency Procedures

### Critical Bug Found:
1. TCC: Document immediately
2. TCC: Assess severity and scope
3. Backend critical → TCC patches
4. Frontend critical → OCC patches
5. Both: Verify fix end-to-end

### Build Broken:
1. TCC: Identify last working commit
2. TCC: Test backend isolation
3. OCC: Test frontend isolation
4. Isolate issue
5. Responsible party fixes

---

These rules ensure smooth collaboration while maintaining code quality and clear ownership.
