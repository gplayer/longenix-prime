# DOC_HBA1C_DYNAMIC_PLAN.md – Dynamic HbA1c/Glucose Implementation Plan

**Feature**: Dynamic Fix Pack #3 – HbA1c / Glucose Management  
**Status**: Planning & Architecture (Documentation Only)  
**Date**: 2025-11-29  
**Purpose**: Blueprint for converting static/missing glucose content to dynamic, data-gated recommendations

---

## Executive Summary

This document describes the design and implementation plan for **Dynamic Fix Pack #3**, which will create a comprehensive, data-driven glycemic control recommendation system for the LonGenix-Prime health report.

### Current State
- **HbA1c**, **fasting glucose**, and **fasting insulin** data are collected but **NOT used for recommendations**
- **Diabetes risk** is calculated by `DiseaseRiskCalculator.calculateDiabetesRisk()` but **NOT prominently displayed**
- **No dedicated glycemic control card** exists in the report
- Labs appear only in biomarker tables without actionable guidance

### Target State
- **Dynamic glycemic control card** shown when HbA1c/glucose data indicates clinical concern
- **5-tier clinical classification**: Normal, Elevated-Normal, Prediabetes, Diabetes, High-Risk Diabetes
- **Personalized recommendations** based on actual lab values and risk scores
- **Safety-first approach**: Urgent physician referral for diabetes range, actionable lifestyle guidance for prediabetes

### Clinical Impact
- **High Priority** (Phase 1 from `DOC_STATIC_CONTENT_INVENTORY.md`)
- **Prevalence**: ~50% of US adults have prediabetes or diabetes
- **Major Health Impact**: Leading cause of cardiovascular disease, kidney failure, blindness, neuropathy
- **Actionable**: Lifestyle and medication interventions are highly effective

---

## 1. Current Static Behavior Analysis

### 1.1 Data Collection (Lines ~5442-5443, ~6151-6152)

**Patient Data Fields (Already Collected):**
```typescript
// From /api/assessment/complete (line 5442-5443)
glucose: parseFloat(assessmentData.glucose) || null,  // Fasting glucose (mg/dL)
hba1c: parseFloat(assessmentData.hba1c) || null,      // HbA1c (%)

// Insulin also collected (line 5444)
insulin: parseFloat(assessmentData.insulin) || null,  // Fasting insulin (μU/mL)

// From /api/assessment/comprehensive (line 6151-6152)
glucose: biomarkers.glucose || null,
hba1c: biomarkers.hba1c || null,
```

**Reference Ranges Defined (Lines ~2089-2090):**
```typescript
{ name: 'glucose', label: 'Fasting Glucose', unit: 'mg/dL', range: '70-99' },
{ name: 'hba1c', label: 'HbA1c', unit: '%', range: '4.0-5.6' },
```

### 1.2 Diabetes Risk Calculation (Already Implemented)

**Risk Computation (Lines ~5519, 6174, 6552):**
```typescript
const diabetesRisk = DiseaseRiskCalculator.calculateDiabetesRisk(patientData, assessmentData.lifestyle || {})
```

**Risk Used In:**
- `POST /api/assessment/complete` → stored as `diabetes` risk score
- `POST /api/assessment/comprehensive` → calculated for demo patients
- Risk scores are calculated but **NOT prominently featured in report**

### 1.3 Current Report Display (Biomarker Table Only)

**Where Glucose/HbA1c Appear:**
- **Biomarker Reference Table** (line ~2089-2090): Shows reference ranges
- **Lab Value Display**: Values shown in comprehensive assessment biomarker section
- **NO DEDICATED RECOMMENDATION CARD**: Missing entirely

**Static Content Mentions (Generic):**
```typescript
// Line ~3044: Generic mention in hallmarks section
'<p class="mb-1"><strong>Based on:</strong> Glucose, lipids, body composition</p>'

// Line ~3540: Data collection mention
'<strong>Laboratory Data:</strong> Complete blood panel, lipid profile, glucose metabolism markers'

// Line ~3577: Hallmark reference
'<p><strong>Deregulated Nutrient Sensing (40%):</strong> Insulin sensitivity, mTOR pathway markers, fasting glucose, HbA1c levels</p>'

// Line ~3843: Generic metabolic mention
'<span><strong>Metabolic Function:</strong> Optimal glucose control and insulin sensitivity</span>'

// Line ~4346: Lifestyle mention
'<li>• Glucose variability monitoring</li>'
```

### 1.4 What's Currently Ignored

**Patient Inputs NOT Used for Personalization:**
1. **Actual HbA1c value** → No tiered recommendations
2. **Actual fasting glucose** → No alerts for prediabetes/diabetes ranges
3. **Fasting insulin** → Could calculate HOMA-IR for insulin resistance
4. **Diabetes risk score** → Calculated but not featured
5. **Family history of diabetes** → Collected (line ~2602) but not used in glycemic card
6. **BMI and obesity status** → Major diabetes risk factor, not integrated
7. **Medications affecting glucose** → Steroids, beta-blockers, etc. not checked

### 1.5 Clinical Gaps & Risks

**Current Problems:**
- ❌ **Missed Diagnoses**: Patient with HbA1c 6.8% (diabetes) gets no urgent alert
- ❌ **No Prediabetes Intervention**: Patient with HbA1c 6.0% gets no lifestyle guidance
- ❌ **Wasted Data**: Extensive glucose/HbA1c collection with no actionable output
- ❌ **Standard of Care Gap**: Every health assessment should address glycemic control
- ❌ **Professional Credibility**: Report appears incomplete without diabetes screening results

---

## 2. Proposed Dynamic Behavior

### 2.1 Data Sources

**Primary Lab Values:**
1. **HbA1c** (`assessmentData.hba1c`, unit: %, optimal range: 4.0-5.6%)
2. **Fasting Glucose** (`assessmentData.glucose`, unit: mg/dL, optimal range: 70-99 mg/dL)
3. **Fasting Insulin** (`assessmentData.insulin`, unit: μU/mL) - Optional for HOMA-IR calculation

