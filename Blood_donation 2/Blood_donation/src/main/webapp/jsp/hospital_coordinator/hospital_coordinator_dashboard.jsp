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
    <title>Blood donation system1 - Hospital Coordinator Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #3498db;
            --primary-dark: #2980b9;
            --secondary: #e74c3c;
            --text-dark: #2c3e50;
            --text-light: #7f8c8d;
            --background: #f8f9fa;
            --white: #ffffff;
            --border: #dfe6e9;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --success: #27ae60;
            --error: #e74c3c;
            --warning: #f39c12;
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
            padding: 1.5rem 2rem;
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        nav {
            background-color: var(--white);
            padding: 1rem 2rem;
            display: flex;
            gap: 2rem;
            box-shadow: var(--shadow);
            border-top: 3px solid var(--secondary);
        }

        nav a {
            color: var(--text-dark);
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 0;
            position: relative;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            white-space: nowrap;
            transition: all 0.3s ease;
        }

        nav a:hover {
            color: var(--primary);
            transform: translateY(-2px);
        }

        nav a.active {
            color: var(--secondary);
            font-weight: 600;
        }

        nav a.active:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background-color: var(--secondary);
        }

        .container {
            padding: 2.5rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        h2 {
            color: var(--text-dark);
            margin-bottom: 1.75rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 1.75rem;
        }

        h3 {
            color: var(--primary-dark);
            margin: 2rem 0 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--border);
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 1.5rem;
        }

        .alert {
            padding: 1rem 1.5rem;
            margin: 1.5rem 0;
            border-radius: 8px;
            background-color: #fdecea;
            color: var(--error);
            border-left: 4px solid var(--error);
            display: flex;
            align-items: center;
            gap: 1rem;
            font-weight: 500;
        }

        ul {
            list-style: none;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }

        li {
            transition: all 0.3s ease;
        }

        li:hover {
            transform: translateY(-5px);
        }

        ul a {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            gap: 1rem;
            padding: 1.75rem;
            background-color: var(--white);
            color: var(--text-dark);
            text-decoration: none;
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: var(--shadow);
            border-top: 4px solid var(--primary);
            height: 100%;
        }

        ul a:hover {
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
            border-top-color: var(--secondary);
        }

        .action-icon {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }

        .action-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-dark);
        }

        .action-desc {
            color: var(--text-light);
            font-size: 0.95rem;
        }

        .welcome-container {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .welcome-icon {
            font-size: 2.5rem;
            color: var(--primary);
            background-color: rgba(52, 152, 219, 0.1);
            padding: 1.5rem;
            border-radius: 50%;
        }

        .welcome-text h2 {
            margin-bottom: 0.5rem;
        }

        .welcome-text p {
            color: var(--text-light);
        }

        @media (max-width: 768px) {
            nav {
                gap: 1rem;
                padding: 1rem;
            }

            .container {
                padding: 1.5rem;
            }

            ul {
                grid-template-columns: 1fr;
            }

            .welcome-container {
                flex-direction: column;
                text-align: center;
            }

            .welcome-icon {
                margin-bottom: 1rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-user-md fa-lg"></i>
        <h1>Hospital Coordinator Dashboard</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/jsp/hospital_coordinator/hospital_coordinator_requests.jsp" class="active">
            <i class="fas fa-tint"></i> Blood Requests
        </a>
        <a href="${pageContext.request.contextPath}/jsp/hospital_coordinator/hospital_coordinator_stock.jsp">
            <i class="fas fa-flask"></i> Blood Stock
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <div class="welcome-container">
            <div class="welcome-icon">
                <i class="fas fa-hand-holding-medical"></i>
            </div>
            <div class="welcome-text">
                <h2><i class="fas fa-user-shield"></i> Welcome, ${sessionScope.user.username}</h2>
                <p>Manage blood requests and inventory efficiently</p>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
        <ul>
            <li>
                <a href="${pageContext.request.contextPath}/coordinator-request/">
                    <i class="fas fa-tint action-icon"></i>
                    <span class="action-title">Manage Blood Requests</span>
                    <span class="action-desc">Review and process incoming blood requests</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/coordinator-stock/">
                    <i class="fas fa-flask action-icon"></i>
                    <span class="action-title">View Blood Stock</span>
                    <span class="action-desc">Monitor current blood inventory levels</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/coordinator-feedback/">
                    <i class="fas fa-comment action-icon"></i>
                    <span class="action-title">Hospital Feedbacks</span>
                    <span class="action-desc">View and manage hospital feedbacks</span>
                </a>
            </li>
        </ul>
    </div>

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