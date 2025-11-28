/**
 * ldl-dynamic.ts - Shared LDL Dynamic Recommendation Logic
 * 
 * This module provides pure functions for:
 * - Extracting LDL cholesterol values from various data structures
 * - Extracting ASCVD risk scores
 * - Computing dynamic LDL targets based on cardiovascular risk
 * - Generating LDL recommendation cards
 * 
 * Used by:
 * - Preview probe endpoint (POST /api/report/preview/ldl)
 * - Main report LDL card generation (GET /report)
 */

/**
 * LDL target thresholds based on ASCVD risk levels
 */
export const LDL_TARGETS = {
  VERY_HIGH_RISK: 70,    // ASCVD >= 20%
  HIGH_RISK: 100,        // ASCVD >= 7.5%
  LOW_RISK: 130          // ASCVD < 7.5% or unknown
} as const

/**
 * Gating threshold for showing LDL card
 */
export const LDL_GATE_THRESHOLD = 100      // Show if LDL > 100 mg/dL
export const ASCVD_GATE_THRESHOLD = 0.075  // Show if ASCVD >= 7.5%

/**
 * ASCVD risk thresholds for target computation
 */
export const ASCVD_VERY_HIGH_THRESHOLD = 0.20  // >= 20%
export const ASCVD_HIGH_THRESHOLD = 0.075      // >= 7.5%

/**
 * Risk level to numeric score mapping (fallback)
 */
export const RISK_LEVEL_MAP: Record<string, number> = {
  'low': 0.05,
  'moderate': 0.10,
  'high': 0.15,
  'very_high': 0.25
}

/**
 * Result structure for LDL card generation
 */
export interface LDLCardResult {
  shown: boolean
  ldlValue: number | null
  ascvdRisk: number | null
  ldlTarget: number | null
  html: string
}

/**
 * Extract LDL cholesterol value from a biomarkers object
 * Probes multiple common key variants
 * 
 * @param biomarkers - Object containing biomarker data
 * @returns LDL value in mg/dL or null if not found
 */
export function extractLDLValue(biomarkers: any): number | null {
  if (!biomarkers || typeof biomarkers !== 'object') return null
  
  // Probe common LDL keys in order of preference
  const ldlKeys = ['ldl', 'ldl_c', 'ldlCholesterol', 'ldl_cholesterol', 'LDL']
  
  for (const key of ldlKeys) {
    const value = biomarkers[key]
    if (value != null && !isNaN(Number(value))) {
      return Number(value)
    }
  }
  
  return null
}

/**
 * Extract LDL value from comprehensive data structure (report context)
 * Searches multiple nested locations: biomarkers, clinical, root
 * 
 * @param comprehensiveData - Full patient data object
 * @returns LDL value in mg/dL or null if not found
 */
export function extractLDLValueFromComprehensiveData(comprehensiveData: any): number | null {
  if (!comprehensiveData) return null
  
  // Probe common LDL keys in order of preference
  const ldlKeys = ['ldlCholesterol', 'ldl_cholesterol', 'ldl', 'ldl_c', 'LDL']
  
  // Check biomarkers object first
  if (comprehensiveData.biomarkers) {
    for (const key of ldlKeys) {
      const value = comprehensiveData.biomarkers[key]
      if (value != null && !isNaN(Number(value))) {
        return Number(value)
      }
    }
  }
  
  // Check clinical object
  if (comprehensiveData.clinical) {
    for (const key of ldlKeys) {
      const value = comprehensiveData.clinical[key]
      if (value != null && !isNaN(Number(value))) {
        return Number(value)
      }
    }
  }
  
  // Check root level
  for (const key of ldlKeys) {
    const value = comprehensiveData[key]
    if (value != null && !isNaN(Number(value))) {
      return Number(value)
    }
  }
  
  return null
}

/**
 * Extract ASCVD risk score from a risk object
 * Coerces percentages (>1) to decimal (e.g., 9 → 0.09)
 * Falls back to risk_level mapping if numeric score not available
 * 
 * @param riskObj - Object containing ASCVD risk data
 * @returns ASCVD risk as decimal (0-1 range) or null if not found
 */
export function extractASCVDRisk(riskObj: any): number | null {
  if (!riskObj || typeof riskObj !== 'object') return null
  
  const riskKeys = ['ascvd', 'ascvd_risk', 'ASCVD']
  
  for (const key of riskKeys) {
    let value = riskObj[key]
    if (value != null && !isNaN(Number(value))) {
      value = Number(value)
      // If value > 1, assume it's a percentage and convert to decimal (e.g., 9 → 0.09)
      if (value > 1) {
        value = value / 100
      }
      return value
    }
  }
  
  // Fallback: check risk_level
  if (riskObj.risk_level) {
    return RISK_LEVEL_MAP[riskObj.risk_level] || null
  }
  
  return null
}

/**
 * Extract ASCVD risk from calculated risks array (report context)
 * Searches for cardiovascular risk entry in risks.results
 * 
 * @param risks - Risks calculation object with results array
 * @returns ASCVD risk as decimal (0-1 range) or null if not found
 */