**Secondary Risk Factors (Optional Enhancements):**
4. **Diabetes Risk Score** (`DiseaseRiskCalculator.calculateDiabetesRisk()`)
5. **BMI** (`patientData.bmi`) - Obesity is major risk factor
6. **Family History** (`assessmentData.familyHistory` includes `family_diabetes`)
7. **Age** (`patientData.age`) - Risk increases with age

**Data Prioritization Logic:**
- **If HbA1c available**: Use as primary classifier (gold standard for diabetes diagnosis)
- **If only fasting glucose available**: Use glucose-based thresholds
- **If both available**: Use HbA1c (more reliable), note discrepancies
- **If neither available**: Show data collection card (request labs)

### 2.2 Clinical Tiers & States

**5-Tier Classification System:**

| Tier | HbA1c (%) | Fasting Glucose (mg/dL) | Status | Priority | Clinical Interpretation |
|------|-----------|------------------------|--------|----------|------------------------|
| 1 | < 5.7 | < 100 | `normal` | **OPTIMAL** ✓ | Excellent glycemic control |
| 2 | 5.7-5.9 | 100-109 | `elevated_normal` | **WATCH** ⚠️ | Increased risk, lifestyle modification |
| 3 | 6.0-6.4 | 110-125 | `prediabetes` | **HIGH PRIORITY** 🟠 | High progression risk, intensive lifestyle intervention |
| 4 | 6.5-7.9 | 126-199 | `diabetes` | **URGENT** 🔴 | Diabetes range, immediate physician referral |
| 5 | ≥ 8.0 | ≥ 200 | `high_risk_diabetes` | **CRITICAL** 🔴 | Severe hyperglycemia, urgent medical attention |

**Thresholds Source:**
- **American Diabetes Association (ADA) 2024 Guidelines**
- HbA1c < 5.7%: Normal
- HbA1c 5.7-6.4%: Prediabetes
- HbA1c ≥ 6.5%: Diabetes (if confirmed on repeat test)
- Fasting glucose < 100: Normal
- Fasting glucose 100-125: Prediabetes
- Fasting glucose ≥ 126: Diabetes

### 2.3 Gating Logic (When to Show Card)

**Card Display Rules:**

**Show Card When (OR conditions):**
1. HbA1c ≥ 5.7% (Prediabetes or higher)
2. Fasting glucose ≥ 100 mg/dL (Elevated or higher)
3. HbA1c < 5.7% AND glucose < 100 **AND** diabetes risk score > 0.15 (High risk despite normal labs)
4. **Optional**: If labs are missing but family history + obesity present → "Get tested" card

**Hide Card When:**
- HbA1c < 5.7% AND glucose < 100 AND diabetes risk < 0.10 (Low risk, optimal labs)
- Both HbA1c and glucose are `null` AND no high-risk factors

**Rationale:**
- **Clinical Indication**: Show when there's actionable information (abnormal labs or high risk)
- **Avoid Noise**: Don't show "everything is perfect" card to low-risk patients
- **Encourage Testing**: Show data collection card to high-risk patients without labs

### 2.4 Personalized Recommendations by Tier

#### Tier 1: Normal (HbA1c < 5.7%, Glucose < 100 mg/dL)
**Priority**: OPTIMAL ✓ (Green border)  
**Message**: "Excellent Glycemic Control"

**Recommendations:**
- ✅ Current lifestyle working well
- Maintain healthy diet (emphasize whole foods, fiber)
- Continue regular physical activity
- Annual HbA1c recheck
- Monitor for changes (weight gain, family history)

**Retest**: 12 months

---

#### Tier 2: Elevated-Normal (HbA1c 5.7-5.9%, Glucose 100-109 mg/dL)
**Priority**: WATCH ⚠️ (Yellow border)  
**Message**: "Glucose Elevated - Increased Diabetes Risk"

**Recommendations:**
- ⚠️ You are at **increased risk** for developing type 2 diabetes
- **Weight management**: 5-7% weight loss if BMI > 25
- **Diet changes**:
  - Low glycemic index foods
  - Increase fiber (25-30g daily)
  - Reduce refined carbs and added sugars
  - Prioritize vegetables, whole grains, lean protein
- **Physical activity**: 150 minutes/week moderate exercise (brisk walking, cycling)
- **Retest**: HbA1c in 6 months
- **Consider**: Consultation with registered dietitian

**Retest**: 6 months

---

#### Tier 3: Prediabetes (HbA1c 6.0-6.4%, Glucose 110-125 mg/dL)
**Priority**: HIGH PRIORITY 🟠 (Orange border)  
**Message**: "Prediabetes - Urgent Lifestyle Intervention Needed"

**Recommendations:**
- 🟠 **Prediabetes diagnosis** - High risk of progression to type 2 diabetes
- **Aggressive intervention can REVERSE this condition**
- **Weight loss goal**: 7-10% of body weight (strongest evidence)
- **Intensive dietary changes**:
  - Low glycemic diet (GI < 55)
  - Calorie restriction if overweight
  - High fiber (30-35g daily)
  - Eliminate sugary beverages
  - Portion control
- **Exercise prescription**:
  - **Minimum**: 150 minutes/week moderate activity
  - **Target**: 300 minutes/week for better results
  - Include resistance training 2-3x/week
- **Medical evaluation**:
  - Discuss **metformin** with physician (especially if BMI ≥ 35, age < 60, or history of gestational diabetes)
  - Screen for complications (retinopathy, nephropathy)
  - Check lipid panel, blood pressure, kidney function
- **Continuous glucose monitor** (CGM): Consider for real-time feedback
- **Retest**: HbA1c in 3 months

**Retest**: 3 months  
**Clinical Follow-Up**: Physician visit within 2-4 weeks

