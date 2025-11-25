# Preview Stabilization - Emergency Fix Tests

## Deployment Information
- **Branch**: `fix/preview-stabilize-500s`
- **Deployment ID**: `1707e5d7`
- **Preview URL**: https://fix-preview-stabilize-500s.longenix-prime.pages.dev
- **Status**: ✅ LIVE - Dry-run mode active

## What Changed
This is an **EMERGENCY STABILIZATION** to fix 500 errors in Preview:

1. **Minimal Validation Schema**: Replaced complex AssessmentIntakeSchema with MinimalIntakeSchema
   - Demographics: fullName (min 2 chars), dateOfBirth (YYYY-MM-DD regex), gender (enum)
   - Clinical: weight (max 500 kg), height (max 300 cm) - both optional
   - Strict mode, no passthrough fields

2. **Hardened Endpoint**: Completely rewrote `/api/assessment/comprehensive`
   - OUTER try/catch guards entire function (catches ALL exceptions)
   - Two-phase parsing: read raw text → parse JSON
   - Content-Type validation
   - Returns dot-notation validation paths
   - **DRY-RUN MODE**: No calculators, no DB writes

3. **Synthetic Success Response**:
   ```json
   {
     "success": true,
     "sessionId": 999001,
     "patientId": 888001,
     "message": "Comprehensive assessment (dry-run) accepted"
   }
   ```

## Three Test Scenarios

### Prerequisites
- Replace `USERNAME:PASSWORD` with your actual Basic Auth credentials
- All tests use PowerShell (Windows)
- Alternatively, use the Debug Console: https://fix-preview-stabilize-500s.longenix-prime.pages.dev/debug/console

---

### Test A: Invalid Short Name → 400 with `demographics.fullName`

**PowerShell**:
```powershell
$body = @{
    demographics = @{
        fullName = "J"
        dateOfBirth = "1980-01-15"
        gender = "male"
    }
} | ConvertTo-Json

$cred = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))

try {
    Invoke-RestMethod `
      -Uri "https://fix-preview-stabilize-500s.longenix-prime.pages.dev/api/assessment/comprehensive" `
      -Method POST `
      -Headers @{ Authorization = "Basic $cred"; "Content-Type" = "application/json" } `
      -Body $body
} catch {
    $_.Exception.Response.StatusCode.value__
    $_ | ConvertFrom-Json
}
```

**Expected Response**:
```
Status: 400

{
  "success": false,
  "error": "Validation failed",
  "details": [
    {
      "field": "demographics.fullName",
      "message": "Full name must be at least 2 characters"
    }
  ]
}
```

✅ **Success Criteria**: 
- Status is **400** (not 500)
- `details[0].field` equals **"demographics.fullName"** (not "unknown")
- Error message is human-readable

---

### Test B: Invalid Huge Weight → 400 with `clinical.weight`

**PowerShell**:
```powershell
$body = @{
    demographics = @{
        fullName = "Jane Doe"
        dateOfBirth = "1985-03-20"
        gender = "female"
    }
    clinical = @{
        weight = 5000
    }
} | ConvertTo-Json

$cred = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))

try {
    Invoke-RestMethod `
      -Uri "https://fix-preview-stabilize-500s.longenix-prime.pages.dev/api/assessment/comprehensive" `
      -Method POST `
      -Headers @{ Authorization = "Basic $cred"; "Content-Type" = "application/json" } `
      -Body $body
} catch {
    $_.Exception.Response.StatusCode.value__
    $_ | ConvertFrom-Json
}
```

**Expected Response**:
```
Status: 400

{
  "success": false,
  "error": "Validation failed",
  "details": [
    {
      "field": "clinical.weight",
      "message": "Weight cannot exceed 500 kg"
    }
  ]
}
```

✅ **Success Criteria**:
- Status is **400** (not 500)
- `details[0].field` equals **"clinical.weight"** (not "unknown")
- Error message is human-readable

---

### Test C: Valid Minimal Payload → 200 with Synthetic Success

**PowerShell**:
```powershell
$timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()

$body = @{
    demographics = @{
        fullName = "John Test"
        dateOfBirth = "1980-05-15"
        gender = "male"
    }
} | ConvertTo-Json

$cred = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))

Invoke-RestMethod `
  -Uri "https://fix-preview-stabilize-500s.longenix-prime.pages.dev/api/assessment/comprehensive" `
  -Method POST `
  -Headers @{ Authorization = "Basic $cred"; "Content-Type" = "application/json" } `
  -Body $body
```

**Expected Response**:
```
Status: 200

{
  "success": true,
  "sessionId": 999001,
  "patientId": 888001,
  "message": "Comprehensive assessment (dry-run) accepted"
}
```

