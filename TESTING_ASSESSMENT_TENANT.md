# Testing Guide: Assessment Tenant Header

**Feature**: Tenant validation for comprehensive assessment submission  
**Branch**: `fix/preview-assessment-tenant-header` (off `feat/my-first-mods-preview`)  
**Date**: 2025-11-30

---

## Background

### The Problem
The comprehensive assessment UI in preview (`/assessment/preview`) was failing with:
```json
{
  "success": false,
  "error": "Validation failed",
  "details": [{ "field": "tenant", "message": "Missing or invalid tenant" }]
}
```

### Root Cause
Backend tenant middleware (line 916-942 in `src/index.tsx`) requires `X-Tenant-ID` header for all `/api/assessment/*` endpoints, but the frontend assessment submission didn't include this header.

### The Fix
Added `X-Tenant-ID: 'demo-a'` header to the assessment submission request in `public/js/comprehensive-assessment.js`.

---

## How Tenant Is Passed

### Backend: Tenant Middleware

**Location**: `src/index.tsx` lines 915-942

```typescript
app.use('/api/assessment/*', async (c, next) => {
  // Extract tenant from header or query param
  const tenantFromHeader = c.req.header('X-Tenant-ID')
  const tenantFromQuery = c.req.query('tenant')
  const tenant = tenantFromHeader || tenantFromQuery
  
  // Validate tenant
  if (!tenant) {
    return c.json({
      success: false,
      error: 'Validation failed',
      details: [{ field: 'tenant', message: 'Missing or invalid tenant' }]
    }, 400)
  }
  
  if (!ALLOWED_TENANTS.includes(tenant)) {
    return c.json({
      success: false,
      error: 'Validation failed',
      details: [{ field: 'tenant', message: 'Missing or invalid tenant' }]
    }, 400)
  }
  
  // Set tenant in context for downstream handlers
  c.set('tenant', tenant)
  await next()
})
```

**Allowed Tenants** (line 31): `['demo-a', 'demo-b', 'demo-c']`

### Frontend: Assessment Submission

**Location**: `public/js/comprehensive-assessment.js` line 3129

**Before Fix**:
```javascript
const response = await fetch(`${this.apiBase}/api/assessment/comprehensive`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
    body: JSON.stringify(this.formData)
});
```

**After Fix**:
```javascript
const response = await fetch(`${this.apiBase}/api/assessment/comprehensive`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'X-Tenant-ID': 'demo-a'  // PREVIEW: Required for tenant validation
    },
    body: JSON.stringify(this.formData)
});
```

---

## Verification via Browser Dev Tools

### Step 1: Open Developer Tools
1. Navigate to the preview URL: https://feat-my-first-mods-preview.longenix-prime.pages.dev
2. Press **F12** to open DevTools
3. Go to the **Network** tab
4. Keep DevTools open

### Step 2: Submit Assessment
1. Fill out the comprehensive assessment form
2. Complete all required fields (fullName, dateOfBirth, gender, etc.)
3. Click **"Complete assessment"** button

### Step 3: Inspect Request Headers
1. In the Network tab, find the request: **POST api/assessment/comprehensive**
2. Click on the request to view details
3. Go to the **Headers** tab
4. Scroll down to **Request Headers**

**Expected Request Headers**:
```
Content-Type: application/json
X-Tenant-ID: demo-a
Authorization: Basic [encoded credentials]
```

### Step 4: Check Response
1. Still in the Network tab, go to the **Response** tab (or **Preview**)
2. Check the JSON response

**Expected Success Response**:
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

**Expected Failure Response (without tenant header)**:
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

## Manual Testing with curl

### Test Case 1: With Tenant Header (Should Succeed)
```bash
curl -X POST "http://localhost:3000/api/assessment/comprehensive" \
  -u "admin:changeme123" \
  -H "Content-Type: application/json" \
  -H "X-Tenant-ID: demo-a" \
  -d '{
    "fullName": "Test Patient",
    "dateOfBirth": "1980-01-01",
    "gender": "male",
    "email": "test@example.com"
  }'
```

**Expected Output**:
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

