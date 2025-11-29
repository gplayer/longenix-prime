# DOC_OMEGA3_DYNAMIC_PLAN.md – Dynamic Omega-3 Implementation Plan

**Fix Pack**: #4 – Omega-3 / EPA+DHA Supplementation  
**Status**: Planning Only (Documentation)  
**Date**: 2025-11-29  
**Priority**: Phase 1 (High Clinical Impact)

---

## Executive Summary

This document outlines the plan to convert **static, universal Omega-3 recommendations** into a **dynamic, data-gated, personalized system** that adjusts EPA/DHA dosing based on:
- Cardiovascular risk markers (LDL, triglycerides, ASCVD risk)
- Existing dietary omega-3 intake (fatty fish consumption)
- Contraindication factors (bleeding risk, anticoagulants)

**Clinical Rationale**: Current "2-3g EPA/DHA daily for everyone" approach:
- Ignores individual cardiovascular risk (high-risk patients may need more)
- Ignores dietary intake (someone eating salmon 3x/week may not need supplements)
- Misses contraindications (bleeding risk with anticoagulants like warfarin)
- Wastes cost for patients with adequate dietary intake

**Pattern**: Follows proven LDL, Vitamin D, and HbA1c dynamic implementation patterns.

---

## 1. Current State (Static Behavior)

### 1.1 Location in Report

**Primary Locations:**

1. **30-Day Action Plan → Week 3-4 Integration**
   - **File**: `src/index.tsx`
   - **Lines**: ~4839
   - **Context**: Static action plan template
   - **Current HTML**:
     ```html
     <span>Add omega-3 supplementation (2-3g EPA/DHA daily)</span>
     ```

2. **High Priority Interventions → LDL Management**
   - **File**: `src/index.tsx`
   - **Lines**: ~4451
   - **Context**: Static LDL reduction recommendations
   - **Current HTML**:
     ```html
     <li>• Omega-3 EPA/DHA (2-3g daily)</li>
     ```

3. **Lifestyle Optimization Mentions**
   - **File**: `src/index.tsx`
   - **Lines**: ~3684, ~3834, ~4345, ~4616, ~4774
   - **Context**: Various lifestyle and dietary recommendations
   - **Current Text**: Generic mentions of "omega-3 rich foods" or "omega-3 optimization"

### 1.2 Static Behavior Description

**What's Currently Shown:**
- **Universal dosing**: "2-3g EPA/DHA daily" for ALL patients
- **Always-on**: Appears in action plan for everyone
- **No personalization**: Same recommendation regardless of:
  - Triglyceride levels (normal vs elevated)
  - Dietary fish intake (already eating salmon 3x/week vs never)
  - Cardiovascular risk level (low risk vs high ASCVD risk)
  - Existing omega-3 supplementation
  - Contraindications (bleeding risk, anticoagulants)

### 1.3 Patient Inputs Currently Available But Ignored

**Biomarker Data:**
- `triglycerides` - Elevated TG (≥ 150 mg/dL) warrants higher omega-3 emphasis
- `ldl` - High LDL combined with high TG indicates cardiovascular risk
- `hdl` - Low HDL with high TG (atherogenic dyslipidemia)
- `omega3Index` - Omega-3 Index lab (% EPA+DHA in RBC membranes, target >8%)

**Risk Calculation Data:**
- `ascvdRisk` - Calculated cardiovascular risk (from DiseaseRiskCalculator)
- `cardiovascularRisk` - Overall cardiovascular risk score

**Dietary/Lifestyle Data** (if collected):
- Fatty fish consumption frequency (salmon, mackerel, sardines)
- Current omega-3 supplementation (fish oil, krill oil, algae oil)
- Dietary preferences (vegetarian/vegan → algae-based EPA/DHA)

**Medical History Data:**
- Medications: Anticoagulants (warfarin, apixaban), antiplatelet agents (aspirin, clopidogrel)
- Bleeding disorders (hemophilia, von Willebrand disease)
- Upcoming surgery (omega-3 may need to be stopped 1-2 weeks prior)
- Fish/seafood allergy

### 1.4 Why This Needs to Be Dynamic

**Clinical Risks:**
1. **Bleeding Risk with Anticoagulants**:
   - High-dose omega-3 (≥ 3g) with warfarin/aspirin increases bleeding risk
   - Should either contraindicate or reduce dose with physician oversight

2. **Inappropriate Dosing**:
   - Patient with TG = 250 mg/dL may benefit from 4g EPA/DHA (prescription Vascepa/Lovaza range)
   - Patient with TG = 80 mg/dL eating salmon 3x/week wastes money on supplements

3. **Missed Dietary Adequacy**:
   - 2 servings fatty fish/week = ~1g EPA/DHA from diet
   - Patient already meeting needs doesn't require expensive supplements

**Cost-Effectiveness:**
- High-quality fish oil costs $20-40/month
- Unnecessary supplementation wastes patient money

**Professional Credibility:**
- Generic "2-3g for everyone" undermines personalized approach
- Clinicians expect risk-based dosing recommendations

---

## 2. Target State (Dynamic Behavior)

### 2.1 Technical Specifications

**Proposed Components:**

| Component | Name | Purpose |
|-----------|------|---------|
| **Shared Helper Module** | `src/omega3-dynamic.ts` | Pure functions for extraction, classification, HTML generation |
| **Preview Probe Endpoint** | `POST /api/report/preview/omega3` | Testing endpoint for omega-3 recommendations |
| **Feature Flag** | `PREVIEW_DYNAMIC_OMEGA3` | Enable/disable dynamic omega-3 (preview-only initially) |
| **Main Report Function** | `generateDynamicOmega3Card()` | Integration point in main report (GET /report) |
| **Testing Documentation** | `TESTING_OMEGA3.md` | Test cases and expected outcomes |

