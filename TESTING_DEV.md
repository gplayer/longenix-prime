# Testing Dev/Sandbox Endpoints - Preview Environment

## ⚠️ PREVIEW ONLY - Safe Experimentation Zone

This guide tests the dev/sandbox endpoints in **Preview environment only**.

- ✅ All endpoints require Basic Auth
- ✅ `/api/dev/try` requires valid tenant
- ✅ DRY_RUN mode active: **NO database writes**
- ✅ Safe helpers in `src/dev/scratchpad.ts` with zero side effects

---

## 🔐 Prerequisites

Replace the following in all examples:
- `USERNAME:PASSWORD` - Your Basic Auth credentials (e.g., `admin:changeme123`)
- `PREVIEW_URL` - Your preview URL

**Quick Start**:
1. Replace `USERNAME:PASSWORD` with your Basic Auth credentials
2. Copy any PowerShell snippet below
3. Paste into PowerShell and run

---

## Test Scenarios

### Test A: GET /api/dev/status (200 OK - No Tenant Required)
**Expected**: Returns dev environment status, optionally with tenant if provided.

#### PowerShell
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
}
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/dev/status" -Method Get -Headers $headers
```

#### curl.exe (Windows)
```cmd
curl.exe -u USERNAME:PASSWORD https://PREVIEW_URL/api/dev/status
```

#### bash (Linux/Mac)
```bash
curl -u USERNAME:PASSWORD https://PREVIEW_URL/api/dev/status
```

**Expected Response**:
```json
{
  "ok": true,
  "env": "preview",
  "dryRun": true,
  "tenant": null,
  "time": "2024-01-15T10:30:45.123Z"
}
```

**With Optional Tenant**:
```powershell
# PowerShell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
    "X-Tenant-ID" = "demo-a"
}
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/dev/status" -Method Get -Headers $headers
```

```bash
# bash
curl -u USERNAME:PASSWORD -H "X-Tenant-ID: demo-a" https://PREVIEW_URL/api/dev/status
```

**Expected Response with Tenant**:
```json
{
  "ok": true,
  "env": "preview",
  "dryRun": true,
  "tenant": "demo-a",
  "time": "2024-01-15T10:30:45.123Z"
}
```

---

### Test B: POST /api/dev/try WITHOUT Tenant (400 Bad Request)
**Expected**: Returns validation error with `field: "tenant"`.

#### PowerShell
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
    "Content-Type" = "application/json"
}
$body = @{
    demo = 42
    note = "test without tenant"
} | ConvertTo-Json
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/dev/try" -Method Post -Headers $headers -Body $body
```

#### curl.exe (Windows)
```cmd
curl.exe -u USERNAME:PASSWORD -H "Content-Type: application/json" -X POST https://PREVIEW_URL/api/dev/try -d "{\"demo\":42,\"note\":\"test without tenant\"}"
```

#### bash (Linux/Mac)
```bash
curl -u USERNAME:PASSWORD \
  -H "Content-Type: application/json" \
  -X POST https://PREVIEW_URL/api/dev/try \
  -d '{"demo":42,"note":"test without tenant"}'
```

**Expected Response**:
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

---

### Test C: POST /api/dev/try WITH Tenant + Valid Body (200 OK)
**Expected**: Echoes received payload with tenant and timestamp.

#### PowerShell
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
    "Content-Type" = "application/json"
    "X-Tenant-ID" = "demo-a"
}
$body = @{
    demo = 123
    note = "Testing dev endpoint with tenant"
} | ConvertTo-Json
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/dev/try" -Method Post -Headers $headers -Body $body
```

#### curl.exe (Windows)
```cmd
curl.exe -u USERNAME:PASSWORD -H "Content-Type: application/json" -H "X-Tenant-ID: demo-a" -X POST https://PREVIEW_URL/api/dev/try -d "{\"demo\":123,\"note\":\"Testing dev endpoint with tenant\"}"
```

#### bash (Linux/Mac)
```bash
curl -u USERNAME:PASSWORD \
  -H "Content-Type: application/json" \
  -H "X-Tenant-ID: demo-a" \
  -X POST https://PREVIEW_URL/api/dev/try \
  -d '{"demo":123,"note":"Testing dev endpoint with tenant"}'
```

**Expected Response**:
```json
{
  "ok": true,
  "tenant": "demo-a",
  "echo": {
    "demo": 123,
    "note": "Testing dev endpoint with tenant"
  },
  "dryRun": true,
  "timestamp": "2024-01-15T10:30:45.123Z"
}
```

**Alternative: Tenant via Query Parameter**:
```powershell
# PowerShell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
    "Content-Type" = "application/json"
}
$body = @{
    demo = 456
    note = "Using query param for tenant"
} | ConvertTo-Json
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/dev/try?tenant=demo-b" -Method Post -Headers $headers -Body $body
```

```bash
# bash
curl -u USERNAME:PASSWORD \
  -H "Content-Type: application/json" \
  -X POST "https://PREVIEW_URL/api/dev/try?tenant=demo-b" \
  -d '{"demo":456,"note":"Using query param for tenant"}'
