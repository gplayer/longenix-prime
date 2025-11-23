-- Add health_optimization_assessments table for storing health optimization assessment results
CREATE TABLE IF NOT EXISTS health_optimization_assessments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  overall_health_score REAL NOT NULL,
  health_span_projection REAL NOT NULL,
  primary_strengths TEXT NOT NULL,
  optimization_opportunities TEXT NOT NULL,
  confidence_level TEXT NOT NULL,
  calculation_date TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);

-- Add health_domains table for storing individual health domain results
CREATE TABLE IF NOT EXISTS health_domains (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  health_optimization_assessment_id INTEGER NOT NULL,
  domain_name TEXT NOT NULL,
  score_percentage REAL NOT NULL,
  confidence_level TEXT NOT NULL,
  markers_available TEXT NOT NULL,
  markers_missing TEXT NOT NULL,
  optimization_level TEXT NOT NULL,
  recommendations TEXT NOT NULL,
  description TEXT NOT NULL,
  algorithm_used TEXT NOT NULL,
  reference TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (health_optimization_assessment_id) REFERENCES health_optimization_assessments(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_health_optimization_assessments_session_id ON health_optimization_assessments(session_id);
CREATE INDEX IF NOT EXISTS idx_health_domains_assessment_id ON health_domains(health_optimization_assessment_id);
CREATE INDEX IF NOT EXISTS idx_health_domains_name ON health_domains(domain_name);