### 2.2 Dynamic Behavior Description

**How Recommendations Adapt:**

1. **Based on Cardiovascular Risk**:
   - **High risk** (ASCVD ≥ 15%, LDL > 130, TG > 150): Emphasize supplementation (2-4g range)
   - **Moderate risk** (ASCVD 7.5-15%, TG 100-150): Consider supplementation (1-2g range)
   - **Low risk** (ASCVD < 7.5%, TG < 100): Emphasize dietary sources first

2. **Based on Triglycerides**:
   - **Very high TG** (≥ 500 mg/dL): HIGH PRIORITY - Physician referral for prescription omega-3 (Vascepa/Lovaza)
   - **High TG** (200-499 mg/dL): HIGH PRIORITY - 3-4g EPA/DHA supplementation
   - **Borderline TG** (150-199 mg/dL): MEDIUM PRIORITY - 2-3g EPA/DHA supplementation
   - **Normal TG** (< 150 mg/dL): MAINTENANCE - Dietary sources or 1g supplementation

3. **Based on Dietary Intake**:
   - **High fish intake** (3+ servings/week): Supplementation may not be needed, consider testing Omega-3 Index
   - **Moderate fish intake** (1-2 servings/week): Lower-dose supplementation (1-2g)
   - **Low/No fish intake**: Standard supplementation (2-3g) or higher if risk factors present

4. **Based on Contraindications**:
   - **Anticoagulants present** (warfarin, apixaban, rivaroxaban): ⚠️ CAUTION - Discuss with physician before high-dose omega-3
   - **Antiplatelet agents** (aspirin, clopidogrel): ⚠️ CAUTION - Monitor for bleeding, consider lower dose
   - **Bleeding disorders**: ❌ CONTRAINDICATION - Do NOT recommend omega-3 supplementation
   - **Upcoming surgery** (< 2 weeks): ⚠️ WARNING - Stop omega-3 supplementation 1-2 weeks before surgery

### 2.3 Clinical Decision Support Scope

**Clear Boundaries:**
- ✅ **This IS**: Clinical decision support based on risk factors and labs
- ✅ **This IS**: Evidence-based dosing ranges from AHA/ACC guidelines
- ✅ **This IS**: Contraindication checking for safety

- ❌ **This IS NOT**: A prescription (omega-3 supplements are OTC)
- ❌ **This IS NOT**: Medical advice (always defer to physician for medication interactions)
- ❌ **This IS NOT**: Replacement for physician consultation for very high TG (≥ 500 mg/dL)

**Disclaimers Required:**
- "Consult your physician before starting omega-3, especially if taking blood thinners"
- "For triglycerides ≥ 500 mg/dL, prescription omega-3 (Vascepa/Lovaza) may be indicated"
- "Dosing varies based on individual health status and current medications"

---

## 3. Tiering System Proposal

### 3.1 Risk-Based Tier Definitions

**Tier 0: Contraindicated (DO NOT RECOMMEND)**
- **Criteria**:
  - Bleeding disorder present (hemophilia, von Willebrand disease)
  - Upcoming surgery within 2 weeks (without physician clearance)
- **Priority**: ❌ CONTRAINDICATION
- **Recommendation**: "Omega-3 supplementation is contraindicated due to bleeding risk. Consult physician."
- **Card Shown**: YES (warning only)

**Tier 1: High-Priority Supplementation (CARDIOVASCULAR BENEFIT)**
- **Criteria**:
  - Very high TG (≥ 500 mg/dL) OR
  - High TG (200-499 mg/dL) OR
  - High ASCVD risk (≥ 15%) with elevated TG (≥ 150 mg/dL) OR
  - History of cardiovascular event (MI, stroke) with suboptimal Omega-3 Index (< 8%)
- **Priority**: 🔴 HIGH PRIORITY
- **Recommendation**:
  - **Very high TG (≥ 500 mg/dL)**: "⚠️ URGENT: Physician referral for prescription omega-3 (Vascepa 4g or Lovaza 4g daily)"
  - **High TG (200-499 mg/dL)**: "High-dose EPA/DHA supplementation: 3-4g daily (pharmaceutical-grade fish oil)"
  - **High ASCVD + High TG**: "EPA/DHA supplementation: 2-3g daily for cardiovascular risk reduction"
- **Retest**: Lipid panel in 8-12 weeks, consider Omega-3 Index testing
- **Card Shown**: YES

**Tier 2: Moderate-Priority Supplementation (PREVENTIVE)**
- **Criteria**:
  - Borderline high TG (150-199 mg/dL) OR
  - Moderate ASCVD risk (7.5-15%) with normal-high TG OR
  - Low HDL (< 40 mg/dL men, < 50 mg/dL women) with any TG elevation OR
  - Low dietary fish intake (< 1 serving/week) with any cardiovascular risk
- **Priority**: 🟠 MEDIUM PRIORITY
- **Recommendation**:
  - "EPA/DHA supplementation: 2-3g daily for cardiovascular health"
  - "Emphasize fatty fish consumption: salmon, mackerel, sardines (2-3 servings/week)"
  - "Consider pharmaceutical-grade fish oil for purity and potency"
- **Retest**: Lipid panel in 3-6 months
- **Card Shown**: YES

**Tier 3: Dietary Emphasis (FOOD FIRST)**
- **Criteria**:
  - Normal TG (< 150 mg/dL) AND
  - Low ASCVD risk (< 7.5%) AND
  - Moderate-high dietary fish intake (2+ servings/week)
- **Priority**: ✅ MAINTENANCE
- **Recommendation**:
  - "Continue current dietary omega-3 intake (fatty fish 2-3x/week)"
  - "Optional: Low-dose EPA/DHA supplementation (1g daily) for additional benefit"
  - "Consider testing Omega-3 Index to confirm adequacy (target >8%)"
