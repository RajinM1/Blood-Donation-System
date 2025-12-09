-- Complete Blood Donation System Database Setup
-- This script creates the database and sample data with proper status handling

-- Drop database if exists (optional - remove if you want to keep existing data)
-- DROP DATABASE IF EXISTS blood_donation_system1;

-- Create database
CREATE DATABASE IF NOT EXISTS blood_donation_system1;
USE blood_donation_system1;

-- Create users table with proper status handling
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('DONOR', 'HOSPITAL', 'MANAGER', 'MEDICAL_STAFF', 'DONOR_RELATION', 'HOSPITAL_COORDINATOR') NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    status ENUM('ACTIVE', 'INACTIVE', 'LOCKED', 'SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create donors table
CREATE TABLE IF NOT EXISTS donors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender ENUM('MALE', 'FEMALE', 'OTHER') NOT NULL,
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    weight DECIMAL(5,2) NOT NULL,
    health_info TEXT,
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    medical_conditions TEXT,
    last_donation_date DATE,
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'SUSPENDED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create hospitals table
CREATE TABLE IF NOT EXISTS hospitals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    hospital_name VARCHAR(255) NOT NULL,
    hospital_type ENUM('PRIVATE', 'GOVERNMENT') NOT NULL,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    contact_person VARCHAR(255),
    contact_phone VARCHAR(20),
    contact_email VARCHAR(255),
    license_number VARCHAR(100),
    registration_number VARCHAR(100),
    status ENUM('ACTIVE', 'PENDING', 'SUSPENDED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_hospital_name (hospital_name),
    INDEX idx_hospital_type (hospital_type),
    INDEX idx_status (status),
    INDEX idx_city (city)
);

-- Create blood_stock table
CREATE TABLE IF NOT EXISTS blood_stock (
    id INT PRIMARY KEY AUTO_INCREMENT,
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    expiry_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create appointments table
CREATE TABLE IF NOT EXISTS appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT NOT NULL,
    camp_id INT,
    appointment_date DATE NOT NULL,
    time_slot VARCHAR(20),
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (donor_id) REFERENCES donors(id) ON DELETE CASCADE
);

-- Create blood_requests table
CREATE TABLE IF NOT EXISTS blood_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    hospital_id INT NOT NULL,
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    quantity INT NOT NULL,
    urgency ENUM('LOW', 'NORMAL', 'MEDIUM', 'HIGH', 'URGENT', 'CRITICAL') DEFAULT 'NORMAL',
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'ON_HOLD', 'COMPLETED') DEFAULT 'PENDING',
    priority INT DEFAULT 0,
    patient_info TEXT,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create donation_camps table
CREATE TABLE IF NOT EXISTS donation_camps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    camp_name VARCHAR(100) NOT NULL,
    location VARCHAR(200) NOT NULL,
    camp_date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    max_donors INT DEFAULT 50,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create feedback table
CREATE TABLE IF NOT EXISTS feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    feedback_text TEXT NOT NULL,
    category ENUM('GENERAL', 'COMPLAINT', 'SUGGESTION', 'URGENT') DEFAULT 'GENERAL',
    status ENUM('PENDING', 'RESPONDED', 'ESCALATED', 'RESOLVED') DEFAULT 'PENDING',
    response TEXT,
    responded_by INT,
    response_date TIMESTAMP NULL,
    is_urgent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'GENERAL',
    channel ENUM('EMAIL', 'SMS', 'IN_APP') DEFAULT 'IN_APP',
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create blood_reports table
CREATE TABLE IF NOT EXISTS blood_reports (
    id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT NOT NULL,
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
    new_field VARCHAR(100),
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (donor_id) REFERENCES donors(id) ON DELETE CASCADE
);

-- Clear existing data (optional - remove if you want to keep existing data)
-- DELETE FROM blood_reports;
-- DELETE FROM notifications;
-- DELETE FROM feedback;
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
('hospital1', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'HOSPITAL', 'hospital1@email.com', '0112345680', 'ACTIVE'),
('medical1', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'MEDICAL_STAFF', 'medical1@email.com', '0112345681', 'ACTIVE'),
('officer1', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'DONOR_RELATION', 'officer1@email.com', '0112345682', 'ACTIVE'),
('coordinator1', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'HOSPITAL_COORDINATOR', 'coordinator1@email.com', '0112345683', 'ACTIVE');

