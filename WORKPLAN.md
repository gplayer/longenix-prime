# LongenixPrime Development Workplan
**Date**: 2025-11-24  
**Status**: AWAITING USER APPROVAL  
**Environment**: DEV (Preview) Only

---

## Instructions for User

**Please review DEV_AUDIT.md and provide:**

1. **Your known issues list** - Any problems you've already identified
2. **Your desired modifications** - Features or improvements you want
3. **Priority selection** - Choose focus area:
   - Safety & Stability
   - Performance
   - Security
   - Clinical Accuracy
   - Other (specify)

**After you provide this information, I will populate this WORKPLAN with:**
- Categorized checklist (Bug Fixes / Enhancements / Major Changes)
- Detailed TEST PLAN for each item
- Proposed branch names and PR structure
- Effort estimates and risk assessments

---

## Preliminary Work Items (from Audit)

### 🔴 HIGH PRIORITY Issues Found
1. **Monolithic Architecture** - 13,273-line single file
2. **Client-Side Form Rendering** - No SSR fallback
3. **Report Performance** - Multiple sync queries, large bundle

### 🟡 MEDIUM PRIORITY Improvements
1. **Underutilized Tables** - biomarkers table empty
2. **Large JSON Fields** - 100KB+ assessment_data
3. **Hardcoded Clinical Rules** - Code changes required for guideline updates
4. **No Server-Side Validation** - Client-side only
5. **LocalStorage State** - No server-side drafts
6. **No Report Caching** - Regenerated every time
7. **Basic Auth Limitations** - No MFA or user management
8. **Inconsistent API Versioning** - v1, v2, v3 all active

### 🟢 LOW PRIORITY Enhancements
1. **No Automated Tests** - Zero coverage
2. **Missing Soft Deletes** - Hard deletes only
3. **Algorithm Documentation** - Minimal inline comments
4. **PDF Generation** - Browser-only, inconsistent
5. **No Audit Logging** - No action tracking
6. **Data Validation Constraints** - No CHECK constraints
7. **No API Rate Limiting** - Potential abuse
8. **Chart Rendering** - Slow on mobile

---

## User Input Required

### 1. Known Issues

**Please list any issues you're already aware of:**
```
(User to fill in)

Example:
- Form validation errors not displaying correctly
- ATM timeline date parser fails on certain formats
- Report generation times out for users with many biomarkers
- etc.
```

### 2. Desired Modifications

**Please list features/improvements you want:**
```
(User to fill in)

Example:
- Add email notifications when reports are ready
- Allow patients to export their data as JSON
- Implement dark mode for assessment form
- Add multi-language support
- etc.
```

### 3. Priority Focus

**Choose ONE primary focus area (or rank 1-4):**
```
[ ] Safety & Stability (server-side validation, tests, data integrity)
[ ] Performance (caching, query optimization, bundle size)
[ ] Security (Cloudflare Access, MFA, audit logging)
[ ] Clinical Accuracy (configurable rules, documentation, biomarker queries)
[ ] Other: _______________
```

---

## After User Input, I Will Provide:

### Section A: Bug Fixes
*Will be populated with:*
- Exact files and line numbers
- Expected vs actual behavior
- Reproduction steps
- Proposed fix
- Test plan

### Section B: Small Enhancements (Low Risk)
*Will be populated with:*
- Description and rationale
- Affected files
- Implementation approach
- Test plan
- Effort estimate

### Section C: Larger Modifications (Require Approval)
*Will be populated with:*
- Detailed design proposal
- Affected components
- Migration strategy (if database changes)
- Rollback plan
- Comprehensive test plan
- Risk assessment

### Section D: Proposed Branches/PRs
*Will be populated with:*
- Branch naming convention
- PR titles
- Linked to work items
- Suggested merge order

### Section E: Required Permissions/Secrets
*Will be populated with:*
- Any missing secret names (values not shown)
- Cloudflare resources needed
- External service access

---

## Safety Reminders

### ✅ Allowed Actions (after approval)
- Create feature branches
- Implement approved changes
- Deploy to DEV (preview)
- Run tests on preview environment
- Create PRs for review

### ❌ Prohibited Actions
- Modify Production environment
- Merge without explicit approval ("Approved—merge & deploy to preview")
- Destructive database operations (DROP, TRUNCATE)
- Change Production secrets/bindings
- Commit sensitive data (credentials, real PHI)

### 🔒 Required Before Implementation
- Feature branch off main (naming: `feat/`, `fix/`, `refactor/`)
- PR with TEST PLAN included
- Preview deployment with exact URL
- Manual testing completed
- Screenshots/diffs attached
- User approval comment on PR

---

## Next Steps

**USER ACTION REQUIRED:**
1. Review SYSTEM_OVERVIEW.md (understand the system)
2. Review DEV_AUDIT.md (understand the findings)
3. Reply to this message with:
   - Your known issues list
   - Your desired modifications
   - Your priority focus area

**THEN I WILL:**
1. Populate this WORKPLAN.md with detailed checklist
2. Create TEST PLANS for each item
3. Propose branch/PR structure
4. Wait for your approval to proceed

---

**Document Version**: 0.1 (SKELETON)  
**Status**: AWAITING USER INPUT  
**Last Updated**: 2025-11-24
