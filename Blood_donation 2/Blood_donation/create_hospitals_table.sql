USE blood_donation_system1;

CREATE TABLE hospitals (
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
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO hospitals (user_id, hospital_name, hospital_type, address, city, contact_person, contact_phone, contact_email, status) VALUES
(4, 'City General Hospital', 'GOVERNMENT', '123 Main Street, Colombo 07', 'Colombo', 'Dr. John Smith', '0112345681', 'hospital1@email.com', 'ACTIVE');