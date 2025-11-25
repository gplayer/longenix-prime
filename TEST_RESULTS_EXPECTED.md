# Expected Test Results - Validation Fix

## Preview Deployment
**Debug Console**: https://fix-validation-paths-and-min.longenix-prime.pages.dev/debug/console

---

## Test Scenario A: Invalid Short Name

### Request
**Click**: "❌ Invalid: Short Name" button in Debug Console

**Payload**:
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

**Status Badge**: 🟡 400 Bad Request

**Status Line**:
```
HTTP/2 400 Bad Request (XXXms)
```

**Response Body**:
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

### Success Criteria
- ✅ HTTP status is **400**
- ✅ `details[0].field` equals **"demographics.fullName"** (not "unknown")
- ✅ Error message is clear and human-readable
- ✅ Response structure matches: `{success, error, details[]}`

---

## Test Scenario B: Invalid Huge Weight

### Request
**Click**: "❌ Invalid: Huge Weight" button in Debug Console

**Payload**:
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

**Status Badge**: 🟡 400 Bad Request

**Status Line**:
```
HTTP/2 400 Bad Request (XXXms)
```

**Response Body**:
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

### Success Criteria
- ✅ HTTP status is **400**
- ✅ `details[0].field` equals **"clinical.weight"** (not "unknown")
- ✅ Error message is clear and human-readable
- ✅ Response structure matches: `{success, error, details[]}`

---

## Test Scenario C: Valid Minimal Payload

### Request
**Click**: "✅ Valid: Minimal Payload" button in Debug Console

**Payload** (with dynamic timestamp):
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

**Note**: The Debug Console automatically injects `Date.now()` into the email to ensure uniqueness.

### Expected Response

**Status Badge**: 🟢 200 OK

**Status Line**:
```
HTTP/2 200 OK (XXXms)
```

**Response Body**:
```json
{
  "success": true,
  "sessionId": 789,
  "patientId": 234,
  "message": "Comprehensive assessment completed successfully"
}
```

**Note**: The actual `sessionId` and `patientId` values will be auto-generated integers from the database.

### Success Criteria
- ✅ HTTP status is **200** (or 201)
- ✅ `success` is **true**
- ✅ Response includes `sessionId` (integer)
- ✅ Response includes `patientId` (integer)
- ✅ Response includes success message
- ✅ No errors or 500 responses

---

## How to Copy-Paste Results

### Step 1: Test in Browser
1. Open: https://fix-validation-paths-and-min.longenix-prime.pages.dev/debug/console
2. Enter Basic Auth credentials when prompted
3. Run each of the three tests

### Step 2: Copy Status Line
For each test, copy the status line shown in the console, e.g.:
```
HTTP/2 400 Bad Request (234ms)
```

### Step 3: Copy Response Body
For each test, copy the entire JSON response body from the "Response Body" section.

### Step 4: Format for PR
Paste results in this format:

```
## Actual Test Results

### Test A: Invalid Short Name
Status: HTTP/2 400 Bad Request (234ms)
Response:
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

### Test B: Invalid Huge Weight
Status: HTTP/2 400 Bad Request (187ms)
Response:
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

### Test C: Valid Minimal Payload
Status: HTTP/2 200 OK (456ms)
Response:
{
  "success": true,
  "sessionId": 789,
  "patientId": 234,
  "message": "Comprehensive assessment completed successfully"
}
```

---

## What to Look For

### ✅ PASS Indicators
- Test A: `field: "demographics.fullName"` (NOT "unknown")
- Test B: `field: "clinical.weight"` (NOT "unknown")
- Test C: HTTP 200 with `success: true`
- All responses have consistent structure
- No 500 errors
- No "unknown" field paths
- Human-readable error messages

### ❌ FAIL Indicators
- Any test returns `field: "unknown"`
- Test C returns 500 or 422
- Test C returns `success: false`
- Missing `sessionId` or `patientId` in Test C
- Error messages are cryptic or include stack traces
- Responses have inconsistent structure

---

## Quick Verification Commands

If you prefer command-line testing (requires Basic Auth credentials):

### Test A (curl)
```bash
curl -u "USERNAME:PASSWORD" \
  -X POST \
  "https://fix-validation-paths-and-min.longenix-prime.pages.dev/api/assessment/comprehensive" \
  -H "Content-Type: application/json" \
  -d '{"demographics":{"fullName":"J","dateOfBirth":"1980-01-15","gender":"male"}}' \
  | jq
```

### Test B (curl)
```bash
curl -u "USERNAME:PASSWORD" \
  -X POST \
  "https://fix-validation-paths-and-min.longenix-prime.pages.dev/api/assessment/comprehensive" \
  -H "Content-Type: application/json" \
  -d '{"demographics":{"fullName":"Jane Doe","dateOfBirth":"1985-03-20","gender":"female"},"clinical":{"weight":5000}}' \
  | jq
```

### Test C (curl)
```bash
curl -u "USERNAME:PASSWORD" \
  -X POST \
  "https://fix-validation-paths-and-min.longenix-prime.pages.dev/api/assessment/comprehensive" \
  -H "Content-Type: application/json" \
  -d "{\"demographics\":{\"fullName\":\"John Test\",\"dateOfBirth\":\"1980-05-15\",\"gender\":\"male\",\"email\":\"test$(date +%s)@example.com\"}}" \
  | jq
```

---

## Additional Validation

### Multiple Errors Test
To verify multiple validation errors work correctly, you can manually test:

**Payload**:
```json
{
  "demographics": {
    "fullName": "A",
    "dateOfBirth": "1980-01-15",
    "gender": "male"
  },
  "clinical": {
    "weight": 5000,
    "height": 10
  }
}
```

**Expected**: Should return multiple entries in `details[]` array:
```json
{
  "success": false,
  "error": "Validation failed",
  "details": [
    {
      "field": "demographics.fullName",
      "message": "Full name must be at least 2 characters"
    },
    {
      "field": "clinical.weight",
      "message": "Weight cannot exceed 500 kg"
    },
    {
      "field": "clinical.height",
      "message": "Height must be at least 50 cm"
    }
  ]
}
```

---

## Troubleshooting

### Issue: Getting 401 Unauthorized
**Solution**: Ensure you're entering the correct Basic Auth credentials. These should be the same credentials used for other longenix-prime preview environments.

### Issue: Getting 500 Instead of 400
**Solution**: This indicates the validation fix didn't deploy correctly. Check deployment logs and verify build succeeded.

### Issue: Getting "unknown" in field paths
**Solution**: This indicates the code changes didn't take effect. Verify you're testing the correct deployment URL (c9f49940 deployment ID).

### Issue: Test C returns 422 or 500
**Solution**: Check the error message for details. Common causes:
- Calculator missing required fields (should be handled now)
- Database constraint violation (check email uniqueness)
- ATM normalization failure (should fallback to raw data now)

---

## PR Approval Criteria

Before approving the PR, confirm:
- [ ] All three tests completed without errors
- [ ] Test A shows `field: "demographics.fullName"`
- [ ] Test B shows `field: "clinical.weight"`
- [ ] Test C shows `success: true` with sessionId and patientId
- [ ] No test results show `field: "unknown"`
- [ ] All error messages are human-readable
- [ ] Response structures are consistent across all tests
- [ ] No PHI or sensitive data in error messages

---

**Document Version**: 1.0  
**Created**: 2025-11-25  
**Deployment**: c9f49940  
**Branch**: fix/validation-paths-and-minimal-success
