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
    <title>Blood donation system1 - Donor Relation Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #9c27b0;
            --primary-dark: #7b1fa2;
            --secondary: #ff9800;
            --text-dark: #2c3e50;
            --text-light: #7f8c8d;
            --background: #f5f5f5;
            --white: #ffffff;
            --border: #e0e0e0;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --success: #4caf50;
            --error: #f44336;
            --info: #2196f3;
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
            color: var(--primary);
            font-weight: 600;
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

        .action-card {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            gap: 1rem;
            padding: 1.75rem;
            background-color: var(--white);
            color: var(--text-dark);
            text-decoration: none;
            border-radius: 10px;
            transition: all 0.3s ease;
            box-shadow: var(--shadow);
            border-top: 4px solid var(--primary);
            height: 100%;
        }

        .action-card:hover {
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
            background-color: rgba(156, 39, 176, 0.1);
            padding: 1.5rem;
            border-radius: 50%;
        }

        .welcome-text h2 {
            margin-bottom: 0.5rem;
        }

        .welcome-text p {
            color: var(--text-light);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .stat-card {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            text-align: center;
            transition: transform 0.3s ease;
            border-left: 4px solid var(--primary);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card.donors {
            border-left-color: #4caf50;
        }
        
        .stat-card.camps {
            border-left-color: #2196f3;
        }
        
        .stat-card.feedback {
            border-left-color: #ff9800;
        }
        
        .stat-card.urgent {
            border-left-color: #f44336;
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: var(--primary);
        }
        
        .stat-card.donors .stat-icon {
            color: #4caf50;
        }
        
        .stat-card.camps .stat-icon {
            color: #2196f3;
        }
        
        .stat-card.feedback .stat-icon {
            color: #ff9800;
        }
        
        .stat-card.urgent .stat-icon {
            color: #f44336;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            color: var(--text-light);
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
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
        <i class="fas fa-handshake fa-lg"></i>
        <h1>Donor Relation Dashboard</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/donor-relation/dashboard" class="active">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/appointments">
            <i class="fas fa-calendar-check"></i> Appointments
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/camp-management">
            <i class="fas fa-medkit"></i> Camp Management
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/communication">
            <i class="fas fa-comments"></i> Communication
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/donor-messages">
            <i class="fas fa-envelope"></i> Messages
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <div class="welcome-container">
            <div class="welcome-icon">
                <i class="fas fa-heartbeat"></i>
            </div>
            <div class="welcome-text">
                <h2><i class="fas fa-user-tie"></i> Welcome, ${sessionScope.user.username}</h2>
                <p>Manage donor communications and donation camps</p>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <!-- Statistics Banner -->
        <div class="stats-grid">
            <div class="stat-card donors">
                <i class="fas fa-users stat-icon"></i>
                <div class="stat-number">${totalDonors}</div>
                <div class="stat-label">Total Donors</div>
            </div>
            <div class="stat-card camps">
                <i class="fas fa-hospital stat-icon"></i>
                <div class="stat-number">${activeCamps}</div>
                <div class="stat-label">Active Camps</div>
            </div>
            <div class="stat-card feedback">
                <i class="fas fa-comments stat-icon"></i>
                <div class="stat-number">${pendingFeedback}</div>
                <div class="stat-label">Pending Messages</div>
            </div>
            <div class="stat-card urgent">
                <i class="fas fa-exclamation-triangle stat-icon"></i>
                <div class="stat-number">${urgentFeedback}</div>
                <div class="stat-label">Urgent Messages</div>
            </div>
        </div>

        <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
        <ul>
            <li>
                <a href="${pageContext.request.contextPath}/donor-relation/appointments" class="action-card">
                    <i class="fas fa-calendar-check action-icon"></i>
                    <span class="action-title">Manage Appointments</span>
                    <span class="action-desc">Approve or reject donor appointment requests</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/donor-relation/camp-management" class="action-card">
                    <i class="fas fa-hospital action-icon"></i>
                    <span class="action-title">Manage Donation Camps</span>
                    <span class="action-desc">Organize and schedule blood donation camps</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/donor-relation/communication" class="action-card">
                    <i class="fas fa-bell action-icon"></i>
                    <span class="action-title">Send Notifications</span>
                    <span class="action-desc">Communicate with donors via messages and alerts</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/donor-relation/donor-messages" class="action-card">
                    <i class="fas fa-envelope action-icon"></i>
                    <span class="action-title">View Donor Messages</span>
                    <span class="action-desc">View and manage all donor communications</span>
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