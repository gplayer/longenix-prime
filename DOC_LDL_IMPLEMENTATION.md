# DOC_LDL_IMPLEMENTATION.md – LonGenix-Prime LDL Implementation

**Last Updated:** 2025-11-28  
**Branch:** `fix/preview-dynamic-ldl`  
**Status:** Preview only (not in production)

---

## Overview

This document describes how LDL (Low-Density Lipoprotein) cholesterol management is currently implemented in the LonGenix-Prime health assessment system. The implementation consists of two main components:

1. **Preview Probe Endpoint** – A standalone testing endpoint for validating LDL logic
2. **Main Report Integration** – Dynamic LDL cards embedded in the comprehensive health report

Both implementations share similar logic for extracting LDL values, calculating ASCVD risk, and determining appropriate LDL targets based on cardiovascular risk levels.

---

## 1. Preview Probe Endpoint

### 1.1 Endpoint Wiring

**File:** `src/index.tsx`  
**Lines:** ~1101-1330 (approximately)  
**Route:** `POST /api/report/preview/ldl`

**Authentication:**
- Requires Basic Auth with credentials `preview:<PASSWORD>`
- Requires `X-Tenant-ID` header (must be one of: `demo-a`, `demo-b`, `demo-c`)

### 1.2 Main Functions

#### `app.post('/api/report/preview/ldl', async (c) => { ... })`
**Purpose:** Main endpoint handler that processes probe requests  
**Behavior:**
- Validates tenant authentication
- Performs defensive JSON parsing (accepts empty body `{}`)
- Applies self-contained helper functions to analyze LDL data
- Returns JSON response with gating decision, computed targets, and HTML preview
- **Critical Safety:** Contains DB Guard that warns if database binding is present but never accesses the database

#### `getLDLValueLocal(biomarkers: any): number | null`
**Purpose:** Extracts LDL cholesterol value from biomarkers object  
**Behavior:**
- Probes multiple common LDL key variants: `['ldl', 'ldl_c', 'ldlCholesterol', 'ldl_cholesterol', 'LDL']`
- Returns first valid numeric value found
- Returns `null` if no valid value is found
- Self-contained within probe endpoint (no external dependencies)

#### `getASCVDRiskLocal(riskObj: any): number | null`
**Purpose:** Extracts ASCVD (Atherosclerotic Cardiovascular Disease) 10-year risk score  
**Behavior:**
- Probes risk keys: `['ascvd', 'ascvd_risk', 'ASCVD']`
- Coerces percentages to decimal (e.g., 9 → 0.09) if value > 1
- Fallback: Maps `risk_level` strings to proxy values (`'low': 0.05, 'moderate': 0.10, 'high': 0.15, 'very_high': 0.25`)
- Returns decimal risk score (0-1 range) or `null`
- Self-contained within probe endpoint

#### `generateDynamicLDLCardLocal(ldlValue, ascvdRisk): { shown, ldlValue, ascvdRisk, ldlTarget, html }`
**Purpose:** Applies gating logic and generates dynamic LDL recommendation card  
**Behavior:**
- **Gating Logic:** Card is shown ONLY if `ldlValue > 100 OR ascvdRisk >= 0.075` (7.5%)
- **Dynamic Target Calculation:**
  - `ascvdRisk >= 0.20` → `ldlTarget = 70` mg/dL (very high risk)
  - `ascvdRisk >= 0.075` → `ldlTarget = 100` mg/dL (moderate-high risk)
  - `ascvdRisk < 0.075` or unknown → `ldlTarget = 130` mg/dL (low risk)
- Returns structured object with `shown` flag, computed values, and HTML card
- HTML includes `data-test="ldl-card"` attribute for test automation

### 1.3 Response Schema

**Success Response (HTTP 200):**
```json
{
  "success": true,
  "shown": true,
  "ldlValue": 145,
  "ascvdRisk": 0.09,
  "ldlTarget": 100,
  "html": "<section data-test=\"ldl-card\">...</section>"
}
```

**Error Responses:**
- **400** – Missing or invalid tenant
- **422** – Invalid JSON or request body shape
- **500** – Unexpected system error (includes fingerprint for tracking)

---

