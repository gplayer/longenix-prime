/**
 * Dev/Sandbox Helper Module
 * PREVIEW ONLY: Safe experimentation helpers with zero side effects
 * 
 * Purpose: Provide utilities for testing and development without touching
 * production code, database, or medical calculators.
 */

/**
 * Safe JSON parsing with error handling
 * @param text - Raw text to parse
 * @returns Parsed object or null on error
 */
export function safeJSONParse(text: string): any | null {
  try {
    return JSON.parse(text)
  } catch (error) {
    return null
  }
}

/**
 * Safe logger for development (does not write to DB)
 * @param message - Log message
 * @param data - Optional data to log
 */
export function devLog(message: string, data?: any): void {
  const timestamp = new Date().toISOString()
  console.log(`[DEV ${timestamp}] ${message}`, data ? JSON.stringify(data, null, 2) : '')
}

/**
 * Echo received data (for testing payload handling)
 * @param input - Input data to echo
 * @returns Echo response with metadata
 */
export function echoPayload(input: any): { received: any; timestamp: string } {
  return {
    received: input,
    timestamp: new Date().toISOString()
  }
}

/**
 * Validate demo payload structure
 * @param payload - Payload to validate
 * @returns Validation result
 */
export function validateDemoPayload(payload: any): {
  valid: boolean
  errors: Array<{ field: string; message: string }>
} {
  const errors: Array<{ field: string; message: string }> = []
  
  if (typeof payload.demo !== 'number') {
    errors.push({ field: 'demo', message: 'Field "demo" must be a number' })
  }
  
  if (payload.note !== undefined && typeof payload.note !== 'string') {
    errors.push({ field: 'note', message: 'Field "note" must be a string if provided' })
  }
  
  return {
    valid: errors.length === 0,
    errors
  }
}
