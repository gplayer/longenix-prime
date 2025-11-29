# CHECKLIST_HBA1C_PRODUCTION.md – Dynamic HbA1c/Glucose Production Readiness

This checklist describes what must be true before the dynamic HbA1c/Glucose feature (Dynamic Fix Pack #3 – HbA1c/Glucose Management) can be safely enabled in a production environment.

It is a living document and should be updated if requirements change.

---

## 1. Functional Behavior

- [ ] **Tier thresholds verified (ADA 2024 Guidelines):**
  - [ ] **HbA1c thresholds:**
    - [ ] Normal: `< 5.7%`
    - [ ] Elevated-Normal: `5.7-5.9%`
    - [ ] Prediabetes: `6.0-6.4%`
    - [ ] Diabetes: `6.5-7.9%`
    - [ ] High-Risk Diabetes: `≥ 8.0%`
  - [ ] **Fasting Glucose thresholds:**
    - [ ] Normal: `< 100` mg/dL
    - [ ] Elevated-Normal: `100-109` mg/dL
    - [ ] Prediabetes: `110-125` mg/dL
    - [ ] Diabetes: `126-199` mg/dL
    - [ ] High-Risk Diabetes: `≥ 200` mg/dL

- [ ] **Status classifications verified:**
  - [ ] HbA1c `< 5.7%` OR glucose `< 100` mg/dL → `status = "normal"`
  - [ ] HbA1c `5.7-5.9%` OR glucose `100-109` mg/dL → `status = "elevated_normal"`
  - [ ] HbA1c `6.0-6.4%` OR glucose `110-125` mg/dL → `status = "prediabetes"`
  - [ ] HbA1c `6.5-7.9%` OR glucose `126-199` mg/dL → `status = "diabetes"`
  - [ ] HbA1c `≥ 8.0%` OR glucose `≥ 200` mg/dL → `status = "high_risk_diabetes"`
  - [ ] No data → `status = null`

- [ ] **Priority logic verified:**
  - [ ] **HbA1c takes priority** when both HbA1c and glucose are present (gold standard)
  - [ ] Glucose used as fallback when HbA1c is missing
  - [ ] Classification function correctly implements this logic

- [ ] **Gating logic verified:**
  - [ ] Card shows ONLY when glycemic data is available AND status is NOT normal
  - [ ] If `hba1cValue = null` AND `glucoseValue = null`, then `shown = false`
  - [ ] If `status = "normal"`, then `shown = false` (no clinical action needed)
  - [ ] If `status = null`, then `shown = false`
  - [ ] Card appears for: elevated_normal, prediabetes, diabetes, high_risk_diabetes

- [ ] **Response shape for the HbA1c probe endpoint verified:**
  - [ ] Probe returns: `{ success, shown, hba1cValue, glucoseValue, status, html, fingerprint }`
  - [ ] All fields have correct types and nullable behavior
  - [ ] Error responses follow standard format: `{ success: false, error, details, fingerprint }`

- [ ] **Main report HbA1c card content reviewed and clinically approved:**
  - [ ] **Elevated-Normal (5.7-5.9% HbA1c / 100-109 mg/dL glucose):**
    - [ ] ⚠️ WATCH label present (yellow priority)
    - [ ] "Increased Diabetes Risk" messaging
    - [ ] Recommendations: 5-7% weight loss, 150 min/week exercise, low GI diet, fiber increase
    - [ ] Retest: 6 months
    - [ ] Consider registered dietitian consultation
  - [ ] **Prediabetes (6.0-6.4% HbA1c / 110-125 mg/dL glucose):**
    - [ ] 🟠 HIGH PRIORITY label present (orange priority)
    - [ ] "Urgent Lifestyle Intervention Needed" messaging
    - [ ] "Aggressive intervention can REVERSE this condition" statement
    - [ ] Recommendations: 7-10% weight loss goal, 300 min/week exercise, low glycemic diet
    - [ ] **Discuss metformin with physician** (especially if BMI ≥ 35)
    - [ ] Retest: 3 months
    - [ ] Screen for complications (eyes, kidneys)
    - [ ] Consider CGM (continuous glucose monitor)
  - [ ] **Diabetes (6.5-7.9% HbA1c / 126-199 mg/dL glucose):**
    - [ ] 🔴 URGENT label present (red priority)
    - [ ] "Immediate Physician Referral Required" messaging
    - [ ] **URGENT: Immediate Physician Referral** warning box
    - [ ] "Do NOT attempt self-management without physician guidance" warning
    - [ ] **Schedule physician appointment THIS WEEK** instruction
    - [ ] Confirm diagnosis with repeat testing
    - [ ] Discuss medication options (metformin, GLP-1 agonists)
    - [ ] Comprehensive complication screening (eye exam, kidney function, foot exam, lipid panel, blood pressure)
    - [ ] Disclaimer: "This report is NOT a diabetes diagnosis tool. Diabetes must be confirmed by a physician with repeat testing."
  - [ ] **High-Risk Diabetes (≥ 8.0% HbA1c / ≥ 200 mg/dL glucose):**
    - [ ] 🔴 CRITICAL label present (red priority)
    - [ ] "Severe Hyperglycemia - Urgent Medical Attention Required" title
    - [ ] **"⚠️ CALL YOUR DOCTOR TODAY OR GO TO URGENT CARE"** prominent warning
    - [ ] Risk of diabetic ketoacidosis (DKA) or hyperosmolar state mentioned
    - [ ] "May require immediate medication adjustment or hospitalization"
    - [ ] "DO NOT delay medical care" and "DO NOT attempt lifestyle changes alone" warnings
    - [ ] Warning symptoms listed: excessive thirst, urination, unexplained weight loss, blurred vision, confusion, fruity breath, nausea/vomiting
    - [ ] Emergency care instructions present
  - [ ] Preview label `(Preview dynamic - Fix Pack #3)` removed or replaced with production text
  - [ ] All priority levels use correct color schemes (yellow, orange, red)

---

## 2. Safety & Data Gating

- [ ] **Card is shown ONLY when clinically indicated:**
  - [ ] HbA1c ≥ 5.7% OR glucose ≥ 100 mg/dL (non-normal status)
  - [ ] Card hidden for normal values (HbA1c < 5.7% AND glucose < 100 mg/dL)
  - [ ] Card hidden when no data available
  - [ ] Gating logic uses OR (not AND) when both values present

- [ ] **If HbA1c/glucose data is missing or invalid:**
  - [ ] `shown = false` is returned
  - [ ] HbA1c card is NOT displayed in report
  - [ ] No speculative or placeholder recommendations are shown
  - [ ] No error is thrown (graceful degradation)

- [ ] **High-Risk Diabetes range (≥ 8.0% HbA1c / ≥ 200 mg/dL glucose) safety measures verified:**
  - [ ] **RED critical alert** (border-red-200, bg-red-100)
  - [ ] **🔴 CRITICAL label** prominently displayed
  - [ ] **EXPLICIT instruction: "CALL YOUR DOCTOR TODAY OR GO TO URGENT CARE"**
  - [ ] DKA/hyperosmolar state risk warning present
  - [ ] Warning symptoms section with emergency care instructions
  - [ ] "DO NOT delay medical care" warning present
  - [ ] "DO NOT attempt lifestyle changes alone" warning present
  - [ ] Emergency warning box with red styling

- [ ] **Diabetes range (6.5-7.9% HbA1c / 126-199 mg/dL glucose) safety measures verified:**
  - [ ] **RED urgent alert** (border-red-200, bg-red-100)
  - [ ] **🔴 URGENT label** prominently displayed
  - [ ] "Immediate Physician Referral Required" warning present
  - [ ] **EXPLICIT: "Schedule physician appointment THIS WEEK"**
  - [ ] "Do NOT attempt self-management without physician guidance" warning
  - [ ] Disclaimer about NOT being a diagnosis tool
  - [ ] Complication screening recommendations present
  - [ ] No dosing or treatment recommendations (defer to physician)

- [ ] **Prediabetes range (6.0-6.4% HbA1c / 110-125 mg/dL glucose) clinical appropriateness verified:**
  - [ ] **ORANGE high priority alert** (border-orange-200, bg-orange-100)
  - [ ] **🟠 HIGH PRIORITY label** prominently displayed
  - [ ] Appropriate intensity recommendations (7-10% weight loss, 300 min/week exercise)
  - [ ] "Aggressive intervention can REVERSE this condition" encouragement
  - [ ] Metformin discussion recommended (especially if BMI ≥ 35)
  - [ ] Short retest interval (3 months)
  - [ ] Complication screening recommended (preventative)

- [ ] **No database writes occur during HbA1c computation:**
  - [ ] Shared module (`src/hba1c-dynamic.ts`) contains only pure functions
  - [ ] No calls to `env.DB` in HbA1c logic
  - [ ] Probe endpoint DB guard is active (warns if binding present, never accesses)

- [ ] **No dynamic HbA1c behavior without explicit flag:**
  - [ ] Feature flag `PREVIEW_DYNAMIC_HBA1C` (or production equivalent) must be `true`
  - [ ] If flag is `false` or missing, no HbA1c card is shown
  - [ ] Flag is checked before any HbA1c computation in main report

- [ ] **Sanity checks for data extraction:**
  - [ ] HbA1c values validated: must be between 3% and 15% (physiological range)
  - [ ] Glucose values validated: must be between 40 and 400 mg/dL (physiological range)
  - [ ] Values outside ranges are rejected (treated as null)

---

## 3. Feature Flags & Configuration

- [ ] **Clear feature flag exists for dynamic HbA1c:**
  - [ ] Current preview flag: `PREVIEW_DYNAMIC_HBA1C = true` (line ~31 in `src/index.tsx`)
  - [ ] Production flag name decided (e.g., `ENABLE_DYNAMIC_HBA1C`, `FEATURE_HBA1C_PERSONALIZATION`)
  - [ ] Flag source determined (environment variable, config file, or feature flag service)

- [ ] **Default for production deployments explicitly documented:**
  - [ ] Production default: `false` (off by default until clinical approval)
  - [ ] Flag must be explicitly enabled after checklist completion

- [ ] **Mechanism to enable HbA1c in production is documented:**
  - [ ] Environment variable: `ENABLE_DYNAMIC_HBA1C=true` in Cloudflare Pages settings
  - [ ] OR config file: Update `wrangler.jsonc` or equivalent
  - [ ] OR feature flag service: Toggle in LaunchDarkly/equivalent

- [ ] **Rollback plan exists:**
  - [ ] How to disable quickly: Set `ENABLE_DYNAMIC_HBA1C=false` in Cloudflare dashboard
  - [ ] Fallback behavior: HbA1c card does not appear (graceful degradation)
  - [ ] Estimated rollback time: < 5 minutes (environment variable update)
  - [ ] Who has access to disable: Operations team + Technical owner

---

## 4. Testing

### Manual Probe Tests (TESTING_HBA1C.md)

- [ ] **Test Case 1: Empty body `{}`**
  - [ ] Expected: `success=true, shown=false, hba1cValue=null, glucoseValue=null, status=null`
  - [ ] Verified: Card hidden, no data displayed

- [ ] **Test Case 2: Normal (HbA1c 5.3%)**
  - [ ] Input: `{"biomarkers":{"hba1c":5.3}}`
  - [ ] Expected: `shown=false, hba1cValue=5.3, status="normal"`
  - [ ] Verified: Card hidden (no clinical action needed)

- [ ] **Test Case 3: Elevated-Normal (HbA1c 5.8%, Glucose 105 mg/dL)**
  - [ ] Input: `{"biomarkers":{"hba1c":5.8,"glucose":105}}`
  - [ ] Expected: `shown=true, hba1cValue=5.8, glucoseValue=105, status="elevated_normal"`
  - [ ] Verified: ⚠️ WATCH label, lifestyle recommendations, 6-month retest

- [ ] **Test Case 4: Prediabetes (HbA1c 6.2%, Glucose 118 mg/dL)**
  - [ ] Input: `{"biomarkers":{"hba1c":6.2,"glucose":118}}`
  - [ ] Expected: `shown=true, hba1cValue=6.2, glucoseValue=118, status="prediabetes"`
  - [ ] Verified: 🟠 HIGH PRIORITY, intensive intervention, metformin discussion, 3-month retest

- [ ] **Test Case 5: Diabetes (HbA1c 7.2%, Glucose 145 mg/dL)**
  - [ ] Input: `{"biomarkers":{"hba1c":7.2,"glucose":145}}`
  - [ ] Expected: `shown=true, hba1cValue=7.2, glucoseValue=145, status="diabetes"`
  - [ ] Verified: 🔴 URGENT, physician referral THIS WEEK, complication screening

- [ ] **Test Case 6: High-Risk Diabetes (HbA1c 9.5%, Glucose 250 mg/dL)**
  - [ ] Input: `{"biomarkers":{"hba1c":9.5,"glucose":250}}`
  - [ ] Expected: `shown=true, hba1cValue=9.5, glucoseValue=250, status="high_risk_diabetes"`
  - [ ] Verified: 🔴 CRITICAL, "CALL DOCTOR TODAY", DKA risk warning, emergency symptoms

- [ ] **Test Case 7: Glucose-only (Prediabetes - 115 mg/dL)**
  - [ ] Input: `{"biomarkers":{"glucose":115}}`
  - [ ] Expected: `shown=true, glucoseValue=115, status="prediabetes"`
  - [ ] Verified: Correct classification using glucose fallback

- [ ] **Test Case 8: Glucose-only (High-Risk - 210 mg/dL)**
  - [ ] Input: `{"biomarkers":{"glucose":210}}`
  - [ ] Expected: `shown=true, glucoseValue=210, status="high_risk_diabetes"`
  - [ ] Verified: Correct high-risk classification using glucose fallback

### End-to-End Report Tests

- [ ] **Scenario 1: HbA1c card HIDDEN (normal values)**
  - [ ] HbA1c = 5.3%, glucose = 95 mg/dL
  - [ ] Verified: No HbA1c card appears in report
  - [ ] Biomarker section shows values in normal range

- [ ] **Scenario 2: HbA1c card SHOWN with prediabetes warning**
  - [ ] HbA1c = 6.1%, glucose = 112 mg/dL
  - [ ] Verified: Card appears with 🟠 HIGH PRIORITY, prediabetes content
  - [ ] Lifestyle interventions and metformin discussion present
  - [ ] 3-month retest recommendation

- [ ] **Scenario 3: HbA1c card SHOWN with diabetes urgent referral**
  - [ ] HbA1c = 7.0%, glucose = 140 mg/dL
  - [ ] Verified: Card appears with 🔴 URGENT, physician referral THIS WEEK
  - [ ] Complication screening recommendations
  - [ ] Disclaimer about NOT being diagnostic tool

- [ ] **Scenario 4: HbA1c card SHOWN with high-risk critical warning**
  - [ ] HbA1c = 9.2%, glucose = 220 mg/dL
  - [ ] Verified: Card appears with 🔴 CRITICAL, "CALL DOCTOR TODAY" warning
  - [ ] Emergency symptoms listed
  - [ ] DKA risk warning present

### Automated Tests

- [ ] **Unit tests for shared HbA1c helpers exist:**
  - [ ] `extractHba1cValueFromBiomarkers()` - Tests multiple key variants ('hba1c', 'HbA1c', 'HBA1C', 'a1c', 'A1C', 'hemoglobinA1c', 'glycated_hemoglobin')
  - [ ] `extractGlucoseValueFromBiomarkers()` - Tests multiple key variants ('glucose', 'fastingGlucose', 'fasting_glucose', 'bloodGlucose', 'fpg')
  - [ ] `extractHba1cValueFromComprehensiveData()` - Tests nested data structures (biomarkers, clinical, root)
  - [ ] `extractGlucoseValueFromComprehensiveData()` - Tests nested data structures
  - [ ] `classifyGlycemicStatus()` - Tests all 5 tier boundaries + HbA1c priority over glucose
  - [ ] `shouldShowHbA1cCard()` - Tests gating logic (hide normal, show others)
  - [ ] `generateHbA1cCardHTML()` - Tests HTML generation for all 5 tiers
  - [ ] `buildHbA1cCardResult()` - Tests complete flow
  - [ ] Tests null/undefined/invalid input handling
  - [ ] Tests physiological range validation (HbA1c 3-15%, glucose 40-400 mg/dL)

- [ ] **Integration tests for report generation:**
  - [ ] HbA1c card appears in correct section ("Biomarker Optimization" or "High Priority Interventions")
  - [ ] Card has `data-test="hba1c-card"` attribute for test automation
  - [ ] HTML output matches expected structure
  - [ ] Priority classes applied correctly (yellow, orange, red)

- [ ] **All tests documented in CI/README:**
  - [ ] Test commands documented
  - [ ] Test coverage requirements defined
  - [ ] CI pipeline runs tests automatically

---

## 5. Security & Compliance

- [ ] **No secrets hard-coded in HbA1c code or test docs:**
  - [ ] No passwords in source files
  - [ ] No API keys in test examples
  - [ ] All examples use placeholders: `<PW>`, `<BASE>`, `<TENANT>`

- [ ] **Authentication requirements unchanged and verified:**
  - [ ] Basic Auth required for probe endpoint
  - [ ] `X-Tenant-ID` header or query parameter required
  - [ ] Production tenants are NOT `demo-a`, `demo-b`, `demo-c`
  - [ ] Production Basic Auth credentials are different from preview

- [ ] **Access control for preview/test tenants:**
  - [ ] Demo tenants (`demo-a`, `demo-b`, `demo-c`) accessible only in preview
  - [ ] Production tenants have proper access controls
  - [ ] Tenant validation enforced at API level

- [ ] **PHI (Protected Health Information) handling:**
  - [ ] No PHI logged in error messages
  - [ ] Fingerprints used instead of full error details in responses
  - [ ] HbA1c and glucose values treated as sensitive data
  - [ ] Probe endpoint does not store any data
  - [ ] No patient identifiers in logs or error messages

- [ ] **Clinical governance and regulatory alignment:**
  - [ ] HbA1c recommendations align with ADA 2024 Guidelines
  - [ ] Clear disclaimers present (NOT a diagnostic tool)
  - [ ] Language reviewed for appropriate clinical decision support vs medical advice
  - [ ] Emergency instructions appropriate and clear
  - [ ] No treatment/dosing recommendations (defers to physician for medication)

---

## 6. Observability & Logging

- [ ] **Error logging strategy defined:**
  - [ ] Errors logged with fingerprint for tracking
  - [ ] Stack traces not exposed in API responses
  - [ ] Sensitive data (HbA1c, glucose values, patient info) redacted from logs

- [ ] **Monitoring strategy for HbA1c feature:**
  - [ ] Metric: Frequency of HbA1c card being shown (per session/report)
  - [ ] Metric: Status distribution (normal/elevated/prediabetes/diabetes/high-risk)
  - [ ] Metric: HbA1c-only vs glucose-only vs combined data cases
  - [ ] Alert: Unexpected error rates from HbA1c computation
  - [ ] Alert: High rate of `shown=false` (potential data quality issue)
  - [ ] Alert: Unusual distribution of high-risk diabetes cases (may indicate data error)

- [ ] **Integration with existing monitoring stack:**
  - [ ] Metrics exported to Cloudflare Analytics or equivalent
  - [ ] Logs aggregated in centralized logging system
  - [ ] Dashboards created for HbA1c feature health
  - [ ] Alerts configured for critical errors

- [ ] **DB Guard logging verified:**
  - [ ] Warning logged if DB binding present in probe endpoint
  - [ ] No actual DB access occurs (confirmed via monitoring)
  - [ ] Warning format: `[fingerprint] ⚠️  DB binding present - probe will not access DB`

---

## 7. Documentation & Training

- [ ] **Technical documentation complete and accurate:**
  - [ ] API documentation for `POST /api/report/preview/hba1c` endpoint
  - [ ] Request/response schema documented with examples
  - [ ] Error codes and messages documented
  - [ ] Feature flag configuration documented
  - [ ] Rollback procedure documented

- [ ] **Testing documentation accessible:**
  - [ ] Link to `TESTING_HBA1C.md` in main README or docs folder
  - [ ] 8 probe test scenarios with curl/PowerShell examples
  - [ ] 4 E2E test scenarios documented
  - [ ] Expected outcomes clearly defined

- [ ] **Clinical documentation for end users:**
  - [ ] Explanation of 5-tier system (Normal, Elevated-Normal, Prediabetes, Diabetes, High-Risk)
  - [ ] ADA 2024 Guidelines thresholds explained
  - [ ] Priority level meanings (WATCH, HIGH PRIORITY, URGENT, CRITICAL)
  - [ ] When to seek medical attention (diabetes and high-risk tiers)
  - [ ] Limitations: NOT a diagnostic tool, confirmation needed

- [ ] **Training plan for new users/clinicians:**
  - [ ] Overview of HbA1c/glucose dynamic feature
  - [ ] How recommendations differ from static content
  - [ ] How to interpret each tier
  - [ ] When recommendations are shown vs hidden
  - [ ] Emergency response protocol for high-risk cases
  - [ ] How to escalate concerns or report issues

- [ ] **Code documentation:**
  - [ ] All functions in `src/hba1c-dynamic.ts` have JSDoc comments
  - [ ] Inline comments explain complex logic (e.g., HbA1c priority over glucose)
  - [ ] Constants clearly defined with clinical rationale (ADA 2024 Guidelines)

---

## 8. Promotion Plan

- [ ] **Merge strategy from preview into production:**
  - [ ] Preview branch: `fix/preview-dynamic-hba1c`
  - [ ] Target production branch: `main` or `production`
  - [ ] PR template includes this checklist as requirement
  - [ ] Code review required from: Technical owner + Clinical owner

- [ ] **Required approvals before enabling in production:**
  - [ ] Technical owner approval (code quality, security, performance)
  - [ ] Clinical owner approval (clinical accuracy, safety, guidelines alignment)
  - [ ] Operations/DevOps owner approval (deployment plan, rollback plan)
  - [ ] Compliance/Legal review (if required by organization)

- [ ] **Step-by-step deployment and verification plan:**
  1. [ ] Merge code to production branch with feature flag OFF
  2. [ ] Deploy to production environment
  3. [ ] Verify deployment successful (no errors, service running)
  4. [ ] Smoke test probe endpoint with demo data (feature flag still OFF)
  5. [ ] Enable feature flag for canary tenant (1-2% of users)
  6. [ ] Monitor for 24-48 hours:
     - [ ] No increase in error rates
     - [ ] Card shown rates match expectations
     - [ ] No user complaints or issues
  7. [ ] Gradual rollout: 10% → 25% → 50% → 100% of users
  8. [ ] Each rollout stage monitored for 24 hours before next stage
  9. [ ] Full rollout only after all stages successful

- [ ] **Rollback steps and responsibility:**
  - [ ] **Who**: Operations team member (on-call) OR Technical owner
  - [ ] **When**: If error rate > 5% OR critical user issue reported
  - [ ] **How**: 
    1. [ ] Set `ENABLE_DYNAMIC_HBA1C=false` in Cloudflare dashboard
    2. [ ] Verify HbA1c card no longer appears in new reports
    3. [ ] Notify team in incident channel
    4. [ ] Investigate root cause
  - [ ] **Time**: < 5 minutes to disable flag
  - [ ] **Communication**: Post-mortem required if rollback needed

---

## 9. Clinical & Regulatory Review

- [ ] **Clinical validation of thresholds & language:**
  - [ ] **ADA 2024 Guidelines compliance verified:**
    - [ ] HbA1c thresholds align with ADA 2024 Standards of Care
    - [ ] Glucose thresholds align with ADA 2024 Standards of Care
    - [ ] Prediabetes definition matches ADA criteria (HbA1c 6.0-6.4%)
    - [ ] Diabetes definition matches ADA criteria (HbA1c ≥ 6.5%)
  - [ ] **Clinical language appropriate:**
    - [ ] No overstatement of risk or urgency (except high-risk tier)
    - [ ] Appropriate encouragement for prediabetes (reversibility)
    - [ ] Clear urgency for diabetes tier (physician referral)
    - [ ] Emergency instructions for high-risk tier
    - [ ] All recommendations evidence-based

- [ ] **Documentation of evidence base and assumptions:**
  - [ ] ADA 2024 Standards of Care cited as primary source
  - [ ] HbA1c priority over glucose documented (rationale: gold standard, less variability)
  - [ ] Tier boundaries documented with clinical justification
  - [ ] Lifestyle recommendations based on DPP (Diabetes Prevention Program) evidence
  - [ ] Metformin discussion based on ADA recommendations (BMI ≥ 35, age < 60)

- [ ] **Risk assessment for incorrect classification:**
  - [ ] **False negative (missing high-risk case):**
    - [ ] Risk: Patient with diabetes/high-risk not identified
    - [ ] Mitigation: Card shows for ANY elevated value (HbA1c ≥ 5.7% OR glucose ≥ 100 mg/dL)
    - [ ] Mitigation: Disclaimer present (NOT a diagnostic tool)
  - [ ] **False positive (over-alerting):**
    - [ ] Risk: Patient with normal values gets unnecessary recommendations
    - [ ] Mitigation: Card hidden for normal status
    - [ ] Mitigation: Physiological range validation (HbA1c 3-15%, glucose 40-400 mg/dL)
  - [ ] **Misclassification (wrong tier):**
    - [ ] Risk: Prediabetes classified as diabetes or vice versa
    - [ ] Mitigation: Tier boundaries strictly follow ADA guidelines
    - [ ] Mitigation: HbA1c prioritized (more reliable than glucose)
    - [ ] Mitigation: Manual review of tier logic and unit tests
  - [ ] **Data quality issues:**
    - [ ] Risk: Invalid or out-of-range values
    - [ ] Mitigation: Sanity checks (HbA1c 3-15%, glucose 40-400 mg/dL)
    - [ ] Mitigation: Graceful degradation if data invalid

- [ ] **Sign-off requirements:**
  - [ ] **Clinical owner sign-off:**
    - [ ] Name: ________________________
    - [ ] Date: ________________________
    - [ ] Signature: ____________________
  - [ ] **Technical owner sign-off:**
    - [ ] Name: ________________________
    - [ ] Date: ________________________
    - [ ] Signature: ____________________
  - [ ] **Operations/DevOps owner sign-off:**
    - [ ] Name: ________________________
    - [ ] Date: ________________________
    - [ ] Signature: ____________________

---

## 10. Final Sign-Off

- [ ] **All checklist items completed:**
  - [ ] All checkboxes in sections 1-9 marked as complete
  - [ ] No outstanding items or exceptions
  - [ ] All documentation complete and accessible

- [ ] **Pre-production verification complete:**
  - [ ] All 8 manual probe tests pass
  - [ ] All 4 E2E tests pass
  - [ ] Automated unit tests pass (if implemented)
  - [ ] No regressions in Vitamin D or LDL features
  - [ ] Build successful, no TypeScript errors

- [ ] **Production enablement authorized:**
  - [ ] Technical owner authorizes production deployment
  - [ ] Clinical owner authorizes feature enablement
  - [ ] Operations team prepared for rollout and monitoring

- [ ] **Rollback plan tested:**
  - [ ] Feature flag disable verified to work
  - [ ] Rollback time confirmed (< 5 minutes)
  - [ ] Team knows who to contact for rollback

- [ ] **Monitoring and alerting in place:**
  - [ ] Dashboards created and accessible
  - [ ] Alerts configured for error rates
  - [ ] On-call rotation includes HbA1c feature coverage

---

## Notes

### Review Frequency

This checklist should be reviewed and updated:

1. **Before each major release** that touches HbA1c/glucose logic
2. **Annually** (or when ADA guidelines are updated)
3. **When clinical feedback suggests changes** (e.g., tier thresholds, recommendations)
4. **After any production incident** related to HbA1c feature

### How to Update This Checklist

1. **When ADA guidelines change:**
   - [ ] Review new ADA Standards of Care (published annually in January)
   - [ ] Update tier thresholds if changed
   - [ ] Update recommendations if evidence base changes
   - [ ] Re-verify all clinical content with clinical owner
   - [ ] Update `src/hba1c-dynamic.ts` constants
   - [ ] Update `TESTING_HBA1C.md` test cases

2. **When new features are added:**
   - [ ] Add new checklist items for new functionality
   - [ ] Update test cases
   - [ ] Re-verify safety and gating logic

3. **When issues are discovered:**
   - [ ] Add checklist items to prevent recurrence
   - [ ] Update risk assessment section
   - [ ] Document lessons learned

### Related Documents

- **Implementation Plan**: `DOC_HBA1C_DYNAMIC_PLAN.md`
- **Testing Guide**: `TESTING_HBA1C.md`
- **Shared Helper Module**: `src/hba1c-dynamic.ts`
- **LDL Checklist** (pattern reference): `CHECKLIST_LDL_PRODUCTION.md`
- **Vitamin D Checklist** (pattern reference): `CHECKLIST_VITAMIN_D_PRODUCTION.md`

### Maintenance Ownership

- **Technical Owner**: _______________________ (responsible for code, tests, deployment)
- **Clinical Owner**: _______________________ (responsible for clinical accuracy, guidelines alignment)
- **Operations Owner**: _______________________ (responsible for monitoring, rollback, on-call)

---

**Last Updated**: [Date]  
**Version**: 1.0  
**Status**: Draft (pending initial review)