## 2. Main Report Integration

### 2.1 Report Rendering

**File:** `src/index.tsx`  
**Lines:** ~1420-1560 (feature flag and helpers), ~3939 (HTML injection point)  
**Route:** `GET /report?session=<sessionId>&demo=<true|false>`

**Feature Flag:**
```typescript
const PREVIEW_DYNAMIC_LDL = true
```
Located at line ~1420 within the `/report` route handler. When `false`, the LDL card is not rendered at all.

### 2.2 Helper Functions (Report Context)

These functions are defined within the `/report` route scope and have access to `comprehensiveData` and `risks` objects.

#### `getLDLValue(): number | null`
**Purpose:** Extracts LDL value from comprehensive patient data  
**Behavior:**
- Probes keys: `['ldlCholesterol', 'ldl_cholesterol', 'ldl', 'ldl_c', 'LDL']`
- Searches in three locations in order:
  1. `comprehensiveData.biomarkers[key]`
  2. `comprehensiveData.clinical[key]`
  3. `comprehensiveData[key]` (root level)
- Returns first valid numeric value or `null`

#### `getASCVDRisk(): number | null`
**Purpose:** Extracts ASCVD risk from calculated risk results  
**Behavior:**
- Searches `risks.results` array for cardiovascular risk entry (categories: `'cardiovascular'`, `'ascvd'`, `'cvd'`)
- Extracts `risk_score` if available (numeric 0-1 range)
- Fallback: Maps `risk_level` string to proxy numeric value
- Returns decimal risk score or `null`

#### `generateDynamicLDLCard(): string`
**Purpose:** Generates HTML for dynamic LDL recommendation card  
**Behavior:**
- Checks feature flag `PREVIEW_DYNAMIC_LDL` (returns empty string if disabled)
- Calls `getLDLValue()` and `getASCVDRisk()` to retrieve patient data
- Applies same gating logic as probe endpoint: `ldlValue > 100 OR ascvdRisk >= 0.075`
- Computes dynamic target using identical thresholds (70/100/130 mg/dL)
- Returns HTML string with `data-test="ldl-card"` wrapper
- HTML includes:
  - Red-themed card with heart icon
  - Current LDL value and target
  - "Preview dynamic" label
  - Nutritional interventions (fiber, plant sterols, healthy fats, fatty fish)
  - Clinical discussion options (bergamot, psyllium, omega-3)
  - **No dosing claims** (removed for safety)
  - **No red yeast rice** (removed due to contraindication risk)

### 2.3 HTML Injection Point

**Location:** Line ~3939 in `src/index.tsx`

The LDL card is injected within the "High Priority Interventions" section of the HTML report:

```typescript
<div class="bg-red-50 border-l-4 border-red-500 rounded-lg p-6 mb-8">
    <h3 class="text-lg font-semibold text-red-800 mb-4">
        <i class="fas fa-exclamation-circle mr-2"></i>High Priority Interventions
    </h3>
    <div class="space-y-6">
        ${generateDynamicLDLCard()}
        <!-- Other high-priority cards follow -->
    </div>
</div>
```

**Rendering Logic:**
- If `PREVIEW_DYNAMIC_LDL = false` → empty string, no card appears
- If LDL value is missing or doesn't meet gating criteria → empty string, no card appears
- If gating criteria met → full HTML card is rendered

---

## 3. Feature Flags & Configuration

### 3.1 Feature Flags

**Name:** `PREVIEW_DYNAMIC_LDL`  
**Type:** Boolean constant  
**Location:** `src/index.tsx` line ~1420 (within `/report` route)  
**Default Value:** `true`  
**Purpose:** Controls whether dynamic LDL card is rendered in main report

**How It's Checked:**
```typescript
function generateDynamicLDLCard(): string {
  if (!PREVIEW_DYNAMIC_LDL) return ''
  // ... rest of logic
}
```

**Scope:** This flag only affects the main `/report` route. The probe endpoint (`/api/report/preview/ldl`) is always active and does not check this flag.

### 3.2 Configuration Constants

**Allowed Tenants:**
```typescript
const ALLOWED_TENANTS = ['demo-a', 'demo-b', 'demo-c']
```
Located near the top of `src/index.tsx`. Used for tenant validation in both probe endpoint and main assessment routes.

