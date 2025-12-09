<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Blood donation system1 - Donor Dashboard</title>
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
            color: var(--primary-dark);
            border-left: 4px solid var(--primary);
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
        }

        ul a:hover {
            background-color: var(--primary-dark);
        }

        /* Welcome Section */
        .welcome-section {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            padding: 2rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            text-align: center;
        }

        .welcome-section h2 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .welcome-section p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        /* Success Alert */
        .alert.success {
            background-color: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        /* Statistics Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }

        .stat-card {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            gap: 1rem;
            border-left: 4px solid var(--primary);
            transition: transform 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-2px);
        }

        .stat-icon {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .stat-content h4 {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }

        .stat-number {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.25rem;
        }

        .stat-desc {
            font-size: 0.8rem;
            color: var(--text-light);
        }

        /* Actions Grid */
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin: 1.5rem 0;
        }

        .action-card {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: var(--shadow);
            text-decoration: none;
            color: var(--text-dark);
            transition: all 0.3s;
            border: 2px solid transparent;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            gap: 1rem;
        }

        .action-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            border-color: var(--primary);
        }

        .action-card.primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
        }

        .action-card.primary:hover {
            background: linear-gradient(135deg, var(--primary-dark), #a93226);
        }

        .action-card i {
            font-size: 2rem;
            color: var(--primary);
        }

        .action-card.primary i {
            color: var(--white);
        }

        .action-card h4 {
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
        }

        .action-card p {
            font-size: 0.9rem;
            color: var(--text-light);
            margin: 0;
        }

        .action-card.primary p {
            color: rgba(255, 255, 255, 0.8);
        }

        /* Dashboard Section */
        .dashboard-section {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: var(--shadow);
            margin: 2rem 0;
        }

        .dashboard-section h3 {
            color: var(--primary);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border);
        }

        /* Activity List */
        .activity-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            padding: 1rem;
            background: var(--background);
            border-radius: 8px;
            border-left: 4px solid var(--primary);
        }

        .activity-item i {
            color: var(--primary);
            margin-top: 0.25rem;
            font-size: 1.1rem;
        }

        .activity-item strong {
            display: block;
            margin-bottom: 0.25rem;
            color: var(--text-dark);
        }

        .activity-item p {
            color: var(--text-light);
            font-size: 0.9rem;
            margin: 0 0 0.25rem 0;
        }

        .activity-item .time {
            font-size: 0.8rem;
            color: var(--text-light);
            font-style: italic;
        }

        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .actions-grid {
                grid-template-columns: 1fr;
            }
            
            .welcome-section h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-heartbeat"></i>
        <h1>Donor Dashboard</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/view/my-details" class="active">
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
        <a href="${pageContext.request.contextPath}/jsp/donor/donor_eligibility.jsp">
            <i class="fas fa-clipboard-check"></i> Eligibility
        </a>
        <a href="${pageContext.request.contextPath}/donor-page/summary">
            <i class="fas fa-chart-pie"></i> Summary
        </a>
        <a href="${pageContext.request.contextPath}/donor-page/feedback">
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
        <div class="welcome-section">
            <h2><i class="fas fa-hand-holding-heart"></i> Welcome back, ${sessionScope.user.username}!</h2>
            <p>Thank you for being a life-saving hero. Your donations make a difference.</p>
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

        <!-- Donor Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-tint"></i>
                </div>
                <div class="stat-content">
                    <h4>Total Donations</h4>
                    <p class="stat-number">${totalDonations != null ? totalDonations : 0}</p>
                    <span class="stat-desc">Lives saved</span>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div class="stat-content">
                    <h4>Next Eligible</h4>
                    <p class="stat-number">
                        <c:choose>
                            <c:when test="${nextEligibleDate != null}">
                                <c:set var="now" value="<%=new java.util.Date()%>" />
                                <c:set var="daysDiff" value="${(nextEligibleDate.time - now.time) / (1000 * 60 * 60 * 24)}" />
                                <c:choose>
                                    <c:when test="${daysDiff > 0}">
                                        <fmt:formatNumber value="${daysDiff}" maxFractionDigits="0" /> Days
                                    </c:when>
                                    <c:otherwise>
                                        Now
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                Now
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <span class="stat-desc">Until next donation</span>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-award"></i>
                </div>
                <div class="stat-content">
                    <h4>Donor Level</h4>
                    <p class="stat-number">${donorLevel != null ? donorLevel : 'New'}</p>
                    <span class="stat-desc">Regular donor</span>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-heart"></i>
                </div>
                <div class="stat-content">
                    <h4>Blood Type</h4>
                    <p class="stat-number">${bloodGroup != null ? bloodGroup : 'N/A'}</p>
                    <span class="stat-desc">Your blood group</span>
                </div>
            </div>
        </div>

        <!-- Quick Actions Grid -->
        <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
        <div class="actions-grid">
            <a href="${pageContext.request.contextPath}/eligibility" class="action-card primary">
                <i class="fas fa-clipboard-check"></i>
                <h4>Check Eligibility</h4>
                <p>Verify if you can donate today</p>
            </a>
            <a href="${pageContext.request.contextPath}/appointment-page" class="action-card">
                <i class="fas fa-calendar-plus"></i>
                <h4>Book Appointment</h4>
                <p>Schedule your next donation</p>
            </a>
            <a href="${pageContext.request.contextPath}/donor-page/summary" class="action-card">
                <i class="fas fa-chart-line"></i>
                <h4>View Summary</h4>
                <p>See your donation history</p>
            </a>
            <a href="${pageContext.request.contextPath}/view/my-details" class="action-card">
                <i class="fas fa-user-circle"></i>
                <h4>View My Details</h4>
                <p>See all your information</p>
            </a>
        <a href="${pageContext.request.contextPath}/view/my-blood-reports" class="action-card">
            <i class="fas fa-file-medical"></i>
            <h4>View Blood Reports</h4>
            <p>Check your test results</p>
        </a>
        <a href="${pageContext.request.contextPath}/blood-report/" class="action-card">
            <i class="fas fa-plus-circle"></i>
            <h4>Submit Blood Report</h4>
            <p>Submit new test results</p>
        </a>
            <a href="${pageContext.request.contextPath}/donor-page/donation-history" class="action-card">
                <i class="fas fa-history"></i>
                <h4>Donation History</h4>
                <p>View past donations</p>
            </a>
        </div>

        <!-- Recent Activity -->
        <div class="dashboard-section">
            <h3><i class="fas fa-clock"></i> Recent Activity</h3>
            <div class="activity-list">
                <c:choose>
                    <c:when test="${not empty notifications}">
                        <c:forEach var="notification" items="${notifications}" begin="0" end="2">
                            <div class="activity-item">
                                <i class="fas fa-bell"></i>
                                <div>
                                    <strong>Notification</strong>
                                    <p>${notification.message}</p>
                                    <span class="time">
                                        <fmt:formatDate value="${notification.createdAt}" pattern="MMM dd, yyyy 'at' HH:mm" />
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:when test="${not empty recentBloodReports}">
                        <c:forEach var="report" items="${recentBloodReports}" begin="0" end="2">
                            <div class="activity-item">
                                <i class="fas fa-tint"></i>
                                <div>
                                    <strong>Blood Report ${report.status}</strong>
                                    <p>Your blood report has been ${report.status.toLowerCase()}</p>
                                    <span class="time">
                                        <fmt:formatDate value="${report.createdAt}" pattern="MMM dd, yyyy 'at' HH:mm" />
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="activity-item">
                            <i class="fas fa-info-circle"></i>
                            <div>
                                <strong>Welcome!</strong>
                                <p>No recent activity. Start by checking your eligibility or booking an appointment.</p>
                                <span class="time">Just now</span>
                            </div>
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