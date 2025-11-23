-- Patients table
CREATE TABLE IF NOT EXISTS patients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name TEXT NOT NULL,
  date_of_birth DATE NOT NULL,
  gender TEXT NOT NULL,
  ethnicity TEXT DEFAULT 'not_specified',
  email TEXT UNIQUE NOT NULL,
  phone TEXT,
  country TEXT DEFAULT 'US',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Assessment sessions table
CREATE TABLE IF NOT EXISTS assessment_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  patient_id INTEGER NOT NULL,
  session_type TEXT NOT NULL DEFAULT 'standard',
  status TEXT NOT NULL DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
);

-- Clinical assessments table
CREATE TABLE IF NOT EXISTS clinical_assessments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  height_cm REAL,
  weight_kg REAL,
  systolic_bp INTEGER,
  diastolic_bp INTEGER,
  heart_rate INTEGER,
  temperature REAL,
  bmi REAL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);

-- Biomarkers table
CREATE TABLE IF NOT EXISTS biomarkers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  biomarker_name TEXT NOT NULL,
  value REAL NOT NULL,
  unit TEXT,
  reference_range TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);

-- Lifestyle assessments table
CREATE TABLE IF NOT EXISTS lifestyle_assessments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  assessment_type TEXT NOT NULL,
  question_key TEXT NOT NULL,
  response TEXT NOT NULL,
  score INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);

-- Assessment reports table
CREATE TABLE IF NOT EXISTS assessment_reports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  report_data TEXT NOT NULL,
  chronological_age REAL,
  biological_age REAL,
  phenotypic_age REAL,
  kd_biological_age REAL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);

-- Comprehensive assessments table for storing JSON data
CREATE TABLE IF NOT EXISTS comprehensive_assessments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  assessment_data TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_patients_email ON patients(email);
CREATE INDEX IF NOT EXISTS idx_sessions_patient_id ON assessment_sessions(patient_id);
CREATE INDEX IF NOT EXISTS idx_clinical_session_id ON clinical_assessments(session_id);
CREATE INDEX IF NOT EXISTS idx_biomarkers_session_id ON biomarkers(session_id);
CREATE INDEX IF NOT EXISTS idx_biomarkers_name ON biomarkers(biomarker_name);
CREATE INDEX IF NOT EXISTS idx_lifestyle_session_id ON lifestyle_assessments(session_id);
CREATE INDEX IF NOT EXISTS idx_lifestyle_type ON lifestyle_assessments(assessment_type);
CREATE INDEX IF NOT EXISTS idx_reports_session_id ON assessment_reports(session_id);
CREATE INDEX IF NOT EXISTS idx_comprehensive_session_id ON comprehensive_assessments(session_id);