**LDL Key Probing Order:**
```typescript
// Probe endpoint
const ldlKeys = ['ldl', 'ldl_c', 'ldlCholesterol', 'ldl_cholesterol', 'LDL']

// Main report
const ldlKeys = ['ldlCholesterol', 'ldl_cholesterol', 'ldl', 'ldl_c', 'LDL']
```
Note: Slightly different order between probe and report (probe prefers short keys, report prefers camelCase).

**ASCVD Risk Level Mapping:**
```typescript
const riskLevelMap: Record<string, number> = {
  'low': 0.05,
  'moderate': 0.10,
  'high': 0.15,
  'very_high': 0.25
}
```
Used as fallback when numeric ASCVD risk score is not available.

**LDL Target Thresholds:**
- `ascvdRisk >= 0.20` → `70 mg/dL` (very high cardiovascular risk)
- `ascvdRisk >= 0.075` → `100 mg/dL` (moderate-high risk)
- `ascvdRisk < 0.075` → `130 mg/dL` (low risk or unknown)

### 3.3 Gating Conditions

**Show LDL Card When:**
```typescript
ldlValue > 100 OR ascvdRisk >= 0.075
```

This ensures the card only appears when clinically indicated (elevated LDL or significant cardiovascular risk).

---

## 4. Related Modules & Dependencies

### 4.1 Medical Algorithms Module

**File:** `src/medical-algorithms.ts`  
**Class:** `DiseaseRiskCalculator`  
**Relevant Method:** `calculateASCVDRisk(patientData)`

**Usage:** Called during assessment processing to compute ASCVD risk scores that are stored in the `risks` object. The LDL implementation reads these pre-calculated risk scores rather than computing them directly.

**Lines in index.tsx:** ~5459, ~6114 (within assessment and demo data generation)

### 4.2 Database Schema

The LDL implementation reads from but does not modify the database. Relevant tables:

**Tables Referenced:**
- `assessment_sessions` – Session metadata
- `patients` – Patient demographics
- `risk_calculations` – Pre-calculated ASCVD risk scores

**Biomarker Fields:**
- `ldlCholesterol` (preferred field name)
- `ldl_cholesterol` (snake_case variant)
- May also appear in raw `comprehensiveData` JSON blobs

**Important:** The probe endpoint (`/api/report/preview/ldl`) intentionally does NOT access the database and operates entirely on mock request data.

---

## 5. Tests & Documentation

### 5.1 Test Files

**Unit/Integration Tests:**
- No Jest or other automated test files currently exist for LDL-specific logic
- Test coverage is manual via documentation and probe endpoint

**Note:** The only test files found in the repository are within `node_modules` and Wrangler templates. No application-level tests exist yet for LDL functionality.

### 5.2 Documentation Files

#### `TESTING_DYNAMIC_LDL_PROBE.md`
**Branch:** `fix/preview-dynamic-ldl`  
**Purpose:** Comprehensive testing guide for the probe endpoint  
**Contents:**
- Request/response schemas
- 4 detailed test scenarios (A-D) with expected outcomes
- PowerShell and curl command examples
- Multi-key probing validation
- Error case testing
- Verification checklist

**Scenarios Covered:**
- **A:** High LDL (145 mg/dL), no ASCVD data → shown=true, target=130
- **B:** Moderate ASCVD risk (9%) → shown=true, target=100
- **C:** Very high ASCVD risk (25%) → shown=true, target=70
- **D:** Low LDL + low risk → shown=false

#### `TESTING_DYNAMIC_LDL.md`
**Branch:** `fix/preview-dynamic-ldl`  
**Purpose:** End-to-end testing guide for main report integration  
**Contents:**
- Overview of Dynamic Fix Pack #1
- 4 test scenarios for full assessment workflow
- PowerShell examples for submitting assessment data
- Expected report behavior verification
- Steps to verify card visibility and target computation

#### `TESTING_LDL.md`
**Branch:** `fix/preview-ldl-testing`  
**Purpose:** Simplified probe endpoint testing guide  
**Contents:**
- Quick reference for preview-only LDL probe
- PowerShell and curl examples for 4 test cases
- Placeholder documentation for preview passwords
- Security warnings (do not commit actual passwords)

