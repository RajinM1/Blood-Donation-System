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
    <title>Blood donation system1 - Manager Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

        #stockChart {
            background-color: var(--white);
            padding: 1rem;
            border-radius: 6px;
            box-shadow: var(--shadow);
            margin: 1rem 0;
            border: 1px solid var(--border);
        }

        .quick-actions ul {
            list-style: none;
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-top: 1rem;
        }

        .quick-actions li {
            margin-bottom: 0;
        }

        .quick-actions a {
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

        .quick-actions a:hover {
            background-color: var(--primary-dark);
        }

        /* Statistics Grid */
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
            display: flex;
            align-items: center;
            gap: 1rem;
            border-left: 4px solid var(--primary);
        }

        .stat-icon {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        .stat-content h4 {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.25rem;
        }

        .stat-change {
            font-size: 0.8rem;
            font-weight: 500;
        }

        .stat-change.positive {
            color: #27ae60;
        }

        .stat-change.negative {
            color: #e74c3c;
        }

        /* Chart Container */
        .chart-container {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            margin: 1rem 0;
        }
        
        /* Blood Stock Summary */
        .blood-stock-summary {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            margin: 1rem 0;
        }
        
        .blood-stock-summary h4 {
            color: var(--primary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .stock-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 1rem;
        }
        
        .stock-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 1rem;
            background: var(--background);
            border-radius: 6px;
            border: 2px solid var(--border);
            transition: all 0.2s;
        }
        
        .stock-item:hover {
            border-color: var(--primary);
            transform: translateY(-2px);
        }
        
        .blood-group {
            font-weight: 600;
            color: var(--primary);
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
        }
        
        .stock-quantity {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        /* Dashboard Grid */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin: 2rem 0;
        }

        .dashboard-section {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
        }

        .dashboard-section h3 {
            margin-bottom: 1rem;
            color: var(--primary);
            border-bottom: 2px solid var(--border);
            padding-bottom: 0.5rem;
        }

        /* Alert List */
        .alert-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .alert-item {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            padding: 1rem;
            border-radius: 6px;
            border-left: 4px solid;
        }

        .alert-item.urgent {
            background: #fdeaea;
            border-left-color: #e74c3c;
        }

        .alert-item.warning {
            background: #fff3cd;
            border-left-color: #ffc107;
        }

        .alert-item.info {
            background: #d1ecf1;
            border-left-color: #17a2b8;
        }

        .alert-item.danger {
            background: #f8d7da;
            border-left-color: #dc3545;
        }

        .alert-item i {
            margin-top: 0.25rem;
        }

        .alert-item strong {
            display: block;
            margin-bottom: 0.25rem;
        }

        .alert-item p {
            color: var(--text-light);
            font-size: 0.9rem;
            margin: 0;
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
            border-radius: 6px;
        }

        .activity-item i {
            color: var(--primary);
            margin-top: 0.25rem;
        }

        .activity-item strong {
            display: block;
            margin-bottom: 0.25rem;
            color: var(--text-dark);
        }

        .activity-item p {
            color: var(--text-light);
            font-size: 0.9rem;
            margin: 0;
        }

        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
            
            .quick-actions ul {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1><i class="fas fa-tachometer-alt"></i> Manager Dashboard</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=manager" class="active">
            <i class="fas fa-home"></i> Dashboard
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
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <h2><i class="fas fa-user"></i> Welcome, ${sessionScope.user.username}</h2>
        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-content">
                    <h4>Total Users</h4>
                    <p class="stat-number">${totalUsers}</p>
                    <span class="stat-change positive">Active users in system</span>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-hand-holding-heart"></i>
                </div>
                <div class="stat-content">
                    <h4>Active Donors</h4>
                    <p class="stat-number">${activeDonors}</p>
                    <span class="stat-change positive">Approved donors</span>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-tint"></i>
                </div>
                <div class="stat-content">
                    <h4>Blood Units</h4>
                    <p class="stat-number">${totalBloodUnits}</p>
                    <span class="stat-change positive">Total units in stock</span>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-hospital"></i>
                </div>
                <div class="stat-content">
                    <h4>Hospitals</h4>
                    <p class="stat-number">${totalHospitals}</p>
                    <span class="stat-change positive">Registered hospitals</span>
                </div>
            </div>
        </div>

        <h3><i class="fas fa-chart-line"></i> Blood Stock Overview</h3>
        <div class="chart-container">
            <canvas id="stockChart"></canvas>
        </div>
        
        <!-- Blood Stock Summary -->
        <div class="blood-stock-summary">
            <h4><i class="fas fa-tint"></i> Blood Stock by Group</h4>
            <div class="stock-grid">
                <c:forEach var="stock" items="${bloodStockByGroup}">
                    <div class="stock-item">
                        <span class="blood-group">${stock.key}</span>
                        <span class="stock-quantity">${stock.value} units</span>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="dashboard-grid">
            <div class="dashboard-section">
                <h3><i class="fas fa-exclamation-triangle"></i> Alerts & Notifications</h3>
                <div class="alert-list">
                    <c:if test="${urgentFeedback > 0}">
                        <div class="alert-item urgent">
                            <i class="fas fa-exclamation-circle"></i>
                            <div>
                                <strong>Urgent Feedback</strong>
                                <p>${urgentFeedback} urgent feedback items need attention</p>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${pendingAppointments > 0}">
                        <div class="alert-item warning">
                            <i class="fas fa-clock"></i>
                            <div>
                                <strong>Pending Appointments</strong>
                                <p>${pendingAppointments} appointments awaiting approval</p>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${pendingBloodRequests > 0}">
                        <div class="alert-item info">
                            <i class="fas fa-tint"></i>
                            <div>
                                <strong>Blood Requests</strong>
                                <p>${pendingBloodRequests} blood requests pending approval</p>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${lowStockAlerts > 0}">
                        <div class="alert-item danger">
                            <i class="fas fa-exclamation-triangle"></i>
                            <div>
                                <strong>Low Stock Alert</strong>
                                <p>${lowStockAlerts} blood groups are running low on stock</p>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${urgentFeedback == 0 && pendingAppointments == 0 && pendingBloodRequests == 0 && lowStockAlerts == 0}">
                        <div class="alert-item info">
                            <i class="fas fa-check-circle"></i>
                            <div>
                                <strong>All Good</strong>
                                <p>No pending items requiring attention</p>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="dashboard-section">
                <h3><i class="fas fa-chart-pie"></i> Recent Activity</h3>
                <div class="activity-list">
                    <c:choose>
                        <c:when test="${not empty recentActivities}">
                            <c:forEach var="activity" items="${recentActivities}" varStatus="status">
                                <c:if test="${status.index < 3}">
                                    <div class="activity-item">
                                        <i class="fas fa-${activity.icon}"></i>
                                        <div>
                                            <strong>${activity.title}</strong>
                                            <p>${activity.description}</p>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="activity-item">
                                <i class="fas fa-info-circle"></i>
                                <div>
                                    <strong>No Recent Activity</strong>
                                    <p>No recent activities to display</p>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
        <div class="quick-actions">
            <ul>
                <li>
                    <a href="${pageContext.request.contextPath}/user-management">
                        <i class="fas fa-users"></i> Manage Users
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/stock">
                        <i class="fas fa-boxes"></i> View Inventory
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/reports">
                        <i class="fas fa-file-alt"></i> Generate Reports
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin-feedback">
                        <i class="fas fa-comments"></i> View Feedback
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/alerts">
                        <i class="fas fa-bell"></i> Manage Alerts
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/settings">
                        <i class="fas fa-cog"></i> System Settings
                    </a>
                </li>
            </ul>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
    <script>
        window.onload = function() {
            loadDashboardCharts();
            loadBloodStockChart();
        };
        
        function loadBloodStockChart() {
            const ctx = document.getElementById('stockChart').getContext('2d');
            const bloodStockData = {
                <c:forEach var="stock" items="${bloodStockByGroup}" varStatus="status">
                    '${stock.key}': ${stock.value}<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            };
            
            const labels = Object.keys(bloodStockData);
            const data = Object.values(bloodStockData);
            
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Blood Units',
                        data: data,
                        backgroundColor: [
                            '#e74c3c',
                            '#3498db',
                            '#2ecc71',
                            '#f39c12',
                            '#9b59b6',
                            '#1abc9c',
                            '#e67e22',
                            '#34495e'
                        ],
                        borderColor: [
                            '#c0392b',
                            '#2980b9',
                            '#27ae60',
                            '#e67e22',
                            '#8e44ad',
                            '#16a085',
                            '#d35400',
                            '#2c3e50'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        title: {
                            display: true,
                            text: 'Blood Stock by Group'
                        }
                    }
                }
            });
        }
    </script>

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