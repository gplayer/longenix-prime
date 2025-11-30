# TESTING GUIDE: Vitamin D Dynamic Block Personalization (Preview)

## Overview

This document describes how to test the **preview-only Vitamin D probe endpoint** for the LonGenix-Prime app.

**Branch**: `fix/preview-dynamic-vitamin-d`  
**Feature**: Dynamic Fix Pack #2 - Vitamin D Optimization  
**Endpoint**: `POST /api/report/preview/vitaminD`  
**Status**: Preview only, gated by `PREVIEW_DYNAMIC_VITAMIN_D` flag

---

## What Changed

### Before (Static):
- Same "4000 IU daily" recommendation shown to everyone
- No consideration of current Vitamin D level
- Risk of over-supplementation (patient at 80 ng/mL) or under-treatment (patient at 12 ng/mL)

### After (Dynamic):
- **5 clinical tiers** based on Vitamin D level (ng/mL):
  - **Severe deficiency** (< 20): High-dose replacement (5,000-10,000 IU), 6-8 week retest
  - **Insufficiency** (20-30): Moderate dose (4,000-5,000 IU), 8-12 week retest
  - **Low-normal** (30-50): Maintenance dose (2,000-3,000 IU), encourage optimization
  - **Optimal** (50-80): Current plan working, maintain dose (1,000-2,000 IU)
  - **High** (> 80): HOLD supplementation, check calcium, retest in 3 months

- Card shown **ONLY when Vitamin D value is available**
- Different priority levels and recommendations per tier
- Prevents inappropriate dosing recommendations

---

## Prerequisites

Before testing, you need:

1. **Preview password** (from environment: `BASIC_AUTH_PASS`)
2. **Base URL**: 
   - Local: `http://localhost:3000`
   - Preview: Your Cloudflare Pages preview URL
3. **Demo tenant ID**: One of `demo-a`, `demo-b`, `demo-c`

---

## PowerShell Examples

### Setup Authentication

```powershell
# Replace with your actual preview password
$previewPassword = "your-preview-password-here"
$base64Auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("preview:$previewPassword"))

# Base URL (change for your environment)
$baseUrl = "http://localhost:3000"

# Headers
$headers = @{
    "Authorization" = "Basic $base64Auth"
    "X-Tenant-ID" = "demo-a"
    "Content-Type" = "application/json"
}
```

### Test Case 1: Empty Body (No Data)

**Expected**: `shown=false`, no status or value

```powershell
$body = @{} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/vitaminD" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": false,
  "vitaminDValue": null,
  "status": null,
  "html": "",
  "fingerprint": "vitd-..."
}
```

---

### Test Case 2: Severe Deficiency (< 20 ng/mL)

**Scenario**: Patient with severe Vitamin D deficiency (12 ng/mL)

```powershell
$body = @{
    biomarkers = @{
        vitaminD = 12
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/vitaminD" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "vitaminDValue": 12,
  "status": "severe_deficiency",
  "html": "<section data-test=\"vitamin-d-card\"...HIGH PRIORITY...5,000-10,000 IU daily...</section>",
  "fingerprint": "vitd-..."
}
```

**Key Content**:
- Priority: **HIGH PRIORITY**
- Recommendation: High-dose D3 (5,000-10,000 IU daily)
- Retest: 6-8 weeks
- Warning: Immediate action required
- Consider loading dose, assess malabsorption

---

### Test Case 3: Insufficiency (20-30 ng/mL)

**Scenario**: Patient with insufficient Vitamin D (25 ng/mL)

```powershell
$body = @{
    biomarkers = @{
        vitaminD = 25
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/vitaminD" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "vitaminDValue": 25,
  "status": "insufficiency",
  "html": "<section data-test=\"vitamin-d-card\"...MEDIUM PRIORITY...4,000-5,000 IU daily...</section>",
  "fingerprint": "vitd-..."
}
```

