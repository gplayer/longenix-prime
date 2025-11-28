/**
 * vitaminD-dynamic.ts - Shared Vitamin D Dynamic Recommendation Logic
 * 
 * This module provides pure functions for:
 * - Extracting Vitamin D (25-OH) values from various data structures
 * - Classifying Vitamin D status into clinical tiers
 * - Generating Vitamin D recommendation cards
 * 
 * Used by:
 * - Preview probe endpoint (POST /api/report/preview/vitaminD)
 * - Main report Vitamin D card generation (GET /report)
 */

/**
 * Vitamin D classification thresholds (ng/mL)
 */
export const VITD_SEVERE_DEFICIENCY_THRESHOLD = 20
export const VITD_INSUFFICIENCY_THRESHOLD = 30
export const VITD_LOW_NORMAL_THRESHOLD = 50
export const VITD_OPTIMAL_HIGH = 80

/**
 * Vitamin D status classifications
 */
export type VitaminDStatus = 
  | 'severe_deficiency'
  | 'insufficiency'
  | 'low_normal'
  | 'optimal'
  | 'high'
  | null

/**
 * Result structure for Vitamin D card generation
 */
export interface VitaminDCardResult {
  shown: boolean
  vitaminDValue: number | null
  status: VitaminDStatus
  html: string
}

/**
 * Extract Vitamin D value from a biomarkers object (probe context)
 * Probes multiple common key variants
 * 
 * @param biomarkers - Object containing biomarker data
 * @returns Vitamin D value in ng/mL or null if not found
 */
export function extractVitaminDValue(biomarkers: any): number | null {
  if (!biomarkers || typeof biomarkers !== 'object') return null
  
  // Probe common Vitamin D keys in order of preference
  const vitDKeys = ['vitaminD', 'vitamin_d', 'vitamin_D', 'VitaminD', 'VITAMIN_D', '25OHD', '25_oh_d']
  
  for (const key of vitDKeys) {
    const value = biomarkers[key]
    if (value != null && !isNaN(Number(value))) {
      return Number(value)
    }
  }
  
  return null
}

/**
 * Extract Vitamin D value from comprehensive data structure (report context)
 * Searches multiple nested locations: biomarkers, clinical, root
 * 
 * @param comprehensiveData - Full patient data object
 * @returns Vitamin D value in ng/mL or null if not found
 */
export function extractVitaminDValueFromComprehensiveData(comprehensiveData: any): number | null {
  if (!comprehensiveData) return null
  
  // Probe common Vitamin D keys in order of preference
  const vitDKeys = ['vitaminD', 'vitamin_d', 'vitamin_D', 'VitaminD', 'VITAMIN_D', '25OHD', '25_oh_d']
  
  // Check biomarkers object first
  if (comprehensiveData.biomarkers) {
    for (const key of vitDKeys) {
      const value = comprehensiveData.biomarkers[key]
      if (value != null && !isNaN(Number(value))) {
        return Number(value)
      }
    }
  }
  
  // Check clinical object
  if (comprehensiveData.clinical) {
    for (const key of vitDKeys) {
      const value = comprehensiveData.clinical[key]
      if (value != null && !isNaN(Number(value))) {
        return Number(value)
      }
    }
  }
  
  // Check root level
  for (const key of vitDKeys) {
    const value = comprehensiveData[key]
    if (value != null && !isNaN(Number(value))) {
      return Number(value)
    }
  }
  
  return null
}

/**
 * Classify Vitamin D status into clinical tiers
 * 
 * Tiers:
 * - Severe deficiency: < 20 ng/mL
 * - Insufficiency: 20-30 ng/mL
 * - Low-normal: 30-50 ng/mL
 * - Optimal: 50-80 ng/mL
 * - High: > 80 ng/mL (potential toxicity risk)
 * 
 * @param value - Vitamin D level in ng/mL
 * @returns Classification status or null if value is null
 */
export function classifyVitaminDStatus(value: number | null): VitaminDStatus {
  if (value == null) return null
  
  if (value < VITD_SEVERE_DEFICIENCY_THRESHOLD) {
    return 'severe_deficiency'
  } else if (value < VITD_INSUFFICIENCY_THRESHOLD) {
    return 'insufficiency'
  } else if (value < VITD_LOW_NORMAL_THRESHOLD) {
    return 'low_normal'
  } else if (value <= VITD_OPTIMAL_HIGH) {
    return 'optimal'
  } else {
    return 'high'
  }
}