---

#### Tier 4: Diabetes (HbA1c 6.5-7.9%, Glucose 126-199 mg/dL)
**Priority**: URGENT 🔴 (Red border)  
**Message**: "Diabetes Range - Immediate Physician Referral Required"

**Recommendations:**
- 🔴 **URGENT**: Your labs indicate **type 2 diabetes**
- **⚠️ DO NOT attempt self-management without physician guidance**
- **Immediate next steps**:
  1. **Schedule physician appointment THIS WEEK** (primary care or endocrinologist)
  2. Confirm diagnosis with repeat HbA1c or fasting glucose
  3. Discuss medication options (metformin, GLP-1 agonists, etc.)
  4. Comprehensive diabetes education program
- **Screening for complications**:
  - Eye exam (retinopathy screening)
  - Kidney function tests (creatinine, urine albumin)
  - Foot examination (neuropathy check)
  - Lipid panel (cardiovascular risk)
  - Blood pressure monitoring
- **Lifestyle foundation** (in addition to medications):
  - Medical nutrition therapy with certified diabetes educator
  - Structured exercise program
  - Self-monitoring of blood glucose (SMBG)
  - Continuous glucose monitor (CGM) if appropriate
- **Target HbA1c**: Discuss with physician (typically < 7.0% for most adults)
- **Retest**: HbA1c in 3 months after starting treatment

**Retest**: 3 months (with medication)  
**Clinical Follow-Up**: **URGENT - Within 1 week**

**⚠️ Note**: This report is NOT a diabetes diagnosis tool. Diabetes must be confirmed by a physician with repeat testing.

---

#### Tier 5: High-Risk Diabetes (HbA1c ≥ 8.0%, Glucose ≥ 200 mg/dL)
**Priority**: CRITICAL 🔴 (Red border, bold)  
**Message**: "Severe Hyperglycemia - Urgent Medical Attention Required"

**Recommendations:**
- 🔴 **CRITICAL**: Your glucose levels indicate **severe hyperglycemia**
- **⚠️ CALL YOUR DOCTOR TODAY OR GO TO URGENT CARE**
- **Immediate physician evaluation required:**
  - Risk of diabetic ketoacidosis (DKA) or hyperosmolar state
  - May require immediate medication adjustment or hospitalization
  - Comprehensive metabolic panel and kidney function tests needed
- **DO NOT delay medical care**
- **DO NOT attempt lifestyle changes alone** - medication is essential
- **Symptoms to watch** (seek emergency care if present):
  - Excessive thirst or urination
  - Unexplained weight loss
  - Blurred vision
  - Confusion or difficulty concentrating
  - Fruity breath odor
  - Nausea or vomiting
- **After medical stabilization**:
  - Intensive diabetes management program
  - Close monitoring (possibly CGM + insulin therapy)
  - Aggressive screening for complications
  - Frequent follow-up with endocrinologist

**Retest**: As directed by physician (likely weekly initially)  
**Clinical Follow-Up**: **IMMEDIATE - Contact physician today**

**⚠️ IMPORTANT**: If you have symptoms of hyperglycemia (excessive thirst, frequent urination, blurred vision), seek emergency medical care immediately.

---

#### Missing Data Scenario
**Priority**: DATA COLLECTION 📊 (Blue border)  
**Message**: "Glucose Screening Recommended"

**Recommendations:**
- 📊 **HbA1c and fasting glucose testing recommended**
- Diabetes screening is recommended for:
  - All adults age 35 and older
  - Adults with BMI ≥ 25 and one or more risk factors:
    - Family history of diabetes
    - High-risk ethnicity (African American, Latino, Native American, Asian American, Pacific Islander)
    - History of gestational diabetes
    - Hypertension or on blood pressure medication
    - HDL < 35 mg/dL or triglycerides > 250 mg/dL
    - Physical inactivity
    - Polycystic ovary syndrome (PCOS)
- **Tests to request**:
  - HbA1c (glycated hemoglobin) - preferred
  - Fasting plasma glucose (8-hour fast)
  - Optional: Fasting insulin (for insulin resistance assessment)
- **Next steps**: Schedule lab work with your physician or local lab

---

## 3. Technical Pattern & Architecture

### 3.1 Shared Helper Module

**File**: `src/hba1c-dynamic.ts` (NEW FILE)

**Module Structure** (Following LDL/Vitamin D Pattern):