✅ **Success Criteria**:
- Status is **200** (not 500, not 422)
- `success` is **true**
- Response includes synthetic IDs: `sessionId: 999001`, `patientId: 888001`
- Response includes dry-run message

---

## Alternative: curl (Linux/Mac/WSL)

### Test A: Invalid Short Name
```bash
curl -u "USERNAME:PASSWORD" \
  -X POST \
  "https://fix-preview-stabilize-500s.longenix-prime.pages.dev/api/assessment/comprehensive" \
  -H "Content-Type: application/json" \
  -d '{"demographics":{"fullName":"J","dateOfBirth":"1980-01-15","gender":"male"}}' \
  -w "\nStatus: %{http_code}\n" | jq
```

### Test B: Invalid Huge Weight
```bash
curl -u "USERNAME:PASSWORD" \
  -X POST \
  "https://fix-preview-stabilize-500s.longenix-prime.pages.dev/api/assessment/comprehensive" \
  -H "Content-Type: application/json" \
  -d '{"demographics":{"fullName":"Jane Doe","dateOfBirth":"1985-03-20","gender":"female"},"clinical":{"weight":5000}}' \
  -w "\nStatus: %{http_code}\n" | jq
```

### Test C: Valid Minimal
```bash
curl -u "USERNAME:PASSWORD" \
  -X POST \
  "https://fix-preview-stabilize-500s.longenix-prime.pages.dev/api/assessment/comprehensive" \
  -H "Content-Type: application/json" \
  -d '{"demographics":{"fullName":"John Test","dateOfBirth":"1980-05-15","gender":"male"}}' \
  -w "\nStatus: %{http_code}\n" | jq
```

---

## Verification Unauthenticated (expect 401)

```bash
curl -X POST "https://fix-preview-stabilize-500s.longenix-prime.pages.dev/api/assessment/comprehensive" \
  -H "Content-Type: application/json" \
  -d '{"demographics":{"fullName":"Test","dateOfBirth":"1980-01-15","gender":"male"}}' \
  -w "\nStatus: %{http_code}\n"
```

**Expected**: `Unauthorized` with status **401** ✅ **CONFIRMED**

---

## Debug Console Alternative

If PowerShell/curl is difficult, use the browser Debug Console:

**URL**: https://fix-preview-stabilize-500s.longenix-prime.pages.dev/debug/console

1. Enter Basic Auth credentials
2. Click "❌ Invalid: Short Name" → Send Request
3. Click "❌ Invalid: Huge Weight" → Send Request
4. Click "✅ Valid: Minimal Payload" → Send Request

---

## Important Notes

### ⚠️ DRY-RUN MODE ACTIVE
- **No Database Writes**: No patient records created
- **No Calculators**: No biological age or risk calculations
- **Synthetic IDs**: sessionId=999001, patientId=888001 (fake)
- **Purpose**: Validate request parsing and validation paths ONLY

### ✅ What This Proves
- JSON parsing works correctly
- Content-Type validation works
- Zod validation produces precise dot-notation paths
- Invalid inputs return 400 (not 500)
- Valid minimal payload returns 200 (not 500)
- All exceptions caught (no unhandled 500s escape)

### 🔄 Next Steps After Confirmation
Once all three tests pass:
1. ✅ Validation is stable
2. ✅ Error paths are correct
3. 🔜 Re-enable calculators and DB writes
4. 🔜 Test full flow end-to-end
5. 🔜 Merge to main after full testing

---

## Safety Confirmation

✅ **Preview Only**: No production changes  
✅ **No Schema Changes**: Database not modified  
✅ **No Calculator Execution**: Medical algorithms not run  
✅ **No Data Persistence**: Nothing written to database  
✅ **Basic Auth Protected**: All endpoints require authentication  
✅ **No PHI Exposure**: Error messages sanitized  

---

## PR Information

**Title**: `fix: preview stabilize 500s (dry-run intake, strict parsing, safe validation)`

**Create PR**: https://github.com/gplayer/longenix-prime/compare/main...fix/preview-stabilize-500s

**Key Changes**:
- Added MinimalIntakeSchema with strict validation
- Replaced comprehensive endpoint with minimal dry-run handler
- OUTER try/catch prevents all unhandled exceptions
- Hardened JSON parsing with Content-Type validation
- Dot-notation error paths for precise validation feedback
- Synthetic success response (no side effects)

---

**Document Version**: 1.0  
**Created**: 2025-11-25  
**Branch**: fix/preview-stabilize-500s  
**Deployment**: 1707e5d7  
**Status**: Emergency Stabilization - Dry-Run Mode
