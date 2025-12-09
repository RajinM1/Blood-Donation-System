<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Blood donation system1</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary: #e74c3c;
            --primary-dark: #c0392b;
            --primary-light: #fadbd8;
            --secondary: #f5f5f5;
            --text: #333;
            --light-text: #777;
            --white: #fff;
            --shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--primary-light);
            color: var(--text);
            line-height: 1.6;
            overflow-x: hidden;
        }

        .hero-container {
            display: flex;
            min-height: 100vh;
        }

        .hero-image {
            flex: 1;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            color: var(--white);
            text-align: center;
            overflow: hidden;
        }

        .video-background {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: -1;
        }

        .video-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(231, 76, 60, 0.7);
            z-index: -1;
        }

        .hero-content {
            max-width: 800px;
            z-index: 1;
        }

        .hero-image h1 {
            font-size: 2.8rem;
            margin-bottom: 1.5rem;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            animation: fadeInUp 1s ease;
        }

        .hero-image p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            text-shadow: 0 1px 2px rgba(0,0,0,0.3);
            line-height: 1.8;
            animation: fadeInUp 1.2s ease;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .register-container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            background-color: var(--white);
        }

        .register-box {
            width: 100%;
            max-width: 500px;
            transition: var(--transition);
            animation: fadeIn 0.8s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .register-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .register-header h2 {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 0.8rem;
        }

        .register-header p {
            color: var(--light-text);
            font-size: 1rem;
        }

        .form-group {
            margin-bottom: 1.8rem;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.6rem;
            font-weight: 500;
            color: var(--text);
            font-size: 0.95rem;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 1px solid #ddd;
            border-radius: 10px;
            font-size: 1rem;
            transition: var(--transition);
            font-family: 'Poppins', sans-serif;
            background-color: var(--secondary);
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.2);
            background-color: var(--white);
        }

        .form-group i {
            position: absolute;
            left: 1rem;
            top: 3.1rem;
            color: var(--light-text);
            font-size: 1.1rem;
        }

        button[type="submit"] {
            width: 100%;
            padding: 1.1rem;
            background-color: var(--primary);
            color: var(--white);
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            margin-top: 1.5rem;
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.8rem;
        }

        button[type="submit"]:hover {
            background-color: var(--primary-dark);
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(231, 76, 60, 0.3);
        }

        .alert {
            padding: 1.2rem;
            margin-bottom: 2rem;
            border-radius: 10px;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .alert-error {
            background-color: #fdecea;
            color: #c62828;
            border-left: 4px solid #c62828;
        }

        .login-link {
            text-align: center;
            margin-top: 2rem;
            font-size: 1rem;
        }

        .login-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .system-badge {
            position: absolute;
            top: 2rem;
            left: 2rem;
            background-color: rgba(255, 255, 255, 0.9);
            padding: 0.7rem 1.5rem;
            border-radius: 30px;
            font-size: 1rem;
            font-weight: 600;
            color: var(--primary);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            z-index: 2;
            animation: fadeIn 1s ease;
        }

        .blood-drop-icon {
            font-size: 4rem;
            margin-top: 2rem;
            color: rgba(255, 255, 255, 0.8);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        @media (max-width: 768px) {
            .hero-container {
                flex-direction: column;
            }

            .hero-image {
                padding: 5rem 1.5rem 3rem;
                min-height: 45vh;
            }

            .hero-image h1 {
                font-size: 2.2rem;
            }

            .hero-image p {
                font-size: 1rem;
            }

            .register-container {
                padding: 2.5rem 1.5rem;
                min-height: 55vh;
            }

            .system-badge {
                top: 1.5rem;
                left: 1.5rem;
                font-size: 0.9rem;
            }

            .video-background {
                object-position: 60% center;
            }
        }
    </style>
</head>
<body>
    <div class="hero-container">
        <div class="hero-image">
            <video autoplay muted loop playsinline class="video-background">
                <source src="https://assets.mixkit.co/videos/preview/mixkit-medical-animation-of-a-beating-heart-4993-large.mp4" type="video/mp4">
                <img src="https://images.unsplash.com/photo-1576669801827-3b8f7190d4b6?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80" alt="Blood donation background">
            </video>
            <div class="video-overlay"></div>
            <span class="system-badge"><i class="fas fa-heartbeat" style="margin-right: 8px;"></i> BloodLink System</span>
            <div class="hero-content">
                <h1>Donate Blood, Save Lives</h1>
                <p>Every drop counts. Register today to become a blood donor or hospital partner in our life-saving network.</p>
                <i class="fas fa-tint blood-drop-icon"></i>
            </div>
        </div>

        <div class="register-container">
            <div class="register-box">
                <div class="register-header">
                    <h2>Join Our Community</h2>
                    <p>Create your account in just a few steps</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateRegistrationForm()">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <i class="fas fa-user"></i>
                        <input type="text" id="username" name="username" placeholder="Enter your username" required>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" name="password" placeholder="Create a password" required>
                    </div>

                    <div class="form-group">
                        <label for="role">Account Type</label>
                        <i class="fas fa-user-tag"></i>
                        <select id="role" name="role" required>
                            <option value="" disabled selected>Select your role</option>
                            <option value="DONOR">I want to donate blood</option>
                            <option value="HOSPITAL">Hospital/Medical center</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <i class="fas fa-envelope"></i>
                        <input type="email" id="email" name="email" placeholder="Your email address" required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <i class="fas fa-phone-alt"></i>
                        <input type="text" id="phone" name="phone" placeholder="Your contact number" required>
                    </div>

                    <!-- Donor-specific fields -->
                    <div id="donorFields" style="display: none;">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <i class="fas fa-id-card"></i>
                            <input type="text" id="name" name="name" placeholder="Your full name">
                        </div>

                        <div class="form-group">
                            <label for="age">Age</label>
                            <i class="fas fa-calendar-alt"></i>
                            <input type="number" id="age" name="age" placeholder="Your age" min="18" max="65">
                        </div>

                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <i class="fas fa-venus-mars"></i>
                            <select id="gender" name="gender">
                                <option value="" disabled selected>Select your gender</option>
                                <option value="MALE">Male</option>
                                <option value="FEMALE">Female</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="bloodGroup">Blood Group</label>
                            <i class="fas fa-tint"></i>
                            <select id="bloodGroup" name="bloodGroup">
                                <option value="" disabled selected>Select your blood group</option>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="weight">Weight (kg)</label>
                            <i class="fas fa-weight"></i>
                            <input type="number" id="weight" name="weight" placeholder="Your weight in kg" min="40" max="200" step="0.1">
                        </div>
                    </div>

                    <!-- Hospital-specific fields -->
                    <div id="hospitalFields" style="display: none;">
                        <div class="form-group">
                            <label for="hospitalName">Hospital/Medical Center Name</label>
                            <i class="fas fa-hospital"></i>
                            <input type="text" id="hospitalName" name="hospitalName" placeholder="Enter hospital name" required>
                        </div>

                        <div class="form-group">
                            <label for="hospitalType">Hospital Type</label>
                            <i class="fas fa-building"></i>
                            <select id="hospitalType" name="hospitalType" required>
                                <option value="" disabled selected>Select hospital type</option>
                                <option value="PRIVATE">Private</option>
                                <option value="GOVERNMENT">Government</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="hospitalAddress">Address</label>
                            <i class="fas fa-map-marker-alt"></i>
                            <textarea id="hospitalAddress" name="hospitalAddress" placeholder="Enter hospital address" rows="3" required></textarea>
                        </div>

                        <div class="form-group">
                            <label for="hospitalCity">City</label>
                            <i class="fas fa-city"></i>
                            <input type="text" id="hospitalCity" name="hospitalCity" placeholder="Enter city" required>
                        </div>

                        <div class="form-group">
                            <label for="hospitalState">State</label>
                            <i class="fas fa-map"></i>
                            <input type="text" id="hospitalState" name="hospitalState" placeholder="Enter state" required>
                        </div>

                        <div class="form-group">
                            <label for="hospitalPostalCode">Postal Code</label>
                            <i class="fas fa-mail-bulk"></i>
                            <input type="text" id="hospitalPostalCode" name="hospitalPostalCode" placeholder="Enter postal code" required>
                        </div>

                        <div class="form-group">
                            <label for="contactPerson">Contact Person</label>
                            <i class="fas fa-user-tie"></i>
                            <input type="text" id="contactPerson" name="contactPerson" placeholder="Enter contact person name" required>
                        </div>

                        <div class="form-group">
                            <label for="contactPhone">Contact Phone</label>
                            <i class="fas fa-phone"></i>
                            <input type="text" id="contactPhone" name="contactPhone" placeholder="Enter contact phone number" required>
                        </div>

                        <div class="form-group">
                            <label for="contactEmail">Contact Email</label>
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="contactEmail" name="contactEmail" placeholder="Enter contact email" required>
                        </div>

                        <div class="form-group">
                            <label for="licenseNumber">License Number</label>
                            <i class="fas fa-certificate"></i>
                            <input type="text" id="licenseNumber" name="licenseNumber" placeholder="Enter license number" required>
                        </div>

                        <div class="form-group">
                            <label for="registrationNumber">Registration Number</label>
                            <i class="fas fa-file-alt"></i>
                            <input type="text" id="registrationNumber" name="registrationNumber" placeholder="Enter registration number" required>
                        </div>
                    </div>

                    <button type="submit">
                        <i class="fas fa-user-plus"></i> Register Now
                    </button>
                </form>

                <div class="login-link">
                    <p>Already registered? <a href="login.jsp">Sign in to your account</a></p>
                </div>
            </div>
        </div>
    </div>

    <script>
        function validateRegistrationForm() {
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const role = document.getElementById('role').value;
            const email = document.getElementById('email').value;
            const phone = document.getElementById('phone').value;

            if (!username || !password || !role || !email || !phone) {
                alert('Please fill in all required fields.');
                return false;
            }

            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                alert('Please enter a valid email address.');
                return false;
            }

            // Validate donor-specific fields if role is DONOR
            if (role === 'DONOR') {
                const name = document.getElementById('name').value;
                const age = document.getElementById('age').value;
                const gender = document.getElementById('gender').value;
                const bloodGroup = document.getElementById('bloodGroup').value;
                const weight = document.getElementById('weight').value;

                if (!name || !age || !gender || !bloodGroup || !weight) {
                    alert('Please fill in all donor-specific fields.');
                    return false;
                }

                if (age < 18 || age > 65) {
                    alert('Age must be between 18 and 65 years.');
                    return false;
                }

                if (weight < 40 || weight > 200) {
                    alert('Weight must be between 40 and 200 kg.');
                    return false;
                }
            }

            // Validate hospital-specific fields if role is HOSPITAL
            if (role === 'HOSPITAL') {
                const hospitalName = document.getElementById('hospitalName').value;
                const hospitalType = document.getElementById('hospitalType').value;
                const hospitalAddress = document.getElementById('hospitalAddress').value;
                const hospitalCity = document.getElementById('hospitalCity').value;
                const hospitalState = document.getElementById('hospitalState').value;
                const hospitalPostalCode = document.getElementById('hospitalPostalCode').value;
                const contactPerson = document.getElementById('contactPerson').value;
                const contactPhone = document.getElementById('contactPhone').value;
                const contactEmail = document.getElementById('contactEmail').value;
                const licenseNumber = document.getElementById('licenseNumber').value;
                const registrationNumber = document.getElementById('registrationNumber').value;

                if (!hospitalName || !hospitalType || !hospitalAddress || !hospitalCity || 
                    !hospitalState || !hospitalPostalCode || !contactPerson || !contactPhone || 
                    !contactEmail || !licenseNumber || !registrationNumber) {
                    alert('Please fill in all hospital-specific fields.');
                    return false;
                }

                if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(contactEmail)) {
                    alert('Please enter a valid contact email address.');
                    return false;
                }
            }

            return true;
        }

        function toggleRoleFields() {
            const role = document.getElementById('role').value;
            const donorFields = document.getElementById('donorFields');
            const hospitalFields = document.getElementById('hospitalFields');
            
            // Hide all role-specific fields first
            donorFields.style.display = 'none';
            hospitalFields.style.display = 'none';
            
            // Remove required attributes from all role-specific fields
            const donorFieldIds = ['name', 'age', 'gender', 'bloodGroup', 'weight'];
            const hospitalFieldIds = ['hospitalName', 'hospitalType', 'hospitalAddress', 'hospitalCity', 
                                    'hospitalState', 'hospitalPostalCode', 'contactPerson', 'contactPhone', 
                                    'contactEmail', 'licenseNumber', 'registrationNumber'];
            
            donorFieldIds.forEach(id => {
                const field = document.getElementById(id);
                if (field) field.required = false;
            });
            
            hospitalFieldIds.forEach(id => {
                const field = document.getElementById(id);
                if (field) field.required = false;
            });
            
            // Show and make required fields based on role
            if (role === 'DONOR') {
                donorFields.style.display = 'block';
                donorFieldIds.forEach(id => {
                    const field = document.getElementById(id);
                    if (field) field.required = true;
                });
            } else if (role === 'HOSPITAL') {
                hospitalFields.style.display = 'block';
                hospitalFieldIds.forEach(id => {
                    const field = document.getElementById(id);
                    if (field) field.required = true;
                });
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const video = document.querySelector('.video-background');
            video.play().catch(e => {
                video.poster = 'https://images.unsplash.com/photo-1576669801827-3b8f7190d4b6?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80';
                video.load();
            });

            // Add event listener to role select
            document.getElementById('role').addEventListener('change', toggleRoleFields);
        });
    </script>
</body>
</html>