- **Retest**: Omega-3 Index annually (optional)
- **Card Shown**: YES

**Tier 4: Caution Required (MEDICATION INTERACTION)**
- **Criteria**:
  - Anticoagulants present (warfarin, apixaban, rivaroxaban, dabigatran) OR
  - Antiplatelet agents present (aspirin ≥ 81mg, clopidogrel, ticagrelor) OR
  - Multiple bleeding risk factors
- **Priority**: ⚠️ CAUTION
- **Recommendation**:
  - "⚠️ CAUTION: Omega-3 at high doses may increase bleeding risk with blood thinners"
  - "Discuss with your physician before starting omega-3 supplementation"
  - "If approved, start with lower dose (1-2g daily) and monitor for unusual bruising/bleeding"
  - "Consider INR monitoring if on warfarin"
- **Retest**: Discuss with physician
- **Card Shown**: YES (warning emphasis)

**Tier 5: No Recommendation Needed (ADEQUATE INTAKE)**
- **Criteria**:
  - Already taking omega-3 supplements (≥ 2g/day) OR
  - Omega-3 Index ≥ 8% (optimal) OR
  - Very high dietary intake (4+ servings fatty fish/week)
- **Priority**: N/A
- **Recommendation**: None (adequate intake)
- **Card Shown**: NO (no action needed)

### 3.2 Tier Priority Summary

| Tier | Name | Show Card | Priority | Key Criteria |
|------|------|-----------|----------|--------------|
| 0 | Contraindicated | ✅ YES | ❌ CONTRAINDICATION | Bleeding disorder, surgery |
| 1 | High-Priority | ✅ YES | 🔴 HIGH PRIORITY | TG ≥ 200, ASCVD ≥ 15% + TG ≥ 150 |
| 2 | Moderate-Priority | ✅ YES | 🟠 MEDIUM PRIORITY | TG 150-199, ASCVD 7.5-15% |
| 3 | Dietary Emphasis | ✅ YES | ✅ MAINTENANCE | TG < 150, low risk, high fish intake |
| 4 | Caution | ✅ YES | ⚠️ CAUTION | Anticoagulants, antiplatelet agents |
| 5 | No Recommendation | ❌ NO | N/A | Already adequate (Omega-3 Index ≥ 8%) |

### 3.3 Dosing Guidelines (To Be Confirmed by Clinical Owner)

**Note**: Exact gram doses should be reviewed and approved by clinical owner. Below are directional guidelines based on AHA/ACC recommendations.

| Indication | Dosing Range | Evidence Base |
|------------|--------------|---------------|
| **Very High TG (≥ 500 mg/dL)** | 4g EPA (prescription) | FDA-approved Vascepa/Lovaza |
| **High TG (200-499 mg/dL)** | 3-4g EPA/DHA | AHA recommendation for TG lowering |
| **Moderate TG (150-199 mg/dL)** | 2-3g EPA/DHA | Preventive cardiovascular benefit |
| **Normal TG + High ASCVD Risk** | 2g EPA/DHA | REDUCE-IT trial (EPA) |
| **Low Risk, Preventive** | 1-2g EPA/DHA | General cardiovascular health |
| **Dietary Adequacy** | 1g EPA/DHA (optional) | Maintenance |

**Clinical Owner Sign-Off Required**:
- [ ] Review and approve dosing ranges for each tier
- [ ] Confirm contraindication criteria (bleeding disorders, anticoagulants)
- [ ] Approve disclaimer language for medication interactions
- [ ] Confirm prescription omega-3 referral criteria (TG ≥ 500 mg/dL)

---

## 4. Data Gating & Safety

### 4.1 When to Show Omega-3 Card

**Show Card When:**
- Triglycerides ≥ 150 mg/dL (borderline high or higher) OR
- ASCVD risk ≥ 7.5% (moderate or higher) with any TG elevation OR
- Low HDL (< 40 men, < 50 women) with TG ≥ 100 mg/dL OR
- History of cardiovascular event (regardless of current TG) OR
- Contraindication present (show warning card) OR
- Caution required (anticoagulants present)

**Hide Card When:**
- Triglycerides < 150 mg/dL AND ASCVD risk < 7.5% AND no cardiovascular history AND no contraindications AND already taking omega-3 ≥ 2g/day OR
- Omega-3 Index ≥ 8% (adequate intake confirmed by lab) OR
- No data available (triglycerides, ASCVD risk, dietary intake all null)

### 4.2 Missing/Inconsistent Data Handling

**Scenario 1: Triglycerides Missing**
- **Fallback**: Use ASCVD risk or cardiovascular history
- **If all data missing**: Hide card (graceful degradation)
- **Recommendation**: Suggest ordering lipid panel

**Scenario 2: Medication Data Missing**
- **Conservative Approach**: Show general omega-3 recommendation
- **Add Disclaimer**: "Consult your physician before starting omega-3, especially if taking blood thinners"

**Scenario 3: Dietary Intake Missing**
- **Assumption**: Low dietary intake (conservative)
- **Recommendation**: Standard supplementation dosing

**Scenario 4: Conflicting Data**
- Example: TG = 120 mg/dL (normal) but ASCVD risk = 18% (high)
- **Resolution**: Use HIGHEST risk factor (ASCVD risk in this case)
- **Recommendation**: Omega-3 for cardiovascular risk reduction despite normal TG

### 4.3 Safety Guardrails

**Contraindication Checking:**
1. **Bleeding Disorders**:
   - Check patient history for: hemophilia, von Willebrand disease, platelet disorders
   - If present: ❌ DO NOT recommend omega-3
   - Show warning card: "Omega-3 supplementation is contraindicated due to bleeding risk"

