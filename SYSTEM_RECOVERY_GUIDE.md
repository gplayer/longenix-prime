# 🛡️ LongenixHealth System Recovery Guide

## 📅 Backup Created: August 27, 2025

### 🎯 **SYSTEM STATUS: FULLY OPERATIONAL** ✅

This guide provides complete instructions to restore your LongenixHealth system to its fully working state.

## 🔄 **Multiple Recovery Options Available**

### **Option 1: Project Backup Download (RECOMMENDED)**
- **Backup URL**: https://page.gensparksite.com/project_backups/tooluse_CA-GKbZQQQNmCqti6QeGV6Q.tar.gz
- **Size**: 133 KB (compressed)
- **Created**: August 27, 2025, 02:03 UTC
- **Status**: Complete working system with all fixes applied

**Recovery Steps**:
```bash
# 1. Download and extract the backup
wget https://page.gensparksite.com/project_backups/tooluse_CA-GKbZQQQNmCqti6QeGV6Q.tar.gz
tar -xzf tooluse_CA-GKbZQQQNmCqti6QeGV6Q.tar.gz
cd home/user/LongenixHealth

# 2. Install dependencies
npm install

# 3. Apply database migrations
npx wrangler d1 migrations apply longenix-assessment-production --local

# 4. Start the system
npm run build
pm2 start ecosystem.config.cjs

# 5. Verify system is working
curl http://localhost:3000
```

### **Option 2: GitHub Repository Clone**
- **Repository**: https://github.com/gplayer/LonGenixP3
- **Latest Commit**: dd2d10a (Database configuration fixes)
- **Status**: All fixes pushed and synchronized

**Recovery Steps**:
```bash
# 1. Clone repository
git clone https://github.com/gplayer/LonGenixP3.git LongenixHealth
cd LongenixHealth

# 2. Install dependencies
npm install

# 3. Apply database migrations
npx wrangler d1 migrations apply longenix-assessment-production --local

# 4. Start the system
npm run build
pm2 start ecosystem.config.cjs

# 5. Verify system is working
curl http://localhost:3000
```

## 🔧 **Critical Configuration Details**

### **Database Configuration**
- **Database Name**: `longenix-assessment-production`
- **Database ID**: `b74cb302-2299-4fd7-8086-42c1ee465f58`
- **Binding**: `DB`
- **Local Storage**: `.wrangler/state/v3/d1/`

### **Key Configuration Files Fixed**
1. **ecosystem.config.cjs**: Uses correct database name
2. **package.json**: All scripts use consistent database name
3. **wrangler.jsonc**: Main configuration file (source of truth)

### **PM2 Process Configuration**
- **Process Name**: `longenix-p3`
- **Working Directory**: `/home/user/LongenixHealth` (CRITICAL!)
- **Command**: `wrangler pages dev dist --d1=longenix-assessment-production --local --ip 0.0.0.0 --port 3000`

## ⚡ **Quick Verification Checklist**

After recovery, verify these components:

1. **✅ Server Running**:
   ```bash
   pm2 list
   # Should show longenix-p3 as 'online'
   ```

2. **✅ Database Tables Exist**:
   ```bash
   npx wrangler d1 execute longenix-assessment-production --local --command="SELECT name FROM sqlite_master WHERE type='table';"
   # Should show: patients, assessment_sessions, clinical_assessments, biomarkers, etc.
   ```

3. **✅ API Working**:
   ```bash
   curl -X POST http://localhost:3000/api/auth/login -H "Content-Type: application/json" -d '{"password": "#*LonGenix42", "country": "US"}'
   # Should return: {"success": true, "country": "US", "message": "Authentication successful"}
   ```

4. **✅ Comprehensive Assessment**:
   ```bash
   curl -X POST http://localhost:3000/api/assessment/comprehensive -H "Content-Type: application/json" -d '{"demographics": {"fullName": "Test User", "dateOfBirth": "1990-01-01", "gender": "male"}, "sessionId": "test123"}'
   # Should return: {"success": true, "sessionId": 1, "patientId": 1, "message": "Comprehensive assessment completed successfully"}
   ```

## 🚨 **What Was Fixed in This Version**

### **Issue Resolution Summary**:
1. **Database Configuration Mismatch**: Aligned all config files to use `longenix-assessment-production`
2. **PM2 Directory Issue**: Fixed PM2 to run from correct directory (`/home/user/LongenixHealth`)
3. **Database Tables Missing**: Applied all 4 migration files successfully
4. **API 500 Errors**: Resolved "no such table: patients" error
5. **Authentication Modal**: Working correctly with sessionStorage management

### **Files Modified**:
- `ecosystem.config.cjs`: Updated database name parameter
- `package.json`: Updated all database script references
- Applied migrations: 4 migration files executed successfully

## 🎯 **Working Features Confirmed**

### **✅ Fully Operational**:
- Authentication system with password `#*LonGenix42`
- Country selection (US, Australia, Philippines)
- Comprehensive assessment form (8-step process)
- Real-time biomarker validation
- Dynamic report generation
- Database persistence (all assessment data saved)
- PM2 process management
- GitHub synchronization

### **✅ API Endpoints Working**:
- `POST /api/auth/login` - Authentication
- `POST /api/assessment/comprehensive` - Assessment submission
- All static file serving (`/css/`, `/js/`, etc.)

## 🔗 **Access Information**

### **Authentication Credentials**:
- **Password**: `#*LonGenix42`
- **Countries**: US, Australia, Philippines

### **URLs**:
- **Local Development**: http://localhost:3000
- **Public Access**: Use GetServiceUrl tool to generate public sandbox URL
- **Production**: https://longenix-assessment.pages.dev (requires Cloudflare deployment)

## 📋 **Dependencies**

### **Required Tools**:
- Node.js 20.19.3+
- npm
- PM2 (pre-installed in sandbox)
- Wrangler CLI

### **Key NPM Packages**:
- hono: ^4.0.0
- wrangler: ^3.78.0
- vite: ^5.0.0
- @hono/vite-cloudflare-pages: ^0.4.2
- @cloudflare/workers-types: 4.20250705.0

## 🛠️ **Troubleshooting**

### **Common Issues & Solutions**:

1. **Port 3000 in use**:
   ```bash
   fuser -k 3000/tcp 2>/dev/null || true
   ```

2. **Database tables missing**:
   ```bash
   npx wrangler d1 migrations apply longenix-assessment-production --local
   ```

3. **PM2 not starting**:
   ```bash
   cd /home/user/LongenixHealth  # CRITICAL: Correct directory
   pm2 delete longenix-p3 2>/dev/null || true
   pm2 start ecosystem.config.cjs
   ```

4. **Authentication modal not showing**:
   - Clear browser sessionStorage or use incognito mode
   - Check browser console for JavaScript errors

## 📞 **Support Information**

### **System Metadata**:
- **Project Code Name**: LongenixHealth
- **Cloudflare Project**: longenix-assessment
- **GitHub Repository**: gplayer/LonGenixP3
- **Backup Date**: August 27, 2025
- **Last Commit**: dd2d10a

### **Dr. Graham Player, Ph.D - Longenix Health**
*Professional Healthcare Innovation Consultant*  
**Predict • Prevent • Persist**

---

**🎉 This backup represents a FULLY OPERATIONAL system with all major issues resolved and comprehensive assessment functionality working perfectly.**