/**
 * Generate HTML for Vitamin D recommendation card based on status
 * 
 * @param vitaminDValue - Current Vitamin D value in ng/mL
 * @param status - Classification status
 * @returns HTML string for the card
 */
export function generateVitaminDCardHTML(vitaminDValue: number, status: VitaminDStatus): string {
  let priorityClass = 'border-yellow-200'
  let iconBg = 'bg-yellow-100'
  let iconColor = 'text-yellow-600'
  let priorityLabel = ''
  let recommendations = ''
  
  switch (status) {
    case 'severe_deficiency':
      priorityClass = 'border-red-200'
      iconBg = 'bg-red-100'
      iconColor = 'text-red-600'
      priorityLabel = 'HIGH PRIORITY'
      recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              Current level: <strong>${Math.round(vitaminDValue)} ng/mL</strong> (Severe Deficiency - Normal: 30-100 ng/mL)
                          </p>
                          <div class="bg-red-50 border border-red-200 rounded p-3 mb-3">
                              <p class="text-sm font-semibold text-red-800 mb-1">⚠️ Immediate Action Required</p>
                              <p class="text-xs text-red-700">Severe deficiency requires aggressive repletion and close monitoring.</p>
                          </div>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Recommended Actions:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• High-dose D3 supplementation (5,000-10,000 IU daily)</li>
                                      <li>• Consider loading dose if clinically appropriate</li>
                                      <li>• Take with fat-containing meal for absorption</li>
                                      <li>• Retest in 6-8 weeks to monitor response</li>
                                      <li>• Assess for malabsorption issues</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Clinical Considerations:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Add Vitamin K2 co-supplementation (45-180 mcg)</li>
                                      <li>• Increase dietary sources (fatty fish, fortified foods)</li>
                                      <li>• Safe sun exposure when possible (10-30 min)</li>
                                      <li>• Discuss with healthcare provider for personalized plan</li>
                                  </ul>
                              </div>
                          </div>
      `
      break
      
    case 'insufficiency':
      priorityClass = 'border-orange-200'
      iconBg = 'bg-orange-100'
      iconColor = 'text-orange-600'
      priorityLabel = 'MEDIUM PRIORITY'
      recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              Current level: <strong>${Math.round(vitaminDValue)} ng/mL</strong> (Insufficient - Normal: 30-100 ng/mL)
                          </p>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Recommended Actions:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Moderate-dose D3 supplementation (4,000-5,000 IU daily)</li>
                                      <li>• Take with fat-containing meal</li>
                                      <li>• Retest in 8-12 weeks</li>
                                      <li>• Monitor for improvement to optimal range (50-80 ng/mL)</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Lifestyle Optimization:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Consider Vitamin K2 co-supplementation</li>
                                      <li>• Increase dietary sources (salmon, mackerel, sardines)</li>
                                      <li>• Safe sun exposure (10-20 min, 2-3x per week)</li>
                                      <li>• Address any absorption issues with provider</li>
                                  </ul>
                              </div>
                          </div>
      `
      break
      
    case 'low_normal':
      priorityClass = 'border-yellow-200'
      iconBg = 'bg-yellow-100'
      iconColor = 'text-yellow-600'
      priorityLabel = 'MAINTENANCE'
      recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              Current level: <strong>${Math.round(vitaminDValue)} ng/mL</strong> (Acceptable - Optimal: 50-80 ng/mL)
                          </p>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Maintenance Recommendations:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Maintenance D3 supplementation (2,000-3,000 IU daily)</li>
                                      <li>• Continue taking with fat-containing meal</li>
                                      <li>• Retest in 3-6 months</li>
                                      <li>• Consider optimizing to 50-80 ng/mL range</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Lifestyle Support:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Regular sun exposure (15-20 min, 3-4x per week)</li>
                                      <li>• Include vitamin D-rich foods in diet</li>
                                      <li>• Consider seasonal adjustments (higher dose in winter)</li>
                                      <li>• Monitor if levels trend downward</li>
                                  </ul>
                              </div>
                          </div>
      `
      break
      
    case 'optimal':
      priorityClass = 'border-green-200'
      iconBg = 'bg-green-100'
      iconColor = 'text-green-600'
      priorityLabel = 'OPTIMAL'
      recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              Current level: <strong>${Math.round(vitaminDValue)} ng/mL</strong> (Optimal Range: 50-80 ng/mL) ✓
                          </p>
                          <div class="bg-green-50 border border-green-200 rounded p-3 mb-3">
                              <p class="text-sm font-semibold text-green-800 mb-1">✓ On Track</p>
                              <p class="text-xs text-green-700">Your vitamin D level is in the optimal range. Maintain your current plan.</p>
                          </div>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Maintenance Plan:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Continue current D3 dose (1,000-2,000 IU daily)</li>
                                      <li>• Keep taking with fat-containing meal</li>
                                      <li>• Annual recheck recommended</li>
                                      <li>• No need to increase dosing</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Ongoing Support:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Continue balanced diet with vitamin D sources</li>
                                      <li>• Maintain regular outdoor activity</li>
                                      <li>• Adjust dose seasonally if needed</li>
                                      <li>• Monitor if life circumstances change</li>
                                  </ul>
                              </div>
                          </div>
      `
      break
      
    case 'high':
      priorityClass = 'border-red-200'
      iconBg = 'bg-red-100'
      iconColor = 'text-red-600'
      priorityLabel = 'CAUTION'
      recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              Current level: <strong>${Math.round(vitaminDValue)} ng/mL</strong> (Above Optimal - Risk of Toxicity)
                          </p>
                          <div class="bg-red-50 border border-red-200 rounded p-3 mb-3">
                              <p class="text-sm font-semibold text-red-800 mb-1">⚠️ Caution: High Level</p>
                              <p class="text-xs text-red-700">Elevated vitamin D can lead to hypercalcemia and other complications.</p>
                          </div>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Immediate Actions:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• <strong>HOLD all vitamin D supplementation</strong></li>
                                      <li>• Reduce fortified food intake</li>
                                      <li>• Retest in 3 months to monitor decline</li>
                                      <li>• Check serum calcium levels</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Clinical Follow-up:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Consult healthcare provider promptly</li>
                                      <li>• Assess for symptoms of hypervitaminosis D</li>
                                      <li>• Monitor kidney function if appropriate</li>
                                      <li>• Re-evaluate supplementation regimen</li>
                                  </ul>
                                  <p class="text-xs text-red-600 font-medium mt-2">Do NOT continue routine high-dose supplementation.</p>
                              </div>
                          </div>
      `
      break
      
    default:
      return ''
  }
  
  return `
              <section data-test="vitamin-d-card" class="bg-white rounded-lg p-4 border ${priorityClass}">
                  <div class="flex items-start">
                      <div class="${iconBg} p-2 rounded-full mr-4 mt-1">
                          <i class="fas fa-sun ${iconColor}"></i>
                      </div>
                      <div class="flex-1">
                          <h4 class="font-semibold text-gray-800 mb-1">
                              Vitamin D Optimization 
                              <span class="text-xs text-blue-600">(Preview dynamic)</span>
                              ${priorityLabel ? `<span class="ml-2 text-xs font-bold ${iconColor}">${priorityLabel}</span>` : ''}
                          </h4>
                          ${recommendations}
                      </div>
                  </div>
              </section>
      `.trim()
}

/**
 * Build complete Vitamin D card result with gating logic
 * This is the main function used by both probe endpoint and report
 * 
 * Card is shown when:
 * - A valid Vitamin D value is available
 * 
 * @param vitaminDValue - Vitamin D level in ng/mL or null
 * @returns Complete Vitamin D card result object
 */
export function buildVitaminDCardResult(vitaminDValue: number | null): VitaminDCardResult {
  if (vitaminDValue == null) {
    return {
      shown: false,
      vitaminDValue: null,
      status: null,
      html: ''
    }
  }
  
  const status = classifyVitaminDStatus(vitaminDValue)
  const html = generateVitaminDCardHTML(vitaminDValue, status)
  
  return {
    shown: true,
    vitaminDValue: vitaminDValue,
    status: status,
    html: html
  }
}
