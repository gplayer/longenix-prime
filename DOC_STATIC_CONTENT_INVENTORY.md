# DOC_STATIC_CONTENT_INVENTORY.md – Static Clinical Content Inventory & Roadmap

**Purpose:** This document identifies static clinical content in the LonGenix-Prime report that should be converted to dynamic, data-gated recommendations.

**Last Updated:** 2025-11-28  
**Status:** Preview analysis only (not a change specification)

---

## Overview

### What This Document Is

This inventory catalogs clinical content in the LonGenix-Prime health report that currently displays the same recommendations to all users, regardless of their individual lab values, risk profiles, medications, or contraindications.

### Static → Dynamic: The LDL Example

**Before (Static):**
- LDL recommendations shown to everyone
- Fixed dosing advice (e.g., "red yeast rice 1200mg daily")
- Same target (<100 mg/dL) regardless of cardiovascular risk
- No gating based on actual LDL values

**After (Dynamic):**
- Card shown ONLY when clinically indicated (LDL > 100 OR ASCVD ≥ 7.5%)
- Dynamic targets based on risk: 70/100/130 mg/dL
- No hard-coded dosing claims
- Personalized based on patient data

**Goal:** Apply this "static → dynamic" pattern to all clinical content areas identified below.

### This Is Analysis Only

This document does NOT specify:
- How to implement the changes
- Exact clinical logic or thresholds
- Timeline or resource allocation

It DOES provide:
- What needs to change
- Why it matters clinically
- Suggested priority order

---

## Inventory of Static Clinical Content

### 1. Vitamin D Optimization

**Report Section:** High Priority Interventions → Optimization Strategies  
**File Path:** `src/index.tsx` lines ~3840-3847  
**Function/Context:** Hard-coded in report template HTML

**Current Behavior:**
```html
<p class="font-medium">Vitamin D Optimization:</p>
<ul class="ml-4 mt-1 text-xs space-y-1">
    <li>• D3 supplementation 4000 IU daily</li>
    <li>• Take with fat-containing meal</li>
    <li>• Retest in 8-12 weeks</li>
    <li>• Consider K2 co-supplementation</li>
</ul>
```

**Type of Staticness:**
- **Hard-coded dosing advice** (4000 IU daily for everyone)
- **Always-on recommendation** (shows regardless of current vitamin D level)
- **Fixed retest interval** (8-12 weeks)

**Inputs Currently Ignored:**
- Actual vitamin D (25-OH D) level (data field exists: `vitaminD`)
- Current supplementation status
- Sun exposure patterns
- Medications affecting vitamin D metabolism (e.g., anticonvulsants, corticosteroids)
- Body weight (dosing should vary by weight)
- Malabsorption conditions

**Why This Should Be Dynamic:**
- **Clinical Risk:** Dosing 4000 IU daily to someone already at 80 ng/mL risks hypervitaminosis D
- **Missed Opportunity:** Someone at 15 ng/mL needs more aggressive dosing (possibly 5000-10000 IU)
- **Professional Credibility:** Clinicians expect recommendations based on actual lab values

**Preview vs Production:** Currently in preview; would be visible in production reports

**Priority Assessment:**
- **Clinical Impact:** HIGH (dosing advice could be harmful if levels already optimal/high)
- **Visibility:** HIGH (prominent in "Optimization Strategies" section)
- **Implementation Effort:** MEDIUM (similar to LDL pattern; need thresholds for deficiency levels)

**Suggested Dynamic Logic (Illustrative):**
- Vitamin D < 20 ng/mL → 5000-10000 IU daily, retest 6-8 weeks
- 20-30 ng/mL → 4000 IU daily, retest 8-12 weeks
- 30-50 ng/mL → 2000 IU daily maintenance
- 50-80 ng/mL → Maintenance dose, monitor
- > 80 ng/mL → Hold supplementation, recheck in 3 months

---

### 2. Omega-3 Supplementation

**Report Section:** 30-Day Priority Action Plan → Week 3-4  
**File Path:** `src/index.tsx` lines ~3999  
**Function/Context:** Hard-coded in action plan

**Current Behavior:**
```html
<span>Add omega-3 supplementation (2-3g EPA/DHA daily)</span>
```

**Type of Staticness:**
- **Fixed dosing recommendation** (2-3g for everyone)
- **Always-on in action plan**
- **No contraindication checking**

