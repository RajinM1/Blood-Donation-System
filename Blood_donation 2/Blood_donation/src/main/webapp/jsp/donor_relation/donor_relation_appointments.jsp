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
    <title>Appointment Management - Donor Relations</title>
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
            justify-content: space-between;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        nav {
            background-color: var(--white);
            padding: 1rem 2rem;
            display: flex;
            justify-content: center;
            gap: 2rem;
            box-shadow: var(--shadow);
        }

        nav a {
            color: var(--text-dark);
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        nav a:hover, nav a.active {
            background-color: var(--primary);
            color: var(--white);
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 600;
            color: var(--text-dark);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            text-align: center;
            transition: transform 0.3s ease;
            border-left: 4px solid var(--primary);
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card.pending {
            border-left-color: var(--warning);
        }

        .stat-card.approved {
            border-left-color: var(--success);
        }

        .stat-card.rejected {
            border-left-color: var(--error);
        }

        .stat-card.completed {
            border-left-color: var(--info);
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .stat-card.pending .stat-icon {
            color: var(--warning);
        }

        .stat-card.approved .stat-icon {
            color: var(--success);
        }

        .stat-card.rejected .stat-icon {
            color: var(--error);
        }

        .stat-card.completed .stat-icon {
            color: var(--info);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--text-light);
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .filters {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }

        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            align-items: end;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
        }

        .filter-group label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--text-dark);
        }

        .filter-group input,
        .filter-group select {
            padding: 0.75rem;
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 1rem;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
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
            background-color: #45a049;
        }

        .btn-danger {
            background-color: var(--error);
            color: var(--white);
        }

        .btn-danger:hover {
            background-color: #da190b;
        }

        .btn-warning {
            background-color: var(--warning);
            color: var(--white);
        }

        .btn-warning:hover {
            background-color: #e68900;
        }

        .btn-secondary {
            background-color: var(--text-light);
            color: var(--white);
        }

        .btn-secondary:hover {
            background-color: #6c757d;
        }

        .appointments-table {
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .table-header {
            background: var(--primary);
            color: var(--white);
            padding: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-title {
            font-size: 1.25rem;
            font-weight: 600;
        }

        .bulk-actions {
            display: flex;
            gap: 0.5rem;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th,
        .table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }

        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: var(--text-dark);
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
            text-transform: uppercase;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-approved {
            background-color: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
        }

        .status-completed {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
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
            border-radius: 12px;
            width: 90%;
            max-width: 500px;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .modal-title {
            font-size: 1.25rem;
            font-weight: 600;
        }

        .close {
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--text-light);
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border);
            border-radius: 6px;
            resize: vertical;
            min-height: 100px;
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 6px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-info {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .no-data {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .no-data i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--border);
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .filter-row {
                grid-template-columns: 1fr;
            }

            .table {
                font-size: 0.875rem;
            }

            .table th,
            .table td {
                padding: 0.5rem;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="header-left">
            <i class="fas fa-calendar-check"></i>
            <h1>Appointment Management</h1>
        </div>
        <div class="header-right">
            <span>Welcome, ${sessionScope.user.username}</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </header>

    <nav>
        <a href="${pageContext.request.contextPath}/donor-relation/dashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/appointments" class="active">
            <i class="fas fa-calendar-check"></i> Appointments
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/camp-management">
            <i class="fas fa-hospital"></i> Camp Management
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/communication">
            <i class="fas fa-comments"></i> Communication
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/donor-messages">
            <i class="fas fa-envelope"></i> Messages
        </a>
    </nav>

    <div class="container">
        <div class="page-header">
            <h2 class="page-title">Appointment Management</h2>
            <div>
                <button class="btn btn-primary" onclick="refreshPage()">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${success == 'approved'}">Appointment approved successfully!</c:when>
                    <c:when test="${success == 'rejected'}">Appointment rejected successfully!</c:when>
                    <c:when test="${success == 'bulk_approved'}">${param.count} appointments approved successfully!</c:when>
                    <c:when test="${success == 'bulk_rejected'}">${param.count} appointments rejected successfully!</c:when>
                    <c:otherwise>Operation completed successfully!</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <c:choose>
                    <c:when test="${error == 'database_error'}">Database error occurred. Please try again.</c:when>
                    <c:when test="${error == 'no_selection'}">Please select at least one appointment.</c:when>
                    <c:otherwise>${error}</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Statistics -->
        <div class="stats-grid">
            <div class="stat-card pending">
                <i class="fas fa-clock stat-icon"></i>
                <div class="stat-number">${pendingCount}</div>
                <div class="stat-label">Pending</div>
            </div>
            <div class="stat-card approved">
                <i class="fas fa-check-circle stat-icon"></i>
                <div class="stat-number">${approvedCount}</div>
                <div class="stat-label">Approved</div>
            </div>
            <div class="stat-card rejected">
                <i class="fas fa-times-circle stat-icon"></i>
                <div class="stat-number">${rejectedCount}</div>
                <div class="stat-label">Rejected</div>
            </div>
            <div class="stat-card completed">
                <i class="fas fa-check-double stat-icon"></i>
                <div class="stat-number">${completedCount}</div>
                <div class="stat-label">Completed</div>
            </div>
        </div>

        <!-- Filters -->
        <div class="filters">
            <form method="GET" action="${pageContext.request.contextPath}/donor-relation/appointments">
                <div class="filter-row">
                    <div class="filter-group">
                        <label for="status">Status</label>
                        <select name="status" id="status">
                            <option value="">All Appointments</option>
                            <option value="PENDING" ${currentStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                            <option value="APPROVED" ${currentStatus == 'APPROVED' ? 'selected' : ''}>Approved</option>
                            <option value="REJECTED" ${currentStatus == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                            <option value="COMPLETED" ${currentStatus == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="search">Search</label>
                        <input type="text" name="search" id="search" placeholder="Search by time slot or status..." value="${searchTerm}">
                    </div>
                    <div class="filter-group">
                        <label for="date">Date</label>
                        <input type="date" name="date" id="date" value="${dateFilter}">
                    </div>
                    <div class="filter-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Filter
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Appointments Table -->
        <div class="appointments-table">
            <div class="table-header">
                <div class="table-title">
                    <c:choose>
                        <c:when test="${currentStatus == 'PENDING'}">Pending Appointments</c:when>
                        <c:when test="${currentStatus == 'APPROVED'}">Approved Appointments</c:when>
                        <c:when test="${currentStatus == 'REJECTED'}">Rejected Appointments</c:when>
                        <c:when test="${currentStatus == 'COMPLETED'}">Completed Appointments</c:when>
                        <c:otherwise>All Appointments</c:otherwise>
                    </c:choose>
                </div>
                <c:if test="${currentStatus == 'PENDING' && not empty appointments}">
                    <div class="bulk-actions">
                        <button class="btn btn-success btn-sm" onclick="showBulkApproveModal()">
                            <i class="fas fa-check"></i> Bulk Approve
                        </button>
                        <button class="btn btn-danger btn-sm" onclick="showBulkRejectModal()">
                            <i class="fas fa-times"></i> Bulk Reject
                        </button>
                    </div>
                </c:if>
            </div>

            <c:choose>
                <c:when test="${empty appointments}">
                    <div class="no-data">
                        <i class="fas fa-calendar-times"></i>
                        <h3>No appointments found</h3>
                        <p>There are no appointments matching your current filters.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="table">
                        <thead>
                            <tr>
                                <c:if test="${currentStatus == 'PENDING'}">
                                    <th><input type="checkbox" id="selectAll" onchange="toggleSelectAll()"></th>
                                </c:if>
                                <th>Donor</th>
                                <th>Blood Group</th>
                                <th>Camp</th>
                                <th>Date & Time</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="appointmentDetail" items="${appointments}">
                                <tr>
                                    <c:if test="${currentStatus == 'PENDING'}">
                                        <td>
                                            <input type="checkbox" name="appointment_ids" value="${appointmentDetail.appointment.id}" class="appointment-checkbox">
                                        </td>
                                    </c:if>
                                    <td>
                                        <div>
                                            <strong>${appointmentDetail.donorName}</strong>
                                            <br>
                                            <small>${appointmentDetail.donorEmail}</small>
                                            <br>
                                            <small>${appointmentDetail.donorPhone}</small>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="status-badge" style="background-color: #e3f2fd; color: #1976d2;">
                                            ${appointmentDetail.donorBloodGroup}
                                        </span>
                                    </td>
                                    <td>
                                        <div>
                                            <strong>${appointmentDetail.campName}</strong>
                                            <br>
                                            <small>${appointmentDetail.campLocation}</small>
                                        </div>
                                    </td>
                                    <td>
                                        <div>
                                            <strong><fmt:formatDate value="${appointmentDetail.appointment.appointmentDate}" pattern="MMM dd, yyyy"/></strong>
                                            <br>
                                            <small>${appointmentDetail.appointment.timeSlot}</small>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="status-badge status-${appointmentDetail.appointment.status.toLowerCase()}">
                                            ${appointmentDetail.appointment.status}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn btn-info btn-sm" onclick="viewAppointmentDetails(${appointmentDetail.appointment.id})">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <c:if test="${appointmentDetail.appointment.status == 'PENDING'}">
                                                <button class="btn btn-success btn-sm" onclick="showApproveModal(${appointmentDetail.appointment.id})">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                                <button class="btn btn-danger btn-sm" onclick="showRejectModal(${appointmentDetail.appointment.id})">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Approve Modal -->
    <div id="approveModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Approve Appointment</h3>
                <span class="close" onclick="closeModal('approveModal')">&times;</span>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/donor-relation/appointments/approve">
                <input type="hidden" name="appointment_id" id="approveAppointmentId">
                <div class="form-group">
                    <label for="approveNotes">Notes (Optional)</label>
                    <textarea name="notes" id="approveNotes" placeholder="Add any notes about this approval..."></textarea>
                </div>
                <div style="display: flex; gap: 1rem; justify-content: flex-end;">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('approveModal')">Cancel</button>
                    <button type="submit" class="btn btn-success">Approve Appointment</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Reject Modal -->
    <div id="rejectModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Reject Appointment</h3>
                <span class="close" onclick="closeModal('rejectModal')">&times;</span>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/donor-relation/appointments/reject">
                <input type="hidden" name="appointment_id" id="rejectAppointmentId">
                <div class="form-group">
                    <label for="rejectReason">Reason for Rejection *</label>
                    <textarea name="reason" id="rejectReason" placeholder="Please provide a reason for rejecting this appointment..." required></textarea>
                </div>
                <div style="display: flex; gap: 1rem; justify-content: flex-end;">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('rejectModal')">Cancel</button>
                    <button type="submit" class="btn btn-danger">Reject Appointment</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Bulk Approve Modal -->
    <div id="bulkApproveModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Bulk Approve Appointments</h3>
                <span class="close" onclick="closeModal('bulkApproveModal')">&times;</span>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/donor-relation/appointments/bulk-approve">
                <div class="form-group">
                    <label>Selected Appointments: <span id="selectedCount">0</span></label>
                    <div id="selectedAppointments"></div>
                </div>
                <div class="form-group">
                    <label for="bulkApproveNotes">Notes (Optional)</label>
                    <textarea name="notes" id="bulkApproveNotes" placeholder="Add any notes about this bulk approval..."></textarea>
                </div>
                <div style="display: flex; gap: 1rem; justify-content: flex-end;">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('bulkApproveModal')">Cancel</button>
                    <button type="submit" class="btn btn-success">Approve Selected</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Bulk Reject Modal -->
    <div id="bulkRejectModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Bulk Reject Appointments</h3>
                <span class="close" onclick="closeModal('bulkRejectModal')">&times;</span>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/donor-relation/appointments/bulk-reject">
                <div class="form-group">
                    <label>Selected Appointments: <span id="selectedRejectCount">0</span></label>
                    <div id="selectedRejectAppointments"></div>
                </div>
                <div class="form-group">
                    <label for="bulkRejectReason">Reason for Rejection *</label>
                    <textarea name="reason" id="bulkRejectReason" placeholder="Please provide a reason for rejecting these appointments..." required></textarea>
                </div>
                <div style="display: flex; gap: 1rem; justify-content: flex-end;">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('bulkRejectModal')">Cancel</button>
                    <button type="submit" class="btn btn-danger">Reject Selected</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function showApproveModal(appointmentId) {
            document.getElementById('approveAppointmentId').value = appointmentId;
            document.getElementById('approveModal').style.display = 'block';
        }

        function showRejectModal(appointmentId) {
            document.getElementById('rejectAppointmentId').value = appointmentId;
            document.getElementById('rejectModal').style.display = 'block';
        }

        function showBulkApproveModal() {
            const selectedCheckboxes = document.querySelectorAll('.appointment-checkbox:checked');
            if (selectedCheckboxes.length === 0) {
                alert('Please select at least one appointment to approve.');
                return;
            }
            
            updateBulkApproveModal(selectedCheckboxes);
            document.getElementById('bulkApproveModal').style.display = 'block';
        }

        function showBulkRejectModal() {
            const selectedCheckboxes = document.querySelectorAll('.appointment-checkbox:checked');
            if (selectedCheckboxes.length === 0) {
                alert('Please select at least one appointment to reject.');
                return;
            }
            
            updateBulkRejectModal(selectedCheckboxes);
            document.getElementById('bulkRejectModal').style.display = 'block';
        }

        function updateBulkApproveModal(selectedCheckboxes) {
            const count = selectedCheckboxes.length;
            document.getElementById('selectedCount').textContent = count;
            
            const container = document.getElementById('selectedAppointments');
            container.innerHTML = '';
            
            selectedCheckboxes.forEach(checkbox => {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'appointment_ids';
                input.value = checkbox.value;
                container.appendChild(input);
            });
        }

        function updateBulkRejectModal(selectedCheckboxes) {
            const count = selectedCheckboxes.length;
            document.getElementById('selectedRejectCount').textContent = count;
            
            const container = document.getElementById('selectedRejectAppointments');
            container.innerHTML = '';
            
            selectedCheckboxes.forEach(checkbox => {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'appointment_ids';
                input.value = checkbox.value;
                container.appendChild(input);
            });
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        function toggleSelectAll() {
            const selectAllCheckbox = document.getElementById('selectAll');
            const appointmentCheckboxes = document.querySelectorAll('.appointment-checkbox');
            
            appointmentCheckboxes.forEach(checkbox => {
                checkbox.checked = selectAllCheckbox.checked;
            });
        }

        function viewAppointmentDetails(appointmentId) {
            window.open('${pageContext.request.contextPath}/donor-relation/appointments/details?id=' + appointmentId, '_blank');
        }

        function refreshPage() {
            window.location.reload();
        }

        // Close modals when clicking outside
        window.onclick = function(event) {
            const modals = document.querySelectorAll('.modal');
            modals.forEach(modal => {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
