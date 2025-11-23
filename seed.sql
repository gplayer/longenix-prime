-- LongenixHealth Dynamic Risk Assessment System
-- Seed Data: Reference Ranges and Clinical Algorithms
-- Dr. Graham Player, Ph.D - Longenix Health

-- Insert Reference Ranges for Key Biomarkers
-- Based on clinical guidelines and laboratory standards

-- Lipid Panel
INSERT OR IGNORE INTO reference_ranges (biomarker_name, unit, normal_min, normal_max, optimal_min, optimal_max, source) VALUES
('Total Cholesterol', 'mg/dL', 0, 200, 150, 180, 'AHA/ACC 2018 Guidelines'),
('LDL Cholesterol', 'mg/dL', 0, 130, 70, 100, 'AHA/ACC 2018 Guidelines'),
('HDL Cholesterol', 'mg/dL', 40, 999, 60, 999, 'AHA/ACC 2018 Guidelines'),
('Triglycerides', 'mg/dL', 0, 150, 50, 100, 'AHA/ACC 2018 Guidelines'),
('Non-HDL Cholesterol', 'mg/dL', 0, 160, 100, 130, 'AHA/ACC 2018 Guidelines');

-- Glucose Metabolism
INSERT OR IGNORE INTO reference_ranges (biomarker_name, unit, normal_min, normal_max, optimal_min, optimal_max, source) VALUES
('Fasting Glucose', 'mg/dL', 70, 100, 80, 90, 'ADA 2023 Standards'),
('HbA1c', '%', 4.0, 5.7, 4.5, 5.2, 'ADA 2023 Standards'),
('Fasting Insulin', 'μIU/mL', 2, 20, 3, 8, 'Clinical Chemistry Guidelines'),
('HOMA-IR', 'ratio', 0.5, 2.5, 0.7, 1.5, 'Matthews et al. 1985');

-- Cardiovascular Markers
INSERT OR IGNORE INTO reference_ranges (biomarker_name, unit, normal_min, normal_max, optimal_min, optimal_max, source) VALUES
('C-Reactive Protein', 'mg/L', 0, 3.0, 0, 1.0, 'AHA Scientific Statement'),
('Homocysteine', 'μmol/L', 5, 15, 6, 10, 'European Guidelines'),
('Lipoprotein(a)', 'mg/dL', 0, 30, 0, 20, 'ESC/EAS Guidelines 2019'),
('Apolipoprotein B', 'mg/dL', 60, 130, 70, 100, 'Lipid Guidelines');

-- Inflammatory Markers
INSERT OR IGNORE INTO reference_ranges (biomarker_name, unit, normal_min, normal_max, optimal_min, optimal_max, source) VALUES
('IL-6', 'pg/mL', 0, 7, 0, 3, 'Clinical Laboratory Standards'),
('TNF-alpha', 'pg/mL', 0, 15, 0, 8, 'Clinical Laboratory Standards'),
('ESR', 'mm/hr', 0, 20, 2, 15, 'International Guidelines');

-- Liver Function
INSERT OR IGNORE INTO reference_ranges (biomarker_name, unit, normal_min, normal_max, optimal_min, optimal_max, source) VALUES
('ALT', 'U/L', 7, 40, 10, 25, 'AASLD Guidelines'),
('AST', 'U/L', 8, 40, 10, 30, 'AASLD Guidelines'),
('GGT', 'U/L', 9, 48, 10, 30, 'Clinical Chemistry References'),
('Bilirubin Total', 'mg/dL', 0.2, 1.2, 0.3, 1.0, 'Laboratory Medicine');

-- Kidney Function
INSERT OR IGNORE INTO reference_ranges (biomarker_name, unit, normal_min, normal_max, optimal_min, optimal_max, source) VALUES
('Creatinine', 'mg/dL', 0.6, 1.2, 0.7, 1.0, 'KDIGO 2012 Guidelines'),
('eGFR', 'mL/min/1.73m²', 90, 999, 100, 999, 'KDIGO 2012 Guidelines'),
('BUN', 'mg/dL', 7, 20, 8, 15, 'Clinical Chemistry Standards'),
('Uric Acid', 'mg/dL', 3.5, 7.2, 4.0, 6.0, 'Rheumatology Guidelines');

