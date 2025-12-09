-- =====================================================
-- FINAL COMPLETE BLOOD DONATION SYSTEM DATABASE SCHEMA
-- =====================================================
-- This is the complete, final database schema for the Blood Donation System
-- Includes all tables, columns, indexes, and sample data needed for full functionality

-- Drop database if exists (optional - remove if you want to keep existing data)
-- DROP DATABASE IF EXISTS blood_donation_system1;

-- Create database
CREATE DATABASE IF NOT EXISTS blood_donation_system1;
USE blood_donation_system1;

-- =====================================================
-- CORE USER MANAGEMENT TABLES
-- =====================================================

-- Users table - Main authentication and role management
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('DONOR', 'HOSPITAL', 'MANAGER', 'MEDICAL_STAFF', 'DONOR_RELATION', 'HOSPITAL_COORDINATOR') NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    status ENUM('ACTIVE', 'INACTIVE', 'LOCKED', 'SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_status (status)
);

-- Donors table - Detailed donor information
CREATE TABLE IF NOT EXISTS donors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender ENUM('MALE', 'FEMALE', 'OTHER') NOT NULL,
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    weight DECIMAL(5,2) NOT NULL,
    height DECIMAL(5,2),
    health_info TEXT,
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    postal_code VARCHAR(20),
    medical_conditions TEXT,
    medications TEXT,
    last_donation_date DATE,
    next_eligible_date DATE,
    total_donations INT DEFAULT 0,
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'SUSPENDED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_blood_group (blood_group),
    INDEX idx_status (status),
    INDEX idx_last_donation (last_donation_date)
);

-- =====================================================
-- BLOOD MANAGEMENT TABLES
-- =====================================================

-- Blood stock table - Inventory management
CREATE TABLE IF NOT EXISTS blood_stock (
    id INT PRIMARY KEY AUTO_INCREMENT,
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    expiry_date DATE NOT NULL,
    collection_date DATE,
    donor_id INT,
    batch_number VARCHAR(50),
    storage_location VARCHAR(100),
    temperature DECIMAL(4,2),
    status ENUM('AVAILABLE', 'RESERVED', 'EXPIRED', 'DISCARDED') DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (donor_id) REFERENCES donors(id) ON DELETE SET NULL,
    INDEX idx_blood_group (blood_group),
    INDEX idx_expiry_date (expiry_date),
    INDEX idx_status (status),
    INDEX idx_collection_date (collection_date)
);

-- Blood requests table - Hospital requests for blood
CREATE TABLE IF NOT EXISTS blood_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    hospital_id INT NOT NULL,
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    quantity INT NOT NULL,
    urgency ENUM('NORMAL', 'URGENT', 'CRITICAL') DEFAULT 'NORMAL',
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'ON_HOLD', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    priority INT DEFAULT 0,
    patient_name VARCHAR(100),
    patient_info TEXT,
    medical_condition TEXT,
    doctor_name VARCHAR(100),
    doctor_contact VARCHAR(20),
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    required_date DATE,
    approved_by INT,
    approved_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    notes TEXT,
    FOREIGN KEY (hospital_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_hospital_id (hospital_id),
    INDEX idx_blood_group (blood_group),
    INDEX idx_status (status),
    INDEX idx_urgency (urgency),
    INDEX idx_request_date (request_date)
);

-- =====================================================
-- APPOINTMENT AND CAMP MANAGEMENT
-- =====================================================

-- Donation camps table - Blood donation camps
CREATE TABLE IF NOT EXISTS donation_camps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    camp_name VARCHAR(100) NOT NULL,
    location VARCHAR(200) NOT NULL,
    address TEXT,
    city VARCHAR(100),
    camp_date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    max_donors INT DEFAULT 50,
    current_donors INT DEFAULT 0,
    organizer_id INT,
    status ENUM('PLANNED', 'ACTIVE', 'COMPLETED', 'CANCELLED') DEFAULT 'PLANNED',
    description TEXT,
    special_requirements TEXT,
    contact_person VARCHAR(100),
    contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (organizer_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_camp_date (camp_date),
    INDEX idx_status (status),
    INDEX idx_location (location)
);

