# Testing Cloudflare Pages Preview - feat/my-first-mods-preview

## 🌐 Preview URLs

- **Deployment URL**: https://44a5873d.longenix-prime.pages.dev
- **Branch Alias**: https://feat-my-first-mods-preview.longenix-prime.pages.dev

---

## 🔐 Authentication

All endpoints require Basic Auth:
- **Username**: `admin`
- **Password**: `changeme123`

Tenant-required endpoints need:
- **Header**: `X-Tenant-ID: demo-a` (or `demo-b`, `demo-c`)

---

## ✅ Test Scenarios

### Test 1: GET /api/tenants (200 OK)

Returns list of allowed tenants.

#### PowerShell
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:changeme123"))
}
Invoke-RestMethod -Uri "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/tenants" -Method Get -Headers $headers
```

**Expected Response**:
```json
{
  "tenants": ["demo-a", "demo-b", "demo-c"]
}
```

---

### Test 2: GET /api/dev/status (200 OK)

Returns dev environment status with optional tenant.

#### PowerShell (without tenant)
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:changeme123"))
}
Invoke-RestMethod -Uri "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/dev/status" -Method Get -Headers $headers
```

#### PowerShell (with tenant)
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:changeme123"))
    "X-Tenant-ID" = "demo-a"
}
Invoke-RestMethod -Uri "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/dev/status" -Method Get -Headers $headers
```

**Expected Response**:
```json
{
  "ok": true,
  "env": "preview",
  "dryRun": true,
  "tenant": "demo-a",
  "time": "2025-11-25T09:00:00.000Z"
}
```

---

### Test 3: POST /api/dev/try (200 OK with tenant)

Safe experimentation endpoint that echoes received data.

#### PowerShell
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:changeme123"))
    "Content-Type" = "application/json"
    "X-Tenant-ID" = "demo-a"
}
$body = @{
    demo = 123
    note = "check"
} | ConvertTo-Json
Invoke-RestMethod -Uri "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/dev/try" -Method Post -Headers $headers -Body $body
```

**Expected Response**:
```json
{
  "ok": true,
  "tenant": "demo-a",
  "echo": {
    "demo": 123,
    "note": "check"
  },
  "dryRun": true,
  "timestamp": "2025-11-25T09:00:00.000Z"
}
```

---

### Test 4: POST /api/assessment/comprehensive (200 OK - DRY_RUN)

Assessment endpoint with minimal demographics, returns synthetic IDs.

#### PowerShell
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:changeme123"))
    "Content-Type" = "application/json"
    "X-Tenant-ID" = "demo-b"
}
$body = @{
    demographics = @{
        fullName = "Test User"
        dateOfBirth = "1980-01-01"
        gender = "male"
    }
} | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/assessment/comprehensive" -Method Post -Headers $headers -Body $body
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

## 🔧 Alternative: Using Query Parameter for Tenant

You can also pass tenant via query parameter instead of header:

#### PowerShell
```powershell
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:changeme123"))
    "Content-Type" = "application/json"
}
$body = @{
    demo = 456
    note = "query param test"
} | ConvertTo-Json
Invoke-RestMethod -Uri "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/dev/try?tenant=demo-c" -Method Post -Headers $headers -Body $body
```

---

## 🛡️ Safety Guarantees

- ✅ **DRY_RUN=true**: No database writes
- ✅ **Preview Only**: Production unchanged
- ✅ **Synthetic IDs**: sessionId 999001, patientId 888001
- ✅ **No Calculators**: Medical algorithms not executed

---

## 📋 Quick Verification

Run all tests in sequence:

```powershell
# Test 1: List tenants
$auth = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:changeme123"))
$headers = @{ Authorization = $auth }
Write-Host "Test 1: GET /api/tenants"
Invoke-RestMethod -Uri "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/tenants" -Headers $headers

# Test 2: Dev status
Write-Host "`nTest 2: GET /api/dev/status"
Invoke-RestMethod -Uri "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/dev/status" -Headers $headers

# Test 3: Dev try
$headers["X-Tenant-ID"] = "demo-a"
$headers["Content-Type"] = "application/json"
$body = @{ demo = 123; note = "check" } | ConvertTo-Json
Write-Host "`nTest 3: POST /api/dev/try"
Invoke-RestMethod -Uri "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/dev/try" -Method Post -Headers $headers -Body $body

# Test 4: Assessment (dry-run)
$body = @{ demographics = @{ fullName = "Test User"; dateOfBirth = "1980-01-01"; gender = "male" } } | ConvertTo-Json -Depth 5
Write-Host "`nTest 4: POST /api/assessment/comprehensive"
Invoke-RestMethod -Uri "https://feat-my-first-mods-preview.longenix-prime.pages.dev/api/assessment/comprehensive" -Method Post -Headers $headers -Body $body
```

---

## ✅ Expected Results Summary

| Test | Endpoint | Status | Key Field |
|------|----------|--------|-----------|
| 1 | GET /api/tenants | 200 | `tenants: ["demo-a", "demo-b", "demo-c"]` |
| 2 | GET /api/dev/status | 200 | `dryRun: true` |
| 3 | POST /api/dev/try | 200 | `echo.demo: 123` |
| 4 | POST /api/assessment/comprehensive | 200 | `sessionId: 999001, patientId: 888001` |

All responses should include authentication success and proper tenant validation.