**Key Content**:
- Priority: **MEDIUM PRIORITY**
- Recommendation: Moderate-dose D3 (4,000-5,000 IU daily)
- Retest: 8-12 weeks
- Goal: Move to optimal range (50-80 ng/mL)

---

### Test Case 4: Low-Normal (30-50 ng/mL)

**Scenario**: Patient in low-normal range (40 ng/mL)

```powershell
$body = @{
    biomarkers = @{
        vitaminD = 40
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/vitaminD" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "vitaminDValue": 40,
  "status": "low_normal",
  "html": "<section data-test=\"vitamin-d-card\"...MAINTENANCE...2,000-3,000 IU daily...</section>",
  "fingerprint": "vitd-..."
}
```

**Key Content**:
- Priority: **MAINTENANCE**
- Recommendation: Maintenance dose (2,000-3,000 IU daily)
- Retest: 3-6 months
- Consider optimizing to 50-80 ng/mL range

---

### Test Case 5: Optimal (50-80 ng/mL)

**Scenario**: Patient in optimal range (65 ng/mL)

```powershell
$body = @{
    biomarkers = @{
        vitaminD = 65
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/vitaminD" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "vitaminDValue": 65,
  "status": "optimal",
  "html": "<section data-test=\"vitamin-d-card\"...OPTIMAL...on track...1,000-2,000 IU...</section>",
  "fingerprint": "vitd-..."
}
```

**Key Content**:
- Priority: **OPTIMAL** (✓ On Track)
- Recommendation: Continue current plan, maintenance dose (1,000-2,000 IU)
- Retest: Annual recheck
- Message: Level is in optimal range, no need to increase

---

### Test Case 6: High / Toxicity Risk (> 80 ng/mL)

**Scenario**: Patient with elevated Vitamin D (90 ng/mL)

```powershell
$body = @{
    biomarkers = @{
        vitaminD = 90
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/vitaminD" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "vitaminDValue": 90,
  "status": "high",
  "html": "<section data-test=\"vitamin-d-card\"...CAUTION...HOLD all vitamin D supplementation...</section>",
  "fingerprint": "vitd-..."
}
```

**Key Content**:
- Priority: **CAUTION** (⚠️ High Level)
- Recommendation: **HOLD all vitamin D supplementation**
- Retest: 3 months to monitor decline
- Check serum calcium levels
- Warning: Risk of hypercalcemia and toxicity
- Explicit: **Do NOT continue routine high-dose supplementation**

---

## curl Examples

If you prefer `curl` over PowerShell:

### Test Case 1: Empty Body
```bash
curl -X POST http://localhost:3000/api/report/preview/vitaminD \
  -H "Authorization: Basic $(echo -n 'preview:your-password' | base64)" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{}'
```

### Test Case 2: Severe Deficiency (12 ng/mL)
```bash
curl -X POST http://localhost:3000/api/report/preview/vitaminD \
  -H "Authorization: Basic $(echo -n 'preview:your-password' | base64)" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"vitaminD":12}}'
```

### Test Case 3: Insufficiency (25 ng/mL)
```bash
curl -X POST http://localhost:3000/api/report/preview/vitaminD \
  -H "Authorization: Basic $(echo -n 'preview:your-password' | base64)" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"vitaminD":25}}'
```

### Test Case 4: Low-Normal (40 ng/mL)
```bash
curl -X POST http://localhost:3000/api/report/preview/vitaminD \
  -H "Authorization: Basic $(echo -n 'preview:your-password' | base64)" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"vitaminD":40}}'
```

### Test Case 5: Optimal (65 ng/mL)
```bash
curl -X POST http://localhost:3000/api/report/preview/vitaminD \
  -H "Authorization: Basic $(echo -n 'preview:your-password' | base64)" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"vitaminD":65}}'
```

