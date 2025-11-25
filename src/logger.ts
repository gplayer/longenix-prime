// Lightweight server-side logging utility
// No PHI, no secret values, anonymized identifiers only

export type LogLevel = 'debug' | 'info' | 'warn' | 'error'

interface RequestLog {
  route: string
  method: string
  duration_ms: number
  rows_returned?: number
  status?: number
}

interface ErrorLog {
  route: string
  error_name: string
  fingerprint: string
  stack_excerpt: string
  status?: number
}

class Logger {
  private level: LogLevel
  
  constructor(level: LogLevel = 'info') {
    this.level = level
  }
  
  private shouldLog(level: LogLevel): boolean {
    const levels: LogLevel[] = ['debug', 'info', 'warn', 'error']
    return levels.indexOf(level) >= levels.indexOf(this.level)
  }
  
  private anonymize(value: string): string {
    // Hash or truncate identifiers to prevent PHI leakage
    return value.substring(0, 8) + '...'
  }
  
  logRequest(data: RequestLog) {
    if (!this.shouldLog('info')) return
    
    console.log(JSON.stringify({
      type: 'request',
      timestamp: new Date().toISOString(),
      ...data,
    }))
  }
  
  logError(data: ErrorLog) {
    if (!this.shouldLog('error')) return
    
    console.error(JSON.stringify({
      type: 'error',
      timestamp: new Date().toISOString(),
      ...data,
    }))
  }
  
  warn(message: string, context?: Record<string, any>) {
    if (!this.shouldLog('warn')) return
    
    console.warn(JSON.stringify({
      type: 'warn',
      timestamp: new Date().toISOString(),
      message,
      ...context,
    }))
  }
  
  info(message: string, context?: Record<string, any>) {
    if (!this.shouldLog('info')) return
    
    console.log(JSON.stringify({
      type: 'info',
      timestamp: new Date().toISOString(),
      message,
      ...context,
    }))
  }
  
  debug(message: string, context?: Record<string, any>) {
    if (!this.shouldLog('debug')) return
    
    console.log(JSON.stringify({
      type: 'debug',
      timestamp: new Date().toISOString(),
      message,
      ...context,
    }))
  }
}

// Export singleton instance
export const logger = new Logger(
  (typeof process !== 'undefined' && process.env?.LOG_LEVEL as LogLevel) || 'info'
)

// Utility to create error fingerprint (for grouping similar errors)
export function createErrorFingerprint(error: Error, route: string): string {
  const parts = [
    error.name,
    route,
    error.message.split(':')[0], // First part of message only
  ]
  return Buffer.from(parts.join('|')).toString('base64').substring(0, 12)
}

// Utility to extract safe stack excerpt (no line numbers that could reveal code structure)
export function getStackExcerpt(error: Error): string {
  if (!error.stack) return 'No stack trace'
  
  const lines = error.stack.split('\n')
  const relevant = lines.slice(0, 3).map(line => {
    // Remove file paths and line numbers
    return line.replace(/\(.*:\d+:\d+\)/, '(...)').replace(/at.*\//, 'at ')
  })
  
  return relevant.join(' | ')
}
