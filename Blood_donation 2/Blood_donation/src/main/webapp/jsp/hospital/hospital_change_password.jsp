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
    <title>Change Password</title>
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
            max-width: 600px;
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

        .form-group {
            margin-bottom: 1.5rem;
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

        .form-group input {
            width: 100%;
            padding: 0.8rem;
            border: 2px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 1rem;
            transition: var(--transition);
            font-family: 'Poppins', sans-serif;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.1);
        }

        .password-strength {
            margin-top: 0.5rem;
            font-size: 0.9rem;
        }

        .strength-weak {
            color: var(--error);
        }

        .strength-medium {
            color: #f39c12;
        }

        .strength-strong {
            color: var(--success);
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

        .password-requirements {
            background: var(--background);
            padding: 1rem;
            border-radius: var(--radius-sm);
            margin-top: 1rem;
        }

        .password-requirements h4 {
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .password-requirements ul {
            list-style: none;
            padding: 0;
        }

        .password-requirements li {
            color: var(--text-light);
            font-size: 0.8rem;
            margin-bottom: 0.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .requirement-met {
            color: var(--success);
        }

        .requirement-not-met {
            color: var(--text-light);
        }

        @media (max-width: 768px) {
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
        <i class="fas fa-key"></i>
        <h1>Change Password</h1>
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
        <a href="${pageContext.request.contextPath}/jsp/hospital/hospital_feedback.jsp">
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
                <h1><i class="fas fa-lock"></i> Change Your Password</h1>
                <p>Update your account password for better security</p>
            </div>

            <form action="${pageContext.request.contextPath}/hospital/profile/change-password" method="post" onsubmit="return validatePasswordForm()">
                <div class="form-group">
                    <label for="oldPassword">
                        <i class="fas fa-lock"></i> Current Password
                    </label>
                    <input type="password" id="oldPassword" name="oldPassword" required>
                </div>

                <div class="form-group">
                    <label for="newPassword">
                        <i class="fas fa-key"></i> New Password
                    </label>
                    <input type="password" id="newPassword" name="newPassword" required onkeyup="checkPasswordStrength()">
                    <div id="passwordStrength" class="password-strength"></div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">
                        <i class="fas fa-check-circle"></i> Confirm New Password
                    </label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required onkeyup="checkPasswordMatch()">
                    <div id="passwordMatch" class="password-strength"></div>
                </div>

                <div class="password-requirements">
                    <h4>Password Requirements:</h4>
                    <ul>
                        <li id="req-length" class="requirement-not-met">
                            <i class="fas fa-circle"></i> At least 8 characters long
                        </li>
                        <li id="req-letter" class="requirement-not-met">
                            <i class="fas fa-circle"></i> Contains at least one letter
                        </li>
                        <li id="req-number" class="requirement-not-met">
                            <i class="fas fa-circle"></i> Contains at least one number
                        </li>
                        <li id="req-match" class="requirement-not-met">
                            <i class="fas fa-circle"></i> Passwords match
                        </li>
                    </ul>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Change Password
                    </button>
                    <a href="${pageContext.request.contextPath}/hospital/profile" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        function checkPasswordStrength() {
            const password = document.getElementById('newPassword').value;
            const strengthDiv = document.getElementById('passwordStrength');
            
            let strength = 0;
            let strengthText = '';
            let strengthClass = '';
            
            if (password.length >= 8) strength++;
            if (/[a-zA-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^a-zA-Z0-9]/.test(password)) strength++;
            
            if (password.length === 0) {
                strengthText = '';
            } else if (strength < 2) {
                strengthText = 'Weak';
                strengthClass = 'strength-weak';
            } else if (strength < 4) {
                strengthText = 'Medium';
                strengthClass = 'strength-medium';
            } else {
                strengthText = 'Strong';
                strengthClass = 'strength-strong';
            }
            
            strengthDiv.textContent = strengthText;
            strengthDiv.className = 'password-strength ' + strengthClass;
            
            // Update requirements
            updateRequirements();
        }
        
        function checkPasswordMatch() {
            const password = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const matchDiv = document.getElementById('passwordMatch');
            
            if (confirmPassword.length === 0) {
                matchDiv.textContent = '';
            } else if (password === confirmPassword) {
                matchDiv.textContent = 'Passwords match';
                matchDiv.className = 'password-strength strength-strong';
            } else {
                matchDiv.textContent = 'Passwords do not match';
                matchDiv.className = 'password-strength strength-weak';
            }
            
            updateRequirements();
        }
        
        function updateRequirements() {
            const password = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // Length requirement
            const reqLength = document.getElementById('req-length');
            if (password.length >= 8) {
                reqLength.className = 'requirement-met';
                reqLength.innerHTML = '<i class="fas fa-check-circle"></i> At least 8 characters long';
            } else {
                reqLength.className = 'requirement-not-met';
                reqLength.innerHTML = '<i class="fas fa-circle"></i> At least 8 characters long';
            }
            
            // Letter requirement
            const reqLetter = document.getElementById('req-letter');
            if (/[a-zA-Z]/.test(password)) {
                reqLetter.className = 'requirement-met';
                reqLetter.innerHTML = '<i class="fas fa-check-circle"></i> Contains at least one letter';
            } else {
                reqLetter.className = 'requirement-not-met';
                reqLetter.innerHTML = '<i class="fas fa-circle"></i> Contains at least one letter';
            }
            
            // Number requirement
            const reqNumber = document.getElementById('req-number');
            if (/[0-9]/.test(password)) {
                reqNumber.className = 'requirement-met';
                reqNumber.innerHTML = '<i class="fas fa-check-circle"></i> Contains at least one number';
            } else {
                reqNumber.className = 'requirement-not-met';
                reqNumber.innerHTML = '<i class="fas fa-circle"></i> Contains at least one number';
            }
            
            // Match requirement
            const reqMatch = document.getElementById('req-match');
            if (password === confirmPassword && password.length > 0) {
                reqMatch.className = 'requirement-met';
                reqMatch.innerHTML = '<i class="fas fa-check-circle"></i> Passwords match';
            } else {
                reqMatch.className = 'requirement-not-met';
                reqMatch.innerHTML = '<i class="fas fa-circle"></i> Passwords match';
            }
        }
        
        function validatePasswordForm() {
            const oldPassword = document.getElementById('oldPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (!oldPassword || !newPassword || !confirmPassword) {
                alert('Please fill in all fields.');
                return false;
            }
            
            if (newPassword.length < 8) {
                alert('New password must be at least 8 characters long.');
                return false;
            }
            
            if (!/[a-zA-Z]/.test(newPassword)) {
                alert('New password must contain at least one letter.');
                return false;
            }
            
            if (!/[0-9]/.test(newPassword)) {
                alert('New password must contain at least one number.');
                return false;
            }
            
            if (newPassword !== confirmPassword) {
                alert('Passwords do not match.');
                return false;
            }
            
            if (oldPassword === newPassword) {
                alert('New password must be different from current password.');
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
