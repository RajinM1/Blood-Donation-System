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
    <title>Submit Blood Request</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #e74c3c;
            --primary-dark: #c0392b;
            --text-dark: #2c3e50;
            --text-light: #7f8c8d;
            --background: #f9f9f9;
            --white: #ffffff;
            --border: #ecf0f1;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --success: #2ecc71;
            --error: #e74c3c;
            --urgent: #f39c12;
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
            max-width: 1200px;
            margin: 0 auto;
        }

        h2 {
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert {
            padding: 0.8rem 1rem;
            margin: 1rem 0;
            border-radius: 4px;
            background-color: #fdecea;
            color: var(--error);
            border-left: 4px solid var(--error);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .success {
            background-color: #e8f5e9;
            color: var(--success);
            border-left: 4px solid var(--success);
        }

        .form-container {
            background-color: var(--white);
            padding: 2rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
            margin-top: 1rem;
            max-width: 600px;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            font-weight: 500;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        select, input[type="number"], input[type="text"], textarea {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s;
            font-family: 'Poppins', sans-serif;
        }

        select:focus, input[type="number"]:focus, input[type="text"]:focus, textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(231, 76, 60, 0.2);
        }

        textarea {
            resize: vertical;
            min-height: 80px;
        }

        button {
            background-color: var(--primary);
            color: var(--white);
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 4px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        button:hover {
            background-color: var(--primary-dark);
        }

        .request-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .request-icon {
            font-size: 2rem;
            color: var(--primary);
        }

        @media (max-width: 768px) {
            .form-container {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-tint"></i>
        <h1>Submit Blood Request</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/hospital/dashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/blood-request/history">
            <i class="fas fa-history"></i> Request History
        </a>
        <a href="${pageContext.request.contextPath}/feedback/hospital">
            <i class="fas fa-comment"></i> Feedback
        </a>
        <a href="${pageContext.request.contextPath}/hospital/profile">
            <i class="fas fa-user"></i> Profile
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <div class="request-header">
            <i class="fas fa-hand-holding-medical request-icon"></i>
            <h2>Blood Request Form</h2>
        </div>

        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        <c:if test="${param.success == 'true'}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> Blood request submitted successfully!
            </div>
        </c:if>

        <div class="form-container">
            <form action="${pageContext.request.contextPath}/blood-request/submit" method="post" onsubmit="return validateBloodRequestForm()">
                <div class="form-group">
                    <label for="blood_group"><i class="fas fa-tint"></i> Blood Group:</label>
                    <select id="blood_group" name="blood_group" required>
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
                    <label for="quantity"><i class="fas fa-flask"></i> Quantity (units):</label>
                    <input type="number" id="quantity" name="quantity" min="1" max="10" required>
                </div>

                <div class="form-group">
                    <label for="urgency"><i class="fas fa-exclamation-triangle"></i> Urgency:</label>
                    <select id="urgency" name="urgency" required>
                        <option value="NORMAL">Normal</option>
                        <option value="URGENT">Urgent</option>
                        <option value="CRITICAL">Critical</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="patient_name"><i class="fas fa-user"></i> Patient Name:</label>
                    <input type="text" id="patient_name" name="patient_name" placeholder="Enter patient name" required>
                </div>

                <div class="form-group">
                    <label for="reason"><i class="fas fa-file-medical"></i> Reason for Request:</label>
                    <textarea id="reason" name="reason" placeholder="Enter reason for blood request" rows="3" required></textarea>
                </div>

                <button type="submit">
                    <i class="fas fa-paper-plane"></i> Submit Request
                </button>
            </form>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/validation.js"></script>

    <script>
        // Prevent back button access after logout
        window.history.pushState(null, null, window.location.href);
        window.onpopstate = function(event) {
            window.history.pushState(null, null, window.location.href);
        };
        
        // Clear form data on page unload
        window.addEventListener('beforeunload', function() {
            // Clear any sensitive form data
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                if (form.querySelector('input[type="password"]')) {
                    form.reset();
                }
            });
        });
    </script>
</body>
</html>