```typescript
// ============================================================================
// src/hba1c-dynamic.ts - Shared HbA1c/Glucose Dynamic Recommendation Logic
// ============================================================================
// Purpose: Pure functions for glycemic control assessment and recommendation generation
// Pattern: Mirrored from src/ldl-dynamic.ts
// Status: Preview only (PREVIEW_DYNAMIC_HBA1C flag)
// ============================================================================

/**
 * Clinical Classification Thresholds (ADA 2024 Guidelines)
 */
export const HBA1C_THRESHOLDS = {
  NORMAL: 5.7,                   // < 5.7%: Normal
  ELEVATED_NORMAL: 6.0,          // 5.7-5.9%: Elevated-Normal
  PREDIABETES: 6.5,              // 6.0-6.4%: Prediabetes
  HIGH_RISK_DIABETES: 8.0,       // ≥ 8.0%: High-Risk Diabetes
} as const;

export const GLUCOSE_THRESHOLDS = {
  NORMAL: 100,                   // < 100 mg/dL: Normal
  ELEVATED_NORMAL: 110,          // 100-109 mg/dL: Elevated-Normal
  PREDIABETES: 126,              // 110-125 mg/dL: Prediabetes
  HIGH_RISK_DIABETES: 200,       // ≥ 200 mg/dL: High-Risk Diabetes
} as const;

export const DIABETES_RISK_GATE_THRESHOLD = 0.15; // 15% risk score

/**
 * Clinical Status Types
 */
export type GlycemicStatus = 
  | 'normal'
  | 'elevated_normal'
  | 'prediabetes'
  | 'diabetes'
  | 'high_risk_diabetes';

/**
 * Card Result Interface
 */
export interface HbA1cCardResult {
  success: boolean;
  shown: boolean;
  hba1cValue: number | null;
  fastingGlucoseValue: number | null;
  diabetesRiskScore: number | null;
  status: GlycemicStatus | null;
  priority: 'optimal' | 'watch' | 'high' | 'urgent' | 'critical' | null;
  html: string;
  fingerprint?: string;
}

/**
 * Extract HbA1c value from probe input
 */
export function extractHbA1cValue(probeInput: any): number | null {
  const biomarkers = probeInput?.biomarkers;
  if (!biomarkers || typeof biomarkers !== 'object') return null;
  
  const hba1c = biomarkers.hba1c ?? biomarkers.HbA1c ?? biomarkers.a1c;
  if (typeof hba1c === 'number' && hba1c >= 3.0 && hba1c <= 15.0) {
    return hba1c;
  }
  if (typeof hba1c === 'string') {
    const parsed = parseFloat(hba1c);
    if (!isNaN(parsed) && parsed >= 3.0 && parsed <= 15.0) {
      return parsed;
    }
  }
  return null;
}

/**
 * Extract fasting glucose value from probe input
 */
export function extractFastingGlucose(probeInput: any): number | null {
  const biomarkers = probeInput?.biomarkers;
  if (!biomarkers || typeof biomarkers !== 'object') return null;
  
  const glucose = biomarkers.glucose ?? biomarkers.fastingGlucose ?? biomarkers.fasting_glucose;
  if (typeof glucose === 'number' && glucose >= 40 && glucose <= 400) {
    return glucose;
  }
  if (typeof glucose === 'string') {
    const parsed = parseFloat(glucose);
    if (!isNaN(parsed) && parsed >= 40 && parsed <= 400) {
      return parsed;
    }
  }
  return null;
}

/**
 * Extract diabetes risk score from probe input
 */
export function extractDiabetesRisk(probeInput: any): number | null {
  const risk = probeInput?.risk;
  if (!risk || typeof risk !== 'object') return null;
  
  const diabetesRisk = risk.diabetes ?? risk.diabetesRisk ?? risk.diabetes_risk;
  if (typeof diabetesRisk === 'number' && diabetesRisk >= 0 && diabetesRisk <= 1) {
    return diabetesRisk;
  }
  if (typeof diabetesRisk === 'string') {
    const parsed = parseFloat(diabetesRisk);
    if (!isNaN(parsed) && parsed >= 0 && parsed <= 1) {
      return parsed;
    }
  }
  return null;
}

/**
 * Classify glycemic status based on HbA1c and/or glucose
 */
export function classifyGlycemicStatus(
  hba1c: number | null,
  glucose: number | null
): GlycemicStatus | null {
  // Priority: Use HbA1c if available (more reliable)
  if (hba1c !== null) {
    if (hba1c >= HBA1C_THRESHOLDS.HIGH_RISK_DIABETES) return 'high_risk_diabetes';
    if (hba1c >= HBA1C_THRESHOLDS.PREDIABETES) return 'diabetes';
    if (hba1c >= HBA1C_THRESHOLDS.ELEVATED_NORMAL) return 'prediabetes';
    if (hba1c >= HBA1C_THRESHOLDS.NORMAL) return 'elevated_normal';
    return 'normal';
  }
  
  // Fallback: Use glucose if HbA1c not available
  if (glucose !== null) {
    if (glucose >= GLUCOSE_THRESHOLDS.HIGH_RISK_DIABETES) return 'high_risk_diabetes';
    if (glucose >= GLUCOSE_THRESHOLDS.PREDIABETES) return 'diabetes';
    if (glucose >= GLUCOSE_THRESHOLDS.ELEVATED_NORMAL) return 'prediabetes';
    if (glucose >= GLUCOSE_THRESHOLDS.NORMAL) return 'elevated_normal';
    return 'normal';
  }
  
  return null;
}

/**
 * Determine if card should be shown
 */
export function shouldShowHbA1cCard(
  hba1c: number | null,
  glucose: number | null,
  diabetesRisk: number | null
): boolean {
  // Show if HbA1c elevated
  if (hba1c !== null && hba1c >= HBA1C_THRESHOLDS.NORMAL) return true;
  
  // Show if glucose elevated
  if (glucose !== null && glucose >= GLUCOSE_THRESHOLDS.NORMAL) return true;
  
  // Show if high diabetes risk despite normal labs
  if (diabetesRisk !== null && diabetesRisk >= DIABETES_RISK_GATE_THRESHOLD) return true;
  
  // Show data collection card if no labs but high-risk factors exist
  // (This logic could be enhanced to check BMI, family history, etc.)
  if (hba1c === null && glucose === null && diabetesRisk !== null && diabetesRisk >= 0.10) {
    return true; // Show "get tested" card
  }
  
  return false;
}

/**
 * Get priority level based on status
 */
export function getPriorityLevel(status: GlycemicStatus | null): string {
  if (status === null) return 'data_collection';
  if (status === 'high_risk_diabetes' || status === 'diabetes') return 'urgent';
  if (status === 'prediabetes') return 'high';
  if (status === 'elevated_normal') return 'watch';
  return 'optimal';
}

/**
 * Generate HTML for glycemic control card
 */
export function generateHbA1cCardHTML(
  hba1c: number | null,
  glucose: number | null,
  status: GlycemicStatus | null,
  priority: string
): string {
  // Implementation similar to LDL/Vitamin D pattern
  // Returns full HTML card based on status tier
  // ... (detailed HTML generation logic)
}

/**
 * Main function: Build complete HbA1c card result
 */
export function buildHbA1cCardResult(probeInput: any): HbA1cCardResult {
  const hba1c = extractHbA1cValue(probeInput);
  const glucose = extractFastingGlucose(probeInput);
  const diabetesRisk = extractDiabetesRisk(probeInput);
  
  const status = classifyGlycemicStatus(hba1c, glucose);
  const shown = shouldShowHbA1cCard(hba1c, glucose, diabetesRisk);
  const priority = getPriorityLevel(status);
  
  const html = shown ? generateHbA1cCardHTML(hba1c, glucose, status, priority) : '';
  
  const fingerprint = `hba1c-${Date.now().toString(36)}-${Math.random().toString(36).substring(2, 9)}`;
  
  return {
    success: true,
    shown,
    hba1cValue: hba1c,
    fastingGlucoseValue: glucose,
    diabetesRiskScore: diabetesRisk,
    status,
    priority: shown ? priority : null,
    html,
    fingerprint,
  };
}
```

