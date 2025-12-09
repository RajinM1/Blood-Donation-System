<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Hospital Profile</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #e74c3c;
            --primary-dark: #c0392b;
            --primary-light: #ffebe9;
            --text-dark: #2c3e50;
            --text-medium: #34495e;
            --text-light: #7f8c8d;
            --background: #f5f7fa;
            --white: #ffffff;
            --border: #dfe6e9;
            --border-light: #ecf0f1;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --shadow-hover: 0 6px 16px rgba(0, 0, 0, 0.12);
            --success: #27ae60;
            --success-light: #e8f5e9;
            --error: #e74c3c;
            --error-light: #fdecea;
            --radius: 8px;
            --radius-sm: 4px;
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background-color: var(--background);
            color: var(--text-dark);
            line-height: 1.6;
            min-height: 100vh;
        }

        header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            padding: 1.2rem 2rem;
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        nav {
            background-color: var(--white);
            padding: 0.9rem 2rem;
            display: flex;
            gap: 1.5rem;
            box-shadow: var(--shadow);
            overflow-x: auto;
        }

        nav a {
            color: var(--text-dark);
            text-decoration: none;
            font-weight: 500;
            padding: 0.3rem 0;
            position: relative;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            white-space: nowrap;
            transition: var(--transition);
        }

        nav a:hover {
            color: var(--primary);
        }

        nav a.active {
            color: var(--primary);
        }

        nav a.active:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background-color: var(--primary);
        }

        .container {
            padding: 2rem;
            max-width: 1000px;
            margin: 0 auto;
        }

        .form-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 2rem;
        }

        .form-header {
            margin-bottom: 2rem;
            text-align: center;
        }

        .form-header h1 {
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            font-size: 1.8rem;
            font-weight: 600;
        }

        .form-header p {
            color: var(--text-light);
            font-size: 1rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            font-weight: 500;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.8rem;
            border: 2px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 1rem;
            transition: var(--transition);
            font-family: 'Poppins', sans-serif;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid var(--border-light);
        }

        .btn {
            padding: 0.8rem 2rem;
            border: none;
            border-radius: var(--radius-sm);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1rem;
        }

        .btn-primary {
            background: var(--primary);
            color: var(--white);
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: var(--white);
            color: var(--text-dark);
            border: 2px solid var(--border);
        }

        .btn-secondary:hover {
            background: var(--background);
            border-color: var(--primary);
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert.success {
            background-color: var(--success-light);
            color: var(--success);
            border-left: 4px solid var(--success);
        }

        .alert.error {
            background-color: var(--error-light);
            color: var(--error);
            border-left: 4px solid var(--error);
        }

        .section-title {
            color: var(--text-dark);
            margin: 2rem 0 1rem 0;
            font-size: 1.2rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border-light);
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-edit"></i>
        <h1>Edit Hospital Profile</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/hospital/dashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/jsp/hospital/hospital_blood_request.jsp">
            <i class="fas fa-tint"></i> Blood Request
        </a>
        <a href="${pageContext.request.contextPath}/blood-request/history">
            <i class="fas fa-history"></i> Request History
        </a>
        <a href="${pageContext.request.contextPath}/feedback/hospital">
            <i class="fas fa-comment"></i> Feedback
        </a>
        <a href="${pageContext.request.contextPath}/hospital/profile" class="active">
            <i class="fas fa-user"></i> Profile
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <c:if test="${not empty param.success}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> ${param.success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <div class="form-container">
            <div class="form-header">
                <h1><i class="fas fa-hospital"></i> Update Hospital Information</h1>
                <p>Keep your hospital profile information up to date</p>
            </div>

            <form action="${pageContext.request.contextPath}/hospital/profile/update" method="post" onsubmit="return validateHospitalProfileForm()">
                <h3 class="section-title">
                    <i class="fas fa-info-circle"></i> Basic Information
                </h3>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label for="hospitalName">
                            <i class="fas fa-hospital"></i> Hospital Name
                        </label>
                        <input type="text" id="hospitalName" name="hospitalName" 
                               value="${hospital.hospitalName}" required>
                    </div>

                    <div class="form-group">
                        <label for="hospitalType">
                            <i class="fas fa-building"></i> Hospital Type
                        </label>
                        <select id="hospitalType" name="hospitalType" required>
                            <option value="PRIVATE" ${hospital.hospitalType == 'PRIVATE' ? 'selected' : ''}>Private</option>
                            <option value="GOVERNMENT" ${hospital.hospitalType == 'GOVERNMENT' ? 'selected' : ''}>Government</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="licenseNumber">
                            <i class="fas fa-certificate"></i> License Number
                        </label>
                        <input type="text" id="licenseNumber" name="licenseNumber" 
                               value="${hospital.licenseNumber}" required>
                    </div>

                    <div class="form-group">
                        <label for="registrationNumber">
                            <i class="fas fa-file-alt"></i> Registration Number
                        </label>
                        <input type="text" id="registrationNumber" name="registrationNumber" 
                               value="${hospital.registrationNumber}" required>
                    </div>
                </div>

                <h3 class="section-title">
                    <i class="fas fa-map-marker-alt"></i> Location Information
                </h3>

                <div class="form-group full-width">
                    <label for="address">
                        <i class="fas fa-map-pin"></i> Address
                    </label>
                    <textarea id="address" name="address" required>${hospital.address}</textarea>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="city">
                            <i class="fas fa-city"></i> City
                        </label>
                        <input type="text" id="city" name="city" 
                               value="${hospital.city}" required>
                    </div>

                    <div class="form-group">
                        <label for="state">
                            <i class="fas fa-map"></i> State
                        </label>
                        <input type="text" id="state" name="state" 
                               value="${hospital.state}" required>
                    </div>

                    <div class="form-group">
                        <label for="postalCode">
                            <i class="fas fa-mail-bulk"></i> Postal Code
                        </label>
                        <input type="text" id="postalCode" name="postalCode" 
                               value="${hospital.postalCode}" required>
                    </div>
                </div>

                <h3 class="section-title">
                    <i class="fas fa-phone"></i> Contact Information
                </h3>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="contactPerson">
                            <i class="fas fa-user-tie"></i> Contact Person
                        </label>
                        <input type="text" id="contactPerson" name="contactPerson" 
                               value="${hospital.contactPerson}" required>
                    </div>

                    <div class="form-group">
                        <label for="contactPhone">
                            <i class="fas fa-phone"></i> Contact Phone
                        </label>
                        <input type="tel" id="contactPhone" name="contactPhone" 
                               value="${hospital.contactPhone}" required>
                    </div>

                    <div class="form-group">
                        <label for="contactEmail">
                            <i class="fas fa-envelope"></i> Contact Email
                        </label>
                        <input type="email" id="contactEmail" name="contactEmail" 
                               value="${hospital.contactEmail}" required>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Update Profile
                    </button>
                    <a href="${pageContext.request.contextPath}/hospital/profile" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        function validateHospitalProfileForm() {
            const hospitalName = document.getElementById('hospitalName').value;
            const hospitalType = document.getElementById('hospitalType').value;
            const licenseNumber = document.getElementById('licenseNumber').value;
            const registrationNumber = document.getElementById('registrationNumber').value;
            const address = document.getElementById('address').value;
            const city = document.getElementById('city').value;
            const state = document.getElementById('state').value;
            const postalCode = document.getElementById('postalCode').value;
            const contactPerson = document.getElementById('contactPerson').value;
            const contactPhone = document.getElementById('contactPhone').value;
            const contactEmail = document.getElementById('contactEmail').value;

            if (!hospitalName || !hospitalType || !licenseNumber || !registrationNumber || 
                !address || !city || !state || !postalCode || !contactPerson || !contactPhone || !contactEmail) {
                alert('Please fill in all required fields.');
                return false;
            }

            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(contactEmail)) {
                alert('Please enter a valid contact email address.');
                return false;
            }

            return true;
        }

        // Prevent back button access after logout
        window.history.pushState(null, null, window.location.href);
        window.onpopstate = function(event) {
            window.history.pushState(null, null, window.location.href);
        };
    </script>
</body>
</html>
