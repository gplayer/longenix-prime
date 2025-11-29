# TESTING GUIDE: HbA1c/Glucose Dynamic Personalization (Preview)

## Overview

This document describes how to test the **preview-only HbA1c/Glucose probe endpoint** for the LonGenix-Prime app.

**Branch**: `fix/preview-dynamic-hba1c`  
**Feature**: Dynamic Fix Pack #3 - HbA1c/Glucose Management  
**Endpoint**: `POST /api/report/preview/hba1c`  
**Status**: Preview only, gated by `PREVIEW_DYNAMIC_HBA1C` flag

---

## What Changed

### Before (Static/Missing):
- HbA1c, glucose, and insulin data collected but **NOT used** for recommendations
- Diabetes risk calculated but **NOT prominently displayed**
- **No dedicated glycemic control card** in report
- Labs shown only in biomarker tables without actionable guidance

### After (Dynamic):
- **5 clinical tiers** based on HbA1c and/or fasting glucose (ADA 2024 Guidelines):
  - **Normal** (HbA1c < 5.7%, glucose < 100 mg/dL): Hidden (no action needed)
  - **Elevated-Normal** (HbA1c 5.7-5.9%, glucose 100-109 mg/dL): WATCH priority, lifestyle modifications
  - **Prediabetes** (HbA1c 6.0-6.4%, glucose 110-125 mg/dL): HIGH PRIORITY, intensive intervention
  - **Diabetes** (HbA1c 6.5-7.9%, glucose 126-199 mg/dL): URGENT, immediate physician referral
  - **High-Risk Diabetes** (HbA1c ≥ 8.0%, glucose ≥ 200 mg/dL): CRITICAL, call doctor TODAY

- Card shown **ONLY when clinically indicated** (non-normal status)
- Priority: HbA1c used if available (gold standard), fallback to glucose
- Different priority levels and recommendations per tier
- Urgent physician referral for diabetes range (prevents unsafe self-management)

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
$previewPassword = "changeme123"
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

---

### Test Case 1: Empty Body (No Data)

**Expected**: `shown=false`, no status or values

```powershell
$body = @{} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/hba1c" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": false,
  "hba1cValue": null,
  "glucoseValue": null,
  "status": null,
  "html": "",
  "fingerprint": "hba1c-..."
}
```

---

### Test Case 2: Normal (HbA1c 5.3%)

**Scenario**: Patient with excellent glycemic control

```powershell
$body = @{
    biomarkers = @{
        hba1c = 5.3
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/hba1c" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": false,
  "hba1cValue": 5.3,
  "glucoseValue": null,
  "status": "normal",
  "html": "",
  "fingerprint": "hba1c-..."
}
```

**Note**: Card is **hidden** for normal status (no action needed)

---

### Test Case 3: Elevated-Normal (HbA1c 5.8%, Glucose 105 mg/dL)

**Scenario**: Patient at increased risk for diabetes

```powershell
$body = @{
    biomarkers = @{
        hba1c = 5.8
        glucose = 105
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/hba1c" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "hba1cValue": 5.8,
  "glucoseValue": 105,
  "status": "elevated_normal",
  "html": "<section class=\"mt-4 p-4 bg-white border border-yellow-200...",
  "fingerprint": "hba1c-..."
}
```

**HTML Content Verification**:
- Priority: `⚠️ WATCH`
- Title: "Glucose Elevated - Increased Diabetes Risk"
- Recommendations: Weight management 5-7%, 150 min/week exercise, low GI diet
- Retest: 6 months

---

### Test Case 4: Prediabetes (HbA1c 6.2%, Glucose 118 mg/dL)

**Scenario**: Patient with prediabetes requiring intensive intervention

```powershell
$body = @{
    biomarkers = @{
        hba1c = 6.2
        glucose = 118
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/hba1c" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "hba1cValue": 6.2,
  "glucoseValue": 118,
  "status": "prediabetes",
  "html": "<section class=\"mt-4 p-4 bg-white border border-orange-200...",
  "fingerprint": "hba1c-..."
}
```

**HTML Content Verification**:
- Priority: `🟠 HIGH PRIORITY`
- Title: "Prediabetes - Urgent Lifestyle Intervention Needed"
- Recommendations: 
  - **Weight loss goal: 7-10% of body weight**
  - **Exercise: 300 min/week for best results**
  - **Discuss metformin with physician**
- Retest: 3 months
- Note: "Aggressive intervention can REVERSE this condition"

---

### Test Case 5: Diabetes (HbA1c 7.2%, Glucose 145 mg/dL)

**Scenario**: Patient in diabetes range requiring immediate physician referral

```powershell
$body = @{
    biomarkers = @{
        hba1c = 7.2
        glucose = 145
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/hba1c" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "hba1cValue": 7.2,
  "glucoseValue": 145,
  "status": "diabetes",
  "html": "<section class=\"mt-4 p-4 bg-white border border-red-200...",
  "fingerprint": "hba1c-..."
}
```