---

### 3.2 Preview Probe Endpoint

**Endpoint**: `POST /api/report/preview/hba1c`  
**Location**: `src/index.tsx` (insert after Vitamin D probe, before `/report` route)

**Request Shape**:
```json
{
  "biomarkers": {
    "hba1c": 6.2,           // HbA1c percentage (optional)
    "glucose": 115,         // Fasting glucose mg/dL (optional)
    "insulin": 12.5         // Fasting insulin μU/mL (optional, for future HOMA-IR)
  },
  "risk": {
    "diabetes": 0.18        // Diabetes risk score 0-1 (optional)
  }
}
```

**Response Shape** (Success):
```json
{
  "success": true,
  "shown": true,
  "hba1cValue": 6.2,
  "fastingGlucoseValue": 115,
  "diabetesRiskScore": 0.18,
  "status": "prediabetes",
  "priority": "high",
  "html": "<section class='...'>...</section>",
  "fingerprint": "hba1c-l9x3k2-a4b7c9"
}
```

**Response Shape** (No Data/Low Risk):
```json
{
  "success": true,
  "shown": false,
  "hba1cValue": null,
  "fastingGlucoseValue": null,
  "diabetesRiskScore": null,
  "status": null,
  "priority": null,
  "html": "",
  "fingerprint": "hba1c-l9x3k2-a4b7c9"
}
```

**Authentication**: Basic Auth (same as LDL/Vitamin D probes)  
**Tenant**: `X-Tenant-ID` header required  
**Database**: NO DB access (pure computation only)

---

### 3.3 Main Report Integration

**Function**: `generateDynamicHbA1cCard()` (NEW FUNCTION in `src/index.tsx`)  
**Location**: Insert after `generateDynamicVitaminDCard()`, before `generateATMSection()`

**Integration Point** (Report HTML):
```typescript
// Around line ~3990-4000 (after Vitamin D card, before action plan)
${PREVIEW_DYNAMIC_HBA1C ? generateDynamicHbA1cCard() : ''}
```

**Function Signature**:
```typescript
function generateDynamicHbA1cCard(): string {
  if (!comprehensiveData) {
    return ''; // No data, hide card
  }
  
  const probeInput = {
    biomarkers: {
      hba1c: comprehensiveData.biomarkers?.hba1c || null,
      glucose: comprehensiveData.biomarkers?.glucose || null,
      insulin: comprehensiveData.biomarkers?.insulin || null,
    },
    risk: {
      diabetes: comprehensiveData.risks?.diabetes || null,
    },
  };
  
  const result = buildHbA1cCardResult(probeInput);
  
  return result.shown ? result.html : '';
}
```

---

### 3.4 Feature Flag

**Flag Name**: `PREVIEW_DYNAMIC_HBA1C`  
**Location**: `src/index.tsx` (near line ~1310, after `PREVIEW_DYNAMIC_VITAMIN_D`)  
**Default**: `true` (enabled in preview branch)

```typescript
// Feature Flags for Preview Dynamic Features
const PREVIEW_DYNAMIC_LDL = true;
const PREVIEW_DYNAMIC_VITAMIN_D = true;
const PREVIEW_DYNAMIC_HBA1C = true;  // NEW FLAG
```

**Production Flag** (Future):
- Name: `ENABLE_DYNAMIC_HBA1C` or `FEATURE_HBA1C_PERSONALIZATION`
- Source: Environment variable in Cloudflare Pages settings
- Default: `false` (off until production checklist completed)

---

## 4. Testing Strategy

### 4.1 Testing Documentation

**File**: `TESTING_HBA1C.md` (NEW FILE, to be created in implementation phase)

**Contents** (Similar to `TESTING_VITAMIN_D.md`):
- Overview of dynamic HbA1c feature
- Prerequisites (preview password, base URL, tenant ID)
- PowerShell test examples
- cURL test examples
- Expected response shapes
- Troubleshooting guide

---

### 4.2 Probe Endpoint Test Scenarios

**Test Case 1: Empty Body (No Data)**
- **Input**: `{}`
- **Expected**: `success=true, shown=false, hba1cValue=null, status=null`
- **Purpose**: Verify graceful handling of missing data

---

**Test Case 2: Normal Glycemic Control (HbA1c 5.3%)**
- **Input**: `{"biomarkers": {"hba1c": 5.3}}`
- **Expected**: 
  - `shown=false` (optimal, no card needed)
  - `status="normal"`
  - `priority="optimal"`
- **Purpose**: Verify card is hidden for low-risk patients

---

**Test Case 3: Elevated-Normal (HbA1c 5.8%, Glucose 105 mg/dL)**
- **Input**: `{"biomarkers": {"hba1c": 5.8, "glucose": 105}}`
- **Expected**:
  - `shown=true`
  - `status="elevated_normal"`
  - `priority="watch"`
  - HTML contains "⚠️ WATCH" and lifestyle modification advice
- **Purpose**: Verify early warning for increased risk

---