export function extractASCVDRiskFromResults(risks: any): number | null {
  if (!risks || !risks.results || risks.results.length === 0) return null
  
  // Find cardiovascular risk entry
  const cvdRisk = risks.results.find((r: any) => 
    r.category === 'cardiovascular' || r.category === 'ascvd' || r.category === 'cvd'
  )
  
  if (!cvdRisk) return null
  
  // Try to extract numeric risk score (typically 0-1 range representing percentage)
  if (cvdRisk.risk_score != null && !isNaN(Number(cvdRisk.risk_score))) {
    return Number(cvdRisk.risk_score)
  }
  
  // Fallback: map risk_level to proxy numeric value
  return RISK_LEVEL_MAP[cvdRisk.risk_level] || null
}

/**
 * Compute dynamic LDL target based on ASCVD risk level
 * 
 * Targets:
 * - ASCVD >= 20% → <70 mg/dL (very high risk)
 * - ASCVD >= 7.5% → <100 mg/dL (moderate-high risk)
 * - ASCVD < 7.5% or unknown → <130 mg/dL (low risk)
 * 
 * @param ascvdRisk - ASCVD risk as decimal (0-1 range) or null
 * @returns LDL target in mg/dL
 */
export function computeLDLTarget(ascvdRisk: number | null): number {
  if (ascvdRisk != null) {
    if (ascvdRisk >= ASCVD_VERY_HIGH_THRESHOLD) {
      return LDL_TARGETS.VERY_HIGH_RISK  // <70 mg/dL
    } else if (ascvdRisk >= ASCVD_HIGH_THRESHOLD) {
      return LDL_TARGETS.HIGH_RISK  // <100 mg/dL
    }
  }
  return LDL_TARGETS.LOW_RISK  // <130 mg/dL (default)
}

/**
 * Determine if LDL card should be shown based on gating criteria
 * 
 * Gate: Show card ONLY if LDL > 100 OR ASCVD risk >= 7.5%
 * 
 * @param ldlValue - LDL cholesterol in mg/dL or null
 * @param ascvdRisk - ASCVD risk as decimal (0-1) or null
 * @returns true if card should be shown, false otherwise
 */
export function shouldShowLDLCard(ldlValue: number | null, ascvdRisk: number | null): boolean {
  return ldlValue != null && (ldlValue > LDL_GATE_THRESHOLD || (ascvdRisk != null && ascvdRisk >= ASCVD_GATE_THRESHOLD))
}

/**
 * Generate HTML for LDL recommendation card
 * 
 * @param ldlValue - Current LDL value in mg/dL
 * @param ldlTarget - Target LDL in mg/dL
 * @returns HTML string for the card
 */
export function generateLDLCardHTML(ldlValue: number, ldlTarget: number): string {
  return `
              <section data-test="ldl-card" class="bg-white rounded-lg p-4 border border-red-200">
                  <div class="flex items-start">
                      <div class="bg-red-100 p-2 rounded-full mr-4 mt-1">
                          <i class="fas fa-heartbeat text-red-600"></i>
                      </div>
                      <div class="flex-1">
                          <h4 class="font-semibold text-gray-800 mb-2">LDL Cholesterol Optimization <span class="text-xs text-blue-600">(Preview dynamic)</span></h4>
                          <p class="text-sm text-gray-600 mb-3">
                              Current LDL: <strong>${Math.round(ldlValue)} mg/dL</strong> | 
                              Target LDL: <strong>&lt;${ldlTarget} mg/dL</strong>
                              <span class="text-xs italic">(target depends on overall ASCVD risk)</span>
                          </p>
                          <div class="grid md:grid-cols-2 gap-4">
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Nutritional Interventions:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Increase soluble fiber intake (oats, beans, apples)</li>
                                      <li>• Add plant sterols/stanols</li>
                                      <li>• Replace saturated fats with monounsaturated fats</li>
                                      <li>• Include fatty fish 2-3 times per week</li>
                                  </ul>
                              </div>
                              <div>
                                  <p class="text-sm font-medium text-gray-700 mb-2">Options to Discuss with Your Clinician:</p>
                                  <ul class="text-xs text-gray-600 space-y-1">
                                      <li>• Bergamot extract</li>
                                      <li>• Psyllium husk fiber</li>
                                      <li>• Omega-3 fatty acids (EPA/DHA)</li>
                                      <li>• Lifestyle optimization strategies</li>
                                  </ul>
                                  <p class="text-xs text-gray-500 italic mt-2">Note: Dosing and suitability vary by individual health status.</p>
                              </div>
                          </div>
                      </div>
                  </div>
              </section>
      `.trim()
}

/**
 * Build complete LDL card result with gating logic
 * This is the main function used by both probe endpoint and report
 * 
 * @param ldlValue - LDL cholesterol in mg/dL or null
 * @param ascvdRisk - ASCVD risk as decimal (0-1) or null
 * @returns Complete LDL card result object
 */
export function buildLDLCardResult(ldlValue: number | null, ascvdRisk: number | null): LDLCardResult {
  const shouldShow = shouldShowLDLCard(ldlValue, ascvdRisk)
  
  if (!shouldShow) {
    return {
      shown: false,
      ldlValue: ldlValue,
      ascvdRisk: ascvdRisk,
      ldlTarget: null,
      html: ''
    }
  }
  
  const ldlTarget = computeLDLTarget(ascvdRisk)
  const html = generateLDLCardHTML(ldlValue!, ldlTarget)
  
  return {
    shown: true,
    ldlValue: ldlValue,
    ascvdRisk: ascvdRisk,
    ldlTarget: ldlTarget,
    html: html
  }
}
