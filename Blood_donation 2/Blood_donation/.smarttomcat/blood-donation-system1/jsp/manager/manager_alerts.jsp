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
    <title>Blood Donation System - Alerts Management</title>
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
            --success: #27ae60;
            --warning: #f39c12;
            --danger: #e74c3c;
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
        }

        nav {
            background-color: var(--white);
            padding: 0.9rem 2rem;
            display: flex;
            gap: 1.5rem;
            box-shadow: var(--shadow);
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

        .alert {
            padding: 0.8rem 1rem;
            margin: 1rem 0;
            border-radius: 4px;
            background-color: #fdecea;
            color: var(--primary-dark);
            border-left: 4px solid var(--primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert.success {
            background-color: #d4edda;
            color: #155724;
            border-left-color: var(--success);
        }

        .alert.error {
            background-color: #f8d7da;
            color: #721c24;
            border-left-color: var(--danger);
        }

        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 1.5rem 0;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .filter-tabs {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .filter-tab {
            padding: 0.5rem 1rem;
            background-color: var(--white);
            border: 2px solid var(--border);
            border-radius: 4px;
            text-decoration: none;
            color: var(--text-dark);
            font-weight: 500;
            transition: all 0.2s;
        }

        .filter-tab:hover {
            border-color: var(--primary);
            color: var(--primary);
        }

        .filter-tab.active {
            background-color: var(--primary);
            color: var(--white);
            border-color: var(--primary);
        }

        .btn {
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s;
        }

        .btn-primary {
            background-color: var(--primary);
            color: var(--white);
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
        }

        .btn-success {
            background-color: var(--success);
            color: var(--white);
        }

        .btn-success:hover {
            background-color: #229954;
        }

        .btn-warning {
            background-color: var(--warning);
            color: var(--white);
        }

        .btn-warning:hover {
            background-color: #e67e22;
        }

        .btn-small {
            padding: 0.4rem 0.8rem;
            font-size: 0.8rem;
        }

        .alerts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            margin: 1rem 0;
        }

        .alert-card {
            background: var(--white);
            border-radius: 8px;
            box-shadow: var(--shadow);
            padding: 1.5rem;
            border-left: 4px solid;
            transition: transform 0.2s;
        }

        .alert-card:hover {
            transform: translateY(-2px);
        }

        .alert-card.urgent {
            border-left-color: var(--danger);
        }

        .alert-card.high {
            border-left-color: var(--warning);
        }

        .alert-card.medium {
            border-left-color: var(--info);
        }

        .alert-card.low {
            border-left-color: var(--success);
        }

        .alert-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .alert-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .alert-message {
            color: var(--text-light);
            margin-bottom: 1rem;
            line-height: 1.5;
        }

        .alert-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.8rem;
            color: var(--text-light);
            margin-bottom: 1rem;
        }

        .priority-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .priority-urgent {
            background-color: #f8d7da;
            color: #721c24;
        }

        .priority-high {
            background-color: #fff3cd;
            color: #856404;
        }

        .priority-medium {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .priority-low {
            background-color: #d4edda;
            color: #155724;
        }

        .alert-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .no-data {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
            grid-column: 1 / -1;
        }

        .no-data i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--border);
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: var(--white);
            margin: 5% auto;
            padding: 2rem;
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .close {
            color: var(--text-light);
            font-size: 1.5rem;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: var(--text-dark);
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text-dark);
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.6rem;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 0.9rem;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        @media (max-width: 768px) {
            .header-actions {
                flex-direction: column;
                align-items: stretch;
            }
            
            .filter-tabs {
                justify-content: center;
            }
            
            .alerts-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1><i class="fas fa-bell"></i> Alerts Management</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=manager">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/user-management">
            <i class="fas fa-users-cog"></i> User Management
        </a>
        <a href="${pageContext.request.contextPath}/stock">
            <i class="fas fa-warehouse"></i> Inventory
        </a>
        <a href="${pageContext.request.contextPath}/reports">
            <i class="fas fa-chart-bar"></i> Reports
        </a>
        <a href="${pageContext.request.contextPath}/alerts" class="active">
            <i class="fas fa-bell"></i> Alerts
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <h2><i class="fas fa-bell"></i> ${title}</h2>
        
        <c:if test="${not empty error}">
            <div class="alert error">
                <i class="fas fa-exclamation-circle"></i> 
                <c:choose>
                    <c:when test="${param.error == 'emailfailed'}">Failed to send email. Please check email configuration.</c:when>
                    <c:otherwise>${error}</c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <c:if test="${not empty success or not empty param.success}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> 
                <c:choose>
                    <c:when test="${param.success == 'mailsent'}">Email sent successfully to blooddonationsystem1@gmail.com!</c:when>
                    <c:when test="${param.success == 'mailsimulated'}">Email notification logged (check console for details)</c:when>
                    <c:when test="${success == 'mailsent'}">Email sent successfully to blooddonationsystem1@gmail.com!</c:when>
                    <c:when test="${success == 'mailsimulated'}">Email notification logged (check console for details)</c:when>
                    <c:when test="${not empty param.success}">Alert ${param.success} successfully!</c:when>
                    <c:otherwise>Alert ${success} successfully!</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Header Actions -->
        <div class="header-actions">
            <div class="filter-tabs">
                <a href="${pageContext.request.contextPath}/alerts" 
                   class="filter-tab ${empty title or title == 'All Alerts' ? 'active' : ''}">
                    <i class="fas fa-list"></i> All Alerts
                </a>
                <a href="${pageContext.request.contextPath}/alerts/active" 
                   class="filter-tab ${title == 'Active Alerts' ? 'active' : ''}">
                    <i class="fas fa-bell"></i> Active
                </a>
                <a href="${pageContext.request.contextPath}/alerts/urgent" 
                   class="filter-tab ${title == 'Urgent Alerts' ? 'active' : ''}">
                    <i class="fas fa-exclamation-triangle"></i> Critical
                </a>
                <a href="${pageContext.request.contextPath}/alerts/resolved" 
                   class="filter-tab ${title == 'Resolved Alerts' ? 'active' : ''}">
                    <i class="fas fa-check-circle"></i> Resolved
                </a>
            </div>
            <button class="btn btn-primary" onclick="openCreateModal()">
                <i class="fas fa-plus"></i> Create Alert
            </button>
        </div>

        <!-- Alerts Grid -->
        <div class="alerts-grid">
            <c:choose>
                <c:when test="${not empty alerts}">
                    <c:forEach var="alert" items="${alerts}">
                        <div class="alert-card ${alert.priority}">
                            <div class="alert-header">
                                <div>
                                    <div class="alert-title">${alert.title}</div>
                                    <span class="priority-badge priority-${alert.priority}">
                                        ${alert.priority}
                                    </span>
                                </div>
                            </div>
                            <div class="alert-message">${alert.message}</div>
                            <div class="alert-meta">
                                <span><i class="fas fa-tag"></i> ${alert.type}</span>
                                <span><i class="fas fa-clock"></i> 
                                    <fmt:formatDate value="${alert.createdAt}" pattern="MMM dd, HH:mm"/>
                                </span>
                            </div>
                            <div class="alert-actions">
                                <c:if test="${alert.status == 'ACTIVE'}">
                                    <form method="post" action="${pageContext.request.contextPath}/alerts/resolve" 
                                          style="display: inline;">
                                        <input type="hidden" name="alert_id" value="${alert.id}">
                                        <input type="hidden" name="resolution" value="Resolved by admin">
                                        <button type="submit" class="btn btn-success btn-small">
                                            <i class="fas fa-check"></i> Resolve
                                        </button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/alerts/dismiss" 
                                          style="display: inline;">
                                        <input type="hidden" name="alert_id" value="${alert.id}">
                                        <button type="submit" class="btn btn-warning btn-small">
                                            <i class="fas fa-times"></i> Dismiss
                                        </button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/alerts/sendmail" 
                                          style="display: inline;">
                                        <input type="hidden" name="alert_id" value="${alert.id}">
                                        <button type="submit" class="btn btn-primary btn-small">
                                            <i class="fas fa-envelope"></i> Send Mail
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <i class="fas fa-bell-slash"></i>
                        <h3>No alerts found</h3>
                        <p>There are no alerts matching your current filter.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Create Alert Modal -->
    <div id="createModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Create New Alert</h3>
                <span class="close" onclick="closeCreateModal()">&times;</span>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/alerts/create">
                <div class="form-group">
                    <label for="title">Alert Title</label>
                    <input type="text" id="title" name="title" required>
                </div>
                <div class="form-group">
                    <label for="message">Message</label>
                    <textarea id="message" name="message" required></textarea>
                </div>
                <div class="form-group">
                    <label for="priority">Priority</label>
                    <select id="priority" name="priority" required>
                        <option value="LOW">Low</option>
                        <option value="MEDIUM">Medium</option>
                        <option value="HIGH">High</option>
                        <option value="CRITICAL">Critical</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="type">Type</label>
                    <select id="type" name="type" required>
                        <option value="SYSTEM">System</option>
                        <option value="STOCK">Stock</option>
                        <option value="USER">User</option>
                        <option value="SECURITY">Security</option>
                        <option value="GENERAL">General</option>
                    </select>
                </div>
                <div style="text-align: right;">
                    <button type="button" class="btn btn-warning" onclick="closeCreateModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create Alert</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openCreateModal() {
            document.getElementById('createModal').style.display = 'block';
        }

        function closeCreateModal() {
            document.getElementById('createModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('createModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }

        // Prevent back button access after logout
        window.history.pushState(null, null, window.location.href);
        window.onpopstate = function(event) {
            window.history.pushState(null, null, window.location.href);
        };
    </script>
</body>
</html>



