-- Fix alerts table severity column to include URGENT
USE blood_donation_system1;

-- Modify the severity enum to include URGENT
ALTER TABLE alerts MODIFY COLUMN severity ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL', 'URGENT') NOT NULL DEFAULT 'MEDIUM';

-- Verify the change
DESCRIBE alerts;

SELECT 'Alerts severity column updated successfully!' as Status;