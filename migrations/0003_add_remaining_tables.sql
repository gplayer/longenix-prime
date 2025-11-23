-- Add risk_calculations table for storing risk assessment results
CREATE TABLE IF NOT EXISTS risk_calculations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  risk_category TEXT NOT NULL,
  risk_score REAL NOT NULL,
  risk_level TEXT NOT NULL,
  recommendations TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);

-- Add assessment_data table for storing JSON assessment data
CREATE TABLE IF NOT EXISTS assessment_data (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  data_type TEXT NOT NULL,
  json_data TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_risk_calculations_session_id ON risk_calculations(session_id);
CREATE INDEX IF NOT EXISTS idx_risk_calculations_category ON risk_calculations(risk_category);
CREATE INDEX IF NOT EXISTS idx_assessment_data_session_id ON assessment_data(session_id);
CREATE INDEX IF NOT EXISTS idx_assessment_data_type ON assessment_data(data_type);