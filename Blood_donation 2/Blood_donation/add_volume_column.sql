-- Add volume column to blood_stock table
USE blood_donation_system1;

-- Add volume column with default value of 450.0 ml (standard blood unit)
ALTER TABLE blood_stock ADD COLUMN volume DECIMAL(6,2) DEFAULT 450.0 AFTER quantity;

-- Update existing records to have the default volume
UPDATE blood_stock SET volume = 450.0 WHERE volume IS NULL OR volume = 0;

-- Verify the change
SELECT 'Volume column added successfully!' as Status;
DESCRIBE blood_stock;