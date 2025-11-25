# Testing Guide - Validation Paths + Minimal Payload Success

## Quick Test via Debug Console

### Access the Console
**URL**: https://fix-validation-paths-and-min.longenix-prime.pages.dev/debug/console

Enter your Basic Auth credentials when prompted, then run the three test scenarios below.

---

## Test Scenario A: Invalid Short Name → 400 with Precise Field Path

### How to Test
1. Click the **"❌ Invalid: Short Name"** button
2. Click **"🚀 Send Request"**

### Request Payload
```json
{
  "demographics": {
    "fullName": "J",
    "dateOfBirth": "1980-01-15",
    "gender": "male"
  }
}
```

### Expected Response
**Status**: 🟡 400 Bad Request

**Body**:
```json
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

### ✅ Success Criteria
- HTTP status is **400**
- `details[0].field` equals **"demographics.fullName"** (not "unknown")
- Error message is human-readable

---

## Test Scenario B: Invalid Huge Weight → 400 with Precise Field Path

### How to Test
1. Click the **"❌ Invalid: Huge Weight"** button
2. Click **"🚀 Send Request"**

### Request Payload
```json
{
  "demographics": {
    "fullName": "Jane Doe",
    "dateOfBirth": "1985-03-20",
    "gender": "female"
  },
  "clinical": {
    "weight": 5000
  }
}
```

### Expected Response
**Status**: 🟡 400 Bad Request

**Body**:
```json
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

### ✅ Success Criteria
- HTTP status is **400**
- `details[0].field` equals **"clinical.weight"** (not "unknown")
- Error message is human-readable

---

## Test Scenario C: Valid Minimal Payload → 200 with Success Response

### How to Test
1. Click the **"✅ Valid: Minimal Payload"** button
2. Click **"🚀 Send Request"**

### Request Payload
```json
{
  "demographics": {
    "fullName": "John Test",
    "dateOfBirth": "1980-05-15",
    "gender": "male",
    "email": "test1732545678000@example.com"
  }
}
```

**Note**: The email includes a timestamp to ensure uniqueness. The console automatically injects `Date.now()` into the email field.

### Expected Response
**Status**: 🟢 200 OK (or 201 Created)

**Body**:
```json
{
  "success": true,
  "sessionId": 123,
  "patientId": 456,
  "message": "Comprehensive assessment completed successfully"
}
```

### ✅ Success Criteria
- HTTP status is **200** or **201**
- `success` is **true**
- Response includes `sessionId` (number)
- Response includes `patientId` (number)
- Response includes success message

### What Changed to Support Minimal Payload
1. **Validation**: Demographics-only payload now passes validation
2. **Normalization**: Optional fields (clinical, biomarkers) preserved as undefined/empty
3. **Calculators**: Use safe defaults for missing height/weight/BP values
4. **Database**: All inserts handle minimal data gracefully
5. **ATM Normalization**: Wrapped in try/catch to handle incomplete data

---

## Alternative: Command-Line Testing (PowerShell)

If you prefer testing via PowerShell instead of the browser console:

### Prerequisites
- Replace `USERNAME:PASSWORD` with your actual Basic Auth credentials
- PowerShell 5.1+ or PowerShell Core 7+

### Test A: Invalid Short Name
```powershell
$body = @{
    demographics = @{
        fullName = "J"
        dateOfBirth = "1980-01-15"
        gender = "male"
    }
} | ConvertTo-Json

$cred = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))

Invoke-RestMethod `
  -Uri "https://fix-validation-paths-and-min.longenix-prime.pages.dev/api/assessment/comprehensive" `
  -Method POST `
  -Headers @{ Authorization = "Basic $cred"; "Content-Type" = "application/json" } `
  -Body $body
```

**Expected**: 400 error with `field: "demographics.fullName"`

### Test B: Invalid Huge Weight
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

Invoke-RestMethod `
  -Uri "https://fix-validation-paths-and-min.longenix-prime.pages.dev/api/assessment/comprehensive" `
  -Method POST `
  -Headers @{ Authorization = "Basic $cred"; "Content-Type" = "application/json" } `
  -Body $body
```

**Expected**: 400 error with `field: "clinical.weight"`

### Test C: Valid Minimal Payload
```powershell
$timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()

$body = @{
    demographics = @{
        fullName = "John Test"
        dateOfBirth = "1980-05-15"
        gender = "male"
        email = "test$timestamp@example.com"
    }
} | ConvertTo-Json

$cred = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("USERNAME:PASSWORD"))

Invoke-RestMethod `
  -Uri "https://fix-validation-paths-and-min.longenix-prime.pages.dev/api/assessment/comprehensive" `
  -Method POST `
  -Headers @{ Authorization = "Basic $cred"; "Content-Type" = "application/json" } `
  -Body $body
