/**
 * hba1c-dynamic.ts - Shared HbA1c/Glucose Dynamic Recommendation Logic
 * 
 * This module provides pure functions for:
 * - Extracting HbA1c and fasting glucose values from various data structures
 * - Classifying glycemic status into clinical tiers
 * - Generating HbA1c/glucose recommendation cards
 * 
 * Used by:
 * - Preview probe endpoint (POST /api/report/preview/hba1c)
 * - Main report HbA1c/glucose card generation (GET /report)
 * 
 * Clinical Basis: American Diabetes Association (ADA) 2024 Guidelines
 */

/**
 * HbA1c classification thresholds (%)
 * Based on ADA 2024 Guidelines
 */
export const HBA1C_NORMAL = 5.7              // < 5.7%: Normal
export const HBA1C_ELEVATED_NORMAL = 6.0    // 5.7-5.9%: Elevated-Normal
export const HBA1C_PREDIABETES = 6.5         // 6.0-6.4%: Prediabetes
export const HBA1C_HIGH_RISK = 8.0           // ≥ 8.0%: High-Risk Diabetes

/**
 * Fasting glucose classification thresholds (mg/dL)
 * Based on ADA 2024 Guidelines
 */
export const GLUCOSE_NORMAL = 100            // < 100 mg/dL: Normal
export const GLUCOSE_ELEVATED_NORMAL = 110   // 100-109 mg/dL: Elevated-Normal
export const GLUCOSE_PREDIABETES = 126       // 110-125 mg/dL: Prediabetes
export const GLUCOSE_HIGH_RISK = 200         // ≥ 200 mg/dL: High-Risk Diabetes

/**
 * Glycemic status classifications
 * 5-tier system for personalized recommendations
 */
export type GlycemicStatus = 
  | 'normal'
  | 'elevated_normal'
  | 'prediabetes'
  | 'diabetes'
  | 'high_risk_diabetes'
  | null

/**
 * Result structure for HbA1c card generation
 */
export interface HbA1cCardResult {
  shown: boolean
  hba1cValue: number | null
  glucoseValue: number | null
  status: GlycemicStatus
  html: string
}

/**
 * Extract HbA1c value from a biomarkers object (probe context)
 * Probes multiple common key variants
 * 
 * @param biomarkers - Object containing biomarker data
 * @returns HbA1c value in % or null if not found
 */
export function extractHba1cValueFromBiomarkers(biomarkers: any): number | null {
  if (!biomarkers || typeof biomarkers !== 'object') return null
  
  // Probe common HbA1c keys in order of preference
  const hba1cKeys = ['hba1c', 'HbA1c', 'HBA1C', 'a1c', 'A1C', 'hemoglobinA1c', 'glycated_hemoglobin']
  
  for (const key of hba1cKeys) {
    const value = biomarkers[key]
    if (value != null && !isNaN(Number(value))) {
      const numValue = Number(value)
      // Sanity check: HbA1c should be between 3% and 15%
      if (numValue >= 3 && numValue <= 15) {
        return numValue
      }
    }
  }
  
  return null
}

/**
 * Extract fasting glucose value from a biomarkers object (probe context)
 * Probes multiple common key variants
 * 
 * @param biomarkers - Object containing biomarker data
 * @returns Fasting glucose value in mg/dL or null if not found
 */
export function extractGlucoseValueFromBiomarkers(biomarkers: any): number | null {
  if (!biomarkers || typeof biomarkers !== 'object') return null
  
  // Probe common glucose keys in order of preference
  const glucoseKeys = ['glucose', 'fastingGlucose', 'fasting_glucose', 'bloodGlucose', 'blood_glucose', 'fpg', 'FPG']
  
  for (const key of glucoseKeys) {
    const value = biomarkers[key]
    if (value != null && !isNaN(Number(value))) {
      const numValue = Number(value)
      // Sanity check: Fasting glucose should be between 40 and 400 mg/dL
      if (numValue >= 40 && numValue <= 400) {
        return numValue
      }
    }
  }
  
  return null
}

