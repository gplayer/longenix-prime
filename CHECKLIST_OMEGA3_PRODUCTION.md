# CHECKLIST_OMEGA3_PRODUCTION.md – Dynamic Omega-3/EPA+DHA Production Readiness

This checklist describes what must be true before the dynamic Omega-3/EPA+DHA supplementation feature (Dynamic Fix Pack #4 – Omega-3 / EPA+DHA Management) can be safely enabled in a production environment.

It is a living document and should be updated if requirements change.

---

## 1. Functional Behavior

- [ ] **Tier thresholds verified (AHA/ACC 2020 Guidelines):**
  - [ ] **Triglycerides thresholds:**
    - [ ] Normal: `< 150` mg/dL
    - [ ] Borderline High: `150-199` mg/dL
    - [ ] High: `200-499` mg/dL
    - [ ] Very High: `≥ 500` mg/dL (prescription omega-3 required)
  - [ ] **ASCVD Risk thresholds:**
    - [ ] Low: `< 7.5%` (10-year risk)
    - [ ] Moderate: `7.5-15%`
    - [ ] High: `≥ 15%`
  - [ ] **Omega-3 Index thresholds:**
    - [ ] Deficient: `< 4%` (red blood cell EPA+DHA)
    - [ ] Insufficient: `4-8%`
    - [ ] Optimal: `≥ 8%` (cardioprotective range)
  - [ ] **Dietary Fish Intake thresholds:**
    - [ ] Low: `< 2` servings/week
    - [ ] Moderate: `2-3` servings/week
    - [ ] High: `≥ 4` servings/week (may not need supplementation)

- [ ] **6-Tier classification system verified:**
  - [ ] **Tier 0 (Contraindicated)**:
    - [ ] Criteria: Bleeding disorder OR upcoming surgery within 2 weeks
    - [ ] Action: DO NOT RECOMMEND (red warning card)
    - [ ] Priority: `❌ CONTRAINDICATION`
  - [ ] **Tier 1 (High-Priority Supplementation)**:
    - [ ] Criteria: Very high TG ≥ 500 mg/dL OR high TG 200-499 mg/dL OR high ASCVD risk ≥ 15% + elevated TG ≥ 150 mg/dL OR cardiovascular event + Omega-3 Index < 8%
    - [ ] Action: High-dose supplementation (2-4g EPA/DHA daily) OR prescription (TG ≥ 500)
    - [ ] Priority: `🔴 HIGH PRIORITY`
  - [ ] **Tier 2 (Moderate-Priority Supplementation)**:
    - [ ] Criteria: Borderline high TG 150-199 mg/dL OR moderate ASCVD risk 7.5-15% OR low HDL with TG elevation OR low dietary fish intake
    - [ ] Action: Moderate-dose supplementation (1-2g EPA/DHA daily)
    - [ ] Priority: `🟠 MEDIUM PRIORITY`
  - [ ] **Tier 3 (Dietary Emphasis)**:
    - [ ] Criteria: Normal TG < 150 mg/dL AND low ASCVD risk < 7.5% AND moderate-high dietary fish intake
    - [ ] Action: Continue dietary pattern (2-3 fatty fish servings/week)
    - [ ] Priority: `✅ MAINTENANCE`
  - [ ] **Tier 4 (Caution Required)**:
    - [ ] Criteria: On anticoagulants (warfarin, DOACs) OR antiplatelet agents (aspirin, clopidogrel) OR multiple bleeding risk factors
    - [ ] Action: Physician approval required, low-dose only (≤ 1g EPA/DHA daily)
    - [ ] Priority: `⚠️ CAUTION`
  - [ ] **Tier 5 (No Recommendation Needed)**:
    - [ ] Criteria: Omega-3 Index ≥ 8% OR already taking ≥ 2g/day supplements OR very high dietary intake ≥ 4 servings/week
    - [ ] Action: No card shown (patient already optimal)
    - [ ] Priority: N/A

- [ ] **Gating logic verified:**
  - [ ] Card shows ONLY when clinically indicated (Tier 0-4)
  - [ ] Card hidden for Tier 5 (patient already optimal)
  - [ ] Card hidden when insufficient data to classify (all values null)
  - [ ] If `triglycerides = null` AND `ascvdRisk = null` AND `omega3Index = null`, then `shown = false`
  - [ ] Contraindication (Tier 0) overrides all other tiers (safety first)
  - [ ] Very high TG ≥ 500 mg/dL triggers prescription referral messaging

- [ ] **Response shape for the Omega-3 probe endpoint verified:**
  - [ ] Probe returns: `{ success, shown, triglycerides, ascvdRisk, omega3Index, tier, priority, html, fingerprint }`
  - [ ] All fields have correct types and nullable behavior
  - [ ] Error responses follow standard format: `{ success: false, error, details, fingerprint }`

- [ ] **Main report Omega-3 card content reviewed and clinically approved:**
  - [ ] **Tier 0 - Contraindicated:**
    - [ ] ❌ CONTRAINDICATION label present (red alert)
    - [ ] "DO NOT RECOMMEND OMEGA-3 SUPPLEMENTATION" prominent warning
    - [ ] Reason stated: "Bleeding disorder detected" OR "Upcoming surgery within 2 weeks"
    - [ ] "Omega-3 supplementation may increase bleeding risk" explanation
    - [ ] "Consult your physician before considering omega-3 supplements" instruction
    - [ ] No dosing recommendations provided
  - [ ] **Tier 1 - High-Priority Supplementation:**
    - [ ] 🔴 HIGH PRIORITY label present (red priority)
    - [ ] **For TG ≥ 500 mg/dL**: "PRESCRIPTION OMEGA-3 REQUIRED" warning
      - [ ] "Schedule physician appointment THIS WEEK" instruction
      - [ ] "Discuss prescription omega-3 (Vascepa/Lovaza 4g EPA daily)" recommendation
      - [ ] "Over-the-counter supplements insufficient at this triglyceride level" explanation
    - [ ] **For TG 200-499 mg/dL**: "High-Dose Supplementation Recommended"
      - [ ] "2-4g EPA/DHA daily from high-quality fish oil" recommendation
      - [ ] "Target: EPA 2-3g, DHA 1-2g (read supplement labels carefully)" guidance
      - [ ] Retest triglycerides in 3 months
    - [ ] **For high ASCVD risk + elevated TG**: "Cardiovascular Risk Reduction Priority"
      - [ ] "2-3g EPA/DHA daily to support heart health" recommendation
      - [ ] "Consider prescription omega-3 if over-the-counter ineffective" guidance
    - [ ] Food sources listed: fatty fish (salmon, mackerel, sardines, anchovies, herring)
    - [ ] Quality guidance: "Choose pharmaceutical-grade, third-party tested supplements"
  - [ ] **Tier 2 - Moderate-Priority Supplementation:**
    - [ ] 🟠 MEDIUM PRIORITY label present (orange priority)
    - [ ] "Moderate-Dose Supplementation Recommended" title
    - [ ] "1-2g EPA/DHA daily from fish oil or algae oil" recommendation
    - [ ] "Target: EPA 1-1.5g, DHA 0.5-1g" specific guidance
    - [ ] "Increase fatty fish consumption to 2-3 servings/week" dietary recommendation
    - [ ] Retest triglycerides in 6 months (if borderline high)
    - [ ] "Monitor HDL cholesterol if low HDL is contributing factor" guidance
  - [ ] **Tier 3 - Dietary Emphasis:**
    - [ ] ✅ MAINTENANCE label present (green/blue neutral)
    - [ ] "Continue Current Dietary Pattern" title
    - [ ] "Your current fatty fish intake is sufficient" affirmation
    - [ ] "Target: 2-3 servings fatty fish per week (salmon, mackerel, sardines)" recommendation
    - [ ] "Consider low-dose supplement (500-1000mg EPA/DHA) if dietary intake inconsistent" optional guidance
    - [ ] No urgent action required
  - [ ] **Tier 4 - Caution Required:**
    - [ ] ⚠️ CAUTION label present (yellow/orange warning)
    - [ ] "CAUTION: Physician Approval Required Before Supplementation" prominent warning
    - [ ] "You are taking anticoagulants/antiplatelet agents" reason stated
    - [ ] "Omega-3 may increase bleeding risk when combined with blood thinners" explanation
    - [ ] "IF physician approves: Low-dose ONLY (≤ 1g EPA/DHA daily)" conditional recommendation
    - [ ] "Monitor for bleeding signs: unusual bruising, prolonged bleeding, blood in stool/urine" safety instruction
    - [ ] "Do NOT exceed 1g daily without physician guidance" warning
    - [ ] Medication interaction warning box with red/orange styling
  - [ ] Preview label `(Preview dynamic - Fix Pack #4)` removed or replaced with production text
  - [ ] All priority levels use correct color schemes (red, orange, yellow, green/blue)

---

## 2. Safety & Data Gating

- [ ] **Card is shown ONLY when clinically indicated:**
  - [ ] Tier 0-4: Card shown (contraindicated, high-priority, moderate-priority, dietary, caution)
  - [ ] Tier 5: Card hidden (patient already optimal - Omega-3 Index ≥ 8% OR already supplementing ≥ 2g/day)
  - [ ] Card hidden when insufficient data to classify (all triglycerides, ASCVD risk, omega-3 index null)
  - [ ] Gating logic prioritizes safety: contraindication checks BEFORE benefit assessment

- [ ] **If omega-3 data is missing or invalid:**
  - [ ] `shown = false` is returned when no relevant biomarkers available
  - [ ] Omega-3 card is NOT displayed in report
  - [ ] No speculative or placeholder recommendations are shown
  - [ ] No error is thrown (graceful degradation)

- [ ] **Contraindication tier (Tier 0) safety measures verified:**
  - [ ] **RED critical alert** (border-red-200, bg-red-100)
  - [ ] **❌ CONTRAINDICATION label** prominently displayed
  - [ ] **EXPLICIT instruction: "DO NOT RECOMMEND OMEGA-3 SUPPLEMENTATION"**
  - [ ] Reason clearly stated (bleeding disorder OR upcoming surgery)
  - [ ] Bleeding risk explanation present
  - [ ] "Consult your physician" instruction present
  - [ ] No dosing recommendations provided at all
  - [ ] Contraindication check occurs FIRST (overrides all other tiers)

- [ ] **Caution tier (Tier 4) safety measures verified:**
  - [ ] **YELLOW/ORANGE warning alert** (border-yellow-200 or border-orange-200)
  - [ ] **⚠️ CAUTION label** prominently displayed
  - [ ] "PHYSICIAN APPROVAL REQUIRED" explicit warning
  - [ ] Medication interaction explanation (anticoagulants/antiplatelet agents)
  - [ ] Conditional recommendation: "IF physician approves: Low-dose ONLY (≤ 1g)"
  - [ ] Bleeding monitoring instructions present
  - [ ] "Do NOT exceed 1g daily" warning present
  - [ ] Red/orange warning box for medication interactions

- [ ] **Very high triglycerides (≥ 500 mg/dL) prescription referral verified:**
  - [ ] **RED high priority alert** (border-red-200, bg-red-100)
  - [ ] **🔴 HIGH PRIORITY label** prominently displayed
  - [ ] "PRESCRIPTION OMEGA-3 REQUIRED" explicit title
  - [ ] "Schedule physician appointment THIS WEEK" urgent instruction
  - [ ] "Over-the-counter supplements insufficient" explanation
  - [ ] Prescription options mentioned: Vascepa (4g EPA), Lovaza (EPA+DHA)
  - [ ] No recommendation for OTC supplements at this triglyceride level

- [ ] **High triglycerides (200-499 mg/dL) clinical appropriateness verified:**
  - [ ] **RED high priority alert** (border-red-200, bg-red-100)
  - [ ] **🔴 HIGH PRIORITY label** prominently displayed
  - [ ] High-dose recommendation: "2-4g EPA/DHA daily"
  - [ ] Specific targets: "EPA 2-3g, DHA 1-2g"
  - [ ] Quality guidance: "pharmaceutical-grade, third-party tested"
  - [ ] 3-month retest recommendation
  - [ ] Escalation path: "Consider prescription omega-3 if OTC ineffective"

- [ ] **Borderline high triglycerides (150-199 mg/dL) clinical appropriateness verified:**
  - [ ] **ORANGE medium priority alert** (border-orange-200, bg-orange-100)
  - [ ] **🟠 MEDIUM PRIORITY label** prominently displayed
  - [ ] Moderate-dose recommendation: "1-2g EPA/DHA daily"
  - [ ] Specific targets: "EPA 1-1.5g, DHA 0.5-1g"
  - [ ] Dietary emphasis: "2-3 fatty fish servings/week"
  - [ ] 6-month retest recommendation

- [ ] **No database writes occur during Omega-3 computation:**
  - [ ] Shared module (`src/omega3-dynamic.ts`) contains only pure functions
  - [ ] No calls to `env.DB` in Omega-3 logic
  - [ ] Probe endpoint DB guard is active (warns if binding present, never accesses)

- [ ] **No dynamic Omega-3 behavior without explicit flag:**
  - [ ] Feature flag `PREVIEW_DYNAMIC_OMEGA3` (or production equivalent) must be `true`
  - [ ] If flag is `false` or missing, no Omega-3 card is shown
  - [ ] Flag is checked before any Omega-3 computation in main report

- [ ] **Sanity checks for data extraction:**
  - [ ] Triglyceride values validated: must be between 20 and 2000 mg/dL (physiological range)
  - [ ] ASCVD risk values validated: must be between 0.0 and 1.0 (percentage as decimal)
  - [ ] Omega-3 Index values validated: must be between 0% and 20% (physiological range)
  - [ ] Values outside ranges are rejected (treated as null)

---

## 3. Feature Flags & Configuration

- [ ] **Clear feature flag exists for dynamic Omega-3:**
  - [ ] Current preview flag: `PREVIEW_DYNAMIC_OMEGA3 = true` (line ~36 in `src/index.tsx`)
  - [ ] Production flag name decided (e.g., `ENABLE_DYNAMIC_OMEGA3`, `FEATURE_OMEGA3_PERSONALIZATION`)
  - [ ] Flag source determined (environment variable, config file, or feature flag service)

- [ ] **Default for production deployments explicitly documented:**
  - [ ] Production default: `false` (off by default until clinical approval)
  - [ ] Flag must be explicitly enabled after checklist completion

- [ ] **Mechanism to enable Omega-3 in production is documented:**
  - [ ] Environment variable: `ENABLE_DYNAMIC_OMEGA3=true` in Cloudflare Pages settings
  - [ ] OR config file: Update `wrangler.jsonc` or equivalent
  - [ ] OR feature flag service: Toggle in LaunchDarkly/equivalent

- [ ] **Rollback plan exists:**
  - [ ] How to disable quickly: Set `ENABLE_DYNAMIC_OMEGA3=false` in Cloudflare dashboard
  - [ ] Fallback behavior: Omega-3 card does not appear (graceful degradation)
  - [ ] Estimated rollback time: < 5 minutes (environment variable update)
  - [ ] Who has access to disable: Operations team + Technical owner

---

## 4. Testing

### Manual Probe Tests (TESTING_OMEGA3.md)

- [ ] **Test Case 1: Empty body `{}`**
  - [ ] Expected: `success=true, shown=false, triglycerides=null, ascvdRisk=null, omega3Index=null, tier=null, priority=null`
  - [ ] Verified: Card hidden, no data displayed

- [ ] **Test Case 2: Normal (TG 120 mg/dL, low ASCVD risk 5%)**
  - [ ] Input: `{"biomarkers":{"triglycerides":120},"risk":{"ascvdRisk":0.05}}`
  - [ ] Expected: `shown=true, triglycerides=120, ascvdRisk=0.05, tier="dietary_emphasis", priority="MAINTENANCE"`
  - [ ] Verified: ✅ MAINTENANCE label, continue dietary pattern, no urgent supplementation

- [ ] **Test Case 3: Borderline High TG (175 mg/dL)**
  - [ ] Input: `{"biomarkers":{"triglycerides":175}}`
  - [ ] Expected: `shown=true, triglycerides=175, tier="moderate_priority", priority="MEDIUM PRIORITY"`
  - [ ] Verified: 🟠 MEDIUM PRIORITY, 1-2g EPA/DHA daily, 6-month retest

- [ ] **Test Case 4: High TG (350 mg/dL)**
  - [ ] Input: `{"biomarkers":{"triglycerides":350}}`
  - [ ] Expected: `shown=true, triglycerides=350, tier="high_priority", priority="HIGH PRIORITY"`
  - [ ] Verified: 🔴 HIGH PRIORITY, 2-4g EPA/DHA daily, 3-month retest

- [ ] **Test Case 5: Very High TG (550 mg/dL) - Prescription Required**
  - [ ] Input: `{"biomarkers":{"triglycerides":550}}`
  - [ ] Expected: `shown=true, triglycerides=550, tier="high_priority", priority="HIGH PRIORITY"`
  - [ ] Verified: 🔴 HIGH PRIORITY, "PRESCRIPTION OMEGA-3 REQUIRED", Vascepa/Lovaza mentioned, "Schedule physician appointment THIS WEEK"

- [ ] **Test Case 6: High ASCVD Risk + Elevated TG (ASCVD 18%, TG 160 mg/dL)**
  - [ ] Input: `{"biomarkers":{"triglycerides":160},"risk":{"ascvdRisk":0.18}}`
  - [ ] Expected: `shown=true, triglycerides=160, ascvdRisk=0.18, tier="high_priority", priority="HIGH PRIORITY"`
  - [ ] Verified: 🔴 HIGH PRIORITY, cardiovascular risk emphasis, 2-3g EPA/DHA daily

- [ ] **Test Case 7: Contraindicated (Bleeding Disorder)**
  - [ ] Input: `{"biomarkers":{"triglycerides":250},"medicalHistory":{"bleedingDisorder":true}}`
  - [ ] Expected: `shown=true, triglycerides=250, tier="contraindicated", priority="CONTRAINDICATION"`
  - [ ] Verified: ❌ CONTRAINDICATION, "DO NOT RECOMMEND", bleeding risk explanation, no dosing

- [ ] **Test Case 8: Caution (Anticoagulants - Warfarin)**
  - [ ] Input: `{"biomarkers":{"triglycerides":180},"medications":{"anticoagulants":["warfarin"]}}`
  - [ ] Expected: `shown=true, triglycerides=180, tier="caution" or "moderate_priority", priority="CAUTION" or "MEDIUM PRIORITY"`
  - [ ] Verified: ⚠️ CAUTION warning present, "PHYSICIAN APPROVAL REQUIRED", "≤ 1g daily IF approved", bleeding monitoring instructions

- [ ] **Test Case 9: No Recommendation Needed (Omega-3 Index ≥ 8%)**
  - [ ] Input: `{"biomarkers":{"omega3Index":8.5}}`
  - [ ] Expected: `shown=false, omega3Index=8.5, tier="no_recommendation"`
  - [ ] Verified: Card hidden (patient already optimal)

- [ ] **Test Case 10: No Recommendation Needed (Already Supplementing ≥ 2g/day)**
  - [ ] Input: `{"supplements":{"omega3":{"dose":3000,"unit":"mg"}}}`
  - [ ] Expected: `shown=false, tier="no_recommendation"`
  - [ ] Verified: Card hidden (patient already supplementing adequately)

### End-to-End Report Tests

- [ ] **Scenario 1: Omega-3 card HIDDEN (normal TG, low risk, already optimal)**
  - [ ] TG = 110 mg/dL, ASCVD risk = 4%, Omega-3 Index = 9%
  - [ ] Verified: No Omega-3 card appears in report
  - [ ] Biomarker section shows TG in normal range

- [ ] **Scenario 2: Omega-3 card SHOWN with moderate-priority recommendation**
  - [ ] TG = 170 mg/dL, ASCVD risk = 9%, no contraindications
  - [ ] Verified: Card appears with 🟠 MEDIUM PRIORITY, 1-2g EPA/DHA daily
  - [ ] Dietary fish intake recommendations present
  - [ ] 6-month retest recommendation

- [ ] **Scenario 3: Omega-3 card SHOWN with high-priority recommendation**
  - [ ] TG = 320 mg/dL, ASCVD risk = 14%, no contraindications
  - [ ] Verified: Card appears with 🔴 HIGH PRIORITY, 2-4g EPA/DHA daily
  - [ ] Quality supplement guidance present
  - [ ] 3-month retest recommendation
  - [ ] Escalation path mentioned (prescription if OTC ineffective)

- [ ] **Scenario 4: Omega-3 card SHOWN with prescription referral (very high TG)**
  - [ ] TG = 600 mg/dL, ASCVD risk = 20%, no contraindications
  - [ ] Verified: Card appears with 🔴 HIGH PRIORITY, "PRESCRIPTION OMEGA-3 REQUIRED"
  - [ ] "Schedule physician appointment THIS WEEK" instruction
  - [ ] Vascepa/Lovaza mentioned
  - [ ] No OTC supplement recommendations

- [ ] **Scenario 5: Omega-3 card SHOWN with contraindication warning**
  - [ ] TG = 280 mg/dL, bleeding disorder detected
  - [ ] Verified: Card appears with ❌ CONTRAINDICATION, "DO NOT RECOMMEND"
  - [ ] Bleeding risk explanation present
  - [ ] "Consult your physician" instruction
  - [ ] No dosing recommendations

- [ ] **Scenario 6: Omega-3 card SHOWN with caution warning (anticoagulants)**
  - [ ] TG = 190 mg/dL, on warfarin
  - [ ] Verified: Card appears with ⚠️ CAUTION, "PHYSICIAN APPROVAL REQUIRED"
  - [ ] Medication interaction warning present
  - [ ] Conditional recommendation: "IF approved: ≤ 1g daily"
  - [ ] Bleeding monitoring instructions

### Automated Tests

- [ ] **Unit tests for shared Omega-3 helpers exist:**
  - [ ] `extractTriglyceridesFromBiomarkers()` - Tests multiple key variants ('triglycerides', 'tg', 'TG', 'trigs', 'serum_triglycerides')
  - [ ] `extractASCVDRiskFromData()` - Tests nested data structures (risk.ascvdRisk, cardiovascularRisk, ascvd_risk)
  - [ ] `extractOmega3IndexFromBiomarkers()` - Tests key variants ('omega3Index', 'omega_3_index', 'epa_dha_index')
  - [ ] `extractOmega3ContextFromComprehensiveData()` - Tests comprehensive extraction (biomarkers, risk, medications, medicalHistory, dietary, supplements)
  - [ ] `classifyOmega3Status()` - Tests all 6 tier boundaries (contraindicated, high_priority, moderate_priority, dietary_emphasis, caution, no_recommendation)
  - [ ] `generateOmega3CardHTML()` - Tests HTML generation for each tier with correct priority labels and styling
  - [ ] `buildOmega3CardResult()` - Tests complete result object structure

- [ ] **Integration tests for Omega-3 probe endpoint exist:**
  - [ ] Authentication tests (Basic Auth + X-Tenant-ID validation)
  - [ ] Empty body handling (returns success=true, shown=false)
  - [ ] Each tier classification scenario (10 test cases from manual probe tests)
  - [ ] Error handling (invalid JSON, missing auth, invalid tenant)
  - [ ] DB guard verification (no database access occurs)

- [ ] **End-to-end report generation tests exist:**
  - [ ] All 6 report scenarios (hidden, moderate, high, prescription, contraindicated, caution)
  - [ ] Omega-3 card placement verification (after HbA1c card in report)
  - [ ] Feature flag ON/OFF behavior (card appears/disappears correctly)
  - [ ] No regression: Other dynamic cards still work (Vitamin D, HbA1c)

---

## 5. Security & Compliance

- [ ] **No PHI (Protected Health Information) in logs beyond minimal needed:**
  - [ ] Probe logs contain only: tenant_id, tier classification, shown=true/false
  - [ ] No patient names, emails, or identifying information in logs
  - [ ] No full biomarker data in logs (only TG value if needed for debugging)
  - [ ] Fingerprint IDs used for traceability (no PHI)

- [ ] **Authentication and tenant gating unchanged:**
  - [ ] Basic Auth required for probe endpoint (username/password)
  - [ ] X-Tenant-ID header required and validated (demo-a, demo-b, demo-c)
  - [ ] No new authentication mechanisms introduced
  - [ ] Tenant restrictions enforced (probe rejects invalid tenants)

- [ ] **No hard-coded secrets:**
  - [ ] No API keys or credentials in `src/omega3-dynamic.ts`
  - [ ] No passwords or tokens in probe endpoint code
  - [ ] All secrets in `.dev.vars` (local) or environment variables (production)
  - [ ] `.dev.vars` file in `.gitignore` (never committed)

- [ ] **Clinical content aligns with cardiovascular prevention guidelines:**
  - [ ] AHA/ACC 2020 guidelines referenced for triglyceride thresholds
  - [ ] Prescription omega-3 recommendations (Vascepa/Lovaza) align with FDA approvals
  - [ ] Bleeding risk warnings consistent with cardiology literature
  - [ ] Dosing recommendations conservative and evidence-based
  - [ ] All recommendations include physician consultation disclaimers

- [ ] **Disclaimers present:**
  - [ ] "This report is NOT a diagnostic tool. For clinical decision support only."
  - [ ] "Consult your physician before starting any supplementation regimen."
  - [ ] "Do not stop prescription medications without physician guidance."
  - [ ] "Omega-3 supplementation is not a substitute for prescription lipid-lowering medications."

---

## 6. Observability & Logging

- [ ] **Error logging for Omega-3 probe endpoint:**
  - [ ] Authentication failures logged (with tenant_id, no credentials)
  - [ ] Invalid input errors logged (with sanitized input summary)
  - [ ] Classification failures logged (with tier determination details)
  - [ ] HTML generation errors logged (with tier and fingerprint)
  - [ ] Unexpected exceptions logged with stack traces (production mode: sanitized)

- [ ] **Error logging for main report Omega-3 card:**
  - [ ] Data extraction failures logged (missing or invalid biomarkers)
  - [ ] Classification logic errors logged (unexpected tier results)
  - [ ] Card rendering errors logged (HTML generation failures)
  - [ ] Feature flag check failures logged (if flag undefined or invalid)

- [ ] **Recommended metrics for observability:**
  - [ ] **Omega-3 card display rate**: Percentage of reports where Omega-3 card appears
  - [ ] **Tier distribution**: Count of reports by tier (contraindicated, high_priority, moderate_priority, dietary_emphasis, caution, no_recommendation)
  - [ ] **Prescription referral rate**: Percentage of reports triggering TG ≥ 500 mg/dL prescription message
  - [ ] **Contraindication rate**: Percentage of reports showing contraindication warning
  - [ ] **Caution warning rate**: Percentage of reports showing anticoagulant caution warning
  - [ ] **Probe endpoint error rate**: Percentage of probe requests returning error responses
  - [ ] **Response time**: P50, P95, P99 for probe endpoint and main report card generation

- [ ] **Alerting for unexpected error rates:**
  - [ ] Alert if Omega-3 probe error rate > 5% (sustained 5 minutes)
  - [ ] Alert if main report card rendering failure rate > 2% (sustained 5 minutes)
  - [ ] Alert if unexpected tier classification (null when data present) > 1%
  - [ ] Alert if response time P95 > 500ms (performance degradation)

- [ ] **Monitoring dashboard includes:**
  - [ ] Omega-3 card display rate over time (daily/weekly trend)
  - [ ] Tier distribution breakdown (pie chart or bar chart)
  - [ ] Error rate trend (probe + main report)
  - [ ] Response time percentiles (P50, P95, P99)
  - [ ] Contraindication and caution warning rates

---

## 7. Documentation & Training

- [ ] **Technical documentation exists and is current:**
  - [ ] `TESTING_OMEGA3.md` (645 lines, 17KB) - Probe test cases and E2E scenarios
  - [ ] `DOC_OMEGA3_DYNAMIC_PLAN.md` (1,148 lines, 40KB) - Implementation plan and clinical rationale
  - [ ] `src/omega3-dynamic.ts` (766 lines, 31KB) - Shared helper module with inline comments
  - [ ] This checklist: `CHECKLIST_OMEGA3_PRODUCTION.md` - Production readiness requirements

- [ ] **Code documentation is adequate:**
  - [ ] All exported functions in `src/omega3-dynamic.ts` have JSDoc comments
  - [ ] Clinical threshold constants have inline comments explaining rationale
  - [ ] Tier classification logic has comments referencing AHA/ACC guidelines
  - [ ] Probe endpoint has comments explaining authentication, DB guard, error handling

- [ ] **Clinician-facing interpretation guidance documented:**
  - [ ] Explanation of 6-tier system (what each tier means clinically)
  - [ ] When to prescribe vs recommend OTC supplements (TG ≥ 500 vs < 500)
  - [ ] How to interpret Omega-3 Index results (< 4%, 4-8%, ≥ 8%)
  - [ ] When to contraindicate vs caution (bleeding disorder vs anticoagulants)
  - [ ] Expected patient questions and suggested responses

- [ ] **Training materials prepared:**
  - [ ] Overview presentation: "Dynamic Omega-3 Recommendations - Clinical Decision Support"
  - [ ] Demo walkthrough: Show Omega-3 card for each tier (contraindicated, high, moderate, caution)
  - [ ] FAQ document: Common questions about dosing, contraindications, when to prescribe
  - [ ] Quick reference card: Tier thresholds, actions, and retest intervals

- [ ] **At least one training/demo session conducted before production enablement:**
  - [ ] Clinical team trained on interpretation of Omega-3 cards
  - [ ] Operations team trained on feature flag and rollback procedures
  - [ ] Support team trained on patient questions about omega-3 recommendations
  - [ ] Technical team trained on monitoring, alerting, and troubleshooting

---

## 8. Promotion Plan

- [ ] **PR approval requirements documented:**
  - [ ] **Technical owner approval**: Code quality, test coverage, performance verified
  - [ ] **Clinical owner approval**: Thresholds, language, safety warnings reviewed
  - [ ] **Operations owner approval**: Deployment process, rollback plan, monitoring verified
  - [ ] All three approvals required before merging to production branch

- [ ] **Stepwise deployment process defined:**
  - [ ] **Step 1**: Deploy code to production with `ENABLE_DYNAMIC_OMEGA3=false` (off by default)
  - [ ] **Step 2**: Verify deployment successful, no errors in logs
  - [ ] **Step 3**: Enable for single test tenant (e.g., demo-a) for 24 hours
  - [ ] **Step 4**: Monitor metrics (display rate, error rate, response time) for test tenant
  - [ ] **Step 5**: If metrics acceptable, enable for all preview tenants (demo-a, demo-b, demo-c) for 1 week
  - [ ] **Step 6**: If no issues, enable for production tenants (phased rollout: 10% → 50% → 100%)
  - [ ] **Step 7**: Full production enablement after 2 weeks of stable operation

- [ ] **Clear conditions for quick disable defined:**
  - [ ] Error rate > 10% (probe or main report card)
  - [ ] Response time P95 > 1000ms (significant performance degradation)
  - [ ] Clinical concern raised (incorrect recommendations, safety issues)
  - [ ] Patient complaints > 5 in 24 hours (about incorrect Omega-3 advice)
  - [ ] Unexpected tier classifications (many patients in contraindicated when shouldn't be)

- [ ] **Rollback procedure documented and tested:**
  - [ ] Set `ENABLE_DYNAMIC_OMEGA3=false` in Cloudflare Pages environment variables
  - [ ] Verify rollback time < 5 minutes (environment variable propagation)
  - [ ] Verify fallback behavior: Omega-3 card does not appear (no errors thrown)
  - [ ] Verify other dynamic cards unaffected (Vitamin D, HbA1c still work)
  - [ ] Rollback drill conducted in staging environment (verified successful)

---

## 9. Clinical & Regulatory Review

- [ ] **Clinical owner identified and assigned:**
  - [ ] Name: ______________________________
  - [ ] Title: ______________________________
  - [ ] Email: ______________________________
  - [ ] Responsibilities: Validate clinical thresholds, review recommendation language, approve dosing guidance

- [ ] **Clinical thresholds validated:**
  - [ ] Triglyceride thresholds (< 150, 150-199, 200-499, ≥ 500) reviewed and approved
  - [ ] ASCVD risk thresholds (< 7.5%, 7.5-15%, ≥ 15%) reviewed and approved
  - [ ] Omega-3 Index thresholds (< 4%, 4-8%, ≥ 8%) reviewed and approved
  - [ ] Dietary fish intake thresholds (< 2, 2-3, ≥ 4 servings/week) reviewed and approved
  - [ ] Clinical owner confirms: "These thresholds align with AHA/ACC 2020 guidelines."

- [ ] **Recommendation language reviewed:**
  - [ ] **Tier 0 (Contraindicated)**: "DO NOT RECOMMEND" language reviewed and approved
  - [ ] **Tier 1 (High-Priority)**: Prescription referral language (TG ≥ 500) reviewed and approved
  - [ ] **Tier 1 (High-Priority)**: High-dose OTC language (TG 200-499, 2-4g EPA/DHA) reviewed and approved
  - [ ] **Tier 2 (Moderate-Priority)**: Moderate-dose language (1-2g EPA/DHA) reviewed and approved
  - [ ] **Tier 3 (Dietary Emphasis)**: "Continue current pattern" language reviewed and approved
  - [ ] **Tier 4 (Caution)**: "PHYSICIAN APPROVAL REQUIRED" language reviewed and approved
  - [ ] Clinical owner confirms: "All recommendation language is clinically appropriate."

- [ ] **Risk/benefit assessment documented:**
  - [ ] **High-dose (2-4g) vs prescription-only (TG ≥ 500) rationale**: OTC high-dose may be insufficient for very high TG; prescription omega-3 (Vascepa 4g EPA) FDA-approved for TG ≥ 500.
  - [ ] **Bleeding risk with anticoagulants**: Omega-3 may potentiate anticoagulants; caution tier requires physician approval and low-dose only (≤ 1g).
  - [ ] **Contraindication for bleeding disorders**: High-dose omega-3 increases bleeding risk; DO NOT RECOMMEND for patients with hemophilia, von Willebrand, or upcoming surgery.
  - [ ] **Dietary emphasis for normal TG**: Patients with TG < 150 and adequate fish intake do not need supplements; avoid unnecessary supplementation cost.
  - [ ] Clinical owner confirms: "Risk/benefit rationale is sound and evidence-based."

- [ ] **Disclaimers reviewed and approved:**
  - [ ] "This report is NOT a diagnostic tool. For clinical decision support only."
  - [ ] "Consult your physician before starting any supplementation regimen."
  - [ ] "Do not stop prescription medications without physician guidance."
  - [ ] "Omega-3 supplementation is not a substitute for prescription lipid-lowering medications."
  - [ ] Clinical owner confirms: "Disclaimers are adequate and appropriate."

- [ ] **Regulatory compliance assessed:**
  - [ ] No claims that omega-3 "treats" or "cures" cardiovascular disease (FDA compliance)
  - [ ] Prescription omega-3 (Vascepa, Lovaza) mentioned only as "discuss with physician" (not prescribing)
  - [ ] No specific brand recommendations for OTC supplements (avoid commercial bias)
  - [ ] All recommendations framed as "clinical decision support" not "medical advice"
  - [ ] Legal/compliance team consulted if needed

---

## 10. Final Sign-Off

- [ ] **Technical Owner Sign-Off:**
  - [ ] Name: ______________________________
  - [ ] Date: ______________________________
  - [ ] Signature: ______________________________
  - [ ] Confirmation: "All technical requirements met. Code quality, tests, monitoring, and rollback plan verified."

- [ ] **Clinical Owner Sign-Off:**
  - [ ] Name: ______________________________
  - [ ] Date: ______________________________
  - [ ] Signature: ______________________________
  - [ ] Confirmation: "All clinical requirements met. Thresholds, recommendations, and safety warnings reviewed and approved."

- [ ] **Operations Owner Sign-Off:**
  - [ ] Name: ______________________________
  - [ ] Date: ______________________________
  - [ ] Signature: ______________________________
  - [ ] Confirmation: "All operational requirements met. Deployment process, monitoring, and rollback plan verified."

- [ ] **Final Production Enablement Approval:**
  - [ ] All three sign-offs above completed
  - [ ] All checklist items marked complete
  - [ ] Training session conducted
  - [ ] Rollback drill successful
  - [ ] Production deployment scheduled: ______________________________

---

## Notes

- **Review Frequency**: This checklist should be reviewed quarterly or whenever clinical guidelines (AHA/ACC) are updated.
- **Update Guidelines**: If triglyceride or ASCVD risk thresholds change in future guidelines, update Section 1 (Functional Behavior) and Section 9 (Clinical Review).
- **Deprecation Plan**: If dynamic Omega-3 feature is deprecated, set `ENABLE_DYNAMIC_OMEGA3=false` and archive documentation.
- **Related Checklists**: See `CHECKLIST_LDL_PRODUCTION.md`, `CHECKLIST_VITAMIN_D_PRODUCTION.md`, `CHECKLIST_HBA1C_PRODUCTION.md` for similar dynamic feature patterns.
