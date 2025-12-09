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
    <title>Submit Feedback</title>
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
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert {
            padding: 0.8rem 1rem;
            margin: 1rem 0;
            border-radius: 4px;
            background-color: #fdecea;
            color: var(--error);
            border-left: 4px solid var(--error);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-container {
            background-color: var(--white);
            padding: 2rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
            margin-top: 1rem;
            max-width: 800px;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            font-weight: 500;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        textarea {
            width: 100%;
            padding: 1rem;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 1rem;
            min-height: 150px;
            resize: vertical;
            transition: border-color 0.3s;
            font-family: 'Poppins', sans-serif;
        }

        textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(231, 76, 60, 0.2);
        }

        button {
            background-color: var(--primary);
            color: var(--white);
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 4px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        button:hover {
            background-color: var(--primary-dark);
        }

        /* Success Alert */
        .alert.success {
            background-color: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        /* Feedback List Styles */
        .feedback-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            margin-top: 1rem;
        }

        .feedback-item {
            background: var(--background);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 1.5rem;
            transition: box-shadow 0.3s;
        }

        .feedback-item:hover {
            box-shadow: var(--shadow);
        }

        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            flex-wrap: wrap;
            gap: 0.5rem;
        }

        .feedback-date {
            color: var(--text-light);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .feedback-status {
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .status-pending {
            background: #fff3e0;
            color: #f57c00;
        }

        .status-responded {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .status-resolved {
            background: #e3f2fd;
            color: #1976d2;
        }

        .status-escalated {
            background: #fce4ec;
            color: #c2185b;
        }

        .feedback-content {
            margin-bottom: 1rem;
        }

        .feedback-content p {
            color: var(--text-dark);
            line-height: 1.6;
            margin: 0;
        }

        .feedback-response {
            background: var(--white);
            border-left: 4px solid var(--primary);
            padding: 1rem;
            border-radius: 4px;
            margin-top: 1rem;
        }

        .feedback-response strong {
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
        }

        .feedback-response p {
            color: var(--text-dark);
            margin: 0;
            font-style: italic;
        }

        .no-feedback {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .no-feedback h3 {
            margin-bottom: 1rem;
            color: var(--text-medium);
        }

        h3 {
            color: var(--primary);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        @media (max-width: 768px) {
            .form-container {
                padding: 1.5rem;
            }
            
            .feedback-header {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-comment-dots"></i>
        <h1>Submit Feedback</h1>
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
        <a href="${pageContext.request.contextPath}/donor-page/feedback" class="active">
            <i class="fas fa-comment"></i> Feedback
        </a>
        <a href="${pageContext.request.contextPath}/donor-page/notifications">
            <i class="fas fa-bell"></i> Notifications
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <h2><i class="fas fa-edit"></i> Share Your Feedback</h2>
        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty param.success}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> Feedback submitted successfully!
            </div>
        </c:if>
        <div class="form-container">
            <form action="${pageContext.request.contextPath}/feedback/submit" method="post">
                <div class="form-group">
                    <label for="feedback_text"><i class="fas fa-comment-alt"></i> Your Feedback:</label>
                    <textarea id="feedback_text" name="feedback_text" placeholder="Please share your experience or suggestions..." required></textarea>
                </div>
                <button type="submit">
                    <i class="fas fa-paper-plane"></i> Submit Feedback
                </button>
            </form>
        </div>
        
        <!-- View Submitted Feedbacks Section -->
        <div class="form-container" style="margin-top: 2rem;">
            <h3><i class="fas fa-list"></i> Your Submitted Feedbacks</h3>
            <c:choose>
                <c:when test="${not empty feedbacks}">
                    <div class="feedback-list">
                        <c:forEach var="feedback" items="${feedbacks}">
                            <div class="feedback-item">
                                <div class="feedback-header">
                                    <span class="feedback-date">
                                        <i class="fas fa-calendar"></i> 
                                        <fmt:formatDate value="${feedback.createdAt}" pattern="MMM dd, yyyy 'at' HH:mm" />
                                    </span>
                                    <span class="feedback-status status-${feedback.status.toLowerCase()}">
                                        <i class="fas fa-${feedback.status eq 'PENDING' ? 'clock' : feedback.status eq 'RESPONDED' ? 'check-circle' : feedback.status eq 'RESOLVED' ? 'check-double' : 'exclamation-circle'}"></i>
                                        ${feedback.status}
                                    </span>
                                </div>
                                <div class="feedback-content">
                                    <p>${feedback.feedbackText}</p>
                                </div>
                                <c:if test="${not empty feedback.response}">
                                    <div class="feedback-response">
                                        <strong><i class="fas fa-reply"></i> Response:</strong>
                                        <p>${feedback.response}</p>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-feedback">
                        <i class="fas fa-comment-slash fa-3x" style="color: var(--text-light); margin-bottom: 1rem;"></i>
                        <h3>No feedback submitted yet</h3>
                        <p>Your submitted feedbacks will appear here</p>
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