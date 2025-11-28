# CHECKLIST_LDL_PRODUCTION.md – Dynamic LDL Production Readiness

This checklist describes what must be true before the dynamic LDL feature (Dynamic Fix Pack #1 – LDL) can be safely enabled in a production environment.

It is a living document and should be updated if requirements change.

---

## 1. Functional Behavior

- [ ] **Gating logic verified:**
  - [ ] LDL gate: `ldlValue > 100` mg/dL
  - [ ] ASCVD gate: `ascvdRisk ≥ 0.075` (7.5%)
  - [ ] Card shows ONLY when: `ldlValue > 100` OR `ascvdRisk ≥ 0.075`

- [ ] **Target tiers verified:**
  - [ ] ASCVD ≥ 0.20 (20%) → target `<70` mg/dL (very high risk)
  - [ ] 0.075 ≤ ASCVD < 0.20 (7.5% - 20%) → target `<100` mg/dL (moderate-high risk)
  - [ ] ASCVD < 0.075 (< 7.5%) or unknown → target `<130` mg/dL (low risk)

- [ ] **Response shape for the LDL probe endpoint verified:**
  - [ ] Probe returns: `{ success, shown, ldlValue, ascvdRisk, ldlTarget, html }`
  - [ ] All fields have correct types and nullable behavior
  - [ ] Error responses follow standard format: `{ success: false, error, details, fingerprint }`

- [ ] **Main report LDL card content reviewed and clinically approved:**
  - [ ] Nutritional interventions (soluble fiber, plant sterols, healthy fats, fatty fish)
  - [ ] Clinical discussion options (bergamot, psyllium, omega-3, lifestyle strategies)
  - [ ] **No dosing claims** (e.g., "500-1000mg daily")
  - [ ] **No red yeast rice** (removed due to contraindication risk)
  - [ ] Disclaimer present: "Dosing and suitability vary by individual health status"
  - [ ] Preview label `(Preview dynamic)` removed or replaced with production text

---

## 2. Safety & Data Gating

- [ ] **Card is shown ONLY when clinically indicated:**
  - [ ] `ldlValue > 100` mg/dL, OR
  - [ ] `ascvdRisk ≥ 0.075` (7.5%)
  - [ ] Both conditions checked correctly (using OR, not AND)

- [ ] **If LDL or risk data is missing/invalid:**
  - [ ] `shown=false` is returned
  - [ ] LDL card is NOT displayed in report
  - [ ] No speculative or placeholder recommendations are shown
  - [ ] No error is thrown (graceful degradation)

- [ ] **No database writes occur during LDL computation:**
  - [ ] Shared module (`src/ldl-dynamic.ts`) contains only pure functions
  - [ ] No calls to `env.DB` in LDL logic
  - [ ] Probe endpoint DB guard is active (warns if binding present, never accesses)

- [ ] **No dynamic LDL behavior without explicit flag:**
  - [ ] Feature flag `PREVIEW_DYNAMIC_LDL` (or production equivalent) must be `true`
  - [ ] If flag is `false` or missing, no LDL card is shown
  - [ ] Flag is checked before any LDL computation in main report

---

## 3. Feature Flags & Configuration

- [ ] **Clear feature flag exists for dynamic LDL:**
  - [ ] Current preview flag: `PREVIEW_DYNAMIC_LDL = true` (line ~1310 in `src/index.tsx`)
  - [ ] Production flag name decided (e.g., `ENABLE_DYNAMIC_LDL`, `FEATURE_LDL_PERSONALIZATION`)
  - [ ] Flag source determined (environment variable, config file, or feature flag service)

- [ ] **Default for production deployments explicitly documented:**
  - [ ] Production default: `false` (off by default until clinical approval)
  - [ ] Flag must be explicitly enabled after checklist completion

- [ ] **Mechanism to enable LDL in production is documented:**
  - [ ] Environment variable: `ENABLE_DYNAMIC_LDL=true` in Cloudflare Pages settings
  - [ ] OR config file: Update `wrangler.jsonc` or equivalent
  - [ ] OR feature flag service: Toggle in LaunchDarkly/equivalent

- [ ] **Rollback plan exists:**
  - [ ] How to disable quickly: Set `ENABLE_DYNAMIC_LDL=false` in Cloudflare dashboard
  - [ ] Fallback behavior: LDL card does not appear (graceful degradation)
  - [ ] Estimated rollback time: < 5 minutes (environment variable update)
  - [ ] Who has access to disable: Operations team + Technical owner

---

## 4. Testing

### Manual Probe Tests (TESTING_LDL.md)

- [ ] **Test Case 1: Empty body `{}`**
  - [ ] Expected: `success=true, shown=false, ldlValue=null, ascvdRisk=null, ldlTarget=null`
  - [ ] Verified: Card hidden, no data displayed

- [ ] **Test Case 2: LDL=145, no ASCVD**
  - [ ] Input: `{"biomarkers":{"ldl":145}}`
  - [ ] Expected: `shown=true, ldlValue=145, ascvdRisk=null, ldlTarget=130`
  - [ ] Verified: LDL > 100 gate triggers, low risk target

- [ ] **Test Case 3: LDL=95, ASCVD=0.09 (9%)**
  - [ ] Input: `{"biomarkers":{"ldl":95},"risk":{"ascvd":0.09}}`
  - [ ] Expected: `shown=true, ldlValue=95, ascvdRisk=0.09, ldlTarget=100`
  - [ ] Verified: ASCVD ≥ 7.5% gate triggers, high risk target

- [ ] **Test Case 4: LDL=95, ASCVD=0.25 (25%)**
  - [ ] Input: `{"biomarkers":{"ldl":95},"risk":{"ascvd":0.25}}`
  - [ ] Expected: `shown=true, ldlValue=95, ascvdRisk=0.25, ldlTarget=70`
  - [ ] Verified: Very high risk target

### End-to-End Report Tests (TESTING_DYNAMIC_LDL.md)

- [ ] **Scenario 1: LDL card HIDDEN (not clinically indicated)**
  - [ ] LDL = 95 mg/dL, ASCVD risk = 3%
  - [ ] Verified: No LDL card appears in report

- [ ] **Scenario 2: LDL card SHOWN with target 130 mg/dL**
  - [ ] LDL = 145 mg/dL, ASCVD risk unknown
  - [ ] Verified: Card appears, target = 130 mg/dL

- [ ] **Scenario 3: LDL card SHOWN with target 100 mg/dL**
  - [ ] LDL = 115 mg/dL, ASCVD risk = 9%
  - [ ] Verified: Card appears, target = 100 mg/dL

- [ ] **Scenario 4: LDL card SHOWN with target 70 mg/dL**
  - [ ] LDL = 155 mg/dL, ASCVD risk = 22%
  - [ ] Verified: Card appears, target = 70 mg/dL

### Automated Tests

- [ ] **Unit tests for shared LDL helpers exist:**
  - [ ] `extractLDLValue()` - Tests multiple key variants
  - [ ] `extractLDLValueFromComprehensiveData()` - Tests nested data structures
  - [ ] `extractASCVDRisk()` - Tests percentage coercion (9 → 0.09)
  - [ ] `extractASCVDRiskFromResults()` - Tests risk_level fallback
  - [ ] `computeLDLTarget()` - Tests all three risk tiers
  - [ ] `shouldShowLDLCard()` - Tests gating logic edge cases
  - [ ] `buildLDLCardResult()` - Tests complete flow

- [ ] **Integration tests for report generation:**
  - [ ] LDL card appears in correct section ("High Priority Interventions")
  - [ ] Card has `data-test="ldl-card"` attribute for test automation
  - [ ] HTML output matches expected structure

- [ ] **All tests documented in CI/README:**
  - [ ] Test commands documented
  - [ ] Test coverage requirements defined
  - [ ] CI pipeline runs tests automatically

---

## 5. Security & Compliance

- [ ] **No secrets hard-coded in LDL code or test docs:**
  - [ ] No passwords in source files
  - [ ] No API keys in test examples
  - [ ] All examples use placeholders: `<PW>`, `<BASE>`, `<TENANT>`

- [ ] **Authentication requirements unchanged and verified:**
  - [ ] Basic Auth required for probe endpoint
  - [ ] `X-Tenant-ID` header required
  - [ ] Production tenants are NOT `demo-a`, `demo-b`, `demo-c`
  - [ ] Production Basic Auth credentials are different from preview

- [ ] **Access control for preview/test tenants:**
  - [ ] Demo tenants (`demo-a`, `demo-b`, `demo-c`) accessible only in preview
  - [ ] Production tenants have proper access controls
  - [ ] Tenant validation enforced at API level

- [ ] **PHI (Protected Health Information) handling:**
  - [ ] No PHI logged in error messages
  - [ ] Fingerprints used instead of full error details in responses
  - [ ] LDL values and ASCVD risk treated as sensitive data
  - [ ] Probe endpoint does not store any data

---

## 6. Observability & Logging

- [ ] **Error logging strategy defined:**
  - [ ] Errors logged with fingerprint for tracking
  - [ ] Stack traces not exposed in API responses
  - [ ] Sensitive data (LDL values, patient info) redacted from logs

- [ ] **Monitoring strategy for LDL feature:**
  - [ ] Metric: Frequency of LDL card being shown (per session/report)
  - [ ] Metric: LDL target distribution (70/100/130 mg/dL)
  - [ ] Alert: Unexpected error rates from LDL computation
  - [ ] Alert: High rate of `shown=false` (potential data quality issue)

- [ ] **Integration with existing monitoring stack:**
  - [ ] Metrics exported to Cloudflare Analytics or equivalent
  - [ ] Logs aggregated in centralized logging system
  - [ ] Dashboards created for LDL feature health

- [ ] **DB Guard logging verified:**
  - [ ] Warning logged if DB binding present in probe endpoint
  - [ ] No actual DB access occurs (confirmed via monitoring)

---

## 7. Documentation & Training

### Technical Documentation

- [ ] **LDL implementation documented:**
  - [ ] `DOC_LDL_IMPLEMENTATION.md` - Complete implementation guide
  - [ ] Shared module (`src/ldl-dynamic.ts`) has inline documentation
  - [ ] Constants and thresholds explained with rationale

- [ ] **Preview guardrails documented:**
  - [ ] `AGENT_CONTROL_LGX_PREVIEW.md` - Agent behavior rules
  - [ ] Preview-only constraints clearly stated
  - [ ] NO PRODUCTION ACCESS rules enforced

- [ ] **Test procedures documented:**
  - [ ] `TESTING_LDL.md` - Probe endpoint test guide
  - [ ] `TESTING_DYNAMIC_LDL_PROBE.md` - Comprehensive probe validation
  - [ ] `TESTING_DYNAMIC_LDL.md` - End-to-end report testing
  - [ ] All test commands include expected outputs

### Clinical & User-Facing Documentation

- [ ] **Clinician-facing explanation updated:**
  - [ ] What the LDL card means
  - [ ] How targets are chosen (based on ASCVD risk)
  - [ ] Why targets vary (70/100/130 mg/dL)
  - [ ] When the card appears (gating criteria)

- [ ] **Product documentation updated:**
  - [ ] Feature announcement (what's new)
  - [ ] Help center article: "Understanding Your LDL Recommendations"
  - [ ] FAQ: "Why don't I see an LDL card?"
  - [ ] Disclaimer about personalization and clinical follow-up

- [ ] **Training materials prepared:**
  - [ ] Internal training for support team
  - [ ] Clinical team briefing on new LDL logic
  - [ ] Demo environment for hands-on testing

---

## 8. Promotion Plan

### Merge Strategy

- [ ] **Target production branch identified:**
  - [ ] Production branch name: `main` / `prod` / `production`
  - [ ] Current branch: `feat/my-first-mods-preview` (preview only)
  - [ ] Intermediate branch (if any): Release candidate branch

- [ ] **Merge sequence planned:**
  - [ ] Step 1: Merge `fix/preview-dynamic-ldl` → `feat/my-first-mods-preview` (DONE)
  - [ ] Step 2: Merge `fix/preview-ldl-shared-helpers` → `feat/my-first-mods-preview`
  - [ ] Step 3: Create release branch from `feat/my-first-mods-preview`
  - [ ] Step 4: Merge release branch → production (after checklist completion)

- [ ] **PR approval requirements:**
  - [ ] Minimum reviewers: 2 (technical + clinical)
  - [ ] Required checks: Build passes, tests pass
  - [ ] Approval authority defined (who can merge to production)

### Access Control

- [ ] **Authority to approve PR:**
  - [ ] Technical owner: [NAME] (must approve code changes)
  - [ ] Clinical owner: [NAME] (must approve content and thresholds)
  - [ ] Operations owner: [NAME] (must approve deployment plan)

- [ ] **Authority to enable feature flag in production:**
  - [ ] Primary: Technical owner + Clinical owner (both required)
  - [ ] Secondary: Operations team (emergency rollback only)

- [ ] **AI/Automation agent restrictions:**
  - [ ] Agents are READ-ONLY on production branches
  - [ ] Agents CANNOT merge PRs to production
  - [ ] Agents CANNOT modify production environment variables
  - [ ] Agents CANNOT create or rotate production secrets
  - [ ] Guardrails enforced via `AGENT_CONTROL_LGX_PREVIEW.md`

### Deployment Plan

- [ ] **Deployment method documented:**
  - [ ] Cloudflare Pages automatic deployment from production branch
  - [ ] OR manual `wrangler pages deploy dist --project-name <production-project>`

- [ ] **Feature flag activation plan:**
  - [ ] Environment variable set in Cloudflare Pages dashboard
  - [ ] OR feature flag service toggle (if applicable)
  - [ ] Gradual rollout plan (if using feature flag service)

- [ ] **Rollback procedure documented:**
  - [ ] Step 1: Set `ENABLE_DYNAMIC_LDL=false` in environment
  - [ ] Step 2: Verify LDL card no longer appears
  - [ ] Step 3: Investigate issue and fix
  - [ ] Estimated rollback time: < 5 minutes

---

## 9. Clinical & Regulatory Review

- [ ] **Clinical validation completed:**
  - [ ] LDL thresholds (100 mg/dL gate) reviewed by clinician
  - [ ] ASCVD risk thresholds (7.5%, 20%) reviewed by clinician
  - [ ] LDL targets (70/100/130 mg/dL) align with clinical guidelines
  - [ ] Nutritional recommendations reviewed for accuracy
  - [ ] Clinical discussion options reviewed (bergamot, psyllium, omega-3)
  - [ ] Disclaimer text reviewed and approved

- [ ] **Risk assessment completed:**
  - [ ] What happens if wrong target is shown? (Mitigation: Conservative targets)
  - [ ] What happens if card shows when it shouldn't? (Mitigation: Gating logic + clinical follow-up)
  - [ ] What happens if card doesn't show when it should? (Mitigation: Existing generic recommendations remain)

- [ ] **Regulatory compliance (if applicable):**
  - [ ] HIPAA compliance verified (no PHI leakage)
  - [ ] Medical device regulations reviewed (if applicable)
  - [ ] Disclaimers meet legal requirements
  - [ ] Terms of service updated (if needed)

---

## 10. Final Sign-Off

### Required Approvals

- [ ] **Technical Owner Sign-Off:**
  - [ ] Name: ___________________________
  - [ ] Title: ___________________________
  - [ ] Date: ___________________________
  - [ ] Signature: ___________________________
  - [ ] Confirms: Code quality, test coverage, feature flag implementation

- [ ] **Clinical Owner Sign-Off:**
  - [ ] Name: ___________________________
  - [ ] Title: ___________________________
  - [ ] Date: ___________________________
  - [ ] Signature: ___________________________
  - [ ] Confirms: Thresholds, targets, content, clinical accuracy

- [ ] **Operations / Infrastructure Sign-Off:**
  - [ ] Name: ___________________________
  - [ ] Title: ___________________________
  - [ ] Date: ___________________________
  - [ ] Signature: ___________________________
  - [ ] Confirms: Deployment plan, rollback procedure, monitoring

### Pre-Deployment Final Check

- [ ] All items in sections 1-9 are checked
- [ ] All sign-offs obtained
- [ ] Production environment variables prepared
- [ ] Rollback plan tested in preview
- [ ] Support team notified of deployment
- [ ] Monitoring dashboards ready
- [ ] Emergency contact list updated

---

## Notes

- **This checklist should be reviewed before EVERY production deployment of LDL changes.**
- **If ANY item is unchecked, deployment should be delayed until resolved.**
- **This is a living document - update it as requirements evolve.**

---

**Last Updated:** 2025-11-28  
**Document Owner:** Technical Lead / Clinical Lead  
**Review Frequency:** Before each production deployment + quarterly review
