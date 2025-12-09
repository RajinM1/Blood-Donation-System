<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Blood Reports</title>
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
            --approved: #e8f5e9;
            --rejected: #ffebee;
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
            max-width: 95%;
            margin: 2rem auto;
        }

        h2 {
            color: var(--text-dark);
            margin: 2rem 0 1.5rem;
            font-weight: 600;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
            background-color: var(--white);
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            padding: 0.75rem 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }

        th {
            background-color: var(--primary);
            color: var(--white);
            font-weight: 500;
            position: sticky;
            top: 0;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .status-approved {
            background-color: var(--approved);
            color: var(--success);
            font-weight: 500;
        }

        .status-rejected {
            background-color: var(--rejected);
            color: var(--error);
            font-weight: 500;
        }

        button {
            background-color: var(--primary);
            color: var(--white);
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin: 0.25rem;
        }

        button:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }

        button.approve {
            background-color: var(--success);
        }

        button.reject {
            background-color: var(--error);
        }

        button.approve:hover {
            background-color: #3d8b40;
        }

        button.reject:hover {
            background-color: #d32f2f;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            align-items: center;
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
            background: #ffebee;
            color: #c62828;
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert.success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid var(--success);
        }

        .alert.error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid var(--error);
        }

        .table-container {
            overflow-x: auto;
            margin-bottom: 2rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
        }

        @media (max-width: 1200px) {
            th, td {
                padding: 0.5rem;
                font-size: 0.9rem;
            }

            button {
                padding: 0.4rem 0.8rem;
                font-size: 0.8rem;
            }
        }

        @media (max-width: 768px) {
            nav {
                flex-direction: column;
                gap: 0.5rem;
                padding: 1rem;
            }

            .container {
                padding: 1rem;
                margin: 1rem;
            }

            h2 {
                margin: 1.5rem 0 1rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-file-medical"></i>
        <h1>Blood Reports</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/medical/dashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/medical/blood-reports" class="active">
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
        <c:if test="${not empty param.success}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> ${param.success}
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert error">
                <i class="fas fa-exclamation-circle"></i> ${param.error}
            </div>
        </c:if>

        <h2><i class="fas fa-microscope"></i> Review Blood Reports</h2>
        
        <!-- Statistics -->
        <div class="stats-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-bottom: 2rem;">
            <div class="stat-card" style="background: white; padding: 1rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                <div style="font-size: 2rem; color: #f39c12; margin-bottom: 0.5rem;">
                    <i class="fas fa-clock"></i>
                </div>
                <div>
                    <h3 style="margin: 0; color: #2c3e50;">
                        <c:set var="pendingCount" value="0" />
                        <c:forEach var="report" items="${bloodReports}">
                            <c:if test="${report.status == 'PENDING'}">
                                <c:set var="pendingCount" value="${pendingCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${pendingCount}
                    </h3>
                    <p style="margin: 0; color: #7f8c8d;">Pending Reports</p>
                </div>
            </div>
            <div class="stat-card" style="background: white; padding: 1rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                <div style="font-size: 2rem; color: #27ae60; margin-bottom: 0.5rem;">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div>
                    <h3 style="margin: 0; color: #2c3e50;">
                        <c:set var="approvedCount" value="0" />
                        <c:forEach var="report" items="${bloodReports}">
                            <c:if test="${report.status == 'APPROVED'}">
                                <c:set var="approvedCount" value="${approvedCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${approvedCount}
                    </h3>
                    <p style="margin: 0; color: #7f8c8d;">Approved Reports</p>
                </div>
            </div>
            <div class="stat-card" style="background: white; padding: 1rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                <div style="font-size: 2rem; color: #e74c3c; margin-bottom: 0.5rem;">
                    <i class="fas fa-times-circle"></i>
                </div>
                <div>
                    <h3 style="margin: 0; color: #2c3e50;">
                        <c:set var="rejectedCount" value="0" />
                        <c:forEach var="report" items="${bloodReports}">
                            <c:if test="${report.status == 'REJECTED'}">
                                <c:set var="rejectedCount" value="${rejectedCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${rejectedCount}
                    </h3>
                    <p style="margin: 0; color: #7f8c8d;">Rejected Reports</p>
                </div>
            </div>
            <div class="stat-card" style="background: white; padding: 1rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                <div style="font-size: 2rem; color: #3498db; margin-bottom: 0.5rem;">
                    <i class="fas fa-file-medical"></i>
                </div>
                <div>
                    <h3 style="margin: 0; color: #2c3e50;">${bloodReports.size()}</h3>
                    <p style="margin: 0; color: #7f8c8d;">Total Reports</p>
                </div>
            </div>
        </div>


        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-id-card"></i> Report ID</th>
                        <th><i class="fas fa-user"></i> Donor Name</th>
                        <th><i class="fas fa-tint"></i> Blood Group</th>
                        <th>Hemoglobin</th>
                        <th>RBC</th>
                        <th>HCT</th>
                        <th>MCV</th>
                        <th>MCH</th>
                        <th>MCHC</th>
                        <th>RDW</th>
                        <th>WBC</th>
                        <th>ESR</th>
                        <th>PLT</th>
                        <th>GRA</th>
                        <th>LYM</th>
                        <th>EOS</th>
                        <th>BAS</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty bloodReports}">
                            <tr>
                                <td colspan="20" style="text-align: center; padding: 2rem; color: #7f8c8d;">
                                    <i class="fas fa-info-circle" style="font-size: 2rem; margin-bottom: 1rem; display: block;"></i>
                                    No blood reports found. Donors need to submit their blood test results first.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="report" items="${bloodReports}">
                        <tr class="${report.status == 'APPROVED' ? 'status-approved' : report.status == 'REJECTED' ? 'status-rejected' : ''}">
                            <td>#${report.id}</td>
                            <td>
                                <c:forEach var="donor" items="${donors}">
                                    <c:if test="${donor.id == report.donorId}">${donor.name}</c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <c:forEach var="donor" items="${donors}">
                                    <c:if test="${donor.id == report.donorId}">
                                        <span style="font-weight: bold; color: #e74c3c;">${donor.bloodGroup}</span>
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>${report.hemoglobin}</td>
                            <td>${report.rbc}</td>
                            <td>${report.hct}</td>
                            <td>${report.mcv}</td>
                            <td>${report.mch}</td>
                            <td>${report.mchc}</td>
                            <td>${report.rdw}</td>
                            <td>${report.wbc}</td>
                            <td>${report.esr}</td>
                            <td>${report.plt}</td>
                            <td>${report.gra}</td>
                            <td>${report.lym}</td>
                            <td>${report.eos}</td>
                            <td>${report.bas}</td>
                            <td>
                                <span class="status-badge status-${report.status.toLowerCase()}">
                                    ${report.status}
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <c:if test="${report.status == 'PENDING'}">
                                        <form action="${pageContext.request.contextPath}/medical/approve-report" method="post" style="display:inline;">
                                            <input type="hidden" name="report_id" value="${report.id}">
                                            <button type="submit" class="approve"><i class="fas fa-check"></i> Approve</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/medical/reject-report" method="post" style="display:inline;">
                                            <input type="hidden" name="report_id" value="${report.id}">
                                            <input type="text" name="reason" placeholder="Rejection reason (optional)" style="padding: 0.3rem; margin-right: 0.5rem; border: 1px solid #ddd; border-radius: 4px; font-size: 0.8rem;" maxlength="255">
                                            <button type="submit" class="reject" onclick="return confirm('Are you sure you want to reject this report?')"><i class="fas fa-times"></i> Reject</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${report.status == 'APPROVED'}">
                                        <span class="status-approved"><i class="fas fa-check-circle"></i> Approved</span>
                                    </c:if>
                                    <c:if test="${report.status == 'REJECTED'}">
                                        <span class="status-rejected"><i class="fas fa-times-circle"></i> Rejected</span>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
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