# TESTING GUIDE: Omega-3/EPA+DHA Dynamic Personalization (Preview)

**Feature**: Dynamic Fix Pack #4 – Omega-3 / EPA+DHA Supplementation  
**Branch**: `fix/preview-dynamic-omega3` (off `feat/my-first-mods-preview`)  
**Status**: Implementation Complete, Testing Phase  
**Date**: 2025-11-29

---

## What Changed

### Before (Static)
- **Universal dosing**: "2-3g EPA/DHA daily" for ALL patients
- **Always-on**: Appeared in action plan for everyone
- **No personalization**: Same recommendation regardless of triglyceride levels, ASCVD risk, dietary intake, or contraindications
- **No safety checking**: No warnings for anticoagulants or bleeding disorders

### After (Dynamic)
- **Data-gated recommendations**: Adapt based on:
  - Triglycerides (normal vs borderline vs high vs very high)
  - ASCVD risk (low vs moderate vs high)
  - Omega-3 Index (if available)
  - Dietary fish intake (if available)
  - Contraindications (bleeding disorders, upcoming surgery)
  - Caution factors (anticoagulants, antiplatelet agents)
- **6-Tier System**: 
  - **Tier 0**: Contraindicated (bleeding disorder, surgery)
  - **Tier 1**: High-Priority (TG ≥ 200 mg/dL or high ASCVD + elevated TG)
  - **Tier 2**: Moderate-Priority (TG 150-199 mg/dL or moderate ASCVD)
  - **Tier 3**: Dietary Emphasis (TG < 150 mg/dL, low risk, high fish intake)
  - **Tier 4**: Caution (anticoagulants/antiplatelet agents)
  - **Tier 5**: No Recommendation (Omega-3 Index ≥ 8% or already taking ≥ 2g/day)
- **Safety warnings**: Contraindication and caution cards with physician consultation requirements
- **Prescription referral**: For TG ≥ 500 mg/dL (Vascepa/Lovaza)

---

## Implementation Details

### Key Components
- **Shared Helper Module**: `src/omega3-dynamic.ts` (618 lines)
- **Preview Probe Endpoint**: `POST /api/report/preview/omega3`
- **Feature Flag**: `PREVIEW_DYNAMIC_OMEGA3 = true` (preview-only, hard-coded)
- **Main Report Integration**: `generateDynamicOmega3Card()` in `src/index.tsx`

### Clinical Thresholds (AHA/ACC Guidelines)
- **Triglycerides**:
  - Very High: ≥ 500 mg/dL (prescription omega-3 required)
  - High: 200-499 mg/dL (high-dose supplementation)
  - Borderline High: 150-199 mg/dL (moderate-dose supplementation)
  - Normal: < 150 mg/dL (dietary emphasis)
- **ASCVD Risk**:
  - High: ≥ 15%
  - Moderate: 7.5-15%
  - Low: < 7.5%
- **Omega-3 Index**:
  - Optimal: ≥ 8%

---

## Prerequisites

**Preview Environment Access:**
- **Base URL**: `https://longenix-preview.pages.dev`
- **Tenant**: `demo-a`, `demo-b`, or `demo-c` (use query param `?tenant=demo-a`)
- **Probe Endpoint**: `POST /api/report/preview/omega3?tenant=demo-a`

**Tools:**
- PowerShell (Windows) or curl (Linux/Mac)
- `jq` for JSON parsing (optional but recommended)

---

## Probe Test Cases

### Test Case 1: Empty Body (No Data)

**Purpose**: Verify graceful handling of missing data

**PowerShell**:
```powershell
$headers = @{
    "Content-Type" = "application/json"
}
$body = @{} | ConvertTo-Json
$response = Invoke-RestMethod -Uri "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" -Method POST -Headers $headers -Body $body
$response | ConvertTo-Json -Depth 10
```

**curl**:
```bash
curl -X POST "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" \
  -H "Content-Type: application/json" \
  -d '{}' | jq '.'
```

**Expected Response**:
```json
{
  "success": true,
  "shown": false,
  "triglycerides": null,
  "ascvdRisk": null,
  "omega3Index": null,
  "tier": null,
  "priority": null,
  "html": "",
  "fingerprint": "omega3-..."
}
```

**Verification**: ✅ Card hidden, no errors

---

### Test Case 2: Normal TG, Low Risk, Adequate Intake (No Recommendation)

**Purpose**: Verify card is hidden for adequate omega-3 intake

**PowerShell**:
```powershell
$body = @{
    biomarkers = @{
        triglycerides = 95
        omega3Index = 9
    }
    risk = @{
        ascvd = 0.04
    }
} | ConvertTo-Json -Depth 10
$response = Invoke-RestMethod -Uri "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" -Method POST -Headers @{"Content-Type"="application/json"} -Body $body
$response | ConvertTo-Json -Depth 10
```

