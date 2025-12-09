-- Fix alerts table by adding missing columns
USE blood_donation_system1;

-- Add missing columns to alerts table
ALTER TABLE alerts ADD COLUMN IF NOT EXISTS resolution TEXT;
ALTER TABLE alerts ADD COLUMN IF NOT EXISTS escalated_to INT;
ALTER TABLE alerts ADD COLUMN IF NOT EXISTS escalated_at TIMESTAMP NULL;

-- Add foreign key constraints if they don't exist
ALTER TABLE alerts ADD CONSTRAINT fk_alerts_escalated_to FOREIGN KEY (escalated_to) REFERENCES users(id) ON DELETE SET NULL;

-- Verify the table structure
DESCRIBE alerts;

SELECT 'Alerts table fixed successfully!' as Status;