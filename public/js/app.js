// Longenix Health Assessment System - Main Application
// Dr. Graham Player, Ph.D - Longenix Health

class LongenixAssessment {
    constructor() {
        this.isAuthenticated = false;
        this.selectedCountry = null;
        this.assessmentData = {};
        this.apiBase = this.getApiBase();
        
        this.init();
    }

    getApiBase() {
        // Detect if we're running on Cloudflare Pages or GitHub Pages
        if (window.location.hostname.includes('pages.dev')) {
            return '/api'; // Cloudflare Pages with Hono backend
        } else if (window.location.hostname.includes('github.io')) {
            return null; // GitHub Pages - use client-side calculations
        } else {
            return '/api'; // Local development
        }
    }

    init() {
        console.log('🚀 App initializing, document ready state:', document.readyState);
        
        if (document.readyState === 'loading') {
            console.log('⏳ Document still loading, waiting for DOMContentLoaded');
            document.addEventListener('DOMContentLoaded', () => {
                console.log('📄 DOMContentLoaded fired');
                this.setupEventListeners();
                this.checkAuthStatus();
            });
        } else {
            console.log('✅ Document ready, setting up immediately');
            this.setupEventListeners();
            this.checkAuthStatus();
        }
    }

    setupEventListeners() {
        console.log('🔧 Setting up event listeners');
        
        // Authentication form
        const authForm = document.getElementById('authForm');
        const passwordInput = document.getElementById('systemPassword');
        const countrySelect = document.getElementById('countrySelect');
        
        console.log('📋 Form elements check:', { 
            authForm: !!authForm, 
            passwordInput: !!passwordInput, 
            countrySelect: !!countrySelect 
        });
        
        if (authForm) {
            // Remove any existing event listeners
            authForm.onsubmit = null;
            
            // Add event listener with proper binding
            // Add multiple event listeners to ensure we catch the submission
            console.log('🔧 Adding submit event listener...');
            
            const submitHandler = (e) => {
                console.log('📝 ======= FORM SUBMIT EVENT TRIGGERED =======');
                console.log('⏰ Event timestamp:', new Date().toISOString());
                console.log('🎯 Event details:', {
                    type: e.type,
                    target: e.target.tagName,
                    targetId: e.target.id,
                    defaultPrevented: e.defaultPrevented,
                    isTrusted: e.isTrusted,
                    bubbles: e.bubbles,
                    cancelable: e.cancelable
                });
                
                console.log('🔍 Form values at event time:', {
                    password: document.getElementById('systemPassword')?.value ? 'present' : 'empty',
                    country: document.getElementById('countrySelect')?.value
                });
                
                console.log('🚀 Calling handleAuth...');
                try {
                    this.handleAuth(e);
                } catch (handlerError) {
                    console.error('💥 Error in handleAuth:', handlerError);
                }
                console.log('📝 ======= FORM SUBMIT EVENT HANDLER COMPLETED =======');
            };
            
            // Bind the handler to preserve 'this' context
            const boundHandler = submitHandler.bind(this);
            
            authForm.addEventListener('submit', boundHandler);
            console.log('✅ Submit event listener added');
            
            // Also add listeners to capture any form interaction
            authForm.addEventListener('click', (e) => {
                console.log('🖱️ Form clicked:', e.target.tagName, e.target.type);
            });
            
            // Add listener to submit button specifically
            const submitBtn = authForm.querySelector('button[type="submit"]');
            if (submitBtn) {
                console.log('🔘 Submit button found, adding click listener');
                submitBtn.addEventListener('click', (e) => {
                    console.log('🔘 ======= SUBMIT BUTTON CLICKED =======');
                    console.log('🎯 Button click details:', {
                        target: e.target.tagName,
                        type: e.target.type,
                        defaultPrevented: e.defaultPrevented
                    });
                    // Don't prevent default here - let it trigger form submit
                });
            } else {
                console.error('❌ Submit button not found!');
            }
            

            
            console.log('✅ Auth form event listeners added');
        } else {
            console.error('❌ Auth form not found!');
        }

        // Logout button
        const logoutBtn = document.getElementById('logoutBtn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', () => this.logout());
        }