**curl**:
```bash
curl -X POST "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" \
  -H "Content-Type: application/json" \
  -d '{
    "biomarkers": {
      "triglycerides": 95,
      "omega3Index": 9
    },
    "risk": {
      "ascvd": 0.04
    }
  }' | jq '.'
```

**Expected Response**:
```json
{
  "success": true,
  "shown": false,
  "triglycerides": 95,
  "ascvdRisk": 0.04,
  "omega3Index": 9,
  "tier": "no_recommendation",
  "priority": null,
  "html": "",
  "fingerprint": "omega3-..."
}
```

**Verification**: ✅ Card hidden for Omega-3 Index ≥ 8%

---

### Test Case 3: Borderline High TG, Moderate Risk (Medium Priority)

**Purpose**: Verify MEDIUM PRIORITY card for borderline high triglycerides

**PowerShell**:
```powershell
$body = @{
    biomarkers = @{
        triglycerides = 165
        ldl = 125
    }
    risk = @{
        ascvd = 0.09
    }
} | ConvertTo-Json -Depth 10
$response = Invoke-RestMethod -Uri "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" -Method POST -Headers @{"Content-Type"="application/json"} -Body $body
$response | ConvertTo-Json -Depth 10
```

**curl**:
```bash
curl -X POST "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" \
  -H "Content-Type: application/json" \
  -d '{
    "biomarkers": {
      "triglycerides": 165,
      "ldl": 125
    },
    "risk": {
      "ascvd": 0.09
    }
  }' | jq '.'
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "triglycerides": 165,
  "ascvdRisk": 0.09,
  "omega3Index": null,
  "tier": "moderate_priority",
  "priority": "MEDIUM PRIORITY",
  "html": "<!-- Card with 2-3g EPA/DHA recommendation -->",
  "fingerprint": "omega3-..."
}
```

**Verification**: 
- ✅ Card shown with 🟠 MEDIUM PRIORITY
- ✅ Recommendation: "EPA/DHA supplementation: 2-3g daily"
- ✅ Contains: "Emphasize fatty fish consumption"

---

### Test Case 4: High TG (High-Priority Supplementation)

**Purpose**: Verify HIGH PRIORITY card for high triglycerides

**PowerShell**:
```powershell
$body = @{
    biomarkers = @{
        triglycerides = 285
        ldl = 145
        hdl = 38
    }
    risk = @{
        ascvd = 0.18
    }
} | ConvertTo-Json -Depth 10
$response = Invoke-RestMethod -Uri "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" -Method POST -Headers @{"Content-Type"="application/json"} -Body $body
$response | ConvertTo-Json -Depth 10
```

**curl**:
```bash
curl -X POST "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" \
  -H "Content-Type: application/json" \
  -d '{
    "biomarkers": {
      "triglycerides": 285,
      "ldl": 145,
      "hdl": 38
    },
    "risk": {
      "ascvd": 0.18
    }
  }' | jq '.'
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "triglycerides": 285,
  "ascvdRisk": 0.18,
  "omega3Index": null,
  "tier": "high_priority",
  "priority": "HIGH PRIORITY",
  "html": "<!-- Card with 3-4g EPA/DHA recommendation -->",
  "fingerprint": "omega3-..."
}
```

**Verification**: 
- ✅ Card shown with 🔴 HIGH PRIORITY
- ✅ Recommendation: "High-dose EPA/DHA supplementation: 3-4g daily"
- ✅ Contains: "Pharmaceutical-grade fish oil recommended"

---

### Test Case 5: Very High TG (Prescription Omega-3 Referral)

**Purpose**: Verify URGENT referral for very high triglycerides (≥ 500 mg/dL)

**PowerShell**:
```powershell
$body = @{
    biomarkers = @{
        triglycerides = 625
        ldl = 160
    }
} | ConvertTo-Json -Depth 10
$response = Invoke-RestMethod -Uri "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" -Method POST -Headers @{"Content-Type"="application/json"} -Body $body
$response | ConvertTo-Json -Depth 10
```

**curl**:
```bash
curl -X POST "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" \
  -H "Content-Type: application/json" \
  -d '{
    "biomarkers": {
      "triglycerides": 625,
      "ldl": 160
    }
  }' | jq '.'
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "triglycerides": 625,
  "ascvdRisk": null,
  "omega3Index": null,
  "tier": "high_priority",
  "priority": "HIGH PRIORITY",
  "html": "<!-- Card with URGENT physician referral -->",
  "fingerprint": "omega3-..."
}
```

