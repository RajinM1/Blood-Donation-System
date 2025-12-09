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
    <title>Hospital Feedbacks - Coordinator</title>
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
            --success-light: #d5f4e6;
            --error: #e74c3c;
            --error-light: #fdecea;
            --warning: #f39c12;
            --warning-light: #fef5e7;
            --info: #3498db;
            --info-light: #ebf3fd;
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
            gap: 1rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border-bottom: 2px solid var(--border);
        }

        nav a {
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
        }

        nav a:hover, nav a.active {
            background-color: var(--primary-dark);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
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

        .feedback-container {
            background: var(--white);
            border-radius: 8px;
            box-shadow: var(--shadow);
            overflow: hidden;
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

        tr:hover {
            background-color: rgba(52, 152, 219, 0.05);
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: uppercase;
        }

        .status-pending {
            background-color: var(--warning-light);
            color: var(--warning);
        }

        .status-responded {
            background-color: var(--success-light);
            color: var(--success);
        }

        .status-escalated {
            background-color: var(--error-light);
            color: var(--error);
        }

        .status-resolved {
            background-color: var(--info-light);
            color: var(--info);
        }

        .category-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .category-general {
            background-color: var(--info-light);
            color: var(--info);
        }

        .category-complaint {
            background-color: var(--error-light);
            color: var(--error);
        }

        .category-suggestion {
            background-color: var(--success-light);
            color: var(--success);
        }

        .category-urgent {
            background-color: var(--warning-light);
            color: var(--warning);
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
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
            background-color: #27ae60;
        }

        .btn-warning {
            background-color: var(--warning);
            color: var(--white);
        }

        .btn-warning:hover {
            background-color: #e67e22;
        }

        .btn-info {
            background-color: var(--info);
            color: var(--white);
        }

        .btn-info:hover {
            background-color: #2980b9;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: var(--white);
            margin: 5% auto;
            padding: 2rem;
            border-radius: 8px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border);
        }

        .close {
            color: var(--text-light);
            font-size: 2rem;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: var(--text-dark);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text-dark);
        }

        .form-group select,
        .form-group textarea,
        .form-group input[type="text"] {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 0.9rem;
            transition: border-color 0.3s;
        }

        .form-group select:focus,
        .form-group textarea:focus,
        .form-group input[type="text"]:focus {
            outline: none;
            border-color: var(--primary);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .no-feedback {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .no-feedback i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--border);
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }
            
            nav {
                flex-wrap: wrap;
                gap: 0.5rem;
            }
            
            table {
                font-size: 0.8rem;
            }
            
            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-comment-medical fa-lg"></i>
        <h1>Hospital Feedbacks</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=hospital_coordinator">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/coordinator-request/">
            <i class="fas fa-tint"></i> Blood Requests
        </a>
        <a href="${pageContext.request.contextPath}/coordinator-stock/">
            <i class="fas fa-flask"></i> Blood Stock
        </a>
        <a href="${pageContext.request.contextPath}/coordinator-feedback/" class="active">
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
        <c:if test="${param.success == 'updated'}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> Feedback status updated successfully!
            </div>
        </c:if>
        <c:if test="${param.success == 'message_sent'}">
            <div class="alert success">
                <i class="fas fa-paper-plane"></i> Message sent to hospital successfully!
            </div>
        </c:if>

        <h2><i class="fas fa-comment-dots"></i> Hospital Feedback Management</h2>

        <div class="feedback-container">
            <c:choose>
                <c:when test="${not empty feedbacks}">
                    <table>
                        <thead>
                            <tr>
                                <th><i class="fas fa-id-card"></i> ID</th>
                                <th><i class="fas fa-hospital"></i> Hospital</th>
                                <th><i class="fas fa-comment"></i> Feedback</th>
                                <th><i class="fas fa-tags"></i> Category</th>
                                <th><i class="fas fa-info-circle"></i> Status</th>
                                <th><i class="fas fa-calendar"></i> Date</th>
                                <th><i class="fas fa-cogs"></i> Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="feedback" items="${feedbacks}">
                                <tr>
                                    <td>${feedback.id}</td>
                                    <td>
                                        <c:forEach var="user" items="${users}">
                                            <c:if test="${user.id == feedback.userId}">
                                                <strong>${user.username}</strong>
                                                <br><small style="color: var(--text-light);">${user.email}</small>
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                    <td>
                                        <div style="max-width: 200px; overflow: hidden; text-overflow: ellipsis;">
                                            ${feedback.feedbackText}
                                        </div>
                                    </td>
                                    <td>
                                        <span class="category-badge category-${feedback.category.toLowerCase()}">
                                            ${feedback.category}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-badge status-${feedback.status.toLowerCase()}">
                                            ${feedback.status}
                                        </span>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${feedback.createdAt}" pattern="MMM dd, yyyy"/>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn btn-primary" onclick="openUpdateModal(${feedback.id}, '${feedback.status}', '${feedback.response}')">
                                                <i class="fas fa-edit"></i> Update
                                            </button>
                                            <button class="btn btn-info" onclick="openMessageModal(${feedback.id}, '${feedback.userId}')">
                                                <i class="fas fa-envelope"></i> Send Message
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-feedback">
                        <i class="fas fa-comment-slash"></i>
                        <h3>No hospital feedback found</h3>
                        <p>Hospital feedback will appear here when submitted</p>
                        <p><small>Debug: Check console logs for database connection and filtering details</small></p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Update Status Modal -->
    <div id="updateModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-edit"></i> Update Feedback Status</h3>
                <span class="close" onclick="closeUpdateModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/coordinator-feedback/update-status" method="post">
                <input type="hidden" id="feedbackId" name="feedback_id">
                
                <div class="form-group">
                    <label for="status">Status:</label>
                    <select id="status" name="status" required>
                        <option value="PENDING">Pending</option>
                        <option value="RESPONDED">Responded</option>
                        <option value="ESCALATED">Escalated</option>
                        <option value="RESOLVED">Resolved</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="response">Response:</label>
                    <textarea id="response" name="response" placeholder="Enter your response to the feedback..."></textarea>
                </div>
                
                <div class="action-buttons">
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save"></i> Update Status
                    </button>
                    <button type="button" class="btn btn-primary" onclick="closeUpdateModal()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Send Message Modal -->
    <div id="messageModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-envelope"></i> Send Message to Hospital</h3>
                <span class="close" onclick="closeMessageModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/coordinator-feedback/send-message" method="post">
                <input type="hidden" id="messageFeedbackId" name="feedback_id">
                <input type="hidden" id="messageUserId" name="user_id">
                
                <div class="form-group">
                    <label for="messageSubject">Subject:</label>
                    <input type="text" id="messageSubject" name="subject" placeholder="Enter message subject..." required>
                </div>
                
                <div class="form-group">
                    <label for="messageContent">Message:</label>
                    <textarea id="messageContent" name="message" placeholder="Enter your message to the hospital..." required></textarea>
                </div>
                
                <div class="action-buttons">
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-paper-plane"></i> Send Message
                    </button>
                    <button type="button" class="btn btn-primary" onclick="closeMessageModal()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openUpdateModal(feedbackId, currentStatus, currentResponse) {
            document.getElementById('feedbackId').value = feedbackId;
            document.getElementById('status').value = currentStatus;
            document.getElementById('response').value = currentResponse || '';
            document.getElementById('updateModal').style.display = 'block';
        }

        function closeUpdateModal() {
            document.getElementById('updateModal').style.display = 'none';
        }

        function openMessageModal(feedbackId, userId) {
            document.getElementById('messageFeedbackId').value = feedbackId;
            document.getElementById('messageUserId').value = userId;
            document.getElementById('messageSubject').value = '';
            document.getElementById('messageContent').value = '';
            document.getElementById('messageModal').style.display = 'block';
        }

        function closeMessageModal() {
            document.getElementById('messageModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const updateModal = document.getElementById('updateModal');
            const messageModal = document.getElementById('messageModal');
            if (event.target == updateModal) {
                closeUpdateModal();
            } else if (event.target == messageModal) {
                closeMessageModal();
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