### Test Case 6: High/Toxicity (90 ng/mL)
```bash
curl -X POST http://localhost:3000/api/report/preview/vitaminD \
  -H "Authorization: Basic $(echo -n 'preview:your-password' | base64)" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"vitaminD":90}}'
```

---

## Key Verification Points

For each test case, verify:

1. **Response shape** is consistent:
   - `success: true`
   - `shown: boolean`
   - `vitaminDValue: number | null`
   - `status: string | null`
   - `html: string`
   - `fingerprint: string`

2. **Status classification** matches the tier:
   - `< 20` → `"severe_deficiency"`
   - `20-30` → `"insufficiency"`
   - `30-50` → `"low_normal"`
   - `50-80` → `"optimal"`
   - `> 80` → `"high"`

3. **Gating logic** works correctly:
   - Empty body or no vitaminD field → `shown=false`, `status=null`
   - Valid vitaminD value → `shown=true`, appropriate status

4. **HTML content** reflects the tier:
   - Severe deficiency: RED border, HIGH PRIORITY, 5,000-10,000 IU
   - Insufficiency: ORANGE border, MEDIUM PRIORITY, 4,000-5,000 IU
   - Low-normal: YELLOW border, MAINTENANCE, 2,000-3,000 IU
   - Optimal: GREEN border, OPTIMAL (✓), 1,000-2,000 IU
   - High: RED border, CAUTION (⚠️), HOLD supplementation

5. **Safety messaging** for high values:
   - Explicitly says "HOLD all vitamin D supplementation"
   - Warns about toxicity risk
   - Says "Do NOT continue routine high-dose supplementation"

---

## Common Issues

### Issue: 401 Unauthorized
- **Cause**: Incorrect password or missing Authorization header
- **Fix**: Verify `BASIC_AUTH_PASS` environment variable and base64 encoding

### Issue: 400 Invalid Tenant
- **Cause**: Missing or invalid `X-Tenant-ID` header
- **Fix**: Use one of: `demo-a`, `demo-b`, `demo-c`

### Issue: 422 Invalid JSON
- **Cause**: Malformed JSON in request body
- **Fix**: Ensure JSON is valid, or send empty `{}`

### Issue: shown=false for valid data
- **Cause**: Feature flag disabled or vitaminD key not recognized
- **Fix**: Verify `PREVIEW_DYNAMIC_VITAMIN_D = true` and use key `vitaminD` in biomarkers

---

## Integration with Main Report

The same logic used in the probe endpoint is reused in the main report generation:

- **File**: `src/vitaminD-dynamic.ts` (shared module)
- **Report helper**: `generateDynamicVitaminDCard()` in `/report` route
- **Feature flag**: `PREVIEW_DYNAMIC_VITAMIN_D` (gated)

When the feature flag is enabled, the static "4000 IU daily" content is replaced with the dynamic card that adapts to the patient's Vitamin D level from `comprehensiveData.vitaminD` or `assessmentData.vitaminD`.

---

## Related Documentation

- **Inventory**: `DOC_STATIC_CONTENT_INVENTORY.md` - Static content analysis and roadmap
- **Pattern**: `TESTING_LDL.md` - Similar probe testing for LDL (Fix Pack #1)
- **Source**: `src/vitaminD-dynamic.ts` - Shared helper module
- **Endpoint**: `src/index.tsx` - Probe endpoint and report integration

---

## Status

✅ **Probe endpoint implemented** (`POST /api/report/preview/vitaminD`)  
✅ **Shared helper module** (`src/vitaminD-dynamic.ts`)  
✅ **Main report integration** (`generateDynamicVitaminDCard()`)  
✅ **Feature flag** (`PREVIEW_DYNAMIC_VITAMIN_D`)  
✅ **Testing documentation** (this file)

**Next**: Manual verification using PowerShell test cases above

---

**Branch**: `fix/preview-dynamic-vitamin-d`  
**PR**: To be opened to `feat/my-first-mods-preview`  
**Status**: Preview only, DO NOT MERGE to production