```

---

### Test D: POST /api/dev/try WITH Tenant + Invalid Body (400 Bad Request)
**Expected**: Returns precise field-level validation errors.

#### Test D1: Missing "demo" field
```powershell
# PowerShell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
    "Content-Type" = "application/json"
    "X-Tenant-ID" = "demo-c"
}
$body = @{
    note = "Missing demo field"
} | ConvertTo-Json
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/dev/try" -Method Post -Headers $headers -Body $body
```

```bash
# bash
curl -u USERNAME:PASSWORD \
  -H "Content-Type: application/json" \
  -H "X-Tenant-ID: demo-c" \
  -X POST https://PREVIEW_URL/api/dev/try \
  -d '{"note":"Missing demo field"}'
```

**Expected Response**:
```json
{
  "success": false,
  "error": "Validation failed",
  "details": [
    {
      "field": "demo",
      "message": "Field \"demo\" must be a number"
    }
  ]
}
```

#### Test D2: Invalid "demo" type (string instead of number)
```powershell
# PowerShell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
    "Content-Type" = "application/json"
    "X-Tenant-ID" = "demo-a"
}
$body = @{
    demo = "not a number"
    note = "Invalid demo type"
} | ConvertTo-Json
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/dev/try" -Method Post -Headers $headers -Body $body
```

```bash
# bash
curl -u USERNAME:PASSWORD \
  -H "Content-Type: application/json" \
  -H "X-Tenant-ID: demo-a" \
  -X POST https://PREVIEW_URL/api/dev/try \
  -d '{"demo":"not a number","note":"Invalid demo type"}'
```

**Expected Response**:
```json
{
  "success": false,
  "error": "Validation failed",
  "details": [
    {
      "field": "demo",
      "message": "Field \"demo\" must be a number"
    }
  ]
}
```

#### Test D3: Invalid "note" type (number instead of string)
```powershell
# PowerShell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
    "Content-Type" = "application/json"
    "X-Tenant-ID" = "demo-b"
}
$body = @{
    demo = 789
    note = 12345
} | ConvertTo-Json
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/dev/try" -Method Post -Headers $headers -Body $body
```

```bash
# bash
curl -u USERNAME:PASSWORD \
  -H "Content-Type: application/json" \
  -H "X-Tenant-ID: demo-b" \
  -X POST https://PREVIEW_URL/api/dev/try \
  -d '{"demo":789,"note":12345}'
```

**Expected Response**:
```json
{
  "success": false,
  "error": "Validation failed",
  "details": [
    {
      "field": "note",
      "message": "Field \"note\" must be a string if provided"
    }
  ]
}
```

#### Test D4: Malformed JSON
```bash
# bash
curl -u USERNAME:PASSWORD \
  -H "Content-Type: application/json" \
  -H "X-Tenant-ID: demo-a" \
  -X POST https://PREVIEW_URL/api/dev/try \
  -d '{"demo":123,note:"missing quotes"}'
```

**Expected Response**:
```json
{
  "success": false,
  "error": "Validation failed",
  "details": [
    {
      "field": "body",
      "message": "Request body must be valid JSON"
    }
  ]
}
```

---

## Quick Verification Table

| Test | Endpoint | Tenant | Payload | Expected Status | Expected Field |
|------|----------|--------|---------|----------------|----------------|
| A | GET /api/dev/status | optional | N/A | 200 | `ok: true` |
| B | POST /api/dev/try | (missing) | valid | 400 | `field: "tenant"` |
| C | POST /api/dev/try | demo-a | valid | 200 | `ok: true, echo` |
| D1 | POST /api/dev/try | demo-c | missing demo | 400 | `field: "demo"` |
| D2 | POST /api/dev/try | demo-a | demo: string | 400 | `field: "demo"` |
| D3 | POST /api/dev/try | demo-b | note: number | 400 | `field: "note"` |
| D4 | POST /api/dev/try | demo-a | malformed JSON | 400 | `field: "body"` |

---

## 📁 What's New in Phase 2

### New Files:
1. **src/dev/scratchpad.ts** - Safe helper utilities:
   - `safeJSONParse()` - JSON parsing with error handling
   - `devLog()` - Safe logging (no DB writes)
   - `echoPayload()` - Echo received data with timestamp
   - `validateDemoPayload()` - Payload validation

2. **TESTING_DEV.md** - This comprehensive testing guide

### Modified Files:
1. **src/index.tsx**:
   - Added import for scratchpad helpers
   - Added `GET /api/dev/status` endpoint (no tenant required)
   - Added tenant middleware for `/api/dev/try`
   - Added `POST /api/dev/try` endpoint (tenant required)

---

## 🔒 Security Notes

- All dev endpoints require Basic Auth
- `/api/dev/try` enforces tenant validation
- DRY_RUN mode prevents database writes
- All helpers in `scratchpad.ts` have zero side effects
- No medical calculators executed

---

## 🚨 Rollback Instructions

If issues are found:

1. **Close the PR** from GitHub UI
2. **Delete the branch**:
   ```bash
   git push origin --delete feat/my-first-mods-preview
   ```
3. Base branch `feat/tenant-scaffold-preview` remains intact

---

## ✅ What's Safe to Experiment With

Using these dev endpoints, you can safely:
- Test payload validation logic
- Experiment with tenant routing
- Try different request formats
- Debug authentication flows
- Test error handling

**WITHOUT**:
- Writing to database
- Executing medical calculators
- Affecting production data
- Changing secrets or credentials

---

## 📚 Next Steps

After testing these dev endpoints:
1. Add more helper functions to `src/dev/scratchpad.ts`
2. Create additional `/api/dev/*` endpoints for experimentation
3. Test integration patterns safely
4. Document learnings for production implementation
