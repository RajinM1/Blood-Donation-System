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
    <title>Blood Stock</title>
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
            --expired: #e74c3c;
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
            margin: 2rem 0 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
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

        .form-container {
            background-color: var(--white);
            padding: 2rem;
            border-radius: 10px;
            box-shadow: var(--shadow);
            margin-bottom: 3rem;
            max-width: 600px;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            font-weight: 500;
            color: var(--text-dark);
            margin-bottom: 0.75rem;
        }

        select, input[type="number"], input[type="date"] {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        select:focus, input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
        }

        button {
            background-color: var(--primary);
            color: var(--white);
            border: none;
            padding: 0.8rem 1.75rem;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
        }

        button:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .stock-container {
            background-color: var(--white);
            padding: 2rem;
            border-radius: 10px;
            box-shadow: var(--shadow);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        th {
            background-color: var(--primary);
            color: var(--white);
            padding: 1.25rem 1rem;
            text-align: left;
            font-weight: 500;
            position: sticky;
            top: 0;
        }

        td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }

        tr:hover {
            background-color: rgba(52, 152, 219, 0.05);
        }

        .expired {
            color: var(--expired);
            font-weight: 600;
        }

        .low-stock {
            background-color: rgba(243, 156, 18, 0.1);
        }

        .critical-stock {
            background-color: rgba(231, 76, 60, 0.1);
        }

        .no-stock {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .no-stock i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--border);
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
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

        @media (max-width: 768px) {
            nav {
                gap: 1rem;
                padding: 1rem;
            }
            .container {
                padding: 1.5rem;
            }
            .form-container, .stock-container {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-flask fa-lg"></i>
        <h1>Blood Stock Management</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=hospital_coordinator">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/coordinator-request/">
            <i class="fas fa-tint"></i> Blood Requests
        </a>
        <a href="${pageContext.request.contextPath}/coordinator-stock/" class="active">
            <i class="fas fa-flask"></i> Blood Stock
        </a>
        <a href="${pageContext.request.contextPath}/coordinator-feedback/">
            <i class="fas fa-comment"></i> Hospital Feedbacks
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <c:if test="${not empty error}">
            <div class="alert error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>

        <h2><i class="fas fa-boxes"></i> Current Stock Levels</h2>

        <div class="stock-container">
            <c:choose>
                <c:when test="${not empty stocks}">
                    <table>
                        <thead>
                            <tr>
                                <th><i class="fas fa-tint"></i> Blood Group</th>
                                <th><i class="fas fa-flask"></i> Quantity</th>
                                <th><i class="fas fa-calendar-times"></i> Expiry Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="stock" items="${stocks}">
                                <tr class="${stock.quantity < 5 ? 'critical-stock' : (stock.quantity < 10 ? 'low-stock' : '')}">
                                    <td>${stock.bloodGroup}</td>
                                    <td>${stock.quantity} units</td>
                                    <td class="${stock.expired ? 'expired' : ''}">
                                        <i class="fas fa-${stock.expired ? 'exclamation-triangle' : 'calendar-alt'}"></i>
                                        ${stock.expiryDate}
                                        <c:if test="${stock.expired}"> (Expired)</c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-stock">
                        <i class="fas fa-flask"></i>
                        <h3>No blood stock available</h3>
                        <p>Add blood stock using the form above</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
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