**HTML Content Verification**:
- Priority: `🔴 URGENT`
- Title: "Diabetes Range - Immediate Physician Referral Required"
- Warning: "Do NOT attempt self-management without physician guidance"
- Immediate action: **"Schedule physician appointment THIS WEEK"**
- Complication screening: Eye exam, kidney function, foot exam, lipid panel
- Disclaimer: "This report is NOT a diabetes diagnosis tool"

---

### Test Case 6: High-Risk Diabetes (HbA1c 9.5%, Glucose 250 mg/dL)

**Scenario**: Patient with severe hyperglycemia requiring urgent medical attention

```powershell
$body = @{
    biomarkers = @{
        hba1c = 9.5
        glucose = 250
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/hba1c" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "hba1cValue": 9.5,
  "glucoseValue": 250,
  "status": "high_risk_diabetes",
  "html": "<section class=\"mt-4 p-4 bg-white border border-red-200...",
  "fingerprint": "hba1c-..."
}
```

**HTML Content Verification**:
- Priority: `🔴 CRITICAL`
- Title: "Severe Hyperglycemia - Urgent Medical Attention Required"
- **Bold warning**: "⚠️ CALL YOUR DOCTOR TODAY OR GO TO URGENT CARE"
- Risk: Diabetic ketoacidosis (DKA) or hyperosmolar state
- Warning symptoms: Excessive thirst, weight loss, blurred vision, confusion, fruity breath, nausea
- Emergency care guidance

---

### Test Case 7: Glucose Only (No HbA1c)

**Scenario**: Patient with only glucose measurement (HbA1c not available)

```powershell
$body = @{
    biomarkers = @{
        glucose = 122
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/hba1c" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": true,
  "hba1cValue": null,
  "glucoseValue": 122,
  "status": "prediabetes",
  "html": "<section class=\"mt-4 p-4 bg-white border border-orange-200...",
  "fingerprint": "hba1c-..."
}
```

**Note**: Falls back to glucose-based classification when HbA1c not available

---

### Test Case 8: Edge Case - Normal HbA1c (5.5%) with Elevated Glucose (102 mg/dL)

**Scenario**: Discrepancy between HbA1c and glucose (HbA1c takes priority)

```powershell
$body = @{
    biomarkers = @{
        hba1c = 5.5
        glucose = 102
    }
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/api/report/preview/hba1c" `
    -Method Post `
    -Headers $headers `
    -Body $body
```

**Expected Response**:
```json
{
  "success": true,
  "shown": false,
  "hba1cValue": 5.5,
  "glucoseValue": 102,
  "status": "normal",
  "html": "",
  "fingerprint": "hba1c-..."
}
```

**Note**: HbA1c (gold standard) takes priority over glucose in classification

---

## cURL Examples

### Test Case 1: Empty Body

```bash
curl -X POST http://localhost:3000/api/report/preview/hba1c \
  -H "Authorization: Basic cHJldmlldzpjaGFuZ2VtZTEyMw==" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{}'
```

---

### Test Case 4: Prediabetes

```bash
curl -X POST http://localhost:3000/api/report/preview/hba1c \
  -H "Authorization: Basic cHJldmlldzpjaGFuZ2VtZTEyMw==" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"hba1c":6.2,"glucose":118}}'
```

---

### Test Case 5: Diabetes

```bash
curl -X POST http://localhost:3000/api/report/preview/hba1c \
  -H "Authorization: Basic cHJldmlldzpjaGFuZ2VtZTEyMw==" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"hba1c":7.2,"glucose":145}}'
```

---

### Test Case 6: High-Risk Diabetes

```bash
curl -X POST http://localhost:3000/api/report/preview/hba1c \
  -H "Authorization: Basic cHJldmlldzpjaGFuZ2VtZTEyMw==" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"hba1c":9.5,"glucose":250}}'
