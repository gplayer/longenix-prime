# 🚀 Quick Reference - LonGenix Preview Environment

## 📍 Current Status

### Branches
- ✅ `feat/tenant-scaffold-preview` (Phase 1) - Commit: 371fc87
- ✅ `feat/my-first-mods-preview` (Phase 2) - Commit: 97d2470

### Local Preview
- **URL**: https://3000-iu8uyw7pqk7i18hv64mtt-6532622b.e2b.dev
- **Auth**: `admin:changeme123` (from .dev.vars)
- **Status**: ✅ Online, DRY_RUN=true

---

## 🔗 Quick Test Commands

### Phase 1 - Tenant Scaffold

```bash
# Test 1: List tenants
curl -u admin:changeme123 https://3000-iu8uyw7pqk7i18hv64mtt-6532622b.e2b.dev/api/tenants

# Test 2: Validate tenant
curl -u admin:changeme123 "https://3000-iu8uyw7pqk7i18hv64mtt-6532622b.e2b.dev/api/tenants/validate?tenant=demo-a"

# Test 3: Assessment with tenant
curl -u admin:changeme123 \
  -H "Content-Type: application/json" \
  -H "X-Tenant-ID: demo-a" \
  -X POST https://3000-iu8uyw7pqk7i18hv64mtt-6532622b.e2b.dev/api/assessment/comprehensive \
  -d '{"demographics":{"fullName":"Test User","dateOfBirth":"1980-01-01","gender":"male"}}'
```

### Phase 2 - Dev Sandbox

```bash
# Test 1: Dev status
curl -u admin:changeme123 https://3000-iu8uyw7pqk7i18hv64mtt-6532622b.e2b.dev/api/dev/status

# Test 2: Dev try with tenant
curl -u admin:changeme123 \
  -H "Content-Type: application/json" \
  -H "X-Tenant-ID: demo-a" \
  -X POST https://3000-iu8uyw7pqk7i18hv64mtt-6532622b.e2b.dev/api/dev/try \
  -d '{"demo":123,"note":"Quick test"}'
```

---

## 📋 New Endpoints

### Phase 1
| Endpoint | Method | Auth | Tenant | Description |
|----------|--------|------|--------|-------------|
| `/api/tenants` | GET | ✅ | ❌ | List allowed tenants |
| `/api/tenants/validate` | GET | ✅ | ❌ | Validate tenant param |
| `/api/assessment/comprehensive` | POST | ✅ | ✅ | Comprehensive assessment (DRY_RUN) |
| `/api/assessment/demo` | POST | ✅ | ✅ | Demo assessment (DRY_RUN) |

### Phase 2
| Endpoint | Method | Auth | Tenant | Description |
|----------|--------|------|--------|-------------|
| `/api/dev/status` | GET | ✅ | 🟡 | Dev environment status |
| `/api/dev/try` | POST | ✅ | ✅ | Safe experimentation endpoint |

**Legend**: ✅ Required | ❌ Not required | 🟡 Optional

---

## 🔑 Allowed Tenants

- `demo-a`
- `demo-b`
- `demo-c`

---

## 🎯 DRY_RUN Mode

When `DRY_RUN=true` (default in preview):
- ❌ No database writes
- ❌ No medical calculator execution
- ✅ Returns synthetic IDs: `sessionId: 999001`, `patientId: 888001`
- ✅ Includes `dryRun: true` in responses

---

## 📁 Key Files

### Implementation
- `src/index.tsx` - Main app with middleware and endpoints
- `src/dev/scratchpad.ts` - Safe helper utilities

### Testing
- `TESTING_TENANTS.md` - Phase 1 test guide
- `TESTING_DEV.md` - Phase 2 test guide

### Verification
- `PHASE1_VERIFICATION.md` - Phase 1 test results
- `PHASE2_VERIFICATION.md` - Phase 2 test results
- `DEPLOYMENT_SUMMARY.md` - Complete overview

### Configuration
- `.dev.vars` - Local environment variables (gitignored)
- `ecosystem.config.cjs` - PM2 configuration

---

## 🛠️ Common Commands

### Server Management
```bash
# Start server
pm2 start ecosystem.config.cjs

# Restart server
pm2 restart longenix-preview

# Check logs
pm2 logs longenix-preview --nostream

# Stop server
pm2 delete longenix-preview
```

### Build & Deploy
```bash
# Build
npm run build

# Deploy to Cloudflare (after API key setup)
npx wrangler pages deploy dist --project-name longenix-assessment --branch BRANCH_NAME
```

### Git Operations
```bash
# View current branch
git branch

# Switch branches
git checkout feat/tenant-scaffold-preview
git checkout feat/my-first-mods-preview

# View commit log
git log --oneline -5

# Push to GitHub (after auth setup)
git push -u origin BRANCH_NAME
```

---

## ⚠️ Manual Steps Required

### 1. GitHub Push
```bash
# Setup GitHub authentication first, then:
cd /home/user/webapp
git push -u origin feat/tenant-scaffold-preview
git push -u origin feat/my-first-mods-preview
```

### 2. Cloudflare Deployment
1. Go to **Deploy tab** in sidebar
2. Configure Cloudflare API key
3. Run deployment commands

### 3. Create PRs
- **PR #1**: `feat/tenant-scaffold-preview` → `main`
- **PR #2**: `feat/my-first-mods-preview` → `feat/tenant-scaffold-preview`

See `DEPLOYMENT_SUMMARY.md` for PR templates.

---

## 🔄 Quick Rollback

### Phase 2 Only
```bash
pm2 delete longenix-preview
git checkout feat/tenant-scaffold-preview
git branch -D feat/my-first-mods-preview
```

### Both Phases
```bash
pm2 delete longenix-preview
git checkout main
git branch -D feat/tenant-scaffold-preview feat/my-first-mods-preview
```

---

## 📊 Test Results

- **Phase 1**: ✅ 6/6 tests passed
- **Phase 2**: ✅ 5/5 tests passed
- **Total**: ✅ 11/11 tests passed (100%)

---

## 🎉 Success Indicators

- ✅ All middleware working
- ✅ All endpoints responding correctly
- ✅ Tenant validation enforced
- ✅ DRY_RUN mode active
- ✅ No production changes
- ✅ Comprehensive documentation
- ✅ Local testing complete

---

## 📞 Next Actions

1. ⏸️ **GitHub**: Setup authentication and push branches
2. ⏸️ **Cloudflare**: Configure API key and deploy
3. ⏸️ **PRs**: Create pull requests with templates from DEPLOYMENT_SUMMARY.md
4. ⏸️ **Testing**: Share preview URLs with team
5. ⏸️ **Review**: Get feedback and iterate

---

**For detailed information, see**:
- Full overview: `DEPLOYMENT_SUMMARY.md`
- Phase 1 tests: `TESTING_TENANTS.md`
- Phase 2 tests: `TESTING_DEV.md`
- Test results: `PHASE1_VERIFICATION.md` and `PHASE2_VERIFICATION.md`
