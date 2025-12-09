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
    <title>Submit Blood Report</title>
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
        }

        .form-group {
            margin-bottom: 1.2rem;
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 1rem;
            align-items: center;
        }

        label {
            font-weight: 500;
            color: var(--text-dark);
        }

        input[type="number"] {
            padding: 0.8rem;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s;
            width: 100%;
        }

        input[type="number"]:focus {
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
            margin-top: 1rem;
        }

        button:hover {
            background-color: var(--primary-dark);
        }

        @media (max-width: 768px) {
            .form-group {
                grid-template-columns: 1fr;
                gap: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-file-medical"></i>
        <h1>Submit Blood Report</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=donor">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/view/my-details">
            <i class="fas fa-user"></i> Profile
        </a>
        <a href="${pageContext.request.contextPath}/view/my-blood-reports" class="active">
            <i class="fas fa-file-medical"></i> Blood Report
        </a>
        <a href="${pageContext.request.contextPath}/jsp/donor/donor_eligibility.jsp">
            <i class="fas fa-clipboard-check"></i> Eligibility
        </a>
        <a href="${pageContext.request.contextPath}/donor-page/summary">
            <i class="fas fa-chart-pie"></i> Summary
        </a>
        <a href="${pageContext.request.contextPath}/donor-page/donation-history">
            <i class="fas fa-history"></i> Donation History
        </a>
        <a href="${pageContext.request.contextPath}/appointment-page">
            <i class="fas fa-calendar-check"></i> Appointments
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
        <h2><i class="fas fa-vial"></i> Blood Report</h2>
        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        <c:if test="${param.success == 'true'}">
            <div class="alert" style="background-color: #e8f5e9; color: #2e7d32; border-left-color: #2e7d32;">
                <i class="fas fa-check-circle"></i> Blood report submitted successfully!
            </div>
        </c:if>
        <div class="form-container">
            <h3><i class="fas fa-chart-line"></i> My Blood Reports</h3>
            <c:choose>
                <c:when test="${not empty bloodReports}">
                    <table style="width: 100%; border-collapse: collapse; margin-top: 1rem;">
                        <thead>
                            <tr style="background-color: var(--primary); color: white;">
                                <th style="padding: 0.75rem; text-align: left;">Date</th>
                                <th style="padding: 0.75rem; text-align: left;">Hemoglobin</th>
                                <th style="padding: 0.75rem; text-align: left;">RBC</th>
                                <th style="padding: 0.75rem; text-align: left;">HCT</th>
                                <th style="padding: 0.75rem; text-align: left;">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="report" items="${bloodReports}">
                                <tr style="border-bottom: 1px solid var(--border);">
                                    <td style="padding: 0.75rem;">
                                        <fmt:formatDate value="${report.createdAt}" pattern="MMM dd, yyyy" />
                                    </td>
                                    <td style="padding: 0.75rem;">${report.hemoglobin}</td>
                                    <td style="padding: 0.75rem;">${report.rbc}</td>
                                    <td style="padding: 0.75rem;">${report.hct}</td>
                                    <td style="padding: 0.75rem;">
                                        <span style="padding: 0.25rem 0.5rem; border-radius: 4px; font-size: 0.8rem; font-weight: 500; 
                                              background-color: ${report.status eq 'APPROVED' ? '#e8f5e9' : report.status eq 'PENDING' ? '#fff3e0' : '#ffebee'}; 
                                              color: ${report.status eq 'APPROVED' ? '#2e7d32' : report.status eq 'PENDING' ? '#f57c00' : '#c62828'};">
                                            ${report.status}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 2rem; color: var(--text-light);">
                        <i class="fas fa-file-medical" style="font-size: 3rem; margin-bottom: 1rem; color: var(--text-light);"></i>
                        <h3>No Blood Reports Found</h3>
                        <p>Your blood test reports will appear here once they are processed.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="form-container" style="margin-top: 2rem;">
            <h3><i class="fas fa-plus-circle"></i> Submit New Blood Report</h3>
            <form action="${pageContext.request.contextPath}/blood-report/submit" method="post" onsubmit="return validateBloodReportForm()">
                <!-- Removed donor_id input -->
                <div class="form-group">
                    <label for="hemoglobin">Hemoglobin:</label>
                    <input type="number" id="hemoglobin" name="hemoglobin" step="0.1" required>
                </div>
                <div class="form-group">
                    <label for="rbc">RBC:</label>
                    <input type="number" id="rbc" name="rbc" step="0.1" required>
                </div>
                <div class="form-group">
                    <label for="hct">HCT:</label>
                    <input type="number" id="hct" name="hct" step="0.1" required>
                </div>
                <div class="form-group">
                    <label for="mcv">MCV:</label>
                    <input type="number" id="mcv" name="mcv" step="0.1" required>
                </div>
                <div class="form-group">
                    <label for="mch">MCH:</label>
                    <input type="number" id="mch" name="mch" step="0.1" required>
                </div>
                <div class="form-group">
                    <label for="mchc">MCHC:</label>
                    <input type="number" id="mchc" name="mchc" step="0.1" required>
                </div>
                <div class="form-group">
                    <label for="rdw">RDW:</label>
                    <input type="number" id="rdw" name="rdw" step="0.1" required>
                </div>
                <div class="form-group">
                    <label for="wbc">WBC:</label>
                    <input type="number" id="wbc" name="wbc" step="0.1" required>
                </div>
                <div class="form-group">
                    <label for="esr">ESR:</label>
                    <input type="number" id="esr" name="esr" step="0.1" required>
                </div>
                <div class="form-group">
                    <label for="plt">PLT:</label>
                    <input type="number" id="plt" name="plt" step="0.1" required>
                </div>
                <div class="form-group">
                    <label for="gra">GRA:</label>
                    <input type="number" id="gra" name="gra" step="0.1" required>
                </div>
                <div class="form-group">
                    <label for="lym">LYM:</label>
                    <input type="number" id="lym" name="lym" step="0.1" required>
                </div>
                <div class="form-group">
                    <label for="eos">EOS:</label>
                    <input type="number" id="eos" name="eos" step="0.1" required>
                </div>
                <div class="form-group">
                    <label for="bas">BAS:</label>
                    <input type="number" id="bas" name="bas" step="0.1" required>
                </div>
                <button type="submit">
                    <i class="fas fa-paper-plane"></i> Submit
                </button>
            </form>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/validation.js"></script>

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