**Test Case 4: Prediabetes (HbA1c 6.2%, Glucose 118 mg/dL)**
- **Input**: `{"biomarkers": {"hba1c": 6.2, "glucose": 118}}`
- **Expected**:
  - `shown=true`
  - `status="prediabetes"`
  - `priority="high"`
  - HTML contains "🟠 HIGH PRIORITY", "Prediabetes", weight loss goal, retest in 3 months
- **Purpose**: Verify prediabetes intervention recommendations

---

**Test Case 5: Diabetes (HbA1c 7.2%, Glucose 145 mg/dL)**
- **Input**: `{"biomarkers": {"hba1c": 7.2, "glucose": 145}}`
- **Expected**:
  - `shown=true`
  - `status="diabetes"`
  - `priority="urgent"`
  - HTML contains "🔴 URGENT", "Diabetes Range", "Immediate Physician Referral"
- **Purpose**: Verify urgent referral for diabetes range

---

**Test Case 6: High-Risk Diabetes (HbA1c 9.5%, Glucose 250 mg/dL)**
- **Input**: `{"biomarkers": {"hba1c": 9.5, "glucose": 250}}`
- **Expected**:
  - `shown=true`
  - `status="high_risk_diabetes"`
  - `priority="critical"`
  - HTML contains "🔴 CRITICAL", "Severe Hyperglycemia", "CALL YOUR DOCTOR TODAY"
- **Purpose**: Verify critical alert for severe hyperglycemia

---

**Test Case 7: Glucose Only (No HbA1c)**
- **Input**: `{"biomarkers": {"glucose": 122}}`
- **Expected**:
  - `shown=true`
  - `status="prediabetes"` (based on glucose threshold)
  - Recommendation to get HbA1c for confirmation
- **Purpose**: Verify fallback to glucose-based classification

---

**Test Case 8: High Risk Score, Normal Labs**
- **Input**: `{"biomarkers": {"hba1c": 5.5, "glucose": 95}, "risk": {"diabetes": 0.18}}`
- **Expected**:
  - `shown=true` (high risk warrants monitoring)
  - `status="normal"`
  - HTML emphasizes prevention despite normal labs
- **Purpose**: Verify risk-based gating for high-risk patients

---

### 4.3 End-to-End Report Testing

**E2E Test Scenario 1: Normal Patient (No Card)**
- **Patient Profile**: Age 30, BMI 22, no family history
- **Labs**: HbA1c 5.2%, Glucose 88 mg/dL
- **Expected**: No HbA1c card displayed (optimal, low risk)

---

**E2E Test Scenario 2: Prediabetes Patient (High Priority Card)**
- **Patient Profile**: Age 55, BMI 32, family history of diabetes
- **Labs**: HbA1c 6.1%, Glucose 115 mg/dL
- **Expected**: 
  - Orange border card with "🟠 HIGH PRIORITY"
  - Weight loss recommendations (7-10% goal)
  - 150+ minutes/week exercise
  - Dietary changes (low GI, high fiber)
  - Retest in 3 months
  - Physician consultation for metformin

---

**E2E Test Scenario 3: Diabetes Patient (Urgent Card)**
- **Patient Profile**: Age 62, BMI 35, hypertension
- **Labs**: HbA1c 7.8%, Glucose 165 mg/dL
- **Expected**:
  - Red border card with "🔴 URGENT"
  - "Immediate Physician Referral Required"
  - No self-management advice (defers to physician)
  - Complication screening recommendations
  - "Schedule appointment THIS WEEK"

---

**E2E Test Scenario 4: Missing Labs, High Risk (Data Collection Card)**
- **Patient Profile**: Age 58, BMI 36, family history of diabetes
- **Labs**: None collected
- **Expected**:
  - Blue border card with "📊 DATA COLLECTION"
  - "Glucose Screening Recommended"
  - List of tests to request (HbA1c, fasting glucose)
  - Risk factors present (age, BMI, family history)

---

### 4.4 Automated Testing (Future)

**Unit Tests** (to be created):
- `extractHbA1cValue()` with various input shapes
- `classifyGlycemicStatus()` for all 5 tiers
- `shouldShowHbA1cCard()` with edge cases
- `getPriorityLevel()` mapping

**Integration Tests**:
- Probe endpoint with authentication
- Probe endpoint with invalid data
- Main report integration with feature flag on/off

---

## 5. Production Readiness Checklist

### 5.1 Checklist Document

**File**: `CHECKLIST_HBA1C_PRODUCTION.md` (NEW FILE, to be created after implementation)

**Structure** (Mirroring `CHECKLIST_LDL_PRODUCTION.md` and `CHECKLIST_VITAMIN_D_PRODUCTION.md`):

---

### Section 1: Functional Behavior
- [ ] **Gating logic verified:**
  - [ ] HbA1c gate: `hba1c ≥ 5.7%` OR
  - [ ] Glucose gate: `glucose ≥ 100 mg/dL` OR
  - [ ] Diabetes risk gate: `diabetesRisk ≥ 0.15`
- [ ] **5-tier classification verified:**
  - [ ] Normal: HbA1c < 5.7%, Glucose < 100
  - [ ] Elevated-Normal: HbA1c 5.7-5.9%, Glucose 100-109
  - [ ] Prediabetes: HbA1c 6.0-6.4%, Glucose 110-125
  - [ ] Diabetes: HbA1c 6.5-7.9%, Glucose 126-199
  - [ ] High-Risk Diabetes: HbA1c ≥ 8.0%, Glucose ≥ 200
- [ ] **Probe endpoint response shape verified:**
  - [ ] Returns: `{ success, shown, hba1cValue, fastingGlucoseValue, diabetesRiskScore, status, priority, html }`
  - [ ] Error responses follow standard format
- [ ] **Clinical content approved:**
  - [ ] Reviewed by endocrinologist or diabetes specialist
  - [ ] ADA 2024 guidelines cited and followed
  - [ ] Urgent referral language appropriate
  - [ ] Disclaimer present for diabetes diagnosis