**Inputs Currently Ignored:**
- Triglyceride levels (high TG might warrant higher omega-3 dose)
- Existing omega-3 supplementation
- Dietary fish intake
- Bleeding risk factors
- Anticoagulant medications (warfarin, aspirin, etc.)
- Allergy to fish/seafood

**Why This Should Be Dynamic:**
- **Clinical Risk:** Omega-3 at high doses increases bleeding risk (especially with anticoagulants)
- **Personalization:** Dosing should vary based on cardiovascular risk and current TG levels
- **Cost-Effectiveness:** Someone eating salmon 3x/week may not need supplementation

**Preview vs Production:** Currently in preview

**Priority Assessment:**
- **Clinical Impact:** MEDIUM-HIGH (bleeding risk with anticoagulants; inappropriate for some patients)
- **Visibility:** MEDIUM (in action plan, not main recommendations)
- **Implementation Effort:** MEDIUM (need medication checking + lab-based dosing)

---

### 3. 30-Day Action Plan (Entire Section)

**Report Section:** 30-Day Priority Action Plan  
**File Path:** `src/index.tsx` lines ~3967-4016  
**Function/Context:** Static action plan template

**Current Behavior:**
- **Week 1-2 Foundation:** Always includes Vitamin D, meditation, fiber, LDL consultation
- **Week 3-4 Integration:** Always includes omega-3, stress reduction, lipid panel, sleep

**Type of Staticness:**
- **Template-based plan** (same 8 items for everyone)
- **No prioritization based on patient data**
- **Fixed timeline** (everyone gets same 4-week plan)

**Inputs Currently Ignored:**
- Patient's actual top 3 risk factors
- Current medications and supplements
- Lifestyle data (already meditating? already eating high-fiber?)
- Labs that are already optimal vs. those that need urgent attention

**Why This Should Be Dynamic:**
- **Clinical Risk:** Generic plans are less effective than personalized ones
- **Patient Engagement:** Patients may ignore plan if it recommends things they're already doing
- **Efficiency:** Should prioritize highest-impact items for THIS patient

**Preview vs Production:** Currently in preview

**Priority Assessment:**
- **Clinical Impact:** MEDIUM (generic plan is less effective but not harmful)
- **Visibility:** HIGH (dedicated section near end of report)
- **Implementation Effort:** HIGH (requires prioritization algorithm across all risk factors)

---

### 4. Stress Management Card

**Report Section:** Lifestyle Optimization → Stress Management  
**File Path:** `src/index.tsx` lines ~3859-3874  
**Function/Context:** Hard-coded scores in lifestyle section

**Current Behavior:**
```html
<h4>Stress Management</h4>
<div>Current Score: 65/100</div>
<div>Target Score: 85/100</div>
<p>Implementation of daily mindfulness practices and stress reduction techniques needed.</p>
```

**Type of Staticness:**
- **Hard-coded scores** (65/100 current, 85/100 target for everyone)
- **Generic advice**
- **No assessment data used**

**Inputs Currently Ignored:**
- Stress questionnaire responses (if collected)
- Cortisol levels (if measured)
- Sleep quality data
- Mental health assessment scores
- Current stress management practices

**Why This Should Be Dynamic:**
- **Clinical Risk:** Low (mostly informational)
- **Credibility:** Showing fake scores damages trust
- **Missed Opportunity:** Could provide personalized stress reduction strategies

**Preview vs Production:** Currently in preview

**Priority Assessment:**
- **Clinical Impact:** LOW (informational, not prescriptive)
- **Visibility:** MEDIUM (visible but not prominent)
- **Implementation Effort:** LOW (just remove hard-coded scores or gate by data availability)

---

### 5. Social Connection Card

**Report Section:** Lifestyle Optimization → Social Connection  
**File Path:** `src/index.tsx` lines ~3876-3891  
**Function/Context:** Hard-coded scores in lifestyle section

**Current Behavior:**
```html
<h4>Social Connection</h4>
<div>Current Score: Moderate</div>
<div>Target Score: Strong</div>
<p>Strengthen social networks and community engagement for longevity benefits.</p>
```

**Type of Staticness:**
- **Hard-coded assessment** ("Moderate" for everyone)
- **Generic advice**

**Inputs Currently Ignored:**
- Actual social connection assessment data
- Loneliness/isolation questionnaires
- Support network information

**Why This Should Be Dynamic:**
- **Clinical Risk:** LOW (advisory only)
- **Data Quality:** Showing fake data undermines credibility

**Preview vs Production:** Currently in preview

**Priority Assessment:**
- **Clinical Impact:** LOW
- **Visibility:** MEDIUM
- **Implementation Effort:** LOW (gate by data availability)

