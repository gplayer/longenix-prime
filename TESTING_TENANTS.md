# Testing Tenant Scaffold - Preview Environment

## ⚠️ PREVIEW ONLY - DRY_RUN Mode Active

This guide tests the tenant scaffold in **Preview environment only**.

- ✅ All endpoints require Basic Auth (`BASIC_AUTH_USER` / `BASIC_AUTH_PASS`)
- ✅ Assessment endpoints require valid tenant (`demo-a`, `demo-b`, or `demo-c`)
- ✅ DRY_RUN mode active: **NO database writes, NO calculator execution**
- ✅ Synthetic responses: `sessionId: 999001`, `patientId: 888001`

---

## 🔐 Prerequisites

Replace the following in all examples:
- `USERNAME:PASSWORD` - Your Basic Auth credentials
- `PREVIEW_URL` - Your Cloudflare Pages preview URL

---

## Test Scenarios

### Test 1: GET /api/tenants (200 OK)
**Expected**: Returns list of allowed tenants without requiring tenant header.

#### PowerShell
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
}
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/tenants" -Method Get -Headers $headers
```

#### curl.exe (Windows)
```cmd
curl.exe -u USERNAME:PASSWORD https://PREVIEW_URL/api/tenants
```

#### bash (Linux/Mac)
```bash
curl -u USERNAME:PASSWORD https://PREVIEW_URL/api/tenants
```

**Expected Response**:
```json
{
  "tenants": ["demo-a", "demo-b", "demo-c"]
}
```

---

### Test 2: GET /api/tenants/validate?tenant=invalid (400 Bad Request)
**Expected**: Returns validation error with `field: "tenant"`.

#### PowerShell
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
}
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/tenants/validate?tenant=invalid" -Method Get -Headers $headers
```

#### curl.exe (Windows)
```cmd
curl.exe -u USERNAME:PASSWORD "https://PREVIEW_URL/api/tenants/validate?tenant=invalid"
```

#### bash (Linux/Mac)
```bash
curl -u USERNAME:PASSWORD "https://PREVIEW_URL/api/tenants/validate?tenant=invalid"
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

### Test 3: GET /api/tenants/validate?tenant=demo-a (200 OK)
**Expected**: Returns success with valid tenant.

#### PowerShell
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
}
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/tenants/validate?tenant=demo-a" -Method Get -Headers $headers
```

#### curl.exe (Windows)
```cmd
curl.exe -u USERNAME:PASSWORD "https://PREVIEW_URL/api/tenants/validate?tenant=demo-a"
```

#### bash (Linux/Mac)
```bash
curl -u USERNAME:PASSWORD "https://PREVIEW_URL/api/tenants/validate?tenant=demo-a"
```

**Expected Response**:
```json
{
  "success": true,
  "tenant": "demo-a",
  "valid": true
}
```

---

### Test 4: POST /api/assessment/comprehensive WITHOUT tenant (400 Bad Request)
**Expected**: Returns validation error requiring tenant.

#### PowerShell
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
    "Content-Type" = "application/json"
}
$body = @{
    demographics = @{
        fullName = "Test User"
        dateOfBirth = "1980-01-01"
        gender = "male"
    }
} | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/assessment/comprehensive" -Method Post -Headers $headers -Body $body
```

#### curl.exe (Windows)
```cmd
curl.exe -u USERNAME:PASSWORD -H "Content-Type: application/json" -X POST https://PREVIEW_URL/api/assessment/comprehensive -d "{\"demographics\":{\"fullName\":\"Test User\",\"dateOfBirth\":\"1980-01-01\",\"gender\":\"male\"}}"
```

#### bash (Linux/Mac)
```bash
curl -u USERNAME:PASSWORD \
  -H "Content-Type: application/json" \
  -X POST https://PREVIEW_URL/api/assessment/comprehensive \
  -d '{"demographics":{"fullName":"Test User","dateOfBirth":"1980-01-01","gender":"male"}}'
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

### Test 5: POST /api/assessment/comprehensive WITH tenant via Header (200 OK - DRY_RUN)
**Expected**: Returns synthetic success with no DB writes.

