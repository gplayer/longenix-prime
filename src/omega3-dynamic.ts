/**
 * omega3-dynamic.ts - Shared Omega-3 Dynamic Recommendation Logic
 * 
 * This module provides pure functions for:
 * - Extracting triglycerides, ASCVD risk, Omega-3 Index from various data structures
 * - Checking contraindications and caution factors
 * - Classifying Omega-3 priority tiers
 * - Generating Omega-3 recommendation cards
 * 
 * Used by:
 * - Preview probe endpoint (POST /api/report/preview/omega3)
 * - Main report Omega-3 card generation (GET /report)
 * 
 * Clinical Basis: AHA/ACC Guidelines, REDUCE-IT Trial
 */

/**
 * Omega-3 classification thresholds
 */
export const TG_VERY_HIGH = 500        // mg/dL - Prescription omega-3 required
export const TG_HIGH = 200             // mg/dL - High-dose supplementation
export const TG_BORDERLINE_HIGH = 150  // mg/dL - Moderate-dose supplementation
export const TG_NORMAL = 150           // mg/dL - Below this is normal

export const ASCVD_HIGH_RISK = 0.15    // 15% - High cardiovascular risk
export const ASCVD_MODERATE_RISK = 0.075 // 7.5% - Moderate cardiovascular risk

export const OMEGA3_INDEX_OPTIMAL = 8  // % - Target Omega-3 Index

/**
 * Omega-3 priority tiers
 */
export type Omega3Tier = 
  | 'contraindicated'
  | 'high_priority'
  | 'moderate_priority'
  | 'dietary_emphasis'
  | 'caution'
  | 'no_recommendation'
  | null

/**
 * Result structure for Omega-3 card generation
 */
export interface Omega3CardResult {
  shown: boolean
  triglycerides: number | null
  ascvdRisk: number | null
  omega3Index: number | null
  tier: Omega3Tier
  priority: string | null
  html: string
}

/**
 * Extract triglycerides from biomarkers object (probe context)
 * Probes multiple common key variants
 * 
 * @param biomarkers - Object containing biomarker data
 * @returns Triglycerides in mg/dL or null if not found
 */
export function extractTriglyceridesFromBiomarkers(biomarkers: any): number | null {
  if (!biomarkers || typeof biomarkers !== 'object') return null
  
  // Probe common triglycerides keys in order of preference
  const tgKeys = ['triglycerides', 'tg', 'TG', 'Triglycerides', 'TRIGLYCERIDES', 'trigs']
  
  for (const key of tgKeys) {
    const value = biomarkers[key]
    if (value != null && !isNaN(Number(value))) {
      const numValue = Number(value)
      // Sanity check: Triglycerides should be between 20 and 3000 mg/dL
      if (numValue >= 20 && numValue <= 3000) {
        return numValue
      }
    }
  }
  
  return null
}

/**
 * Extract ASCVD risk from risk calculation object or biomarkers (probe context)
 * @param risk - Object containing risk calculation data
 * @returns ASCVD risk as decimal (0.15 = 15%) or null
 */
export function extractASCVDRiskFromCalculation(risk: any): number | null {
  if (!risk || typeof risk !== 'object') return null
  
  // Probe common ASCVD risk keys
  const ascvdKeys = ['ascvd', 'ASCVD', 'ascvdRisk', 'ascvd_risk', 'cardiovascularRisk']
  
  for (const key of ascvdKeys) {
    const value = risk[key]
    if (value != null && !isNaN(Number(value))) {
      const numValue = Number(value)
      // Sanity check: ASCVD risk should be between 0 and 1 (0% to 100%)
      if (numValue >= 0 && numValue <= 1) {
        return numValue
      }
    }
  }
  
  return null
}

/**
 * Extract Omega-3 Index from biomarkers object (probe context)
 * @param biomarkers - Object containing biomarker data
 * @returns Omega-3 Index as percentage or null
 */
export function extractOmega3IndexFromBiomarkers(biomarkers: any): number | null {
  if (!biomarkers || typeof biomarkers !== 'object') return null
  
  // Probe common Omega-3 Index keys
  const o3Keys = ['omega3Index', 'omega_3_index', 'o3Index', 'Omega3Index', 'OMEGA3_INDEX']
  
  for (const key of o3Keys) {
    const value = biomarkers[key]
    if (value != null && !isNaN(Number(value))) {
      const numValue = Number(value)
      // Sanity check: Omega-3 Index should be between 0 and 20%
      if (numValue >= 0 && numValue <= 20) {
        return numValue
      }
    }
  }
  
  return null
}