2. **Anticoagulants**:
   - Check medications for: warfarin, apixaban, rivaroxaban, dabigatran, edoxaban
   - If present: ⚠️ CAUTION card
   - Recommendation: "Discuss with physician before starting omega-3 (bleeding risk)"
   - If approved: Lower dose (1-2g) and monitor

3. **Antiplatelet Agents**:
   - Check medications for: aspirin (≥ 81mg daily), clopidogrel, ticagrelor, prasugrel
   - If present: ⚠️ CAUTION card
   - Recommendation: "Monitor for unusual bruising/bleeding with omega-3"

4. **Upcoming Surgery**:
   - Check surgical history/schedule (if available)
   - If surgery within 2 weeks: ⚠️ WARNING
   - Recommendation: "Stop omega-3 supplementation 1-2 weeks before surgery"

**Prescription Omega-3 Referral:**
- **Criteria**: Triglycerides ≥ 500 mg/dL
- **Action**: ⚠️ URGENT physician referral
- **Reason**: Prescription omega-3 (Vascepa 4g EPA, Lovaza 4g EPA/DHA) required for very high TG
- **Do NOT**: Recommend OTC supplements for TG ≥ 500 mg/dL (insufficient dosing)

**Disclaimer Requirements:**
- All omega-3 cards MUST include:
  - "Consult your physician before starting omega-3, especially if taking blood thinners"
  - "Dosing varies based on individual health status and current medications"
- High-dose cards (≥ 3g) MUST include:
  - "High-dose omega-3 may increase bleeding risk - monitor for unusual bruising"
- Very high TG cards (≥ 500 mg/dL) MUST include:
  - "Physician consultation required for prescription omega-3 (Vascepa/Lovaza)"

---

## 5. Technical Pattern

### 5.1 Shared Helper Module: `src/omega3-dynamic.ts`

**Follows pattern from**: `src/vitaminD-dynamic.ts`, `src/hba1c-dynamic.ts`

**Proposed Functions:**

```typescript
/**
 * Omega-3 classification thresholds
 */
export const TG_VERY_HIGH = 500        // mg/dL - Prescription omega-3 required
export const TG_HIGH = 200             // mg/dL - High-dose supplementation
export const TG_BORDERLINE_HIGH = 150  // mg/dL - Moderate-dose supplementation
export const TG_NORMAL = 150           // mg/dL - Below this is normal

export const ASCVD_HIGH_RISK = 0.15    // 15% - High cardiovascular risk
export const ASCVD_MODERATE_RISK = 0.075 // 7.5% - Moderate cardiovascular risk

export const OMEGA3_INDEX_OPTIMAL = 8  // % - Target Omega-3 Index

/**
 * Omega-3 priority tiers
 */
export type Omega3Tier = 
  | 'contraindicated'
  | 'high_priority'
  | 'moderate_priority'
  | 'dietary_emphasis'
  | 'caution'
  | 'no_recommendation'
  | null

/**
 * Result structure for Omega-3 card generation
 */
export interface Omega3CardResult {
  shown: boolean
  triglycerides: number | null
  ascvdRisk: number | null
  omega3Index: number | null
  tier: Omega3Tier
  priority: string | null
  html: string
}

/**
 * Extract triglycerides from biomarkers object (probe context)
 * @param biomarkers - Object containing biomarker data
 * @returns Triglycerides in mg/dL or null
 */
export function extractTriglyceridesFromBiomarkers(biomarkers: any): number | null

/**
 * Extract ASCVD risk from risk calculation object (probe context)
 * @param risk - Object containing risk calculation data
 * @returns ASCVD risk as decimal (0.15 = 15%) or null
 */
export function extractASCVDRiskFromCalculation(risk: any): number | null

/**
 * Extract Omega-3 Index from biomarkers object (probe context)
 * @param biomarkers - Object containing biomarker data
 * @returns Omega-3 Index as percentage or null
 */
export function extractOmega3IndexFromBiomarkers(biomarkers: any): number | null

/**
 * Extract dietary fish intake from lifestyle/dietary data (probe context)
 * @param dietary - Object containing dietary data
 * @returns Fish servings per week or null
 */
export function extractFishIntakeFromDietary(dietary: any): number | null

/**
 * Extract existing omega-3 supplementation from supplements list (probe context)
 * @param supplements - Array of current supplements
 * @returns Daily EPA/DHA dose in grams or null
 */
export function extractExistingOmega3Supplementation(supplements: any[]): number | null

/**
 * Check for contraindications (bleeding disorders, upcoming surgery)
 * @param medicalHistory - Object containing medical history
 * @returns true if contraindication present
 */
export function hasOmega3Contraindication(medicalHistory: any): boolean

/**
 * Check for caution factors (anticoagulants, antiplatelet agents)
 * @param medications - Array of current medications
 * @returns true if caution required
 */
export function requiresOmega3Caution(medications: any[]): boolean

/**
 * Classify Omega-3 priority tier based on risk factors
 * @param triglycerides - Triglycerides in mg/dL
 * @param ascvdRisk - ASCVD risk as decimal
 * @param omega3Index - Omega-3 Index percentage (if available)
 * @param fishIntake - Fish servings per week (if available)
 * @param hasContraindication - Contraindication present
 * @param requiresCaution - Caution required
 * @returns Omega-3 tier
 */
export function classifyOmega3Tier(
  triglycerides: number | null,
  ascvdRisk: number | null,
  omega3Index: number | null,
  fishIntake: number | null,
  hasContraindication: boolean,
  requiresCaution: boolean
): Omega3Tier

/**
 * Determine if Omega-3 card should be shown
 * @param tier - Omega-3 tier
 * @returns true if card should be shown
 */
export function shouldShowOmega3Card(tier: Omega3Tier): boolean

/**
 * Generate HTML for Omega-3 recommendation card
 * @param triglycerides - Triglycerides in mg/dL
 * @param ascvdRisk - ASCVD risk as decimal
 * @param omega3Index - Omega-3 Index percentage
 * @param tier - Omega-3 tier
 * @returns HTML string for card
 */
export function generateOmega3CardHTML(
  triglycerides: number | null,
  ascvdRisk: number | null,
  omega3Index: number | null,
  tier: Omega3Tier
): string

/**
 * Build complete Omega-3 card result with gating logic
 * Main function used by probe endpoint and report generation
 * @param biomarkers - Biomarker data
 * @param risk - Risk calculation data
 * @param medicalHistory - Medical history
 * @param medications - Current medications
 * @param dietary - Dietary data
 * @param supplements - Current supplements
 * @returns Complete Omega-3 card result
 */
export function buildOmega3CardResult(
  biomarkers: any,
  risk: any,
  medicalHistory: any,
  medications: any[],
  dietary: any,
  supplements: any[]
): Omega3CardResult
```