---

### 6. Environmental Factors Card (EMF, Air Quality)

**Report Section:** Lifestyle Optimization → Environmental  
**File Path:** `src/index.tsx` lines ~3893-3908  
**Function/Context:** Hard-coded environmental assessments

**Current Behavior:**
```html
<h4>Environmental</h4>
<div>EMF Exposure: Moderate</div>
<div>Air Quality: Good</div>
<p>Consider EMF reduction strategies and air purification systems.</p>
```

**Type of Staticness:**
- **Hard-coded environmental data**
- **Generic recommendations**

**Inputs Currently Ignored:**
- Actual environmental questionnaire data
- Location-based air quality data
- Occupational exposures

**Why This Should Be Dynamic:**
- **Clinical Risk:** LOW
- **Actionability:** Generic advice has low utility

**Preview vs Production:** Currently in preview

**Priority Assessment:**
- **Clinical Impact:** LOW
- **Visibility:** MEDIUM
- **Implementation Effort:** MEDIUM (requires external data sources for air quality)

---

### 7. Cognitive Decline Recommendations

**Report Section:** High Priority Interventions  
**File Path:** `src/index.tsx` lines ~3612-3648  
**Function/Context:** Static cognitive health card

**Current Behavior:**
- Hard-coded cognitive decline recommendations
- Fixed supplement suggestions (curcumin, vitamin D, etc.)
- No gating based on cognitive assessment or risk factors

**Type of Staticness:**
- **Always-on card** (shown to everyone)
- **Generic supplement list**

**Inputs Currently Ignored:**
- Cognitive assessment scores
- Cognitive decline risk calculation (exists in `DiseaseRiskCalculator`)
- Family history of dementia
- ApoE genotype (if available)
- Current cognitive medications

**Why This Should Be Dynamic:**
- **Clinical Risk:** MEDIUM (suggesting cognitive supplements to someone with no risk may cause anxiety)
- **Personalization:** Should prioritize based on actual risk

**Preview vs Production:** Currently in preview

**Priority Assessment:**
- **Clinical Impact:** MEDIUM
- **Visibility:** HIGH (in "High Priority" section)
- **Implementation Effort:** MEDIUM (risk calculation exists, needs gating logic)

---

### 8. Sleep Optimization Card

**Report Section:** Medium Priority Optimizations  
**File Path:** `src/index.tsx` lines ~3676-3688  
**Function/Context:** Static sleep recommendations

**Current Behavior:**
```html
<h4>Sleep Optimization</h4>
<ul>
    <li>• Maintain consistent sleep/wake schedule</li>
    <li>• Optimize sleep environment (temperature, darkness)</li>
    <li>• Consider magnesium supplementation</li>
</ul>
```

**Type of Staticness:**
- **Generic advice** (same for everyone)
- **No dosing for magnesium**

**Inputs Currently Ignored:**
- Sleep hours data (field exists: `sleepHours`)
- Sleep quality assessment (field exists: `sleepQuality`)
- Sleep disorders (apnea, insomnia)
- Current sleep medications

**Why This Should Be Dynamic:**
- **Clinical Risk:** LOW (generic advice is safe)
- **Effectiveness:** Personalized sleep recommendations based on data would be more actionable

**Preview vs Production:** Currently in preview

**Priority Assessment:**
- **Clinical Impact:** LOW-MEDIUM
- **Visibility:** MEDIUM
- **Implementation Effort:** LOW (sleep data already collected, just needs conditional rendering)

---

### 9. Exercise Recommendations

**Report Section:** Medium Priority Optimizations  
**File Path:** `src/index.tsx` lines ~3676-3688  
**Function/Context:** Static exercise frequency recommendations

**Current Behavior:**
```html
<li>• Fasting protocol: 2x per week, 20-30 minutes (metabolic flexibility)</li>
```

**Type of Staticness:**
- **Fixed frequency recommendation**
- **No personalization**

**Inputs Currently Ignored:**
- Current exercise frequency (field exists: `exerciseFrequency`)
- Exercise minutes (field exists: `exerciseMinutes`)
- Exercise types (field exists: `exerciseTypes`)
- Cardiovascular fitness level
- Metabolic risk factors

**Why This Should Be Dynamic:**
- **Clinical Risk:** LOW (exercise is generally safe)
- **Effectiveness:** Should recommend INCREASE if sedentary, MAINTAIN if already optimal

**Preview vs Production:** Currently in preview

