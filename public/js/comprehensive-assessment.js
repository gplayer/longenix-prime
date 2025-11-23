// Comprehensive Lifestyle Assessment Form
// Dr. Graham Player, Ph.D - Longenix Health

class ComprehensiveAssessment {
    constructor() {
        this.currentStep = 1;
        this.totalSteps = 7;
        this.formData = {};
        this.apiBase = this.getApiBase();
        
        // Load existing data from localStorage
        this.loadSavedData();
        
        this.init();
    }

    loadSavedData() {
        try {
            const savedData = localStorage.getItem('comprehensive_assessment_data');
            if (savedData) {
                this.formData = JSON.parse(savedData);
                console.log('Loaded saved form data:', Object.keys(this.formData).length, 'fields');
            }
        } catch (error) {
            console.error('Error loading saved data:', error);
            this.formData = {};
        }
    }

    populateFormFields() {
        const form = document.getElementById('comprehensive-assessment-form');
        if (!form || !this.formData || Object.keys(this.formData).length === 0) {
            return;
        }

        // Populate all form fields from saved data
        Object.keys(this.formData).forEach(fieldName => {
            const fieldValue = this.formData[fieldName];
            
            // Handle different input types
            const input = form.querySelector(`[name="${fieldName}"]`);
            if (input && fieldValue !== null && fieldValue !== undefined && fieldValue !== '') {
                if (input.type === 'checkbox' || input.type === 'radio') {
                    if (Array.isArray(fieldValue)) {
                        // Multiple checkboxes with same name
                        fieldValue.forEach(value => {
                            const specificInput = form.querySelector(`[name="${fieldName}"][value="${value}"]`);
                            if (specificInput) {
                                specificInput.checked = true;
                            }
                        });
                    } else {
                        // Single checkbox or radio
                        if (input.value === fieldValue || (input.type === 'checkbox' && fieldValue)) {
                            input.checked = true;
                        }
                    }
                } else {
                    // Text, select, textarea, etc.
                    input.value = fieldValue;
                }
            }
        });

        console.log('Populated form fields for step', this.currentStep);
    }

    validateRestoredBiomarkers() {
        // Validate all biomarker inputs that have values
        const biomarkerInputs = document.querySelectorAll('.biomarker-input');
        biomarkerInputs.forEach(input => {
            if (input.value && input.value.trim() !== '') {
                // Trigger validation for this field
                this.validateBiomarkerInput(input);
            }
        });
    }

    validateBiomarkerInput(input) {
        if (!input) return;
        
        const value = parseFloat(input.value);
        const normalMin = parseFloat(input.dataset.normalMin);
        const normalMax = parseFloat(input.dataset.normalMax);
        const container = input.closest('.biomarker-input-container');
        const statusSpan = container?.querySelector('.validation-status');
        
        if (isNaN(value) || !statusSpan) return;

        // Apply validation logic
        let status = 'normal';
        let message = 'Normal';
        let className = 'text-green-600';

        if (isNaN(normalMin) || isNaN(normalMax)) {
            status = 'unknown';
            message = 'Cannot validate range';
            className = 'text-gray-500';
        } else if (value < normalMin || value > normalMax) {
            status = 'abnormal';
            message = 'Abnormal';
            className = 'text-yellow-600';
            input.classList.add('border-yellow-400');
            input.classList.remove('border-red-500', 'border-green-500');
        } else {
            status = 'normal';
            message = 'Normal';
            className = 'text-green-600';
            input.classList.add('border-green-500');
            input.classList.remove('border-red-500', 'border-yellow-400');
        }

        // Update status display
        statusSpan.textContent = message;
        statusSpan.className = `validation-status ml-2 ${className}`;
        statusSpan.classList.remove('hidden');
        
        return status;
    }

    getSavedValue(fieldName, defaultValue = '') {
        return this.formData[fieldName] || defaultValue;
    }

    getSavedSelected(fieldName, value) {
        const savedValue = this.formData[fieldName];
        return savedValue === value ? 'selected' : '';
    }

    getSavedChecked(fieldName, value = null) {
        const savedValue = this.formData[fieldName];
        if (value === null) {
            // For single checkbox
            return savedValue ? 'checked' : '';
        } else {
            // For radio buttons or checkboxes with specific values
            return savedValue === value ? 'checked' : '';
        }
    }

    getApiBase() {
        const hostname = window.location.hostname;
        const origin = window.location.origin;
        console.log('🔗 getApiBase() - hostname:', hostname, 'origin:', origin);
        
        if (hostname.includes('pages.dev')) {
            console.log('✅ Detected pages.dev - returning origin:', origin);
            return origin;
        } else if (hostname.includes('github.io')) {
            console.log('🚫 Detected github.io - returning null (demo mode)');
            return null;
        } else {
            console.log('🏠 Local development - returning origin:', origin);
            return origin;
        }
    }

    init() {
        console.log('ComprehensiveAssessment initializing...');
        this.renderForm();
        this.setupEventListeners();
    }