        // Assessment method buttons are handled by onclick in HTML
    }

    checkAuthStatus() {
        const savedAuth = sessionStorage.getItem('longenix_auth');
        if (savedAuth) {
            const authData = JSON.parse(savedAuth);
            this.isAuthenticated = true;
            this.selectedCountry = authData.country;
            this.showMainContent();
        }
    }

    async handleAuth(event) {
        try {
            console.log('🔐 ======= AUTHENTICATION ATTEMPT STARTED =======');
        } catch (e) {
            console.error('💥 Error in logging attempt start:', e);
        }
        
        try {
            console.log('📅 Timestamp:', new Date().toISOString());
            console.log('🎯 Event details:', {
                type: event?.type,
                target: event?.target?.tagName,
                targetId: event?.target?.id,
                isTrusted: event?.isTrusted
            });
        } catch (e) {
            console.error('💥 Error in event logging:', e);
        }
        
        try {
            event.preventDefault();
            console.log('✋ Default form submission prevented');
        } catch (e) {
            console.error('💥 Error in preventDefault:', e);
        }
        
        let password, country, errorDiv;
        
        try {
            console.log('🔍 Getting password element...');
            const passwordElement = document.getElementById('systemPassword');
            console.log('📝 Password element found:', !!passwordElement);
            password = passwordElement ? passwordElement.value : '';
            console.log('🔑 Password extracted:', password ? 'present' : 'empty');
        } catch (e) {
            console.error('💥 Error getting password:', e);
            password = '';
        }
        
        try {
            console.log('🔍 Getting country element...');
            const countryElement = document.getElementById('countrySelect');
            console.log('🌍 Country element found:', !!countryElement);
            country = countryElement ? countryElement.value : '';
            console.log('🏴 Country extracted:', country);
        } catch (e) {
            console.error('💥 Error getting country:', e);
            country = '';
        }
        
        try {
            console.log('🔍 Getting error div element...');
            errorDiv = document.getElementById('authError');
            console.log('🚨 Error div found:', !!errorDiv);
        } catch (e) {
            console.error('💥 Error getting error div:', e);
        }
        
        try {
            console.log('📝 Form data extracted:', { 
                password: password ? `${password.substring(0, 3)}...` : 'empty',
                passwordLength: password ? password.length : 0,
                country: country,
                apiBase: this.apiBase 
            });
        } catch (e) {
            console.error('💥 Error in form data logging:', e);
        }
        
        try {
            console.log('🔍 DOM elements check:', {
                passwordInput: !!document.getElementById('systemPassword'),
                countrySelect: !!document.getElementById('countrySelect'),
                errorDiv: !!errorDiv,
                authModal: !!document.getElementById('authModal'),
                mainContent: !!document.getElementById('mainContent')
            });
        } catch (e) {
            console.error('💥 Error in DOM elements check:', e);
        }
        
        // Hide any previous errors
        try {
            if (errorDiv) {
                errorDiv.classList.add('hidden');
                console.log('👻 Error div hidden');
            } else {
                console.warn('⚠️ Error div not found!');
            }
        } catch (e) {
            console.error('💥 Error hiding error div:', e);
        }
        
        try {
            if (this.apiBase) {
                console.log('🌐 Using server-side authentication');
                console.log('🔗 API endpoint:', `${this.apiBase}/auth/login`);
                
                const requestBody = { password, country };
                console.log('📤 Request payload:', { ...requestBody, password: requestBody.password ? `${requestBody.password.substring(0, 3)}...` : 'empty' });
                
                console.log('⏳ Making fetch request...');
                const response = await fetch(`${this.apiBase}/auth/login`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(requestBody)
                });
                
                console.log('📡 Server response received:', {
                    status: response.status,
                    statusText: response.statusText,
                    ok: response.ok,
                    headers: {
                        contentType: response.headers.get('content-type')
                    }
                });
                
                console.log('📄 Parsing JSON response...');
                const result = await response.json();
                console.log('📄 Response data:', result);
                
                if (result.success) {
                    console.log('✅ Server authentication successful!');
                    console.log('🎉 Calling authenticateSuccess with country:', country);
                    this.authenticateSuccess(country);
                } else {
                    console.log('❌ Server authentication failed:', result.error);
                    console.log('🔄 Calling showAuthError...');
                    this.showAuthError(result.error || 'Authentication failed');
                }
            } else {
                console.log('💻 Using client-side authentication (no apiBase)');
                console.log('🔑 Checking password and country...');
                console.log('🔍 Password check:', password === '#*LonGenix42');
                console.log('🔍 Country check:', ['US', 'Australia', 'Philippines'].includes(country));
                
                // Client-side authentication (GitHub Pages)
                if (password === '#*LonGenix42' && ['US', 'Australia', 'Philippines'].includes(country)) {
                    console.log('✅ Client-side authentication successful');
                    this.authenticateSuccess(country);
                } else {
                    console.log('❌ Client-side authentication failed');
                    this.showAuthError('Invalid password or country selection');
                }
            }
        } catch (error) {
            console.error('💥 Authentication error details:', {
                name: error.name,
                message: error.message,
                stack: error.stack
            });
            console.log('🔄 Calling showAuthError for exception...');
            this.showAuthError('Authentication service unavailable');
        }
        
        console.log('🔐 ======= AUTHENTICATION ATTEMPT COMPLETED =======');
    }

    authenticateSuccess(country) {
        console.log('🎉 ======= AUTHENTICATION SUCCESS =======');
        console.log('🌍 Country:', country);
        console.log('⏰ Timestamp:', new Date().toISOString());
        
        console.log('📝 Setting instance variables...');
        this.isAuthenticated = true;
        this.selectedCountry = country;
        console.log('✅ Instance variables set:', {
            isAuthenticated: this.isAuthenticated,
            selectedCountry: this.selectedCountry
        });
        
        // Save authentication state
        const authData = {
            authenticated: true,
            country: country,
            timestamp: new Date().getTime()
        };
        
        console.log('💾 Saving to sessionStorage...');
        try {
            sessionStorage.setItem('longenix_auth', JSON.stringify(authData));
            console.log('✅ SessionStorage saved successfully:', authData);
            
            // Verify it was saved
            const saved = sessionStorage.getItem('longenix_auth');
            console.log('🔍 Verification - saved data:', saved);
        } catch (storageError) {
            console.error('❌ SessionStorage error:', storageError);
        }
        
        console.log('🎭 Calling showMainContent...');
        this.showMainContent();
        console.log('🎉 ======= AUTHENTICATION SUCCESS COMPLETED =======');
    }

    showAuthError(message) {
        console.log('🚨 ======= SHOWING AUTH ERROR =======');
        console.log('📝 Error message:', message);
        
        const errorDiv = document.getElementById('authError');
        const errorMessage = document.getElementById('authErrorMessage');
        
        console.log('🔍 Error elements check:', {
            errorDiv: !!errorDiv,
            errorMessage: !!errorMessage
        });
        
        if (errorMessage) {
            errorMessage.textContent = message;
            console.log('✅ Error message text set');
        } else {
            console.error('❌ Error message element not found!');
        }
        
        if (errorDiv) {
            errorDiv.classList.remove('hidden');
            console.log('👁️ Error div shown');
            console.log('🎨 Error div classes:', errorDiv.className);
        } else {
            console.error('❌ Error div not found!');
        }
        
        console.log('🚨 ======= AUTH ERROR DISPLAY COMPLETED =======');
    }

    showMainContent() {
        console.log('🎭 ======= SHOWING MAIN CONTENT =======');
        
        const authModal = document.getElementById('authModal');
        const mainContent = document.getElementById('mainContent');
        
        console.log('🔍 DOM elements found:', { 
            authModal: !!authModal, 
            mainContent: !!mainContent 
        });
        
        if (authModal) {
            console.log('🎨 Auth modal current classes:', authModal.className);
            authModal.classList.add('hidden');
            console.log('👻 Auth modal hidden, new classes:', authModal.className);
        } else {
            console.error('❌ Auth modal not found!');
        }
        
        if (mainContent) {
            console.log('🎨 Main content current classes:', mainContent.className);
            mainContent.classList.remove('hidden');
            console.log('👁️ Main content shown, new classes:', mainContent.className);
        } else {
            console.error('❌ Main content not found!');
        }
        
        // Update country display
        const countryDisplay = document.getElementById('selectedCountry');
        console.log('🏷️ Country display element:', !!countryDisplay);
        
        if (countryDisplay) {
            countryDisplay.textContent = this.selectedCountry;
        }
    }

    logout() {
        this.isAuthenticated = false;
        this.selectedCountry = null;
        sessionStorage.removeItem('longenix_auth');
        
        document.getElementById('authModal').classList.remove('hidden');
        document.getElementById('mainContent').classList.add('hidden');
        
        // Clear form
        document.getElementById('systemPassword').value = '';
        document.getElementById('countrySelect').value = '';
    }

    startAssessment(method) {
        if (!this.isAuthenticated) {
            alert('Please authenticate first');
            return;
        }

        // Show loading
        this.showLoadingOverlay(true);

        // Handle different assessment methods
        switch(method) {
            case 'comprehensive':
                // Redirect to comprehensive assessment form
                window.location.href = '/comprehensive-assessment';
                break;
                
            case 'manual':
                // Redirect to quick assessment form
                window.location.href = '/assessment';
                break;
            
            case 'demo':
                // Load demo data and generate report
                this.loadDemoData();
                break;
                
            case 'upload':
                alert('File upload functionality coming soon!');
                this.showLoadingOverlay(false);
                break;
                
            case 'existing':
                alert('Client management system coming soon!');
                this.showLoadingOverlay(false);
                break;
                
            default:
                alert('Unknown assessment method');
                this.showLoadingOverlay(false);
        }
    }

    loadDemoData(demoType = 'usa_optimal') {
        // Generate a demo report with sample data
        // This will create a session with demo patient data
        fetch('/api/assessment/demo', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                country: this.selectedCountry,
                demoType: demoType
            })
        })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                // Redirect to demo report
                window.location.href = `/report?session=${result.sessionId}&demo=true`;
            } else {
                alert('Failed to load demo data: ' + result.error);
            }
        })
        .catch(error => {
            console.error('Demo data error:', error);
            alert('Failed to load demo data');
        })
        .finally(() => {
            this.showLoadingOverlay(false);
        });
    }

    showLoadingOverlay(show) {
        const overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            if (show) {
                overlay.classList.remove('hidden');
            } else {
                overlay.classList.add('hidden');
            }
        }
    }

    viewSampleReport() {
        if (!this.isAuthenticated) {
            alert('Please authenticate first');
            return;
        }
        
        // Load demo and show report
        this.startAssessment('demo');

        switch (method) {
            case 'manual':
                this.startManualAssessment();
                break;
            case 'upload':
                this.startFileUpload();
                break;
            case 'demo':
                this.startDemoClient();
                break;
            case 'existing':
                this.startExistingReports();
                break;
        }
    }

    startManualAssessment() {
        // Navigate to assessment form
        window.location.href = './assessment-form.html';
    }

    startFileUpload() {
        // Create file upload interface
        const input = document.createElement('input');
        input.type = 'file';
        input.multiple = true;
        input.accept = '.pdf,.csv,.txt,.xml';
        
        input.onchange = (event) => {
            const files = Array.from(event.target.files);
            this.handleFileUpload(files);
        };
        
        input.click();
    }

    async handleFileUpload(files) {
        this.showLoading(true);
        
        try {
            const processedData = await this.processUploadedFiles(files);
            
            if (processedData) {
                // Store processed data and navigate to review page
                sessionStorage.setItem('assessment_data', JSON.stringify(processedData));
                window.location.href = './comprehensive-report.html?upload=true';
            }
        } catch (error) {
            console.error('File upload error:', error);
            alert('Error processing files. Please try manual entry instead.');
        }
        
        this.showLoading(false);
    }

    async processUploadedFiles(files) {
        // In a production system, this would:
        // 1. Upload files to server
        // 2. Use OCR/AI to extract data from PDFs
        // 3. Parse CSV files
        // 4. Return structured data
        
        // For now, return simulated data
        return {
            method: 'upload',
            files: files.map(f => ({ name: f.name, size: f.size, type: f.type })),
            client: {
                name: 'John Doe',
                age: 52,
                gender: 'male'
            },
            extractedData: {
                demographics: {
                    age: 52,
                    gender: 'male',
                    height: 178,
                    weight: 85
                },
                labValues: {
                    glucose: 98,
                    cholesterol: 195,
                    hdl: 45,
                    triglycerides: 135,
                    creatinine: 1.1,
                    albumin: 4.0
                },
                timestamp: new Date().toISOString()
            }
        };
    }

    startDemoClient() {
        // Load demo client data and navigate to comprehensive report
        const demoData = this.generateDemoClientData();
        sessionStorage.setItem('assessment_data', JSON.stringify(demoData));
        sessionStorage.setItem('demo_mode', 'true');
        window.location.href = './comprehensive-report.html?demo=true';
    }

    startExistingReports() {
        // Navigate to client reports search page
        window.location.href = './client-reports.html';
    }

    generateDemoClientData() {
        // Generate comprehensive demo client data for full report preview
        return {
            method: 'demo',
            client: {
                name: 'Sarah Johnson',
                dateOfBirth: '1978-05-15',
                age: 45,
                gender: 'female',
                ethnicity: 'Caucasian',
                occupation: 'Marketing Manager'
            },
            demographics: {
                age: 45,
                gender: 'female',
                height: 165,
                weight: 68,
                ethnicity: 'Caucasian',
                occupation: 'Marketing Manager',
                education: 'Bachelor Degree',
                maritalStatus: 'Married'
            },
            biometrics: {
                bmi: 25.0,
                bodyFatPercentage: 28,
                waistCircumference: 85,
                hipCircumference: 98,
                waistHipRatio: 0.87,
                bloodPressure: { 
                    systolic: 125, 
                    diastolic: 82,
                    pulse: 72
                },
                restingHeartRate: 72,
                bodyTemperature: 98.6
            },
            labValues: {
                // Basic Metabolic Panel
                glucose: 92,
                hba1c: 5.4,
                insulin: 8.2,
                creatinine: 0.9,
                bun: 15,
                eGFR: 95,
                sodium: 140,
                potassium: 4.2,
                chloride: 102,
                
                // Lipid Panel
                totalCholesterol: 195,
                hdl: 58,
                ldl: 115,
                triglycerides: 110,
                nonHdlCholesterol: 137,
                
                // Liver Function
                alt: 22,
                ast: 20,
                albumin: 4.2,
                totalBilirubin: 0.8,
                
                // Inflammatory Markers
                cReactiveProtein: 1.8,
                esr: 12,
                
                // Thyroid Function
                tsh: 2.1,
                t3: 3.2,
                t4: 1.1,
                reverseT3: 18,
                
                // Vitamins & Minerals
                vitaminD: 32,
                vitaminB12: 450,
                folate: 12,
                iron: 95,
                ferritin: 65,
                transferrin: 280,
                
                // Additional Biomarkers
                homocysteine: 8.5,
                uricAcid: 5.2,
                magnesium: 2.1,
                zinc: 95,
                
                // Complete Blood Count
                wbc: 6.8,
                rbc: 4.5,
                hemoglobin: 13.5,
                hematocrit: 40.2,
                platelets: 285
            },
            lifestyle: {
                smoker: false,
                formerSmoker: false,
                alcoholConsumption: 'moderate', // none, light, moderate, heavy
                alcoholUnitsPerWeek: 6,
                exerciseFrequency: 3, // times per week
                exerciseType: ['cardio', 'strength'],
                exerciseDuration: 45, // minutes per session
                sleepHours: 7,
                sleepQuality: 'good', // poor, fair, good, excellent
                stressLevel: 'moderate', // low, moderate, high
                workStressLevel: 'moderate',
                dietType: 'Mediterranean',
                waterIntakeGlasses: 8,
                caffeineIntake: 'moderate'
            },
            familyHistory: {
                // Paternal (Father's side)
                paternalGrandfather: {
                    alive: false,
                    ageAtDeath: 78,
                    causeOfDeath: 'Heart attack',
                    conditions: ['Hypertension', 'Coronary artery disease']
                },
                paternalGrandmother: {
                    alive: true,
                    currentAge: 85,
                    conditions: ['Osteoporosis', 'Mild cognitive impairment']
                },
                father: {
                    alive: true,
                    currentAge: 72,
                    conditions: ['Type 2 Diabetes', 'High cholesterol']
                },
                
                // Maternal (Mother's side)
                maternalGrandfather: {
                    alive: false,
                    ageAtDeath: 82,
                    causeOfDeath: 'Stroke',
                    conditions: ['Hypertension', 'Atrial fibrillation']
                },
                maternalGrandmother: {
                    alive: false,
                    ageAtDeath: 75,
                    causeOfDeath: 'Breast cancer',
                    conditions: ['Breast cancer', 'Osteoporosis']
                },
                mother: {
                    alive: true,
                    currentAge: 68,
                    conditions: ['Hypothyroidism', 'Osteoarthritis']
                },
                
                // Siblings
                siblings: [
                    {
                        gender: 'male',
                        age: 47,
                        conditions: ['None known']
                    },
                    {
                        gender: 'female',
                        age: 41,
                        conditions: ['Anxiety', 'PCOS']
                    }
                ]
            },
            mentalHealth: {
                phq9Score: 3, // Depression screening (0-27, higher is worse)
                gad7Score: 4, // Anxiety screening (0-21, higher is worse)
                stressLevel: 'moderate',
                sleepIssues: false,
                moodIssues: false,
                anxietySymptoms: 'mild',
                depressionSymptoms: 'none',
                cognitiveFunction: 'normal'
            },
            atmTimeline: {
                // Accidents, Traumas, Major illnesses
                events: [
                    {
                        year: 2018,
                        age: 40,
                        event: 'Minor car accident',
                        impact: 'Mild whiplash, recovered fully',
                        treatment: 'Physical therapy'
                    },
                    {
                        year: 2015,
                        age: 37,
                        event: 'Appendectomy',
                        impact: 'Full recovery',
                        treatment: 'Surgical removal'
                    }
                ]
            },
            medications: [
                {
                    name: 'Multivitamin',
                    dosage: '1 tablet daily',
                    purpose: 'General health',
                    duration: 'Ongoing'
                },
                {
                    name: 'Omega-3',
                    dosage: '1000mg daily',
                    purpose: 'Heart health',
                    duration: '2 years'
                }
            ],
            supplements: [
                'Vitamin D3 2000 IU',
                'Magnesium 400mg',
                'Probiotics'
            ],
            riskAssessments: {
                biologicalAge: {
                    phenotypicAge: 42.3,
                    klemeraDoubalAge: 43.1,
                    metabolicAge: 41.8,
                    telomereAge: 42.7,
                    averageBiologicalAge: 42.5
                },
                diseaseRisks: {
                    cardiovascular: { 
                        risk: 8.5, 
                        level: 'Low',
                        algorithm: 'ASCVD Risk Calculator'
                    },
                    diabetes: { 
                        risk: 12.0, 
                        level: 'Low',
                        algorithm: 'FINDRISC Score'
                    },
                    metabolicSyndrome: { 
                        risk: 15.5, 
                        level: 'Moderate',
                        algorithm: 'ATP III Criteria'
                    },
                    cancer: {
                        risk: 18.2,
                        level: 'Low-Moderate',
                        algorithm: 'Family History + Lifestyle'
                    },
                    cognitiveDecline: {
                        risk: 8.8,
                        level: 'Low',
                        algorithm: 'CAIDE Risk Score'
                    },
                    osteoporosis: {
                        risk: 22.1,
                        level: 'Moderate',
                        algorithm: 'FRAX Calculator'
                    },
                    overallMortality: {
                        risk: 12.3,
                        level: 'Low',
                        algorithm: 'Life Expectancy Calculator'
                    }
                }
            },
            timestamp: new Date().toISOString()
        };
    }

    showLoading(show) {
        const overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            if (show) {
                overlay.classList.remove('hidden');
            } else {
                overlay.classList.add('hidden');
            }
        }
    }

    viewSampleReport() {
        // Open sample report in new window/tab
        window.open('./comprehensive-report.html?sample=true', '_blank');
    }

    // Utility method for API calls
    async apiCall(endpoint, options = {}) {
        if (!this.apiBase) {
            throw new Error('API not available in this environment');
        }
        
        const url = `${this.apiBase}${endpoint}`;
        const defaultOptions = {
            headers: {
                'Content-Type': 'application/json',
            }
        };
        
        const response = await fetch(url, { ...defaultOptions, ...options });
        
        if (!response.ok) {
            throw new Error(`API call failed: ${response.status}`);
        }
        
        return await response.json();
    }

    // Client-side calculation methods (for GitHub Pages)
    calculateBMI(weight, height) {
        const heightInMeters = height / 100;
        return Math.round((weight / (heightInMeters * heightInMeters)) * 10) / 10;
    }

    calculateASCVDRisk(data) {
        // Simplified client-side ASCVD calculation
        const { age, gender, cholesterol, hdl, systolicBP, diabetes, smoker } = data;
        
        let riskScore = 0;
        
        // Age factor
        if (gender === 'male') {
            riskScore += (age - 40) * 0.5;
        } else {
            riskScore += (age - 40) * 0.4;
        }
        
        // Cholesterol factor
        if (cholesterol > 200) riskScore += (cholesterol - 200) * 0.01;
        if (hdl < 50) riskScore += (50 - hdl) * 0.05;
        
        // Blood pressure factor
        if (systolicBP > 120) riskScore += (systolicBP - 120) * 0.02;
        
        // Risk factors
        if (diabetes) riskScore += 3;
        if (smoker) riskScore += 2;
        
        const riskPercentage = Math.min(Math.max(riskScore, 0), 50);
        
        return {
            riskPercentage: Math.round(riskPercentage * 10) / 10,
            riskLevel: riskPercentage > 20 ? 'High' : riskPercentage > 7.5 ? 'Moderate' : 'Low'
        };
    }

    calculatePhenotypicAge(data) {
        // Simplified client-side phenotypic age calculation
        const { age, albumin, creatinine, glucose, cReactiveProtein } = data;
        
        let ageAdjustment = 0;
        
        if (albumin && albumin < 4.0) ageAdjustment += (4.0 - albumin) * 5;
        if (creatinine && creatinine > 1.0) ageAdjustment += (creatinine - 1.0) * 10;
        if (glucose && glucose > 100) ageAdjustment += (glucose - 100) * 0.1;
        if (cReactiveProtein && cReactiveProtein > 3) ageAdjustment += (cReactiveProtein - 3) * 0.5;
        
        return age + ageAdjustment;
    }

    calculateFINDRISCScore(data) {
        // Finnish Diabetes Risk Score calculation
        const { age, bmi, waistCircumference, exerciseFrequency, familyHistory, glucose } = data;
        
        let score = 0;
        
        // Age points
        if (age >= 45 && age < 55) score += 2;
        else if (age >= 55 && age < 65) score += 3;
        else if (age >= 65) score += 4;
        
        // BMI points
        if (bmi >= 25 && bmi < 30) score += 1;
        else if (bmi >= 30) score += 3;
        
        // Waist circumference points
        if (waistCircumference > 94) score += 3; // For men
        if (waistCircumference > 80) score += 3; // For women
        
        // Physical activity
        if (exerciseFrequency < 4) score += 2;
        
        // Family history
        if (familyHistory.diabetes) score += 5;
        
        // High glucose
        if (glucose > 100) score += 5;
        
        return {
            score: score,
            risk: score < 7 ? 'Low' : score < 12 ? 'Slightly elevated' : score < 15 ? 'Moderate' : score < 20 ? 'High' : 'Very high'
        };
    }
}

