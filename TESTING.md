# API Testing Guide - Windows PowerShell Compatible

## New Deployment
- **Deployment ID**: 08bdd226
- **URL**: https://08bdd226.longenix-prime.pages.dev
- **Alias**: https://mini-hardening-01.longenix-prime.pages.dev
- **Auth**: Basic Auth required (username: `preview`, password: from dashboard)

---

## Endpoints

### GET /api/ping - Health Check
**Purpose**: Verify service is running and DB is connected  
**Auth**: Basic Auth required  
**Response**: `{ok: true, env: "preview", db: boolean, timestamp: ISO string}`

### POST /api/assessment/comprehensive - Create Assessment
**Purpose**: Submit comprehensive health assessment  
**Auth**: Basic Auth required  
**Content-Type**: application/json  
**Body**: See minimal payload below

---

## Minimal Valid Payload

```json
{
  "demographics": {
    "fullName": "John Doe",
    "dateOfBirth": "1980-01-15",
    "gender": "male"
  }
}
```

**Field Rules**:
- `fullName`: 2-100 characters
- `dateOfBirth`: ISO date (YYYY-MM-DD), age 18-120 years
- `gender`: "male", "female", or "other" (exact match)

---

## Windows PowerShell Test Commands

**Note**: Replace `YOUR_PASSWORD` with your actual preview environment password from the Cloudflare dashboard.

### Test 1: Health Check (Ping)

```powershell
curl.exe -X GET "https://08bdd226.longenix-prime.pages.dev/api/ping" `
  -u "preview:YOUR_PASSWORD"
```

**Expected Output**:
```
HTTP status: 200
Body: {"ok":true,"env":"preview","db":true,"timestamp":"2025-11-25T...Z"}
```

---

### Test 2: Invalid Name (Too Short) - Expect 400

```powershell
curl.exe -v -X POST "https://08bdd226.longenix-prime.pages.dev/api/assessment/comprehensive" `
  -u "preview:YOUR_PASSWORD" `
  -H "Content-Type: application/json" `
  -d '{"demographics":{"fullName":"J","dateOfBirth":"1980-01-15","gender":"male"}}'
```

**Expected HTTP Status**: `400`

**Expected Response**:
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

**Key Lines in Output**:
```
< HTTP/2 400
< content-type: application/json
```

---

### Test 3: Out of Range Weight - Expect 400

```powershell
curl.exe -v -X POST "https://08bdd226.longenix-prime.pages.dev/api/assessment/comprehensive" `
  -u "preview:YOUR_PASSWORD" `
  -H "Content-Type: application/json" `
  -d '{"demographics":{"fullName":"Jane Doe","dateOfBirth":"1985-03-20","gender":"female"},"clinical":{"weight":5000}}'
```

**Expected HTTP Status**: `400`

**Expected Response**:
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

**Key Lines in Output**:
```
< HTTP/2 400
< content-type: application/json
```

---

### Test 4: Valid Minimal Payload - Expect 200

```powershell
# Generate unique email with timestamp
$timestamp = [int](Get-Date -UFormat %s)

curl.exe -v -X POST "https://08bdd226.longenix-prime.pages.dev/api/assessment/comprehensive" `
  -u "preview:YOUR_PASSWORD" `
  -H "Content-Type: application/json" `
  -d "{`\"demographics`\":{`\"fullName`\":`\"John Test`\",`\"dateOfBirth`\":`\"1980-05-15`\",`\"gender`\":`\"male`\",`\"email`\":`\"test${timestamp}@example.com`\"}}"
```

**Expected HTTP Status**: `200`

**Expected Response**:
```json
{
  "success": true,
  "sessionId": 123,
  "patientId": 456,
  "message": "Comprehensive assessment completed successfully"
}
```

**Key Lines in Output**:
```
< HTTP/2 200
< content-type: application/json
```

---

## Troubleshooting

### Getting 401 Unauthorized
- Verify your password is correct (check Cloudflare dashboard)
- Ensure you're using `-u "preview:PASSWORD"` format
- Check that your password doesn't contain special characters that need escaping

### Getting 400 Validation Error
- Check the `details` array in the response
- Each detail shows the exact `field` and `message`
- Fix the payload according to the validation rules

### Getting 500 Internal Error
- Check the error response for details
- Verify all required fields are present
- Ensure JSON is properly formatted
- Contact support if error persists after fixing payload

---

## Expected Test Results Summary

| Test | Endpoint | Expected Status | Expected Response |
|------|----------|----------------|-------------------|
| 1 | GET /api/ping | 200 | `{"ok":true,"db":true,...}` |
| 2 | POST (invalid name) | 400 | Validation error with field details |
| 3 | POST (out of range) | 400 | Validation error with field details |
| 4 | POST (valid minimal) | 200 | Success with sessionId and patientId |

---

## Notes

- All endpoints require Basic Auth
- Validation errors always return `{success, error, details[]}` structure
- No PHI is logged or exposed in error messages
- Timestamps in Test 4 prevent duplicate email errors