**Priority Assessment:**
- **Clinical Impact:** LOW
- **Visibility:** MEDIUM
- **Implementation Effort:** LOW (data already collected)

---

### 10. LDL Cholesterol Optimization (Already Dynamic)

**Report Section:** High Priority Interventions / Optimization Strategies  
**File Path:** `src/index.tsx` (uses `src/ldl-dynamic.ts`)  
**Function/Context:** Dynamic LDL card (Fix Pack #1)

**Current Behavior:**
- ✅ **Data-gated:** Shows only if LDL > 100 OR ASCVD ≥ 7.5%
- ✅ **Dynamic targets:** 70/100/130 mg/dL based on ASCVD risk
- ✅ **No dosing claims**
- ✅ **Personalized based on patient data**

**Status:** **COMPLETED** (this is the reference implementation)

**Priority Assessment:**
- **Clinical Impact:** HIGH
- **Visibility:** HIGH
- **Implementation Effort:** MEDIUM (already completed)

**Reference for Future Work:** See `src/ldl-dynamic.ts` for pattern to follow

---

### 11. HbA1c / Glucose Management

**Report Section:** Not currently implemented as dedicated card  
**File Path:** Data collected but no dynamic recommendations  
**Function/Context:** Labs collected (`glucose`, `hba1c`, `insulin`) but not used for recommendations

**Current Behavior:**
- Labs displayed in biomarker table
- No dynamic recommendations based on glucose/HbA1c values
- Diabetes risk calculated but not prominently featured

**Type of Staticness:**
- **Missing dynamic content** (should exist but doesn't)

**Inputs Available But Not Used:**
- Fasting glucose (field: `glucose`)
- HbA1c (field: `hba1c`)
- Fasting insulin (field: `insulin`)
- Diabetes risk (calculated by `DiseaseRiskCalculator.calculateDiabetesRisk()`)

**Why This Should Be Dynamic:**
- **Clinical Risk:** HIGH (pre-diabetes and diabetes are common and serious)
- **Missing Opportunity:** Major health issue not addressed in recommendations

**Preview vs Production:** Currently in preview

**Priority Assessment:**
- **Clinical Impact:** HIGH (diabetes/pre-diabetes is major health concern)
- **Visibility:** Currently ZERO (missing)
- **Implementation Effort:** MEDIUM (risk calculation exists, need recommendation card)

---

### 12. Blood Pressure / Hypertension Management

**Report Section:** Not currently implemented  
**File Path:** Data not collected  
**Function/Context:** No blood pressure data or recommendations

**Current Behavior:**
- No blood pressure fields in assessment
- No hypertension recommendations
- Cardiovascular risk mentions family history but not BP

**Type of Staticness:**
- **Missing data and content**

**Inputs Not Collected:**
- Systolic blood pressure
- Diastolic blood pressure
- Hypertension diagnosis
- Blood pressure medications

**Why This Should Be Dynamic:**
- **Clinical Risk:** HIGH (hypertension is "silent killer")
- **Standard of Care:** Blood pressure is basic vital sign in any health assessment

**Preview vs Production:** Missing in both

**Priority Assessment:**
- **Clinical Impact:** HIGH
- **Visibility:** Currently ZERO (missing)
- **Implementation Effort:** HIGH (requires data collection + recommendations)

---

### 13. CoQ10 and Statin Interactions

**Report Section:** Longevity Optimization  
**File Path:** `src/index.tsx` line ~3947  
**Function/Context:** Generic supplement mention

**Current Behavior:**
```html
<li>• CoQ10 supplementation consideration</li>
```

**Type of Staticness:**
- **Generic mention** (no context)
- **No dosing**
- **No indication**

**Inputs Currently Ignored:**
- Statin use (CoQ10 depleted by statins)
- Mitochondrial dysfunction markers
- Fatigue symptoms
- Cardiovascular risk

**Why This Should Be Dynamic:**
- **Clinical Risk:** MEDIUM (CoQ10 is important for statin users but not needed by everyone)
- **Specificity:** Should ONLY recommend for statin users or mitochondrial dysfunction

**Preview vs Production:** Currently in preview

**Priority Assessment:**
- **Clinical Impact:** MEDIUM
- **Visibility:** LOW (buried in longevity section)
- **Implementation Effort:** LOW (check medications for statins)

---

### 14. Curcumin Supplementation

**Report Section:** Lifestyle Recommendations  
**File Path:** `src/index.tsx` line ~2988  
**Function/Context:** Generic supplement mention

**Current Behavior:**
```html
<li>• Consider curcumin supplementation</li>
```

**Type of Staticness:**
- **Generic recommendation**
- **No indication or dosing**

**Inputs Currently Ignored:**
- Inflammatory markers (CRP, ESR)
- Arthritis or joint pain
- Cardiovascular risk
- Drug interactions (anticoagulants)

**Why This Should Be Dynamic:**
- **Clinical Risk:** MEDIUM (curcumin has blood-thinning effects)
- **Targeting:** Should be based on inflammation markers or conditions

**Preview vs Production:** Currently in preview

**Priority Assessment:**
- **Clinical Impact:** MEDIUM
- **Visibility:** LOW
- **Implementation Effort:** MEDIUM (needs inflammatory marker gating + contraindication check)

---

### 15. Magnesium Supplementation

**Report Section:** Sleep Optimization  
**File Path:** `src/index.tsx` (within sleep recommendations)  
**Function/Context:** Generic mention without context

**Current Behavior:**
```html
<li>• Consider magnesium supplementation</li>
```

**Type of Staticness:**
- **Generic mention**
- **No dosing or form specified**

**Inputs Currently Ignored:**
- Magnesium level (if measured)
- Sleep quality scores
- Muscle cramps/spasms
- Kidney function (magnesium contraindicated in renal insufficiency)

**Why This Should Be Dynamic:**
- **Clinical Risk:** MEDIUM (can cause diarrhea; contraindicated in kidney disease)
- **Personalization:** Dosing and form should depend on indication

**Preview vs Production:** Currently in preview

**Priority Assessment:**
- **Clinical Impact:** LOW-MEDIUM
- **Visibility:** LOW
- **Implementation Effort:** LOW (gate by sleep quality + kidney function check)

---

## Priority Assessment Summary

### Phase 1: Must-Fix Before Initial Commercial Launch

**HIGH Clinical Impact + HIGH Visibility:**

1. **✅ LDL Cholesterol (COMPLETED)** - Dynamic Fix Pack #1 already implemented
2. **Vitamin D Optimization** - Hard-coded dosing could be harmful
3. **HbA1c / Glucose Management** - Missing entirely despite being major health concern
4. **Omega-3 Supplementation** - Dosing advice with bleeding risk

**Rationale:** These items have the highest risk of clinical harm (inappropriate dosing, missed diagnoses) and are prominently displayed. Clinicians will immediately notice and question these.

---

### Phase 2: Important, Ship Soon After Launch

**MEDIUM Clinical Impact + MEDIUM-HIGH Visibility:**

5. **Cognitive Decline Recommendations** - Should be gated by risk calculation
6. **30-Day Action Plan** - Generic plan reduces effectiveness and engagement
7. **Blood Pressure Management** - Standard of care, currently missing
8. **CoQ10 Recommendations** - Important for statin users

**Rationale:** These improve clinical quality and personalization significantly but are less likely to cause harm if left static temporarily.

---

### Phase 3: Nice-to-Have / Later

**LOW Clinical Impact or LOW Visibility:**

9. **Sleep Optimization** - Safe but could be more personalized
10. **Exercise Recommendations** - Already collecting data, easy to personalize
11. **Stress Management Card** - Remove hard-coded scores or gate
12. **Social Connection Card** - Remove hard-coded scores or gate
13. **Environmental Factors** - Requires external data integration
14. **Curcumin Supplementation** - Low visibility mention
15. **Magnesium Supplementation** - Low visibility mention

**Rationale:** These are lower risk and less visible. Can be addressed incrementally after launch.

---

## Priority Matrix

| Item | Clinical Impact | Visibility | Implementation Effort | Phase |
|------|----------------|------------|----------------------|-------|
| LDL Cholesterol | HIGH | HIGH | MEDIUM | **Phase 1 (✅ DONE)** |
| Vitamin D | HIGH | HIGH | MEDIUM | **Phase 1** |
| HbA1c/Glucose | HIGH | ZERO (missing) | MEDIUM | **Phase 1** |
| Omega-3 | MEDIUM-HIGH | MEDIUM | MEDIUM | **Phase 1** |
| Cognitive Decline | MEDIUM | HIGH | MEDIUM | **Phase 2** |
| 30-Day Action Plan | MEDIUM | HIGH | HIGH | **Phase 2** |
| Blood Pressure | HIGH | ZERO (missing) | HIGH | **Phase 2** |
| CoQ10 | MEDIUM | LOW | LOW | **Phase 2** |
| Sleep | LOW-MEDIUM | MEDIUM | LOW | **Phase 3** |
| Exercise | LOW | MEDIUM | LOW | **Phase 3** |
| Stress Management | LOW | MEDIUM | LOW | **Phase 3** |
| Social Connection | LOW | MEDIUM | LOW | **Phase 3** |
| Environmental | LOW | MEDIUM | MEDIUM | **Phase 3** |
| Curcumin | MEDIUM | LOW | MEDIUM | **Phase 3** |
| Magnesium | LOW-MEDIUM | LOW | LOW | **Phase 3** |

---

## Notable Examples: Deep Dive

### Example 1: Vitamin D Optimization (Phase 1)

**Location:**
- File: `src/index.tsx` lines ~3840-3847
- Section: High Priority Interventions → Optimization Strategies
- Function: Hard-coded in report HTML template

**Current Behavior:**
```html
<div>
    <p class="font-medium">Vitamin D Optimization:</p>
    <ul class="ml-4 mt-1 text-xs space-y-1">
        <li>• D3 supplementation 4000 IU daily</li>
        <li>• Take with fat-containing meal</li>
        <li>• Retest in 8-12 weeks</li>
        <li>• Consider K2 co-supplementation</li>
    </ul>
</div>
```

**What's Wrong:**
1. **Universal Dosing:** 4000 IU recommended to everyone regardless of:
   - Current vitamin D level (may be 12 ng/mL or 75 ng/mL)
   - Body weight (heavier patients need more)
   - Malabsorption issues
   - Current supplementation
   
2. **Clinical Risks:**
   - **Over-supplementation:** Patient at 80 ng/mL gets 4000 IU → risk of toxicity
   - **Under-supplementation:** Patient at 12 ng/mL needs 10,000 IU for deficiency
   - **Inappropriate for optimal patients:** Wastes money and time

3. **Professional Credibility:**
   - Clinicians expect recommendations based on actual values
   - Shows "4000 IU" next to lab showing 65 ng/mL → looks careless

**Data Already Available:**
- `assessmentData.vitaminD` (field exists for 25-OH D level)
- Unit: ng/mL
- Reference range: 30-100 ng/mL (listed in biomarker reference)

**Why It Should Be Dynamic:**

**Severe Deficiency (< 20 ng/mL):**
- Show: HIGH PRIORITY card
- Recommendation: 5000-10,000 IU daily (consider loading dose)
- Retest: 6-8 weeks
- Additional: Check for malabsorption, add K2

**Insufficiency (20-30 ng/mL):**
- Show: MEDIUM PRIORITY card
- Recommendation: 4000-5000 IU daily
- Retest: 8-12 weeks
- Additional: Dietary sources, sun exposure

**Low-Normal (30-50 ng/mL):**
- Show: MAINTENANCE card
- Recommendation: 2000-3000 IU daily
- Retest: 3-6 months

**Optimal (50-80 ng/mL):**
- Show: MAINTENANCE card
- Recommendation: 1000-2000 IU maintenance
- Monitor: Annual recheck

**High (> 80 ng/mL):**
- Show: CAUTION card
- Recommendation: HOLD supplementation
- Retest: 3 months
- Warning: Risk of toxicity

**Missing (no vitamin D data):**
- Show: GENERIC card
- Recommendation: "Check vitamin D level (25-OH D) before supplementing"
- No dosing advice

**Implementation Pattern:** Follow `src/ldl-dynamic.ts` approach:
1. Create `src/vitaminD-dynamic.ts` with pure functions
2. `extractVitaminDLevel(biomarkers): number | null`
3. `computeVitaminDRecommendation(level): { shown, priority, dosing, retest, html }`
4. Gate card by data availability and clinical thresholds

---

### Example 2: HbA1c / Glucose Management (Phase 1)

**Location:**
- Currently MISSING dedicated recommendation card
- Data fields exist but unused for recommendations
- Diabetes risk calculated but not prominently displayed

**Data Already Available:**
- `assessmentData.glucose` (fasting glucose, mg/dL)
- `assessmentData.hba1c` (HbA1c, %)
- `assessmentData.insulin` (fasting insulin, μU/mL)
- `DiseaseRiskCalculator.calculateDiabetesRisk()` (already implemented)

**Why This Is Critical:**
- **High Prevalence:** Diabetes/pre-diabetes affects ~50% of US adults
- **Major Health Impact:** Leading cause of cardiovascular disease, kidney failure, blindness
- **Actionable:** Lifestyle and medication interventions highly effective
- **Standard of Care:** Every health assessment should address glucose control

**What Should Be Dynamic:**

**Diabetes (HbA1c ≥ 6.5% or Glucose ≥ 126 mg/dL):**
- Show: HIGH PRIORITY card (red border)
- Message: "Diabetes range - immediate clinical follow-up required"
- Actions:
  - Urgent physician referral for diabetes management
  - Consider continuous glucose monitor
  - Dietary counseling (low glycemic index)
  - Exercise prescription
- No self-management advice (needs physician)

**Pre-Diabetes (HbA1c 5.7-6.4% or Glucose 100-125 mg/dL):**
- Show: HIGH PRIORITY card (orange border)
- Message: "Pre-diabetes - high risk of progression"
- Recommendations:
  - Weight loss if BMI > 25 (7-10% target)
  - 150 minutes/week moderate exercise
  - Low glycemic diet
  - Consider metformin (discuss with physician)
  - Retest HbA1c in 3 months

**Optimal (HbA1c < 5.7% and Glucose < 100 mg/dL):**
- Show: MAINTENANCE card (green border)
- Message: "Excellent glucose control"
- Recommendations:
  - Maintain current lifestyle
  - Annual recheck
  - Continue healthy diet and exercise

**Missing Data:**
- Show: DATA COLLECTION card
- Message: "Glucose and HbA1c testing recommended"
- Next steps: Order fasting glucose and HbA1c

**Implementation:** Create `src/glucose-dynamic.ts` similar to LDL pattern

---

### Example 3: 30-Day Action Plan (Phase 2)

**Location:**
- File: `src/index.tsx` lines ~3967-4016
- Section: 30-Day Priority Action Plan
- Function: Static template in report HTML

**Current Behavior:**
Everyone gets the same 8-item plan:

**Week 1-2:**
1. Start Vitamin D3 (4000 IU)
2. Begin meditation (10 min)
3. Increase fiber
4. Schedule LDL consultation

**Week 3-4:**
5. Add omega-3 (2-3g)
6. Stress reduction
7. Order lipid panel
8. Sleep routine

**What's Wrong:**
- **No Personalization:** Same plan regardless of:
  - Top 3 risk factors
  - Current habits
  - Labs that need attention
  - Medications
  
- **Wasted Effort:** May recommend things patient is already doing
- **Missed Priorities:** May ignore patient's biggest health issue

**What Should Be Dynamic:**

**Personalized Plan Algorithm:**
1. Identify top 3 modifiable risk factors from assessment:
   - Highest risk scores (diabetes, cardiovascular, etc.)
   - Worst lab values (LDL, HbA1c, vitamin D, etc.)
   - Lifestyle gaps (sedentary, poor sleep, etc.)

2. For each risk factor, identify evidence-based interventions:
   - High HbA1c → low glycemic diet + exercise + weight loss
   - High LDL → fiber + plant sterols + physician consult
   - Low vitamin D → supplementation at appropriate dose
   - Poor sleep → sleep hygiene + magnesium + screen time reduction

3. Prioritize by:
   - **Urgency:** Diabetes range > pre-diabetes > optimal
   - **Impact:** Interventions with strongest evidence
   - **Feasibility:** Start with easiest changes

4. Generate 4-week plan:
   - **Week 1-2:** 2-3 highest priority items (Foundation)
   - **Week 3-4:** 2-3 next priority items (Integration)

**Example Personalized Plans:**

**Patient A:** High HbA1c (6.2%), high LDL (145), sedentary
- Week 1-2: Low glycemic diet, 30-min walks 5x/week, fiber increase
- Week 3-4: Plant sterols, physician visit, blood work recheck

**Patient B:** Low vitamin D (18 ng/mL), poor sleep (5 hrs), high stress
- Week 1-2: Vitamin D 5000 IU, sleep hygiene (7+ hrs), stress assessment
- Week 3-4: Magnesium, meditation app, sleep tracker

**Implementation:** HIGH effort - requires prioritization algorithm across all risk factors

---

## Implementation Pattern (Based on LDL Success)

For each static item above, follow this pattern (established by LDL work):

### 1. Create Shared Helper Module
- Example: `src/vitaminD-dynamic.ts`, `src/glucose-dynamic.ts`
- Pure functions for extraction, computation, gating, HTML generation
- Export constants for thresholds

### 2. Extraction Functions
```typescript
extractVitaminDLevel(biomarkers: any): number | null
extractGlucose(labs: any): number | null
extractHbA1c(labs: any): number | null
```

### 3. Computation Functions
```typescript
computeVitaminDRecommendation(level: number | null): RecommendationResult
computeGlucoseRisk(glucose, hba1c): DiabetesRiskResult
```

### 4. Gating Logic
```typescript
shouldShowVitaminDCard(level): boolean
// Show if: level < 30 OR level > 80 OR level is null (missing)
```

### 5. HTML Generation
```typescript
generateVitaminDCardHTML(level, recommendation): string
```

### 6. Main Function
```typescript
buildVitaminDCardResult(level): { shown, priority, dosing, retest, html }
```

### 7. Integration Points
- **Probe Endpoint:** Create `POST /api/report/preview/vitaminD` for testing
- **Main Report:** Replace static HTML with dynamic card call

### 8. Testing Documentation
- Create `TESTING_VITAMIN_D.md` with test scenarios
- Document expected outputs for each vitamin D level range

### 9. Feature Flag
- Add `PREVIEW_DYNAMIC_VITAMIN_D` flag (default: true in preview)
- Production flag: `ENABLE_DYNAMIC_VITAMIN_D` (default: false)

---

## Related Documentation & Modules

### Completed Work (LDL)
- **`AGENT_CONTROL_LGX_PREVIEW.md`** - Agent guardrails for preview work
- **`DOC_LDL_IMPLEMENTATION.md`** - Complete implementation guide for dynamic LDL
- **`src/ldl-dynamic.ts`** - Shared LDL helper module (REFERENCE PATTERN)
- **`TESTING_LDL.md`** - Probe endpoint test guide
- **`TESTING_DYNAMIC_LDL_PROBE.md`** - Comprehensive probe validation
- **`TESTING_DYNAMIC_LDL.md`** - End-to-end report testing
- **`CHECKLIST_LDL_PRODUCTION.md`** - Production readiness checklist

### How to Use These Documents

**For Each New Dynamic Feature:**

1. **Reference Pattern:** `src/ldl-dynamic.ts`
   - Copy structure: extraction → computation → gating → HTML → main function
   - Use same naming conventions
   - Export constants for transparency

2. **Testing Pattern:** `TESTING_LDL.md`
   - Create probe endpoint for validation
   - Document 4+ test scenarios
   - Include PowerShell and curl examples

3. **Implementation Guide:** `DOC_LDL_IMPLEMENTATION.md`
   - Document how it works
   - File locations and line numbers
   - Data sources and gating logic

4. **Production Checklist:** `CHECKLIST_LDL_PRODUCTION.md`
   - Copy and adapt for new feature
   - Clinical validation required
   - Sign-off process

5. **Preview Guardrails:** `AGENT_CONTROL_LGX_PREVIEW.md`
   - Follow preview-only rules
   - Feature flag pattern
   - Testing documentation requirements

---

## Summary Statistics

**Total Static Items Identified:** 15

**Phase 1 (Must-Fix Before Launch):** 4 items
1. ✅ LDL Cholesterol (COMPLETED)
2. Vitamin D Optimization
3. HbA1c / Glucose Management
4. Omega-3 Supplementation

**Phase 2 (Ship Soon After Launch):** 4 items
5. Cognitive Decline Recommendations
6. 30-Day Action Plan
7. Blood Pressure Management
8. CoQ10 Recommendations

**Phase 3 (Nice-to-Have / Later):** 7 items
9-15. Sleep, Exercise, Stress, Social, Environmental, Curcumin, Magnesium

**Clinical Impact Breakdown:**
- **HIGH Impact:** 4 items (LDL, Vitamin D, HbA1c, Blood Pressure)
- **MEDIUM Impact:** 7 items
- **LOW Impact:** 4 items

**Visibility Breakdown:**
- **HIGH Visibility:** 5 items
- **MEDIUM Visibility:** 8 items
- **LOW Visibility:** 2 items

---

## Next Steps

1. **Review this inventory** with technical and clinical stakeholders
2. **Prioritize Phase 1 items** for immediate work (after LDL completion)
3. **Create feature specs** for Vitamin D and HbA1c/Glucose (next highest priority)
4. **Follow LDL pattern** for implementation (shared modules, probe endpoints, testing docs)
5. **Update this document** as items are completed or priorities change

---

**Last Updated:** 2025-11-28  
**Document Owner:** Technical Lead / Clinical Lead  
**Review Frequency:** Monthly during active development; quarterly after launch