-- Insert sample donors
INSERT INTO donors (user_id, name, age, gender, blood_group, weight, email, phone, address, last_donation_date) VALUES
(2, 'John Doe', 25, 'MALE', 'O+', 70.5, 'donor1@email.com', '0112345679', '123 Main St, Colombo', '2024-09-15'),
(2, 'Jane Smith', 30, 'FEMALE', 'A+', 65.0, 'jane@email.com', '0112345684', '456 Oak Ave, Kandy', '2024-08-20');

-- Insert sample blood stock
INSERT INTO blood_stock (blood_group, quantity, expiry_date) VALUES
('A+', 25, '2024-12-31'),
('A-', 15, '2024-12-31'),
('B+', 20, '2024-12-31'),
('B-', 10, '2024-12-31'),
('AB+', 8, '2024-12-31'),
('AB-', 5, '2024-12-31'),
('O+', 30, '2024-12-31'),
('O-', 12, '2024-12-31');

-- Insert sample donation camps
INSERT INTO donation_camps (camp_name, location, camp_date, start_time, end_time, max_donors) VALUES
('Colombo Central Camp', 'Colombo Central Hospital', '2025-12-15', '09:00:00', '17:00:00', 100),
('Kandy City Camp', 'Kandy City Hall', '2025-12-20', '08:00:00', '16:00:00', 80),
('Galle District Camp', 'Galle District Hospital', '2025-12-25', '09:30:00', '17:30:00', 60);

-- Insert sample blood requests
INSERT INTO blood_requests (hospital_id, blood_group, quantity, urgency, status, patient_info) VALUES
(3, 'O+', 4, 'URGENT', 'PENDING', 'Emergency surgery - Patient: John Smith'),
(3, 'A-', 2, 'NORMAL', 'APPROVED', 'Routine procedure - Patient: Jane Doe'),
(3, 'B+', 6, 'URGENT', 'COMPLETED', 'Emergency case - Patient: Mike Johnson');

-- Insert sample appointments
INSERT INTO appointments (donor_id, camp_id, appointment_date, time_slot, status) VALUES
(1, 1, '2025-12-15', '10:00-11:00', 'APPROVED'),
(2, 2, '2025-12-20', '14:00-15:00', 'PENDING');

-- Insert sample feedback
INSERT INTO feedback (user_id, feedback_text, category, status) VALUES
(2, 'Great service! The staff was very helpful during my donation.', 'GENERAL', 'RESPONDED'),
(3, 'Need faster processing of urgent blood requests.', 'SUGGESTION', 'PENDING'),
(2, 'Had to wait too long for my appointment.', 'COMPLAINT', 'PENDING');

-- Insert sample notifications
INSERT INTO notifications (user_id, message, type, priority) VALUES
(2, 'Your appointment for Dec 15th has been approved', 'APPOINTMENT', 'MEDIUM'),
(2, 'You are eligible to donate again in 15 days', 'REMINDER', 'LOW'),
(3, 'Your blood request for O+ has been processed', 'REQUEST', 'HIGH');

-- Insert sample blood reports
INSERT INTO blood_reports (donor_id, hemoglobin, rbc, hct, mcv, mch, mchc, rdw, wbc, esr, plt, gra, lym, eos, bas, status) VALUES
(1, 14.5, 4.5, 42.0, 90.0, 30.0, 33.0, 12.0, 7.0, 15.0, 25.0, 60.0, 35.0, 3.0, 1.0, 'PENDING'),
(2, 13.8, 4.2, 40.0, 95.0, 32.0, 34.0, 11.5, 6.5, 12.0, 28.0, 55.0, 40.0, 4.0, 1.0, 'APPROVED');

-- Verify the setup
SELECT 'Users Table:' as Table_Name;
SELECT id, username, role, status, email FROM users;

SELECT 'Donors Table:' as Table_Name;
SELECT id, user_id, name, blood_group, status FROM donors;

-- Show success message
SELECT 'Database setup completed successfully!' as Status;



