<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Appointment Management - Medical Staff</title>
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
            --warning: #ff9800;
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
            gap: 1rem;
        }

        header i {
            font-size: 2rem;
        }

        header h1 {
            font-size: 1.8rem;
            font-weight: 600;
        }

        nav {
            background: var(--white);
            padding: 1rem 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex;
            gap: 2rem;
            align-items: center;
        }

        nav a {
            color: var(--text-dark);
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        nav a:hover, nav a.active {
            background: var(--primary);
            color: var(--white);
        }

        .container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--white);
        }

        .stat-icon.pending { background: var(--warning); }
        .stat-icon.approved { background: var(--success); }
        .stat-icon.completed { background: var(--info); }
        .stat-icon.rejected { background: var(--error); }

        .stat-content h3 {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .stat-content p {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .table-container {
            background: var(--white);
            border-radius: 8px;
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }

        th {
            background: var(--background);
            font-weight: 600;
            color: var(--text-dark);
        }

        tr:hover {
            background: #f8f9fa;
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

        .status-completed {
            background: #e3f2fd;
            color: #1976d2;
        }

        .status-rejected {
            background: #ffebee;
            color: #c62828;
        }

        .status-cancelled {
            background: #f3e5f5;
            color: #7b1fa2;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
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
            transition: all 0.3s;
        }

        .btn-approve {
            background: var(--success);
            color: var(--white);
        }

        .btn-approve:hover {
            background: #45a049;
        }

        .btn-reject {
            background: var(--error);
            color: var(--white);
        }

        .btn-reject:hover {
            background: #d32f2f;
        }

        .btn-complete {
            background: var(--info);
            color: var(--white);
        }

        .btn-complete:hover {
            background: #1976d2;
        }

        .btn-view {
            background: var(--primary);
            color: var(--white);
        }

        .btn-view:hover {
            background: var(--primary-dark);
        }

        .filter-section {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }

        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text-dark);
        }

        .form-group input, .form-group select {
            padding: 0.8rem;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 1rem;
        }

        .btn-filter {
            background: var(--primary);
            color: var(--white);
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-filter:hover {
            background: var(--primary-dark);
        }

        @media (max-width: 768px) {
            .container {
                padding: 0 1rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .filter-row {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            table {
                font-size: 0.9rem;
            }

            th, td {
                padding: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-calendar-check"></i>
        <h1>Appointment Management</h1>
    </header>
    
    <nav>
        <a href="${pageContext.request.contextPath}/medical/dashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/medical/blood-reports">
            <i class="fas fa-file-medical"></i> Blood Reports
        </a>
        <a href="${pageContext.request.contextPath}/medical/appointments" class="active">
            <i class="fas fa-calendar-check"></i> Appointments
        </a>
        <a href="${pageContext.request.contextPath}/medical/donors">
            <i class="fas fa-users"></i> Donors
        </a>
        <a href="${pageContext.request.contextPath}/medical/blood-collection">
            <i class="fas fa-tint"></i> Blood Collection
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

        <!-- Statistics -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon pending">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-content">
                    <h3>${appointments.stream().filter(a -> a.status == 'PENDING').count()}</h3>
                    <p>Pending Appointments</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon approved">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-content">
                    <h3>${appointments.stream().filter(a -> a.status == 'APPROVED').count()}</h3>
                    <p>Approved Appointments</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon completed">
                    <i class="fas fa-check-double"></i>
                </div>
                <div class="stat-content">
                    <h3>${appointments.stream().filter(a -> a.status == 'COMPLETED').count()}</h3>
                    <p>Completed Appointments</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon rejected">
                    <i class="fas fa-times-circle"></i>
                </div>
                <div class="stat-content">
                    <h3>${appointments.stream().filter(a -> a.status == 'REJECTED').count()}</h3>
                    <p>Rejected Appointments</p>
                </div>
            </div>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <h3><i class="fas fa-filter"></i> Filter Appointments</h3>
            <form method="get" action="${pageContext.request.contextPath}/medical/appointments">
                <div class="filter-row">
                    <div class="form-group">
                        <label for="status">Status:</label>
                        <select id="status" name="status">
                            <option value="">All Statuses</option>
                            <option value="PENDING">Pending</option>
                            <option value="APPROVED">Approved</option>
                            <option value="COMPLETED">Completed</option>
                            <option value="REJECTED">Rejected</option>
                            <option value="CANCELLED">Cancelled</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="date">Date:</label>
                        <input type="date" id="date" name="date">
                    </div>
                    <div class="form-group">
                        <label for="donor">Donor:</label>
                        <select id="donor" name="donor">
                            <option value="">All Donors</option>
                            <c:forEach var="donor" items="${donors}">
                                <option value="${donor.id}">${donor.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn-filter">
                            <i class="fas fa-search"></i> Filter
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Appointments Table -->
        <div class="table-container">
            <h3><i class="fas fa-list"></i> All Appointments</h3>
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> ID</th>
                        <th><i class="fas fa-user"></i> Donor</th>
                        <th><i class="fas fa-tint"></i> Blood Group</th>
                        <th><i class="fas fa-file-medical"></i> Blood Report</th>
                        <th><i class="fas fa-calendar"></i> Date</th>
                        <th><i class="fas fa-clock"></i> Time</th>
                        <th><i class="fas fa-map-marker-alt"></i> Camp</th>
                        <th><i class="fas fa-info-circle"></i> Status</th>
                        <th><i class="fas fa-tag"></i> Type</th>
                        <th><i class="fas fa-ellipsis-h"></i> Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="appointment" items="${appointments}">
                        <tr>
                            <td>#${appointment.id}</td>
                            <td>
                                <c:forEach var="donor" items="${donors}">
                                    <c:if test="${donor.id == appointment.donorId}">
                                        ${donor.name}
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <c:forEach var="donor" items="${donors}">
                                    <c:if test="${donor.id == appointment.donorId}">
                                        <span style="font-weight: bold; color: #e74c3c;">${donor.bloodGroup}</span>
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <c:set var="hasApprovedReport" value="false" />
                                <c:forEach var="report" items="${bloodReports}">
                                    <c:if test="${report.donorId == appointment.donorId && report.status == 'APPROVED'}">
                                        <c:set var="hasApprovedReport" value="true" />
                                        <span class="status-badge status-approved">
                                            <i class="fas fa-check"></i> Approved
                                        </span>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!hasApprovedReport}">
                                    <span class="status-badge status-pending">
                                        <i class="fas fa-clock"></i> Pending
                                    </span>
                                </c:if>
                            </td>
                            <td>
                                <fmt:formatDate value="${appointment.appointmentDate}" pattern="MMM dd, yyyy" />
                            </td>
                            <td>${appointment.timeSlot}</td>
                            <td>
                                <c:forEach var="camp" items="${camps}">
                                    <c:if test="${camp.id == appointment.campId}">
                                        ${camp.campName}
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <span class="status-badge status-${appointment.status.toLowerCase()}">
                                    ${appointment.status}
                                </span>
                            </td>
                            <td>${appointment.appointmentType}</td>
                            <td>
                                <div class="action-buttons">
                                    <c:if test="${appointment.status == 'PENDING'}">
                                        <c:set var="canApprove" value="false" />
                                        <c:forEach var="report" items="${bloodReports}">
                                            <c:if test="${report.donorId == appointment.donorId && report.status == 'APPROVED'}">
                                                <c:set var="canApprove" value="true" />
                                            </c:if>
                                        </c:forEach>
                                        <c:choose>
                                            <c:when test="${canApprove}">
                                                <form method="post" action="${pageContext.request.contextPath}/medical/approve-appointment" style="display: inline;">
                                                    <input type="hidden" name="appointment_id" value="${appointment.id}">
                                                    <button type="submit" class="btn btn-approve">
                                                        <i class="fas fa-check"></i> Approve
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn" style="background: #ccc; color: #666; cursor: not-allowed;" disabled title="Cannot approve - No approved blood report">
                                                    <i class="fas fa-lock"></i> Approve
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                        <form method="post" action="${pageContext.request.contextPath}/medical/reject-appointment" style="display: inline;">
                                            <input type="hidden" name="appointment_id" value="${appointment.id}">
                                            <button type="submit" class="btn btn-reject" onclick="return confirm('Are you sure you want to reject this appointment?')">
                                                <i class="fas fa-times"></i> Reject
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${appointment.status == 'APPROVED'}">
                                        <form method="post" action="${pageContext.request.contextPath}/medical/complete-appointment" style="display: inline;">
                                            <input type="hidden" name="appointment_id" value="${appointment.id}">
                                            <button type="submit" class="btn btn-complete">
                                                <i class="fas fa-check-double"></i> Complete
                                            </button>
                                        </form>
                                    </c:if>
                                    <button class="btn btn-view" onclick="viewAppointmentDetails(${appointment.id})">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function viewAppointmentDetails(appointmentId) {
            // This could open a modal or redirect to a details page
            alert('Appointment details for ID: ' + appointmentId);
        }

        // Prevent back button access after logout
        window.history.pushState(null, null, window.location.href);
        window.onpopstate = function(event) {
            window.history.pushState(null, null, window.location.href);
        };
    </script>
</body>
</html>