---

### Section 2: Safety & Data Gating
- [ ] **Card shown only when clinically indicated**
- [ ] **Urgent cases trigger clear physician referral** (HbA1c ≥ 6.5% or glucose ≥ 126)
- [ ] **No self-management advice for diabetes range** (defers to physician)
- [ ] **No database writes in probe endpoint**
- [ ] **Feature flag controls card visibility**

---

### Section 3: Feature Flags & Configuration
- [ ] `PREVIEW_DYNAMIC_HBA1C` exists and is `true` in preview
- [ ] Production flag defined and defaults to `false`
- [ ] Rollback plan documented

---

### Section 4: Testing
- [ ] **8 probe test cases passed** (empty, normal, elevated, prediabetes, diabetes, high-risk, glucose-only, high-risk-normal-labs)
- [ ] **4 E2E report scenarios tested** (normal, prediabetes, diabetes, missing-labs)
- [ ] Automated tests written and passing

---

### Section 5: Security & Compliance
- [ ] No hard-coded secrets
- [ ] Basic Auth required
- [ ] PHI handling validated (HbA1c/glucose values secured)
- [ ] HIPAA compliance review completed

---

### Section 6: Observability & Logging
- [ ] Error logging for probe failures
- [ ] Monitoring for card generation errors
- [ ] Alerts configured

---

### Section 7: Documentation & Training
- [ ] `TESTING_HBA1C.md` completed
- [ ] Technical documentation complete
- [ ] Clinician-facing documentation prepared
- [ ] Training materials ready

---

### Section 8: Promotion Plan
- [ ] Merge strategy defined
- [ ] Deployment plan documented
- [ ] Rollback plan tested

---

### Section 9: Clinical & Regulatory Review
- [ ] **Clinical validation of 5-tier logic** (CRITICAL - requires endocrinologist sign-off)
- [ ] **Risk assessment for missed diabetes cases**
- [ ] **HIPAA compliance review**
- [ ] **Clinical sign-off obtained**

---

### Section 10: Final Sign-Off
- [ ] **Technical Lead**: Code review and architecture approval
- [ ] **Clinical Lead / Endocrinologist**: Medical accuracy and safety approval
- [ ] **Operations Lead**: Deployment and monitoring approval
- [ ] **Date Approved**: _____________

---

### 5.2 Key Verification Dimensions

**Functional Correctness:**
- 5-tier classification logic matches ADA guidelines
- Gating logic correctly identifies high-risk patients
- Probe endpoint returns correct structure

**Clinical Safety:**
- Urgent referral for diabetes range (HbA1c ≥ 6.5%, glucose ≥ 126)
- No self-management advice that could delay medical care
- Appropriate disclaimers about diagnosis confirmation

**Testing Coverage:**
- All 8 probe scenarios tested
- All 4 E2E report scenarios tested
- Edge cases handled (missing data, invalid values)

**Security & Compliance:**
- PHI properly secured
- HIPAA compliance validated
- No unauthorized data access

**Clinical Review:**
- **CRITICAL**: Endocrinologist or diabetes specialist must review
- ADA guidelines adherence verified
- Risk assessment for false negatives/positives

---

## 6. Open Questions & TODOs

### 6.1 Clinical Thresholds

**QUESTION 1**: Should we use slightly more conservative HbA1c thresholds?
- Current plan: 5.7% for elevated-normal (ADA guideline)
- Alternative: 5.5% for earlier intervention
- **Action**: Confirm with clinical lead during implementation

---

**QUESTION 2**: Should we calculate HOMA-IR for insulin resistance?
- Formula: `HOMA-IR = (fasting_glucose * fasting_insulin) / 405`
- Normal: < 2.0, Insulin resistant: ≥ 2.5
- **Action**: Decide if this adds value or complexity

---

**QUESTION 3**: Should we integrate BMI into gating logic?
- High BMI (≥ 35) with normal labs → show prevention card?
- **Action**: Review with clinical team

---

### 6.2 Data Integration

**QUESTION 4**: Where is diabetes risk score stored in comprehensive assessment?
- Line ~5519 calculates: `DiseaseRiskCalculator.calculateDiabetesRisk()`
- Is it stored in `comprehensiveData.risks.diabetes`?
- **Action**: Verify during implementation

---

**QUESTION 5**: Should we check for diabetes-related medications?
- Metformin, GLP-1 agonists, insulin, etc.
- If on medication, adjust card content?
- **Action**: Evaluate feasibility of medication checking

---

### 6.3 Report Integration

**QUESTION 6**: Where exactly should the HbA1c card appear?
- Current plan: After Vitamin D card, before action plan
- Alternative: In dedicated "Metabolic Health" section?
- **Action**: Review report structure with design team

---

**QUESTION 7**: Should we modify existing "Deregulated Nutrient Sensing" hallmark section?
- Line ~3577 mentions "fasting glucose, HbA1c levels"
- Coordinate with or replace with dynamic card?
- **Action**: Discuss during implementation

---

### 6.4 Edge Cases

**QUESTION 8**: What if HbA1c and glucose disagree?
- Example: HbA1c 5.5% (normal) but glucose 130 mg/dL (diabetes)
- Current logic: HbA1c takes priority
- Should we flag discrepancies?
- **Action**: Consult endocrinologist

---

**QUESTION 9**: How to handle very recent diagnosis?
- Patient already knows they have diabetes
- Show same card or different "management" card?
- **Action**: Consider in future iteration

---

**QUESTION 10**: Should we show card to patients already on diabetes medication?
- If on metformin with HbA1c 6.8%, show "continue treatment" card?
- **Action**: Evaluate in future phase (requires medication data)

---

### 6.5 Must Confirm with Human Owner

**BEFORE IMPLEMENTATION STARTS:**

