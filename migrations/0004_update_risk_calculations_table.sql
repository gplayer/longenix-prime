-- Add missing columns to risk_calculations table
ALTER TABLE risk_calculations ADD COLUMN ten_year_risk REAL;
ALTER TABLE risk_calculations ADD COLUMN algorithm_used TEXT;