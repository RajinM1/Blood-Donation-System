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
    <title>Donor Communication</title>
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
            justify-content: center;
            gap: 1rem;
        }

        header i {
            font-size: 1.8rem;
        }

        nav {
            background-color: var(--white);
            padding: 1rem 2rem;
            display: flex;
            justify-content: center;
            gap: 2rem;
            box-shadow: var(--shadow);
            border-top: 3px solid var(--secondary);
        }

        nav a {
            color: var(--text-dark);
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        nav a:hover {
            background-color: rgba(156, 39, 176, 0.1);
            color: var(--primary);
        }

        .container {
            padding: 2rem;
            max-width: 800px;
            margin: 2rem auto;
            background-color: var(--white);
            border-radius: 8px;
            box-shadow: var(--shadow);
        }

        h2 {
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            font-weight: 600;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
            background-color: #fdecea;
            color: var(--error);
            border-left: 4px solid var(--error);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert.success {
            background-color: #d4edda;
            color: #155724;
            border-left-color: #c3e6cb;
        }

        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        label {
            display: block;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        input[type="text"], select, textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 1rem;
            transition: all 0.3s ease;
            padding-left: 2.5rem;
        }

        textarea {
            min-height: 150px;
            resize: vertical;
        }

        select:focus, textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(156, 39, 176, 0.2);
        }

        button {
            background-color: var(--primary);
            color: var(--white);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 4px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        button:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 2.5rem;
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
        
        .stat-card.notifications {
            border-left-color: #2196f3;
        }
        
        .stat-card.unread {
            border-left-color: #ff9800;
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: var(--primary);
        }
        
        .stat-card.donors .stat-icon {
            color: #4caf50;
        }
        
        .stat-card.notifications .stat-icon {
            color: #2196f3;
        }
        
        .stat-card.unread .stat-icon {
            color: #ff9800;
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
                flex-direction: column;
                gap: 0.5rem;
                padding: 1rem;
            }

            .container {
                padding: 1.5rem;
                margin: 1rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-comments"></i>
        <h1>Donor Communication</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/donor-relation/dashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/communication" class="active">
            <i class="fas fa-comments"></i> Communication
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/camp-management">
            <i class="fas fa-medkit"></i> Camp Management
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/donor-messages">
            <i class="fas fa-envelope"></i> View Messages
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <h2><i class="fas fa-paper-plane"></i> Send Notification</h2>

        <!-- Statistics Banner -->
        <div class="stats-grid">
            <div class="stat-card donors">
                <i class="fas fa-users stat-icon"></i>
                <div class="stat-number">${totalDonors}</div>
                <div class="stat-label">Total Donors</div>
            </div>
            <div class="stat-card notifications">
                <i class="fas fa-bell stat-icon"></i>
                <div class="stat-number">${totalNotifications}</div>
                <div class="stat-label">Total Notifications</div>
            </div>
            <div class="stat-card unread">
                <i class="fas fa-envelope-open stat-icon"></i>
                <div class="stat-number">${unreadNotifications}</div>
                <div class="stat-label">Unread Messages</div>
            </div>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> ${param.success}
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${param.error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/donor-relation/send-notification" method="post">
            <div class="form-group">
                <label for="user_id"><i class="fas fa-user"></i> Donor:</label>
                <i class="fas fa-user input-icon"></i>
                <select id="user_id" name="user_id" required>
                    <option value="">Select a donor</option>
                    <c:forEach var="donor" items="${donors}">
                        <option value="${donor.userId}">${donor.name} (${donor.bloodGroup})</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="title"><i class="fas fa-tag"></i> Title:</label>
                <i class="fas fa-tag input-icon"></i>
                <input type="text" id="title" name="title" placeholder="Enter notification title..." required>
            </div>

            <div class="form-group">
                <label for="message"><i class="fas fa-envelope"></i> Message:</label>
                <i class="fas fa-envelope input-icon"></i>
                <textarea id="message" name="message" placeholder="Enter your notification message here..." required></textarea>
            </div>

            <button type="submit">
                <i class="fas fa-paper-plane"></i> Send Notification
            </button>
        </form>
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