-- Appointments table - Donor appointments
CREATE TABLE IF NOT EXISTS appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT NOT NULL,
    camp_id INT,
    appointment_date DATE NOT NULL,
    time_slot VARCHAR(20),
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED', 'COMPLETED', 'NO_SHOW') DEFAULT 'PENDING',
    appointment_type ENUM('REGULAR', 'EMERGENCY', 'PLASMA', 'PLATELET') DEFAULT 'REGULAR',
    medical_staff_id INT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (donor_id) REFERENCES donors(id) ON DELETE CASCADE,
    FOREIGN KEY (camp_id) REFERENCES donation_camps(id) ON DELETE SET NULL,
    FOREIGN KEY (medical_staff_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_donor_id (donor_id),
    INDEX idx_appointment_date (appointment_date),
    INDEX idx_status (status),
    INDEX idx_camp_id (camp_id)
);

-- =====================================================
-- MEDICAL AND TESTING TABLES
-- =====================================================

-- Blood reports table - Medical test results
CREATE TABLE IF NOT EXISTS blood_reports (
    id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT NOT NULL,
    appointment_id INT,
    hemoglobin DECIMAL(4,2),
    rbc DECIMAL(4,2),
    hct DECIMAL(4,2),
    mcv DECIMAL(4,2),
    mch DECIMAL(4,2),
    mchc DECIMAL(4,2),
    rdw DECIMAL(4,2),
    wbc DECIMAL(4,2),
    esr DECIMAL(4,2),
    plt DECIMAL(4,2),
    gra DECIMAL(4,2),
    lym DECIMAL(4,2),
    eos DECIMAL(4,2),
    bas DECIMAL(4,2),
    blood_pressure_systolic INT,
    blood_pressure_diastolic INT,
    pulse_rate INT,
    temperature DECIMAL(4,2),
    weight_at_donation DECIMAL(5,2),
    donation_volume INT,
    medical_staff_notes TEXT,
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'REQUIRES_FOLLOWUP') DEFAULT 'PENDING',
    tested_by INT,
    tested_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (donor_id) REFERENCES donors(id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL,
    FOREIGN KEY (tested_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_donor_id (donor_id),
    INDEX idx_status (status),
    INDEX idx_tested_at (tested_at)
);

-- =====================================================
-- COMMUNICATION AND FEEDBACK TABLES
-- =====================================================

-- Feedback table - User feedback and complaints
CREATE TABLE IF NOT EXISTS feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    subject VARCHAR(255),
    feedback_text TEXT NOT NULL,
    category ENUM('GENERAL', 'COMPLAINT', 'SUGGESTION', 'URGENT', 'BUG_REPORT', 'FEATURE_REQUEST') DEFAULT 'GENERAL',
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
    status ENUM('PENDING', 'RESPONDED', 'ESCALATED', 'RESOLVED', 'CLOSED') DEFAULT 'PENDING',
    response TEXT,
    responded_by INT,
    response_date TIMESTAMP NULL,
    resolved_by INT,
    resolved_at TIMESTAMP NULL,
    escalated_to INT,
    escalated_at TIMESTAMP NULL,
    is_urgent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (responded_by) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (resolved_by) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (escalated_to) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_priority (priority),
    INDEX idx_category (category),
    INDEX idx_created_at (created_at)
);

-- Notifications table - System notifications
CREATE TABLE IF NOT EXISTS notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('APPOINTMENT', 'REMINDER', 'REQUEST', 'SYSTEM', 'ALERT', 'PROMOTION') DEFAULT 'SYSTEM',
    channel ENUM('EMAIL', 'SMS', 'IN_APP', 'PUSH') DEFAULT 'IN_APP',
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP NULL,
    expires_at TIMESTAMP NULL,
    action_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_type (type),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at)
);

-- =====================================================
-- SYSTEM MANAGEMENT TABLES
-- =====================================================

-- Alerts table - System alerts and warnings
CREATE TABLE IF NOT EXISTS alerts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type ENUM('SYSTEM', 'STOCK', 'EXPIRY', 'MAINTENANCE', 'SECURITY', 'PERFORMANCE') NOT NULL,
    severity ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') NOT NULL DEFAULT 'MEDIUM',
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    blood_group VARCHAR(10),
    quantity INT,
    expiry_date DATE,
    threshold_value DECIMAL(10,2),
    status ENUM('ACTIVE', 'ACKNOWLEDGED', 'RESOLVED', 'DISMISSED') DEFAULT 'ACTIVE',
    acknowledged_by INT,
    acknowledged_at TIMESTAMP NULL,
    resolved_by INT,
    resolved_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (acknowledged_by) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (resolved_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_type (type),
    INDEX idx_severity (severity),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);

