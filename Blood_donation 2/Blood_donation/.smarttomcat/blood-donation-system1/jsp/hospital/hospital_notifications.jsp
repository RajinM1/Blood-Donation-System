<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Blood Donation System - Hospital Notifications</title>
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
            --warning: #f39c12;
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

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-header h2 {
            color: var(--text-dark);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .notification-filters {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 0.5rem 1rem;
            border: 2px solid var(--border);
            background: var(--white);
            color: var(--text-dark);
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .filter-btn:hover, .filter-btn.active {
            background: var(--primary);
            color: var(--white);
            border-color: var(--primary);
        }

        .notifications-container {
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .notification-item {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .notification-item:hover {
            background: #f8f9fa;
        }

        .notification-item:last-child {
            border-bottom: none;
        }

        .notification-item.unread {
            background: #f0f8ff;
            border-left: 4px solid var(--primary);
        }

        .notification-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.5rem;
        }

        .notification-title {
            font-weight: 600;
            color: var(--text-dark);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .notification-type {
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .notification-type.system {
            background: #e3f2fd;
            color: #1976d2;
        }

        .notification-type.alert {
            background: #fff3e0;
            color: #f57c00;
        }

        .notification-type.request {
            background: #f3e5f5;
            color: #7b1fa2;
        }

        .notification-type.reminder {
            background: #e8f5e8;
            color: #388e3c;
        }

        .notification-content {
            color: var(--text-light);
            margin: 0.5rem 0;
            line-height: 1.5;
        }

        .notification-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 0.75rem;
            font-size: 0.85rem;
            color: var(--text-light);
        }

        .notification-time {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .notification-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-small {
            padding: 0.25rem 0.75rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.8rem;
            transition: all 0.3s ease;
        }

        .btn-mark-read {
            background: var(--info);
            color: var(--white);
        }

        .btn-mark-read:hover {
            background: #2980b9;
        }

        .btn-delete {
            background: var(--error);
            color: var(--white);
        }

        .btn-delete:hover {
            background: #c0392b;
        }

        .no-notifications {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .no-notifications i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--text-light);
        }

        .stats-bar {
            background: var(--white);
            padding: 1rem 1.5rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-around;
            text-align: center;
        }

        .stat-item {
            flex: 1;
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--primary);
            margin: 0;
        }

        .stat-label {
            color: var(--text-light);
            font-size: 0.85rem;
            margin: 0.25rem 0 0 0;
        }

        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .notification-filters {
                flex-direction: column;
            }

            .filter-btn {
                text-align: center;
            }

            .notification-header {
                flex-direction: column;
                gap: 0.5rem;
            }

            .notification-meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .stats-bar {
                flex-direction: column;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-bell"></i>
        <h1>Hospital Notifications</h1>
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
        <a href="${pageContext.request.contextPath}/hospital/notifications" class="active">
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
        <div class="page-header">
            <h2><i class="fas fa-bell"></i> Coordinator Notifications</h2>
        </div>

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

        <!-- Notification Statistics -->
        <div class="stats-bar">
            <div class="stat-item">
                <p class="stat-number">${totalNotifications}</p>
                <p class="stat-label">Total Notifications</p>
            </div>
            <div class="stat-item">
                <p class="stat-number">${unreadNotifications}</p>
                <p class="stat-label">Unread</p>
            </div>
            <div class="stat-item">
                <p class="stat-number">${systemNotifications}</p>
                <p class="stat-label">System</p>
            </div>
            <div class="stat-item">
                <p class="stat-number">${alertNotifications}</p>
                <p class="stat-label">Alerts</p>
            </div>
        </div>

        <!-- Filter Buttons -->
        <div class="notification-filters">
            <button class="filter-btn active" onclick="filterNotifications('all')">
                <i class="fas fa-list"></i> All Notifications
            </button>
            <button class="filter-btn" onclick="filterNotifications('unread')">
                <i class="fas fa-envelope"></i> Unread
            </button>
            <button class="filter-btn" onclick="filterNotifications('system')">
                <i class="fas fa-cog"></i> System
            </button>
            <button class="filter-btn" onclick="filterNotifications('alert')">
                <i class="fas fa-exclamation-triangle"></i> Alerts
            </button>
            <button class="filter-btn" onclick="filterNotifications('request')">
                <i class="fas fa-file-medical"></i> Requests
            </button>
        </div>

        <!-- Notifications List -->
        <div class="notifications-container">
            <c:choose>
                <c:when test="${not empty notifications}">
                    <c:forEach var="notification" items="${notifications}">
                        <div class="notification-item ${notification.read ? '' : 'unread'}" 
                             data-type="${notification.type.toLowerCase()}" 
                             data-read="${notification.read}">
                            <div class="notification-header">
                                <h4 class="notification-title">
                                    <i class="fas fa-${notification.type == 'SYSTEM' ? 'cog' : notification.type == 'ALERT' ? 'exclamation-triangle' : notification.type == 'REQUEST' ? 'file-medical' : 'bell'}"></i>
                                    ${notification.title}
                                </h4>
                                <span class="notification-type ${notification.type.toLowerCase()}">${notification.type}</span>
                            </div>
                            <div class="notification-content">
                                ${notification.message}
                            </div>
                            <div class="notification-meta">
                                <div class="notification-time">
                                    <i class="fas fa-clock"></i>
                                    <fmt:formatDate value="${notification.createdAt}" pattern="MMM dd, yyyy 'at' HH:mm"/>
                                </div>
                                <div class="notification-actions">
                                    <c:if test="${not notification.read}">
                                        <button class="btn-small btn-mark-read" onclick="markAsRead(${notification.id})">
                                            <i class="fas fa-check"></i> Mark Read
                                        </button>
                                    </c:if>
                                    <button class="btn-small btn-delete" onclick="deleteNotification(${notification.id})">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-notifications">
                        <i class="fas fa-bell-slash"></i>
                        <h3>No notifications found</h3>
                        <p>You don't have any notifications from coordinators yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        // Filter notifications
        function filterNotifications(filter) {
            const items = document.querySelectorAll('.notification-item');
            const buttons = document.querySelectorAll('.filter-btn');
            
            // Update active button
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            // Filter items
            items.forEach(item => {
                if (filter === 'all') {
                    item.style.display = 'block';
                } else if (filter === 'unread') {
                    item.style.display = item.dataset.read === 'false' ? 'block' : 'none';
                } else {
                    item.style.display = item.dataset.type === filter ? 'block' : 'none';
                }
            });
        }

        // Mark notification as read
        function markAsRead(notificationId) {
            fetch('${pageContext.request.contextPath}/hospital/notifications', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=markRead&id=' + notificationId
            })
            .then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    alert('Error marking notification as read');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error marking notification as read');
            });
        }

        // Delete notification
        function deleteNotification(notificationId) {
            if (confirm('Are you sure you want to delete this notification?')) {
                fetch('${pageContext.request.contextPath}/hospital/notifications', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=delete&id=' + notificationId
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('Error deleting notification');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error deleting notification');
                });
            }
        }

        // Auto-refresh every 30 seconds
        setInterval(function() {
            location.reload();
        }, 30000);
    </script>
</body>
</html>