### 5.2 Preview Probe Endpoint: `POST /api/report/preview/omega3`

**Endpoint Specification:**

**Request Body Schema:**
```json
{
  "biomarkers": {
    "triglycerides": number,       // mg/dL (optional)
    "ldl": number,                  // mg/dL (optional)
    "hdl": number,                  // mg/dL (optional)
    "omega3Index": number           // % (optional)
  },
  "risk": {
    "ascvd": number                 // Decimal 0-1 (e.g., 0.15 = 15%) (optional)
  },
  "medicalHistory": {
    "bleedingDisorder": boolean,    // (optional)
    "upcomingSurgery": boolean,     // Within 2 weeks (optional)
    "cardiovascularEvent": boolean  // History of MI/stroke (optional)
  },
  "medications": [                  // (optional)
    { "name": "warfarin", "category": "anticoagulant" },
    { "name": "aspirin", "dose": "81mg", "category": "antiplatelet" }
  ],
  "dietary": {
    "fishServingsPerWeek": number   // (optional)
  },
  "supplements": [                  // (optional)
    { "name": "fish oil", "epaDha": 2 }  // grams per day
  ]
}
```

**Response Schema:**
```json
{
  "success": boolean,
  "shown": boolean,
  "triglycerides": number | null,
  "ascvdRisk": number | null,
  "omega3Index": number | null,
  "tier": "contraindicated" | "high_priority" | "moderate_priority" | "dietary_emphasis" | "caution" | "no_recommendation" | null,
  "priority": "CONTRAINDICATION" | "HIGH PRIORITY" | "MEDIUM PRIORITY" | "MAINTENANCE" | "CAUTION" | null,
  "html": string,
  "fingerprint": string
}
```

**Example Request/Response:**

**Request (High TG, High ASCVD Risk):**
```json
{
  "biomarkers": {
    "triglycerides": 285,
    "ldl": 145,
    "hdl": 38
  },
  "risk": {
    "ascvd": 0.18
  }
}
```

**Response:**
```json
{
  "success": true,
  "shown": true,
  "triglycerides": 285,
  "ascvdRisk": 0.18,
  "omega3Index": null,
  "tier": "high_priority",
  "priority": "HIGH PRIORITY",
  "html": "<!-- Full HTML card with 3-4g EPA/DHA recommendation -->",
  "fingerprint": "omega3-abc123"
}
```

### 5.3 Main Report Integration

**Function: `generateDynamicOmega3Card()`**

**Integration Point:**
- File: `src/index.tsx`
- Location: Replace static omega-3 mentions in action plan and LDL card
- Feature Flag: `PREVIEW_DYNAMIC_OMEGA3 = true`

**Pseudocode:**
```typescript
function generateDynamicOmega3Card(): string {
  // Check feature flag
  if (!PREVIEW_DYNAMIC_OMEGA3) return ''
  
  // Check comprehensive data availability
  if (!comprehensiveData) return ''
  
  // Extract data from comprehensive structure
  const biomarkers = comprehensiveData.biomarkers || {}
  const risk = comprehensiveData.risk || {}
  const medicalHistory = comprehensiveData.medicalHistory || {}
  const medications = comprehensiveData.medications || []
  const dietary = comprehensiveData.dietary || {}
  const supplements = comprehensiveData.supplements || []
  
  // Build Omega-3 card result
  const result = buildOmega3CardResult(
    biomarkers,
    risk,
    medicalHistory,
    medications,
    dietary,
    supplements
  )
  
  // Return HTML if card should be shown
  return result.html
}
```

**Replacement Strategy:**
1. Remove static "2-3g EPA/DHA daily" from action plan (line ~4839)
2. Remove static omega-3 from LDL card supplements list (line ~4451)
3. Insert `${generateDynamicOmega3Card()}` in appropriate section (e.g., "Biomarker Optimization" or "High Priority Interventions")

### 5.4 Feature Flag

**Preview Flag:**
```typescript
const PREVIEW_DYNAMIC_OMEGA3 = true  // Hard-coded true for preview branch
```

**Production Flag (Future):**
```typescript
const ENABLE_DYNAMIC_OMEGA3 = env.FEATURE_DYNAMIC_OMEGA3 || false  // Environment variable
```

**Rollback:**
- Set flag to `false` → Omega-3 card hidden (graceful degradation)
- Estimated rollback time: < 5 minutes

---

## 6. Testing Plan

### 6.1 Probe Endpoint Test Scenarios (8 scenarios)

**Test Case 1: Empty Body (No Data)**
```json
{}
```
**Expected Response:**
```json
{
  "success": true,
  "shown": false,
  "triglycerides": null,
  "ascvdRisk": null,
  "omega3Index": null,
  "tier": null,
  "priority": null,
  "html": ""
}
```
**Verification**: Card hidden when no data available

---

