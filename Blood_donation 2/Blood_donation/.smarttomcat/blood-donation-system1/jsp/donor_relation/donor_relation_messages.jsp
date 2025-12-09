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
    <title>Donor Messages</title>
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

        nav a.active {
            background-color: var(--primary);
            color: var(--white);
        }

        .container {
            padding: 2rem;
            max-width: 1200px;
            margin: 2rem auto;
        }

        h2 {
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            font-weight: 600;
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

        .messages-container {
            background-color: var(--white);
            border-radius: 8px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .messages-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            padding: 1.5rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .messages-header h3 {
            margin: 0;
            font-size: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .stats {
            display: flex;
            gap: 2rem;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: bold;
            display: block;
        }

        .stat-label {
            font-size: 0.85rem;
            opacity: 0.9;
        }

        .messages-list {
            max-height: 600px;
            overflow-y: auto;
        }

        .message-item {
            padding: 1.5rem 2rem;
            border-bottom: 1px solid var(--border);
            transition: all 0.3s ease;
        }

        .message-item:hover {
            background-color: #f8f9fa;
        }

        .message-item:last-child {
            border-bottom: none;
        }

        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.75rem;
        }

        .message-sender {
            font-weight: 600;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .message-time {
            color: var(--text-light);
            font-size: 0.85rem;
        }

        .message-title {
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }

        .message-content {
            color: var(--text-dark);
            line-height: 1.5;
        }

        .message-type {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            margin-left: 0.5rem;
        }

        .type-general {
            background-color: #e3f2fd;
            color: #1976d2;
        }

        .type-urgent {
            background-color: #ffebee;
            color: #d32f2f;
        }

        .type-info {
            background-color: #f3e5f5;
            color: #7b1fa2;
        }

        .type-general {
            background-color: #e8f5e8;
            color: #2e7d32;
        }

        .type-complaint {
            background-color: #ffebee;
            color: #c62828;
        }

        .type-suggestion {
            background-color: #e3f2fd;
            color: #1565c0;
        }

        .message-response {
            background-color: #f8f9fa;
            border-left: 3px solid var(--primary);
            padding: 1rem;
            margin-top: 1rem;
            border-radius: 4px;
        }

        .message-status {
            margin-top: 0.75rem;
        }

        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-responded {
            background-color: #d4edda;
            color: #155724;
        }

        .status-escalated {
            background-color: #f8d7da;
            color: #721c24;
        }

        .status-resolved {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .no-messages {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .no-messages i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--border);
        }

        .filter-buttons {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 0.5rem 1rem;
            border: 1px solid var(--border);
            background: var(--white);
            color: var(--text-dark);
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.85rem;
        }

        .filter-btn:hover,
        .filter-btn.active {
            background: var(--primary);
            color: var(--white);
            border-color: var(--primary);
        }

        @media (max-width: 768px) {
            nav {
                flex-direction: column;
                gap: 0.5rem;
                padding: 1rem;
            }

            .container {
                padding: 1rem;
            }

            .messages-header {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .stats {
                justify-content: center;
            }

            .message-item {
                padding: 1rem;
            }

            .message-header {
                flex-direction: column;
                gap: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-envelope"></i>
        <h1>Donor Messages</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/donor-relation/dashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/communication">
            <i class="fas fa-comments"></i> Communication
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/camp-management">
            <i class="fas fa-medkit"></i> Camp Management
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/donor-messages" class="active">
            <i class="fas fa-envelope"></i> View Messages
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    
    <div class="container">
        <h2><i class="fas fa-envelope-open"></i> Donor Messages & Notifications</h2>

        <!-- Success/Error Messages -->
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

        <!-- Filter Buttons -->
        <div class="filter-buttons">
            <button class="filter-btn active" onclick="filterMessages('all')">All Messages</button>
            <button class="filter-btn" onclick="filterMessages('pending')">Pending</button>
            <button class="filter-btn" onclick="filterMessages('urgent')">Urgent</button>
            <button class="filter-btn" onclick="filterMessages('responded')">Responded</button>
        </div>

        <!-- Messages Container -->
        <div class="messages-container">
            <div class="messages-header">
                <h3><i class="fas fa-list"></i> All Messages</h3>
                <div class="stats">
                    <div class="stat-item">
                        <span class="stat-number">${totalMessages}</span>
                        <span class="stat-label">Total</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">${pendingMessages}</span>
                        <span class="stat-label">Pending</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">${urgentMessages}</span>
                        <span class="stat-label">Urgent</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">${respondedMessages}</span>
                        <span class="stat-label">Responded</span>
                    </div>
                </div>
            </div>

            <div class="messages-list" id="messagesList">
                <c:choose>
                    <c:when test="${not empty feedback}">
                        <c:forEach var="feedback" items="${feedback}">
                            <div class="message-item" data-type="${feedback.category.toLowerCase()}" data-status="${feedback.status.toLowerCase()}" data-urgent="${feedback.urgent}">
                                <div class="message-header">
                                    <div class="message-sender">
                                        <i class="fas fa-user"></i>
                                        <c:forEach var="donor" items="${donors}">
                                            <c:if test="${donor.userId == feedback.userId}">
                                                ${donor.name}
                                            </c:if>
                                        </c:forEach>
                                        <span class="message-type type-${feedback.category.toLowerCase()}">${feedback.category}</span>
                                        <c:if test="${feedback.urgent}">
                                            <span class="message-type type-urgent">URGENT</span>
                                        </c:if>
                                    </div>
                                    <div class="message-time">
                                        <fmt:formatDate value="${feedback.createdAt}" pattern="MMM dd, yyyy HH:mm" />
                                    </div>
                                </div>
                                <div class="message-title">${feedback.category} Feedback</div>
                                <div class="message-content">${feedback.feedbackText}</div>
                                <c:if test="${not empty feedback.response}">
                                    <div class="message-response">
                                        <strong>Response:</strong> ${feedback.response}
                                        <br><small>Responded on: <fmt:formatDate value="${feedback.responseDate}" pattern="MMM dd, yyyy HH:mm" /></small>
                                    </div>
                                </c:if>
                                <div class="message-status">
                                    <span class="status-badge status-${feedback.status.toLowerCase()}">${feedback.status}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-messages">
                            <i class="fas fa-envelope-open"></i>
                            <h3>No messages found</h3>
                            <p>There are no feedback messages from donors to display.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        // Update statistics on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateStats();
        });

        function updateStats() {
            const messages = document.querySelectorAll('.message-item');
            const totalMessages = messages.length;
            const pendingMessages = document.querySelectorAll('.message-item[data-status="pending"]').length;
            
            document.getElementById('totalMessages').textContent = totalMessages;
            document.getElementById('unreadMessages').textContent = pendingMessages;
        }

        function filterMessages(filter) {
            const messages = document.querySelectorAll('.message-item');
            const buttons = document.querySelectorAll('.filter-btn');
            
            // Update button states
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            // Filter messages
            messages.forEach(message => {
                const type = message.getAttribute('data-type');
                const status = message.getAttribute('data-status');
                const isUrgent = message.getAttribute('data-urgent') === 'true';
                
                let show = true;
                
                switch(filter) {
                    case 'pending':
                        show = status === 'pending';
                        break;
                    case 'urgent':
                        show = isUrgent;
                        break;
                    case 'responded':
                        show = status === 'responded';
                        break;
                    case 'all':
                    default:
                        show = true;
                        break;
                }
                
                message.style.display = show ? 'block' : 'none';
            });
            
            // Update stats for filtered view
            const visibleMessages = document.querySelectorAll('.message-item[style*="block"], .message-item:not([style*="none"])');
            const visiblePending = document.querySelectorAll('.message-item[data-status="pending"][style*="block"], .message-item[data-status="pending"]:not([style*="none"])');
            
            document.getElementById('totalMessages').textContent = visibleMessages.length;
            document.getElementById('unreadMessages').textContent = visiblePending.length;
        }

        // Prevent back button access after logout
        window.history.pushState(null, null, window.location.href);
        window.onpopstate = function(event) {
            window.history.pushState(null, null, window.location.href);
        };
    </script>
</body>
</html>