**Verification**: 
- ✅ Card shown with 🔴 URGENT
- ✅ Contains: "Schedule physician appointment THIS WEEK"
- ✅ Contains: "Prescription omega-3 required: Vascepa (4g EPA) or Lovaza (4g EPA/DHA)"
- ✅ Contains: "OTC supplements insufficient for TG ≥ 500 mg/dL"

---

### Test Case 6: Anticoagulant Present (Caution)

**Purpose**: Verify CAUTION card for anticoagulant medication

**PowerShell**:
```powershell
$body = @{
    biomarkers = @{
        triglycerides = 175
    }
    medications = @(
        @{
            name = "warfarin"
            category = "anticoagulant"
        }
    )
} | ConvertTo-Json -Depth 10
$response = Invoke-RestMethod -Uri "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" -Method POST -Headers @{"Content-Type"="application/json"} -Body $body
$response | ConvertTo-Json -Depth 10
```

**curl**:
```bash
curl -X POST "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" \
  -H "Content-Type: application/json" \
  -d '{
    "biomarkers": {
      "triglycerides": 175
    },
    "medications": [
      {
        "name": "warfarin",
        "category": "anticoagulant"
      }
    ]
  }' | jq '.'
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "triglycerides": 175,
  "ascvdRisk": null,
  "omega3Index": null,
  "tier": "caution",
  "priority": "CAUTION",
  "html": "<!-- Card with bleeding risk warning -->",
  "fingerprint": "omega3-..."
}
```

**Verification**: 
- ✅ Card shown with ⚠️ CAUTION
- ✅ Contains: "Discuss with your physician BEFORE starting omega-3"
- ✅ Contains: "Omega-3 at high doses may increase bleeding risk with blood thinners"
- ✅ Contains: "If approved by physician: Start with lower dose (1-2g daily)"

---

### Test Case 7: Bleeding Disorder (Contraindicated)

**Purpose**: Verify CONTRAINDICATION card for bleeding disorder

**PowerShell**:
```powershell
$body = @{
    biomarkers = @{
        triglycerides = 185
    }
    medicalHistory = @{
        bleedingDisorder = $true
    }
} | ConvertTo-Json -Depth 10
$response = Invoke-RestMethod -Uri "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" -Method POST -Headers @{"Content-Type"="application/json"} -Body $body
$response | ConvertTo-Json -Depth 10
```

**curl**:
```bash
curl -X POST "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" \
  -H "Content-Type: application/json" \
  -d '{
    "biomarkers": {
      "triglycerides": 185
    },
    "medicalHistory": {
      "bleedingDisorder": true
    }
  }' | jq '.'
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "triglycerides": 185,
  "ascvdRisk": null,
  "omega3Index": null,
  "tier": "contraindicated",
  "priority": "CONTRAINDICATION",
  "html": "<!-- Card with CONTRAINDICATION warning -->",
  "fingerprint": "omega3-..."
}
```

**Verification**: 
- ✅ Card shown with ❌ CONTRAINDICATION
- ✅ Contains: "DO NOT RECOMMEND"
- ✅ Contains: "Omega-3 supplementation is contraindicated due to bleeding risk"
- ✅ Contains: "Bleeding disorder present"

---

### Test Case 8: High Fish Intake, Low TG (Dietary Emphasis)

**Purpose**: Verify MAINTENANCE card emphasizing dietary sources

**PowerShell**:
```powershell
$body = @{
    biomarkers = @{
        triglycerides = 105
    }
    dietary = @{
        fishServingsPerWeek = 3
    }
    risk = @{
        ascvd = 0.05
    }
} | ConvertTo-Json -Depth 10
$response = Invoke-RestMethod -Uri "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" -Method POST -Headers @{"Content-Type"="application/json"} -Body $body
$response | ConvertTo-Json -Depth 10
```

**curl**:
```bash
curl -X POST "https://longenix-preview.pages.dev/api/report/preview/omega3?tenant=demo-a" \
  -H "Content-Type: application/json" \
  -d '{
    "biomarkers": {
      "triglycerides": 105
    },
    "dietary": {
      "fishServingsPerWeek": 3
    },
    "risk": {
      "ascvd": 0.05
    }
  }' | jq '.'
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "triglycerides": 105,
  "ascvdRisk": 0.05,
  "omega3Index": null,
  "tier": "dietary_emphasis",
  "priority": "MAINTENANCE",
  "html": "<!-- Card with dietary emphasis -->",
  "fingerprint": "omega3-..."
}
```

