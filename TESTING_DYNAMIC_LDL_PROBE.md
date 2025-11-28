# TESTING GUIDE: LDL Probe Endpoint (Dynamic Fix Pack #1 Validation)

**Endpoint:** `POST /api/report/preview/ldl`  
**Branch:** `fix/preview-dynamic-ldl`  
**Environment:** Preview ONLY  
**Auth:** Basic Auth `preview:<PREVIEW_PASSWORD>`  
**Tenant:** `X-Tenant-ID: demo-a` (required)

---

## Overview

This probe endpoint validates the **Dynamic LDL Block Personalization (Fix Pack #1)** by exposing the same `getLDLValue()`, `getASCVDRisk()`, and `generateDynamicLDLCard()` helpers used in the `/report` route.

**Purpose:**
- Test gating logic (`LDL > 100` OR `ASCVD >= 7.5%`)
- Verify dynamic target computation (70/100/130 mg/dL thresholds)
- Validate multi-key LDL probing
- Inspect exact HTML output for different scenarios

**Safety:**
- ✅ NO DATABASE READS or WRITES
- ✅ Uses mock data from request body only
- ✅ Returns JSON analysis (not actual report HTML)
- ✅ Preview-only (not exposed in production)

---

## Request Schema

```json
{
  "biomarkers": {
    "ldl": 145,              // or ldl_cholesterol, ldl_c, ldlCholesterol, LDL
    "ldl_c": 145,            // probes all these keys in order
    "ldl_cholesterol": 145
  },
  "risk": {
    "ascvd": 0.09,           // or ascvd_risk (0-1 range, e.g., 0.09 = 9%)
    "risk_level": "moderate" // fallback if numeric score missing
  }
}
```

**Notes:**
- All fields are optional
- If `biomarkers` omitted, `ldlValue` will be `null`
- If `risk` omitted, `ascvdRisk` will be `null`
- Mimics the exact key-probing logic used in `/report` route

---

## Response Schema

```json
{
  "success": true,
  "tenant": "demo-a",
  "probe": "ldl-dynamic",
  "shown": true,                  // boolean: card passes gate?
  "ldlValue": 145,                // resolved LDL value or null
  "ascvdRisk": 0.09,              // resolved ASCVD risk (0-1) or null
  "ldlTarget": 100,               // 70, 100, or 130 if shown, else null
  "html": "<section ...>...</section>",  // exact HTML when shown, else ""
  "message": "Preview LDL probe complete (no DB writes)"
}
```

---

## Test Scenarios

### Scenario A: High LDL, No ASCVD Risk Data
**Condition:** LDL = 145 mg/dL, ASCVD risk unknown  
**Expected:** Card SHOWN, Target = 130 mg/dL (default for unknown risk)

#### PowerShell
```powershell
$base = "https://feat-my-first-mods-preview.longenix-prime.pages.dev"
$auth = "preview:<PREVIEW_PASSWORD>"
$headers = @{
    "Authorization" = "Basic $([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($auth)))"
    "X-Tenant-ID" = "demo-a"
    "Content-Type" = "application/json"
}

$body = @{
    biomarkers = @{
        ldl = 145
    }
} | ConvertTo-Json

$response = Invoke-RestMethod -Method POST -Uri "$base/api/report/preview/ldl" -Headers $headers -Body $body
Write-Host "Shown: $($response.shown) (expected: True)"
Write-Host "LDL: $($response.ldlValue) mg/dL (expected: 145)"
Write-Host "ASCVD: $($response.ascvdRisk) (expected: null)"
Write-Host "Target: $($response.ldlTarget) mg/dL (expected: 130)"
Write-Host "HTML Length: $($response.html.Length) chars (expected: >0)"
```

#### curl
```bash
curl -X POST "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/report/preview/ldl" \
  -u "preview:<PREVIEW_PASSWORD>" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"ldl":145}}'
```

---

### Scenario B: Normal LDL, Moderate ASCVD Risk
**Condition:** LDL = 95 mg/dL, ASCVD = 9% (0.09)  
**Expected:** Card SHOWN (ASCVD >= 7.5%), Target = 100 mg/dL

#### PowerShell
```powershell
$body = @{
    biomarkers = @{
        ldl = 95
    }
    risk = @{
        ascvd = 0.09
    }
} | ConvertTo-Json

$response = Invoke-RestMethod -Method POST -Uri "$base/api/report/preview/ldl" -Headers $headers -Body $body
Write-Host "Shown: $($response.shown) (expected: True)"
Write-Host "LDL: $($response.ldlValue) mg/dL (expected: 95)"
Write-Host "ASCVD: $($response.ascvdRisk) (expected: 0.09)"
Write-Host "Target: $($response.ldlTarget) mg/dL (expected: 100)"
```

#### curl
```bash
curl -X POST "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/report/preview/ldl" \
  -u "preview:<PREVIEW_PASSWORD>" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"ldl":95},"risk":{"ascvd":0.09}}'
```

---

### Scenario C: Normal LDL, Very High ASCVD Risk
**Condition:** LDL = 95 mg/dL, ASCVD = 25% (0.25)  
**Expected:** Card SHOWN (ASCVD >= 20%), Target = 70 mg/dL

#### PowerShell
```powershell
$body = @{
    biomarkers = @{
        ldl = 95
    }
    risk = @{
        ascvd = 0.25
    }
} | ConvertTo-Json

$response = Invoke-RestMethod -Method POST -Uri "$base/api/report/preview/ldl" -Headers $headers -Body $body
Write-Host "Shown: $($response.shown) (expected: True)"
Write-Host "LDL: $($response.ldlValue) mg/dL (expected: 95)"
Write-Host "ASCVD: $($response.ascvdRisk) (expected: 0.25)"
Write-Host "Target: $($response.ldlTarget) mg/dL (expected: 70)"
```

#### curl
```bash
curl -X POST "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/report/preview/ldl" \
  -u "preview:<PREVIEW_PASSWORD>" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"ldl":95},"risk":{"ascvd":0.25}}'
```

---

### Scenario D: Normal LDL, Low ASCVD Risk
**Condition:** LDL = 95 mg/dL, ASCVD = 3% (0.03)  
**Expected:** Card HIDDEN (LDL < 100 AND ASCVD < 7.5%)

#### PowerShell
```powershell
$body = @{
    biomarkers = @{
        ldl = 95
    }
    risk = @{
        ascvd = 0.03
    }
} | ConvertTo-Json

$response = Invoke-RestMethod -Method POST -Uri "$base/api/report/preview/ldl" -Headers $headers -Body $body
Write-Host "Shown: $($response.shown) (expected: False)"
Write-Host "LDL: $($response.ldlValue) mg/dL (expected: 95)"
Write-Host "ASCVD: $($response.ascvdRisk) (expected: 0.03)"
Write-Host "Target: $($response.ldlTarget) (expected: null)"
Write-Host "HTML: '$($response.html)' (expected: empty string)"
```

#### curl
```bash
curl -X POST "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/report/preview/ldl" \
  -u "preview:<PREVIEW_PASSWORD>" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"ldl":95},"risk":{"ascvd":0.03}}'
```

---

## Verification Checklist

After running all 4 scenarios:

- [ ] **Scenario A:** `shown=true`, `ldlTarget=130`, HTML length >1000 chars
- [ ] **Scenario B:** `shown=true`, `ldlTarget=100`, HTML contains "Preview dynamic"
- [ ] **Scenario C:** `shown=true`, `ldlTarget=70`, HTML contains "Current LDL: 95 mg/dL"
- [ ] **Scenario D:** `shown=false`, `ldlTarget=null`, `html=""` (empty string)
- [ ] **All scenarios:** No "Red yeast rice" in HTML
- [ ] **All scenarios:** No dosing claims ("500-1000mg", "2-3g") in HTML
- [ ] **All scenarios:** HTML contains `data-test="ldl-card"` when shown
- [ ] **All scenarios:** `success: true` and `message` confirms "no DB writes"

---

## Multi-Key Probing Tests

Test that the endpoint accepts all supported LDL key variants:

### Test: ldl_cholesterol
```powershell
$body = @{ biomarkers = @{ ldl_cholesterol = 120 } } | ConvertTo-Json
$response = Invoke-RestMethod -Method POST -Uri "$base/api/report/preview/ldl" -Headers $headers -Body $body
Write-Host "LDL resolved: $($response.ldlValue) (expected: 120)"
```

### Test: ldl_c
```powershell
$body = @{ biomarkers = @{ ldl_c = 130 } } | ConvertTo-Json
$response = Invoke-RestMethod -Method POST -Uri "$base/api/report/preview/ldl" -Headers $headers -Body $body
Write-Host "LDL resolved: $($response.ldlValue) (expected: 130)"
```

### Test: ldlCholesterol (camelCase)
```powershell
$body = @{ biomarkers = @{ ldlCholesterol = 140 } } | ConvertTo-Json
$response = Invoke-RestMethod -Method POST -Uri "$base/api/report/preview/ldl" -Headers $headers -Body $body
Write-Host "LDL resolved: $($response.ldlValue) (expected: 140)"
```

### Test: ascvd_risk (alternate key)
```powershell
$body = @{ 
    biomarkers = @{ ldl = 110 }
    risk = @{ ascvd_risk = 0.12 }
} | ConvertTo-Json
$response = Invoke-RestMethod -Method POST -Uri "$base/api/report/preview/ldl" -Headers $headers -Body $body
Write-Host "ASCVD resolved: $($response.ascvdRisk) (expected: 0.12)"
```

---

## Error Cases

### Missing Tenant
```bash
curl -X POST "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/report/preview/ldl" \
  -u "preview:<PREVIEW_PASSWORD>" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"ldl":145}}'
# Expected: 400 {"success":false, "error":"Validation failed", "details":[{"field":"tenant",...}]}
```

### Invalid Tenant
```bash
curl -X POST "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/report/preview/ldl" \
  -u "preview:<PREVIEW_PASSWORD>" \
  -H "X-Tenant-ID: invalid-tenant" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"ldl":145}}'
# Expected: 400 {"success":false, "error":"Validation failed", "details":[{"field":"tenant",...}]}
```

### Invalid JSON
```bash
curl -X POST "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/report/preview/ldl" \
  -u "preview:<PREVIEW_PASSWORD>" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d 'not valid json'
# Expected: 400 {"success":false, "error":"Validation failed", "details":[{"field":"body",...}]}
```

---

## One-Liners for Quick Testing

### Scenario A (High LDL)
```bash
curl -s -X POST "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/report/preview/ldl" -u "preview:<PREVIEW_PASSWORD>" -H "X-Tenant-ID: demo-a" -H "Content-Type: application/json" -d '{"biomarkers":{"ldl":145}}' | jq '{shown,ldlValue,ascvdRisk,ldlTarget}'
```

### Scenario B (Moderate ASCVD)
```bash
curl -s -X POST "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/report/preview/ldl" -u "preview:<PREVIEW_PASSWORD>" -H "X-Tenant-ID: demo-a" -H "Content-Type: application/json" -d '{"biomarkers":{"ldl":95},"risk":{"ascvd":0.09}}' | jq '{shown,ldlValue,ascvdRisk,ldlTarget}'
```

### Scenario C (Very High ASCVD)
```bash
curl -s -X POST "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/report/preview/ldl" -u "preview:<PREVIEW_PASSWORD>" -H "X-Tenant-ID: demo-a" -H "Content-Type: application/json" -d '{"biomarkers":{"ldl":95},"risk":{"ascvd":0.25}}' | jq '{shown,ldlValue,ascvdRisk,ldlTarget}'
```

### Scenario D (Not Indicated)
```bash
curl -s -X POST "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/report/preview/ldl" -u "preview:<PREVIEW_PASSWORD>" -H "X-Tenant-ID: demo-a" -H "Content-Type: application/json" -d '{"biomarkers":{"ldl":95},"risk":{"ascvd":0.03}}' | jq '{shown,ldlValue,ascvdRisk,ldlTarget}'
```

---

## Safety Confirmations

✅ **NO DATABASE ACCESS** — Endpoint operates entirely on request body mock data  
✅ **NO SCHEMA CHANGES** — Only added endpoint to `src/index.tsx`  
✅ **NO BUILD CONFIG CHANGES** — Uses existing Hono routes  
✅ **NO SECRET MODIFICATIONS** — Uses same Basic Auth as other endpoints  
✅ **PREVIEW ONLY** — Endpoint path `/api/report/preview/ldl` clearly indicates preview status  
✅ **DRY_RUN COMPATIBLE** — Returns JSON analysis, never writes to DB  

---

## Next Steps

1. **Commit changes** to `fix/preview-dynamic-ldl` branch
2. **Update PR #5** with new endpoint documentation
3. **Run all 4 test scenarios** (A-D)
4. **Verify multi-key probing** works for all LDL variants
5. **Test error cases** (missing tenant, invalid JSON)
6. **Compare probe output** with actual `/report` route for consistency

---

**Test Execution Date:** 2025-11-27  
**Tester:** (Your name)  
**Results:** (Pass/Fail/Notes)
