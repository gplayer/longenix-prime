# API Testing Guide for longenix-prime

## Endpoints to Test

### POST /api/assessment/comprehensive
**Purpose**: Create a new comprehensive health assessment  
**Auth**: Basic Auth (username: `preview`, password: from dashboard)  
**Content-Type**: `application/json`

---

## Minimal Valid Payload

The **absolute minimum** required fields for a successful 200/201 response:

```json
{
  "demographics": {
    "fullName": "John Doe",
    "dateOfBirth": "1980-01-15",
    "gender": "male"
  }
}
```

**Required Field Rules**:
- `fullName`: String, 2-100 characters
- `dateOfBirth`: ISO date string (YYYY-MM-DD), must result in age 18-120 years
- `gender`: Enum - must be exactly `"male"`, `"female"`, or `"other"`

**Optional Fields** (will use defaults if omitted):
- `demographics.ethnicity`: String
- `demographics.email`: Valid email or empty string
- `demographics.phone`: String
- `clinical`: Object with `height`, `weight`, `systolicBP`, `diastolicBP` (all optional)
- `biomarkers`: Object with various biomarkers (all optional, nullable)

---

## Windows PowerShell Test Examples

### Test 1: Invalid Payload (400 - Name Too Short)

```powershell
curl.exe -X POST "https://mini-hardening-01.longenix-prime.pages.dev/api/assessment/comprehensive" `
  -H "Content-Type: application/json" `
  -H "Authorization: Basic cHJldmlldzpZT1VSX1BBU1NXT1JEX0hFUkU=" `
  -d '{\"demographics\":{\"fullName\":\"J\",\"dateOfBirth\":\"1980-01-15\",\"gender\":\"male\"}}'
```

**Expected Response** (HTTP 400):
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

---

### Test 2: Invalid Payload (400 - Age Too Young)

```powershell
curl.exe -X POST "https://mini-hardening-01.longenix-prime.pages.dev/api/assessment/comprehensive" `
  -H "Content-Type: application/json" `
  -H "Authorization: Basic cHJldmlldzpZT1VSX1BBU1NXT1JEX0hFUkU=" `
  -d '{\"demographics\":{\"fullName\":\"Jane Doe\",\"dateOfBirth\":\"2020-01-01\",\"gender\":\"female\"}}'
```

**Expected Response** (HTTP 400):
```json
{
  "success": false,
  "error": "Validation failed",
  "details": [
    {
      "field": "demographics.dateOfBirth",
      "message": "Invalid date of birth - must be between 18 and 120 years old"
    }
  ]
}
```

---

### Test 3: Invalid Payload (400 - Out of Range Biomarker)

```powershell
curl.exe -X POST "https://mini-hardening-01.longenix-prime.pages.dev/api/assessment/comprehensive" `
  -H "Content-Type: application/json" `
  -H "Authorization: Basic cHJldmlldzpZT1VSX1BBU1NXT1JEX0hFUkU=" `
  -d '{\"demographics\":{\"fullName\":\"Jane Doe\",\"dateOfBirth\":\"1985-03-20\",\"gender\":\"female\"},\"clinical\":{\"weight\":5000}}'
```

**Expected Response** (HTTP 400):
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

---

### Test 4: Valid Minimal Payload (200/201 - Success)

```powershell
$timestamp = [int](Get-Date -UFormat %s)
curl.exe -X POST "https://mini-hardening-01.longenix-prime.pages.dev/api/assessment/comprehensive" `
  -H "Content-Type: application/json" `
  -H "Authorization: Basic cHJldmlldzpZT1VSX1BBU1NXT1JEX0hFUkU=" `
  -d "{`\"demographics`\":{`\"fullName`\":`\"John Test`\",`\"dateOfBirth`\":`\"1980-05-15`\",`\"gender`\":`\"male`\",`\"email`\":`\"test${timestamp}@example.com`\"}}"
```

**Expected Response** (HTTP 200):
```json
{
  "success": true,
  "sessionId": 123,
  "patientId": 456,
  "message": "Comprehensive assessment completed successfully"
}
```

---

### Test 5: Valid Payload with Optional Fields (200/201 - Success)

```powershell
$timestamp = [int](Get-Date -UFormat %s)
curl.exe -X POST "https://mini-hardening-01.longenix-prime.pages.dev/api/assessment/comprehensive" `
  -H "Content-Type: application/json" `
  -H "Authorization: Basic cHJldmlldzpZT1VSX1BBU1NXT1JEX0hFUkU=" `
  -d "{`\"demographics`\":{`\"fullName`\":`\"John Test Full`\",`\"dateOfBirth`\":`\"1980-05-15`\",`\"gender`\":`\"male`\",`\"email`\":`\"fulltest${timestamp}@example.com`\",`\"ethnicity`\":`\"caucasian`\",`\"phone`\":`\"+1-555-0123`\"},`\"clinical`\":{`\"height`\":178,`\"weight`\":82,`\"systolicBP`\":125,`\"diastolicBP`\":82},`\"biomarkers`\":{`\"glucose`\":95,`\"hba1c`\":5.4,`\"totalCholesterol`\":185}}"
```

**Expected Response** (HTTP 200):
```json
{
  "success": true,
  "sessionId": 124,
  "patientId": 457,
  "message": "Comprehensive assessment completed successfully"
}
```

---

## Notes on Authorization Header

The Authorization header uses Basic Auth. To create your own header:

```powershell
# Encode username:password in Base64
$credentials = "preview:YOUR_ACTUAL_PASSWORD"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
$base64 = [Convert]::ToBase64String($bytes)
Write-Output "Authorization: Basic $base64"
```

Then use the output in your curl commands:
```powershell
-H "Authorization: Basic <your_base64_string>"
```

---

## Troubleshooting

### Getting 401 Unauthorized
- Check that your Basic Auth credentials are correct
- Ensure the Authorization header is properly formatted
- Try testing with `-u preview:PASSWORD` instead of manual header

### Getting 400 with validation errors
- Review the `details` array in the response
- Each detail shows the exact `field` and `message` for the validation error
- Fix the payload according to the error messages

### Getting 500 Internal Error
- Check server logs for error fingerprint
- Verify the request body is valid JSON
- Ensure all required fields are present
- Contact support if the error persists