/**
 * Extract dietary fish intake from lifestyle/dietary data (probe context)
 * @param dietary - Object containing dietary data
 * @returns Fish servings per week or null
 */
export function extractFishIntakeFromDietary(dietary: any): number | null {
  if (!dietary || typeof dietary !== 'object') return null
  
  const fishKeys = ['fishServingsPerWeek', 'fish_servings', 'fishIntake', 'fattyFishServings']
  
  for (const key of fishKeys) {
    const value = dietary[key]
    if (value != null && !isNaN(Number(value))) {
      const numValue = Number(value)
      // Sanity check: Fish servings per week should be between 0 and 14
      if (numValue >= 0 && numValue <= 14) {
        return numValue
      }
    }
  }
  
  return null
}

/**
 * Extract existing omega-3 supplementation from supplements list (probe context)
 * @param supplements - Array of current supplements
 * @returns Daily EPA/DHA dose in grams or null
 */
export function extractExistingOmega3Supplementation(supplements: any[]): number | null {
  if (!Array.isArray(supplements) || supplements.length === 0) return null
  
  for (const supp of supplements) {
    if (!supp || typeof supp !== 'object') continue
    
    // Check if supplement name contains omega-3 related terms
    const name = (supp.name || '').toLowerCase()
    const isOmega3 = name.includes('fish oil') || 
                      name.includes('omega') || 
                      name.includes('epa') || 
                      name.includes('dha') || 
                      name.includes('krill') || 
                      name.includes('algae oil')
    
    if (isOmega3) {
      // Try to extract dose
      const doseKeys = ['epaDha', 'epa_dha', 'dose', 'amount']
      for (const key of doseKeys) {
        const value = supp[key]
        if (value != null && !isNaN(Number(value))) {
          const numValue = Number(value)
          if (numValue > 0 && numValue <= 10) {  // Reasonable dose range
            return numValue
          }
        }
      }
    }
  }
  
  return null
}

/**
 * Check for contraindications (bleeding disorders, upcoming surgery)
 * @param medicalHistory - Object containing medical history
 * @returns true if contraindication present
 */
export function hasOmega3Contraindication(medicalHistory: any): boolean {
  if (!medicalHistory || typeof medicalHistory !== 'object') return false
  
  // Check for bleeding disorder
  if (medicalHistory.bleedingDisorder === true) return true
  
  // Check for upcoming surgery (within 2 weeks)
  if (medicalHistory.upcomingSurgery === true) return true
  
  return false
}

/**
 * Check for caution factors (anticoagulants, antiplatelet agents)
 * @param medications - Array of current medications
 * @returns true if caution required
 */
export function requiresOmega3Caution(medications: any[]): boolean {
  if (!Array.isArray(medications) || medications.length === 0) return false
  
  // Anticoagulants
  const anticoagulants = [
    'warfarin', 'coumadin', 
    'apixaban', 'eliquis', 
    'rivaroxaban', 'xarelto',
    'dabigatran', 'pradaxa',
    'edoxaban', 'savaysa'
  ]
  
  // Antiplatelet agents
  const antiplatelets = [
    'aspirin', 'asa',
    'clopidogrel', 'plavix',
    'ticagrelor', 'brilinta',
    'prasugrel', 'effient'
  ]
  
  for (const med of medications) {
    if (!med || typeof med !== 'object') continue
    
    const name = (med.name || '').toLowerCase()
    const category = (med.category || '').toLowerCase()
    
    // Check category first
    if (category.includes('anticoagulant') || category.includes('antiplatelet')) {
      return true
    }
    
    // Check drug name
    for (const drug of [...anticoagulants, ...antiplatelets]) {
      if (name.includes(drug)) {
        return true
      }
    }
  }
  
  return false
}

/**
 * Classify Omega-3 priority tier based on risk factors
 * @param triglycerides - Triglycerides in mg/dL
 * @param ascvdRisk - ASCVD risk as decimal
 * @param omega3Index - Omega-3 Index percentage (if available)
 * @param fishIntake - Fish servings per week (if available)
 * @param hasContraindication - Contraindication present
 * @param requiresCaution - Caution required
 * @returns Omega-3 tier
 */
