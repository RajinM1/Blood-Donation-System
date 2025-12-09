<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Blood donation system1 - Medical Staff Dashboard</title>
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
            max-width: 1200px;
            margin: 2rem auto;
            background-color: var(--white);
            border-radius: 8px;
            box-shadow: var(--shadow);
        }

        h2 {
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        h3 {
            color: var(--primary);
            margin: 2rem 0 1rem;
            font-weight: 500;
            border-bottom: 2px solid var(--border);
            padding-bottom: 0.5rem;
        }

        .alert {
            padding: 1rem;
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

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }

        .action-card {
            background-color: var(--white);
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
            border-left: 4px solid var(--primary);
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        }

        .action-card i {
            font-size: 2rem;
            color: var(--primary);
        }

        .action-card h4 {
            font-weight: 600;
            color: var(--text-dark);
        }

        .action-card p {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .action-card a {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            margin-top: auto;
            transition: all 0.3s ease;
        }

        .action-card a:hover {
            color: var(--primary-dark);
            transform: translateX(5px);
        }

        .welcome-message {
            background-color: #f0e5f5;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .welcome-message i {
            font-size: 2rem;
            color: var(--primary);
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

            .quick-actions {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-user-md"></i>
        <h1>Medical Staff Dashboard</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/medical/dashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/medical/blood-reports">
            <i class="fas fa-file-medical"></i> Blood Reports
        </a>
        <a href="${pageContext.request.contextPath}/medical/donors">
            <i class="fas fa-users"></i> Donors
        </a>
        <a href="${pageContext.request.contextPath}/medical/blood-stock">
            <i class="fas fa-boxes"></i> Blood Stock
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <div class="welcome-message">
            <i class="fas fa-hand-wave"></i>
            <div>
                <h2>Welcome, ${sessionScope.user.username}</h2>
                <p>You have full access to medical donor management system</p>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <!-- Statistics Section -->
        <h3><i class="fas fa-chart-bar"></i> Statistics Overview</h3>
        <div class="quick-actions" style="margin-bottom: 2rem;">
            <div class="action-card" style="border-left-color: #ff9800;">
                <i class="fas fa-clock" style="color: #ff9800;"></i>
                <h4>Pending Reports</h4>
                <p style="font-size: 2rem; font-weight: bold; color: #ff9800; margin: 0.5rem 0;">${pendingReports.size()}</p>
                <p>Blood reports awaiting review</p>
            </div>
            
            <div class="action-card" style="border-left-color: #4caf50;">
                <i class="fas fa-check-circle" style="color: #4caf50;"></i>
                <h4>Approved Reports</h4>
                <p style="font-size: 2rem; font-weight: bold; color: #4caf50; margin: 0.5rem 0;">${approvedReports.size()}</p>
                <p>Reports approved by medical staff</p>
            </div>
            
            <div class="action-card" style="border-left-color: #f44336;">
                <i class="fas fa-times-circle" style="color: #f44336;"></i>
                <h4>Rejected Reports</h4>
                <p style="font-size: 2rem; font-weight: bold; color: #f44336; margin: 0.5rem 0;">${rejectedReports.size()}</p>
                <p>Reports rejected by medical staff</p>
            </div>
            
            <div class="action-card" style="border-left-color: #2196f3;">
                <i class="fas fa-users" style="color: #2196f3;"></i>
                <h4>Total Donors</h4>
                <p style="font-size: 2rem; font-weight: bold; color: #2196f3; margin: 0.5rem 0;">${allDonors.size()}</p>
                <p>Registered donors in the system</p>
            </div>
        </div>

        <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
        <div class="quick-actions">
            <div class="action-card">
                <i class="fas fa-file-medical"></i>
                <h4>Blood Reports</h4>
                <p>Review and approve blood test results and laboratory reports</p>
                <a href="${pageContext.request.contextPath}/medical/blood-reports">
                    Review Reports <i class="fas fa-arrow-right"></i>
                </a>
            </div>

            <div class="action-card">
                <i class="fas fa-users"></i>
                <h4>Donor Management</h4>
                <p>View and manage all donor information including contact details and medical history</p>
                <a href="${pageContext.request.contextPath}/medical/donors">
                    Access Donor Details <i class="fas fa-arrow-right"></i>
                </a>
            </div>

            <div class="action-card">
                <i class="fas fa-boxes"></i>
                <h4>Blood Stock</h4>
                <p>Manage blood inventory, track stock levels, and monitor expiry dates</p>
                <a href="${pageContext.request.contextPath}/medical/blood-stock">
                    Manage Stock <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>

        <!-- Recent Reports Section -->
        <c:if test="${not empty recentReports}">
            <h3><i class="fas fa-file-medical"></i> Recent Blood Reports</h3>
            <div style="background: white; border-radius: 8px; box-shadow: var(--shadow); overflow: hidden;">
                <table style="width: 100%; border-collapse: collapse;">
                    <thead style="background: #f8f9fa;">
                        <tr>
                            <th style="padding: 1rem; text-align: left; border-bottom: 1px solid #dee2e6;">Report ID</th>
                            <th style="padding: 1rem; text-align: left; border-bottom: 1px solid #dee2e6;">Donor ID</th>
                            <th style="padding: 1rem; text-align: left; border-bottom: 1px solid #dee2e6;">Status</th>
                            <th style="padding: 1rem; text-align: left; border-bottom: 1px solid #dee2e6;">Created</th>
                            <th style="padding: 1rem; text-align: left; border-bottom: 1px solid #dee2e6;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="report" items="${recentReports}" varStatus="status">
                            <c:if test="${status.index < 5}">
                                <tr style="border-bottom: 1px solid #f1f3f4;">
                                    <td style="padding: 1rem;">#${report.id}</td>
                                    <td style="padding: 1rem;">#${report.donorId}</td>
                                    <td style="padding: 1rem;">
                                        <span style="padding: 0.25rem 0.5rem; border-radius: 4px; font-size: 0.75rem; font-weight: bold; text-transform: uppercase; 
                                              background-color: ${report.status == 'PENDING' ? '#fff3cd' : report.status == 'APPROVED' ? '#d4edda' : '#f8d7da'}; 
                                              color: ${report.status == 'PENDING' ? '#856404' : report.status == 'APPROVED' ? '#155724' : '#721c24'};">
                                            ${report.status}
                                        </span>
                                    </td>
                                    <td style="padding: 1rem;">
                                        <c:if test="${not empty report.createdAt}">
                                            <fmt:formatDate value="${report.createdAt}" pattern="MMM dd, yyyy HH:mm" />
                                        </c:if>
                                    </td>
                                    <td style="padding: 1rem;">
                                        <a href="${pageContext.request.contextPath}/medical/blood-reports" 
                                           style="color: var(--primary); text-decoration: none; font-weight: 500;">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
                <div style="padding: 1rem; text-align: center; background: #f8f9fa; border-top: 1px solid #dee2e6;">
                    <a href="${pageContext.request.contextPath}/medical/blood-reports" 
                       style="color: var(--primary); text-decoration: none; font-weight: 500;">
                        <i class="fas fa-arrow-right"></i> View All Reports
                    </a>
                </div>
            </div>
        </c:if>
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