```

---

## Response Structure

### Success Response (Card Shown)

```json
{
  "success": true,
  "shown": true,
  "hba1cValue": 6.2,
  "glucoseValue": 118,
  "status": "prediabetes",
  "html": "<section>...</section>",
  "fingerprint": "hba1c-l9x3k2-a4b7c9"
}
```

### Success Response (Card Hidden - Normal)

```json
{
  "success": true,
  "shown": false,
  "hba1cValue": 5.3,
  "glucoseValue": null,
  "status": "normal",
  "html": "",
  "fingerprint": "hba1c-l9x3k2-a4b7c9"
}
```

### Success Response (No Data)

```json
{
  "success": true,
  "shown": false,
  "hba1cValue": null,
  "glucoseValue": null,
  "status": null,
  "html": "",
  "fingerprint": "hba1c-l9x3k2-a4b7c9"
}
```

### Error Response (Missing Tenant)

```json
{
  "success": false,
  "error": "Validation failed",
  "details": [
    {
      "field": "tenant",
      "message": "Missing or invalid tenant"
    }
  ]
}
```

### Error Response (Invalid JSON)

```json
{
  "success": false,
  "error": "Probe failed",
  "details": [
    {
      "field": "input",
      "message": "Invalid JSON or shape"
    }
  ],
  "fingerprint": "hba1c-l9x3k2-a4b7c9"
}
```

---

## Clinical Tier Summary

| Tier | HbA1c (%) | Glucose (mg/dL) | Status | Priority | shown |
|------|-----------|----------------|--------|----------|-------|
| 1 | < 5.7 | < 100 | `normal` | N/A (hidden) | `false` |
| 2 | 5.7-5.9 | 100-109 | `elevated_normal` | ⚠️ WATCH | `true` |
| 3 | 6.0-6.4 | 110-125 | `prediabetes` | 🟠 HIGH PRIORITY | `true` |
| 4 | 6.5-7.9 | 126-199 | `diabetes` | 🔴 URGENT | `true` |
| 5 | ≥ 8.0 | ≥ 200 | `high_risk_diabetes` | 🔴 CRITICAL | `true` |

**Classification Logic**:
- **Priority**: HbA1c used if available (gold standard)
- **Fallback**: Glucose used if HbA1c not available
- **Gating**: Card shown only for non-normal statuses (tiers 2-5)

---

## Troubleshooting

### Issue: 401 Unauthorized

**Cause**: Missing or incorrect Basic Auth credentials

**Solution**: Verify preview password and ensure Authorization header is set correctly

```powershell
$base64Auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("preview:$previewPassword"))
```

---

### Issue: 400 Validation Failed (tenant)

**Cause**: Missing or invalid `X-Tenant-ID` header

**Solution**: Add valid tenant ID to headers (`demo-a`, `demo-b`, or `demo-c`)

```powershell
$headers = @{
    "X-Tenant-ID" = "demo-a"
}
```

---

### Issue: 422 Invalid JSON

**Cause**: Malformed JSON body or invalid `biomarkers` shape

**Solution**: Ensure `biomarkers` is an object (not array or null)

```json
{
  "biomarkers": {
    "hba1c": 6.2
  }
}
```

---

### Issue: shown=false for all inputs

**Cause**: Feature flag `PREVIEW_DYNAMIC_HBA1C` might be set to `false`

**Solution**: Check feature flag in `src/index.tsx` (should be `true` in preview branch)

---

## Verification Checklist

Before deploying to Cloudflare Pages preview:

- [ ] All 8 test cases pass locally
- [ ] Empty body `{}` returns `success=true, shown=false` without errors
- [ ] Normal status (HbA1c 5.3%) returns `shown=false` (card hidden)
- [ ] Prediabetes status (HbA1c 6.2%) returns `shown=true` with HIGH PRIORITY
- [ ] Diabetes status (HbA1c 7.2%) returns `shown=true` with URGENT
- [ ] High-risk status (HbA1c 9.5%) returns `shown=true` with CRITICAL warning
- [ ] Glucose-only case (glucose 122) falls back correctly
- [ ] HbA1c takes priority over glucose when both available
- [ ] HTML content contains correct priority labels, recommendations, and disclaimers
- [ ] No regressions in LDL or Vitamin D probes

---

## Related Documentation

- **Planning Doc**: `DOC_HBA1C_DYNAMIC_PLAN.md`
- **Shared Helper**: `src/hba1c-dynamic.ts`
- **Probe Endpoint**: `POST /api/report/preview/hba1c` (line ~1467 in `src/index.tsx`)
- **Feature Flag**: `PREVIEW_DYNAMIC_HBA1C` (line ~25 in `src/index.tsx`)
- **Report Integration**: `generateDynamicHbA1cCard()` (line ~2271 in `src/index.tsx`)
- **Reference Patterns**: 
  - `TESTING_LDL.md` (LDL probe testing)
  - `TESTING_VITAMIN_D.md` (Vitamin D probe testing)
  - `CHECKLIST_LDL_PRODUCTION.md` (Production checklist template)

---

## Next Steps

After local testing passes:

1. Deploy to Cloudflare Pages preview environment
2. Run all 8 test cases against preview URL
3. Verify report HTML displays HbA1c card correctly
4. Confirm no regressions in existing features (LDL, Vitamin D)
5. Create production readiness checklist (`CHECKLIST_HBA1C_PRODUCTION.md`)
6. Obtain clinical review from endocrinologist or diabetes specialist
7. Complete all checklist items before production enablement

---

**Last Updated**: 2025-11-29  
**Feature**: Dynamic Fix Pack #3 - HbA1c/Glucose Management  
**Status**: Preview implementation complete, ready for testing