-- System settings table - Application configuration
CREATE TABLE IF NOT EXISTS system_settings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    setting_type ENUM('STRING', 'NUMBER', 'BOOLEAN', 'JSON') DEFAULT 'STRING',
    description TEXT,
    category VARCHAR(50),
    is_public BOOLEAN DEFAULT FALSE,
    updated_by INT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_setting_key (setting_key),
    INDEX idx_category (category)
);

-- =====================================================
-- AUDIT AND LOGGING TABLES
-- =====================================================

-- Activity logs table - System activity tracking
CREATE TABLE IF NOT EXISTS activity_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INT,
    old_values JSON,
    new_values JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_action (action),
    INDEX idx_entity_type (entity_type),
    INDEX idx_created_at (created_at)
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

-- Clear existing data (optional - remove if you want to keep existing data)
-- DELETE FROM activity_logs;
-- DELETE FROM system_settings;
-- DELETE FROM alerts;
-- DELETE FROM notifications;
-- DELETE FROM feedback;
-- DELETE FROM blood_reports;
-- DELETE FROM appointments;
-- DELETE FROM blood_requests;
-- DELETE FROM donation_camps;
-- DELETE FROM blood_stock;
-- DELETE FROM donors;
-- DELETE FROM users;

-- Insert sample users with EXPLICIT status = 'ACTIVE' and password 'password123'
-- Password hash for 'password123' using BCrypt
INSERT INTO users (username, password, role, email, phone, status) VALUES
('admin', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'MANAGER', 'admin@bloodbank.com', '0112345678', 'ACTIVE'),
('donor1', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'DONOR', 'donor1@email.com', '0112345679', 'ACTIVE'),
('donor2', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'DONOR', 'donor2@email.com', '0112345680', 'ACTIVE'),
('hospital1', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'HOSPITAL', 'hospital1@email.com', '0112345681', 'ACTIVE'),
('medical1', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'MEDICAL_STAFF', 'medical1@email.com', '0112345682', 'ACTIVE'),
('officer1', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'DONOR_RELATION', 'officer1@email.com', '0112345683', 'ACTIVE'),
('coordinator1', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'HOSPITAL_COORDINATOR', 'coordinator1@email.com', '0112345684', 'ACTIVE');

-- Insert sample donors
INSERT INTO donors (user_id, name, age, gender, blood_group, weight, height, email, phone, address, city, last_donation_date, next_eligible_date, total_donations, status) VALUES
(2, 'John Doe', 25, 'MALE', 'O+', 70.5, 175.0, 'donor1@email.com', '0112345679', '123 Main St, Colombo 03', 'Colombo', '2024-09-15', '2024-10-15', 3, 'APPROVED'),
(3, 'Jane Smith', 30, 'FEMALE', 'A+', 65.0, 165.0, 'donor2@email.com', '0112345680', '456 Oak Ave, Kandy', 'Kandy', '2024-08-20', '2024-09-20', 5, 'APPROVED'),
(2, 'Mike Johnson', 28, 'MALE', 'B+', 75.0, 180.0, 'mike@email.com', '0112345685', '789 Pine St, Galle', 'Galle', '2024-07-10', '2024-08-10', 2, 'APPROVED');

-- Insert sample blood stock
INSERT INTO blood_stock (blood_group, quantity, expiry_date, collection_date, batch_number, storage_location, status) VALUES
('A+', 25, '2025-12-31', '2024-09-01', 'A+20240901', 'Refrigerator A1', 'AVAILABLE'),
('A-', 15, '2025-12-31', '2024-09-02', 'A-20240902', 'Refrigerator A2', 'AVAILABLE'),
('B+', 20, '2025-12-31', '2024-09-03', 'B+20240903', 'Refrigerator B1', 'AVAILABLE'),
('B-', 10, '2025-12-31', '2024-09-04', 'B-20240904', 'Refrigerator B2', 'AVAILABLE'),
('AB+', 8, '2025-12-31', '2024-09-05', 'AB+20240905', 'Refrigerator C1', 'AVAILABLE'),
('AB-', 5, '2025-12-31', '2024-09-06', 'AB-20240906', 'Refrigerator C2', 'AVAILABLE'),
('O+', 30, '2025-12-31', '2024-09-07', 'O+20240907', 'Refrigerator D1', 'AVAILABLE'),
('O-', 12, '2025-12-31', '2024-09-08', 'O-20240908', 'Refrigerator D2', 'AVAILABLE');

