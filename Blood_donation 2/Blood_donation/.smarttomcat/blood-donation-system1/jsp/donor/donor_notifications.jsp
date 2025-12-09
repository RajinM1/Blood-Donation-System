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
    <title>Notifications</title>
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
            --info: #3498db;
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
            margin: 2rem 0 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .notification-section {
            background-color: var(--white);
            padding: 2rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
            margin-bottom: 2rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        th {
            background-color: var(--primary);
            color: var(--white);
            padding: 1rem;
            text-align: left;
        }

        td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }

        tr:hover {
            background-color: rgba(231, 76, 60, 0.05);
        }

        .notification-message {
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .notification-icon {
            color: var(--info);
            font-size: 1.2rem;
        }

        .camp-icon {
            color: var(--primary);
            font-size: 1.2rem;
        }

        .no-notifications {
            text-align: center;
            padding: 2rem;
            color: var(--text-light);
        }

        @media (max-width: 768px) {
            .notification-section {
                padding: 1rem;
                overflow-x: auto;
            }

            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }

            th, td {
                padding: 0.8rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-bell"></i>
        <h1>Notifications</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=donor">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/view/my-details">
            <i class="fas fa-user"></i> Profile
        </a>
        <a href="${pageContext.request.contextPath}/view/my-blood-reports">
            <i class="fas fa-file-medical"></i> Blood Report
        </a>
        <a href="${pageContext.request.contextPath}/donor-page/donation-history">
            <i class="fas fa-history"></i> Donation History
        </a>
        <a href="${pageContext.request.contextPath}/appointment-page">
            <i class="fas fa-calendar-check"></i> Appointments
        </a>
        <a href="${pageContext.request.contextPath}/donor-page/feedback">
            <i class="fas fa-comment"></i> Feedback
        </a>
        <a href="${pageContext.request.contextPath}/donor-page/notifications" class="active">
            <i class="fas fa-bell"></i> Notifications
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <div class="notification-section">
            <h2><i class="fas fa-envelope"></i> Your Notifications</h2>
            <c:choose>
                <c:when test="${not empty notifications}">
                    <table>
                        <thead>
                            <tr>
                                <th>Message</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="notification" items="${notifications}">
                                <tr>
                                    <td>
                                        <div class="notification-message">
                                            <i class="fas fa-info-circle notification-icon"></i>
                                            ${notification.message}
                                        </div>
                                    </td>
                                    <td>${notification.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-notifications">
                        <i class="fas fa-bell-slash fa-3x" style="color: var(--text-light); margin-bottom: 1rem;"></i>
                        <h3>No notifications yet</h3>
                        <p>You'll see important updates here when they become available</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="notification-section">
            <h2><i class="fas fa-hospital"></i> Upcoming Donation Camps</h2>
            <c:choose>
                <c:when test="${not empty camps}">
                    <table>
                        <thead>
                            <tr>
                                <th>Camp Name</th>
                                <th>Date</th>
                                <th>Location</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="camp" items="${camps}">
                                <tr>
                                    <td>
                                        <div class="notification-message">
                                            <i class="fas fa-medkit camp-icon"></i>
                                            ${camp.campName}
                                        </div>
                                    </td>
                                    <td>${camp.campDate}</td>
                                    <td>${camp.location}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-notifications">
                        <i class="fas fa-calendar-times fa-3x" style="color: var(--text-light); margin-bottom: 1rem;"></i>
                        <h3>No upcoming camps scheduled</h3>
                        <p>Check back later for information about upcoming donation camps</p>
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