1. **Clinical Thresholds**: Confirm ADA 2024 guideline thresholds are appropriate for this population
2. **Urgent Referral Language**: Approve exact wording for diabetes/high-risk tiers
3. **Medication Checking**: Decide if medication integration is in scope
4. **HOMA-IR Calculation**: Decide if insulin resistance index should be included
5. **Report Layout**: Confirm card placement in report structure
6. **Legal Review**: Ensure disclaimers are legally sufficient
7. **Endocrinologist Review**: Identify clinical reviewer for sign-off

---

## 7. Implementation Phases

### Phase 1: Core Implementation (Estimated: 3-5 days)
1. ✅ Create `DOC_HBA1C_DYNAMIC_PLAN.md` (this document) - **DONE**
2. ⏭️ Create `src/hba1c-dynamic.ts` shared helper module
3. ⏭️ Add `POST /api/report/preview/hba1c` probe endpoint
4. ⏭️ Add `PREVIEW_DYNAMIC_HBA1C` feature flag
5. ⏭️ Create `generateDynamicHbA1cCard()` function
6. ⏭️ Integrate card into main report

---

### Phase 2: Testing & Documentation (Estimated: 2-3 days)
7. ⏭️ Create `TESTING_HBA1C.md`
8. ⏭️ Manual probe testing (8 test cases)
9. ⏭️ E2E report testing (4 scenarios)
10. ⏭️ Bug fixes and refinements

---

### Phase 3: Production Preparation (Estimated: 2-3 days)
11. ⏭️ Create `CHECKLIST_HBA1C_PRODUCTION.md`
12. ⏭️ Clinical review with endocrinologist
13. ⏭️ Legal review of disclaimers
14. ⏭️ Security & compliance review
15. ⏭️ Final testing on Cloudflare Pages preview

---

### Phase 4: Production Enablement (Future)
16. ⏭️ Complete all 10 checklist sections
17. ⏭️ Obtain all 3 sign-offs (Technical, Clinical, Operations)
18. ⏭️ Enable in staging environment
19. ⏭️ Monitor for issues
20. ⏭️ Enable in production

---

## 8. Success Metrics

**Immediate (Implementation Complete):**
- ✅ All 8 probe test cases pass
- ✅ All 4 E2E report scenarios work correctly
- ✅ No errors in Cloudflare Pages preview environment
- ✅ Clinical team approves content

**Post-Launch (Production):**
- Percentage of patients with HbA1c/glucose data who see card
- Number of urgent referrals generated (diabetes range)
- Patient engagement with prediabetes recommendations
- Clinician feedback on usefulness
- No adverse events from incorrect recommendations

---

## 9. Related Documentation

### Completed Work (Reference Patterns)
- **`DOC_STATIC_CONTENT_INVENTORY.md`** - HbA1c identified as Phase 1 priority
- **`src/ldl-dynamic.ts`** - Shared helper module pattern (REFERENCE)
- **`src/vitaminD-dynamic.ts`** - Recent similar implementation
- **`TESTING_LDL.md`** - Probe testing pattern
- **`TESTING_VITAMIN_D.md`** - Recent similar testing doc
- **`CHECKLIST_LDL_PRODUCTION.md`** - Production readiness template
- **`CHECKLIST_VITAMIN_D_PRODUCTION.md`** - Recent similar checklist

### Implementation Dependencies
- `DiseaseRiskCalculator.calculateDiabetesRisk()` - Already implemented
- `assessmentData.glucose` - Already collected (line ~5442)
- `assessmentData.hba1c` - Already collected (line ~5443)
- `assessmentData.insulin` - Already collected (line ~5444)

---

## 10. Summary

### Key Decisions Made in This Plan

1. **5-tier classification system** based on ADA 2024 guidelines
2. **HbA1c prioritized over glucose** (more reliable, gold standard)
3. **Gating logic**: Show card if HbA1c ≥ 5.7%, glucose ≥ 100, or high diabetes risk
4. **Urgent referral** for HbA1c ≥ 6.5% or glucose ≥ 126 (diabetes range)
5. **No self-management advice for diabetes** (defers to physician)
6. **Follow LDL/Vitamin D pattern** (shared module, probe endpoint, feature flag)
7. **8 probe test scenarios + 4 E2E scenarios** for comprehensive testing
8. **Production checklist required** before enabling in production

### Technical Artifacts to Create

| Artifact | Type | Status | Estimated Effort |
|----------|------|--------|-----------------|
| `DOC_HBA1C_DYNAMIC_PLAN.md` | Documentation | ✅ **DONE** | N/A |
| `src/hba1c-dynamic.ts` | Code | ⏭️ Next | 1-2 days |
| `POST /api/report/preview/hba1c` | Code | ⏭️ Next | 0.5 days |
| `generateDynamicHbA1cCard()` | Code | ⏭️ Next | 0.5 days |
| `TESTING_HBA1C.md` | Documentation | ⏭️ Next | 1 day |
| `CHECKLIST_HBA1C_PRODUCTION.md` | Documentation | ⏭️ Later | 0.5 days |

### Clinical Review Required

**⚠️ CRITICAL**: Before production enablement, this feature MUST be reviewed and approved by:
- Endocrinologist or diabetes specialist
- Legal team (for disclaimers)
- Clinical operations team
- HIPAA compliance officer

### Next Immediate Step

**After this PR is merged:**
1. Create implementation branch: `fix/preview-dynamic-hba1c`
2. Start with `src/hba1c-dynamic.ts` (follow LDL pattern exactly)
3. Add probe endpoint and test locally
4. Create `TESTING_HBA1C.md` with PowerShell/cURL examples
5. Deploy to Cloudflare Pages preview and validate

---

**Document Status**: ✅ Planning Complete - Ready for Implementation Phase  
**Last Updated**: 2025-11-29  
**Next Review**: After implementation begins  
**Document Owner**: Technical Lead + Clinical Lead
