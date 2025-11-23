-- Add biological_age table for storing calculated biological age results
CREATE TABLE IF NOT EXISTS biological_age (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  chronological_age REAL NOT NULL,
  phenotypic_age REAL,
  klemera_doubal_age REAL,
  metabolic_age REAL,
  telomere_age REAL,
  average_biological_age REAL NOT NULL,
  age_advantage REAL NOT NULL,
  calculation_method TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_biological_age_session_id ON biological_age(session_id);