-- Vitamins and Nutrients
INSERT OR IGNORE INTO reference_ranges (biomarker_name, unit, normal_min, normal_max, optimal_min, optimal_max, source) VALUES
('Vitamin D', 'ng/mL', 30, 100, 40, 80, 'Endocrine Society 2011'),
('Vitamin B12', 'pg/mL', 200, 900, 400, 800, 'WHO/FAO Guidelines'),
('Folate', 'ng/mL', 2.7, 17.0, 5.0, 15.0, 'CDC Guidelines'),
('Iron', 'μg/dL', 60, 170, 80, 150, 'WHO Iron Guidelines'),
('Ferritin', 'ng/mL', 15, 150, 30, 120, 'Iron Disorders Institute');

-- Hormones
INSERT OR IGNORE INTO reference_ranges (biomarker_name, unit, normal_min, normal_max, optimal_min, optimal_max, source) VALUES
('TSH', 'mIU/L', 0.4, 4.0, 1.0, 3.0, 'ATA Guidelines 2014'),
('Free T4', 'ng/dL', 0.8, 1.8, 1.0, 1.6, 'Thyroid Guidelines'),
('Free T3', 'pg/mL', 2.3, 4.2, 2.8, 4.0, 'Endocrine Guidelines'),
('Cortisol AM', 'μg/dL', 6.2, 19.4, 8.0, 16.0, 'Endocrine Society');

-- Complete Blood Count
INSERT OR IGNORE INTO reference_ranges (biomarker_name, unit, normal_min, normal_max, optimal_min, optimal_max, source) VALUES
('Hemoglobin', 'g/dL', 12.0, 16.0, 13.0, 15.0, 'WHO Anemia Guidelines'),
('Hematocrit', '%', 36, 48, 38, 45, 'Hematology References'),
('White Blood Cells', 'K/μL', 4.5, 11.0, 5.0, 9.0, 'Clinical Hematology'),
('Platelets', 'K/μL', 150, 450, 200, 400, 'Hemostasis Guidelines');

-- Clinical Risk Algorithms
INSERT OR IGNORE INTO risk_algorithms (
  algorithm_name, 
  risk_category, 
  formula_description,
  required_parameters,
  validation_study,
  population_applicability,
  accuracy_metrics,
  implementation_notes
) VALUES 

-- Cardiovascular Risk Algorithms
(
  'ASCVD Risk Calculator',
  'cardiovascular',
  '10-year atherosclerotic cardiovascular disease risk based on pooled cohort equations',
  '["age", "gender", "race", "total_cholesterol", "hdl_cholesterol", "systolic_bp", "bp_medication", "diabetes", "smoking"]',
  'Goff DC Jr et al. 2013 ACC/AHA Guideline',
  'Adults 40-79 years, US population',
  'C-statistic: 0.713-0.745',
  'Validated for primary prevention in non-Hispanic whites and African Americans'
),

(
  'Framingham Risk Score',
  'cardiovascular',
  'Traditional 10-year CHD risk calculation',
  '["age", "gender", "total_cholesterol", "hdl_cholesterol", "systolic_bp", "smoking", "diabetes"]',
  'Wilson PWF et al. Circulation 1998',
  'Adults 30-74 years, primarily Caucasian',
  'C-statistic: 0.63-0.79',
  'Original cardiovascular risk algorithm, may underestimate risk in some populations'
),

-- Diabetes Risk Algorithms  
(
  'FINDRISC Score',
  'diabetes',
  'Finnish Diabetes Risk Score for Type 2 diabetes prediction',
  '["age", "bmi", "waist_circumference", "physical_activity", "vegetables", "bp_medication", "glucose_history", "family_history"]',
  'Lindström J et al. Diabetes Care 2003',
  'European population, 35-64 years',
  'AUC: 0.85, Sensitivity: 78%, Specificity: 77%',
  'Score ≥15 indicates high risk, validated in multiple populations'
),