```

**Expected**: 200 success with `sessionId`, `patientId`, and success message

---

## Alternative: curl (Linux/Mac/WSL)

### Test A: Invalid Short Name
```bash
curl -u "USERNAME:PASSWORD" \
  -X POST \
  "https://fix-validation-paths-and-min.longenix-prime.pages.dev/api/assessment/comprehensive" \
  -H "Content-Type: application/json" \
  -d '{"demographics":{"fullName":"J","dateOfBirth":"1980-01-15","gender":"male"}}' \
  | jq
```

### Test B: Invalid Huge Weight
```bash
curl -u "USERNAME:PASSWORD" \
  -X POST \
  "https://fix-validation-paths-and-min.longenix-prime.pages.dev/api/assessment/comprehensive" \
  -H "Content-Type: application/json" \
  -d '{"demographics":{"fullName":"Jane Doe","dateOfBirth":"1985-03-20","gender":"female"},"clinical":{"weight":5000}}' \
  | jq
```

### Test C: Valid Minimal Payload
```bash
curl -u "USERNAME:PASSWORD" \
  -X POST \
  "https://fix-validation-paths-and-min.longenix-prime.pages.dev/api/assessment/comprehensive" \
  -H "Content-Type: application/json" \
  -d "{\"demographics\":{\"fullName\":\"John Test\",\"dateOfBirth\":\"1980-05-15\",\"gender\":\"male\",\"email\":\"test$(date +%s)@example.com\"}}" \
  | jq
```

---

## What Was Fixed

### 1. Precise Validation Field Paths
**Before**: Validation errors returned `field: "unknown"`

**After**: Validation errors return precise dot-notation paths like `demographics.fullName` or `clinical.weight`

**Changes**:
- Enhanced `formatValidationError()` in `src/validation.ts` to ensure path arrays are properly joined
- Removed the fallback error handler that was masking proper validation errors

### 2. Minimal Payload Success
**Before**: Minimal demographics-only payload caused 500 errors

**After**: Minimal payload with only demographics succeeds with 200 response

**Changes**:
- Updated `normalizeAssessmentData()` to preserve optional fields as undefined
- Added safe defaults in patientData construction (height: 170, weight: 70, BP: 120/80)
- Wrapped calculator calls in try/catch to return 422 on calculation errors
- Wrapped ATM normalization in try/catch to handle incomplete data gracefully

### 3. Enhanced Error Handling
**Before**: Internal errors leaked stack traces or returned generic 500s

**After**: Domain errors return 422 with helpful messages, unknown errors return 500 with fingerprint

**Error Response Patterns**:
- **400**: Validation errors (schema violations)
- **422**: Domain/calculation errors (e.g., "Medical calculation failed: ...")
- **500**: Unexpected system errors (no PHI, includes error fingerprint)

---

## Files Modified

### `src/validation.ts`
- Enhanced `formatValidationError()` to ensure proper path joining
- Updated `normalizeAssessmentData()` to not force defaults on optional clinical fields

### `src/index.tsx`
- Removed fallback error handler that returned `field: "unknown"`
- Wrapped calculator calls in try/catch block
- Wrapped ATM normalization in try/catch block
- Added safe defaults in patientData construction for minimal payload support

---

## Preview Deployment

- **Branch**: `fix/validation-paths-and-minimal-success`
- **Deployment ID**: `c9f49940`
- **Debug Console**: https://fix-validation-paths-and-min.longenix-prime.pages.dev/debug/console
- **API Base URL**: https://fix-validation-paths-and-min.longenix-prime.pages.dev

---

## Success Checklist

Before approving this PR, verify:
- [ ] Test A returns 400 with `field: "demographics.fullName"`
- [ ] Test B returns 400 with `field: "clinical.weight"`
- [ ] Test C returns 200 with `success: true, sessionId, patientId`
- [ ] No field paths contain "unknown" in validation errors
- [ ] Multiple validation errors show multiple entries in details array
- [ ] All error messages are human-readable
- [ ] No PHI exposure in error responses

---

## Next Steps

1. **Test in Browser**: Visit the Debug Console URL above
2. **Run All Three Tests**: Verify responses match expectations
3. **Copy-Paste Results**: Document actual responses for PR
4. **Create PR**: Use title "fix: precise validation paths + minimal payload success (Preview only)"
5. **Review & Merge**: If all tests pass, approve and merge to main

---

**Document Version**: 1.0  
**Created**: 2025-11-25  
**Branch**: fix/validation-paths-and-minimal-success  
**Deployment**: c9f49940