/**
 * Extract HbA1c value from comprehensive data structure (report context)
 * Searches multiple nested locations: biomarkers, clinical, root
 * 
 * @param comprehensiveData - Full patient data object
 * @returns HbA1c value in % or null if not found
 */
export function extractHba1cValueFromComprehensiveData(comprehensiveData: any): number | null {
  if (!comprehensiveData) return null
  
  // Probe common HbA1c keys
  const hba1cKeys = ['hba1c', 'HbA1c', 'HBA1C', 'a1c', 'A1C']
  
  // Check biomarkers object first
  if (comprehensiveData.biomarkers) {
    for (const key of hba1cKeys) {
      const value = comprehensiveData.biomarkers[key]
      if (value != null && !isNaN(Number(value))) {
        const numValue = Number(value)
        if (numValue >= 3 && numValue <= 15) {
          return numValue
        }
      }
    }
  }
  
  // Check clinical object
  if (comprehensiveData.clinical) {
    for (const key of hba1cKeys) {
      const value = comprehensiveData.clinical[key]
      if (value != null && !isNaN(Number(value))) {
        const numValue = Number(value)
        if (numValue >= 3 && numValue <= 15) {
          return numValue
        }
      }
    }
  }
  
  // Check root level
  for (const key of hba1cKeys) {
    const value = comprehensiveData[key]
    if (value != null && !isNaN(Number(value))) {
      const numValue = Number(value)
      if (numValue >= 3 && numValue <= 15) {
        return numValue
      }
    }
  }
  
  return null
}

/**
 * Extract fasting glucose value from comprehensive data structure (report context)
 * 
 * @param comprehensiveData - Full patient data object
 * @returns Fasting glucose value in mg/dL or null if not found
 */
export function extractGlucoseValueFromComprehensiveData(comprehensiveData: any): number | null {
  if (!comprehensiveData) return null
  
  const glucoseKeys = ['glucose', 'fastingGlucose', 'fasting_glucose']
  
  // Check biomarkers object first
  if (comprehensiveData.biomarkers) {
    for (const key of glucoseKeys) {
      const value = comprehensiveData.biomarkers[key]
      if (value != null && !isNaN(Number(value))) {
        const numValue = Number(value)
        if (numValue >= 40 && numValue <= 400) {
          return numValue
        }
      }
    }
  }
  
  // Check clinical object
  if (comprehensiveData.clinical) {
    for (const key of glucoseKeys) {
      const value = comprehensiveData.clinical[key]
      if (value != null && !isNaN(Number(value))) {
        const numValue = Number(value)
        if (numValue >= 40 && numValue <= 400) {
          return numValue
        }
      }
    }
  }
  
  // Check root level
  for (const key of glucoseKeys) {
    const value = comprehensiveData[key]
    if (value != null && !isNaN(Number(value))) {
      const numValue = Number(value)
      if (numValue >= 40 && numValue <= 400) {
        return numValue
      }
    }
  }
  
  return null
}

/**
 * Classify glycemic status into clinical tiers
 * Priority: Use HbA1c if available (more reliable), fallback to glucose
 * 
 * Tiers (ADA 2024 Guidelines):
 * - Normal: HbA1c < 5.7% or glucose < 100 mg/dL
 * - Elevated-Normal: HbA1c 5.7-5.9% or glucose 100-109 mg/dL
 * - Prediabetes: HbA1c 6.0-6.4% or glucose 110-125 mg/dL
 * - Diabetes: HbA1c 6.5-7.9% or glucose 126-199 mg/dL
 * - High-Risk Diabetes: HbA1c ≥ 8.0% or glucose ≥ 200 mg/dL
 * 
 * @param hba1c - HbA1c value in %
 * @param glucose - Fasting glucose value in mg/dL
 * @returns Classification status or null if both values are null
 */
