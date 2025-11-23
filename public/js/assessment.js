// LongenixHealth Dynamic Assessment Form
// Dr. Graham Player, Ph.D - Longenix Health

class DynamicAssessmentForm {
    constructor() {
        this.currentStep = 1
        this.totalSteps = 8
        this.assessmentData = {}
        this.sessionId = null
        this.patientId = null
        
        this.init()
    }

    init() {
        this.setupEventListeners()
        this.updateProgress()
    }

    setupEventListeners() {
        const form = document.getElementById('dynamicAssessmentForm')
        const nextBtn = document.getElementById('nextBtn')
        const prevBtn = document.getElementById('prevBtn')
        const submitBtn = document.getElementById('submitBtn')

        if (nextBtn) {
            nextBtn.addEventListener('click', () => this.nextStep())
        }

        if (prevBtn) {
            prevBtn.addEventListener('click', () => this.prevStep())
        }

        if (submitBtn) {
            submitBtn.addEventListener('click', () => this.submitAssessment())
        }

        // Auto-save functionality for form inputs
        if (form) {
            form.addEventListener('input', (e) => this.handleInputChange(e))
            form.addEventListener('change', (e) => this.handleInputChange(e))
        }
    }

    handleInputChange(event) {
        const input = event.target
        const fieldName = input.name
        const value = input.value

        // Store the data in memory
        this.assessmentData[fieldName] = value

        // Show real-time validation feedback
        this.validateField(input)

        console.log('Data updated:', fieldName, '=', value)
    }

    validateField(input) {
        const value = input.value.trim()
        const isRequired = input.hasAttribute('required')

        // Remove previous validation classes
        input.classList.remove('border-red-500', 'border-green-500')

        if (isRequired && !value) {
            input.classList.add('border-red-500')
            return false
        } else if (value) {
            input.classList.add('border-green-500')
        }

        return true
    }

    async nextStep() {
        if (this.validateCurrentStep()) {
            // Save current step data
            await this.saveCurrentStepData()
            
            if (this.currentStep < this.totalSteps) {
                this.currentStep++
                this.showStep(this.currentStep)
                this.updateProgress()
            }
        }
    }

    prevStep() {
        if (this.currentStep > 1) {
            this.currentStep--
            this.showStep(this.currentStep)
            this.updateProgress()
        }
    }

    validateCurrentStep() {
        const currentStepElement = document.getElementById(`step${this.currentStep}`)
        if (!currentStepElement) return true

        const requiredInputs = currentStepElement.querySelectorAll('[required]')
        let isValid = true

        requiredInputs.forEach(input => {
            if (!this.validateField(input)) {
                isValid = false
            }
        })

        if (!isValid) {
            this.showNotification('Please fill in all required fields before proceeding.', 'error')
        }

        return isValid
    }

    showStep(stepNumber) {
        // Hide all steps
        for (let i = 1; i <= this.totalSteps; i++) {
            const step = document.getElementById(`step${i}`)
            if (step) {
                step.classList.add('hidden')
            }
        }

        // Show current step
        const currentStep = document.getElementById(`step${stepNumber}`)
        if (currentStep) {
            currentStep.classList.remove('hidden')
        }

        // Update navigation buttons
        this.updateNavigationButtons()
    }

    updateNavigationButtons() {
        const prevBtn = document.getElementById('prevBtn')
        const nextBtn = document.getElementById('nextBtn')
        const submitBtn = document.getElementById('submitBtn')

        // Previous button
        if (prevBtn) {
            if (this.currentStep > 1) {
                prevBtn.classList.remove('hidden')
            } else {
                prevBtn.classList.add('hidden')
            }
        }

        // Next vs Submit button
        if (this.currentStep === this.totalSteps) {
            if (nextBtn) nextBtn.classList.add('hidden')
            if (submitBtn) submitBtn.classList.remove('hidden')
        } else {
            if (nextBtn) nextBtn.classList.remove('hidden')
            if (submitBtn) submitBtn.classList.add('hidden')
        }
    }

    updateProgress() {
        const progress = (this.currentStep / this.totalSteps) * 100
        const progressFill = document.getElementById('progressFill')
        const progressPercent = document.getElementById('progressPercent')
        const currentStepSpan = document.getElementById('currentStep')

        if (progressFill) {
            progressFill.style.width = `${progress}%`
        }

        if (progressPercent) {
            progressPercent.textContent = Math.round(progress)
        }

        if (currentStepSpan) {
            currentStepSpan.textContent = this.currentStep
        }
    }

    async saveCurrentStepData() {
        if (this.currentStep === 1 && this.assessmentData.fullName) {
            // Save patient data on first step
            try {
                const response = await fetch('/api/assessment/save', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(this.assessmentData)
                })

                const result = await response.json()
                
                if (result.success) {
                    this.sessionId = result.sessionId
                    this.patientId = result.patientId
                    this.showNotification('Data saved successfully!', 'success')
                } else {
                    this.showNotification('Failed to save data: ' + result.error, 'error')
                }
            } catch (error) {
                console.error('Save error:', error)
                this.showNotification('Error saving data. Please try again.', 'error')
            }
        }
    }

    async submitAssessment() {
        if (!this.validateCurrentStep()) return

        this.showLoadingOverlay(true)

        try {
            // Final save of all assessment data
            const response = await fetch('/api/assessment/complete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    sessionId: this.sessionId,
                    patientId: this.patientId,
                    assessmentData: this.assessmentData
                })
            })

            const result = await response.json()
            
            if (result.success) {
                // Redirect to dynamic report
                window.location.href = `/report?session=${this.sessionId}`
            } else {
                throw new Error(result.error || 'Failed to complete assessment')
            }
        } catch (error) {
            console.error('Submit error:', error)
            this.showNotification('Error submitting assessment: ' + error.message, 'error')
        } finally {
            this.showLoadingOverlay(false)
        }
    }

    showLoadingOverlay(show) {
        const overlay = document.getElementById('loadingOverlay')
        if (overlay) {
            if (show) {
                overlay.classList.remove('hidden')
            } else {
                overlay.classList.add('hidden')
            }
        }
    }

    showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div')
        notification.className = `fixed top-4 right-4 p-4 rounded-lg shadow-lg z-50 ${
            type === 'success' ? 'bg-green-500' : 
            type === 'error' ? 'bg-red-500' : 
            'bg-blue-500'
        } text-white`
        
        notification.innerHTML = `
            <div class="flex items-center">
                <i class="fas fa-${type === 'success' ? 'check' : type === 'error' ? 'exclamation-triangle' : 'info'} mr-2"></i>
                <span>${message}</span>
            </div>
        `

        document.body.appendChild(notification)

        // Auto-remove after 3 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification)
            }
        }, 3000)
    }
}

// Initialize the dynamic assessment form when page loads
document.addEventListener('DOMContentLoaded', () => {
    new DynamicAssessmentForm()
})