// Global functions for HTML onclick handlers
function startAssessment(method) {
    window.longenixApp.startAssessment(method);
}

function startFreshAssessment() {
    // Clear localStorage cache before starting assessment
    console.log('🗑️ Clearing localStorage cache for fresh assessment...');
    localStorage.removeItem('comprehensive_assessment_data');
    console.log('✅ Cache cleared - starting fresh assessment');
    
    // Start comprehensive assessment
    window.location.href = '/comprehensive-assessment';
}

function viewSampleReport() {
    window.longenixApp.viewSampleReport();
}

// Initialize application when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.longenixApp = new LongenixAssessment();
});

// Health check for service monitoring
if (window.location.search.includes('health')) {
    document.body.innerHTML = `
        <div style="text-align: center; padding: 20px; font-family: Arial, sans-serif;">
            <h2>Longenix Health System Status</h2>
            <p>✅ Frontend: Operational</p>
            <p>🔄 Backend: ${window.longenixApp?.apiBase ? 'Connected' : 'Client-side mode'}</p>
            <p>📅 ${new Date().toISOString()}</p>
        </div>
    `;
}

// Global test function for debugging authentication
window.testAuth = function() {
    console.log('🧪 ======= MANUAL AUTH TEST =======');
    
    if (window.longenixApp) {
        console.log('✅ App instance found');
        
        // Create a fake event object
        const fakeEvent = {
            type: 'submit',
            target: document.getElementById('authForm'),
            preventDefault: () => console.log('📍 preventDefault called'),
            isTrusted: false
        };
        
        try {
            console.log('🚀 Calling handleAuth directly...');
            window.longenixApp.handleAuth(fakeEvent);
        } catch (error) {
            console.error('💥 Direct handleAuth call failed:', error);
        }
    } else {
        console.error('❌ No app instance found');
    }
    
    console.log('🧪 ======= MANUAL AUTH TEST COMPLETED =======');
};