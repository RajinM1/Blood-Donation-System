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
    <title>View Blood Reports</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
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

        .alert.success {
            background-color: #e8f5e8;
            color: var(--success);
            border-left-color: var(--success);
        }

        .form-container {
            background-color: var(--white);
            padding: 2rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
            margin-top: 1rem;
        }

        .blood-reports-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        .blood-reports-table th,
        .blood-reports-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }

        .blood-reports-table th {
            background-color: var(--background);
            font-weight: 600;
            color: var(--text-dark);
        }

        .blood-reports-table tr:hover {
            background-color: #f8f9fa;
        }

        .status-badge {
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-pending {
            background: #fff3e0;
            color: #f57c00;
        }

        .status-approved {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .status-rejected {
            background: #fce4ec;
            color: #c2185b;
        }
        
        .delete-btn {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 0.4rem 0.6rem;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: background-color 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .delete-btn:hover {
            background-color: #c0392b;
        }
        
        .delete-btn i {
            font-size: 0.8rem;
        }

        .no-reports {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .no-reports i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: var(--text-light);
        }

        .no-reports h3 {
            margin-bottom: 1rem;
            color: var(--text-dark);
        }

        @media (max-width: 768px) {
            .form-container {
                padding: 1.5rem;
            }
            
            .blood-reports-table {
                font-size: 0.9rem;
            }
            
            .blood-reports-table th,
            .blood-reports-table td {
                padding: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-file-medical"></i>
        <h1>View Blood Reports</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=donor">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/view/my-details">
            <i class="fas fa-user"></i> Profile
        </a>
        <a href="${pageContext.request.contextPath}/view/my-blood-reports" class="active">
            <i class="fas fa-file-medical"></i> View Blood Reports
        </a>
        <a href="${pageContext.request.contextPath}/blood-report/submit">
            <i class="fas fa-plus-circle"></i> Submit Blood Report
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
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
            <h2><i class="fas fa-file-medical"></i> Your Blood Reports</h2>
            <a href="${pageContext.request.contextPath}/blood-report/submit" style="background-color: var(--primary); color: white; padding: 0.8rem 1.5rem; text-decoration: none; border-radius: 4px; font-weight: 500; display: flex; align-items: center; gap: 0.5rem; transition: background-color 0.3s;" onmouseover="this.style.backgroundColor='var(--primary-dark)'" onmouseout="this.style.backgroundColor='var(--primary)'">
                <i class="fas fa-plus-circle"></i> Submit New Report
            </a>
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        
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
        
        <div class="form-container">
            <c:choose>
                <c:when test="${not empty bloodReports}">
                    <table class="blood-reports-table">
                        <thead>
                            <tr>
                                <th>Report ID</th>
                                <th>Date</th>
                                <th>Hemoglobin</th>
                                <th>RBC</th>
                                <th>WBC</th>
                                <th>Platelets</th>
                                <th>Blood Pressure</th>
                                <th>Pulse</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="report" items="${bloodReports}">
                                <tr>
                                    <td>#${report.id}</td>
                                    <td>
                                        <fmt:formatDate value="${report.createdAt}" pattern="MMM dd, yyyy" />
                                    </td>
                                    <td>${report.hemoglobin} g/dL</td>
                                    <td>${report.rbc} M/μL</td>
                                    <td>${report.wbc} K/μL</td>
                                    <td>${report.plt} K/μL</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${report.bloodPressureSystolic != null && report.bloodPressureDiastolic != null}">
                                                ${report.bloodPressureSystolic}/${report.bloodPressureDiastolic} mmHg
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${report.pulseRate != null}">
                                                ${report.pulseRate} bpm
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="status-badge status-${report.status.toLowerCase()}">
                                            ${report.status}
                                        </span>
                                    </td>
                                    <td>
                                        <form method="post" action="${pageContext.request.contextPath}/blood-report/delete" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this blood report? This action cannot be undone.');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="reportId" value="${report.id}">
                                            <button type="submit" class="delete-btn" title="Delete Report">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-reports">
                        <i class="fas fa-file-medical-alt"></i>
                        <h3>No Blood Reports Found</h3>
                        <p>Your blood reports will appear here once you submit them</p>
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