**Test Case 2: Normal TG, Low Risk (No Recommendation)**
```json
{
  "biomarkers": {
    "triglycerides": 95,
    "omega3Index": 9
  },
  "risk": {
    "ascvd": 0.04
  }
}
```
**Expected Response:**
```json
{
  "success": true,
  "shown": false,
  "triglycerides": 95,
  "ascvdRisk": 0.04,
  "omega3Index": 9,
  "tier": "no_recommendation",
  "priority": null,
  "html": ""
}
```
**Verification**: Card hidden for adequate intake (Omega-3 Index ≥ 8%)

---

**Test Case 3: Borderline High TG, Moderate Risk**
```json
{
  "biomarkers": {
    "triglycerides": 165,
    "ldl": 125
  },
  "risk": {
    "ascvd": 0.09
  }
}
```
**Expected Response:**
```json
{
  "success": true,
  "shown": true,
  "triglycerides": 165,
  "ascvdRisk": 0.09,
  "omega3Index": null,
  "tier": "moderate_priority",
  "priority": "MEDIUM PRIORITY",
  "html": "<!-- Card with 2-3g EPA/DHA recommendation -->"
}
```
**Verification**: MEDIUM PRIORITY card shown for borderline high TG

---

**Test Case 4: High TG (High-Priority Supplementation)**
```json
{
  "biomarkers": {
    "triglycerides": 285,
    "ldl": 145,
    "hdl": 38
  },
  "risk": {
    "ascvd": 0.18
  }
}
```
**Expected Response:**
```json
{
  "success": true,
  "shown": true,
  "triglycerides": 285,
  "ascvdRisk": 0.18,
  "omega3Index": null,
  "tier": "high_priority",
  "priority": "HIGH PRIORITY",
  "html": "<!-- Card with 3-4g EPA/DHA recommendation -->"
}
```
**Verification**: HIGH PRIORITY card shown for TG 200-499 mg/dL

---

**Test Case 5: Very High TG (Prescription Omega-3 Referral)**
```json
{
  "biomarkers": {
    "triglycerides": 625,
    "ldl": 160
  }
}
```
**Expected Response:**
```json
{
  "success": true,
  "shown": true,
  "triglycerides": 625,
  "ascvdRisk": null,
  "omega3Index": null,
  "tier": "high_priority",
  "priority": "HIGH PRIORITY",
  "html": "<!-- Card with URGENT physician referral for prescription omega-3 -->"
}
```
**Verification**: URGENT referral message for TG ≥ 500 mg/dL

---

**Test Case 6: Anticoagulant Present (Caution)**
```json
{
  "biomarkers": {
    "triglycerides": 175
  },
  "medications": [
    { "name": "warfarin", "category": "anticoagulant" }
  ]
}
```
**Expected Response:**
```json
{
  "success": true,
  "shown": true,
  "triglycerides": 175,
  "ascvdRisk": null,
  "omega3Index": null,
  "tier": "caution",
  "priority": "CAUTION",
  "html": "<!-- Card with bleeding risk warning and physician discussion -->"
}
```
**Verification**: CAUTION card shown with anticoagulant warning

---

**Test Case 7: Bleeding Disorder (Contraindicated)**
```json
{
  "biomarkers": {
    "triglycerides": 185
  },
  "medicalHistory": {
    "bleedingDisorder": true
  }
}
```
**Expected Response:**
```json
{
  "success": true,
  "shown": true,
  "triglycerides": 185,
  "ascvdRisk": null,
  "omega3Index": null,
  "tier": "contraindicated",
  "priority": "CONTRAINDICATION",
  "html": "<!-- Card with CONTRAINDICATION warning -->"
}
```
**Verification**: CONTRAINDICATION card shown for bleeding disorder

---

**Test Case 8: High Fish Intake, Low TG (Dietary Emphasis)**
```json
{
  "biomarkers": {
    "triglycerides": 105
  },
  "dietary": {
    "fishServingsPerWeek": 3
  },
  "risk": {
    "ascvd": 0.05
  }
}
```
**Expected Response:**
```json
{
  "success": true,
  "shown": true,
  "triglycerides": 105,
  "ascvdRisk": 0.05,
  "omega3Index": null,
  "tier": "dietary_emphasis",
  "priority": "MAINTENANCE",
  "html": "<!-- Card with dietary emphasis and optional low-dose supplementation -->"
}
```
**Verification**: MAINTENANCE card shown emphasizing dietary sources

---

### 6.2 E2E Report Test Scenarios (4 scenarios)

**E2E Scenario 1: Omega-3 Card Hidden (No Indication)**
- **Patient Profile**:
  - Triglycerides: 85 mg/dL (normal)
  - ASCVD risk: 3% (low)
  - Omega-3 Index: 9.5% (optimal)
  - Fish intake: 3 servings/week
- **Expected**: No Omega-3 card appears in report
- **Verification**: Adequate intake, no supplementation needed

---

**E2E Scenario 2: Omega-3 Card Shown with Medium Priority**
- **Patient Profile**:
  - Triglycerides: 165 mg/dL (borderline high)
  - ASCVD risk: 8% (moderate)
  - LDL: 130 mg/dL
  - No fish intake
- **Expected**: Omega-3 card appears with 🟠 MEDIUM PRIORITY
- **Content Verification**:
  - "EPA/DHA supplementation: 2-3g daily for cardiovascular health"
  - "Emphasize fatty fish consumption: salmon, mackerel, sardines"
  - Retest lipid panel in 3-6 months

---

**E2E Scenario 3: Omega-3 Card Shown with High Priority**
- **Patient Profile**:
  - Triglycerides: 295 mg/dL (high)
  - ASCVD risk: 16% (high)
  - HDL: 36 mg/dL (low)
  - History of cardiovascular event
