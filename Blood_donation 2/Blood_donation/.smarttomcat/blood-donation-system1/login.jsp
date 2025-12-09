<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Blood donation system1</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary: #e74c3c;
            --primary-dark: #c0392b;
            --secondary: #f5f5f5;
            --text: #333;
            --light-text: #777;
            --white: #fff;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f9f9f9;
            color: var(--text);
            line-height: 1.6;
        }

        .hero-container {
            display: flex;
            min-height: 100vh;
        }

        .hero-image {
            flex: 1;
            background: linear-gradient(rgba(231, 76, 60, 0.8), rgba(231, 76, 60, 0.8)),
                        url('https://images.unsplash.com/photo-1576091160550-2173dba999ef?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            color: var(--white);
            text-align: center;
            position: relative;
        }

        .user-types {
            display: flex;
            justify-content: center;
            gap: 1.5rem;
            margin-top: 2rem;
            flex-wrap: wrap;
        }

        .user-type {
            background: rgba(255, 255, 255, 0.2);
            padding: 1rem;
            border-radius: 8px;
            width: 120px;
            backdrop-filter: blur(5px);
        }

        .user-type i {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .user-type span {
            font-size: 0.8rem;
            font-weight: 500;
        }

        .hero-image h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .hero-image p {
            font-size: 1.1rem;
            max-width: 600px;
            margin-bottom: 2rem;
        }

        .login-container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }

        .login-box {
            background: var(--white);
            border-radius: 10px;
            box-shadow: var(--shadow);
            padding: 2.5rem;
            width: 100%;
            max-width: 450px;
            transition: var(--transition);
        }

        .login-box:hover {
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .login-header h2 {
            font-size: 1.8rem;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }

        .login-header p {
            color: var(--light-text);
            font-size: 0.9rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text);
        }

        .form-group input {
            width: 100%;
            padding: 0.8rem 1rem 0.8rem 2.5rem;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            transition: var(--transition);
        }

        .form-group input:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.2);
        }

        .form-group i {
            position: absolute;
            left: 1rem;
            top: 2.5rem;
            color: var(--light-text);
        }

        button[type="submit"] {
            width: 100%;
            padding: 0.8rem;
            background-color: var(--primary);
            color: var(--white);
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
        }

        button[type="submit"]:hover {
            background-color: var(--primary-dark);
        }

        .alert {
            padding: 0.8rem;
            margin-bottom: 1.5rem;
            border-radius: 5px;
            font-size: 0.9rem;
        }

        .alert-error {
            background-color: #fdecea;
            color: #c62828;
            border-left: 4px solid #c62828;
        }

        .register-link {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.9rem;
        }

        .register-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .system-badge {
            position: absolute;
            top: 1rem;
            left: 1rem;
            background-color: rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        @media (max-width: 768px) {
            .hero-container {
                flex-direction: column;
            }

            .hero-image {
                padding: 4rem 1rem 2rem;
            }

            .login-container {
                padding: 2rem 1rem;
            }

            .user-types {
                gap: 1rem;
            }

            .user-type {
                width: 100px;
                padding: 0.8rem;
            }

            .user-type i {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="hero-container">
        <div class="hero-image">
            <span class="system-badge">Blood donation system1</span>
            <h1>Connecting Lives Through Blood</h1>
            <p>A unified platform for donors, recipients, hospitals, and administrators to manage the blood donation ecosystem</p>

            <div class="user-types">
                <div class="user-type">
                    <i class="fas fa-hand-holding-heart"></i>
                    <span>Donors</span>
                </div>
                <div class="user-type">
                    <i class="fas fa-user-injured"></i>
                    <span>Recipients</span>
                </div>
                <div class="user-type">
                    <i class="fas fa-hospital-user"></i>
                    <span>Hospitals</span>
                </div>
                <div class="user-type">
                    <i class="fas fa-user-shield"></i>
                    <span>Administrators</span>
                </div>
            </div>
        </div>

        <div class="login-container">
            <div class="login-box">
                <div class="login-header">
                    <h2>System Login</h2>
                    <p>Access your account based on your role</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>
                
                <c:if test="${not empty success}">
                    <div class="alert" style="background-color: #d4edda; color: #155724; border-left: 4px solid #28a745;">
                        <i class="fas fa-check-circle"></i> ${success}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post" onsubmit="return validateLoginForm()">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <i class="fas fa-user"></i>
                        <input type="text" id="username" name="username" placeholder="Enter your username" required>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" name="password" placeholder="Enter your password" required>
                    </div>

                    <button type="submit">Login</button>
                </form>

                <div class="register-link">
                    <p>Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp">Register here</a></p>
                    <p style="margin-top: 0.5rem; font-size: 0.8rem;">Hospital/recipients accounts </p>
                </div>
            </div>
        </div>
    </div>

    <script>
        function validateLoginForm() {
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;

            if (!username || !password) {
                alert('Please fill in all fields.');
                return false;
            }

            return true;
        }
    </script>
</body>
</html>