#### `PATCH_DYNAMIC_LDL.diff`
**Branch:** `fix/preview-dynamic-ldl`  
**Purpose:** Git diff file showing exact code changes for dynamic LDL implementation  
**Contents:**
- Complete diff of changes made to `src/index.tsx`
- Useful for code review and understanding implementation details

---

## 6. Open Questions / TODOs

### 6.1 Discrepancies

**Key Probing Order Difference:**
- Probe endpoint: `['ldl', 'ldl_c', 'ldlCholesterol', 'ldl_cholesterol', 'LDL']`
- Main report: `['ldlCholesterol', 'ldl_cholesterol', 'ldl', 'ldl_c', 'LDL']`

**Question:** Should these be unified for consistency? Does the order preference reflect different data sources (API input vs. database schema)?

### 6.2 Missing Test Coverage

**Automated Tests:**
- No Jest, Vitest, or Playwright tests exist for LDL logic
- All validation is currently manual via probe endpoint and documentation

**Recommendation:** Consider adding automated tests for:
- `getLDLValue()` key probing logic
- `getASCVDRisk()` extraction and fallback behavior
- Gating logic (edge cases around 100 mg/dL and 7.5% risk thresholds)
- Target computation (70/100/130 boundary conditions)

### 6.3 Feature Flag Strategy

**Current State:**
- `PREVIEW_DYNAMIC_LDL` is a hard-coded boolean constant
- Not configurable via environment variables or runtime config

**Question:** Should this be promoted to an environment variable (`env.PREVIEW_DYNAMIC_LDL`) to allow runtime toggling without code changes?

### 6.4 Duplication Between Probe and Report

**Current Implementation:**
- Probe endpoint defines `getLDLValueLocal()`, `getASCVDRiskLocal()`, `generateDynamicLDLCardLocal()` as self-contained functions
- Main report defines similar functions: `getLDLValue()`, `getASCVDRisk()`, `generateDynamicLDLCard()`
- Logic is nearly identical but duplicated

**Question:** Should these be refactored into shared utility functions to reduce duplication and ensure consistency? Or is the duplication intentional to keep probe endpoint completely isolated?

### 6.5 ASCVD Risk Calculation Timing

**Current Flow:**
1. `DiseaseRiskCalculator.calculateASCVDRisk()` is called during assessment processing
2. Result is stored in `risk_calculations` table
3. LDL helpers read pre-calculated risk from database

**Question:** For preview/demo mode with `DRY_RUN=true`, are ASCVD risk calculations actually performed and stored? Or are demo risk scores hard-coded?

### 6.6 Production Readiness

**Current Status:** Preview only (not in production)

**Blockers for Production:**
- Clinical review required for recommendation text
- Validation needed for ASCVD risk thresholds (7.5%, 20%)
- Confirmation that LDL target guidelines align with clinical standards
- Decision on whether to show card when ASCVD risk is unknown but LDL > 100

---

## 7. Summary

The LDL implementation in LonGenix-Prime consists of:

1. **Preview Probe Endpoint** (`POST /api/report/preview/ldl`) – A standalone, database-free testing endpoint that accepts mock LDL and ASCVD data and returns gating decisions, computed targets, and HTML previews.

2. **Main Report Integration** – A feature-flagged dynamic LDL card embedded in the comprehensive health report that reads real patient data, applies clinical gating logic, and renders personalized cholesterol management recommendations.

3. **Shared Logic Patterns** – Both implementations use similar key-probing strategies, risk extraction, and target computation algorithms, though the code is currently duplicated rather than shared.

4. **Comprehensive Documentation** – Three testing guides cover probe endpoint validation, end-to-end workflows, and quick reference examples.

5. **Safety Features** – Probe endpoint includes DB guard, defensive parsing, proper error codes, and no PHI in responses. Main report includes feature flag, data-gated rendering, and removal of unsafe content (red yeast rice, dosing claims).

The current implementation is preview-only and requires further clinical validation, automated testing, and architectural decisions before production deployment.

---

**End of Document**