export function classifyGlycemicStatus(
  hba1c: number | null,
  glucose: number | null
): GlycemicStatus {
  // Priority: Use HbA1c if available (gold standard)
  if (hba1c != null) {
    if (hba1c >= HBA1C_HIGH_RISK) {
      return 'high_risk_diabetes'
    } else if (hba1c >= HBA1C_PREDIABETES) {
      return 'diabetes'
    } else if (hba1c >= HBA1C_ELEVATED_NORMAL) {
      return 'prediabetes'
    } else if (hba1c >= HBA1C_NORMAL) {
      return 'elevated_normal'
    } else {
      return 'normal'
    }
  }
  
  // Fallback: Use glucose if HbA1c not available
  if (glucose != null) {
    if (glucose >= GLUCOSE_HIGH_RISK) {
      return 'high_risk_diabetes'
    } else if (glucose >= GLUCOSE_PREDIABETES) {
      return 'diabetes'
    } else if (glucose >= GLUCOSE_ELEVATED_NORMAL) {
      return 'prediabetes'
    } else if (glucose >= GLUCOSE_NORMAL) {
      return 'elevated_normal'
    } else {
      return 'normal'
    }
  }
  
  return null
}

/**
 * Determine if HbA1c card should be shown
 * Show when there's clinical indication (elevated values or abnormal status)
 * 
 * @param hba1c - HbA1c value in %
 * @param glucose - Fasting glucose value in mg/dL
 * @param status - Classified glycemic status
 * @returns true if card should be shown, false otherwise
 */
export function shouldShowHbA1cCard(
  hba1c: number | null,
  glucose: number | null,
  status: GlycemicStatus
): boolean {
  // Hide if no data
  if (status === null) return false
  
  // Hide if normal (no action needed)
  if (status === 'normal') return false
  
  // Show for all non-normal statuses
  return true
}

/**
 * Generate HTML for HbA1c/glucose recommendation card based on status
 * 
 * @param hba1cValue - Current HbA1c value in %
 * @param glucoseValue - Current fasting glucose value in mg/dL
 * @param status - Classification status
 * @returns HTML string for the card
 */
