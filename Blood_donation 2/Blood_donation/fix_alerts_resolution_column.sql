-- Fix for "Data truncated for column 'resolution' at row 1" error
-- This script adds the missing 'resolution' column to the alerts table

USE blood_donation_system1;

-- Add the missing resolution column to the alerts table
ALTER TABLE alerts ADD COLUMN resolution TEXT;

-- Verify the column was added
DESCRIBE alerts;

-- Show success message
SELECT 'Resolution column added successfully to alerts table!' as Status;