- **Expected**: Omega-3 card appears with 🔴 HIGH PRIORITY
- **Content Verification**:
  - "High-dose EPA/DHA supplementation: 3-4g daily"
  - "Pharmaceutical-grade fish oil recommended"
  - Retest lipid panel in 8-12 weeks
  - Consider Omega-3 Index testing

---

**E2E Scenario 4: Omega-3 Card Shown with Caution (Anticoagulant)**
- **Patient Profile**:
  - Triglycerides: 180 mg/dL (borderline high)
  - Medications: Warfarin 5mg daily
- **Expected**: Omega-3 card appears with ⚠️ CAUTION
- **Content Verification**:
  - "⚠️ CAUTION: Omega-3 at high doses may increase bleeding risk with blood thinners"
  - "Discuss with your physician before starting omega-3 supplementation"
  - "If approved, start with lower dose (1-2g daily)"
  - "Consider INR monitoring"

---

### 6.3 Testing Documentation

**File**: `TESTING_OMEGA3.md` (to be created)

**Content Structure** (following TESTING_LDL.md, TESTING_VITAMIN_D.md, TESTING_HBA1C.md patterns):
1. Overview
2. What Changed (Before/After)
3. Prerequisites (preview password, base URL, tenant ID)
4. PowerShell Examples (8 probe test cases)
5. curl Examples (8 probe test cases)
6. E2E Report Scenarios (4 scenarios)
7. Expected Outcomes and Verification Steps
8. Troubleshooting

---

## 7. Open Questions / TODOs

### 7.1 Clinical Questions (Require Clinical Owner Sign-Off)

**Dosing & Guidelines:**
- [ ] **Q1**: Confirm exact EPA/DHA dosing ranges for each tier (currently directional)
  - Very high TG (≥ 500 mg/dL): 4g EPA (prescription only)?
  - High TG (200-499 mg/dL): 3-4g EPA/DHA?
  - Borderline TG (150-199 mg/dL): 2-3g EPA/DHA?
- [ ] **Q2**: Should we differentiate between EPA-only (Vascepa) vs EPA+DHA (Lovaza) recommendations?
  - REDUCE-IT trial showed EPA benefit, but most OTC supplements are EPA+DHA
- [ ] **Q3**: What is the threshold for recommending prescription omega-3 vs OTC?
  - Currently: TG ≥ 500 mg/dL → prescription
  - Should we mention prescription for TG 200-499 mg/dL?

**Contraindications & Cautions:**
- [ ] **Q4**: Confirm contraindication list (bleeding disorders, upcoming surgery)
  - Should we add: Aspirin allergy? Fish/seafood allergy?
- [ ] **Q5**: For anticoagulants, what is the appropriate omega-3 dose ceiling?
  - Currently: 1-2g with physician approval
  - Or should we avoid any recommendation?
- [ ] **Q6**: Should we check for upcoming surgery timeframe (1 week? 2 weeks?)
  - AHA/ACC guidelines suggest stopping 1-2 weeks before surgery

**Dietary vs Supplementation:**
- [ ] **Q7**: How many servings of fatty fish per week = adequate EPA/DHA intake?
  - Currently: 2 servings/week ≈ 1g EPA/DHA
  - Should we adjust supplementation dose based on dietary intake?
- [ ] **Q8**: Should we recommend Omega-3 Index testing for all patients or only specific cases?
  - Currently: Suggest for high fish intake + low TG (dietary adequacy confirmation)

**Cardiovascular Event History:**
- [ ] **Q9**: For patients with history of MI/stroke, should omega-3 be HIGH PRIORITY regardless of current TG?
  - REDUCE-IT trial showed benefit in post-MI patients with EPA 4g
- [ ] **Q10**: What constitutes "cardiovascular event" for omega-3 recommendation?
  - MI, stroke, peripheral artery disease, coronary artery disease?

### 7.2 Technical Questions

**Data Availability:**
- [ ] **Q11**: Is Omega-3 Index lab data currently collected in assessmentData.biomarkers?
  - If yes, what is the key name? ('omega3Index', 'omega_3_index', 'o3Index'?)
  - If no, should we plan to add it?
- [ ] **Q12**: Is dietary fish intake currently collected in assessmentData.dietary or lifestyle?
  - If yes, what is the key name and format? (servings/week, frequency scale 1-5?)
  - If no, should we add a questionnaire item?
- [ ] **Q13**: Are current supplements/medications accessible in comprehensiveData?
  - Format: Array of objects with { name, category, dose }?
  - How to detect omega-3 supplements (fish oil, krill oil, algae oil, EPA, DHA)?

**Medication Checking:**
- [ ] **Q14**: How to reliably detect anticoagulants and antiplatelet agents from medication list?
  - Drug name matching (warfarin, Coumadin, apixaban, Eliquis, etc.)?
  - Category/class matching (anticoagulant, antiplatelet)?
  - Drug interaction database integration?
- [ ] **Q15**: Should we integrate with a drug interaction API for real-time checking?
  - Or maintain a local list of contraindicated/caution medications?

**Integration with Existing Features:**
- [ ] **Q16**: Should dynamic Omega-3 card replace static mentions in LDL card?
  - Currently: LDL card has "Omega-3 EPA/DHA (2-3g daily)" in supplements list
  - Option A: Remove from LDL card, add standalone Omega-3 card
  - Option B: Keep in LDL card but make it dynamic
- [ ] **Q17**: Should dynamic Omega-3 replace action plan mention in Week 3-4?
  - Currently: "Add omega-3 supplementation (2-3g EPA/DHA daily)"
  - Option A: Remove from action plan entirely (rely on Omega-3 card)
  - Option B: Make action plan mention dynamic based on Omega-3 card tier

**Response Shape:**
- [ ] **Q18**: Should probe endpoint return additional fields for debugging?
  - fishIntake, existingOmega3Dose, hasContraindication, requiresCaution?
