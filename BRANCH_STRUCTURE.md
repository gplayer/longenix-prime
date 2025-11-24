# Branch & PR Structure for LongenixPrime Development

**Date**: 2025-11-24  
**Status**: PLANNING PHASE

---

## Branch Naming Convention

### Feature Branches
```
feat/<short-description>
```
**Examples:**
- `feat/server-side-validation`
- `feat/report-caching`
- `feat/algorithm-documentation`

### Bug Fix Branches
```
fix/<short-description>
```
**Examples:**
- `fix/incomplete-risk-calculations`
- `fix/atm-date-parser`
- `fix/biomarker-validation`

### Refactoring Branches
```
refactor/<short-description>
```
**Examples:**
- `refactor/modularize-routes`
- `refactor/extract-templates`
- `refactor/optimize-queries`

### Documentation Branches
```
docs/<short-description>
```
**Examples:**
- `docs/dev-audit-20251124` ✅ (current branch for audit artifacts)
- `docs/api-documentation`
- `docs/algorithm-methodology`

---

## Current Branch: docs/dev-audit-20251124

**Purpose**: Store audit artifacts from Phase 1 & 2  
**Files to Commit**:
- ✅ SYSTEM_OVERVIEW.md
- ✅ DEV_AUDIT.md
- ✅ WORKPLAN.md (skeleton)
- ✅ BRANCH_STRUCTURE.md (this file)

**PR Title**: "docs: Add comprehensive development audit (Phase 1 & 2)"  
**PR Description**:
```markdown
## Purpose
Comprehensive read-only audit of LongenixPrime DEV environment

## Deliverables
- **SYSTEM_OVERVIEW.md**: Technical documentation (35 KB)
- **DEV_AUDIT.md**: Findings and recommendations (23 KB)
- **WORKPLAN.md**: Template for future work (awaiting user input)
- **BRANCH_STRUCTURE.md**: Branch/PR naming conventions

## Findings Summary
- 0 critical blockers
- 3 high-priority issues
- 8 medium-priority improvements
- 8 low-priority enhancements

## Safety Status
✅ READ-ONLY audit - no code changes made
✅ No database writes
✅ Production environment untouched
✅ All guardrails followed

## Next Steps
Awaiting user input to populate WORKPLAN.md
```

**Merge Target**: `main`  
**Approval Required**: Yes (user review)

---

## Proposed Future Branches (After Workplan Approval)

### High Priority Items

#### 1. `refactor/modularize-architecture`
**Purpose**: Break 13,273-line index.tsx into modules  
**Files**:
- Create `src/routes/` directory
- Create `src/middleware/` directory
- Create `src/services/` directory
- Extract route handlers
- Extract utility functions

**PR Title**: "refactor: Modularize monolithic architecture into separate route/service modules"  
**Test Plan**: 
- All existing routes respond identically
- No regressions in API responses
- Unit tests for extracted utilities

---

#### 2. `perf/optimize-report-queries`
**Purpose**: Batch database queries for report generation  
**Files**:
- `src/index.tsx` (report route)
- Possibly `src/services/report.service.ts` (if modularized)

**PR Title**: "perf: Optimize report generation with batched queries and Promise.all()"  
**Test Plan**:
- Compare query count (before: 10-15, after: <5)
- Measure load time improvement (target: <300ms)
- Verify report content unchanged

---

#### 3. `perf/reduce-bundle-size`
**Purpose**: Reduce worker bundle from 580 KB  
**Files**:
- Extract large templates to static files
- Implement code splitting
- Update `vite.config.ts`

**PR Title**: "perf: Reduce worker bundle size via template extraction and code splitting"  
**Test Plan**:
- Measure bundle size (target: <300 KB)
- Verify all routes still functional
- Check cold start time improvement

---

### Medium Priority Items

#### 4. `feat/server-side-validation`
**Purpose**: Add validation layer for form submissions  
**Files**:
- Create `src/validators/assessment.validator.ts`
- Update POST routes to use validators
- Add error response handling

**PR Title**: "feat: Add server-side validation for assessment submissions"  
**Test Plan**:
- Submit valid data → success
- Submit invalid data → 400 with error details
- Verify all validation rules

---

#### 5. `feat/report-caching`
**Purpose**: Cache generated reports in Cloudflare KV  
**Files**:
- Setup KV namespace in `wrangler.jsonc`
- Add caching logic to report route
- Add cache invalidation on assessment update

**PR Title**: "feat: Implement report caching with Cloudflare KV"  
**Test Plan**:
- First report load → cache miss → generate → store
- Second report load → cache hit → fast return
- Update assessment → cache invalidated → regenerate

---

#### 6. `feat/biomarkers-table-population`
**Purpose**: Extract biomarkers from JSON into dedicated table  
**Files**:
- Create migration to add extraction function
- Update assessment submission to populate biomarkers table
- Backfill existing data