### Test Case 2: Without Tenant Header (Should Fail)
```bash
curl -X POST "http://localhost:3000/api/assessment/comprehensive" \
  -u "admin:changeme123" \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Test Patient",
    "dateOfBirth": "1980-01-01",
    "gender": "male",
    "email": "test@example.com"
  }'
```

**Expected Output**:
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

### Test Case 3: With Query Parameter (Alternative, Should Succeed)
```bash
curl -X POST "http://localhost:3000/api/assessment/comprehensive?tenant=demo-a" \
  -u "admin:changeme123" \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Test Patient",
    "dateOfBirth": "1980-01-01",
    "gender": "male",
    "email": "test@example.com"
  }'
```

**Expected Output**:
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

### Test Case 4: Invalid Tenant (Should Fail)
```bash
curl -X POST "http://localhost:3000/api/assessment/comprehensive" \
  -u "admin:changeme123" \
  -H "Content-Type: application/json" \
  -H "X-Tenant-ID: invalid-tenant" \
  -d '{
    "fullName": "Test Patient",
    "dateOfBirth": "1980-01-01",
    "gender": "male",
    "email": "test@example.com"
  }'
```

**Expected Output**:
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

## Testing Checklist

### Before Deployment
- [ ] Local dev server starts successfully (`npm run build && pm2 restart`)
- [ ] Assessment form loads without errors
- [ ] All probe endpoints still work:
  - [ ] POST /api/report/preview/ldl
  - [ ] POST /api/report/preview/vitaminD
  - [ ] POST /api/report/preview/hba1c
  - [ ] POST /api/report/preview/omega3

### Assessment Submission
- [ ] Fill out assessment form with valid data
- [ ] Submit assessment
- [ ] Check Network tab: `X-Tenant-ID: demo-a` present in request headers
- [ ] Response status: **200 OK**
- [ ] Response body: `"success": true`
- [ ] Response includes `"tenant": "demo-a"`
- [ ] Response includes `"dryRun": true` (in preview)

### Error Handling
- [ ] Removing `X-Tenant-ID` header causes validation error
- [ ] Invalid tenant value causes validation error
- [ ] Error message clearly indicates tenant issue

---

## Technical Notes

### DRY_RUN Mode
The preview environment runs with `DRY_RUN=true`, which means:
- No database writes occur
- No risk calculators execute
- Returns synthetic response: `sessionId: 999001`, `patientId: 888001`
- Safe for testing without affecting production data

### Tenant Context
After successful tenant validation, the middleware sets the tenant in the request context:
```typescript
c.set('tenant', tenant)
```

This allows downstream handlers (like the assessment endpoint) to access the validated tenant:
```typescript
const tenant = c.get('tenant')
```

### Multi-Tenant Architecture
The application supports multiple tenants (`demo-a`, `demo-b`, `demo-c`) for:
- Data isolation
- Environment separation
- Testing different configurations

---

## Troubleshooting

### Issue: "Validation failed: tenant" Error
**Cause**: Frontend didn't include `X-Tenant-ID` header  
**Fix**: Ensure `X-Tenant-ID: 'demo-a'` is in request headers (line 3132 in comprehensive-assessment.js)

### Issue: "Missing or invalid tenant" with Header Present
**Cause**: Tenant value not in `ALLOWED_TENANTS` list  
**Fix**: Use one of: `demo-a`, `demo-b`, `demo-c`

### Issue: Network tab shows header but still fails
**Cause**: Header may be stripped by proxy or CORS  
**Fix**: Check browser console for CORS errors; ensure same-origin request

---

## Success Criteria

✅ **Primary Goal**: Assessment submission succeeds without tenant validation error  
✅ **Request Headers**: Include `X-Tenant-ID: demo-a`  
✅ **Response**: `success: true` with `tenant: demo-a`  
✅ **No Regressions**: Dynamic probes (LDL, Vitamin D, HbA1c, Omega-3) unaffected  
✅ **DRY_RUN Mode**: No actual database writes in preview

---

**Branch**: `fix/preview-assessment-tenant-header`  
**Target**: `feat/my-first-mods-preview`  
**Status**: Ready for testing  
**Compliance**: AGENT_CONTROL_LGX_PREVIEW.md (preview only, no production changes)
