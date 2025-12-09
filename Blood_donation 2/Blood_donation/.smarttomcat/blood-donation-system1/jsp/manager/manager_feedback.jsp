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
    <title>Blood Donation System - Feedback Management</title>
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

        .filter-tabs {
            display: flex;
            gap: 1rem;
            margin: 1.5rem 0;
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

        .feedback-table {
            background: var(--white);
            border-radius: 8px;
            box-shadow: var(--shadow);
            overflow: hidden;
            margin: 1rem 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background-color: var(--primary);
            color: var(--white);
            padding: 1rem;
            text-align: left;
            font-weight: 500;
        }

        td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover {
            background-color: #f8f9fa;
        }

        .status-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: uppercase;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-responded {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .status-escalated {
            background-color: #f8d7da;
            color: #721c24;
        }

        .status-resolved {
            background-color: #d4edda;
            color: #155724;
        }

        .category-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .category-general {
            background-color: #e9ecef;
            color: #495057;
        }

        .category-complaint {
            background-color: #f8d7da;
            color: #721c24;
        }

        .category-suggestion {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .category-urgent {
            background-color: #fdeaea;
            color: #e74c3c;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn {
            padding: 0.4rem 0.8rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
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

        .btn-danger {
            background-color: var(--danger);
            color: var(--white);
        }

        .btn-danger:hover {
            background-color: #c0392b;
        }

        .btn-small {
            padding: 0.3rem 0.6rem;
            font-size: 0.75rem;
        }

        .feedback-text {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .urgent-indicator {
            color: var(--danger);
            font-weight: bold;
        }

        .no-data {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .no-data i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--border);
        }

        @media (max-width: 768px) {
            .filter-tabs {
                flex-direction: column;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .feedback-table {
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1><i class="fas fa-comments"></i> Feedback Management</h1>
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
        <a href="${pageContext.request.contextPath}/admin-feedback" class="active">
            <i class="fas fa-comments"></i> Feedback
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <h2><i class="fas fa-comments"></i> ${title}</h2>
        
        <c:if test="${not empty error}">
            <div class="alert error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> Feedback ${success} successfully!
            </div>
        </c:if>

        <!-- Filter Tabs -->
        <div class="filter-tabs">
            <a href="${pageContext.request.contextPath}/admin-feedback" 
               class="filter-tab ${empty title or title == 'All Feedback' ? 'active' : ''}">
                <i class="fas fa-list"></i> All Feedback
            </a>
            <a href="${pageContext.request.contextPath}/admin-feedback/pending" 
               class="filter-tab ${title == 'Pending Feedback' ? 'active' : ''}">
                <i class="fas fa-clock"></i> Pending
            </a>
            <a href="${pageContext.request.contextPath}/admin-feedback/urgent" 
               class="filter-tab ${title == 'Urgent Feedback' ? 'active' : ''}">
                <i class="fas fa-exclamation-triangle"></i> Urgent
            </a>
            <a href="${pageContext.request.contextPath}/admin-feedback/resolved" 
               class="filter-tab ${title == 'Resolved Feedback' ? 'active' : ''}">
                <i class="fas fa-check-circle"></i> Resolved
            </a>
        </div>

        <!-- Feedback Table -->
        <div class="feedback-table">
            <c:choose>
                <c:when test="${not empty feedbacks}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>User</th>
                                <th>Category</th>
                                <th>Feedback</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="feedback" items="${feedbacks}">
                                <tr>
                                    <td>${feedback.id}</td>
                                    <td>User #${feedback.userId}</td>
                                    <td>
                                        <span class="category-badge category-${feedback.category.toLowerCase()}">
                                            ${feedback.category}
                                        </span>
                                        <c:if test="${feedback.urgent}">
                                            <span class="urgent-indicator">!</span>
                                        </c:if>
                                    </td>
                                    <td class="feedback-text" title="${feedback.feedbackText}">
                                        ${feedback.feedbackText}
                                    </td>
                                    <td>
                                        <span class="status-badge status-${feedback.status.toLowerCase()}">
                                            ${feedback.status}
                                        </span>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${feedback.createdAt}" pattern="MMM dd, yyyy HH:mm"/>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <c:if test="${feedback.status == 'PENDING' or feedback.status == 'ESCALATED'}">
                                                <form method="post" action="${pageContext.request.contextPath}/admin-feedback/resolve" 
                                                      style="display: inline;">
                                                    <input type="hidden" name="feedback_id" value="${feedback.id}">
                                                    <button type="submit" class="btn btn-success btn-small">
                                                        <i class="fas fa-check"></i> Resolve
                                                    </button>
                                                </form>
                                            </c:if>
                                            <form method="post" action="${pageContext.request.contextPath}/admin-feedback/delete" 
                                                  style="display: inline;"
                                                  onsubmit="return confirm('Are you sure you want to delete this feedback?')">
                                                <input type="hidden" name="feedback_id" value="${feedback.id}">
                                                <button type="submit" class="btn btn-danger btn-small">
                                                    <i class="fas fa-trash"></i> Delete
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <i class="fas fa-comments"></i>
                        <h3>No feedback found</h3>
                        <p>There are no feedback entries matching your current filter.</p>
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
    </script>
</body>
</html>



