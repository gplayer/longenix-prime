import { z } from 'zod'

// Validation schema for comprehensive assessment intake
export const AssessmentIntakeSchema = z.object({
  demographics: z.object({
    fullName: z.string().min(2, 'Full name must be at least 2 characters').max(100),
    dateOfBirth: z.string().refine((date) => {
      const parsed = new Date(date)
      const age = (Date.now() - parsed.getTime()) / (365.25 * 24 * 60 * 60 * 1000)
      return !isNaN(parsed.getTime()) && age >= 18 && age <= 120
    }, 'Invalid date of birth - must be between 18 and 120 years old'),
    gender: z.enum(['male', 'female', 'other']),
    ethnicity: z.string().optional(),
    email: z.string().email('Invalid email format').or(z.literal('')).optional(),
    phone: z.string().optional(),
  }),
  
  clinical: z.object({
    height: z.number().min(50, 'Height must be at least 50 cm').max(300, 'Height cannot exceed 300 cm').optional(),
    weight: z.number().min(20, 'Weight must be at least 20 kg').max(500, 'Weight cannot exceed 500 kg').optional(),
    systolicBP: z.number().min(60).max(250).optional(),
    diastolicBP: z.number().min(40).max(150).optional(),
  }).optional(),
  
  biomarkers: z.object({
    glucose: z.number().min(20).max(600).optional().nullable(),
    hba1c: z.number().min(3).max(20).optional().nullable(),
    totalCholesterol: z.number().min(50).max(500).optional().nullable(),
    hdlCholesterol: z.number().min(10).max(150).optional().nullable(),
    ldlCholesterol: z.number().min(20).max(400).optional().nullable(),
    triglycerides: z.number().min(20).max(1000).optional().nullable(),
    creatinine: z.number().min(0.1).max(15).optional().nullable(),
    albumin: z.number().min(1).max(6).optional().nullable(),
    crp: z.number().min(0).max(100).optional().nullable(),
    wbc: z.number().min(1).max(50).optional().nullable(),
    alp: z.number().min(10).max(500).optional().nullable(),
    lymphocytes: z.number().min(5).max(95).optional().nullable(),
    mcv: z.number().min(50).max(120).optional().nullable(),
    rdw: z.number().min(10).max(25).optional().nullable(),
    hemoglobin: z.number().min(5).max(25).optional().nullable(),
    egfr: z.number().min(5).max(150).optional().nullable(),
  }).optional(),
}).passthrough() // Allow additional fields for backwards compatibility

// Normalize and sanitize validated data
// For minimal payload, preserve optional fields as undefined/empty
export function normalizeAssessmentData(data: z.infer<typeof AssessmentIntakeSchema>) {
  const demo = data.demographics
  const clinical = data.clinical || {}
  const biomarkers = data.biomarkers || {}
  
  return {
    demographics: {
      fullName: demo.fullName.trim(),
      dateOfBirth: new Date(demo.dateOfBirth).toISOString().split('T')[0],
      gender: demo.gender,
      ethnicity: demo.ethnicity?.trim() || 'not_specified',
      email: demo.email?.trim() || '',
      phone: demo.phone?.trim() || '',
    },
    clinical: {
      height: clinical.height,
      weight: clinical.weight,
      systolicBP: clinical.systolicBP,
      diastolicBP: clinical.diastolicBP,
    },
    biomarkers: {
      glucose: biomarkers.glucose ?? null,
      hba1c: biomarkers.hba1c ?? null,
      totalCholesterol: biomarkers.totalCholesterol ?? null,
      hdlCholesterol: biomarkers.hdlCholesterol ?? null,
      ldlCholesterol: biomarkers.ldlCholesterol ?? null,
      triglycerides: biomarkers.triglycerides ?? null,
      creatinine: biomarkers.creatinine ?? null,
      albumin: biomarkers.albumin ?? null,
      crp: biomarkers.crp ?? null,
      wbc: biomarkers.wbc ?? null,
      alp: biomarkers.alp ?? null,
      lymphocytes: biomarkers.lymphocytes ?? null,
      mcv: biomarkers.mcv ?? null,
      rdw: biomarkers.rdw ?? null,
      hemoglobin: biomarkers.hemoglobin ?? null,
      egfr: biomarkers.egfr ?? null,
    },
  }
}

// Format validation errors for API response
export function formatValidationError(error: z.ZodError) {
  return {
    success: false,
    error: 'Validation failed',
    details: error.errors.map(err => {
      // Ensure path is always an array and join with dots
      const fieldPath = Array.isArray(err.path) ? err.path.join('.') : String(err.path || 'unknown')
      return {
        field: fieldPath,
        message: err.message || 'Validation error',
      }
    }),
  }
}
