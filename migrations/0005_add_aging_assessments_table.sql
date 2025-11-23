-- Add aging_assessments table for storing aging assessment results
CREATE TABLE IF NOT EXISTS aging_assessments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  overall_aging_score REAL NOT NULL,
  biological_age_acceleration REAL NOT NULL,
  primary_concerns TEXT NOT NULL,
  confidence_level TEXT NOT NULL,
  calculation_date TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);

-- Add aging_hallmarks table for storing individual hallmark results
CREATE TABLE IF NOT EXISTS aging_hallmarks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  aging_assessment_id INTEGER NOT NULL,
  hallmark_name TEXT NOT NULL,
  impact_percentage REAL NOT NULL,
  confidence_level TEXT NOT NULL,
  markers_available TEXT NOT NULL,
  markers_missing TEXT NOT NULL,
  risk_level TEXT NOT NULL,
  description TEXT NOT NULL,
  algorithm_used TEXT NOT NULL,
  reference TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (aging_assessment_id) REFERENCES aging_assessments(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_aging_assessments_session_id ON aging_assessments(session_id);
CREATE INDEX IF NOT EXISTS idx_aging_hallmarks_assessment_id ON aging_hallmarks(aging_assessment_id);
CREATE INDEX IF NOT EXISTS idx_aging_hallmarks_name ON aging_hallmarks(hallmark_name);