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
    <title>Blood donation system1 - Hospital Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
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
            margin-bottom: 1.2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        h3 {
            color: var(--primary);
            margin: 1.5rem 0 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert {
            padding: 0.8rem 1rem;
            margin: 1rem 0;
            border-radius: 4px;
            background-color: #fdecea;
            color: var(--error-dark);
            border-left: 4px solid var(--error);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        ul {
            list-style: none;
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 1rem;
        }

        li {
            margin-bottom: 0;
        }

        ul a {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.8rem 1.5rem;
            background-color: var(--primary);
            color: var(--white);
            text-decoration: none;
            border-radius: 4px;
            font-weight: 500;
            transition: background-color 0.2s;
            min-width: 200px;
        }

        ul a:hover {
            background-color: var(--primary-dark);
        }

        .welcome-message {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .welcome-icon {
            font-size: 2rem;
            color: var(--primary);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }

        .stat-card {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .stat-icon {
            font-size: 2.5rem;
            color: var(--primary);
        }

        .stat-content h4 {
            margin: 0 0 0.5rem 0;
            color: var(--text-dark);
            font-size: 0.9rem;
            font-weight: 500;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 600;
            color: var(--primary);
            margin: 0;
        }

        .stat-desc {
            color: var(--text-light);
            font-size: 0.8rem;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin: 1.5rem 0;
        }

        .action-card {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
            text-decoration: none;
            color: var(--text-dark);
            transition: all 0.3s ease;
            text-align: center;
        }

        .action-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }

        .action-card.primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
        }

        .action-card i {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .action-card h4 {
            margin: 0.5rem 0;
            font-size: 1.1rem;
        }

        .action-card p {
            margin: 0;
            font-size: 0.9rem;
            opacity: 0.8;
        }

        .dashboard-section {
            margin: 2rem 0;
        }

        .request-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .request-item {
            background: var(--white);
            padding: 1rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .request-item i {
            font-size: 1.5rem;
            color: var(--primary);
        }

        .request-item div {
            flex: 1;
        }

        .request-item strong {
            display: block;
            margin-bottom: 0.25rem;
            color: var(--text-dark);
        }

        .request-item p {
            margin: 0.25rem 0;
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .request-item .status {
            font-size: 0.8rem;
            font-weight: 500;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            background: var(--border);
            color: var(--text-dark);
        }

        .request-item.pending .status {
            background: #fff3cd;
            color: #856404;
        }

        .request-item.approved .status {
            background: #d4edda;
            color: #155724;
        }

        .request-item.completed .status {
            background: #d1ecf1;
            color: #0c5460;
        }

        .no-requests {
            text-align: center;
            padding: 2rem;
            color: var(--text-light);
        }

        @media (max-width: 768px) {
            ul {
                flex-direction: column;
            }

            ul a {
                width: 100%;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .actions-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-hospital"></i>
        <h1>Hospital Dashboard</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/hospital/dashboard" class="active">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/hospital/blood-request">
            <i class="fas fa-tint"></i> Blood Request
        </a>
        <a href="${pageContext.request.contextPath}/blood-request/history">
            <i class="fas fa-history"></i> Request History
        </a>
        <a href="${pageContext.request.contextPath}/feedback/hospital">
            <i class="fas fa-comment"></i> Feedback
        </a>
        <a href="${pageContext.request.contextPath}/hospital/notifications">
            <i class="fas fa-bell"></i> Notifications
        </a>
        <a href="${pageContext.request.contextPath}/hospital/profile">
            <i class="fas fa-user"></i> Profile
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <div class="welcome-section">
            <h2><i class="fas fa-hospital"></i> Welcome, ${hospital.hospitalName}</h2>
            <p>Manage your blood requests and track deliveries efficiently</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>

        <!-- Hospital Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-file-medical"></i>
                </div>
                <div class="stat-content">
                    <h4>Pending Requests</h4>
                    <p class="stat-number">${pendingRequests}</p>
                    <span class="stat-desc">Awaiting approval</span>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-content">
                    <h4>Approved Requests</h4>
                    <p class="stat-number">${approvedRequests}</p>
                    <span class="stat-desc">Approved</span>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-truck"></i>
                </div>
                <div class="stat-content">
                    <h4>Deliveries</h4>
                    <p class="stat-number">${completedRequests}</p>
                    <span class="stat-desc">Completed</span>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-tint"></i>
                </div>
                <div class="stat-content">
                    <h4>Blood Units</h4>
                    <p class="stat-number">${totalBloodUnits}</p>
                    <span class="stat-desc">Received</span>
                </div>
            </div>
        </div>

        <!-- Quick Actions Grid -->
        <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
        <div class="actions-grid">
            <a href="${pageContext.request.contextPath}/hospital/blood-request" class="action-card primary">
                <i class="fas fa-plus-circle"></i>
                <h4>New Blood Request</h4>
                <p>Submit a new blood request</p>
            </a>
            <a href="${pageContext.request.contextPath}/blood-request/history" class="action-card">
                <i class="fas fa-history"></i>
                <h4>Request History</h4>
                <p>View all your requests</p>
            </a>
            <a href="${pageContext.request.contextPath}/feedback/hospital" class="action-card">
                <i class="fas fa-comment"></i>
                <h4>Send Feedback</h4>
                <p>Share your experience</p>
            </a>
            <a href="${pageContext.request.contextPath}/hospital/notifications" class="action-card">
                <i class="fas fa-bell"></i>
                <h4>Notifications</h4>
                <p>View coordinator messages</p>
            </a>
        </div>

        <!-- Recent Requests -->
        <div class="dashboard-section">
            <h3><i class="fas fa-clock"></i> Recent Requests</h3>
            <div class="request-list">
                <c:choose>
                    <c:when test="${not empty recentRequests}">
                        <c:forEach var="request" items="${recentRequests}">
                            <div class="request-item ${request.status.toLowerCase()}">
                                <i class="fas fa-${request.status == 'COMPLETED' ? 'truck' : request.status == 'APPROVED' ? 'check-circle' : 'clock'}"></i>
                                <div>
                                    <strong>Blood Type ${request.bloodGroup} - ${request.quantity} Units</strong>
                                    <p>${request.reason} - Patient: ${request.patientName}</p>
                                    <span class="status">${request.status}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-requests">
                            <i class="fas fa-clipboard-list fa-3x" style="color: var(--text-light); margin-bottom: 1rem;"></i>
                            <h3>No recent requests</h3>
                            <p>Your recent blood requests will appear here</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
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