    setupEventListeners() {
        // Navigation buttons
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('next-step-btn')) {
                this.nextStep();
            }
            if (e.target.classList.contains('prev-step-btn')) {
                this.prevStep();
            }
            if (e.target.classList.contains('submit-assessment-btn')) {
                this.submitAssessment();
            }
            if (e.target.classList.contains('download-form-pdf-btn')) {
                this.downloadFormPDF();
            }
        });

        // Auto-save on form changes
        document.addEventListener('change', (e) => {
            if (e.target.form && e.target.form.id === 'comprehensive-assessment-form') {
                this.saveFormData();
            }
        });
    }

    renderForm() {
        console.log('Rendering form...');
        const container = document.getElementById('assessmentContainer');
        if (!container) {
            console.error('Container not found in renderForm!');
            return;
        }
        console.log('Container found, rendering content...');

        container.innerHTML = `
            <div class="max-w-6xl mx-auto form-section-card">
                <!-- Enhanced Progress Header -->
                <div class="form-section-header">
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="step-title">Comprehensive Health Assessment</h2>
                        <div class="flex items-center gap-2">
                            <span class="text-sm font-medium text-gray-600">Step ${this.currentStep} of ${this.totalSteps}</span>
                            <div class="w-8 h-8 rounded-full bg-gradient-to-r from-blue-500 to-purple-600 flex items-center justify-center text-white text-sm font-bold">
                                ${this.currentStep}
                            </div>
                        </div>
                    </div>
                    <div class="enhanced-progress-bar">
                        <div class="enhanced-progress-fill" 
                             style="width: ${(this.currentStep / this.totalSteps) * 100}%"></div>
                    </div>
                    <div class="mt-3 step-description">${this.getStepDescription()}</div>
                </div>

                <!-- Enhanced Form Content -->
                <form id="comprehensive-assessment-form" class="form-section-content">
                    <div id="form-step-content" class="assessment-step">
                        ${this.renderStepContent()}
                    </div>

                    <!-- Enhanced Navigation -->
                    <div class="flex justify-between items-center pt-8 mt-8 border-t-2 border-gray-100">
                        <button type="button" class="prev-step-btn btn-enhanced btn-secondary-enhanced ${this.currentStep === 1 ? 'invisible' : ''}">
                            <i class="fas fa-chevron-left mr-2"></i>
                            Previous
                        </button>
                        <div class="flex items-center space-x-4">
                            <button type="button" class="btn-enhanced btn-secondary-enhanced">
                                <i class="fas fa-save mr-2"></i>
                                Save & Resume Later
                            </button>
                            ${this.currentStep === this.totalSteps ? 
                                `<button type="button" class="download-form-pdf-btn btn-enhanced" style="background: linear-gradient(135deg, #7c3aed, #5b21b6); color: white; margin-right: 1rem;">
                                    <i class="fas fa-file-pdf mr-2"></i>Download Form PDF
                                 </button>
                                 <button type="button" class="submit-assessment-btn btn-enhanced" style="background: linear-gradient(135deg, #10b981, #059669); color: white;">
                                    <i class="fas fa-check-circle mr-2"></i>Complete Assessment
                                 </button>` :
                                `<button type="button" class="next-step-btn btn-enhanced btn-primary-enhanced">
                                    Next Step
                                    <i class="fas fa-chevron-right ml-2"></i>
                                 </button>`
                            }
                        </div>
                    </div>
                </form>
            </div>
        `;
        
        // Setup form after DOM is updated
        // Use setTimeout to ensure DOM elements are available
        setTimeout(() => {
            // Restore form data for all steps
            this.populateFormFields();
            
            // Step-specific setup
            if (this.currentStep === 1) {
                this.setupBiomarkerValidation();
                this.addBiomarkerSummary();
                
                // Trigger validation for restored biomarker values
                this.validateRestoredBiomarkers();
            }
        }, 0);
    }

    getStepDescription() {
        const descriptions = {
            1: 'Basic demographics, health profile, and clinical data',
            2: 'Functional Medicine systems assessment (7 core systems)',
            3: 'Mental health & cognitive assessment (PHQ-9, GAD-7, cognitive function)',
            4: 'Detailed lifestyle factors (nutrition, exercise, sleep, stress)',
            5: 'Environmental and social factors',
            6: 'Root cause analysis (ATM framework)',
            7: 'Medical history, family history, and current medications'
        };
        return descriptions[this.currentStep];
    }

    renderStepContent() {
        switch (this.currentStep) {
            case 1:
                return this.renderStep1_Demographics();
            case 2:
                return this.renderStep2_FunctionalMedicine();
            case 3:
                return this.renderStep3_MentalHealth();
            case 4:
                return this.renderStep4_Lifestyle();
            case 5:
                return this.renderStep5_Environmental();
            case 6:
                return this.renderStep6_RootCause();
            case 7:
                return this.renderStep7_MedicalHistory();
            default:
                return '<p>Invalid step</p>';
        }
    }

    renderStep1_Demographics() {
        return `
            <div class="step-header">
                <h3 class="step-title">
                    <i class="fas fa-user-circle text-blue-600 mr-3"></i>
                    Personal Demographics
                </h3>
                <p class="step-description">Please provide your basic personal information to personalize your health assessment</p>
            </div>
            
            <div class="space-y-8">
                <div class="form-section-card">
                    <div class="form-section-header">
                        <h4 class="form-section-title">
                            <i class="fas fa-id-card text-blue-600"></i>
                            Personal Information
                        </h4>
                        <p class="form-section-description">Basic identifying information for your health profile</p>
                    </div>
                    <div class="form-section-content">
                        <div class="form-grid-2">
                            <div>
                                <label class="enhanced-label required">Full Name</label>
                                <input type="text" name="fullName" value="${this.getSavedValue('fullName')}" required class="enhanced-input enhanced-focus">
                            </div>
                            <div>
                                <label class="enhanced-label required">Email Address</label>
                                <input type="email" name="email" value="${this.getSavedValue('email')}" required class="enhanced-input enhanced-focus">
                            </div>
                            <div>
                                <label class="enhanced-label required">Date of Birth</label>
                                <input type="date" name="dateOfBirth" value="${this.getSavedValue('dateOfBirth')}" required class="enhanced-input enhanced-focus">
                            </div>
                            <div>
                                <label class="enhanced-label required">Gender</label>
                                <select name="gender" required class="enhanced-select enhanced-focus">
                                    <option value="">Select gender</option>
                                    <option value="female" ${this.getSavedSelected('gender', 'female')}>Female</option>
                                    <option value="male" ${this.getSavedSelected('gender', 'male')}>Male</option>
                                    <option value="other" ${this.getSavedSelected('gender', 'other')}>Other</option>
                                </select>
                            </div>
                            <div>
                                <label class="enhanced-label">Ethnicity</label>
                                <select name="ethnicity" class="enhanced-select enhanced-focus">
                                    <option value="">Select ethnicity</option>
                                    <option value="caucasian">Caucasian/White</option>
                                    <option value="african_american">African American/Black</option>
                                    <option value="hispanic">Hispanic/Latino</option>
                                    <option value="asian">Asian</option>
                                    <option value="native_american">Native American</option>
                                    <option value="pacific_islander">Pacific Islander</option>
                                    <option value="middle_eastern">Middle Eastern</option>
                                    <option value="mixed">Mixed/Multiracial</option>
                                    <option value="other">Other</option>
                                    <option value="prefer_not_to_say">Prefer not to say</option>
                                </select>
                            </div>
                            <div>
                                <label class="enhanced-label">Education Level</label>
                                <select name="education" class="enhanced-select enhanced-focus">
                                <option value="">Select education level</option>
                                <option value="less_than_high_school">Less than High School</option>
                                <option value="high_school">High School Graduate</option>
                                <option value="some_college">Some College</option>
                                <option value="associates">Associate's Degree</option>
                                <option value="bachelors">Bachelor's Degree</option>
                                <option value="masters">Master's Degree</option>
                                <option value="doctoral">Doctoral/Professional Degree</option>
                            </select>
                        </div>
                            <div>
                                <label class="enhanced-label required">Height (cm)</label>
                                <input type="number" name="height" required min="100" max="250" 
                                       onchange="calculateBMI()" onkeyup="calculateBMI()"
                                       class="enhanced-input enhanced-focus">
                            </div>
                            <div>
                                <label class="enhanced-label required">Weight (kg)</label>
                                <input type="number" name="weight" required min="30" max="300" 
                                       onchange="calculateBMI()" onkeyup="calculateBMI()"
                                       class="enhanced-input enhanced-focus">
                            </div>
                        </div>
                        
                        <!-- Enhanced BMI Display -->
                        <div class="bmi-display-enhanced mt-6">
                            <div class="flex items-center justify-between">
                                <div>
                                    <h4 class="text-lg font-semibold text-blue-800 flex items-center">
                                        <i class="fas fa-calculator text-blue-600 mr-2"></i>
                                        Body Mass Index (BMI)
                                    </h4>
                                    <p class="text-sm text-blue-600 mt-1">Automatically calculated from height and weight</p>
                                </div>
                                <div class="text-right">
                                    <div id="bmiValue" class="bmi-value-large">--</div>
                                    <div id="bmiCategory" class="bmi-category-text">Enter height & weight</div>
                                </div>
                            </div>
                            <div class="mt-4 flex flex-wrap gap-2 text-sm">
                                <span class="px-3 py-1 bg-blue-100 text-blue-800 rounded-full">Underweight: < 18.5</span>
                                <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full">Normal: 18.5-24.9</span>
                                <span class="px-3 py-1 bg-yellow-100 text-yellow-800 rounded-full">Overweight: 25-29.9</span>
                                <span class="px-3 py-1 bg-red-100 text-red-800 rounded-full">Obese: ≥ 30</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-section-card section-green-enhanced">
                    <div class="form-section-header">
                        <h4 class="form-section-title">
                            <i class="fas fa-heartbeat text-red-600"></i>
                            Clinical Measurements
                        </h4>
                        <p class="form-section-description">Current vital signs and physical measurements</p>
                    </div>
                    <div class="form-section-content">
                        <div class="form-grid-2">
                            <div>
                                <label class="enhanced-label">Systolic Blood Pressure (mmHg)</label>
                                <input type="number" name="systolicBP" min="80" max="250" class="enhanced-input enhanced-focus">
                            </div>
                            <div>
                                <label class="enhanced-label">Diastolic Blood Pressure (mmHg)</label>
                                <input type="number" name="diastolicBP" min="40" max="150" class="enhanced-input enhanced-focus">
                            </div>
                            <div>
                                <label class="enhanced-label">Resting Heart Rate (bpm)</label>
                                <input type="number" name="heartRate" min="40" max="120" class="enhanced-input enhanced-focus">
                            </div>
                            <div>
                                <label class="enhanced-label">Waist Circumference (cm)</label>
                                <input type="number" name="waistCircumference" min="50" max="200" class="enhanced-input enhanced-focus">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-section-card section-purple-enhanced">
                    <div class="form-section-header">
                        <h4 class="form-section-title">
                            <i class="fas fa-vial text-purple-600"></i>
                            Recent Laboratory Results
                        </h4>
                        <p class="form-section-description">Enter your most recent lab values (leave blank if not tested)</p>
                    </div>
                    <div class="form-section-content">
                        <div class="form-grid-3">
                            ${this.renderBiomarkerInputs()}
                        </div>
                    </div>
                </div>

                <div class="form-section-card section-yellow-enhanced">
                    <div class="form-section-header">
                        <h4 class="form-section-title">
                            <i class="fas fa-pills text-orange-600"></i>
                            Medical History & Medications
                        </h4>
                        <p class="form-section-description">Current treatments and health conditions</p>
                    </div>
                    <div class="form-section-content">
                        <div class="space-y-6">
                            <div>
                                <label class="enhanced-label">Current Medications & Supplements</label>
                                <textarea name="currentMedications" rows="4" placeholder="List all current medications, supplements, and dosages" class="enhanced-textarea enhanced-focus"></textarea>
                            </div>
                            <div>
                                <label class="enhanced-label">Personal Health Conditions</label>
                                <textarea name="healthConditions" rows="4" placeholder="List any diagnosed health conditions, chronic issues, surgeries, or significant medical events" class="enhanced-textarea enhanced-focus"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div>
                    <h3 class="text-lg font-semibold text-gray-800 mb-4">Comprehensive Family Health History</h3>
                    <p class="text-sm text-gray-600 mb-6">Please provide health information for family members. This helps assess genetic predispositions and inherited disease risks.</p>
                    
                    <div class="space-y-6">
                        <!-- Parents -->
                        <div class="bg-blue-50 rounded-lg p-4">
                            <h4 class="font-semibold text-blue-800 mb-3">Parents</h4>
                            <div class="grid md:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Father's Health History</label>
                                    <textarea name="fatherHistory" rows="3" placeholder="Age, current health status, major conditions, cause of death if applicable" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Mother's Health History</label>
                                    <textarea name="motherHistory" rows="3" placeholder="Age, current health status, major conditions, cause of death if applicable" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Grandparents -->
                        <div class="bg-green-50 rounded-lg p-4">
                            <h4 class="font-semibold text-green-800 mb-3">Grandparents</h4>
                            <div class="grid md:grid-cols-2 gap-6">
                                <div>
                                    <h5 class="text-sm font-medium text-gray-700 mb-2">Paternal Side</h5>
                                    <div class="space-y-3">
                                        <div>
                                            <label class="block text-xs font-medium text-gray-600 mb-1">Paternal Grandfather</label>
                                            <textarea name="paternalGrandfatherHistory" rows="2" placeholder="Health conditions, longevity, cause of death" class="w-full px-2 py-1 border border-gray-300 rounded text-sm focus:outline-none focus:ring-1 focus:ring-blue-500"></textarea>
                                        </div>
                                        <div>
                                            <label class="block text-xs font-medium text-gray-600 mb-1">Paternal Grandmother</label>
                                            <textarea name="paternalGrandmotherHistory" rows="2" placeholder="Health conditions, longevity, cause of death" class="w-full px-2 py-1 border border-gray-300 rounded text-sm focus:outline-none focus:ring-1 focus:ring-blue-500"></textarea>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <h5 class="text-sm font-medium text-gray-700 mb-2">Maternal Side</h5>
                                    <div class="space-y-3">
                                        <div>
                                            <label class="block text-xs font-medium text-gray-600 mb-1">Maternal Grandfather</label>
                                            <textarea name="maternalGrandfatherHistory" rows="2" placeholder="Health conditions, longevity, cause of death" class="w-full px-2 py-1 border border-gray-300 rounded text-sm focus:outline-none focus:ring-1 focus:ring-blue-500"></textarea>
                                        </div>
                                        <div>
                                            <label class="block text-xs font-medium text-gray-600 mb-1">Maternal Grandmother</label>
                                            <textarea name="maternalGrandmotherHistory" rows="2" placeholder="Health conditions, longevity, cause of death" class="w-full px-2 py-1 border border-gray-300 rounded text-sm focus:outline-none focus:ring-1 focus:ring-blue-500"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Great Grandparents -->
                        <div class="bg-purple-50 rounded-lg p-4">
                            <h4 class="font-semibold text-purple-800 mb-3">Great Grandparents (if known)</h4>
                            <div class="grid md:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Paternal Great Grandparents</label>
                                    <textarea name="paternalGreatGrandparentsHistory" rows="2" placeholder="Notable health conditions, longevity patterns" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Maternal Great Grandparents</label>
                                    <textarea name="maternalGreatGrandparentsHistory" rows="2" placeholder="Notable health conditions, longevity patterns" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Siblings -->
                        <div class="bg-yellow-50 rounded-lg p-4">
                            <h4 class="font-semibold text-yellow-800 mb-3">Siblings</h4>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Siblings' Health Information</label>
                                <textarea name="siblingsHistory" rows="3" placeholder="Number of siblings, ages, any significant health conditions or genetic issues" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                            </div>
                        </div>

                        <!-- Notable Family Patterns -->
                        <div class="bg-red-50 rounded-lg p-4">
                            <h4 class="font-semibold text-red-800 mb-3">Notable Family Health Patterns</h4>
                            <div class="space-y-3">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Common Family Conditions</label>
                                    <textarea name="familyPatterns" rows="2" placeholder="Recurring conditions: heart disease, diabetes, cancer, mental health, autoimmune, etc." class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Family Longevity Patterns</label>
                                    <textarea name="familyLongevity" rows="2" placeholder="Typical lifespan, premature deaths, exceptional longevity" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    renderBiomarkerInputs() {
        const biomarkerCategories = {
            'Metabolic Panel': [
                { name: 'glucose', label: 'Fasting Glucose', unit: 'mg/dL', range: '70-99', min: 60, max: 400 },
                { name: 'hba1c', label: 'HbA1c', unit: '%', range: '4.0-5.6', min: 3, max: 15, step: 0.1 },
                { name: 'insulin', label: 'Fasting Insulin', unit: 'μU/mL', range: '2.6-24.9', min: 0.1, max: 100, step: 0.1 },
                { name: 'cPeptide', label: 'C-Peptide', unit: 'ng/mL', range: '1.1-4.4', min: 0.1, max: 10, step: 0.1 },
                { name: 'fructosamine', label: 'Fructosamine', unit: 'μmol/L', range: '205-285', min: 100, max: 500 }
            ],
            'Lipid Panel': [
                { name: 'totalCholesterol', label: 'Total Cholesterol', unit: 'mg/dL', range: '<200', min: 100, max: 400 },
                { name: 'hdlCholesterol', label: 'HDL Cholesterol', unit: 'mg/dL', range: '>40 (M), >50 (F)', min: 20, max: 100 },
                { name: 'ldlCholesterol', label: 'LDL Cholesterol', unit: 'mg/dL', range: '<100', min: 50, max: 300 },
                { name: 'triglycerides', label: 'Triglycerides', unit: 'mg/dL', range: '<150', min: 30, max: 1000 },
                { name: 'nonHdlCholesterol', label: 'Non-HDL Cholesterol', unit: 'mg/dL', range: '<130', min: 50, max: 350 },
                { name: 'apoA1', label: 'Apolipoprotein A1', unit: 'mg/dL', range: '>120 (M), >140 (F)', min: 50, max: 200 },
                { name: 'apoB', label: 'Apolipoprotein B', unit: 'mg/dL', range: '<90', min: 30, max: 150 },
                { name: 'lipoproteinA', label: 'Lipoprotein(a)', unit: 'mg/dL', range: '<30', min: 0.1, max: 200, step: 0.1 }
            ],
            'Kidney Function': [
                { name: 'creatinine', label: 'Creatinine', unit: 'mg/dL', range: '0.6-1.2', min: 0.3, max: 5, step: 0.1 },
                { name: 'bun', label: 'BUN (Blood Urea Nitrogen)', unit: 'mg/dL', range: '7-20', min: 3, max: 100 },
                { name: 'egfr', label: 'eGFR', unit: 'mL/min/1.73m²', range: '>90', min: 5, max: 150 },
                { name: 'albumin', label: 'Albumin', unit: 'g/dL', range: '3.5-5.0', min: 2, max: 6, step: 0.1 },
                { name: 'microalbumin', label: 'Microalbumin (Urine)', unit: 'mg/g creatinine', range: '<30', min: 0.1, max: 1000, step: 0.1 },
                { name: 'cystatinC', label: 'Cystatin C', unit: 'mg/L', range: '0.53-0.95', min: 0.1, max: 5, step: 0.01 }
            ],
            'Liver Function': [
                { name: 'alt', label: 'ALT (Alanine Transaminase)', unit: 'U/L', range: '7-56', min: 5, max: 200 },
                { name: 'ast', label: 'AST (Aspartate Transaminase)', unit: 'U/L', range: '10-40', min: 5, max: 200 },
                { name: 'alp', label: 'Alkaline Phosphatase', unit: 'U/L', range: '44-147', min: 20, max: 300 },
                { name: 'totalBilirubin', label: 'Total Bilirubin', unit: 'mg/dL', range: '0.3-1.2', min: 0.1, max: 10, step: 0.1 },
                { name: 'directBilirubin', label: 'Direct Bilirubin', unit: 'mg/dL', range: '0.0-0.3', min: 0.0, max: 5, step: 0.1 },
                { name: 'ggt', label: 'GGT (Gamma-Glutamyl Transferase)', unit: 'U/L', range: '9-48', min: 5, max: 200 }
            ],
            'Thyroid Function': [
                { name: 'tsh', label: 'TSH (Thyroid Stimulating Hormone)', unit: 'μIU/mL', range: '0.27-4.20', min: 0.01, max: 50, step: 0.01 },
                { name: 'freeT4', label: 'Free T4', unit: 'ng/dL', range: '0.93-1.70', min: 0.1, max: 5, step: 0.01 },
                { name: 'freeT3', label: 'Free T3', unit: 'pg/mL', range: '2.0-4.4', min: 0.5, max: 10, step: 0.1 },
                { name: 'reverseT3', label: 'Reverse T3', unit: 'ng/dL', range: '9.2-24.1', min: 5, max: 50, step: 0.1 },
                { name: 'thyroglobulinAb', label: 'Thyroglobulin Antibodies', unit: 'IU/mL', range: '<4', min: 0, max: 1000, step: 0.1 },
                { name: 'tpoAb', label: 'TPO Antibodies', unit: 'IU/mL', range: '<34', min: 0, max: 1000, step: 0.1 }
            ],
            'Inflammatory Markers': [
                { name: 'crp', label: 'C-Reactive Protein (hs-CRP)', unit: 'mg/L', range: '<3.0', min: 0.1, max: 50, step: 0.1 },
                { name: 'esr', label: 'ESR (Erythrocyte Sedimentation Rate)', unit: 'mm/hr', range: '<20 (M), <30 (F)', min: 1, max: 100 },
                { name: 'interleukin6', label: 'Interleukin-6 (IL-6)', unit: 'pg/mL', range: '<3.4', min: 0.1, max: 50, step: 0.1 },
                { name: 'tnfAlpha', label: 'TNF-α (Tumor Necrosis Factor)', unit: 'pg/mL', range: '<8.1', min: 0.1, max: 100, step: 0.1 }
            ],
            'Complete Blood Count': [
                { name: 'wbc', label: 'White Blood Cells', unit: '10³/μL', range: '4.5-11.0', min: 1, max: 50, step: 0.1 },
                { name: 'rbc', label: 'Red Blood Cells', unit: '10⁶/μL', range: '4.7-6.1 (M), 4.2-5.4 (F)', min: 2, max: 8, step: 0.1 },
                { name: 'hemoglobin', label: 'Hemoglobin', unit: 'g/dL', range: '14-18 (M), 12-16 (F)', min: 6, max: 20, step: 0.1 },
                { name: 'hematocrit', label: 'Hematocrit', unit: '%', range: '42-52 (M), 37-47 (F)', min: 20, max: 60, step: 0.1 },
                { name: 'platelets', label: 'Platelets', unit: '10³/μL', range: '150-450', min: 50, max: 1000 },
                { name: 'mcv', label: 'Mean Cell Volume (MCV)', unit: 'fL', range: '82-98', min: 70, max: 120, step: 0.1 },
                { name: 'rdw', label: 'Red Cell Distribution Width (RDW)', unit: '%', range: '11.5-14.5', min: 10, max: 20, step: 0.1 },
                { name: 'neutrophils', label: 'Neutrophils', unit: '%', range: '40-74', min: 10, max: 90, step: 0.1 },
                { name: 'lymphocytes', label: 'Lymphocytes', unit: '%', range: '19-48', min: 5, max: 70, step: 0.1 },
                { name: 'monocytes', label: 'Monocytes', unit: '%', range: '3.4-9', min: 1, max: 20, step: 0.1 }
            ],
            'Nutritional Status': [
                { name: 'vitaminD', label: 'Vitamin D (25-OH)', unit: 'ng/mL', range: '30-100', min: 5, max: 150, step: 0.1 },
                { name: 'vitaminB12', label: 'Vitamin B12', unit: 'pg/mL', range: '232-1245', min: 100, max: 2000 },
                { name: 'folate', label: 'Folate', unit: 'ng/mL', range: '2.7-17.0', min: 1, max: 30, step: 0.1 },
                { name: 'ferritin', label: 'Ferritin', unit: 'ng/mL', range: '15-150 (F), 15-200 (M)', min: 5, max: 500 },
                { name: 'iron', label: 'Iron', unit: 'μg/dL', range: '60-170 (M), 60-140 (F)', min: 20, max: 300 },
                { name: 'tibc', label: 'TIBC (Total Iron Binding Capacity)', unit: 'μg/dL', range: '240-450', min: 200, max: 600 },
                { name: 'transferrinSat', label: 'Transferrin Saturation', unit: '%', range: '20-50', min: 5, max: 80, step: 0.1 },
                { name: 'omega3Index', label: 'Omega-3 Index', unit: '%', range: '>8', min: 1, max: 15, step: 0.1 }
            ],
            'Hormones (Optional)': [
                { name: 'testosterone', label: 'Testosterone (Total)', unit: 'ng/dL', range: '300-1000 (M), 15-70 (F)', min: 10, max: 1500 },
                { name: 'freeTestosterone', label: 'Free Testosterone', unit: 'pg/mL', range: '9-30 (M), 0.3-3.2 (F)', min: 0.1, max: 50, step: 0.1 },
                { name: 'estradiol', label: 'Estradiol', unit: 'pg/mL', range: '7-42 (M), varies with cycle (F)', min: 5, max: 500, step: 0.1 },
                { name: 'progesterone', label: 'Progesterone', unit: 'ng/mL', range: '<1.4 (M), varies with cycle (F)', min: 0.1, max: 50, step: 0.1 },
                { name: 'cortisol', label: 'Cortisol (AM)', unit: 'μg/dL', range: '6.2-19.4', min: 1, max: 50, step: 0.1 },
                { name: 'dheas', label: 'DHEA-S', unit: 'μg/dL', range: '164-530 (M), 57-279 (F)', min: 20, max: 800 }
            ]
        };

        let html = '';
        
        Object.keys(biomarkerCategories).forEach(category => {
            html += `
                <div class="col-span-full mb-8">
                    <h4 class="text-lg font-semibold text-gray-800 mb-4 border-b border-gray-200 pb-2">
                        <i class="fas fa-flask mr-2 text-blue-600"></i>${category}
                    </h4>
                    <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
            `;
            
            biomarkerCategories[category].forEach(bio => {
                html += `
                    <div class="bg-gray-50 p-4 rounded-lg biomarker-input-container" data-biomarker="${bio.name}">
                        <div class="flex items-center justify-between mb-1">
                            <label class="block text-sm font-medium text-gray-700">${bio.label}</label>
                            <button type="button" class="biomarker-help-btn text-gray-400 hover:text-blue-500 transition-colors" 
                                    data-biomarker="${bio.name}" title="Click for more information">
                                <i class="fas fa-question-circle text-sm"></i>
                            </button>
                        </div>
                        <div class="text-xs text-gray-500 mb-2">
                            <span class="normal-range">Normal: ${bio.range} ${bio.unit}</span>
                            <span class="validation-status ml-2 hidden"></span>
                        </div>
                        <div class="relative">
                            <input type="number" 
                                   name="${bio.name}" 
                                   value="${this.getSavedValue(bio.name)}"
                                   min="${bio.min}" 
                                   max="${bio.max}"
                                   ${bio.step ? `step="${bio.step}"` : ''}
                                   placeholder="Enter value"
                                   class="biomarker-input w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                                   data-normal-min="${this.parseRangeMin(bio.range, bio.min)}"
                                   data-normal-max="${this.parseRangeMax(bio.range)}"
                                   data-unit="${bio.unit}">
                            <div class="validation-icon absolute right-3 top-1/2 transform -translate-y-1/2 hidden">
                                <i class="fas fa-check-circle text-green-500"></i>
                                <i class="fas fa-exclamation-triangle text-yellow-500"></i>
                                <i class="fas fa-times-circle text-red-500"></i>
                            </div>
                        </div>
                        <div class="text-xs text-gray-400 mt-1 flex justify-between">
                            <span>${bio.unit}</span>
                            <span class="validation-message"></span>
                        </div>
                        <div class="guidance-message hidden mt-2 p-2 bg-blue-50 border-l-4 border-blue-400 text-xs text-blue-700">
                            <i class="fas fa-info-circle mr-1"></i>
                            <span class="guidance-text"></span>
                        </div>
                    </div>
                `;
            });
            
            html += `
                    </div>
                </div>
            `;
        });

        return html;
    }

    // Helper methods for biomarker validation - Enhanced to handle complex range formats
    parseRangeMin(range, absoluteMin = null) {
        // Handle standard range format like "70-99" (backward compatibility)
        const standardMatch = range.match(/^([\d.]+)-/);
        if (standardMatch) {
            return parseFloat(standardMatch[1]);
        }
        
        // Handle "greater than" formats like ">40 (M), >50 (F)" or ">90"
        const gtMatch = range.match(/>([\d.]+)/);
        if (gtMatch) {
            return parseFloat(gtMatch[1]);
        }
        
        // Handle "less than" formats like "<200" - use absoluteMin to prevent conflicts
        const ltMatch = range.match(/<([\d.]+)/);
        if (ltMatch) {
            // Use absoluteMin as floor to prevent normal/absolute range conflicts
            // This ensures values between absoluteMin and the "less than" threshold get "abnormal" not "invalid"
            return absoluteMin || 0;
        }
        
        // Handle single number at start (fallback for edge cases)
        const singleMatch = range.match(/^([\d.]+)/);
        if (singleMatch) {
            return parseFloat(singleMatch[1]);
        }
        
        // If no pattern matches, return null (maintains existing behavior)
        return null;
    }

    parseRangeMax(range) {
        // Handle standard range format like "70-99" (backward compatibility)
        const standardMatch = range.match(/-([\d.]+)/);
        if (standardMatch) {
            return parseFloat(standardMatch[1]);
        }
        
        // Handle "less than" formats like "<200"
        const ltMatch = range.match(/<([\d.]+)/);
        if (ltMatch) {
            return parseFloat(ltMatch[1]);
        }
        
        // Handle "greater than" formats like ">40" or ">90" - return high value to allow abnormal classification
        const gtMatch = range.match(/>([\d.]+)/);
        if (gtMatch) {
            // Return a reasonably high value that allows for abnormal classification
            // This ensures values above the threshold get "abnormal" status, not "invalid"
            return 9999;
        }
        
        // If no pattern matches, return null (maintains existing behavior)
        return null;
    }

    validateBiomarkerValue(value, normalMin, normalMax, absoluteMin, absoluteMax, biomarkerName, unit) {
        const numValue = parseFloat(value);
        
        if (isNaN(numValue)) {
            return { 
                status: 'empty', 
                message: '', 
                icon: 'none',
                guidance: 'Enter a numeric value for this biomarker'
            };
        }
        
        // Defensive NaN handling - prevents validation failures when range parsing returns null
        if (isNaN(normalMin) || isNaN(normalMax)) {
            // Fallback: If normal ranges can't be determined, only validate against absolute limits
            if (numValue < absoluteMin || numValue > absoluteMax) {
                return { 
                    status: 'invalid', 
                    message: `Please enter a value between ${absoluteMin}-${absoluteMax} ${unit}`, 
                    icon: 'error',
                    guidance: 'This value appears to be outside the measurable range for this test'
                };
            }
            // If within absolute limits but normal range unknown, treat as acceptable
            return { 
                status: 'normal', 
                message: 'Value accepted - within measurable range', 
                icon: 'success',
                guidance: 'This value is within the acceptable measurement range for this test'
            };
        }
        
        if (numValue < absoluteMin || numValue > absoluteMax) {
            return { 
                status: 'invalid', 
                message: `Please enter a value between ${absoluteMin}-${absoluteMax} ${unit}`, 
                icon: 'error',
                guidance: 'This value appears to be outside the measurable range for this test'
            };
        }
        
        if (numValue >= normalMin && numValue <= normalMax) {
            return { 
                status: 'normal', 
                message: 'Excellent - within normal range', 
                icon: 'success',
                guidance: 'This value falls within the healthy reference range'
            };
        }
        
        if (numValue < normalMin || numValue > normalMax) {
            const severity = this.assessAbnormalSeverity(numValue, normalMin, normalMax);
            const direction = numValue < normalMin ? 'below' : 'above';
            const recommendation = this.getBiomarkerRecommendation(biomarkerName, direction, severity);
            
            return { 
                status: 'abnormal', 
                message: `${severity} - ${direction} normal range`, 
                icon: 'warning',
                guidance: recommendation
            };
        }
        
        return { 
            status: 'unknown', 
            message: 'Unable to validate this value', 
            icon: 'none',
            guidance: 'Please check that you entered the correct value'
        };
    }

    assessAbnormalSeverity(value, normalMin, normalMax) {
        const range = normalMax - normalMin;
        const deviation = Math.min(
            Math.abs(value - normalMin),
            Math.abs(value - normalMax)
        );
        const deviationPercent = (deviation / range) * 100;
        
        if (deviationPercent <= 25) return 'Mild deviation';
        if (deviationPercent <= 50) return 'Moderate deviation';
        return 'Significant deviation';
    }

    getBiomarkerRecommendation(biomarkerName, direction, severity) {
        const recommendations = {
            'glucose': {
                'above': 'High glucose may indicate diabetes risk. Consult your healthcare provider.',
                'below': 'Low glucose may indicate hypoglycemia. Monitor symptoms and consult your doctor.'
            },
            'hba1c': {
                'above': 'Elevated HbA1c suggests poor blood sugar control over 2-3 months.',
                'below': 'Very low HbA1c is rare but may indicate certain medical conditions.'
            },
            'totalCholesterol': {
                'above': 'High cholesterol may increase cardiovascular risk. Consider dietary changes.',
                'below': 'Very low cholesterol may affect hormone production and cell function.'
            },
            'hdlCholesterol': {
                'above': 'High HDL is generally protective against heart disease.',
                'below': 'Low HDL cholesterol may increase heart disease risk. Exercise may help.'
            },
            'ldlCholesterol': {
                'above': 'High LDL cholesterol may contribute to arterial plaque buildup.',
                'below': 'Very low LDL is generally beneficial for cardiovascular health.'
            },
            'triglycerides': {
                'above': 'High triglycerides may indicate increased cardiovascular risk.',
                'below': 'Low triglycerides are generally not a health concern.'
            },
            'systolicBP': {
                'above': 'High blood pressure may increase risk of heart disease and stroke.',
                'below': 'Very low blood pressure may cause dizziness or fainting.'
            },
            'diastolicBP': {
                'above': 'High diastolic pressure may indicate increased cardiovascular risk.',
                'below': 'Very low diastolic pressure may affect organ perfusion.'
            },
            'heartRate': {
                'above': 'High resting heart rate may indicate poor cardiovascular fitness.',
                'below': 'Very low heart rate may indicate excellent fitness or potential issues.'
            },
            'mcv': {
                'above': 'High MCV may suggest B12/folate deficiency or alcohol use. Consider nutritional assessment.',
                'below': 'Low MCV may indicate iron deficiency or thalassemia. Consider iron studies.'
            },
            'rdw': {
                'above': 'Elevated RDW may indicate nutritional deficiencies or chronic conditions. Consider comprehensive metabolic evaluation.',
                'below': 'Low RDW is generally not concerning but may indicate homogeneous cell population.'
            }
        };

        const biomarkerRec = recommendations[biomarkerName];
        if (biomarkerRec && biomarkerRec[direction]) {
            return biomarkerRec[direction];
        }

        // Generic recommendations based on direction and severity
        if (direction === 'above') {
            return severity === 'Significant deviation' 
                ? 'This value is significantly elevated. Please consult your healthcare provider.'
                : 'This value is above normal range. Consider lifestyle modifications or medical consultation.';
        } else {
            return severity === 'Significant deviation'
                ? 'This value is significantly below normal. Please consult your healthcare provider.'
                : 'This value is below normal range. Monitor symptoms and consider medical consultation.';
        }
    }

    setupBiomarkerValidation() {
        // Add event listeners for real-time validation
        const biomarkerInputs = document.querySelectorAll('.biomarker-input');
        
        biomarkerInputs.forEach(input => {
            input.addEventListener('input', (e) => {
                this.validateBiomarkerInput(e.target);
            });
            
            input.addEventListener('blur', (e) => {
                this.validateBiomarkerInput(e.target);
            });
        });
        
        // Add help button functionality
        const helpButtons = document.querySelectorAll('.biomarker-help-btn');
        helpButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                this.showBiomarkerHelp(button.dataset.biomarker);
            });
        });
    }

    showBiomarkerHelp(biomarkerName) {
        const helpInfo = this.getBiomarkerHelpInfo(biomarkerName);
        
        // Create and show modal with biomarker information
        const modal = document.createElement('div');
        modal.className = 'fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4';
        modal.innerHTML = `
            <div class="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto">
                <div class="p-6">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-xl font-semibold text-gray-800">
                            <i class="fas fa-vial text-blue-600 mr-2"></i>
                            ${helpInfo.name}
                        </h3>
                        <button class="close-help-modal text-gray-400 hover:text-gray-600 text-2xl">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    
                    <div class="space-y-4">
                        <div>
                            <h4 class="font-semibold text-gray-700 mb-2">What it measures:</h4>
                            <p class="text-gray-600 text-sm">${helpInfo.description}</p>
                        </div>
                        
                        <div>
                            <h4 class="font-semibold text-gray-700 mb-2">Normal Range:</h4>
                            <p class="text-gray-600 text-sm">${helpInfo.normalRange}</p>
                        </div>
                        
                        <div>
                            <h4 class="font-semibold text-gray-700 mb-2">Clinical Significance:</h4>
                            <p class="text-gray-600 text-sm">${helpInfo.significance}</p>
                        </div>
                        
                        ${helpInfo.tips ? `
                        <div>
                            <h4 class="font-semibold text-gray-700 mb-2">Tips for Improvement:</h4>
                            <ul class="text-gray-600 text-sm space-y-1">
                                ${helpInfo.tips.map(tip => `<li class="flex items-start"><i class="fas fa-check-circle text-green-500 mr-2 mt-0.5 text-xs"></i>${tip}</li>`).join('')}
                            </ul>
                        </div>
                        ` : ''}
                    </div>
                    
                    <div class="mt-6 pt-4 border-t border-gray-200">
                        <button class="close-help-modal w-full bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition">
                            Got it, thanks!
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        // Add to page
        document.body.appendChild(modal);
        
        // Add close functionality
        const closeButtons = modal.querySelectorAll('.close-help-modal');
        closeButtons.forEach(button => {
            button.addEventListener('click', () => {
                document.body.removeChild(modal);
            });
        });
        
        // Close on backdrop click
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                document.body.removeChild(modal);
            }
        });
    }

    getBiomarkerHelpInfo(biomarkerName) {
        const helpDatabase = {
            'glucose': {
                name: 'Fasting Glucose',
                description: 'Measures the amount of sugar (glucose) in your blood after fasting for at least 8 hours. This test helps detect diabetes and prediabetes.',
                normalRange: '70-99 mg/dL (3.9-5.5 mmol/L)',
                significance: 'Elevated glucose levels may indicate insulin resistance, prediabetes, or diabetes. Low levels may suggest hypoglycemia.',
                tips: [
                    'Maintain a balanced diet with complex carbohydrates',
                    'Exercise regularly to improve insulin sensitivity',
                    'Limit processed foods and added sugars',
                    'Consider intermittent fasting (consult your doctor first)'
                ]
            },
            'hba1c': {
                name: 'HbA1c (Glycated Hemoglobin)',
                description: 'Reflects your average blood sugar levels over the past 2-3 months. It measures the percentage of hemoglobin that has glucose attached to it.',
                normalRange: '4.0-5.6% (20-38 mmol/mol)',
                significance: 'HbA1c of 5.7-6.4% indicates prediabetes; 6.5% or higher indicates diabetes. Lower values generally indicate better blood sugar control.',
                tips: [
                    'Focus on steady, gradual weight loss if overweight',
                    'Choose low glycemic index foods',
                    'Monitor carbohydrate intake',
                    'Take prescribed diabetes medications as directed'
                ]
            },
            'totalCholesterol': {
                name: 'Total Cholesterol',
                description: 'Measures the total amount of cholesterol in your blood, including both LDL (bad) and HDL (good) cholesterol.',
                normalRange: 'Less than 200 mg/dL (5.2 mmol/L)',
                significance: 'High total cholesterol may increase risk of heart disease and stroke. However, the ratio of HDL to LDL is more important than total cholesterol alone.',
                tips: [
                    'Increase intake of omega-3 fatty acids',
                    'Choose lean proteins and plant-based options',
                    'Increase soluble fiber intake',
                    'Limit saturated and trans fats'
                ]
            },
            'hdlCholesterol': {
                name: 'HDL Cholesterol (Good Cholesterol)',
                description: 'High-density lipoprotein that helps remove other forms of cholesterol from your bloodstream and transport them to your liver for disposal.',
                normalRange: 'Men: >40 mg/dL, Women: >50 mg/dL (>1.0/>1.3 mmol/L)',
                significance: 'Higher HDL levels are protective against heart disease. Low HDL increases cardiovascular risk even when total cholesterol is normal.',
                tips: [
                    'Engage in regular aerobic exercise',
                    'Maintain a healthy weight',
                    'Choose healthy fats like olive oil and avocados',
                    'Limit refined carbohydrates'
                ]
            },
            'ldlCholesterol': {
                name: 'LDL Cholesterol (Bad Cholesterol)',
                description: 'Low-density lipoprotein that can build up in the walls of your arteries, forming plaque that narrows and hardens arteries.',
                normalRange: 'Less than 100 mg/dL (2.6 mmol/L)',
                significance: 'High LDL cholesterol is a major risk factor for heart disease and stroke. Lower levels reduce cardiovascular risk.',
                tips: [
                    'Reduce saturated fat intake',
                    'Increase soluble fiber consumption',
                    'Consider plant sterols and stanols',
                    'Maintain regular physical activity'
                ]
            },
            'triglycerides': {
                name: 'Triglycerides',
                description: 'A type of fat found in your blood that your body uses for energy. High levels may indicate increased risk of heart disease.',
                normalRange: 'Less than 150 mg/dL (1.7 mmol/L)',
                significance: 'High triglycerides often accompany low HDL and high blood sugar, forming part of metabolic syndrome.',
                tips: [
                    'Limit refined carbohydrates and sugar',
                    'Reduce alcohol consumption',
                    'Increase omega-3 fatty acids',
                    'Maintain a healthy weight'
                ]
            },
            'systolicBP': {
                name: 'Systolic Blood Pressure',
                description: 'The pressure in your arteries when your heart beats and pumps blood. It\'s the top number in a blood pressure reading.',
                normalRange: 'Less than 120 mmHg',
                significance: 'High systolic pressure indicates increased risk of heart disease, stroke, and kidney disease.',
                tips: [
                    'Reduce sodium intake to less than 2,300mg daily',
                    'Increase potassium-rich foods',
                    'Manage stress through meditation or yoga',
                    'Maintain regular exercise routine'
                ]
            },
            'diastolicBP': {
                name: 'Diastolic Blood Pressure',
                description: 'The pressure in your arteries when your heart rests between beats. It\'s the bottom number in a blood pressure reading.',
                normalRange: 'Less than 80 mmHg',
                significance: 'High diastolic pressure may indicate increased cardiovascular risk and potential organ damage.',
                tips: [
                    'Maintain a healthy weight',
                    'Limit alcohol consumption',
                    'Get adequate sleep (7-9 hours nightly)',
                    'Practice stress reduction techniques'
                ]
            },
            'heartRate': {
                name: 'Resting Heart Rate',
                description: 'The number of times your heart beats per minute when you\'re at rest. A lower resting heart rate generally indicates better cardiovascular fitness.',
                normalRange: '60-100 beats per minute',
                significance: 'A lower resting heart rate typically indicates good cardiovascular fitness. Very high rates may indicate poor fitness or medical conditions.',
                tips: [
                    'Engage in regular cardiovascular exercise',
                    'Practice deep breathing exercises',
                    'Maintain adequate hydration',
                    'Get sufficient quality sleep'
                ]
            },
            'mcv': {
                name: 'Mean Cell Volume (MCV)',
                description: 'Measures the average size of your red blood cells. This test helps diagnose different types of anemia and other blood disorders.',
                normalRange: '82-98 femtoliters (fL)',
                significance: 'Low MCV may indicate iron deficiency or thalassemia. High MCV may suggest B12/folate deficiency or alcohol use. Used in biological age calculations.',
                tips: [
                    'Maintain adequate iron intake through diet',
                    'Ensure sufficient B12 and folate consumption', 
                    'Limit excessive alcohol consumption',
                    'Regular blood tests if you have anemia risk factors'
                ]
            },
            'rdw': {
                name: 'Red Cell Distribution Width (RDW)',
                description: 'Measures the variation in size of your red blood cells. Higher values indicate more variation in cell size, which can indicate various health conditions.',
                normalRange: '11.5-14.5%',
                significance: 'Elevated RDW may indicate nutritional deficiencies, chronic diseases, or aging-related changes. Important component of biological age calculations.',
                tips: [
                    'Follow a balanced diet rich in iron, B12, and folate',
                    'Address any underlying chronic conditions',
                    'Regular exercise to improve overall health',
                    'Discuss with your doctor if consistently elevated'
                ]
            }
        };

        return helpDatabase[biomarkerName] || {
            name: 'Biomarker Information',
            description: 'This biomarker provides important health information. Please consult your healthcare provider for specific guidance.',
            normalRange: 'Varies by individual and laboratory',
            significance: 'Clinical significance depends on individual health factors and medical history.'
        };
    }

    addBiomarkerSummary() {
        // Find the biomarker section and add a summary panel
        const biomarkerSection = document.querySelector('.form-section-card .form-section-title i.fa-vial')?.closest('.form-section-card');
        if (!biomarkerSection) return;

        const summaryHTML = `
            <div id="biomarkerSummary" class="mt-4 p-4 bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200 rounded-lg">
                <div class="flex items-center justify-between mb-3">
                    <h5 class="font-semibold text-gray-800 flex items-center">
                        <i class="fas fa-chart-pie text-blue-600 mr-2"></i>
                        Biomarker Status Summary
                    </h5>
                    <button type="button" id="refreshSummary" class="text-sm text-blue-600 hover:text-blue-800 transition">
                        <i class="fas fa-sync-alt mr-1"></i>Refresh
                    </button>
                </div>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                    <div class="bg-white p-2 rounded border">
                        <div class="font-medium text-gray-600">Total Entered</div>
                        <div class="text-lg font-bold text-gray-800" id="totalEntered">0</div>
                    </div>
                    <div class="bg-white p-2 rounded border">
                        <div class="font-medium text-green-600">Normal Range</div>
                        <div class="text-lg font-bold text-green-700" id="normalCount">0</div>
                    </div>
                    <div class="bg-white p-2 rounded border">
                        <div class="font-medium text-yellow-600">Outside Normal</div>
                        <div class="text-lg font-bold text-yellow-700" id="abnormalCount">0</div>
                    </div>
                    <div class="bg-white p-2 rounded border">
                        <div class="font-medium text-red-600">Invalid Values</div>
                        <div class="text-lg font-bold text-red-700" id="invalidCount">0</div>
                    </div>
                </div>
                <div class="mt-3 text-xs text-gray-600">
                    <i class="fas fa-info-circle mr-1"></i>
                    <span id="summaryMessage">Enter your biomarker values to see validation summary</span>
                </div>
            </div>
        `;

        biomarkerSection.insertAdjacentHTML('beforeend', summaryHTML);

        // Add refresh functionality
        document.getElementById('refreshSummary')?.addEventListener('click', () => {
            this.updateBiomarkerSummary();
        });
    }

    updateBiomarkerSummary() {
        const biomarkerInputs = document.querySelectorAll('.biomarker-input');
        let totalEntered = 0;
        let normalCount = 0;
        let abnormalCount = 0;
        let invalidCount = 0;

        biomarkerInputs.forEach(input => {
            const value = input.value.trim();
            if (value) {
                totalEntered++;
                
                if (input.classList.contains('border-green-500')) {
                    normalCount++;
                } else if (input.classList.contains('border-yellow-500')) {
                    abnormalCount++;
                } else if (input.classList.contains('border-red-500')) {
                    invalidCount++;
                }
            }
        });

        // Update the summary display
        const totalElement = document.getElementById('totalEntered');
        const normalElement = document.getElementById('normalCount');
        const abnormalElement = document.getElementById('abnormalCount');
        const invalidElement = document.getElementById('invalidCount');
        const messageElement = document.getElementById('summaryMessage');

        if (totalElement) totalElement.textContent = totalEntered;
        if (normalElement) normalElement.textContent = normalCount;
        if (abnormalElement) abnormalElement.textContent = abnormalCount;
        if (invalidElement) invalidElement.textContent = invalidCount;

        // Update summary message
        if (messageElement) {
            if (totalEntered === 0) {
                messageElement.innerHTML = '<i class="fas fa-info-circle mr-1"></i>Enter your biomarker values to see validation summary';
            } else if (invalidCount > 0) {
                messageElement.innerHTML = '<i class="fas fa-exclamation-triangle text-red-500 mr-1"></i>Please correct invalid values before proceeding';
            } else if (abnormalCount > 0) {
                messageElement.innerHTML = '<i class="fas fa-exclamation-triangle text-yellow-500 mr-1"></i>Some values are outside normal range - review the guidance provided';
            } else if (normalCount > 0) {
                messageElement.innerHTML = '<i class="fas fa-check-circle text-green-500 mr-1"></i>All entered values are within normal ranges';
            }
        }
    }

    validateBiomarkerInput(input) {
        const container = input.closest('.biomarker-input-container');
        const validationStatus = container.querySelector('.validation-status');
        const validationMessage = container.querySelector('.validation-message');
        const validationIcons = container.querySelectorAll('.validation-icon i');
        const guidanceMessage = container.querySelector('.guidance-message');
        const guidanceText = container.querySelector('.guidance-text');
        
        const value = input.value.trim();
        const normalMin = parseFloat(input.dataset.normalMin);
        const normalMax = parseFloat(input.dataset.normalMax);
        const absoluteMin = parseFloat(input.min);
        const absoluteMax = parseFloat(input.max);
        const biomarkerName = input.name;
        const unit = input.dataset.unit;
        
        const validation = this.validateBiomarkerValue(
            value, normalMin, normalMax, absoluteMin, absoluteMax, biomarkerName, unit
        );
        
        // Reset all states
        input.classList.remove('border-green-500', 'border-yellow-500', 'border-red-500');
        validationIcons.forEach(icon => icon.classList.add('hidden'));
        validationStatus.classList.add('hidden');
        guidanceMessage.classList.add('hidden');
        
        if (validation.status === 'empty') {
            // Show helpful guidance for empty values
            if (guidanceText && validation.guidance) {
                guidanceText.textContent = validation.guidance;
                guidanceMessage.classList.remove('hidden');
                guidanceMessage.className = 'guidance-message mt-2 p-2 bg-gray-50 border-l-4 border-gray-400 text-xs text-gray-600';
            }
            validationMessage.textContent = '';
            return;
        }
        
        // Apply validation styling and enhanced feedback
        switch (validation.status) {
            case 'normal':
                input.classList.add('border-green-500');
                validationIcons[0].classList.remove('hidden'); // check circle
                validationStatus.innerHTML = '<i class="fas fa-check-circle text-green-500"></i> Normal';
                validationStatus.classList.remove('hidden');
                if (guidanceText && validation.guidance) {
                    guidanceText.textContent = validation.guidance;
                    guidanceMessage.classList.remove('hidden');
                    guidanceMessage.className = 'guidance-message mt-2 p-2 bg-green-50 border-l-4 border-green-400 text-xs text-green-700';
                }
                break;
                
            case 'abnormal':
                input.classList.add('border-yellow-500');
                validationIcons[1].classList.remove('hidden'); // warning triangle
                validationStatus.innerHTML = '<i class="fas fa-exclamation-triangle text-yellow-500"></i> Abnormal';
                validationStatus.classList.remove('hidden');
                if (guidanceText && validation.guidance) {
                    guidanceText.textContent = validation.guidance;
                    guidanceMessage.classList.remove('hidden');
                    guidanceMessage.className = 'guidance-message mt-2 p-2 bg-yellow-50 border-l-4 border-yellow-400 text-xs text-yellow-700';
                }
                break;
                
            case 'invalid':
                input.classList.add('border-red-500');
                validationIcons[2].classList.remove('hidden'); // error circle
                validationStatus.innerHTML = '<i class="fas fa-times-circle text-red-500"></i> Invalid';
                validationStatus.classList.remove('hidden');
                if (guidanceText && validation.guidance) {
                    guidanceText.textContent = validation.guidance;
                    guidanceMessage.classList.remove('hidden');
                    guidanceMessage.className = 'guidance-message mt-2 p-2 bg-red-50 border-l-4 border-red-400 text-xs text-red-700';
                }
                break;
                
            default:
                // Unknown status
                if (guidanceText && validation.guidance) {
                    guidanceText.textContent = validation.guidance;
                    guidanceMessage.classList.remove('hidden');
                    guidanceMessage.className = 'guidance-message mt-2 p-2 bg-gray-50 border-l-4 border-gray-400 text-xs text-gray-600';
                }
                break;
        }
        
        validationMessage.textContent = validation.message;
        
        // Update summary after validation
        setTimeout(() => this.updateBiomarkerSummary(), 100);
        
        // Trigger accessibility announcements for screen readers
        this.announceValidationChange(validation, biomarkerName);
    }

    announceValidationChange(validation, biomarkerName) {
        // Create or update ARIA live region for accessibility
        let liveRegion = document.getElementById('validation-announcer');
        if (!liveRegion) {
            liveRegion = document.createElement('div');
            liveRegion.id = 'validation-announcer';
            liveRegion.setAttribute('aria-live', 'polite');
            liveRegion.setAttribute('aria-atomic', 'true');
            liveRegion.className = 'sr-only'; // Screen reader only
            document.body.appendChild(liveRegion);
        }
        
        if (validation.status !== 'empty') {
            const biomarkerLabel = this.getBiomarkerLabel(biomarkerName);
            liveRegion.textContent = `${biomarkerLabel}: ${validation.message}`;
        }
    }

    getBiomarkerLabel(biomarkerName) {
        const biomarkerLabels = {
            'glucose': 'Fasting Glucose',
            'hba1c': 'HbA1c',
            'totalCholesterol': 'Total Cholesterol',
            'hdlCholesterol': 'HDL Cholesterol',
            'ldlCholesterol': 'LDL Cholesterol',
            'triglycerides': 'Triglycerides',
            'systolicBP': 'Systolic Blood Pressure',
            'diastolicBP': 'Diastolic Blood Pressure',
            'heartRate': 'Heart Rate',
            'waistCircumference': 'Waist Circumference',
            'creatinine': 'Creatinine',
            'albumin': 'Albumin',
            'crp': 'C-Reactive Protein',
            'wbc': 'White Blood Cells',
            'alp': 'Alkaline Phosphatase',
            'lymphocytes': 'Lymphocytes',
            'mcv': 'Mean Cell Volume',
            'rdw': 'Red Cell Distribution Width',
            'hemoglobin': 'Hemoglobin'
        };
        return biomarkerLabels[biomarkerName] || biomarkerName;
    }

    // Enhanced form validation before step progression
    validateBiomarkerStep() {
        const inputs = document.querySelectorAll('.biomarker-input');
        const errors = [];
        const warnings = [];
        let validCount = 0;
        let totalCount = 0;

        inputs.forEach(input => {
            if (input.value.trim()) {
                totalCount++;
                const container = input.closest('.biomarker-input-container');
                const hasError = input.classList.contains('border-red-500');
                const hasWarning = input.classList.contains('border-yellow-500');
                const isValid = input.classList.contains('border-green-500');
                
                // Enhanced handling: Check for inputs without any validation class (unknown status)
                const hasNoValidationClass = !hasError && !hasWarning && !isValid;

                if (hasError) {
                    const biomarkerLabel = this.getBiomarkerLabel(input.name);
                    errors.push({
                        field: input.name,
                        label: biomarkerLabel,
                        message: container.querySelector('.validation-message').textContent
                    });
                } else if (hasWarning) {
                    const biomarkerLabel = this.getBiomarkerLabel(input.name);
                    warnings.push({
                        field: input.name,
                        label: biomarkerLabel,
                        message: container.querySelector('.validation-message').textContent
                    });
                } else if (isValid || hasNoValidationClass) {
                    // Treat both valid inputs and unknown status inputs as acceptable
                    validCount++;
                }
            }
        });

        return {
            isValid: errors.length === 0,
            errors,
            warnings,
            validCount,
            totalCount,
            hasData: totalCount > 0
        };
    }

    // Enhanced error display for form submission
    showBiomarkerValidationSummary(validation) {
        // Remove existing summary
        const existingSummary = document.getElementById('biomarker-validation-summary');
        if (existingSummary) {
            existingSummary.remove();
        }

        if (!validation.hasData || (validation.errors.length === 0 && validation.warnings.length === 0)) {
            return;
        }

        const summary = document.createElement('div');
        summary.id = 'biomarker-validation-summary';
        summary.className = 'mb-6 p-4 rounded-lg border';

        let summaryContent = '';

        if (validation.errors.length > 0) {
            summary.className += ' bg-red-50 border-red-300';
            summaryContent += `
                <div class="flex items-center mb-3">
                    <i class="fas fa-exclamation-circle text-red-500 mr-2"></i>
                    <h4 class="font-semibold text-red-800">Please correct the following errors:</h4>
                </div>
                <ul class="list-disc list-inside space-y-1 text-sm text-red-700 mb-3">
                    ${validation.errors.map(error => `<li><strong>${error.label}:</strong> ${error.message}</li>`).join('')}
                </ul>
            `;
        } else if (validation.warnings.length > 0) {
            summary.className += ' bg-yellow-50 border-yellow-300';
            summaryContent += `
                <div class="flex items-center mb-3">
                    <i class="fas fa-exclamation-triangle text-yellow-500 mr-2"></i>
                    <h4 class="font-semibold text-yellow-800">Review the following items:</h4>
                </div>
                <ul class="list-disc list-inside space-y-1 text-sm text-yellow-700 mb-3">
                    ${validation.warnings.map(warning => `<li><strong>${warning.label}:</strong> ${warning.message}</li>`).join('')}
                </ul>
                <p class="text-sm text-yellow-700">
                    <i class="fas fa-info-circle mr-1"></i>
                    You can continue with these values, but consider consulting your healthcare provider about any abnormal results.
                </p>
            `;
        }

        // Add overall progress indicator
        if (validation.totalCount > 0) {
            summaryContent += `
                <div class="mt-3 pt-3 border-t border-gray-200">
                    <div class="flex items-center justify-between text-sm text-gray-600">
                        <span>Lab values entered: ${validation.totalCount}</span>
                        <span class="text-green-600">
                            <i class="fas fa-check-circle mr-1"></i>
                            Valid: ${validation.validCount}
                        </span>
                    </div>
                </div>
            `;
        }

        summary.innerHTML = summaryContent;

        // Insert before the navigation buttons with proper error handling
        try {
            const formContent = document.getElementById('form-step-content');
            if (!formContent) {
                console.error('Form content container not found');
                return;
            }

            const navigationDiv = formContent.querySelector('.flex.justify-between');
            if (navigationDiv && navigationDiv.parentNode === formContent) {
                // Verify navigationDiv is a direct child before insertion
                formContent.insertBefore(summary, navigationDiv);
                summary.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            } else {
                // Fallback: append to form content if navigation div not found or not direct child
                formContent.appendChild(summary);
                summary.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }
        } catch (error) {
            console.error('Error inserting biomarker validation summary:', error);
            // Fallback: try to append to form content
            try {
                const formContent = document.getElementById('form-step-content');
                if (formContent) {
                    formContent.appendChild(summary);
                }
            } catch (fallbackError) {
                console.error('Fallback insertion also failed:', fallbackError);
            }
        }
    }

    renderStep2_FunctionalMedicine() {
        return `
            <div class="step-header">
                <h3 class="step-title">
                    <i class="fas fa-cogs text-green-600 mr-3"></i>
                    Functional Medicine Systems Assessment
                </h3>
                <p class="step-description">Rate your symptoms and experiences for each of the 7 core functional medicine systems</p>
            </div>
            
            <div class="space-y-6">
                ${this.renderFunctionalMedicineSystems()}
            </div>
        `;
    }

    renderFunctionalMedicineSystems() {
        const systems = [
            {
                id: 'assimilation',
                name: 'Assimilation System',
                description: 'Digestion, absorption, and nutrient processing',
                questions: [
                    { text: 'How often do you experience bloating after meals?', type: 'frequency' },
                    { text: 'Do you have regular, well-formed bowel movements?', type: 'yesno' },
                    { text: 'How would you rate your digestive comfort overall?', type: 'rating' },
                    { text: 'Do you have known food sensitivities or intolerances?', type: 'yesno' },
                    { text: 'How often do you experience gas or abdominal discomfort?', type: 'frequency' },
                    { text: 'Do you feel satisfied and energized after meals?', type: 'yesno' }
                ]
            },
            {
                id: 'biotransformation',
                name: 'Biotransformation & Elimination',
                description: 'Detoxification, liver function, and waste elimination',
                questions: [
                    { text: 'How often do you feel fatigued or sluggish?', type: 'frequency' },
                    { text: 'Do you have regular bowel movements (at least once daily)?', type: 'yesno' },
                    { text: 'How well do you tolerate alcohol or caffeine?', type: 'rating' },
                    { text: 'Do you sweat easily during physical activity?', type: 'yesno' },
                    { text: 'How sensitive are you to strong odors or chemicals?', type: 'severity' },
                    { text: 'How would you rate your overall energy for detoxification?', type: 'rating' }
                ]
            },
            {
                id: 'defense',
                name: 'Defense & Repair',
                description: 'Immune function, inflammation, and healing',
                questions: [
                    { text: 'How often do you get colds or infections?', type: 'frequency' },
                    { text: 'How quickly do you recover from illness?', type: 'recovery' },
                    { text: 'Do you have any autoimmune conditions or symptoms?', type: 'yesno' },
                    { text: 'How well do cuts and wounds heal?', type: 'rating' },
                    { text: 'Do you experience chronic inflammation or pain?', type: 'yesno' },
                    { text: 'How would you rate your overall immune strength?', type: 'rating' }
                ]
            },
            {
                id: 'structural',
                name: 'Structural Integrity',
                description: 'Musculoskeletal health, posture, and physical stability',
                questions: [
                    { text: 'Do you experience joint pain or stiffness?', type: 'yesno' },
                    { text: 'How would you rate your muscle strength?', type: 'rating' },
                    { text: 'Do you have good posture and alignment?', type: 'yesno' },
                    { text: 'How often do you experience back or neck pain?', type: 'frequency' },
                    { text: 'Do you have good balance and coordination?', type: 'yesno' },
                    { text: 'How would you rate your overall physical mobility?', type: 'rating' }
                ]
            },
            {
                id: 'communication',
                name: 'Communication System',
                description: 'Hormones, neurotransmitters, and signaling',
                questions: [
                    { text: 'How stable is your mood throughout the day?', type: 'rating' },
                    { text: 'Do you have regular, restful sleep patterns?', type: 'yesno' },
                    { text: 'How well do you handle stress?', type: 'rating' },
                    { text: 'Do you experience hormone-related symptoms?', type: 'yesno' },
                    { text: 'How sharp is your mental focus and concentration?', type: 'rating' },
                    { text: 'How would you rate your emotional regulation?', type: 'rating' }
                ]
            },
            {
                id: 'energy',
                name: 'Energy System',
                description: 'Cellular energy production and metabolism',
                questions: [
                    { text: 'How are your energy levels throughout the day?', type: 'rating' },
                    { text: 'Do you experience afternoon energy crashes?', type: 'yesno' },
                    { text: 'How well do you recover from physical exertion?', type: 'rating' },
                    { text: 'Do you feel refreshed after sleep?', type: 'yesno' },
                    { text: 'How stable is your energy without caffeine?', type: 'rating' },
                    { text: 'How would you rate your overall vitality?', type: 'rating' }
                ]
            },
            {
                id: 'transport',
                name: 'Transport System',
                description: 'Circulation, cardiovascular, and lymphatic systems',
                questions: [
                    { text: 'Do you have good circulation (warm hands/feet)?', type: 'yesno' },
                    { text: 'How is your cardiovascular fitness?', type: 'rating' },
                    { text: 'Do you experience swelling or fluid retention?', type: 'yesno' },
                    { text: 'How well do you tolerate physical activity?', type: 'rating' },
                    { text: 'Do you have any heart-related symptoms?', type: 'yesno' },
                    { text: 'How would you rate your overall circulation?', type: 'rating' }
                ]
            }
        ];

        return systems.map((system, idx) => {
            const colors = ['blue', 'green', 'purple', 'orange', 'teal', 'pink', 'indigo'];
            const color = colors[idx % colors.length];
            
            return `
                <div class="form-section-card section-${color === 'orange' ? 'yellow' : color}-enhanced">
                    <div class="form-section-header">
                        <h4 class="form-section-title">
                            <i class="fas fa-${this.getSystemIcon(system.id)} text-${color}-600"></i>
                            ${system.name}
                        </h4>
                        <p class="form-section-description">${system.description}</p>
                    </div>
                    <div class="form-section-content">
                        <div class="space-y-4">
                            ${system.questions.map((questionObj, index) => this.renderFunctionalMedicineQuestion(questionObj, system.id, index + 1)).join('')}
                        </div>
                    </div>
                </div>
            `;
        }).join('');
    }
    
    getSystemIcon(systemId) {
        const icons = {
            'assimilation': 'utensils',
            'biotransformation': 'filter',
            'defense': 'shield-alt',
            'structural': 'bone',
            'communication': 'brain',
            'energy': 'bolt',
            'transport': 'heart'
        };
        return icons[systemId] || 'cog';
    }

    renderFunctionalMedicineQuestion(questionObj, systemId, questionNum) {
        const questionName = `${systemId}_q${questionNum}`;
        
        switch(questionObj.type) {
            case 'frequency':
                return `
                    <div class="bg-white rounded-md p-4">
                        <label class="block text-sm font-medium text-gray-700 mb-3">${questionObj.text}</label>
                        <div class="grid grid-cols-2 md:grid-cols-5 gap-2">
                            ${[
                                { value: 'never', label: 'Never' },
                                { value: 'rarely', label: 'Rarely' },
                                { value: 'sometimes', label: 'Sometimes' },
                                { value: 'often', label: 'Often' },
                                { value: 'always', label: 'Always/Daily' }
                            ].map(option => `
                                <label class="flex items-center p-2 rounded border cursor-pointer hover:bg-gray-50">
                                    <input type="radio" name="${questionName}" value="${option.value}" class="mr-2">
                                    <span class="text-sm">${option.label}</span>
                                </label>
                            `).join('')}
                        </div>
                    </div>
                `;
            
            case 'yesno':
                return `
                    <div class="bg-white rounded-md p-4">
                        <label class="block text-sm font-medium text-gray-700 mb-3">${questionObj.text}</label>
                        <div class="grid grid-cols-2 gap-2">
                            <label class="flex items-center p-3 rounded border cursor-pointer hover:bg-gray-50">
                                <input type="radio" name="${questionName}" value="yes" class="mr-2">
                                <span class="text-sm font-medium">Yes</span>
                            </label>
                            <label class="flex items-center p-3 rounded border cursor-pointer hover:bg-gray-50">
                                <input type="radio" name="${questionName}" value="no" class="mr-2">
                                <span class="text-sm font-medium">No</span>
                            </label>
                        </div>
                    </div>
                `;
            
            case 'severity':
                return `
                    <div class="bg-white rounded-md p-4">
                        <label class="block text-sm font-medium text-gray-700 mb-3">${questionObj.text}</label>
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-2">
                            ${[
                                { value: 'none', label: 'Not Sensitive' },
                                { value: 'mild', label: 'Mildly Sensitive' },
                                { value: 'moderate', label: 'Moderately Sensitive' },
                                { value: 'severe', label: 'Very Sensitive' }
                            ].map(option => `
                                <label class="flex items-center p-2 rounded border cursor-pointer hover:bg-gray-50">
                                    <input type="radio" name="${questionName}" value="${option.value}" class="mr-2">
                                    <span class="text-sm">${option.label}</span>
                                </label>
                            `).join('')}
                        </div>
                    </div>
                `;
            
            case 'recovery':
                return `
                    <div class="bg-white rounded-md p-4">
                        <label class="block text-sm font-medium text-gray-700 mb-3">${questionObj.text}</label>
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-2">
                            ${[
                                { value: 'very_slow', label: 'Very Slowly' },
                                { value: 'slow', label: 'Slowly' },
                                { value: 'normal', label: 'Normal Speed' },
                                { value: 'fast', label: 'Quickly' }
                            ].map(option => `
                                <label class="flex items-center p-2 rounded border cursor-pointer hover:bg-gray-50">
                                    <input type="radio" name="${questionName}" value="${option.value}" class="mr-2">
                                    <span class="text-sm">${option.label}</span>
                                </label>
                            `).join('')}
                        </div>
                    </div>
                `;
            
            case 'rating':
            default:
                return `
                    <div class="bg-white rounded-md p-4">
                        <label class="block text-sm font-medium text-gray-700 mb-3">${questionObj.text}</label>
                        <div class="grid grid-cols-2 md:grid-cols-5 gap-2">
                            ${[
                                { value: 'poor', label: 'Poor' },
                                { value: 'fair', label: 'Fair' },
                                { value: 'good', label: 'Good' },
                                { value: 'very_good', label: 'Very Good' },
                                { value: 'excellent', label: 'Excellent' }
                            ].map(option => `
                                <label class="flex items-center p-2 rounded border cursor-pointer hover:bg-gray-50">
                                    <input type="radio" name="${questionName}" value="${option.value}" class="mr-2">
                                    <span class="text-sm">${option.label}</span>
                                </label>
                            `).join('')}
                        </div>
                    </div>
                `;
        }
    }

    renderStep3_MentalHealth() {
        return `
            <div class="space-y-8">
                <div class="text-center mb-6">
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Mental Health & Cognitive Assessment</h3>
                    <p class="text-gray-600">Comprehensive evaluation including validated screening tools (PHQ-9, GAD-7) and cognitive function assessment</p>
                </div>

                <!-- PHQ-9 Depression Screening -->
                <div class="bg-blue-50 rounded-lg p-6">
                    <h4 class="text-lg font-semibold text-blue-800 mb-4">
                        <i class="fas fa-heart mr-2"></i>PHQ-9 Depression Screening
                    </h4>
                    <p class="text-sm text-blue-700 mb-6">Over the last 2 weeks, how often have you been bothered by any of the following problems?</p>
                    
                    ${this.renderPHQ9Questions()}
                </div>

                <!-- GAD-7 Anxiety Screening -->
                <div class="bg-purple-50 rounded-lg p-6">
                    <h4 class="text-lg font-semibold text-purple-800 mb-4">
                        <i class="fas fa-brain mr-2"></i>GAD-7 Anxiety Screening
                    </h4>
                    <p class="text-sm text-purple-700 mb-6">Over the last 2 weeks, how often have you been bothered by the following problems?</p>
                    
                    ${this.renderGAD7Questions()}
                </div>

                <!-- Cognitive Function Assessment -->
                <div class="bg-indigo-50 rounded-lg p-6">
                    <h4 class="text-lg font-semibold text-indigo-800 mb-4">
                        <i class="fas fa-brain mr-2"></i>Cognitive Function Assessment
                    </h4>
                    <p class="text-sm text-indigo-700 mb-6">Please rate your current cognitive abilities and mental performance over the past month.</p>
                    
                    ${this.renderCognitiveAssessment()}
                </div>

                <!-- Stress & Coping Assessment -->
                <div class="bg-teal-50 rounded-lg p-6">
                    <h4 class="text-lg font-semibold text-teal-800 mb-4">
                        <i class="fas fa-leaf mr-2"></i>Stress Management & Resilience
                    </h4>
                    <p class="text-sm text-teal-700 mb-6">Assessment of your stress management abilities and psychological resilience.</p>
                    
                    ${this.renderStressResilienceAssessment()}
                </div>

                <!-- Enhanced Mental Health Factors -->
                <div class="bg-orange-50 rounded-lg p-6">
                    <h4 class="text-lg font-semibold text-orange-800 mb-4">
                        <i class="fas fa-shield-alt mr-2"></i>Mental Health Protective Factors
                    </h4>
                    <p class="text-sm text-orange-700 mb-6">Factors that support your mental health and cognitive reserve.</p>
                    
                    ${this.renderMentalHealthProtectiveFactors()}
                </div>
            </div>
        `;
    }

    renderPHQ9Questions() {
        const questions = [
            'Little interest or pleasure in doing things',
            'Feeling down, depressed, or hopeless',
            'Trouble falling or staying asleep, or sleeping too much',
            'Feeling tired or having little energy',
            'Poor appetite or overeating',
            'Feeling bad about yourself — or that you are a failure or have let yourself or your family down',
            'Trouble concentrating on things, such as reading the newspaper or watching television',
            'Moving or speaking so slowly that other people could have noticed? Or the opposite — being so fidgety or restless that you have been moving around a lot more than usual',
            'Thoughts that you would be better off dead or of hurting yourself in some way'
        ];

        const options = [
            { value: 0, label: 'Not at all' },
            { value: 1, label: 'Several days' },
            { value: 2, label: 'More than half the days' },
            { value: 3, label: 'Nearly every day' }
        ];

        return questions.map((question, index) => `
            <div class="bg-white rounded-md p-4 mb-3">
                <label class="block text-sm font-medium text-gray-700 mb-3">${index + 1}. ${question}</label>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-2">
                    ${options.map(option => `
                        <label class="flex items-center p-2 rounded border cursor-pointer hover:bg-gray-50">
                            <input type="radio" name="phq9_q${index + 1}" value="${option.value}" class="mr-2">
                            <span class="text-sm">${option.label} (${option.value})</span>
                        </label>
                    `).join('')}
                </div>
            </div>
        `).join('');
    }

    renderGAD7Questions() {
        const questions = [
            'Feeling nervous, anxious or on edge',
            'Not being able to stop or control worrying',
            'Worrying too much about different things',
            'Trouble relaxing',
            'Being so restless that it is hard to sit still',
            'Becoming easily annoyed or irritable',
            'Feeling afraid as if something awful might happen'
        ];

        const options = [
            { value: 0, label: 'Not at all' },
            { value: 1, label: 'Several days' },
            { value: 2, label: 'More than half the days' },
            { value: 3, label: 'Nearly every day' }
        ];

        return questions.map((question, index) => `
            <div class="bg-white rounded-md p-4 mb-3">
                <label class="block text-sm font-medium text-gray-700 mb-3">${index + 1}. ${question}</label>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-2">
                    ${options.map(option => `
                        <label class="flex items-center p-2 rounded border cursor-pointer hover:bg-gray-50">
                            <input type="radio" name="gad7_q${index + 1}" value="${option.value}" class="mr-2">
                            <span class="text-sm">${option.label} (${option.value})</span>
                        </label>
                    `).join('')}
                </div>
            </div>
        `).join('');
    }

    renderCognitiveAssessment() {
        const cognitiveQuestions = [
            {
                id: 'memory_recall',
                question: 'How would you rate your ability to remember recent events, conversations, or where you put things?',
                category: 'Memory'
            },
            {
                id: 'memory_learning',
                question: 'How easily can you learn and remember new information (names, facts, procedures)?',
                category: 'Memory'
            },
            {
                id: 'attention_focus',
                question: 'How well can you maintain focus and attention during tasks or conversations?',
                category: 'Attention'
            },
            {
                id: 'attention_multitask',
                question: 'How effectively can you handle multiple tasks or switch between different activities?',
                category: 'Attention'
            },
            {
                id: 'processing_speed',
                question: 'How quickly can you think through problems or respond to questions?',
                category: 'Processing Speed'
            },
            {
                id: 'processing_decisions',
                question: 'How efficiently can you make decisions, even for simple everyday choices?',
                category: 'Processing Speed'
            },
            {
                id: 'executive_planning',
                question: 'How well can you plan, organize, and execute complex tasks or projects?',
                category: 'Executive Function'
            },
            {
                id: 'executive_problem_solving',
                question: 'How effectively can you solve problems and think through complex situations?',
                category: 'Executive Function'
            }
        ];

        const ratingOptions = [
            { value: 4, label: 'Excellent', description: 'Consistently high performance' },
            { value: 3, label: 'Good', description: 'Generally performs well' },
            { value: 2, label: 'Fair', description: 'Some difficulties noticed' },
            { value: 1, label: 'Poor', description: 'Significant challenges' },
            { value: 0, label: 'Very Poor', description: 'Severe difficulties' }
        ];

        return cognitiveQuestions.map((item, index) => `
            <div class="bg-white rounded-md p-4 mb-4">
                <div class="mb-2">
                    <span class="inline-block px-2 py-1 text-xs font-medium bg-indigo-100 text-indigo-700 rounded-full mb-2">${item.category}</span>
                </div>
                <label class="block text-sm font-medium text-gray-700 mb-3">${index + 1}. ${item.question}</label>
                <div class="grid grid-cols-1 md:grid-cols-5 gap-2">
                    ${ratingOptions.map(option => `
                        <label class="flex flex-col items-center p-3 rounded border cursor-pointer hover:bg-gray-50 text-center">
                            <input type="radio" name="${item.id}" value="${option.value}" class="mb-2">
                            <span class="text-sm font-medium">${option.label}</span>
                            <span class="text-xs text-gray-500">(${option.value})</span>
                            <span class="text-xs text-gray-400 mt-1">${option.description}</span>
                        </label>
                    `).join('')}
                </div>
            </div>
        `).join('');
    }

    renderStressResilienceAssessment() {
        const stressQuestions = [
            {
                id: 'stress_management',
                question: 'How well do you manage daily stress and pressure?',
                category: 'Stress Management'
            },
            {
                id: 'emotional_regulation',
                question: 'How effectively can you control your emotions during difficult situations?',
                category: 'Emotional Control'
            },
            {
                id: 'resilience_bounce_back',
                question: 'How quickly do you recover from setbacks, disappointments, or stressful events?',
                category: 'Resilience'
            },
            {
                id: 'adaptability',
                question: 'How well do you adapt to unexpected changes or new situations?',
                category: 'Adaptability'
            },
            {
                id: 'coping_strategies',
                question: 'How effective are your coping strategies when dealing with life challenges?',
                category: 'Coping Skills'
            }
        ];

        const stressRatingOptions = [
            { value: 4, label: 'Very Well', description: 'Consistently effective' },
            { value: 3, label: 'Well', description: 'Usually effective' },
            { value: 2, label: 'Moderately', description: 'Sometimes effective' },
            { value: 1, label: 'Poorly', description: 'Often ineffective' },
            { value: 0, label: 'Very Poorly', description: 'Consistently ineffective' }
        ];

        return stressQuestions.map((item, index) => `
            <div class="bg-white rounded-md p-4 mb-4">
                <div class="mb-2">
                    <span class="inline-block px-2 py-1 text-xs font-medium bg-teal-100 text-teal-700 rounded-full mb-2">${item.category}</span>
                </div>
                <label class="block text-sm font-medium text-gray-700 mb-3">${index + 1}. ${item.question}</label>
                <div class="grid grid-cols-1 md:grid-cols-5 gap-2">
                    ${stressRatingOptions.map(option => `
                        <label class="flex flex-col items-center p-3 rounded border cursor-pointer hover:bg-gray-50 text-center">
                            <input type="radio" name="${item.id}" value="${option.value}" class="mb-2">
                            <span class="text-sm font-medium">${option.label}</span>
                            <span class="text-xs text-gray-500">(${option.value})</span>
                            <span class="text-xs text-gray-400 mt-1">${option.description}</span>
                        </label>
                    `).join('')}
                </div>
            </div>
        `).join('');
    }

    renderMentalHealthProtectiveFactors() {
        return `
            <div class="space-y-6">
                <!-- Social Support -->
                <div class="bg-white rounded-md p-4">
                    <label class="block text-sm font-medium text-gray-700 mb-3">
                        <i class="fas fa-users mr-2 text-orange-600"></i>Social Support System
                    </label>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-medium text-gray-600 mb-2">Quality of close relationships</label>
                            <select name="social_support_quality" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                                <option value="">Select...</option>
                                <option value="4">Excellent - Very strong, supportive relationships</option>
                                <option value="3">Good - Generally supportive relationships</option>
                                <option value="2">Fair - Some supportive relationships</option>
                                <option value="1">Poor - Limited supportive relationships</option>
                                <option value="0">Very Poor - Isolated, no support</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-xs font-medium text-gray-600 mb-2">Social network size</label>
                            <select name="social_network_size" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                                <option value="">Select...</option>
                                <option value="4">Large - Many meaningful connections (10+)</option>
                                <option value="3">Medium - Several close connections (5-9)</option>
                                <option value="2">Small - Few close connections (3-4)</option>
                                <option value="1">Very Small - Very few connections (1-2)</option>
                                <option value="0">Isolated - No meaningful connections</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Cognitive Engagement -->
                <div class="bg-white rounded-md p-4">
                    <label class="block text-sm font-medium text-gray-700 mb-3">
                        <i class="fas fa-book mr-2 text-orange-600"></i>Cognitive Engagement & Learning
                    </label>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-medium text-gray-600 mb-2">Mental stimulation activities (reading, puzzles, learning)</label>
                            <select name="mental_stimulation" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                                <option value="">Select...</option>
                                <option value="4">Daily - Regular challenging mental activities</option>
                                <option value="3">Often - 4-6 times per week</option>
                                <option value="2">Sometimes - 2-3 times per week</option>
                                <option value="1">Rarely - Once per week or less</option>
                                <option value="0">Never - No regular mental stimulation</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-xs font-medium text-gray-600 mb-2">Creative activities (art, music, writing)</label>
                            <select name="creative_activities" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                                <option value="">Select...</option>
                                <option value="4">Daily - Regular creative engagement</option>
                                <option value="3">Often - Several times per week</option>
                                <option value="2">Sometimes - Weekly creative activities</option>
                                <option value="1">Rarely - Occasional creative activities</option>
                                <option value="0">Never - No creative activities</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Physical Activity & Mental Health -->
                <div class="bg-white rounded-md p-4">
                    <label class="block text-sm font-medium text-gray-700 mb-3">
                        <i class="fas fa-running mr-2 text-orange-600"></i>Physical Activity Impact on Mental Health
                    </label>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-medium text-gray-600 mb-2">Exercise frequency for mental health</label>
                            <select name="exercise_mental_health" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                                <option value="">Select...</option>
                                <option value="4">Daily - Regular exercise routine</option>
                                <option value="3">Often - 4-6 times per week</option>
                                <option value="2">Sometimes - 2-3 times per week</option>
                                <option value="1">Rarely - Once per week or less</option>
                                <option value="0">Never - No regular exercise</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-xs font-medium text-gray-600 mb-2">Mindfulness/meditation practice</label>
                            <select name="mindfulness_practice" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                                <option value="">Select...</option>
                                <option value="4">Daily - Regular practice (20+ min)</option>
                                <option value="3">Often - Several times per week</option>
                                <option value="2">Sometimes - Weekly practice</option>
                                <option value="1">Rarely - Occasional practice</option>
                                <option value="0">Never - No mindfulness practice</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Life Purpose & Meaning -->
                <div class="bg-white rounded-md p-4">
                    <label class="block text-sm font-medium text-gray-700 mb-3">
                        <i class="fas fa-compass mr-2 text-orange-600"></i>Purpose & Meaning in Life
                    </label>
                    <div class="space-y-3">
                        <div>
                            <label class="block text-xs font-medium text-gray-600 mb-2">Sense of life purpose and direction</label>
                            <select name="life_purpose" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                                <option value="">Select...</option>
                                <option value="4">Very Strong - Clear purpose and direction</option>
                                <option value="3">Strong - Generally clear about purpose</option>
                                <option value="2">Moderate - Some sense of purpose</option>
                                <option value="1">Weak - Unclear about life direction</option>
                                <option value="0">Very Weak - No clear purpose or meaning</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    renderStep4_Lifestyle() {
        return `
            <div class="space-y-8">
                <div class="text-center mb-6">
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Detailed Lifestyle Assessment</h3>
                    <p class="text-gray-600">Comprehensive evaluation of nutrition, exercise, sleep, and stress management</p>
                </div>

                ${this.renderLifestyleSections()}
            </div>
        `;
    }

    renderLifestyleSections() {
        // This would be a very long implementation
        // For now, I'll create a structure and key questions
        return `
            <!-- Comprehensive Nutrition Assessment -->
            <div class="bg-green-50 rounded-lg p-6">
                <h4 class="text-lg font-semibold text-green-800 mb-4">Comprehensive Nutrition Assessment</h4>
                
                <!-- Macronutrients -->
                <div class="grid md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">How many servings of vegetables do you eat daily?</label>
                        <select name="vegetableServings" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="0-1">0-1 servings</option>
                            <option value="2-3">2-3 servings</option>
                            <option value="4-5">4-5 servings</option>
                            <option value="6+">6+ servings</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">How many servings of fruits do you eat daily?</label>
                        <select name="fruitServings" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="0">0 servings</option>
                            <option value="1">1 serving</option>
                            <option value="2-3">2-3 servings</option>
                            <option value="4+">4+ servings</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">How often do you eat whole grains (brown rice, quinoa, oats)?</label>
                        <select name="wholeGrains" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="never">Never</option>
                            <option value="rarely">Rarely (once/week)</option>
                            <option value="sometimes">Sometimes (2-3 times/week)</option>
                            <option value="daily">Daily</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">What is your primary protein source?</label>
                        <select name="proteinSource" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="animal">Animal proteins (meat, fish, dairy)</option>
                            <option value="plant">Plant proteins (legumes, nuts, seeds)</option>
                            <option value="mixed">Mixed (both animal and plant)</option>
                            <option value="minimal">Minimal protein intake</option>
                        </select>
                    </div>
                </div>

                <!-- Dietary Patterns -->
                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-3">What dietary pattern best describes your eating habits?</label>
                    <div class="grid md:grid-cols-2 gap-2">
                        <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                            <input type="radio" name="dietaryPattern" value="standard" class="mr-2">
                            <span class="text-sm">Standard Western Diet</span>
                        </label>
                        <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                            <input type="radio" name="dietaryPattern" value="mediterranean" class="mr-2">
                            <span class="text-sm">Mediterranean Diet</span>
                        </label>
                        <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                            <input type="radio" name="dietaryPattern" value="vegetarian" class="mr-2">
                            <span class="text-sm">Vegetarian</span>
                        </label>
                        <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                            <input type="radio" name="dietaryPattern" value="vegan" class="mr-2">
                            <span class="text-sm">Vegan</span>
                        </label>
                        <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                            <input type="radio" name="dietaryPattern" value="paleo" class="mr-2">
                            <span class="text-sm">Paleo</span>
                        </label>
                        <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                            <input type="radio" name="dietaryPattern" value="keto" class="mr-2">
                            <span class="text-sm">Ketogenic</span>
                        </label>
                        <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                            <input type="radio" name="dietaryPattern" value="intermittent" class="mr-2">
                            <span class="text-sm">Intermittent Fasting</span>
                        </label>
                        <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                            <input type="radio" name="dietaryPattern" value="other" class="mr-2">
                            <span class="text-sm">Other/Custom</span>
                        </label>
                    </div>
                </div>

                <!-- Food Quality & Processing -->
                <div class="grid md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">How often do you eat processed foods?</label>
                        <select name="processedFoods" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="never">Never</option>
                            <option value="rarely">Rarely (once/week)</option>
                            <option value="sometimes">Sometimes (2-3 times/week)</option>
                            <option value="often">Often (daily)</option>
                            <option value="mostly">Mostly processed foods</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">What percentage of your food is organic?</label>
                        <select name="organicPercentage" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="0">0%</option>
                            <option value="1-25">1-25%</option>
                            <option value="26-50">26-50%</option>
                            <option value="51-75">51-75%</option>
                            <option value="76-100">76-100%</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">How many glasses of water do you drink daily?</label>
                        <select name="waterIntake" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="1-3">1-3 glasses</option>
                            <option value="4-6">4-6 glasses</option>
                            <option value="7-8">7-8 glasses</option>
                            <option value="9+">9+ glasses</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">How often do you consume sugary drinks or alcohol?</label>
                        <select name="sugarAlcohol" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="never">Never</option>
                            <option value="rarely">Rarely (once/week)</option>
                            <option value="sometimes">Sometimes (2-3 times/week)</option>
                            <option value="daily">Daily</option>
                            <option value="multiple">Multiple times daily</option>
                        </select>
                    </div>
                </div>

                <!-- Eating Behaviors -->
                <div class="grid md:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">How many meals do you typically eat per day?</label>
                        <select name="mealsPerDay" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="1">1 meal</option>
                            <option value="2">2 meals</option>
                            <option value="3">3 meals</option>
                            <option value="4+">4+ meals</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Do you take nutritional supplements?</label>
                        <select name="supplements" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="none">No supplements</option>
                            <option value="basic">Basic vitamins/minerals</option>
                            <option value="targeted">Targeted supplements</option>
                            <option value="comprehensive">Comprehensive regimen</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Exercise Assessment -->
            <div class="bg-blue-50 rounded-lg p-6">
                <h4 class="text-lg font-semibold text-blue-800 mb-4">Physical Activity</h4>
                <div class="grid md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">How many days per week do you exercise?</label>
                        <select name="exerciseFrequency" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="0">0 days</option>
                            <option value="1-2">1-2 days</option>
                            <option value="3-4">3-4 days</option>
                            <option value="5+">5+ days</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Average minutes of exercise per day (when you exercise)</label>
                        <select name="exerciseMinutes" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="0">0 minutes</option>
                            <option value="1-15">1-15 minutes</option>
                            <option value="16-30">16-30 minutes</option>
                            <option value="31-45">31-45 minutes</option>
                            <option value="46-60">46-60 minutes</option>
                            <option value="61-90">61-90 minutes</option>
                            <option value="90+">More than 90 minutes</option>
                        </select>
                    </div>
                </div>
                
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-3">What types of exercise do you regularly do? (Select all that apply)</label>
                    <div class="grid md:grid-cols-2 gap-4">
                        <div class="space-y-2">
                            <label class="flex items-center">
                                <input type="checkbox" name="exerciseTypes" value="cardio" class="mr-2">
                                <span class="text-sm">Cardio/Aerobic</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" name="exerciseTypes" value="strength" class="mr-2">
                                <span class="text-sm">Strength Training</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" name="exerciseTypes" value="flexibility" class="mr-2">
                                <span class="text-sm">Flexibility/Yoga</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" name="exerciseTypes" value="walking" class="mr-2">
                                <span class="text-sm">Walking</span>
                            </label>
                        </div>
                        <div class="space-y-2">
                            <label class="flex items-center">
                                <input type="checkbox" name="exerciseTypes" value="swimming" class="mr-2">
                                <span class="text-sm">Swimming</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" name="exerciseTypes" value="cycling" class="mr-2">
                                <span class="text-sm">Cycling</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" name="exerciseTypes" value="sports" class="mr-2">
                                <span class="text-sm">Sports</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" name="exerciseTypes" value="other" class="mr-2" onchange="toggleOtherExercise(this)">
                                <span class="text-sm">Other</span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Other exercise type text input (hidden by default) -->
                    <div id="otherExerciseContainer" class="mt-3" style="display: none;">
                        <label class="block text-sm font-medium text-gray-700 mb-2">Please specify other exercise types:</label>
                        <input type="text" name="exerciseTypesOther" placeholder="e.g., Pilates, martial arts, dance..." 
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                </div>
            </div>

            <!-- Sleep Assessment -->
            <div class="bg-purple-50 rounded-lg p-6">
                <h4 class="text-lg font-semibold text-purple-800 mb-4">Sleep Quality</h4>
                <div class="grid md:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Average hours of sleep per night</label>
                        <select name="sleepHours" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="<5">Less than 5 hours</option>
                            <option value="5-6">5-6 hours</option>
                            <option value="7-8">7-8 hours</option>
                            <option value="9+">9+ hours</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">How would you rate your sleep quality?</label>
                        <select name="sleepQuality" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="poor">Poor</option>
                            <option value="fair">Fair</option>
                            <option value="good">Good</option>
                            <option value="excellent">Excellent</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Stress Management -->
            <div class="bg-red-50 rounded-lg p-6">
                <h4 class="text-lg font-semibold text-red-800 mb-4">Stress Management</h4>
                <div class="grid md:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">How would you rate your current stress level?</label>
                        <select name="stressLevel" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            <option value="">Select...</option>
                            <option value="1">Very Low (1)</option>
                            <option value="2">Low (2)</option>
                            <option value="3">Moderate (3)</option>
                            <option value="4">High (4)</option>
                            <option value="5">Very High (5)</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Do you practice stress management techniques?</label>
                        <div class="space-y-2">
                            <label class="flex items-center">
                                <input type="checkbox" name="stressTechniques" value="meditation" class="mr-2">
                                <span class="text-sm">Meditation/Mindfulness</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" name="stressTechniques" value="exercise" class="mr-2">
                                <span class="text-sm">Exercise</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" name="stressTechniques" value="social" class="mr-2">
                                <span class="text-sm">Social Support</span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    renderStep5_Environmental() {
        return `
            <div class="space-y-8">
                <div class="text-center mb-6">
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Environmental & Social Factors</h3>
                    <p class="text-gray-600">Assessment of environmental exposures and social connections</p>
                </div>

                <!-- Environmental Toxin Assessment -->
                <div class="bg-yellow-50 rounded-lg p-6">
                    <h4 class="text-lg font-semibold text-yellow-800 mb-4">Environmental Toxin Exposure Assessment</h4>
                    
                    <!-- Water Quality -->
                    <div class="mb-6">
                        <h5 class="text-md font-semibold text-yellow-700 mb-3">Water Quality & Exposure</h5>
                        <div class="grid md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Do you filter your drinking water?</label>
                                <select name="waterFiltered" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                    <option value="">Select...</option>
                                    <option value="yes-reverse-osmosis">Yes, reverse osmosis</option>
                                    <option value="yes-carbon">Yes, carbon filter</option>
                                    <option value="yes-basic">Yes, basic filtration</option>
                                    <option value="sometimes">Sometimes</option>
                                    <option value="no">No filtration</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">What is your primary water source?</label>
                                <select name="waterSource" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                    <option value="">Select...</option>
                                    <option value="municipal">Municipal/tap water</option>
                                    <option value="well">Private well water</option>
                                    <option value="bottled">Bottled water</option>
                                    <option value="spring">Natural spring water</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Air Quality & Chemical Exposures -->
                    <div class="mb-6">
                        <h5 class="text-md font-semibold text-yellow-700 mb-3">Air Quality & Chemical Exposures</h5>
                        <div class="grid md:grid-cols-2 gap-4 mb-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">How would you rate the air quality where you live?</label>
                                <select name="airQuality" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                    <option value="">Select...</option>
                                    <option value="excellent">Excellent (rural/clean)</option>
                                    <option value="good">Good (suburban)</option>
                                    <option value="fair">Fair (some pollution)</option>
                                    <option value="poor">Poor (urban/industrial)</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Do you use air purifiers in your home?</label>
                                <select name="airPurifiers" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                    <option value="">Select...</option>
                                    <option value="yes-hepa">Yes, HEPA filtration</option>
                                    <option value="yes-basic">Yes, basic filtration</option>
                                    <option value="no">No air purification</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">How often are you exposed to household cleaning chemicals?</label>
                                <select name="cleaningChemicals" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                    <option value="">Select...</option>
                                    <option value="daily">Daily exposure</option>
                                    <option value="weekly">Weekly exposure</option>
                                    <option value="monthly">Monthly exposure</option>
                                    <option value="natural-only">Use only natural products</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Do you use personal care products with synthetic fragrances?</label>
                                <select name="syntheticFragrances" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                    <option value="">Select...</option>
                                    <option value="daily">Daily use</option>
                                    <option value="occasionally">Occasionally</option>
                                    <option value="rarely">Rarely</option>
                                    <option value="fragrance-free">Use fragrance-free products</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Occupational & Environmental Exposures -->
                    <div class="mb-6">
                        <h5 class="text-md font-semibold text-yellow-700 mb-3">Occupational & Environmental Exposures</h5>
                        <div class="grid md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Are you exposed to chemicals, solvents, or toxins at work?</label>
                                <select name="occupationalExposure" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                    <option value="">Select...</option>
                                    <option value="yes-high">Yes, high exposure</option>
                                    <option value="yes-moderate">Yes, moderate exposure</option>
                                    <option value="yes-minimal">Yes, minimal exposure</option>
                                    <option value="no">No occupational exposure</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">How often do you use plastic containers for food storage/heating?</label>
                                <select name="plasticExposure" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                    <option value="">Select...</option>
                                    <option value="daily">Daily use</option>
                                    <option value="weekly">Weekly use</option>
                                    <option value="rarely">Rarely use</option>
                                    <option value="avoid">Actively avoid plastic</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Do you live near highways, industrial areas, or airports?</label>
                                <select name="pollutionProximity" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                    <option value="">Select...</option>
                                    <option value="very-close">Very close (< 0.5 miles)</option>
                                    <option value="close">Close (0.5-2 miles)</option>
                                    <option value="moderate">Moderate distance (2-5 miles)</option>
                                    <option value="far">Far from pollution sources</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">How often do you consume conventionally grown (non-organic) produce?</label>
                                <select name="pesticideExposure" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                    <option value="">Select...</option>
                                    <option value="daily">Daily consumption</option>
                                    <option value="often">Often (4-6 times/week)</option>
                                    <option value="sometimes">Sometimes (2-3 times/week)</option>
                                    <option value="organic-only">Eat only organic produce</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- EMF & Technology Exposure -->
                    <div>
                        <h5 class="text-md font-semibold text-yellow-700 mb-3">EMF & Technology Exposure</h5>
                        <div class="grid md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">How many hours per day do you use electronic devices (phone, computer, etc.)?</label>
                                <select name="screenTime" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                    <option value="">Select...</option>
                                    <option value="1-3">1-3 hours</option>
                                    <option value="4-6">4-6 hours</option>
                                    <option value="7-10">7-10 hours</option>
                                    <option value="10+">More than 10 hours</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Do you use EMF protection or limit wireless device exposure?</label>
                                <select name="emfProtection" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                    <option value="">Select...</option>
                                    <option value="yes-active">Yes, active EMF protection</option>
                                    <option value="yes-limited">Yes, limit wireless use</option>
                                    <option value="aware">Aware but no specific measures</option>
                                    <option value="no">No EMF considerations</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Social Connections -->
                <div class="bg-pink-50 rounded-lg p-6">
                    <h4 class="text-lg font-semibold text-pink-800 mb-4">Social Connections</h4>
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">How satisfied are you with your social relationships?</label>
                            <select name="socialSatisfaction" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                <option value="">Select...</option>
                                <option value="very-satisfied">Very Satisfied</option>
                                <option value="satisfied">Satisfied</option>
                                <option value="neutral">Neutral</option>
                                <option value="dissatisfied">Dissatisfied</option>
                                <option value="very-dissatisfied">Very Dissatisfied</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">How often do you spend time in nature?</label>
                            <select name="natureTime" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                <option value="">Select...</option>
                                <option value="daily">Daily</option>
                                <option value="weekly">Weekly</option>
                                <option value="monthly">Monthly</option>
                                <option value="rarely">Rarely</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    renderStep6_RootCause() {
        return `
            <div class="space-y-8">
                <div class="text-center mb-6">
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Root Cause Analysis (ATM Framework)</h3>
                    <p class="text-gray-600">Understanding the underlying factors contributing to your current health status</p>
                </div>

                <!-- Antecedents -->
                <div class="bg-blue-50 rounded-lg p-6">
                    <div class="flex justify-between items-center mb-4">
                        <h4 class="text-lg font-semibold text-blue-800">Antecedents (Predisposing Factors)</h4>
                        <button type="button" onclick="addATMEntry('antecedents')" class="bg-blue-600 text-white px-3 py-1 rounded text-sm hover:bg-blue-700">
                            <i class="fas fa-plus mr-1"></i>Add Another
                        </button>
                    </div>
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Did you experience significant stress or trauma in early life?</label>
                            <select name="earlyStress" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                <option value="">Select...</option>
                                <option value="yes-significant">Yes, significant</option>
                                <option value="yes-moderate">Yes, moderate</option>
                                <option value="minimal">Minimal</option>
                                <option value="no">No</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Do you have known genetic predispositions to health conditions?</label>
                            <textarea name="geneticPredispositions" rows="3" placeholder="Describe any known genetic factors or strong family history" class="w-full px-3 py-2 border border-gray-300 rounded-md"></textarea>
                        </div>
                        
                        <!-- Dynamic Antecedents Entries -->
                        <div id="antecedentsContainer" class="space-y-3">
                            <div class="bg-white p-4 rounded border">
                                <div class="flex justify-between items-start mb-2">
                                    <label class="block text-sm font-medium text-gray-700">Additional Antecedent Factor</label>
                                    <button type="button" onclick="removeATMEntry(this)" class="text-red-500 hover:text-red-700 text-sm">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                                <div class="grid md:grid-cols-4 gap-3">
                                    <div class="md:col-span-2">
                                        <textarea name="antecedentsDescription[]" rows="2" placeholder="Describe the predisposing factor..." class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"></textarea>
                                    </div>
                                    <div>
                                        <label class="block text-xs text-gray-500 mb-1">Date (MM/YY)</label>
                                        <input type="text" name="antecedentsDate[]" placeholder="MM/YY" maxlength="5" pattern="[0-9]{2}/[0-9]{2}" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                                    </div>
                                    <div>
                                        <label class="block text-xs text-gray-500 mb-1">Severity</label>
                                        <select name="antecedentsSeverity[]" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                                            <option value="">Select...</option>
                                            <option value="mild">Mild</option>
                                            <option value="moderate">Moderate</option>
                                            <option value="severe">Severe</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Triggers -->
                <div class="bg-red-50 rounded-lg p-6">
                    <div class="flex justify-between items-center mb-4">
                        <h4 class="text-lg font-semibold text-red-800">Triggers (Initiating Events)</h4>
                        <button type="button" onclick="addATMEntry('triggers')" class="bg-red-600 text-white px-3 py-1 rounded text-sm hover:bg-red-700">
                            <i class="fas fa-plus mr-1"></i>Add Another
                        </button>
                    </div>
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">When did you first notice your current health concerns?</label>
                            <input type="text" name="symptomOnset" placeholder="Approximate timeframe or triggering event" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                        </div>
                        
                        <!-- Dynamic Triggers Entries -->
                        <div id="triggersContainer" class="space-y-3">
                            <div class="bg-white p-4 rounded border">
                                <div class="flex justify-between items-start mb-2">
                                    <label class="block text-sm font-medium text-gray-700">Specific Trigger Event</label>
                                    <button type="button" onclick="removeATMEntry(this)" class="text-red-500 hover:text-red-700 text-sm">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                                <div class="grid md:grid-cols-4 gap-3">
                                    <div class="md:col-span-2">
                                        <textarea name="triggersDescription[]" rows="2" placeholder="e.g., Job loss, divorce, death of loved one, major illness..." class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"></textarea>
                                    </div>
                                    <div>
                                        <label class="block text-xs text-gray-500 mb-1">Date (MM/YY)</label>
                                        <input type="text" name="triggersDate[]" placeholder="MM/YY" maxlength="5" pattern="[0-9]{2}/[0-9]{2}" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                                    </div>
                                    <div>
                                        <label class="block text-xs text-gray-500 mb-1">Impact</label>
                                        <select name="triggersImpact[]" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                                            <option value="">Select...</option>
                                            <option value="low">Low Impact</option>
                                            <option value="moderate">Moderate Impact</option>
                                            <option value="high">High Impact</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Mediators -->
                <div class="bg-green-50 rounded-lg p-6">
                    <div class="flex justify-between items-center mb-4">
                        <h4 class="text-lg font-semibold text-green-800">Mediators/Perpetuators (Ongoing Factors)</h4>
                        <button type="button" onclick="addATMEntry('mediators')" class="bg-green-600 text-white px-3 py-1 rounded text-sm hover:bg-green-700">
                            <i class="fas fa-plus mr-1"></i>Add Another
                        </button>
                    </div>
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">What barriers prevent you from optimal health?</label>
                            <textarea name="healthBarriers" rows="3" placeholder="Time constraints, financial limitations, lack of knowledge, etc." class="w-full px-3 py-2 border border-gray-300 rounded-md"></textarea>
                        </div>
                        
                        <!-- Dynamic Mediators Entries -->
                        <div id="mediatorsContainer" class="space-y-3">
                            <div class="bg-white p-4 rounded border">
                                <div class="flex justify-between items-start mb-2">
                                    <label class="block text-sm font-medium text-gray-700">Ongoing Perpetuating Factor</label>
                                    <button type="button" onclick="removeATMEntry(this)" class="text-red-500 hover:text-red-700 text-sm">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                                <div class="grid md:grid-cols-4 gap-3">
                                    <div class="md:col-span-2">
                                        <textarea name="mediatorsDescription[]" rows="2" placeholder="e.g., Chronic stress, poor sleep, environmental exposures..." class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"></textarea>
                                    </div>
                                    <div>
                                        <label class="block text-xs text-gray-500 mb-1">Started (MM/YY)</label>
                                        <input type="text" name="mediatorsDate[]" placeholder="MM/YY" maxlength="5" pattern="[0-9]{2}/[0-9]{2}" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                                    </div>
                                    <div>
                                        <label class="block text-xs text-gray-500 mb-1">Frequency</label>
                                        <select name="mediatorsFrequency[]" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                                            <option value="">Select...</option>
                                            <option value="always">Always (Daily)</option>
                                            <option value="often">Often (Several times/week)</option>
                                            <option value="sometimes">Sometimes (Occasionally)</option>
                                            <option value="rarely">Rarely (Infrequent)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    renderStep7_MedicalHistory() {
        return `
            <div class="space-y-8">
                <div class="text-center mb-6">
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Medical & Family History</h3>
                    <p class="text-gray-600">Comprehensive medical background and family health history</p>
                </div>

                <!-- Current Medical Conditions -->
                <div class="bg-red-50 rounded-lg p-6">
                    <h4 class="text-lg font-semibold text-red-800 mb-4">Current Medical Conditions</h4>
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Do you have any current diagnosed medical conditions?</label>
                            <div class="grid md:grid-cols-2 gap-2 mb-3">
                                <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                                    <input type="radio" name="hasCurrentConditions" value="yes" class="mr-2" onchange="toggleMedicalConditions(true)">
                                    <span class="text-sm">Yes</span>
                                </label>
                                <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                                    <input type="radio" name="hasCurrentConditions" value="no" class="mr-2" onchange="toggleMedicalConditions(false)">
                                    <span class="text-sm">No</span>
                                </label>
                            </div>
                        </div>
                        
                        <div id="currentConditionsContainer" style="display: none;">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Please list your current medical conditions and when they were diagnosed:</label>
                            <textarea name="currentConditions" rows="4" placeholder="e.g., Type 2 Diabetes (2015), Hypertension (2018), Hypothyroidism (2020)..." class="w-full px-3 py-2 border border-gray-300 rounded-md"></textarea>
                        </div>
                    </div>
                </div>

                <!-- Past Medical History -->
                <div class="bg-orange-50 rounded-lg p-6">
                    <h4 class="text-lg font-semibold text-orange-800 mb-4">Past Medical History</h4>
                    <div class="grid md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-3">Have you ever had any of the following? (Check all that apply)</label>
                            <div class="space-y-2">
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="heart_disease" class="mr-2">
                                    <span class="text-sm">Heart Disease</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="stroke" class="mr-2">
                                    <span class="text-sm">Stroke</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="cancer" class="mr-2">
                                    <span class="text-sm">Cancer</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="diabetes" class="mr-2">
                                    <span class="text-sm">Diabetes</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="hypertension" class="mr-2">
                                    <span class="text-sm">High Blood Pressure</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="high_cholesterol" class="mr-2">
                                    <span class="text-sm">High Cholesterol</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="kidney_disease" class="mr-2">
                                    <span class="text-sm">Kidney Disease</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="liver_disease" class="mr-2">
                                    <span class="text-sm">Liver Disease</span>
                                </label>
                            </div>
                        </div>
                        <div>
                            <div class="space-y-2 mt-6">
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="thyroid_disease" class="mr-2">
                                    <span class="text-sm">Thyroid Disease</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="autoimmune_disease" class="mr-2">
                                    <span class="text-sm">Autoimmune Disease</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="mental_health" class="mr-2">
                                    <span class="text-sm">Mental Health Conditions</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="allergies" class="mr-2">
                                    <span class="text-sm">Severe Allergies</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="surgeries" class="mr-2">
                                    <span class="text-sm">Major Surgeries</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="hospitalizations" class="mr-2">
                                    <span class="text-sm">Hospitalizations</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="checkbox" name="pastConditions" value="other" class="mr-2">
                                    <span class="text-sm">Other Significant Conditions</span>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="mt-4">
                        <label class="block text-sm font-medium text-gray-700 mb-2">Please provide details for any conditions checked above (including dates):</label>
                        <textarea name="pastConditionsDetails" rows="3" placeholder="Provide details about timing, treatment, outcomes..." class="w-full px-3 py-2 border border-gray-300 rounded-md"></textarea>
                    </div>
                </div>

                <!-- Current Medications -->
                <div class="bg-blue-50 rounded-lg p-6">
                    <h4 class="text-lg font-semibold text-blue-800 mb-4">Current Medications & Supplements</h4>
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Are you currently taking any medications?</label>
                            <div class="grid md:grid-cols-2 gap-2 mb-3">
                                <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                                    <input type="radio" name="takingMedications" value="yes" class="mr-2" onchange="toggleMedicationsSection(true)">
                                    <span class="text-sm">Yes</span>
                                </label>
                                <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                                    <input type="radio" name="takingMedications" value="no" class="mr-2" onchange="toggleMedicationsSection(false)">
                                    <span class="text-sm">No</span>
                                </label>
                            </div>
                        </div>
                        
                        <div id="medicationsContainer" style="display: none;">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Please list all current medications (name, dose, frequency, reason):</label>
                            <textarea name="currentMedications" rows="4" placeholder="e.g., Metformin 500mg twice daily for diabetes, Lisinopril 10mg daily for blood pressure..." class="w-full px-3 py-2 border border-gray-300 rounded-md"></textarea>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Are you taking any vitamins, supplements, or herbal products?</label>
                            <div class="grid md:grid-cols-2 gap-2 mb-3">
                                <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                                    <input type="radio" name="takingSupplements" value="yes" class="mr-2" onchange="toggleSupplementsSection(true)">
                                    <span class="text-sm">Yes</span>
                                </label>
                                <label class="flex items-center p-2 border rounded hover:bg-gray-50">
                                    <input type="radio" name="takingSupplements" value="no" class="mr-2" onchange="toggleSupplementsSection(false)">
                                    <span class="text-sm">No</span>
                                </label>
                            </div>
                        </div>
                        
                        <div id="supplementsContainer" style="display: none;">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Please list all supplements and dosages:</label>
                            <textarea name="currentSupplements" rows="4" placeholder="e.g., Vitamin D3 2000 IU daily, Fish Oil 1000mg twice daily, Probiotics..." class="w-full px-3 py-2 border border-gray-300 rounded-md"></textarea>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Do you have any known drug allergies or adverse reactions?</label>
                            <textarea name="drugAllergies" rows="2" placeholder="List any medications that cause allergic reactions or side effects..." class="w-full px-3 py-2 border border-gray-300 rounded-md"></textarea>
                        </div>
                    </div>
                </div>

                <!-- Family History -->
                <div class="bg-purple-50 rounded-lg p-6">
                    <h4 class="text-lg font-semibold text-purple-800 mb-4">Family History</h4>
                    <div class="space-y-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-3">Do any of your blood relatives have or have had the following conditions? (Check all that apply)</label>
                            <div class="grid md:grid-cols-3 gap-4">
                                <div class="space-y-2">
                                    <h5 class="text-sm font-semibold text-purple-700">Cardiovascular</h5>
                                    <label class="flex items-center">
                                        <input type="checkbox" name="familyHistory" value="family_heart_disease" class="mr-2">
                                        <span class="text-sm">Heart Disease</span>
                                    </label>
                                    <label class="flex items-center">
                                        <input type="checkbox" name="familyHistory" value="family_stroke" class="mr-2">
                                        <span class="text-sm">Stroke</span>
                                    </label>
                                    <label class="flex items-center">
                                        <input type="checkbox" name="familyHistory" value="family_hypertension" class="mr-2">
                                        <span class="text-sm">High Blood Pressure</span>
                                    </label>
                                    <label class="flex items-center">
                                        <input type="checkbox" name="familyHistory" value="family_high_cholesterol" class="mr-2">
                                        <span class="text-sm">High Cholesterol</span>
                                    </label>
                                </div>
                                <div class="space-y-2">
                                    <h5 class="text-sm font-semibold text-purple-700">Metabolic</h5>
                                    <label class="flex items-center">
                                        <input type="checkbox" name="familyHistory" value="family_diabetes" class="mr-2">
                                        <span class="text-sm">Diabetes</span>
                                    </label>
                                    <label class="flex items-center">
                                        <input type="checkbox" name="familyHistory" value="family_obesity" class="mr-2">
                                        <span class="text-sm">Obesity</span>
                                    </label>
                                    <label class="flex items-center">
                                        <input type="checkbox" name="familyHistory" value="family_thyroid" class="mr-2">
                                        <span class="text-sm">Thyroid Disease</span>
                                    </label>
                                    <label class="flex items-center">
                                        <input type="checkbox" name="familyHistory" value="family_kidney_disease" class="mr-2">
                                        <span class="text-sm">Kidney Disease</span>
                                    </label>
                                </div>
                                <div class="space-y-2">
                                    <h5 class="text-sm font-semibold text-purple-700">Cancer & Other</h5>
                                    <label class="flex items-center">
                                        <input type="checkbox" name="familyHistory" value="family_cancer" class="mr-2">
                                        <span class="text-sm">Cancer (any type)</span>
                                    </label>
                                    <label class="flex items-center">
                                        <input type="checkbox" name="familyHistory" value="family_mental_health" class="mr-2">
                                        <span class="text-sm">Mental Health</span>
                                    </label>
                                    <label class="flex items-center">
                                        <input type="checkbox" name="familyHistory" value="family_autoimmune" class="mr-2">
                                        <span class="text-sm">Autoimmune Disease</span>
                                    </label>
                                    <label class="flex items-center">
                                        <input type="checkbox" name="familyHistory" value="family_alzheimers" class="mr-2">
                                        <span class="text-sm">Alzheimer's/Dementia</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Please provide details about family history (relationship, condition, age at diagnosis/death):</label>
                            <textarea name="familyHistoryDetails" rows="4" placeholder="e.g., Father - Heart attack at age 55, Mother - Breast cancer at age 62, Grandfather (paternal) - Diabetes..." class="w-full px-3 py-2 border border-gray-300 rounded-md"></textarea>
                        </div>

                        <!-- Timeline-Specific Family History Events -->
                        <div class="bg-white border-l-4 border-purple-400 p-4 mt-6">
                            <h5 class="text-md font-semibold text-purple-800 mb-3">
                                <i class="fas fa-timeline mr-2"></i>Timeline Family Events (Optional)
                            </h5>
                            <p class="text-sm text-gray-600 mb-4">Add specific family health events that may be relevant to your health timeline. These will be integrated with your personal health timeline.</p>
                            
                            <div id="familyTimelineEvents">
                                <div class="family-timeline-event border rounded-lg p-4 mb-4">
                                    <div class="grid md:grid-cols-3 gap-4">
                                        <div>
                                            <label class="block text-xs font-medium text-gray-700 mb-1">Family Member</label>
                                            <select name="familyRelation[]" class="w-full px-2 py-1 text-sm border border-gray-300 rounded">
                                                <option value="">Select relationship</option>
                                                <option value="father">Father</option>
                                                <option value="mother">Mother</option>
                                                <option value="brother">Brother</option>
                                                <option value="sister">Sister</option>
                                                <option value="grandfather_paternal">Grandfather (Paternal)</option>
                                                <option value="grandmother_paternal">Grandmother (Paternal)</option>
                                                <option value="grandfather_maternal">Grandfather (Maternal)</option>
                                                <option value="grandmother_maternal">Grandmother (Maternal)</option>
                                                <option value="uncle">Uncle</option>
                                                <option value="aunt">Aunt</option>
                                                <option value="cousin">Cousin</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label class="block text-xs font-medium text-gray-700 mb-1">Your Age When This Occurred</label>
                                            <input type="number" name="familyEventAge[]" min="0" max="100" placeholder="Your age" class="w-full px-2 py-1 text-sm border border-gray-300 rounded">
                                        </div>
                                        <div>
                                            <label class="block text-xs font-medium text-gray-700 mb-1">Their Age at Event</label>
                                            <input type="number" name="familyMemberAge[]" min="0" max="120" placeholder="Their age" class="w-full px-2 py-1 text-sm border border-gray-300 rounded">
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <label class="block text-xs font-medium text-gray-700 mb-1">Health Event Description</label>
                                        <textarea name="familyEventDescription[]" rows="2" placeholder="e.g., Father diagnosed with Type 2 Diabetes, Mother had heart attack..." class="w-full px-2 py-1 text-sm border border-gray-300 rounded"></textarea>
                                    </div>
                                    <div class="mt-2 grid md:grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-xs font-medium text-gray-700 mb-1">Impact on You</label>
                                            <select name="familyEventImpact[]" class="w-full px-2 py-1 text-sm border border-gray-300 rounded">
                                                <option value="">Select impact</option>
                                                <option value="high_concern">High Concern/Stress</option>
                                                <option value="moderate_concern">Moderate Concern</option>
                                                <option value="low_concern">Low Concern</option>
                                                <option value="lifestyle_change">Led to Lifestyle Changes</option>
                                                <option value="screening_increase">Increased Health Screening</option>
                                            </select>
                                        </div>
                                        <div class="flex items-end">
                                            <button type="button" onclick="removeFamilyTimelineEvent(this)" class="text-red-600 hover:text-red-800 text-sm">
                                                <i class="fas fa-trash mr-1"></i>Remove
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <button type="button" onclick="addFamilyTimelineEvent()" class="text-purple-600 hover:text-purple-800 text-sm font-medium">
                                <i class="fas fa-plus mr-1"></i>Add Another Family Event
                            </button>
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Are there any other significant health patterns in your family?</label>
                            <textarea name="familyHealthPatterns" rows="3" placeholder="Any other health conditions, early deaths, or genetic concerns..." class="w-full px-3 py-2 border border-gray-300 rounded-md"></textarea>
                        </div>
                    </div>
                </div>

                <!-- Women's Health (if applicable) -->
                <div class="bg-pink-50 rounded-lg p-6">
                    <h4 class="text-lg font-semibold text-pink-800 mb-4">Women's Health History (if applicable)</h4>
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Age at first menstruation:</label>
                            <input type="number" name="menarcheAge" min="8" max="20" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Are your menstrual cycles regular?</label>
                            <select name="regularCycles" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                <option value="">Select...</option>
                                <option value="yes">Yes, regular</option>
                                <option value="no">No, irregular</option>
                                <option value="postmenopausal">Postmenopausal</option>
                                <option value="not_applicable">Not applicable</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Number of pregnancies and live births:</label>
                            <div class="grid md:grid-cols-2 gap-4">
                                <input type="number" name="pregnancies" min="0" max="20" placeholder="Total pregnancies" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                                <input type="number" name="liveBirths" min="0" max="20" placeholder="Live births" class="w-full px-3 py-2 border border-gray-300 rounded-md">
                            </div>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Are you currently using hormone replacement therapy or hormonal contraception?</label>
                            <textarea name="hormoneUse" rows="2" placeholder="List any hormonal medications or treatments..." class="w-full px-3 py-2 border border-gray-300 rounded-md"></textarea>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    nextStep() {
        if (this.validateCurrentStep()) {
            this.saveFormData();
            if (this.currentStep < this.totalSteps) {
                this.currentStep++;
                this.renderForm();
            }
        }
    }

    prevStep() {
        if (this.currentStep > 1) {
            this.currentStep--;
            this.renderForm();
        }
    }

    validateCurrentStep() {
        console.log('🔍 Validating current step:', this.currentStep);
        
        const form = document.getElementById('comprehensive-assessment-form');
        if (!form) {
            console.error('❌ Form not found!');
            return false;
        }

        // Check required fields for current step
        const requiredFields = form.querySelectorAll('input[required], select[required]');
        let isValid = true;
        let invalidFields = [];

        requiredFields.forEach(field => {
            if (!field.value.trim()) {
                field.classList.add('border-red-500');
                invalidFields.push(field.name || field.id || 'unnamed field');
                isValid = false;
            } else {
                field.classList.remove('border-red-500');
            }
        });

        if (invalidFields.length > 0) {
            console.warn('⚠️ Invalid required fields:', invalidFields);
        } else {
            console.log('✅ All required fields are valid');
        }

        // Enhanced validation for Step 1 (Demographics with biomarkers)
        if (this.currentStep === 1) {
            console.log('🧬 Validating biomarkers for step 1...');
            const biomarkerValidation = this.validateBiomarkerStep();
            
            // Show validation summary
            this.showBiomarkerValidationSummary(biomarkerValidation);
            
            // Block progression if there are critical errors
            if (!biomarkerValidation.isValid) {
                console.warn('⚠️ Biomarker validation failed:', biomarkerValidation.errors);
                // Scroll to first error
                const firstError = document.querySelector('.biomarker-input.border-red-500');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    firstError.focus();
                }
                
                // Enhanced error message
                this.showEnhancedErrorMessage(
                    'Biomarker Validation Issues',
                    'Please correct the highlighted biomarker values before proceeding. Invalid values could affect the accuracy of your health assessment.',
                    biomarkerValidation.errors
                );
                
                isValid = false;
            }
            // Allow progression with warnings but show confirmation
            else if (biomarkerValidation.warnings.length > 0) {
                const proceedWithWarnings = this.showWarningConfirmation(biomarkerValidation.warnings);
                
                if (!proceedWithWarnings) {
                    isValid = false;
                }
            }
        }

        // Show generic error for required fields
        if (!isValid && requiredFields.some(field => !field.value.trim())) {
            this.showEnhancedErrorMessage(
                'Required Fields Missing',
                'Please fill in all required fields marked with an asterisk (*) before proceeding.',
                []
            );
        }

        return isValid;
    }

    showEnhancedErrorMessage(title, description, errors = []) {
        // Remove existing error modal
        const existingModal = document.getElementById('enhanced-error-modal');
        if (existingModal) {
            existingModal.remove();
        }

        const modal = document.createElement('div');
        modal.id = 'enhanced-error-modal';
        modal.className = 'fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4';
        modal.innerHTML = `
            <div class="bg-white rounded-lg max-w-md w-full p-6">
                <div class="flex items-center mb-4">
                    <div class="flex-shrink-0 w-10 h-10 bg-red-100 rounded-full flex items-center justify-center mr-3">
                        <i class="fas fa-exclamation-triangle text-red-600"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900">${title}</h3>
                </div>
                
                <div class="mb-4">
                    <p class="text-sm text-gray-600">${description}</p>
                </div>
                
                ${errors.length > 0 ? `
                    <div class="mb-4">
                        <h4 class="text-sm font-medium text-gray-700 mb-2">Issues to address:</h4>
                        <ul class="list-disc list-inside space-y-1 text-sm text-gray-600">
                            ${errors.map(error => `<li>${error.label}: ${error.message}</li>`).join('')}
                        </ul>
                    </div>
                ` : ''}
                
                <div class="flex justify-end">
                    <button class="close-error-modal bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition duration-300">
                        <i class="fas fa-check mr-2"></i>I'll Fix These Issues
                    </button>
                </div>
            </div>
        `;

        document.body.appendChild(modal);

        // Add close functionality
        modal.querySelector('.close-error-modal').addEventListener('click', () => {
            modal.remove();
        });

        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.remove();
            }
        });
    }

    showWarningConfirmation(warnings) {
        // For now, return true to allow progression with warnings
        // In a more advanced implementation, you could show a confirmation dialog
        return true;
    }

    saveFormData() {
        const form = document.getElementById('comprehensive-assessment-form');
        if (!form) return;

        const formData = new FormData(form);
        const data = {};

        // Process form data
        for (let [key, value] of formData.entries()) {
            if (data[key]) {
                // Handle multiple values (checkboxes)
                if (Array.isArray(data[key])) {
                    data[key].push(value);
                } else {
                    data[key] = [data[key], value];
                }
            } else {
                data[key] = value;
            }
        }

        // Merge with existing form data
        this.formData = { ...this.formData, ...data };

        // Save to localStorage for persistence
        localStorage.setItem('comprehensive_assessment_data', JSON.stringify(this.formData));
    }

    async submitAssessment() {
        console.log('🚀 Starting assessment submission...');
        
        // Enhanced validation with logging
        if (!this.validateCurrentStep()) {
            console.error('❌ Form validation failed - current step is invalid');
            alert('Please complete all required fields before submitting.');
            return;
        }
        console.log('✅ Form validation passed');

        this.saveFormData();
        console.log('📋 Form data saved, total fields:', Object.keys(this.formData).length);
        
        // Log key demographic fields for debugging
        const demographics = {
            fullName: this.formData.fullName,
            email: this.formData.email,
            dateOfBirth: this.formData.dateOfBirth,
            gender: this.formData.gender
        };
        console.log('👤 Demographics data:', demographics);

        if (!this.apiBase) {
            console.error('❌ API base URL not available - demo mode detected');
            alert('Assessment submission is not available in demo mode.');
            return;
        }
        console.log('🌐 API base URL:', this.apiBase);

        try {
            console.log('📤 Sending POST request to:', `${this.apiBase}/api/assessment/comprehensive-v3`);
            console.log('📦 Request body keys:', Object.keys(this.formData));
            
            const response = await fetch(`${this.apiBase}/api/assessment/comprehensive-v3`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(this.formData)
            });

            console.log('📨 Response status:', response.status);
            console.log('📨 Response ok:', response.ok);

            const result = await response.json();
            console.log('📄 Response data:', result);

            if (result.success) {
                console.log('🎉 Assessment submitted successfully! Session ID:', result.sessionId);
                // Redirect to report
                window.location.href = `/report?session=${result.sessionId}`;
            } else {
                console.error('❌ API returned error:', result.error);
                console.error('📝 Received data keys:', result.received || 'Not provided');
                alert('Assessment submission failed: ' + (result.error || 'Unknown error'));
            }
        } catch (error) {
            console.error('💥 Network/fetch error:', error);
            console.error('📊 Error details:', {
                name: error.name,
                message: error.message,
                stack: error.stack
            });
            alert('Assessment submission failed. Please check your internet connection and try again.');
        }
    }

    downloadFormPDF() {
        // Show loading indicator
        const button = event.target.closest('button');
        const originalText = button.innerHTML;
        button.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Generating PDF...';
        button.disabled = true;

        try {
            // Make sure all form data is current
            this.saveFormData();

            // Configure jsPDF
            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF('p', 'mm', 'a4');
            
            // PDF styling
            const pageHeight = 295;
            const pageWidth = 210;
            const margin = 20;
            let yPosition = margin;
            const lineHeight = 6;
            const sectionSpacing = 10;

            // Helper function to add text with word wrapping
            const addText = (text, x, y, options = {}) => {
                const maxWidth = options.maxWidth || (pageWidth - 2 * margin);
                const fontSize = options.fontSize || 10;
                const fontStyle = options.fontStyle || 'normal';
                
                pdf.setFontSize(fontSize);
                pdf.setFont('helvetica', fontStyle);
                
                if (text.length * fontSize * 0.35 > maxWidth) {
                    const lines = pdf.splitTextToSize(text, maxWidth);
                    lines.forEach((line, index) => {
                        pdf.text(line, x, y + (index * lineHeight));
                    });
                    return lines.length * lineHeight;
                } else {
                    pdf.text(text, x, y);
                    return lineHeight;
                }
            };

            // Check if we need a new page
            const checkNewPage = () => {
                if (yPosition > pageHeight - margin * 2) {
                    pdf.addPage();
                    yPosition = margin;
                }
            };

            // Title
            addText('Comprehensive Health Assessment Form', margin, yPosition, { fontSize: 16, fontStyle: 'bold' });
            yPosition += lineHeight * 2;
            
            // Date
            const currentDate = new Date().toLocaleDateString();
            addText(`Assessment Date: ${currentDate}`, margin, yPosition, { fontSize: 10 });
            yPosition += lineHeight * 2;

            // Process form data by steps
            const stepTitles = {
                1: 'Demographics & Basic Health Information',
                2: 'Lifestyle Factors & Daily Habits', 
                3: 'Functional Medicine Assessment',
                4: 'Mental Health & Wellbeing',
                5: 'Laboratory Values & Biomarkers',
                6: 'ATM Framework Analysis',
                7: 'Medical & Family History'
            };

            Object.entries(this.formData).forEach(([key, value]) => {
                if (value && key !== 'currentStep') {
                    checkNewPage();
                    
                    // Format the key as a readable label
                    const label = key.replace(/([A-Z])/g, ' $1')
                                    .replace(/^./, str => str.toUpperCase())
                                    .replace(/([a-z])([A-Z])/g, '$1 $2');
                    
                    // Add question/field
                    const usedHeight = addText(`${label}:`, margin, yPosition, { fontSize: 11, fontStyle: 'bold' });
                    yPosition += usedHeight;
                    
                    // Add answer/value
                    let displayValue = value;
                    if (Array.isArray(value)) {
                        displayValue = value.join(', ');
                    } else if (typeof value === 'object') {
                        displayValue = JSON.stringify(value, null, 2);
                    }
                    
                    const answerHeight = addText(String(displayValue), margin + 5, yPosition, { fontSize: 10 });
                    yPosition += answerHeight + 3;
                    
                    checkNewPage();
                }
            });

            // Footer on last page
            checkNewPage();
            yPosition = pageHeight - margin;
            addText('Generated by Longenix Health Assessment System', margin, yPosition, { fontSize: 8, fontStyle: 'italic' });
            addText(`Dr. Graham Player, Ph.D - Professional Healthcare Innovation Consultant`, margin, yPosition - 5, { fontSize: 8, fontStyle: 'italic' });

            // Generate filename
            const patientName = this.formData.fullName || 'Patient';
            const date = new Date().toISOString().split('T')[0];
            const filename = `Health_Assessment_Form_${patientName.replace(/[^a-z0-9]/gi, '_')}_${date}.pdf`;

            // Download PDF
            pdf.save(filename);

        } catch (error) {
            console.error('PDF generation error:', error);
            alert('Error generating PDF. Please make sure you have completed the form and try again.');
        } finally {
            // Reset button
            button.innerHTML = originalText;
            button.disabled = false;
        }
    }
}

// Toggle Other Exercise Input Function (global scope for inline event handlers)
function toggleOtherExercise(checkbox) {
    const container = document.getElementById('otherExerciseContainer');
    const textInput = document.querySelector('input[name="exerciseTypesOther"]');
    
    if (checkbox.checked) {
        container.style.display = 'block';
        textInput.focus();
    } else {
        container.style.display = 'none';
        textInput.value = '';
    }
}

// ATM Framework Functions (global scope for inline event handlers)
function addATMEntry(type) {
    const container = document.getElementById(type + 'Container');
    if (!container) return;
    
    const templates = {
        antecedents: `
            <div class="bg-white p-4 rounded border">
                <div class="flex justify-between items-start mb-2">
                    <label class="block text-sm font-medium text-gray-700">Additional Antecedent Factor</label>
                    <button type="button" onclick="removeATMEntry(this)" class="text-red-500 hover:text-red-700 text-sm">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="grid md:grid-cols-4 gap-3">
                    <div class="md:col-span-2">
                        <textarea name="antecedentsDescription[]" rows="2" placeholder="Describe the predisposing factor..." class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"></textarea>
                    </div>
                    <div>
                        <label class="block text-xs text-gray-500 mb-1">Date (MM/YY)</label>
                        <input type="text" name="antecedentsDate[]" placeholder="MM/YY" maxlength="5" pattern="[0-9]{2}/[0-9]{2}" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                    </div>
                    <div>
                        <label class="block text-xs text-gray-500 mb-1">Severity</label>
                        <select name="antecedentsSeverity[]" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                            <option value="">Select...</option>
                            <option value="mild">Mild</option>
                            <option value="moderate">Moderate</option>
                            <option value="severe">Severe</option>
                        </select>
                    </div>
                </div>
            </div>
        `,
        triggers: `
            <div class="bg-white p-4 rounded border">
                <div class="flex justify-between items-start mb-2">
                    <label class="block text-sm font-medium text-gray-700">Specific Trigger Event</label>
                    <button type="button" onclick="removeATMEntry(this)" class="text-red-500 hover:text-red-700 text-sm">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="grid md:grid-cols-4 gap-3">
                    <div class="md:col-span-2">
                        <textarea name="triggersDescription[]" rows="2" placeholder="e.g., Job loss, divorce, death of loved one, major illness..." class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"></textarea>
                    </div>
                    <div>
                        <label class="block text-xs text-gray-500 mb-1">Date (MM/YY)</label>
                        <input type="text" name="triggersDate[]" placeholder="MM/YY" maxlength="5" pattern="[0-9]{2}/[0-9]{2}" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                    </div>
                    <div>
                        <label class="block text-xs text-gray-500 mb-1">Impact</label>
                        <select name="triggersImpact[]" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                            <option value="">Select...</option>
                            <option value="low">Low Impact</option>
                            <option value="moderate">Moderate Impact</option>
                            <option value="high">High Impact</option>
                        </select>
                    </div>
                </div>
            </div>
        `,
        mediators: `
            <div class="bg-white p-4 rounded border">
                <div class="flex justify-between items-start mb-2">
                    <label class="block text-sm font-medium text-gray-700">Ongoing Perpetuating Factor</label>
                    <button type="button" onclick="removeATMEntry(this)" class="text-red-500 hover:text-red-700 text-sm">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="grid md:grid-cols-4 gap-3">
                    <div class="md:col-span-2">
                        <textarea name="mediatorsDescription[]" rows="2" placeholder="e.g., Chronic stress, poor sleep, environmental exposures..." class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"></textarea>
                    </div>
                    <div>
                        <label class="block text-xs text-gray-500 mb-1">Started (MM/YY)</label>
                        <input type="text" name="mediatorsDate[]" placeholder="MM/YY" maxlength="5" pattern="[0-9]{2}/[0-9]{2}" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                    </div>
                    <div>
                        <label class="block text-xs text-gray-500 mb-1">Frequency</label>
                        <select name="mediatorsFrequency[]" class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm">
                            <option value="">Select...</option>
                            <option value="daily">Daily</option>
                            <option value="weekly">Weekly</option>
                            <option value="monthly">Monthly</option>
                            <option value="occasional">Occasional</option>
                        </select>
                    </div>
                </div>
            </div>
        `
    };
    
    if (templates[type]) {
        const newEntry = document.createElement('div');
        newEntry.innerHTML = templates[type];
        container.appendChild(newEntry.firstElementChild);
        
        // Focus on the first textarea in the new entry
        const textarea = container.lastElementChild.querySelector('textarea');
        if (textarea) textarea.focus();
    }
}

function removeATMEntry(button) {
    // Find the parent container (the individual entry div)
    const entry = button.closest('.bg-white.p-4.rounded.border');
    if (entry) {
        entry.remove();
    }
}

// BMI Calculation Function (global scope for inline event handlers)
function calculateBMI() {
    const heightInput = document.querySelector('input[name="height"]');
    const weightInput = document.querySelector('input[name="weight"]');
    const bmiValueElement = document.getElementById('bmiValue');
    const bmiCategoryElement = document.getElementById('bmiCategory');
    
    if (!heightInput || !weightInput || !bmiValueElement || !bmiCategoryElement) {
        return;
    }
    
    const height = parseFloat(heightInput.value);
    const weight = parseFloat(weightInput.value);
    
    if (!height || !weight || height < 100 || height > 250 || weight < 30 || weight > 300) {
        bmiValueElement.textContent = '--';
        bmiCategoryElement.textContent = 'Enter height & weight';
        return;
    }
    
    // Calculate BMI: weight (kg) / (height (cm) / 100)^2
    const heightInMeters = height / 100;
    const bmi = weight / (heightInMeters * heightInMeters);
    
    // Display BMI value
    bmiValueElement.textContent = bmi.toFixed(1);
    
    // Determine BMI category and color
    let category, colorClass;
    if (bmi < 18.5) {
        category = 'Underweight';
        colorClass = 'text-blue-600';
    } else if (bmi < 25) {
        category = 'Normal Weight';
        colorClass = 'text-green-600';
    } else if (bmi < 30) {
        category = 'Overweight';
        colorClass = 'text-yellow-600';
    } else {
        category = 'Obese';
        colorClass = 'text-red-600';
    }
    
    bmiCategoryElement.textContent = category;
    bmiCategoryElement.className = `text-sm ${colorClass}`;
}

// Medical History Helper Functions (global scope for inline event handlers)
function toggleMedicalConditions(show) {
    const container = document.getElementById('currentConditionsContainer');
    const textarea = document.querySelector('textarea[name="currentConditions"]');
    
    if (container) {
        container.style.display = show ? 'block' : 'none';
        if (show && textarea) {
            textarea.focus();
        } else if (!show && textarea) {
            textarea.value = '';
        }
    }
}

function toggleMedicationsSection(show) {
    const container = document.getElementById('medicationsContainer');
    const textarea = document.querySelector('textarea[name="currentMedications"]');
    
    if (container) {
        container.style.display = show ? 'block' : 'none';
        if (show && textarea) {
            textarea.focus();
        } else if (!show && textarea) {
            textarea.value = '';
        }
    }
}

function toggleSupplementsSection(show) {
    const container = document.getElementById('supplementsContainer');
    const textarea = document.querySelector('textarea[name="currentSupplements"]');
    
    if (container) {
        container.style.display = show ? 'block' : 'none';
        if (show && textarea) {
            textarea.focus();
        } else if (!show && textarea) {
            textarea.value = '';
        }
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    console.log('DOM loaded, checking for containers...');
    
    // Check authentication status for comprehensive assessment
    const savedAuth = sessionStorage.getItem('longenix_auth');
    console.log('Authentication status:', savedAuth ? 'Found' : 'Not found');
    
    if (!savedAuth) {
        console.log('Not authenticated, showing authentication message...');
        const container = document.getElementById('assessmentContainer');
        if (container) {
            container.innerHTML = `
                <div class="text-center p-8 bg-white rounded-lg shadow-lg max-w-2xl mx-auto">
                    <i class="fas fa-lock text-4xl text-red-500 mb-4"></i>
                    <h2 class="text-xl font-semibold text-gray-800 mb-4">Authentication Required</h2>
                    <p class="text-gray-600 mb-6">Please authenticate first from the main page to access the comprehensive assessment.</p>
                    <a href="/" class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors">
                        <i class="fas fa-arrow-left mr-2"></i>Go to Home Page
                    </a>
                </div>
            `;
        }
        return;
    }
    
    console.log('Authenticated, looking for assessmentContainer...');
    const container = document.getElementById('assessmentContainer');
    if (container) {
        console.log('Found assessmentContainer, initializing ComprehensiveAssessment...');
        new ComprehensiveAssessment();
    } else {
        console.error('assessmentContainer not found!');
        document.body.innerHTML += `
            <div class="text-center p-8 text-red-600 bg-white rounded-lg shadow-lg max-w-2xl mx-auto mt-8">
                <i class="fas fa-exclamation-triangle text-4xl mb-4"></i>
                <h2 class="text-xl font-semibold mb-4">Container Error</h2>
                <p>Assessment container not found. Please refresh the page.</p>
                <button onclick="location.reload()" class="mt-4 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                    Refresh Page
                </button>
            </div>
        `;
    }
});

// Family Timeline Event Management Functions
function addFamilyTimelineEvent() {
    const container = document.getElementById('familyTimelineEvents');
    if (!container) return;
    
    const eventCount = container.children.length;
    const newEvent = document.createElement('div');
    newEvent.className = 'family-timeline-event border rounded-lg p-4 mb-4';
    newEvent.innerHTML = `
        <div class="grid md:grid-cols-3 gap-4">
            <div>
                <label class="block text-xs font-medium text-gray-700 mb-1">Family Member</label>
                <select name="familyRelation[]" class="w-full px-2 py-1 text-sm border border-gray-300 rounded">
                    <option value="">Select relationship</option>
                    <option value="father">Father</option>
                    <option value="mother">Mother</option>
                    <option value="brother">Brother</option>
                    <option value="sister">Sister</option>
                    <option value="grandfather_paternal">Grandfather (Paternal)</option>
                    <option value="grandmother_paternal">Grandmother (Paternal)</option>
                    <option value="grandfather_maternal">Grandfather (Maternal)</option>
                    <option value="grandmother_maternal">Grandmother (Maternal)</option>
                    <option value="uncle">Uncle</option>
                    <option value="aunt">Aunt</option>
                    <option value="cousin">Cousin</option>
                </select>
            </div>
            <div>
                <label class="block text-xs font-medium text-gray-700 mb-1">Your Age When This Occurred</label>
                <input type="number" name="familyEventAge[]" min="0" max="100" placeholder="Your age" class="w-full px-2 py-1 text-sm border border-gray-300 rounded">
            </div>
            <div>
                <label class="block text-xs font-medium text-gray-700 mb-1">Their Age at Event</label>
                <input type="number" name="familyMemberAge[]" min="0" max="120" placeholder="Their age" class="w-full px-2 py-1 text-sm border border-gray-300 rounded">
            </div>
        </div>
        <div class="mt-3">
            <label class="block text-xs font-medium text-gray-700 mb-1">Health Event Description</label>
            <textarea name="familyEventDescription[]" rows="2" placeholder="e.g., Father diagnosed with Type 2 Diabetes, Mother had heart attack..." class="w-full px-2 py-1 text-sm border border-gray-300 rounded"></textarea>
        </div>
        <div class="mt-2 grid md:grid-cols-2 gap-4">
            <div>
                <label class="block text-xs font-medium text-gray-700 mb-1">Impact on You</label>
                <select name="familyEventImpact[]" class="w-full px-2 py-1 text-sm border border-gray-300 rounded">
                    <option value="">Select impact</option>
                    <option value="high_concern">High Concern/Stress</option>
                    <option value="moderate_concern">Moderate Concern</option>
                    <option value="low_concern">Low Concern</option>
                    <option value="lifestyle_change">Led to Lifestyle Changes</option>
                    <option value="screening_increase">Increased Health Screening</option>
                </select>
            </div>
            <div class="flex items-end">
                <button type="button" onclick="removeFamilyTimelineEvent(this)" class="text-red-600 hover:text-red-800 text-sm">
                    <i class="fas fa-trash mr-1"></i>Remove
                </button>
            </div>
        </div>
    `;
    
    container.appendChild(newEvent);
    console.log(`Added family timeline event #${eventCount + 1}`);
}

function removeFamilyTimelineEvent(button) {
    const container = document.getElementById('familyTimelineEvents');
    const eventElement = button.closest('.family-timeline-event');
    
    if (container && eventElement) {
        // Don't remove if it's the only event
        if (container.children.length <= 1) {
            // Clear the fields instead
            const inputs = eventElement.querySelectorAll('input, select, textarea');
            inputs.forEach(input => input.value = '');
            console.log('Cleared family timeline event fields');
        } else {
            eventElement.remove();
            console.log('Removed family timeline event');
        }
    }
}