-- Insert sample donation camps
INSERT INTO donation_camps (camp_name, location, address, city, camp_date, start_time, end_time, max_donors, organizer_id, status, description, contact_person, contact_phone) VALUES
('Colombo Central Camp', 'Colombo Central Hospital', '123 Hospital Road, Colombo 07', 'Colombo', '2025-12-15', '09:00:00', '17:00:00', 100, 1, 'PLANNED', 'Monthly blood donation camp at Colombo Central Hospital', 'Dr. Sarah Wilson', '0112345678'),
('Kandy City Camp', 'Kandy City Hall', '456 City Hall Road, Kandy', 'Kandy', '2025-12-20', '08:00:00', '16:00:00', 80, 1, 'PLANNED', 'Community blood donation drive in Kandy', 'Dr. Rajesh Kumar', '0112345679'),
('Galle District Camp', 'Galle District Hospital', '789 Hospital Street, Galle', 'Galle', '2025-12-25', '09:30:00', '17:30:00', 60, 1, 'PLANNED', 'District-wide blood donation initiative', 'Dr. Priya Fernando', '0112345680');

-- Insert sample blood requests
INSERT INTO blood_requests (hospital_id, blood_group, quantity, urgency, status, patient_name, patient_info, medical_condition, doctor_name, doctor_contact, required_date, notes) VALUES
(4, 'O+', 4, 'URGENT', 'PENDING', 'John Smith', '45-year-old male, emergency surgery', 'Trauma surgery - car accident', 'Dr. Michael Brown', '0112345681', '2024-09-20', 'Patient requires immediate surgery'),
(4, 'A-', 2, 'NORMAL', 'APPROVED', 'Jane Doe', '35-year-old female, routine procedure', 'Elective surgery - appendectomy', 'Dr. Sarah Johnson', '0112345682', '2024-09-25', 'Scheduled surgery'),
(4, 'B+', 6, 'CRITICAL', 'COMPLETED', 'Mike Johnson', '28-year-old male, emergency case', 'Emergency surgery - internal bleeding', 'Dr. David Wilson', '0112345683', '2024-09-18', 'Critical condition - blood needed immediately');

-- Insert sample appointments
INSERT INTO appointments (donor_id, camp_id, appointment_date, time_slot, status, appointment_type, medical_staff_id, notes) VALUES
(1, 1, '2025-12-15', '10:00-11:00', 'APPROVED', 'REGULAR', 5, 'Regular blood donation'),
(2, 2, '2025-12-20', '14:00-15:00', 'PENDING', 'REGULAR', 5, 'Follow-up donation'),
(3, 1, '2025-12-15', '11:00-12:00', 'APPROVED', 'PLASMA', 5, 'Plasma donation');

-- Insert sample feedback
INSERT INTO feedback (user_id, subject, feedback_text, category, priority, status, is_urgent) VALUES
(2, 'Great Service Experience', 'The staff was very helpful during my donation. The process was smooth and efficient.', 'GENERAL', 'LOW', 'RESPONDED', FALSE),
(4, 'Need Faster Processing', 'Blood requests should be processed faster for urgent cases. Current response time is too slow.', 'SUGGESTION', 'MEDIUM', 'PENDING', FALSE),
(2, 'Long Wait Time', 'Had to wait for 2 hours for my appointment. This is unacceptable.', 'COMPLAINT', 'HIGH', 'PENDING', TRUE),
(3, 'System Bug Report', 'The appointment booking system is not working properly. Getting error messages.', 'BUG_REPORT', 'HIGH', 'PENDING', FALSE);

-- Insert sample notifications
INSERT INTO notifications (user_id, title, message, type, priority, action_url) VALUES
(2, 'Appointment Approved', 'Your appointment for Dec 15th has been approved. Please arrive 15 minutes early.', 'APPOINTMENT', 'MEDIUM', '/donor/appointments'),
(2, 'Donation Reminder', 'You are eligible to donate again in 15 days. Book your next appointment now!', 'REMINDER', 'LOW', '/donor/appointments'),
(4, 'Blood Request Processed', 'Your blood request for O+ has been processed and approved.', 'REQUEST', 'HIGH', '/hospital/requests'),
(1, 'System Maintenance', 'Scheduled maintenance will occur tonight from 2-4 AM. System may be unavailable.', 'SYSTEM', 'MEDIUM', '/dashboard');