export function classifyOmega3Tier(
  triglycerides: number | null,
  ascvdRisk: number | null,
  omega3Index: number | null,
  fishIntake: number | null,
  hasContraindication: boolean,
  requiresCaution: boolean
): Omega3Tier {
  // Tier 0: Contraindicated
  if (hasContraindication) {
    return 'contraindicated'
  }
  
  // Tier 4: Caution Required (but still may recommend with physician approval)
  if (requiresCaution) {
    return 'caution'
  }
  
  // Tier 5: No Recommendation Needed (adequate intake)
  if (omega3Index != null && omega3Index >= OMEGA3_INDEX_OPTIMAL) {
    return 'no_recommendation'
  }
  
  // Tier 1: High-Priority Supplementation
  if (triglycerides != null) {
    // Very high TG (≥ 500 mg/dL) - Prescription omega-3 required
    if (triglycerides >= TG_VERY_HIGH) {
      return 'high_priority'
    }
    
    // High TG (200-499 mg/dL) - High-dose supplementation
    if (triglycerides >= TG_HIGH) {
      return 'high_priority'
    }
    
    // High ASCVD risk (≥ 15%) with elevated TG (≥ 150 mg/dL)
    if (triglycerides >= TG_BORDERLINE_HIGH && ascvdRisk != null && ascvdRisk >= ASCVD_HIGH_RISK) {
      return 'high_priority'
    }
  }
  
  // Tier 2: Moderate-Priority Supplementation
  if (triglycerides != null && triglycerides >= TG_BORDERLINE_HIGH && triglycerides < TG_HIGH) {
    return 'moderate_priority'
  }
  
  if (ascvdRisk != null && ascvdRisk >= ASCVD_MODERATE_RISK && ascvdRisk < ASCVD_HIGH_RISK) {
    return 'moderate_priority'
  }
  
  // Tier 3: Dietary Emphasis
  if (triglycerides != null && triglycerides < TG_BORDERLINE_HIGH) {
    if (ascvdRisk == null || ascvdRisk < ASCVD_MODERATE_RISK) {
      if (fishIntake != null && fishIntake >= 2) {
        return 'dietary_emphasis'
      }
    }
  }
  
  // Default: No data available
  return null
}

/**
 * Determine if Omega-3 card should be shown
 * @param tier - Omega-3 tier
 * @returns true if card should be shown
 */
export function shouldShowOmega3Card(tier: Omega3Tier): boolean {
  // Hide if no data
  if (tier === null) return false
  
  // Hide if no recommendation needed
  if (tier === 'no_recommendation') return false
  
  // Show for all other tiers
  return true
}

/**
 * Generate HTML for Omega-3 recommendation card based on tier
 * 
 * @param triglycerides - Triglycerides in mg/dL
 * @param ascvdRisk - ASCVD risk as decimal
 * @param omega3Index - Omega-3 Index percentage
 * @param tier - Omega-3 tier
 * @returns HTML string for the card
 */