**Verification**: 
- ✅ Card shown with ✅ MAINTENANCE
- ✅ Contains: "Continue current dietary omega-3 intake (fatty fish 2-3x/week)"
- ✅ Contains: "Low-dose EPA/DHA supplementation (1g daily) for additional cardiovascular benefit (optional)"
- ✅ Contains: "Consider testing Omega-3 Index to confirm adequacy (target >8%)"

---

## E2E Report Test Scenarios

### E2E Scenario 1: Omega-3 Card Hidden (No Indication)

**Patient Profile**:
- Triglycerides: 85 mg/dL (normal)
- ASCVD risk: 3% (low)
- Omega-3 Index: 9.5% (optimal)
- Fish intake: 3 servings/week

**Expected**: No Omega-3 card appears in report

**Verification**: Adequate intake, no supplementation needed

---

### E2E Scenario 2: Omega-3 Card Shown with Medium Priority

**Patient Profile**:
- Triglycerides: 165 mg/dL (borderline high)
- ASCVD risk: 8% (moderate)
- LDL: 130 mg/dL
- No fish intake

**Expected**: Omega-3 card appears with 🟠 MEDIUM PRIORITY

**Content Verification**:
- "EPA/DHA supplementation: 2-3g daily for cardiovascular health"
- "Emphasize fatty fish consumption: salmon, mackerel, sardines"
- Retest lipid panel in 3-6 months

---

### E2E Scenario 3: Omega-3 Card Shown with High Priority

**Patient Profile**:
- Triglycerides: 295 mg/dL (high)
- ASCVD risk: 16% (high)
- HDL: 36 mg/dL (low)
- History of cardiovascular event

**Expected**: Omega-3 card appears with 🔴 HIGH PRIORITY

**Content Verification**:
- "High-dose EPA/DHA supplementation: 3-4g daily"
- "Pharmaceutical-grade fish oil recommended"
- Retest lipid panel in 8-12 weeks
- Consider Omega-3 Index testing

---

### E2E Scenario 4: Omega-3 Card Shown with Caution (Anticoagulant)

**Patient Profile**:
- Triglycerides: 180 mg/dL (borderline high)
- Medications: Warfarin 5mg daily

**Expected**: Omega-3 card appears with ⚠️ CAUTION

**Content Verification**:
- "⚠️ CAUTION: Omega-3 at high doses may increase bleeding risk with blood thinners"
- "Discuss with your physician before starting omega-3 supplementation"
- "If approved, start with lower dose (1-2g daily)"
- "Consider INR monitoring"

---

## Regression Checks

**CRITICAL**: Verify existing probes still work:

### Vitamin D Probe
```bash
curl -X POST "https://longenix-preview.pages.dev/api/report/preview/vitaminD?tenant=demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"vitaminD":12}}' | jq '.'
```

**Expected**: `success: true, shown: true, status: "severe_deficiency"`

### HbA1c Probe
```bash
curl -X POST "https://longenix-preview.pages.dev/api/report/preview/hba1c?tenant=demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"hba1c":6.2,"glucose":118}}' | jq '.'
```

**Expected**: `success: true, shown: true, status: "prediabetes"`

---

## Troubleshooting

### Issue: 400 "Invalid tenant"
**Solution**: Ensure using allowed tenant (`demo-a`, `demo-b`, or `demo-c`)

### Issue: 500 Internal Server Error
**Solution**: Check PM2 logs: `pm2 logs longenix-preview --nostream`

### Issue: Card not appearing in E2E report
**Solution**: 
1. Verify `PREVIEW_DYNAMIC_OMEGA3 = true` in code
2. Check `comprehensiveData` contains required biomarkers
3. Review `generateDynamicOmega3Card()` logic in DevTools console

### Issue: Build failures
**Solution**: Run `npm run build` and check for TypeScript errors

---

## Success Criteria

- ✅ All 8 probe test cases pass
- ✅ All 4 E2E report scenarios verified
- ✅ Vitamin D and HbA1c probes still work (no regressions)
- ✅ TypeScript builds successfully
- ✅ No PHI in logs (only `present` / `null` markers)
- ✅ Graceful degradation for missing data

---

## Next Steps

1. **Complete all probe tests** (Test Cases 1-8)
2. **Verify E2E scenarios** (Scenarios 1-4)
3. **Run regression checks** (Vitamin D, HbA1c probes)
4. **Create production checklist** (`CHECKLIST_OMEGA3_PRODUCTION.md`)
5. **Clinical review** for tier definitions and dosing ranges
6. **Open Pull Request** with title: `feat: implement dynamic Omega-3 recommendations (Fix Pack #4)`

---

**Document Status**: ✅ Complete  
**Last Updated**: 2025-11-29  
**Owner**: Technical Lead
