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
    <title>Blood Collection Management - Medical Staff</title>
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

        .stat-icon.collected { background: var(--success); }
        .stat-icon.pending { background: var(--warning); }
        .stat-icon.volume { background: var(--info); }
        .stat-icon.reports { background: var(--primary); }

        .stat-content h3 {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .stat-content p {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .form-container {
            background: var(--white);
            padding: 2rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }

        .form-container h3 {
            color: var(--primary);
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-group input, .form-group select, .form-group textarea {
            padding: 0.8rem;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            outline: none;
            border-color: var(--primary);
        }

        .btn {
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s;
        }

        .btn-primary {
            background: var(--primary);
            color: var(--white);
        }

        .btn-primary:hover {
            background: var(--primary-dark);
        }

        .btn-success {
            background: var(--success);
            color: var(--white);
        }

        .btn-success:hover {
            background: #45a049;
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

        .status-approved {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .status-pending {
            background: #fff3e0;
            color: #f57c00;
        }

        .status-rejected {
            background: #ffebee;
            color: #c62828;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-small {
            padding: 0.4rem 0.8rem;
            font-size: 0.8rem;
        }

        .btn-view {
            background: var(--info);
            color: var(--white);
        }

        .btn-view:hover {
            background: #1976d2;
        }

        .btn-edit {
            background: var(--warning);
            color: var(--white);
        }

        .btn-edit:hover {
            background: #f57c00;
        }

        .btn-success {
            background-color: var(--success);
            color: var(--white);
        }

        .btn-success:hover {
            background-color: #45a049;
        }

        @media (max-width: 768px) {
            .container {
                padding: 0 1rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .form-row {
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
        <i class="fas fa-tint"></i>
        <h1>Blood Collection Management</h1>
    </header>
    
    <nav>
        <a href="${pageContext.request.contextPath}/medical/dashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/medical/blood-reports">
            <i class="fas fa-file-medical"></i> Blood Reports
        </a>
        <a href="${pageContext.request.contextPath}/medical/appointments">
            <i class="fas fa-calendar-check"></i> Appointments
        </a>
        <a href="${pageContext.request.contextPath}/medical/donors">
            <i class="fas fa-users"></i> Donors
        </a>
        <a href="${pageContext.request.contextPath}/medical/blood-collection" class="active">
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
                <div class="stat-icon collected">
                    <i class="fas fa-check-double"></i>
                </div>
                <div class="stat-content">
                    <h3>${completedAppointments.size()}</h3>
                    <p>Completed Collections</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon pending">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-content">
                    <h3>${bloodReports.stream().filter(r -> r.status == 'PENDING').count()}</h3>
                    <p>Pending Reports</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon volume">
                    <i class="fas fa-flask"></i>
                </div>
                <div class="stat-content">
                    <h3>
                        <c:set var="totalVolume" value="0" />
                        <c:forEach var="report" items="${bloodReports}">
                            <c:if test="${report.donationVolume != null}">
                                <c:set var="totalVolume" value="${totalVolume + report.donationVolume}" />
                            </c:if>
                        </c:forEach>
                        ${totalVolume}ml
                    </h3>
                    <p>Total Volume Collected</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon reports">
                    <i class="fas fa-file-medical"></i>
                </div>
                <div class="stat-content">
                    <h3>${bloodReports.size()}</h3>
                    <p>Blood Reports</p>
                </div>
            </div>
        </div>

        <!-- Record Blood Collection Form -->
        <div class="form-container">
            <h3><i class="fas fa-plus-circle"></i> Record Blood Collection</h3>
            <form method="post" action="${pageContext.request.contextPath}/medical/record-collection">
                <div class="form-row">
                    <div class="form-group">
                        <label for="appointment_id">
                            <i class="fas fa-calendar-check"></i> Appointment:
                        </label>
                        <select id="appointment_id" name="appointment_id" required>
                            <option value="">Select Appointment</option>
                            <c:forEach var="appointment" items="${completedAppointments}">
                                <option value="${appointment.id}">
                                    #${appointment.id} - 
                                    <fmt:formatDate value="${appointment.appointmentDate}" pattern="MMM dd, yyyy" /> 
                                    ${appointment.timeSlot}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="donation_volume">
                            <i class="fas fa-flask"></i> Donation Volume (ml):
                        </label>
                        <input type="number" id="donation_volume" name="donation_volume" min="200" max="500" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="blood_pressure_systolic">
                            <i class="fas fa-heartbeat"></i> Blood Pressure - Systolic (mmHg):
                        </label>
                        <input type="number" id="blood_pressure_systolic" name="blood_pressure_systolic" min="60" max="250">
                    </div>
                    <div class="form-group">
                        <label for="blood_pressure_diastolic">
                            <i class="fas fa-heartbeat"></i> Blood Pressure - Diastolic (mmHg):
                        </label>
                        <input type="number" id="blood_pressure_diastolic" name="blood_pressure_diastolic" min="40" max="150">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="pulse_rate">
                            <i class="fas fa-heart"></i> Pulse Rate (bpm):
                        </label>
                        <input type="number" id="pulse_rate" name="pulse_rate" min="40" max="200">
                    </div>
                    <div class="form-group">
                        <label for="temperature">
                            <i class="fas fa-thermometer-half"></i> Temperature (°C):
                        </label>
                        <input type="number" id="temperature" name="temperature" step="0.1" min="35" max="42">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="weight_at_donation">
                            <i class="fas fa-weight"></i> Weight at Donation (kg):
                        </label>
                        <input type="number" id="weight_at_donation" name="weight_at_donation" step="0.1" min="40" max="200">
                    </div>
                    <div class="form-group">
                        <label for="hemoglobin">
                            <i class="fas fa-tint"></i> Hemoglobin (g/dL):
                        </label>
                        <input type="number" id="hemoglobin" name="hemoglobin" step="0.1" min="8" max="20">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="medical_notes">
                        <i class="fas fa-stethoscope"></i> Medical Notes:
                    </label>
                    <textarea id="medical_notes" name="medical_notes" rows="3" placeholder="Any additional medical observations or notes..."></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Record Collection
                </button>
            </form>
        </div>

        <!-- Approved Blood Reports for Collection -->
        <div class="table-container">
            <h3><i class="fas fa-check-circle"></i> Approved Blood Reports Ready for Collection</h3>
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> Report ID</th>
                        <th><i class="fas fa-user"></i> Donor</th>
                        <th><i class="fas fa-tint"></i> Blood Group</th>
                        <th><i class="fas fa-calendar"></i> Report Date</th>
                        <th><i class="fas fa-heartbeat"></i> Blood Pressure</th>
                        <th><i class="fas fa-heart"></i> Pulse</th>
                        <th><i class="fas fa-thermometer-half"></i> Temp</th>
                        <th><i class="fas fa-tint"></i> Hemoglobin</th>
                        <th><i class="fas fa-info-circle"></i> Status</th>
                        <th><i class="fas fa-ellipsis-h"></i> Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="report" items="${bloodReports}">
                        <c:if test="${report.status == 'APPROVED'}">
                            <tr>
                                <td>#${report.id}</td>
                                <td>
                                    <c:forEach var="donor" items="${donors}">
                                        <c:if test="${donor.id == report.donorId}">
                                            ${donor.name}
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td>
                                    <c:forEach var="donor" items="${donors}">
                                        <c:if test="${donor.id == report.donorId}">
                                            <span style="font-weight: bold; color: #e74c3c;">${donor.bloodGroup}</span>
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td>
                                    <fmt:formatDate value="${report.createdAt}" pattern="MMM dd, yyyy" />
                                </td>
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
                                    <c:choose>
                                        <c:when test="${report.temperature != null}">
                                            ${report.temperature}°C
                                        </c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${report.hemoglobin != null}">
                                            ${report.hemoglobin} g/dL
                                        </c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="status-badge status-approved">
                                        ${report.status}
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-small btn-view" onclick="viewCollectionDetails(${report.id})">
                                            <i class="fas fa-eye"></i> View
                                        </button>
                                        <button class="btn btn-small btn-edit" onclick="editCollectionDetails(${report.id})">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <button class="btn btn-small btn-success" onclick="recordCollection(${report.id})">
                                            <i class="fas fa-plus"></i> Record Collection
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Collection Records -->
        <div class="table-container">
            <h3><i class="fas fa-list"></i> Blood Collection Records</h3>
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> Report ID</th>
                        <th><i class="fas fa-user"></i> Donor</th>
                        <th><i class="fas fa-tint"></i> Blood Group</th>
                        <th><i class="fas fa-calendar"></i> Collection Date</th>
                        <th><i class="fas fa-flask"></i> Volume (ml)</th>
                        <th><i class="fas fa-heartbeat"></i> Blood Pressure</th>
                        <th><i class="fas fa-heart"></i> Pulse</th>
                        <th><i class="fas fa-thermometer-half"></i> Temp</th>
                        <th><i class="fas fa-tint"></i> Hemoglobin</th>
                        <th><i class="fas fa-ellipsis-h"></i> Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="report" items="${bloodReports}">
                        <c:if test="${report.donationVolume != null && report.donationVolume > 0}">
                            <tr>
                                <td>#${report.id}</td>
                                <td>
                                    <c:forEach var="donor" items="${donors}">
                                        <c:if test="${donor.id == report.donorId}">
                                            ${donor.name}
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td>
                                    <c:forEach var="donor" items="${donors}">
                                        <c:if test="${donor.id == report.donorId}">
                                            <span style="font-weight: bold; color: #e74c3c;">${donor.bloodGroup}</span>
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td>
                                    <fmt:formatDate value="${report.createdAt}" pattern="MMM dd, yyyy" />
                                </td>
                                <td>
                                    <span style="font-weight: bold; color: #27ae60;">${report.donationVolume}ml</span>
                                </td>
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
                                    <c:choose>
                                        <c:when test="${report.temperature != null}">
                                            ${report.temperature}°C
                                        </c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${report.hemoglobin != null}">
                                            ${report.hemoglobin} g/dL
                                        </c:when>
                                        <c:otherwise>N/A</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-small btn-view" onclick="viewCollectionDetails(${report.id})">
                                            <i class="fas fa-eye"></i> View
                                        </button>
                                        <button class="btn btn-small btn-edit" onclick="editCollectionDetails(${report.id})">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function viewCollectionDetails(reportId) {
            // Create a modal to display collection details
            const modal = document.createElement('div');
            modal.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 1000;
            `;
            
            modal.innerHTML = `
                <div style="background: white; padding: 2rem; border-radius: 8px; max-width: 700px; width: 90%; max-height: 80vh; overflow-y: auto;">
                    <h3>Blood Collection Details - Report ID: ${reportId}</h3>
                    <div id="collectionDetails">
                        <p>Loading collection details...</p>
                    </div>
                    <button onclick="this.closest('.modal').remove()" style="margin-top: 1rem; padding: 0.5rem 1rem; background: #f44336; color: white; border: none; border-radius: 4px; cursor: pointer;">Close</button>
                </div>
            `;
            
            modal.className = 'modal';
            document.body.appendChild(modal);
            
            // Simulate loading data
            setTimeout(() => {
                document.getElementById('collectionDetails').innerHTML = `
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                        <div><strong>Report ID:</strong> ${reportId}</div>
                        <div><strong>Status:</strong> <span style="color: #4caf50;">APPROVED</span></div>
                        <div><strong>Donation Volume:</strong> 450ml</div>
                        <div><strong>Blood Pressure:</strong> 120/80 mmHg</div>
                        <div><strong>Pulse Rate:</strong> 72 bpm</div>
                        <div><strong>Temperature:</strong> 36.5°C</div>
                        <div><strong>Hemoglobin:</strong> 14.2 g/dL</div>
                        <div><strong>Weight:</strong> 70.5 kg</div>
                    </div>
                    <div style="margin-top: 1rem;">
                        <strong>Medical Notes:</strong><br>
                        <p style="background: #f5f5f5; padding: 1rem; border-radius: 4px; margin-top: 0.5rem;">
                            Donor in good health. No adverse reactions during collection. 
                            Blood pressure and vital signs within normal range.
                        </p>
                    </div>
                `;
            }, 500);
        }

        function editCollectionDetails(reportId) {
            // Create a modal for editing collection details
            const modal = document.createElement('div');
            modal.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 1000;
            `;
            
            modal.innerHTML = `
                <div style="background: white; padding: 2rem; border-radius: 8px; max-width: 600px; width: 90%; max-height: 80vh; overflow-y: auto;">
                    <h3>Edit Blood Collection - Report ID: ${reportId}</h3>
                    <form id="editCollectionForm">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                            <div>
                                <label>Donation Volume (ml):</label>
                                <input type="number" name="donation_volume" value="450" min="200" max="500" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                            </div>
                            <div>
                                <label>Blood Pressure - Systolic:</label>
                                <input type="number" name="blood_pressure_systolic" value="120" min="60" max="250" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                            </div>
                            <div>
                                <label>Blood Pressure - Diastolic:</label>
                                <input type="number" name="blood_pressure_diastolic" value="80" min="40" max="150" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                            </div>
                            <div>
                                <label>Pulse Rate (bpm):</label>
                                <input type="number" name="pulse_rate" value="72" min="40" max="200" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                            </div>
                            <div>
                                <label>Temperature (°C):</label>
                                <input type="number" name="temperature" value="36.5" step="0.1" min="35" max="42" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                            </div>
                            <div>
                                <label>Weight (kg):</label>
                                <input type="number" name="weight_at_donation" value="70.5" step="0.1" min="40" max="200" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                            </div>
                        </div>
                        <div style="margin-bottom: 1rem;">
                            <label>Hemoglobin (g/dL):</label>
                            <input type="number" name="hemoglobin" value="14.2" step="0.1" min="8" max="20" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                        </div>
                        <div style="margin-bottom: 1rem;">
                            <label>Medical Notes:</label>
                            <textarea name="medical_notes" rows="3" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;" placeholder="Enter medical notes...">Donor in good health. No adverse reactions during collection. Blood pressure and vital signs within normal range.</textarea>
                        </div>
                        <div style="display: flex; gap: 1rem;">
                            <button type="button" onclick="saveCollectionChanges(${reportId})" style="padding: 0.5rem 1rem; background: #4caf50; color: white; border: none; border-radius: 4px; cursor: pointer;">Save Changes</button>
                            <button type="button" onclick="this.closest('.modal').remove()" style="padding: 0.5rem 1rem; background: #f44336; color: white; border: none; border-radius: 4px; cursor: pointer;">Cancel</button>
                        </div>
                    </form>
                </div>
            `;
            
            modal.className = 'modal';
            document.body.appendChild(modal);
        }

        function saveCollectionChanges(reportId) {
            const form = document.getElementById('editCollectionForm');
            const formData = new FormData(form);
            formData.append('report_id', reportId);
            
            // Send data to server
            fetch('${pageContext.request.contextPath}/medical/update-report', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    alert('Collection changes saved successfully!');
                    // Close the modal
                    document.querySelector('.modal').remove();
                    // Reload the page to show updated data
                    location.reload();
                } else {
                    alert('Error saving changes. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error saving changes. Please try again.');
            });
        }

        function recordCollection(reportId) {
            // Create a modal for recording collection
            const modal = document.createElement('div');
            modal.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 1000;
            `;
            
            modal.innerHTML = `
                <div style="background: white; padding: 2rem; border-radius: 8px; max-width: 600px; width: 90%; max-height: 80vh; overflow-y: auto;">
                    <h3>Record Blood Collection - Report ID: ${reportId}</h3>
                    <form id="recordCollectionForm">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                            <div>
                                <label>Donation Volume (ml):</label>
                                <input type="number" name="donation_volume" value="450" min="200" max="500" required style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                            </div>
                            <div>
                                <label>Blood Pressure - Systolic:</label>
                                <input type="number" name="blood_pressure_systolic" value="120" min="60" max="250" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                            </div>
                            <div>
                                <label>Blood Pressure - Diastolic:</label>
                                <input type="number" name="blood_pressure_diastolic" value="80" min="40" max="150" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                            </div>
                            <div>
                                <label>Pulse Rate (bpm):</label>
                                <input type="number" name="pulse_rate" value="72" min="40" max="200" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                            </div>
                            <div>
                                <label>Temperature (°C):</label>
                                <input type="number" name="temperature" value="36.5" step="0.1" min="35" max="42" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                            </div>
                            <div>
                                <label>Weight (kg):</label>
                                <input type="number" name="weight_at_donation" value="70.5" step="0.1" min="40" max="200" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                            </div>
                        </div>
                        <div style="margin-bottom: 1rem;">
                            <label>Hemoglobin (g/dL):</label>
                            <input type="number" name="hemoglobin" value="14.2" step="0.1" min="8" max="20" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;">
                        </div>
                        <div style="margin-bottom: 1rem;">
                            <label>Medical Notes:</label>
                            <textarea name="medical_notes" rows="3" style="width: 100%; padding: 0.5rem; margin-top: 0.25rem;" placeholder="Enter medical notes...">Blood collection completed successfully. Donor in good health.</textarea>
                        </div>
                        <div style="display: flex; gap: 1rem;">
                            <button type="button" onclick="submitCollection(${reportId})" style="padding: 0.5rem 1rem; background: #4caf50; color: white; border: none; border-radius: 4px; cursor: pointer;">Record Collection</button>
                            <button type="button" onclick="this.closest('.modal').remove()" style="padding: 0.5rem 1rem; background: #f44336; color: white; border: none; border-radius: 4px; cursor: pointer;">Cancel</button>
                        </div>
                    </form>
                </div>
            `;
            
            modal.className = 'modal';
            document.body.appendChild(modal);
        }

        function submitCollection(reportId) {
            const form = document.getElementById('recordCollectionForm');
            const formData = new FormData(form);
            formData.append('report_id', reportId);
            
            // Send data to server
            fetch('${pageContext.request.contextPath}/medical/record-collection', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    alert('Blood collection recorded successfully! Blood has been added to stock.');
                    // Close the modal
                    document.querySelector('.modal').remove();
                    // Reload the page to show updated data
                    location.reload();
                } else {
                    alert('Error recording collection. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error recording collection. Please try again.');
            });
        }

        // Prevent back button access after logout
        window.history.pushState(null, null, window.location.href);
        window.onpopstate = function(event) {
            window.history.pushState(null, null, window.location.href);
        };
    </script>
</body>
</html>