**PR Title**: "feat: Populate biomarkers table for improved queryability"  
**Test Plan**:
- Submit assessment → biomarkers extracted to table
- Verify JSON still contains raw data (no breaking change)
- Query biomarkers by name/value/status

---

#### 7. `feat/cloudflare-access`
**Purpose**: Replace Basic Auth with Cloudflare Access  
**Files**:
- Setup Cloudflare Access application
- Remove Basic Auth middleware
- Update docs with new auth flow

**PR Title**: "feat: Migrate from Basic Auth to Cloudflare Access for MFA support"  
**Test Plan**:
- Access denied without Access authentication
- Access granted with valid Cloudflare Access credentials
- MFA challenged if configured

---

#### 8. `refactor/configurable-clinical-rules`
**Purpose**: Move hardcoded clinical rules to configuration  
**Files**:
- Create `clinical_rules` database table
- Move functional medicine ranges to DB
- Update validators to query DB

**PR Title**: "refactor: Extract hardcoded clinical rules to database configuration"  
**Test Plan**:
- Biomarker validation uses DB rules
- Update rule in DB → immediate effect (no code deployment)
- Backward compatibility maintained

---

### Low Priority Items

#### 9. `test/add-unit-tests`
**Purpose**: Add Vitest unit test suite  
**Files**:
- Create `tests/` directory
- Add tests for medical algorithms
- Add tests for utility functions
- Add CI workflow

**PR Title**: "test: Add comprehensive unit test suite with Vitest"  
**Test Plan**: (meta!)
- All tests pass
- Coverage >80% for medical-algorithms.ts
- Coverage >60% for utility functions

---

#### 10. `docs/algorithm-documentation`
**Purpose**: Add JSDoc comments to medical algorithms  
**Files**:
- `src/medical-algorithms.ts` (inline comments)
- Create `ALGORITHMS.md` (methodology documentation)

**PR Title**: "docs: Add comprehensive algorithm documentation with literature references"  
**Test Plan**:
- JSDoc renders in IDE hover
- Methodology doc is accurate
- References are valid

---

## PR Review Checklist (Template)

**For every PR, include:**

### Description
- [ ] Clear purpose statement
- [ ] List of changed files
- [ ] Breaking changes noted (if any)

### Test Plan
- [ ] Manual test steps documented
- [ ] Expected results stated
- [ ] Actual results confirmed
- [ ] Screenshots/diffs attached (for UI changes)

### Deployment
- [ ] Preview URL provided
- [ ] Preview environment tested
- [ ] Database migrations applied (if applicable)
- [ ] Secrets configured (if applicable)

### Safety
- [ ] No production changes
- [ ] Backwards compatible (or migration path documented)
- [ ] Rollback plan stated (for major changes)
- [ ] Privacy controls maintained (X-Robots-Tag, auth)

### Code Quality
- [ ] No linter errors
- [ ] TypeScript compilation successful
- [ ] Tests added/updated (if test suite exists)
- [ ] Documentation updated

---

## Merge Approval Process

### For Each PR:
1. **Create branch** from `main`
2. **Implement changes** with commits
3. **Push branch** to GitHub
4. **Deploy to preview** (automatic via Cloudflare Pages)
5. **Test on preview** (manual verification)
6. **Open PR** with filled template
7. **Request review** from user
8. **Await approval comment**: "Approved—merge & deploy to preview"
9. **Merge to main** (squash or rebase)
10. **Verify preview deployment** updated
11. **Close related issues** (if any)

### Approval Levels:
- **Bug Fixes (Low Risk)**: Single approval, fast-track
- **Small Enhancements**: Single approval, standard process
- **Large Changes**: Detailed review, may require multiple rounds

---

## Git Workflow

### Local Development
```bash
# Start new feature
git checkout main
git pull origin main
git checkout -b feat/my-feature

# Make changes
# ... edit files ...

# Commit
git add .
git commit -m "feat: Add my feature"

# Push
git push origin feat/my-feature

# Open PR on GitHub
```

### After PR Approval
```bash
# Merge via GitHub UI (squash recommended)
# OR via CLI:
git checkout main
git merge --squash feat/my-feature
git commit -m "feat: Add my feature"
git push origin main

# Delete feature branch
git branch -d feat/my-feature
git push origin --delete feat/my-feature
```

---

## Current Status

**Active Branch**: `docs/dev-audit-20251124`  
**Pending Commits**: 4 files (audit artifacts)  
**Ready to Push**: ⏳ Awaiting user approval  
**Next Branch**: TBD (depends on WORKPLAN priorities)

---

**Document Version**: 1.0  
**Last Updated**: 2025-11-24  
**Next Review**: After first PR merged