-- Insert sample alerts
INSERT INTO alerts (type, severity, title, message, blood_group, quantity, status) VALUES
('STOCK', 'HIGH', 'Low Blood Stock Alert', 'Blood group O+ is running low. Current stock: 5 units', 'O+', 5, 'ACTIVE'),
('EXPIRY', 'MEDIUM', 'Blood Expiring Soon', 'Blood group A- will expire in 3 days. Consider using for urgent requests.', 'A-', 15, 'ACTIVE'),
('SYSTEM', 'LOW', 'Welcome to Blood Donation System', 'System is running normally. All services are operational.', NULL, NULL, 'ACTIVE'),
('MAINTENANCE', 'MEDIUM', 'Scheduled Maintenance', 'System will be under maintenance tonight from 2-4 AM', NULL, NULL, 'ACTIVE');

-- Insert sample blood reports
INSERT INTO blood_reports (donor_id, appointment_id, hemoglobin, rbc, hct, mcv, mch, mchc, rdw, wbc, esr, plt, gra, lym, eos, bas, blood_pressure_systolic, blood_pressure_diastolic, pulse_rate, temperature, weight_at_donation, donation_volume, status, tested_by, tested_at) VALUES
(1, 1, 14.5, 4.5, 42.0, 90.0, 30.0, 33.0, 12.0, 7.0, 15.0, 25.0, 60.0, 35.0, 3.0, 1.0, 120, 80, 72, 36.5, 70.5, 450, 'APPROVED', 5, NOW()),
(2, 2, 13.8, 4.2, 40.0, 95.0, 32.0, 34.0, 11.5, 6.5, 12.0, 28.0, 55.0, 40.0, 4.0, 1.0, 118, 78, 68, 36.2, 65.0, 450, 'PENDING', 5, NOW());

-- Insert sample system settings
INSERT INTO system_settings (setting_key, setting_value, setting_type, description, category, is_public) VALUES
('system_name', 'Blood Donation Management System', 'STRING', 'Name of the blood donation system', 'GENERAL', TRUE),
('max_appointments_per_day', '50', 'NUMBER', 'Maximum number of appointments per day', 'APPOINTMENTS', FALSE),
('blood_expiry_days', '42', 'NUMBER', 'Number of days before blood expires', 'BLOOD_MANAGEMENT', FALSE),
('low_stock_threshold', '10', 'NUMBER', 'Minimum stock level before low stock alert', 'BLOOD_MANAGEMENT', FALSE),
('email_notifications_enabled', 'true', 'BOOLEAN', 'Enable email notifications', 'NOTIFICATIONS', FALSE),
('maintenance_mode', 'false', 'BOOLEAN', 'Enable maintenance mode', 'SYSTEM', FALSE);

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Verify the setup
SELECT 'Database Setup Complete!' as Status;
SELECT 'Total Tables Created:' as Info, COUNT(*) as Count FROM information_schema.tables WHERE table_schema = 'blood_donation_system1';

SELECT 'Users Table:' as Table_Name;
SELECT id, username, role, status, email FROM users;

SELECT 'Donors Table:' as Table_Name;
SELECT id, user_id, name, blood_group, status, total_donations FROM donors;

SELECT 'Blood Stock Summary:' as Table_Name;
SELECT blood_group, SUM(quantity) as total_units, COUNT(*) as batches FROM blood_stock GROUP BY blood_group;

SELECT 'Active Alerts:' as Table_Name;
SELECT id, type, severity, title, status FROM alerts WHERE status = 'ACTIVE';

SELECT 'Pending Feedback:' as Table_Name;
SELECT id, subject, category, priority, status FROM feedback WHERE status = 'PENDING';

-- Show success message
SELECT 'FINAL DATABASE SCHEMA SETUP COMPLETED SUCCESSFULLY!' as Status;
SELECT 'All tables, indexes, foreign keys, and sample data have been created.' as Message;
SELECT 'The system is now ready for full operation.' as Ready;