#### PowerShell
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
    "Content-Type" = "application/json"
    "X-Tenant-ID" = "demo-a"
}
$body = @{
    demographics = @{
        fullName = "Test User"
        dateOfBirth = "1980-01-01"
        gender = "male"
    }
} | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/assessment/comprehensive" -Method Post -Headers $headers -Body $body
```

#### curl.exe (Windows)
```cmd
curl.exe -u USERNAME:PASSWORD -H "Content-Type: application/json" -H "X-Tenant-ID: demo-a" -X POST https://PREVIEW_URL/api/assessment/comprehensive -d "{\"demographics\":{\"fullName\":\"Test User\",\"dateOfBirth\":\"1980-01-01\",\"gender\":\"male\"}}"
```

#### bash (Linux/Mac)
```bash
curl -u USERNAME:PASSWORD \
  -H "Content-Type: application/json" \
  -H "X-Tenant-ID: demo-a" \
  -X POST https://PREVIEW_URL/api/assessment/comprehensive \
  -d '{"demographics":{"fullName":"Test User","dateOfBirth":"1980-01-01","gender":"male"}}'
```

**Expected Response**:
```json
{
  "success": true,
  "sessionId": 999001,
  "patientId": 888001,
  "tenant": "demo-a",
  "dryRun": true,
  "message": "DRY_RUN mode: No data written, no calculators executed"
}
```

---

### Test 6: POST /api/assessment/comprehensive WITH tenant via Query Param (200 OK - DRY_RUN)
**Expected**: Returns synthetic success using query parameter for tenant.

#### PowerShell
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))
    "Content-Type" = "application/json"
}
$body = @{
    demographics = @{
        fullName = "Test User"
        dateOfBirth = "1980-01-01"
        gender = "male"
    }
} | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri "https://PREVIEW_URL/api/assessment/comprehensive?tenant=demo-b" -Method Post -Headers $headers -Body $body
```

#### curl.exe (Windows)
```cmd
curl.exe -u USERNAME:PASSWORD -H "Content-Type: application/json" -X POST "https://PREVIEW_URL/api/assessment/comprehensive?tenant=demo-b" -d "{\"demographics\":{\"fullName\":\"Test User\",\"dateOfBirth\":\"1980-01-01\",\"gender\":\"male\"}}"
```

#### bash (Linux/Mac)
```bash
curl -u USERNAME:PASSWORD \
  -H "Content-Type: application/json" \
  -X POST "https://PREVIEW_URL/api/assessment/comprehensive?tenant=demo-b" \
  -d '{"demographics":{"fullName":"Test User","dateOfBirth":"1980-01-01","gender":"male"}}'
```

**Expected Response**:
```json
{
  "success": true,
  "sessionId": 999001,
  "patientId": 888001,
  "tenant": "demo-b",
  "dryRun": true,
  "message": "DRY_RUN mode: No data written, no calculators executed"
}
```

---

## Quick Verification Table

| Test | Endpoint | Tenant | Expected Status | Expected Field |
|------|----------|--------|----------------|----------------|
| 1 | GET /api/tenants | N/A | 200 | `tenants` array |
| 2 | GET /api/tenants/validate?tenant=invalid | invalid | 400 | `field: "tenant"` |
| 3 | GET /api/tenants/validate?tenant=demo-a | demo-a | 200 | `valid: true` |
| 4 | POST /api/assessment/comprehensive | (missing) | 400 | `field: "tenant"` |
| 5 | POST /api/assessment/comprehensive | demo-a (header) | 200 | `dryRun: true` |
| 6 | POST /api/assessment/comprehensive | demo-b (query) | 200 | `dryRun: true` |

---

## 🔒 Security Notes

- All requests require Basic Auth credentials
- Invalid credentials return `401 Unauthorized` with `WWW-Authenticate` header
- Assessment endpoints enforce tenant validation after auth
- DRY_RUN mode prevents any database modifications

---

## 🚨 Rollback Instructions

If issues are found:

1. **Close the PR** from GitHub UI
2. **Delete the branch**:
   ```bash
   git push origin --delete feat/tenant-scaffold-preview
   ```
3. Production remains unchanged and unaffected

---

## ✅ What's Changed

### Files Modified:
- `src/index.tsx` - Added Basic Auth middleware, tenant middleware, tenant endpoints, DRY_RUN logic

### New Features:
- Basic Auth protection for all `/api/*` routes
- Tenant validation middleware for `/api/assessment/*` routes
- DRY_RUN environment variable support (default: `true` in preview)
- Synthetic response IDs when DRY_RUN is active
- GET `/api/tenants` - List allowed tenants
- GET `/api/tenants/validate` - Validate tenant parameter

### Safety Guarantees:
- ✅ No production changes
- ✅ No database writes in DRY_RUN mode
- ✅ No calculator execution in DRY_RUN mode
- ✅ Preview-only deployment
