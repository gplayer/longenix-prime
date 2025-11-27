# TESTING GUIDE: Dynamic LDL Block Personalization (Preview)

**Branch:** `fix/preview-dynamic-ldl`  
**Environment:** Preview ONLY  
**DRY_RUN:** `true` (no DB writes, no calculator execution)  
**Auth:** Basic Auth `preview:<PREVIEW_PASSWORD>`  
**Tenant:** `X-Tenant-ID: demo-a`

---

## Overview

This PR implements **DYNAMIC FIX PACK #1** — replacing the static LDL recommendation block with a patient-data-driven version that:

1. ✅ Shows ONLY when clinically indicated (`LDL > 100` OR `ASCVD risk ≥ 7.5%`)
2. ✅ Uses patient's actual LDL value from biomarkers
3. ✅ Computes dynamic LDL target based on ASCVD risk:
   - **ASCVD ≥ 20%** → Target: `<70 mg/dL` (very high risk)
   - **ASCVD ≥ 7.5%** → Target: `<100 mg/dL` (moderate-high risk)
   - **ASCVD < 7.5%** → Target: `<130 mg/dL` (low risk)
4. ✅ Removes red yeast rice entirely (contraindication risk)
5. ✅ Removes all dosing claims (e.g., "500-1000mg daily")
6. ✅ Labels clearly as "Preview dynamic"
7. ✅ Wrapped in `<section data-test="ldl-card">` for test automation

---

## Test Scenarios

### Scenario 1: LDL Card HIDDEN (Not Clinically Indicated)

**Condition:** LDL = 95 mg/dL, ASCVD risk = 3%  
**Expected:** LDL card should NOT appear in report

```powershell
# PowerShell
$base = "https://feat-my-first-mods-preview.longenix-prime.pages.dev"
$auth = "preview:<PREVIEW_PASSWORD>"
$headers = @{
    "Authorization" = "Basic $([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($auth)))"
    "X-Tenant-ID" = "demo-a"
    "Content-Type" = "application/json"
}

$body = @{
    demographics = @{
        fullName = "Test User Low Risk"
        dateOfBirth = "1980-01-01"
        gender = "male"
    }
    biomarkers = @{
        ldlCholesterol = 95
    }
} | ConvertTo-Json

$response = Invoke-RestMethod -Method POST -Uri "$base/api/assessment/comprehensive" -Headers $headers -Body $body
Write-Host "Session ID: $($response.sessionId)"
Write-Host "Check report: $base/report?session=$($response.sessionId)&demo=true"
Write-Host "Expected: NO LDL card visible (LDL=95 < 100 AND ASCVD risk low)"
```

### Scenario 2: LDL Card VISIBLE (High LDL, Risk Unknown)

**Condition:** LDL = 145 mg/dL, ASCVD risk missing/unknown  
**Expected:** LDL card appears with `Current LDL: 145 mg/dL | Target LDL: <130 mg/dL`

```powershell
# PowerShell
$body = @{
    demographics = @{
        fullName = "Test User High LDL"
        dateOfBirth = "1975-06-15"
        gender = "female"
    }
    biomarkers = @{
        ldlCholesterol = 145
    }
} | ConvertTo-Json

$response = Invoke-RestMethod -Method POST -Uri "$base/api/assessment/comprehensive" -Headers $headers -Body $body
Write-Host "Session ID: $($response.sessionId)"
Write-Host "Check report: $base/report?session=$($response.sessionId)&demo=true"
Write-Host "Expected: LDL card VISIBLE with Current=145, Target=<130 (default for unknown risk)"
```

### Scenario 3: LDL Card VISIBLE (Moderate ASCVD Risk)

**Condition:** LDL = 98 mg/dL, ASCVD = 12% (≥7.5%)  
**Expected:** LDL card appears with `Current LDL: 98 mg/dL | Target LDL: <100 mg/dL`

```powershell
# PowerShell
$body = @{
    demographics = @{
        fullName = "Test User Moderate Risk"
        dateOfBirth = "1970-03-20"
        gender = "male"
    }
    biomarkers = @{
        ldlCholesterol = 98
        totalCholesterol = 220
        hdlCholesterol = 45
        triglycerides = 180
    }
    clinical = @{
        systolicBP = 145
        weight = 95
        height = 175
    }
} | ConvertTo-Json

$response = Invoke-RestMethod -Method POST -Uri "$base/api/assessment/comprehensive" -Headers $headers -Body $body
Write-Host "Session ID: $($response.sessionId)"
Write-Host "Check report: $base/report?session=$($response.sessionId)&demo=true"
Write-Host "Expected: LDL card VISIBLE (ASCVD risk ≥7.5%), Target=<100 mg/dL"
```

### Scenario 4: No Fabricated Numbers

