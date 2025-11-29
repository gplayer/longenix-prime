# CHECKLIST_VITAMIN_D_PRODUCTION.md – Dynamic Vitamin D Production Readiness

This checklist describes what must be true before the dynamic Vitamin D feature (Dynamic Fix Pack #2 – Vitamin D) can be safely enabled in a production environment.

It is a living document and should be updated if requirements change.

---

## 1. Functional Behavior

- [ ] **Tier thresholds verified:**
  - [ ] Severe deficiency: `< 20` ng/mL
  - [ ] Insufficiency: `20-30` ng/mL
  - [ ] Low-normal: `30-50` ng/mL
  - [ ] Optimal: `50-80` ng/mL
  - [ ] High (toxicity risk): `> 80` ng/mL

- [ ] **Status classifications verified:**
  - [ ] `< 20` ng/mL → `status = "severe_deficiency"`
  - [ ] `20-30` ng/mL → `status = "insufficiency"`
  - [ ] `30-50` ng/mL → `status = "low_normal"`
  - [ ] `50-80` ng/mL → `status = "optimal"`
  - [ ] `> 80` ng/mL → `status = "high"`

- [ ] **Gating logic verified:**
  - [ ] Card shows ONLY when Vitamin D data is available
  - [ ] If `vitaminDValue = null`, then `shown = false`
  - [ ] No card appears if data is missing or invalid

- [ ] **Response shape for the Vitamin D probe endpoint verified:**
  - [ ] Probe returns: `{ success, shown, vitaminDValue, status, html, fingerprint }`
  - [ ] All fields have correct types and nullable behavior
  - [ ] Error responses follow standard format: `{ success: false, error, details, fingerprint }`

- [ ] **Main report Vitamin D card content reviewed and clinically approved:**
  - [ ] Severe deficiency (< 20 ng/mL):
    - [ ] HIGH PRIORITY label present
    - [ ] "Immediate Action Required" warning present
    - [ ] Recommendation: High-dose D3 (5,000-10,000 IU daily)
    - [ ] Mentions: Loading dose, malabsorption assessment
    - [ ] Retest: 6-8 weeks
    - [ ] Includes K2 co-supplementation recommendation
  - [ ] Insufficiency (20-30 ng/mL):
    - [ ] MEDIUM PRIORITY label present
    - [ ] Recommendation: Moderate-dose D3 (4,000-5,000 IU daily)
    - [ ] Retest: 8-12 weeks
    - [ ] Goal: Move to optimal range (50-80 ng/mL)
  - [ ] Low-normal (30-50 ng/mL):
    - [ ] MAINTENANCE label present
    - [ ] Recommendation: Maintenance D3 (2,000-3,000 IU daily)
    - [ ] Retest: 3-6 months
    - [ ] Encourages optimization to 50-80 ng/mL
  - [ ] Optimal (50-80 ng/mL):
    - [ ] OPTIMAL label with checkmark (✓) present
    - [ ] "On Track" positive messaging
    - [ ] Recommendation: Maintenance dose (1,000-2,000 IU daily)
    - [ ] Retest: Annual recheck
    - [ ] No urgency or concern messaging
  - [ ] High / Toxicity risk (> 80 ng/mL):
    - [ ] CAUTION label present
    - [ ] "⚠️ Caution: High Level" warning present
    - [ ] **EXPLICIT: "HOLD all vitamin D supplementation"**
    - [ ] Toxicity risk warning (hypercalcemia)
    - [ ] Recommendation: Check serum calcium levels
    - [ ] Retest: 3 months to monitor decline
    - [ ] **EXPLICIT: "Do NOT continue routine high-dose supplementation"**
  - [ ] Preview label `(Preview dynamic)` removed or replaced with production text
  - [ ] All recommendations include "take with fat-containing meal"

---

## 2. Safety & Data Gating

- [ ] **Card is shown ONLY when data is available:**
  - [ ] Vitamin D value must be present and numeric
  - [ ] If `vitaminDValue = null`, then `shown = false`
  - [ ] Card does NOT appear in report if shown = false

- [ ] **If Vitamin D data is missing/invalid:**
  - [ ] `shown = false` is returned
  - [ ] Vitamin D card is NOT displayed in report
  - [ ] No speculative or placeholder recommendations are shown
  - [ ] No error is thrown (graceful degradation)

- [ ] **High/Toxicity range (> 80 ng/mL) safety measures verified:**
  - [ ] **RED priority alert** (border-red-200, bg-red-100)
  - [ ] **CAUTION label** prominently displayed
  - [ ] **EXPLICIT instruction: "HOLD all vitamin D supplementation"**
  - [ ] Toxicity warning includes hypercalcemia risk
  - [ ] Recommendation to check serum calcium
  - [ ] **NO high-dose recommendations** (explicitly states DO NOT continue)
  - [ ] Retest interval: 3 months (monitor decline)

- [ ] **Severe deficiency range (< 20 ng/mL) safety measures verified:**
  - [ ] **RED priority alert** (border-red-200, bg-red-100)
  - [ ] **HIGH PRIORITY label** prominently displayed
  - [ ] "Immediate Action Required" warning present
  - [ ] Appropriate high-dose range (5,000-10,000 IU) recommended
  - [ ] Mentions loading dose as clinically appropriate
  - [ ] Recommends assessing malabsorption
  - [ ] Short retest interval (6-8 weeks)

- [ ] **No database writes occur during Vitamin D computation:**
  - [ ] Shared module (`src/vitaminD-dynamic.ts`) contains only pure functions
  - [ ] No calls to `env.DB` in Vitamin D logic
  - [ ] Probe endpoint DB guard is active (warns if binding present, never accesses)

- [ ] **No dynamic Vitamin D behavior without explicit flag:**
  - [ ] Feature flag `PREVIEW_DYNAMIC_VITAMIN_D` (or production equivalent) must be `true`
  - [ ] If flag is `false` or missing, no Vitamin D card is shown
  - [ ] Flag is checked before any Vitamin D computation in main report

---

## 3. Feature Flags & Configuration

- [ ] **Clear feature flag exists for dynamic Vitamin D:**
  - [ ] Current preview flag: `PREVIEW_DYNAMIC_VITAMIN_D = true` (line ~18 in `src/index.tsx`)
  - [ ] Production flag name decided (e.g., `ENABLE_DYNAMIC_VITAMIN_D`, `FEATURE_VITAMIN_D_PERSONALIZATION`)
  - [ ] Flag source determined (environment variable, config file, or feature flag service)

- [ ] **Default for production deployments explicitly documented:**
  - [ ] Production default: `false` (off by default until clinical approval)
  - [ ] Flag must be explicitly enabled after checklist completion

- [ ] **Mechanism to enable Vitamin D in production is documented:**
  - [ ] Environment variable: `ENABLE_DYNAMIC_VITAMIN_D=true` in Cloudflare Pages settings
  - [ ] OR config file: Update `wrangler.jsonc` or equivalent
  - [ ] OR feature flag service: Toggle in LaunchDarkly/equivalent

- [ ] **Rollback plan exists:**
  - [ ] How to disable quickly: Set `ENABLE_DYNAMIC_VITAMIN_D=false` in Cloudflare dashboard
  - [ ] Fallback behavior: Vitamin D card does not appear (graceful degradation)
  - [ ] Estimated rollback time: < 5 minutes (environment variable update)
  - [ ] Who has access to disable: Operations team + Technical owner

---

## 4. Testing

### Manual Probe Tests (TESTING_VITAMIN_D.md)

- [ ] **Test Case 1: Empty body `{}`**
  - [ ] Expected: `success=true, shown=false, vitaminDValue=null, status=null`
  - [ ] Verified: Card hidden, no data displayed

- [ ] **Test Case 2: Severe deficiency - 12 ng/mL**
  - [ ] Input: `{"biomarkers":{"vitaminD":12}}`
  - [ ] Expected: `shown=true, vitaminDValue=12, status="severe_deficiency"`
  - [ ] Verified: HIGH PRIORITY, 5,000-10,000 IU recommendation, 6-8 week retest

- [ ] **Test Case 3: Insufficiency - 25 ng/mL**
  - [ ] Input: `{"biomarkers":{"vitaminD":25}}`
  - [ ] Expected: `shown=true, vitaminDValue=25, status="insufficiency"`
  - [ ] Verified: MEDIUM PRIORITY, 4,000-5,000 IU recommendation, 8-12 week retest

- [ ] **Test Case 4: Low-normal - 40 ng/mL**
  - [ ] Input: `{"biomarkers":{"vitaminD":40}}`
  - [ ] Expected: `shown=true, vitaminDValue=40, status="low_normal"`
  - [ ] Verified: MAINTENANCE, 2,000-3,000 IU recommendation, 3-6 month retest

- [ ] **Test Case 5: Optimal - 65 ng/mL**
  - [ ] Input: `{"biomarkers":{"vitaminD":65}}`
  - [ ] Expected: `shown=true, vitaminDValue=65, status="optimal"`
  - [ ] Verified: OPTIMAL with checkmark, "On Track" message, 1,000-2,000 IU maintenance, annual recheck

- [ ] **Test Case 6: High/Toxicity - 90 ng/mL**
  - [ ] Input: `{"biomarkers":{"vitaminD":90}}`
  - [ ] Expected: `shown=true, vitaminDValue=90, status="high"`
  - [ ] Verified: CAUTION warning, "HOLD all vitamin D supplementation", toxicity risk, check calcium, 3 month retest

### End-to-End Report Tests

- [ ] **Scenario 1: Vitamin D card HIDDEN (no data)**
  - [ ] Vitamin D value = null or missing
  - [ ] Verified: No Vitamin D card appears in report

- [ ] **Scenario 2: Vitamin D card SHOWN with severe deficiency**
  - [ ] Vitamin D = 12 ng/mL
  - [ ] Verified: Card appears with HIGH PRIORITY, red alert styling

- [ ] **Scenario 3: Vitamin D card SHOWN with optimal status**
  - [ ] Vitamin D = 65 ng/mL
  - [ ] Verified: Card appears with OPTIMAL badge, green styling, positive messaging

- [ ] **Scenario 4: Vitamin D card SHOWN with toxicity warning**
  - [ ] Vitamin D = 90 ng/mL
  - [ ] Verified: Card appears with CAUTION, red alert styling, HOLD supplementation message

### Automated Tests

- [ ] **Unit tests for shared Vitamin D helpers exist:**
  - [ ] `getVitaminDValueLocal()` - Tests multiple key variants ('vitaminD', 'vitamin_d', 'vitamin_D', 'VitaminD', 'VITAMIN_D', '25OHD', '25_oh_d')
  - [ ] `classifyVitaminDStatusLocal()` - Tests all 5 tier boundaries
  - [ ] `generateDynamicVitaminDCardLocal()` - Tests HTML generation for all 5 tiers
  - [ ] Tests null/undefined/invalid input handling

- [ ] **Integration tests for report generation:**
  - [ ] Vitamin D card appears in correct section (optimization strategies or high priority interventions)
  - [ ] Card has `data-test="vitamin-d-card"` attribute for test automation
  - [ ] HTML output matches expected structure

- [ ] **All tests documented in CI/README:**
  - [ ] Test commands documented
  - [ ] Test coverage requirements defined
  - [ ] CI pipeline runs tests automatically

---

## 5. Security & Compliance

- [ ] **No secrets hard-coded in Vitamin D code or test docs:**
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
  - [ ] Vitamin D values treated as sensitive data
  - [ ] Probe endpoint does not store any data

- [ ] **Content appropriateness verified:**
  - [ ] Recommendations suitable for clinician-facing tool
  - [ ] Not intended for patient self-prescribing
  - [ ] Appropriate disclaimers present
  - [ ] Clinical follow-up encouraged

---

## 6. Observability & Logging

- [ ] **Error logging strategy defined:**
  - [ ] Errors logged with fingerprint for tracking
  - [ ] Stack traces not exposed in API responses
  - [ ] Sensitive data (Vitamin D values, patient info) redacted from logs

- [ ] **Monitoring strategy for Vitamin D feature:**
  - [ ] Metric: Frequency of Vitamin D card being shown (per session/report)
  - [ ] Metric: Status distribution (severe_deficiency, insufficiency, low_normal, optimal, high)
  - [ ] Alert: Unexpected error rates from Vitamin D computation
  - [ ] Alert: High rate of `shown=false` (potential data quality issue)
  - [ ] Alert: High frequency of toxicity tier (> 80 ng/mL) - may indicate data issues

- [ ] **Integration with existing monitoring stack:**
  - [ ] Metrics exported to Cloudflare Analytics or equivalent
  - [ ] Logs aggregated in centralized logging system
  - [ ] Dashboards created for Vitamin D feature health

- [ ] **DB Guard logging verified:**
  - [ ] Warning logged if DB binding present in probe endpoint
  - [ ] No actual DB access occurs (confirmed via monitoring)

---

## 7. Documentation & Training

### Technical Documentation

- [ ] **Vitamin D implementation documented:**
  - [ ] `TESTING_VITAMIN_D.md` - Probe endpoint test guide
  - [ ] `DOC_STATIC_CONTENT_INVENTORY.md` - Vitamin D section explains the problem
  - [ ] Shared module (`src/vitaminD-dynamic.ts`) has inline documentation
  - [ ] Constants and thresholds explained with rationale

- [ ] **Preview guardrails documented:**
  - [ ] `AGENT_CONTROL_LGX_PREVIEW.md` - Agent behavior rules
  - [ ] Preview-only constraints clearly stated
  - [ ] NO PRODUCTION ACCESS rules enforced

- [ ] **Test procedures documented:**
  - [ ] `TESTING_VITAMIN_D.md` - Comprehensive probe validation with PowerShell and curl examples
  - [ ] All 6 test cases documented with expected outputs
  - [ ] Test commands include expected response shapes

### Clinical & User-Facing Documentation

- [ ] **Clinician-facing explanation updated:**
  - [ ] What the Vitamin D card means
  - [ ] How tiers are chosen (based on Vitamin D level in ng/mL)
  - [ ] Why recommendations vary (5 different dosing strategies)
  - [ ] When the card appears (data availability gating)
  - [ ] What to do for toxicity cases (> 80 ng/mL)

- [ ] **Product documentation updated:**
  - [ ] Feature announcement (what's new)
  - [ ] Help center article: "Understanding Your Vitamin D Recommendations"
  - [ ] FAQ: "Why don't I see a Vitamin D card?"
  - [ ] FAQ: "What does 'HOLD supplementation' mean?"
  - [ ] Disclaimer about personalization and clinical follow-up

- [ ] **Training materials prepared:**
  - [ ] Internal training for support team
  - [ ] Clinical team briefing on new Vitamin D logic
  - [ ] Demo environment for hands-on testing
  - [ ] Specific training on toxicity warnings and appropriate responses

---

## 8. Promotion Plan

### Merge Strategy

- [ ] **Target production branch identified:**
  - [ ] Production branch name: `main` / `prod` / `production`
  - [ ] Current branch: `feat/my-first-mods-preview` (preview only)
  - [ ] Intermediate branch (if any): Release candidate branch

- [ ] **Merge sequence planned:**
  - [ ] Step 1: Merge `fix/preview-dynamic-vitamin-d` → `feat/my-first-mods-preview` (DONE)
  - [ ] Step 2: Merge `fix/preview-vitamin-d-probe-stabilize` → `feat/my-first-mods-preview` (DONE)
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
  - [ ] Step 1: Set `ENABLE_DYNAMIC_VITAMIN_D=false` in environment
  - [ ] Step 2: Verify Vitamin D card no longer appears
  - [ ] Step 3: Investigate issue and fix
  - [ ] Estimated rollback time: < 5 minutes

---

## 9. Clinical & Regulatory Review

- [ ] **Clinical validation completed:**
  - [ ] Vitamin D tier thresholds (20, 30, 50, 80 ng/mL) reviewed by clinician
  - [ ] Dosing recommendations (5,000-10,000 IU for deficiency, 1,000-2,000 IU for optimal) reviewed
  - [ ] Retest intervals (6-8 weeks for severe, annual for optimal) validated
  - [ ] Toxicity warning (> 80 ng/mL) reviewed and approved
  - [ ] "HOLD supplementation" instruction reviewed and approved
  - [ ] K2 co-supplementation recommendation reviewed
  - [ ] All nutritional and lifestyle recommendations reviewed for accuracy

- [ ] **Risk assessment completed:**
  - [ ] What happens if wrong tier is shown? (Mitigation: Conservative dosing ranges, clinical follow-up)
  - [ ] What happens if toxicity warning is missed? (Mitigation: Explicit HOLD message, calcium check recommendation)
  - [ ] What happens if severe deficiency is missed? (Mitigation: Existing generic recommendations remain)
  - [ ] What happens if card shows when data is invalid? (Mitigation: Gating logic ensures shown=false)

- [ ] **Safety measures for high-risk scenarios:**
  - [ ] Toxicity (> 80 ng/mL): HOLD message, no routine supplementation, calcium check, 3-month retest
  - [ ] Severe deficiency (< 20 ng/mL): HIGH PRIORITY, aggressive replacement, malabsorption assessment, close follow-up
  - [ ] Both scenarios have RED alert styling for visibility

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
  - [ ] Confirms: Code quality, test coverage, feature flag implementation, probe endpoint stability

- [ ] **Clinical Owner Sign-Off:**
  - [ ] Name: ___________________________
  - [ ] Title: ___________________________
  - [ ] Date: ___________________________
  - [ ] Signature: ___________________________
  - [ ] Confirms: Thresholds, dosing recommendations, content, clinical accuracy, toxicity safeguards

- [ ] **Operations / Infrastructure Sign-Off:**
  - [ ] Name: ___________________________
  - [ ] Title: ___________________________
  - [ ] Date: ___________________________
  - [ ] Signature: ___________________________
  - [ ] Confirms: Deployment plan, rollback procedure, monitoring, alert configuration

### Pre-Deployment Final Check

- [ ] All items in sections 1-9 are checked
- [ ] All sign-offs obtained
- [ ] Production environment variables prepared
- [ ] Rollback plan tested in preview
- [ ] Support team notified of deployment
- [ ] Monitoring dashboards ready
- [ ] Emergency contact list updated
- [ ] Clinical team briefed on toxicity warnings

---

## Notes

- **This checklist should be reviewed before EVERY production deployment of Vitamin D changes.**
- **If ANY item is unchecked, deployment should be delayed until resolved.**
- **Pay special attention to toxicity warnings (> 80 ng/mL) - this is a patient safety issue.**
- **This is a living document - update it as requirements evolve.**

---

**Last Updated:** 2025-11-28  
**Document Owner:** Technical Lead / Clinical Lead  
**Review Frequency:** Before each production deployment + quarterly review