-- Biological Age Algorithms
(
  'Phenotypic Age',
  'biological_aging',
  'Mortality-based biological age using clinical biomarkers',
  '["chronological_age", "albumin", "creatinine", "glucose", "crp", "lymphocyte_percent", "mcv", "rdw", "alp", "wbc"]',
  'Levine ME et al. Aging 2018',
  'Adults 20+ years, NHANES population',
  'Correlation with mortality: HR 1.13 per year',
  'Strong predictor of healthspan and mortality risk'
),

(
  'Klemera-Doubal Method',
  'biological_aging',
  'Linear regression approach using multiple biomarkers',
  '["chronological_age", "systolic_bp", "creatinine", "urea", "cholesterol", "glucose", "albumin", "hemoglobin"]',
  'Klemera P & Doubal S. Mech Ageing Dev 2006',
  'General adult population',
  'Strong correlation with chronological age (r>0.9)',
  'Requires minimum 4 biomarkers for reliable calculation'
),

-- Metabolic Health
(
  'Metabolic Syndrome Criteria',
  'metabolic',
  'ATP III criteria for metabolic syndrome diagnosis',
  '["waist_circumference", "triglycerides", "hdl_cholesterol", "blood_pressure", "fasting_glucose"]',
  'NCEP ATP III 2001, Updated AHA/NHLBI 2005',
  'Adults 20+ years',
  'Predictive of diabetes (RR 5.0) and CVD (RR 2.0)',
  'Requires 3 of 5 criteria for diagnosis'
),

-- Inflammation Assessment
(
  'Inflammation Score',
  'inflammation',
  'Composite inflammatory burden based on multiple markers',
  '["crp", "il6", "tnf_alpha", "fibrinogen", "wbc", "neutrophil_lymphocyte_ratio"]',
  'Emerging research, multiple studies',
  'General adult population',
  'Associated with chronic disease risk',
  'Higher scores indicate increased inflammatory burden'
),

-- Liver Health
(
  'Fatty Liver Index',
  'liver_health',
  'Non-invasive assessment of hepatic steatosis',
  '["bmi", "waist_circumference", "triglycerides", "ggt"]',
  'Bedogni G et al. BMC Gastroenterol 2006',
  'Adults 20-65 years',
  'AUC: 0.84, Cutoff ≥60 for fatty liver',
  'Validated alternative to ultrasound for fatty liver screening'
);

-- Demo Patient Data (Sarah Johnson equivalent for testing)
INSERT OR IGNORE INTO patients (
  full_name, date_of_birth, gender, ethnicity, email, phone, country
) VALUES (
  'Demo Patient', '1978-05-15', 'female', 'caucasian', 'demo@longenix.health', '+1-555-DEMO', 'US'
);

-- Sample Assessment Session
INSERT OR IGNORE INTO assessment_sessions (
  patient_id, session_type, status, completed_at
) VALUES (
  1, 'demo', 'completed', datetime('now')
);

-- Sample Biometric Data
INSERT OR IGNORE INTO biometrics (
  session_id, height_cm, weight_kg, waist_circumference_cm, hip_circumference_cm, 
  systolic_bp, diastolic_bp, resting_heart_rate
) VALUES (
  1, 165, 68, 82, 95, 118, 75, 65
);

-- Sample Lab Results (Key biomarkers)
INSERT OR IGNORE INTO lab_results (session_id, biomarker_name, value, unit, interpretation) VALUES
(1, 'Total Cholesterol', 185, 'mg/dL', 'normal'),
(1, 'LDL Cholesterol', 105, 'mg/dL', 'normal'),
(1, 'HDL Cholesterol', 62, 'mg/dL', 'normal'),
(1, 'Triglycerides', 95, 'mg/dL', 'normal'),
(1, 'Fasting Glucose', 88, 'mg/dL', 'normal'),
(1, 'HbA1c', 5.1, '%', 'normal'),
(1, 'C-Reactive Protein', 0.8, 'mg/L', 'normal'),
(1, 'Vitamin D', 38, 'ng/mL', 'normal'),
(1, 'TSH', 2.1, 'mIU/L', 'normal'),
(1, 'Creatinine', 0.9, 'mg/dL', 'normal');