**Condition:** Minimal demographics only (no biomarkers)  
**Expected:** LDL card should NOT appear (no data = fail safe)

```powershell
# PowerShell
$body = @{
    demographics = @{
        fullName = "Test User Minimal Data"
        dateOfBirth = "1985-12-01"
        gender = "female"
    }
} | ConvertTo-Json

$response = Invoke-RestMethod -Method POST -Uri "$base/api/assessment/comprehensive" -Headers $headers -Body $body
Write-Host "Session ID: $($response.sessionId)"
Write-Host "Check report: $base/report?session=$($response.sessionId)&demo=true"
Write-Host "Expected: NO LDL card (no LDL data provided, fail safe)"
```

---

## Verification Checklist

After running tests, open each report URL and verify:

- [ ] **Scenario 1:** LDL card is completely absent (no "LDL Cholesterol Optimization" section)
- [ ] **Scenario 2:** LDL card shows `Current LDL: 145 mg/dL | Target LDL: <130 mg/dL`
- [ ] **Scenario 3:** LDL card shows `Current LDL: 98 mg/dL | Target LDL: <100 mg/dL`
- [ ] **Scenario 4:** LDL card is completely absent (fail-safe when no data)
- [ ] **All visible cards:**
  - [ ] Title includes "(Preview dynamic)" label
  - [ ] No mention of "115 mg/dL" or other hard-coded values
  - [ ] No "Red yeast rice" item
  - [ ] No dosing claims (e.g., "500-1000mg daily", "2-3g daily")
  - [ ] Supplements section says "Options to Discuss with Your Clinician"
  - [ ] Has `<section data-test="ldl-card">` wrapper (check HTML source)

---

## Manual Inspection (HTML Source)

Search rendered HTML for these strings to confirm removal:

```powershell
# PowerShell - Check for removed static content
$reportUrl = "$base/report?session=<SESSION_ID>&demo=true"
$html = Invoke-WebRequest -Uri $reportUrl -Headers @{ "Authorization" = "Basic $([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($auth)))" }

# Should NOT find these strings:
$html.Content -match "Current: 115 mg/dL"  # Should be FALSE
$html.Content -match "Red yeast rice"       # Should be FALSE
$html.Content -match "500-1000mg daily"     # Should be FALSE
$html.Content -match "2-3g daily"           # Should be FALSE

# Should find these in dynamic cards:
$html.Content -match "data-test=`"ldl-card`""  # Should be TRUE if card shown
$html.Content -match "Preview dynamic"          # Should be TRUE if card shown
```

---

## Data Probing Logic

The implementation probes for LDL and ASCVD risk using the following key patterns:

### LDL Value (prioritized search order):
1. `comprehensiveData.biomarkers.ldlCholesterol`
2. `comprehensiveData.biomarkers.ldl_cholesterol`
3. `comprehensiveData.biomarkers.ldl`
4. `comprehensiveData.biomarkers.ldl_c`
5. `comprehensiveData.biomarkers.LDL`
6. (Repeats for `comprehensiveData.clinical.*`)
7. (Repeats for `comprehensiveData.*` root level)

### ASCVD Risk:
1. `risks.results[]` where `category === 'cardiovascular'`
2. Numeric `risk_score` field (0-1 range, e.g., 0.12 = 12%)
3. Fallback: Map `risk_level` to proxy values:
   - `'low'` → 0.05 (5%)
   - `'moderate'` → 0.10 (10%)
   - `'high'` → 0.15 (15%)
   - `'very_high'` → 0.25 (25%)

---

## Safety Guarantees

✅ **Preview ONLY** — Changes isolated to `fix/preview-dynamic-ldl` branch  
✅ **DRY_RUN=true** — No database writes, no medical calculator execution  
✅ **Fail-safe** — If data missing or invalid, card is hidden (no fabricated values)  
✅ **No contraindications** — Red yeast rice completely removed  
✅ **No dosing claims** — All specific dosages removed  
✅ **Production untouched** — No changes to `main` branch or Production environment  

---

## Rollback Plan

If issues are found, simply:
1. Close PR (do NOT merge)
2. Delete branch: `git branch -D fix/preview-dynamic-ldl`
3. Static LDL block remains in production (unchanged)

---

## Next Steps (After Verification)

1. Run all 4 test scenarios
2. Complete verification checklist
3. Review PR #<PR_NUMBER> on GitHub
4. If approved, squash-merge to `feat/my-first-mods-preview` (NOT to main)
5. Deploy merged branch to Preview for integration testing
6. **DO NOT MERGE TO PRODUCTION** until clinical review complete

---

**Test Execution Date:** 2025-11-27  
**Tester:** (Your name)  
**Results:** (Pass/Fail/Notes)