export function generateOmega3CardHTML(
  triglycerides: number | null,
  ascvdRisk: number | null,
  omega3Index: number | null,
  tier: Omega3Tier
): string {
  if (tier === null || tier === 'no_recommendation') return ''
  
  let priorityClass = 'border-yellow-200'
  let iconBg = 'bg-yellow-100'
  let iconColor = 'text-yellow-600'
  let priorityLabel = ''
  let title = ''
  let recommendations = ''
  
  // Format values for display
  const tgDisplay = triglycerides != null ? `${Math.round(triglycerides)} mg/dL` : 'Not measured'
  const ascvdDisplay = ascvdRisk != null ? `${(ascvdRisk * 100).toFixed(1)}%` : 'Not assessed'
  const o3Display = omega3Index != null ? `${omega3Index.toFixed(1)}%` : 'Not measured'
  
  switch (tier) {
    case 'contraindicated':
      priorityClass = 'border-red-200'
      iconBg = 'bg-red-100'
      iconColor = 'text-red-600'
      priorityLabel = '❌ CONTRAINDICATION'
      title = 'Omega-3 Supplementation Contraindicated'
      recommendations = `
                          <div class="bg-red-50 border border-red-200 rounded p-3 mb-3">
                              <p class="text-sm font-semibold text-red-800 mb-1">❌ DO NOT RECOMMEND</p>
                              <p class="text-xs text-red-700">Omega-3 supplementation is contraindicated due to bleeding risk.</p>
                          </div>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Why Contraindicated:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Bleeding disorder present (e.g., hemophilia, von Willebrand disease)</li>
                                      <li>• Upcoming surgery within 2 weeks</li>
                                      <li>• High-dose omega-3 increases bleeding risk</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Alternative Recommendations:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Consult your physician for personalized guidance</li>
                                      <li>• Dietary sources MAY be acceptable in moderation</li>
                                      <li>• For surgery: Discuss omega-3 timing with surgeon</li>
                                  </ul>
                              </div>
                          </div>
      `
      break
      
    case 'high_priority':
      priorityClass = 'border-red-200'
      iconBg = 'bg-red-100'
      iconColor = 'text-red-600'
      
      // Very high TG (≥ 500 mg/dL) - Prescription omega-3 required
      if (triglycerides != null && triglycerides >= TG_VERY_HIGH) {
        priorityLabel = '🔴 URGENT'
        title = 'Very High Triglycerides - Prescription Omega-3 Required'
        recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              <strong>Triglycerides:</strong> ${tgDisplay} (Very High: ≥ 500 mg/dL) &nbsp;&nbsp;
                              <strong>ASCVD Risk:</strong> ${ascvdDisplay}
                          </p>
                          <div class="bg-red-50 border border-red-200 rounded p-3 mb-3">
                              <p class="text-sm font-semibold text-red-800 mb-1">🔴 URGENT: Physician Referral Required</p>
                              <p class="text-xs text-red-700 font-bold">⚠️ Prescription omega-3 (Vascepa/Lovaza) needed for very high triglycerides</p>
                          </div>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Immediate Action:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• <strong class="text-red-600">Schedule physician appointment THIS WEEK</strong></li>
                                      <li>• <strong>Prescription omega-3 required: Vascepa (4g EPA) or Lovaza (4g EPA/DHA)</strong></li>
                                      <li>• OTC supplements insufficient for TG ≥ 500 mg/dL</li>
                                      <li>• Retest lipid panel in 8-12 weeks after starting treatment</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Lifestyle Support:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Reduce refined carbs and sugars (primary TG driver)</li>
                                      <li>• Limit alcohol intake (alcohol raises TG)</li>
                                      <li>• Increase fatty fish consumption (salmon, mackerel)</li>
                                      <li>• Regular exercise (150+ min/week)</li>
                                  </ul>
                              </div>
                          </div>
        `
      } else {
        // High TG (200-499 mg/dL) or High ASCVD with elevated TG
        priorityLabel = '🔴 HIGH PRIORITY'
        title = 'High Cardiovascular Risk - High-Dose Omega-3 Recommended'
        recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              <strong>Triglycerides:</strong> ${tgDisplay} (High: ≥ 200 mg/dL) &nbsp;&nbsp;
                              <strong>ASCVD Risk:</strong> ${ascvdDisplay}
                          </p>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Recommended Supplementation:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• <strong>High-dose EPA/DHA supplementation: 3-4g daily</strong></li>
                                      <li>• Choose pharmaceutical-grade fish oil (purity & potency verified)</li>
                                      <li>• Take with meals for best absorption</li>
                                      <li>• Consider Omega-3 Index testing to monitor adequacy</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Dietary Optimization:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Increase fatty fish intake (salmon, mackerel, sardines) 3-4x/week</li>
                                      <li>• Reduce refined carbs and sugars</li>
                                      <li>• Limit alcohol intake</li>
                                      <li>• Retest lipid panel in 8-12 weeks</li>
                                  </ul>
                              </div>
                          </div>
                          <div class="mt-3 p-2 bg-gray-50 border border-gray-200 rounded">
                              <p class="text-xs text-gray-600">
                                  <strong>Note:</strong> Consult your physician before starting omega-3, especially if taking blood thinners. Dosing varies based on individual health status.
                              </p>
                          </div>
        `
      }
      break
      
    case 'moderate_priority':
      priorityClass = 'border-orange-200'
      iconBg = 'bg-orange-100'
      iconColor = 'text-orange-600'
      priorityLabel = '🟠 MEDIUM PRIORITY'
      title = 'Moderate Cardiovascular Risk - Omega-3 Supplementation Beneficial'
      recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              <strong>Triglycerides:</strong> ${tgDisplay} (Borderline High: 150-199 mg/dL) &nbsp;&nbsp;
                              <strong>ASCVD Risk:</strong> ${ascvdDisplay}
                          </p>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Recommended Supplementation:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• EPA/DHA supplementation: 2-3g daily</li>
                                      <li>• Choose high-quality fish oil (third-party tested)</li>
                                      <li>• Take with fat-containing meal for absorption</li>
                                      <li>• Retest lipid panel in 3-6 months</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Dietary Emphasis:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Emphasize fatty fish consumption: salmon, mackerel, sardines (2-3 servings/week)</li>
                                      <li>• Include plant-based omega-3 sources (walnuts, flaxseed)</li>
                                      <li>• Reduce refined carbs to lower triglycerides</li>
                                      <li>• Moderate alcohol intake</li>
                                  </ul>
                              </div>
                          </div>
                          <div class="mt-3 p-2 bg-gray-50 border border-gray-200 rounded">
                              <p class="text-xs text-gray-600">
                                  <strong>Note:</strong> Consult your physician before starting omega-3, especially if taking blood thinners.
                              </p>
                          </div>
      `
      break
      
    case 'dietary_emphasis':
      priorityClass = 'border-green-200'
      iconBg = 'bg-green-100'
      iconColor = 'text-green-600'
      priorityLabel = '✅ MAINTENANCE'
      title = 'Low Cardiovascular Risk - Dietary Omega-3 Adequate'
      recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              <strong>Triglycerides:</strong> ${tgDisplay} (Normal: < 150 mg/dL) &nbsp;&nbsp;
                              <strong>ASCVD Risk:</strong> ${ascvdDisplay} &nbsp;&nbsp;
                              <strong>Omega-3 Index:</strong> ${o3Display}
                          </p>
                          <div class="bg-green-50 border border-green-200 rounded p-3 mb-3">
                              <p class="text-sm font-semibold text-green-800 mb-1">✓ On Track</p>
                              <p class="text-xs text-green-700">Your triglycerides are normal. Continue dietary omega-3 intake.</p>
                          </div>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Dietary Recommendations:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Continue current dietary omega-3 intake (fatty fish 2-3x/week)</li>
                                      <li>• Salmon, mackerel, sardines, anchovies are excellent sources</li>
                                      <li>• Include plant-based sources (walnuts, flaxseed, chia seeds)</li>
                                      <li>• Annual lipid panel recheck recommended</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Optional Supplementation:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Low-dose EPA/DHA supplementation (1g daily) for additional cardiovascular benefit (optional)</li>
                                      <li>• Consider testing Omega-3 Index to confirm adequacy (target >8%)</li>
                                      <li>• If Omega-3 Index < 8%, increase fish intake or add supplements</li>
                                  </ul>
                              </div>
                          </div>
      `
      break
      
    case 'caution':
      priorityClass = 'border-orange-200'
      iconBg = 'bg-orange-100'
      iconColor = 'text-orange-600'
      priorityLabel = '⚠️ CAUTION'
      title = 'Omega-3 Supplementation - Physician Consultation Required'
      recommendations = `
                          <p class="text-sm text-gray-600 mb-3">
                              <strong>Triglycerides:</strong> ${tgDisplay} &nbsp;&nbsp;
                              <strong>ASCVD Risk:</strong> ${ascvdDisplay}
                          </p>
                          <div class="bg-orange-50 border border-orange-200 rounded p-3 mb-3">
                              <p class="text-sm font-semibold text-orange-800 mb-1">⚠️ CAUTION: Medication Interaction Risk</p>
                              <p class="text-xs text-orange-700">Omega-3 at high doses may increase bleeding risk with blood thinners.</p>
                          </div>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Before Starting Omega-3:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• <strong>Discuss with your physician BEFORE starting omega-3</strong></li>
                                      <li>• Review current medications (anticoagulants, antiplatelet agents)</li>
                                      <li>• If approved by physician: Start with lower dose (1-2g daily)</li>
                                      <li>• Monitor for unusual bruising or bleeding</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Monitoring Requirements:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• INR monitoring if on warfarin (omega-3 may potentiate effect)</li>
                                      <li>• Report any unusual bleeding to physician immediately</li>
                                      <li>• Stop omega-3 1-2 weeks before any surgery (discuss with surgeon)</li>
                                      <li>• Dietary omega-3 from fish is generally safer than high-dose supplements</li>
                                  </ul>
                              </div>
                          </div>
                          <div class="mt-3 p-2 bg-orange-50 border border-orange-200 rounded">
                              <p class="text-xs text-orange-700 font-semibold">
                                  ⚠️ IMPORTANT: Do NOT start omega-3 supplementation without physician approval if taking blood thinners.
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
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z"></path>
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
          <p class="text-xs text-gray-500 mt-3 italic">(Preview dynamic - Fix Pack #4)</p>
        </div>
      </div>
    </section>
  `
}

/**
 * Extract all Omega-3 context from comprehensive data structure (report context)
 * Searches multiple nested locations
 * 
 * @param comprehensiveData - Full patient data object
 * @returns Object with extracted values
 */
export function extractOmega3ContextFromComprehensiveData(comprehensiveData: any): {
  triglycerides: number | null
  ascvdRisk: number | null
  omega3Index: number | null
  fishIntake: number | null
  existingOmega3: number | null
  hasContraindication: boolean
  requiresCaution: boolean
} {
  if (!comprehensiveData) {
    return {
      triglycerides: null,
      ascvdRisk: null,
      omega3Index: null,
      fishIntake: null,
      existingOmega3: null,
      hasContraindication: false,
      requiresCaution: false
    }
  }
  
  const biomarkers = comprehensiveData.biomarkers || {}
  const risk = comprehensiveData.risk || {}
  const medicalHistory = comprehensiveData.medicalHistory || {}
  const medications = comprehensiveData.medications || []
  const dietary = comprehensiveData.dietary || {}
  const supplements = comprehensiveData.supplements || []
  
  return {
    triglycerides: extractTriglyceridesFromBiomarkers(biomarkers),
    ascvdRisk: extractASCVDRiskFromCalculation(risk),
    omega3Index: extractOmega3IndexFromBiomarkers(biomarkers),
    fishIntake: extractFishIntakeFromDietary(dietary),
    existingOmega3: extractExistingOmega3Supplementation(supplements),
    hasContraindication: hasOmega3Contraindication(medicalHistory),
    requiresCaution: requiresOmega3Caution(medications)
  }
}

/**
 * Build complete Omega-3 card result with gating logic
 * Main function used by probe endpoint and report generation
 * 
 * @param biomarkers - Biomarker data
 * @param risk - Risk calculation data
 * @param medicalHistory - Medical history
 * @param medications - Current medications
 * @param dietary - Dietary data
 * @param supplements - Current supplements
 * @returns Complete Omega-3 card result
 */
export function buildOmega3CardResult(
  biomarkers: any,
  risk: any,
  medicalHistory: any,
  medications: any[],
  dietary: any,
  supplements: any[]
): Omega3CardResult {
  // Extract values
  const triglycerides = extractTriglyceridesFromBiomarkers(biomarkers)
  const ascvdRisk = extractASCVDRiskFromCalculation(risk)
  const omega3Index = extractOmega3IndexFromBiomarkers(biomarkers)
  const fishIntake = extractFishIntakeFromDietary(dietary)
  const existingOmega3 = extractExistingOmega3Supplementation(supplements)
  const hasContraindication = hasOmega3Contraindication(medicalHistory)
  const requiresCaution = requiresOmega3Caution(medications)
  
  // Check if already taking adequate omega-3
  if (existingOmega3 != null && existingOmega3 >= 2) {
    return {
      shown: false,
      triglycerides,
      ascvdRisk,
      omega3Index,
      tier: 'no_recommendation',
      priority: null,
      html: ''
    }
  }
  
  // Classify tier
  const tier = classifyOmega3Tier(
    triglycerides,
    ascvdRisk,
    omega3Index,
    fishIntake,
    hasContraindication,
    requiresCaution
  )
  
  // Determine if card should be shown
  const shown = shouldShowOmega3Card(tier)
  
  // Map tier to priority label
  let priority: string | null = null
  switch (tier) {
    case 'contraindicated':
      priority = 'CONTRAINDICATION'
      break
    case 'high_priority':
      priority = 'HIGH PRIORITY'
      break
    case 'moderate_priority':
      priority = 'MEDIUM PRIORITY'
      break
    case 'dietary_emphasis':
      priority = 'MAINTENANCE'
      break
    case 'caution':
      priority = 'CAUTION'
      break
  }
  
  // Generate HTML if card should be shown
  const html = shown ? generateOmega3CardHTML(triglycerides, ascvdRisk, omega3Index, tier) : ''
  
  return {
    shown,
    triglycerides,
    ascvdRisk,
    omega3Index,
    tier,
    priority,
    html
  }
}
