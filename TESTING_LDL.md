# TESTING_LDL.md – LDL Preview Probe

## Purpose

This document describes how to exercise the preview-only LDL probe endpoint for LonGenix-Prime and verify that dynamic LDL targets and gating logic behave as expected.

This endpoint is non-persistent and runs in Cloudflare Pages Preview only.

- **Endpoint:** `POST /api/report/preview/ldl`
- **Environment:** Preview (never production)
- **Tenants:** `demo-a`, `demo-b`, `demo-c`

---

## Prerequisites

- You have a valid preview password from the Cloudflare dashboard.
- You know the preview base URL for the current branch, for example:
  ```
  https://fix-preview-dynamic-ldl.longenix-prime.pages.dev
  ```
- You have a demo tenant ID (e.g. `demo-a`).
- **Do not commit the actual preview password.** Use `<PW>` as a placeholder in documentation.

**Required headers for all requests:**

- `Authorization: Basic <base64("preview:<PW>")>`
- `X-Tenant-ID: demo-a` (or another demo tenant)
- `Content-Type: application/json`

---

## PowerShell Examples

Replace `<PW>` with your preview password and adjust `$BASE` to your preview URL.

```powershell
# --- CONFIG: preview base + auth ---
$BASE = 'https://fix-preview-dynamic-ldl.longenix-prime.pages.dev'
$PW   = '<PW>'   # replace with your preview password (do NOT commit the real value)

$AUTH = "Basic " + [Convert]::ToBase64String(
    [Text.Encoding]::ASCII.GetBytes("preview:$PW")
)

$H = @{
    Authorization = $AUTH
    'X-Tenant-ID' = 'demo-a'
    'Content-Type' = 'application/json'
}

# --- Case 1: empty body -> no data, tile hidden ---
"=== Case 1: {} ==="
Invoke-RestMethod -Method POST -Uri "$BASE/api/report/preview/ldl" -Headers $H -Body '{}' |
  Select-Object success, shown, ldlValue, ascvdRisk, ldlTarget

# Expected:
# success   : True
# shown     : False
# ldlValue  : (null)
# ascvdRisk : (null)
# ldlTarget : (null)

# --- Case 2: LDL = 145, no ASCVD -> high LDL, low/unknown risk -> target 130 ---
"=== Case 2: LDL=145 ==="
Invoke-RestMethod -Method POST -Uri "$BASE/api/report/preview/ldl" -Headers $H -Body '{"biomarkers":{"ldl":145}}' |
  Select-Object success, shown, ldlValue, ascvdRisk, ldlTarget

# Expected:
# success   : True
# shown     : True
# ldlValue  : 145
# ascvdRisk : (null)
# ldlTarget : 130

# --- Case 3: LDL = 95, ASCVD = 0.09 -> intermediate LDL, intermediate risk -> target 100 ---
"=== Case 3: LDL=95, ASCVD=0.09 ==="
Invoke-RestMethod -Method POST -Uri "$BASE/api/report/preview/ldl" -Headers $H -Body '{"biomarkers":{"ldl":95},"risk":{"ascvd":0.09}}' |
  Select-Object success, shown, ldlValue, ascvdRisk, ldlTarget

# Expected:
# success   : True
# shown     : True
# ldlValue  : 95
# ascvdRisk : 0.09
# ldlTarget : 100

# --- Case 4: LDL = 95, ASCVD = 0.25 -> high risk -> target 70 ---
"=== Case 4: LDL=95, ASCVD=0.25 ==="
Invoke-RestMethod -Method POST -Uri "$BASE/api/report/preview/ldl" -Headers $H -Body '{"biomarkers":{"ldl":95},"risk":{"ascvd":0.25}}' |
  Select-Object success, shown, ldlValue, ascvdRisk, ldlTarget

# Expected:
# success   : True
# shown     : True
# ldlValue  : 95
# ascvdRisk : 0.25
# ldlTarget : 70
```

---

## curl Examples

Replace `<PW>` with your preview password and `<BASE>` with your preview URL
(e.g. `https://fix-preview-dynamic-ldl.longenix-prime.pages.dev`).

```bash
# Helper: build the Basic auth header value (example shown for documentation only)
# echo -n "preview:<PW>" | base64

# --- Case 1: empty body ---
curl -X POST "<BASE>/api/report/preview/ldl" \
  -H "Authorization: Basic <BASE64_PREVIEW_PW>" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{}'

# --- Case 2: LDL = 145 ---
curl -X POST "<BASE>/api/report/preview/ldl" \
  -H "Authorization: Basic <BASE64_PREVIEW_PW>" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"ldl":145}}'

# --- Case 3: LDL = 95, ASCVD = 0.09 ---
curl -X POST "<BASE>/api/report/preview/ldl" \
  -H "Authorization: Basic <BASE64_PREVIEW_PW>" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"ldl":95,"hdl":55},"risk":{"ascvd":0.09}}'

# --- Case 4: LDL = 95, ASCVD = 0.25 ---
curl -X POST "<BASE>/api/report/preview/ldl" \
  -H "Authorization: Basic <BASE64_PREVIEW_PW>" \
  -H "X-Tenant-ID: demo-a" \
  -H "Content-Type: application/json" \
  -d '{"biomarkers":{"ldl":95},"risk":{"ascvd":0.25}}'
```

---

## Expected Behavior Summary

- If no LDL is provided (`{}`), the probe returns `success=true` but `shown=false` and no target.
- When LDL is provided, the probe dynamically chooses `ldlTarget` based on ASCVD risk tier, for example:
  - LDL 145 with no ASCVD risk → `ldlTarget=130`, `shown=true`.
  - LDL 95 with ASCVD 0.09 → `ldlTarget=100`, `shown=true`.
  - LDL 95 with ASCVD 0.25 → `ldlTarget=70`, `shown=true`.

**This endpoint is preview-only and must not be wired to any persistent storage or production environment.**