- [ ] **Q19**: Should we return recommended dose range in response (e.g., "2-3g")?
  - Or only in HTML content?

### 7.3 Implementation TODOs

**Phase 1: Core Implementation**
- [ ] Create `src/omega3-dynamic.ts` with all helper functions
- [ ] Add `POST /api/report/preview/omega3` probe endpoint in `src/index.tsx`
- [ ] Add `PREVIEW_DYNAMIC_OMEGA3` feature flag
- [ ] Add `generateDynamicOmega3Card()` function
- [ ] Replace static omega-3 mentions with dynamic card

**Phase 2: Testing**
- [ ] Create `TESTING_OMEGA3.md` with 8 probe + 4 E2E scenarios
- [ ] Implement 8 probe test cases (PowerShell + curl)
- [ ] Verify all 4 E2E report scenarios
- [ ] Regression test: LDL, Vitamin D, HbA1c probes still work

**Phase 3: Documentation**
- [ ] Update `DOC_STATIC_CONTENT_INVENTORY.md` (mark Omega-3 as completed)
- [ ] Create `CHECKLIST_OMEGA3_PRODUCTION.md` (production readiness checklist)
- [ ] Update README with Omega-3 feature description

**Phase 4: Clinical Review**
- [ ] Clinical owner review of all 5 tiers (contraindicated, high, moderate, dietary, caution)
- [ ] Clinical owner approval of dosing ranges
- [ ] Clinical owner approval of contraindication criteria
- [ ] Clinical owner approval of disclaimer language

**Phase 5: Production Promotion**
- [ ] Complete all items in `CHECKLIST_OMEGA3_PRODUCTION.md`
- [ ] Get sign-offs from Technical, Clinical, Operations owners
- [ ] Merge to production branch with flag OFF
- [ ] Gradual rollout (canary → 10% → 25% → 50% → 100%)

---

## 8. Success Criteria

**This implementation will be considered successful when:**

1. **Functional Requirements Met**:
   - ✅ Omega-3 recommendations adapt based on TG, ASCVD risk, dietary intake
   - ✅ Card hidden for adequate intake (Omega-3 Index ≥ 8% or high fish intake + normal TG)
   - ✅ Contraindication checking prevents recommendations for bleeding disorders
   - ✅ Caution warnings present for anticoagulants/antiplatelet agents
   - ✅ Prescription omega-3 referral for TG ≥ 500 mg/dL

2. **Safety Requirements Met**:
   - ✅ No recommendations when contraindicated
   - ✅ Bleeding risk warnings present for high-dose + anticoagulants
   - ✅ Clear disclaimers about physician consultation
   - ✅ Graceful degradation when data missing

3. **Testing Requirements Met**:
   - ✅ All 8 probe test cases pass
   - ✅ All 4 E2E report scenarios verified
   - ✅ No regressions in LDL, Vitamin D, HbA1c features
   - ✅ TypeScript builds successfully

4. **Clinical Requirements Met**:
   - ✅ Clinical owner approves all tier definitions
   - ✅ Clinical owner approves dosing ranges
   - ✅ Clinical owner approves contraindication criteria
   - ✅ Clinical owner approves disclaimer language

5. **Documentation Requirements Met**:
   - ✅ `TESTING_OMEGA3.md` created with comprehensive test cases
   - ✅ `CHECKLIST_OMEGA3_PRODUCTION.md` created
   - ✅ Code documentation (JSDoc) complete
   - ✅ Production promotion checklist completed

---

## 9. Timeline Estimate

**Assuming 1 developer working full-time:**

| Phase | Duration | Description |
|-------|----------|-------------|
| **Phase 1: Core Implementation** | 3-4 days | Create helper module, probe endpoint, feature flag, main report integration |
| **Phase 2: Testing** | 2-3 days | Create test documentation, implement test cases, E2E verification |
| **Phase 3: Documentation** | 1-2 days | Update docs, create production checklist |
| **Phase 4: Clinical Review** | 3-5 days | Clinical owner reviews, approvals, iterations |
| **Phase 5: Production Promotion** | 2-3 days | Checklist completion, sign-offs, gradual rollout |
| **TOTAL** | **11-17 days** | End-to-end implementation and production deployment |

**Blockers:**
- Clinical owner availability for reviews and approvals
- Availability of Omega-3 Index lab data (may require questionnaire additions)
- Medication data quality (reliable anticoagulant/antiplatelet detection)

---

## 10. Related Documents

**Pattern References:**
- `src/vitaminD-dynamic.ts` - Vitamin D helper module (pattern for omega-3 module)
- `src/hba1c-dynamic.ts` - HbA1c helper module (pattern for omega-3 module)
- `TESTING_VITAMIN_D.md` - Vitamin D testing guide (pattern for omega-3 testing)
- `TESTING_HBA1C.md` - HbA1c testing guide (pattern for omega-3 testing)
- `CHECKLIST_VITAMIN_D_PRODUCTION.md` - Vitamin D production checklist (pattern for omega-3 checklist)
- `CHECKLIST_HBA1C_PRODUCTION.md` - HbA1c production checklist (pattern for omega-3 checklist)

**Static Content Inventory:**
- `DOC_STATIC_CONTENT_INVENTORY.md` - Static content roadmap (Omega-3 section: lines ~35-75)

**Guidelines & Evidence Base:**
- AHA/ACC Guidelines for Omega-3 Fatty Acids
- REDUCE-IT Trial (EPA for cardiovascular risk reduction)
- FDA Approval Documents for Vascepa and Lovaza

---

**Document Status**: ✅ Planning Complete (awaiting clinical review)  
**Next Step**: Create implementation branch and begin Phase 1 (Core Implementation)  
**Owner**: Technical Lead + Clinical Lead  
**Last Updated**: 2025-11-29