export function generateHbA1cCardHTML(
  hba1cValue: number | null,
  glucoseValue: number | null,
  status: GlycemicStatus
): string {
  if (status === null || status === 'normal') return ''
  
  let priorityClass = 'border-yellow-200'
  let iconBg = 'bg-yellow-100'
  let iconColor = 'text-yellow-600'
  let priorityLabel = ''
  let title = ''
  let recommendations = ''
  
  // Format values for display
  const hba1cDisplay = hba1cValue != null ? `${hba1cValue.toFixed(1)}%` : 'Not measured'
  const glucoseDisplay = glucoseValue != null ? `${Math.round(glucoseValue)} mg/dL` : 'Not measured'
  
  switch (status) {
    case 'elevated_normal':
      priorityClass = 'border-yellow-200'
      iconBg = 'bg-yellow-100'
      iconColor = 'text-yellow-600'
      priorityLabel = '⚠️ WATCH'
      title = 'Glucose Elevated - Increased Diabetes Risk'
      recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              <strong>HbA1c:</strong> ${hba1cDisplay} (Normal: < 5.7%) &nbsp;&nbsp;
                              <strong>Fasting Glucose:</strong> ${glucoseDisplay} (Normal: < 100 mg/dL)
                          </p>
                          <div class="bg-yellow-50 border border-yellow-200 rounded p-3 mb-3">
                              <p class="text-sm font-semibold text-yellow-800 mb-1">⚠️ Increased Risk</p>
                              <p class="text-xs text-yellow-700">You are at increased risk for developing type 2 diabetes.</p>
                          </div>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Recommended Actions:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Weight management: 5-7% weight loss if BMI > 25</li>
                                      <li>• Physical activity: 150 minutes/week moderate exercise</li>
                                      <li>• Low glycemic index diet</li>
                                      <li>• Increase fiber intake (25-30g daily)</li>
                                      <li>• Reduce refined carbs and added sugars</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Monitoring:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Retest HbA1c in 6 months</li>
                                      <li>• Consider consultation with registered dietitian</li>
                                      <li>• Monitor weight and blood pressure</li>
                                  </ul>
                              </div>
                          </div>
      `
      break
      
    case 'prediabetes':
      priorityClass = 'border-orange-200'
      iconBg = 'bg-orange-100'
      iconColor = 'text-orange-600'
      priorityLabel = '🟠 HIGH PRIORITY'
      title = 'Prediabetes - Urgent Lifestyle Intervention Needed'
      recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              <strong>HbA1c:</strong> ${hba1cDisplay} (Prediabetes: 6.0-6.4%) &nbsp;&nbsp;
                              <strong>Fasting Glucose:</strong> ${glucoseDisplay} (Prediabetes: 110-125 mg/dL)
                          </p>
                          <div class="bg-orange-50 border border-orange-200 rounded p-3 mb-3">
                              <p class="text-sm font-semibold text-orange-800 mb-1">🟠 High Risk of Progression</p>
                              <p class="text-xs text-orange-700">Aggressive intervention can REVERSE this condition and prevent diabetes.</p>
                          </div>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Intensive Interventions:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• <strong>Weight loss goal: 7-10% of body weight</strong></li>
                                      <li>• <strong>Exercise: 300 min/week for best results</strong></li>
                                      <li>• Low glycemic diet with calorie restriction</li>
                                      <li>• High fiber (30-35g daily)</li>
                                      <li>• Eliminate sugary beverages</li>
                                      <li>• Include resistance training 2-3x/week</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Medical Follow-Up:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• <strong>Discuss metformin with physician</strong> (especially if BMI ≥ 35)</li>
                                      <li>• Retest HbA1c in 3 months</li>
                                      <li>• Screen for complications (eyes, kidneys)</li>
                                      <li>• Check lipid panel and blood pressure</li>
                                      <li>• Consider continuous glucose monitor (CGM)</li>
                                  </ul>
                              </div>
                          </div>
      `
      break
      
    case 'diabetes':
      priorityClass = 'border-red-200'
      iconBg = 'bg-red-100'
      iconColor = 'text-red-600'
      priorityLabel = '🔴 URGENT'
      title = 'Diabetes Range - Immediate Physician Referral Required'
      recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              <strong>HbA1c:</strong> ${hba1cDisplay} (Diabetes: ≥ 6.5%) &nbsp;&nbsp;
                              <strong>Fasting Glucose:</strong> ${glucoseDisplay} (Diabetes: ≥ 126 mg/dL)
                          </p>
                          <div class="bg-red-50 border border-red-200 rounded p-3 mb-3">
                              <p class="text-sm font-semibold text-red-800 mb-1">🔴 URGENT: Immediate Physician Referral</p>
                              <p class="text-xs text-red-700">Your labs indicate type 2 diabetes. Do NOT attempt self-management without physician guidance.</p>
                          </div>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Immediate Next Steps:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• <strong>Schedule physician appointment THIS WEEK</strong></li>
                                      <li>• Confirm diagnosis with repeat HbA1c or fasting glucose</li>
                                      <li>• Discuss medication options (metformin, GLP-1 agonists, etc.)</li>
                                      <li>• Comprehensive diabetes education program</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Complication Screening:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Eye exam (retinopathy screening)</li>
                                      <li>• Kidney function tests (creatinine, urine albumin)</li>
                                      <li>• Foot examination (neuropathy check)</li>
                                      <li>• Lipid panel (cardiovascular risk)</li>
                                      <li>• Blood pressure monitoring</li>
                                  </ul>
                              </div>
                          </div>
                          <div class="mt-3 p-2 bg-gray-50 border border-gray-200 rounded">
                              <p class="text-xs text-gray-600">
                                  <strong>Note:</strong> This report is NOT a diabetes diagnosis tool. Diabetes must be confirmed by a physician with repeat testing.
                              </p>
                          </div>
      `
      break
      
    case 'high_risk_diabetes':
      priorityClass = 'border-red-200'
      iconBg = 'bg-red-100'
      iconColor = 'text-red-600'
      priorityLabel = '🔴 CRITICAL'
      title = 'Severe Hyperglycemia - Urgent Medical Attention Required'
      recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              <strong>HbA1c:</strong> ${hba1cDisplay} (High-Risk: ≥ 8.0%) &nbsp;&nbsp;
                              <strong>Fasting Glucose:</strong> ${glucoseDisplay} (High-Risk: ≥ 200 mg/dL)
                          </p>
                          <div class="bg-red-50 border border-red-200 rounded p-3 mb-3">
                              <p class="text-sm font-semibold text-red-800 mb-1">🔴 CRITICAL: Severe Hyperglycemia</p>
                              <p class="text-xs text-red-700 font-bold">⚠️ CALL YOUR DOCTOR TODAY OR GO TO URGENT CARE</p>
                          </div>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Immediate Action:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• <strong class="text-red-600">Contact physician TODAY</strong></li>
                                      <li>• Risk of diabetic ketoacidosis (DKA) or hyperosmolar state</li>
                                      <li>• May require immediate medication adjustment or hospitalization</li>
                                      <li>• DO NOT delay medical care</li>
                                      <li>• DO NOT attempt lifestyle changes alone</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Warning Symptoms (Seek Emergency Care):</p>
                                  <ul class="text-xs text-red-600 space-y-1">
                                      <li>• Excessive thirst or urination</li>
                                      <li>• Unexplained weight loss</li>
                                      <li>• Blurred vision</li>
                                      <li>• Confusion or difficulty concentrating</li>
                                      <li>• Fruity breath odor</li>
                                      <li>• Nausea or vomiting</li>
                                  </ul>
                              </div>
                          </div>
                          <div class="mt-3 p-2 bg-red-50 border border-red-200 rounded">
                              <p class="text-xs text-red-700 font-semibold">
                                  ⚠️ IMPORTANT: If you have symptoms of hyperglycemia (excessive thirst, frequent urination, blurred vision), seek emergency medical care immediately.
                              </p>
                          </div>
      `
      break
      
    default:
      return ''
  }
  
  return `
    <section class="mt-4 p-4 bg-white border ${priorityClass} rounded-lg shadow-sm">
      <div class="flex items-start gap-3">
        <div class="${iconBg} ${iconColor} p-2 rounded-full">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
        </div>
        <div class="flex-1">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-base font-semibold text-gray-800">
              ${title}
            </h3>
            <span class="text-xs font-bold ${iconColor} px-2 py-1 rounded">${priorityLabel}</span>
          </div>
          ${recommendations}
          <p class="text-xs text-gray-500 mt-3 italic">(Preview dynamic - Fix Pack #3)</p>
        </div>
      </div>
    </section>
  `
}

/**
 * Build complete HbA1c card result with gating logic
 * Main function used by probe endpoint and report generation
 * 
 * @param hba1c - HbA1c value in %
 * @param glucose - Fasting glucose value in mg/dL
 * @returns Complete card result with shown flag and HTML
 */
export function buildHbA1cCardResult(
  hba1c: number | null,
  glucose: number | null
): HbA1cCardResult {
  const status = classifyGlycemicStatus(hba1c, glucose)
  const shown = shouldShowHbA1cCard(hba1c, glucose, status)
  const html = shown ? generateHbA1cCardHTML(hba1c, glucose, status) : ''
  
  return {
    shown,
    hba1cValue: hba1c,
    glucoseValue: glucose,
    status,
    html
  }
}
