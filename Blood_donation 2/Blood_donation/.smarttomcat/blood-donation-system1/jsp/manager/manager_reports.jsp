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
    <title>Reports</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #e74c3c;
            --primary-dark: #c0392b;
            --primary-light: #fadbd8;
            --text-dark: #2c3e50;
            --text-medium: #34495e;
            --text-light: #7f8c8d;
            --background: #f9f9f9;
            --white: #ffffff;
            --border: #ecf0f1;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --success: #27ae60;
            --warning: #f39c12;
            --danger: #e74c3c;
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
        }

        header h1 {
            font-size: 1.8rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        header h1 i {
            font-size: 1.5rem;
        }

        nav {
            background-color: var(--white);
            padding: 1rem 2rem;
            display: flex;
            gap: 1.5rem;
            box-shadow: var(--shadow);
        }

        nav a {
            color: var(--text-medium);
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 0;
            position: relative;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        nav a:hover {
            color: var(--primary);
        }

        nav a:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 3px;
            background-color: var(--primary);
            transition: width 0.3s ease;
        }

        nav a:hover:after {
            width: 100%;
        }

        .container {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        h2 {
            margin: 2rem 0 1.5rem;
            color: var(--primary);
            font-size: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        h2 i {
            font-size: 1.2rem;
        }

        h3 {
            margin: 1.5rem 0 1rem;
            color: var(--text-dark);
            font-size: 1.2rem;
            font-weight: 500;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--primary-light);
        }

        .report-card {
            background-color: var(--white);
            border-radius: 8px;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background-color: var(--primary);
            color: var(--white);
            padding: 1rem;
            text-align: left;
            font-weight: 500;
        }

        td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover {
            background-color: var(--primary-light);
        }

        .urgency-high {
            color: var(--danger);
            font-weight: 500;
        }

        .urgency-medium {
            color: var(--warning);
            font-weight: 500;
        }

        .status-completed {
            color: var(--success);
            font-weight: 500;
        }

        .status-pending {
            color: var(--warning);
            font-weight: 500;
        }

        /* Filter Styles */
        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
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

        .filter-group select,
        .filter-group input {
            padding: 0.75rem;
            border: 2px solid var(--border);
            border-radius: 6px;
            font-size: 0.9rem;
            transition: border-color 0.3s ease;
        }

        .filter-group select:focus,
        .filter-group input:focus {
            outline: none;
            border-color: var(--primary);
        }

        .filter-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 6px;
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

        .btn-secondary {
            background-color: var(--text-light);
            color: var(--white);
        }

        .btn-secondary:hover {
            background-color: var(--text-medium);
        }

        .btn-success {
            background-color: var(--success);
            color: var(--white);
        }

        .btn-success:hover {
            background-color: #229954;
        }

        .btn-info {
            background-color: #17a2b8;
            color: var(--white);
        }

        .btn-info:hover {
            background-color: #138496;
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.85rem;
        }

        /* Report Header Styles */
        .report-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--primary-light);
        }

        .report-actions {
            display: flex;
            gap: 0.5rem;
        }

        /* Table Responsive */
        .table-responsive {
            overflow-x: auto;
        }

        .text-center {
            text-align: center;
        }

        /* Status Colors */
        .status-active { color: var(--success); }
        .status-pending { color: var(--warning); }
        .status-approved { color: var(--success); }
        .status-rejected { color: var(--danger); }
        .status-completed { color: var(--success); }
        .status-cancelled { color: var(--text-light); }

        .urgency-low { color: var(--success); }
        .urgency-medium { color: var(--warning); }
        .urgency-high { color: var(--danger); }
        .urgency-critical { color: var(--danger); font-weight: bold; }

        /* Hide filters based on report type */
        .filter-group.hidden {
            display: none;
        }

        /* Loading state */
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        .loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 20px;
            height: 20px;
            margin: -10px 0 0 -10px;
            border: 2px solid var(--primary);
            border-top: 2px solid transparent;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <header>
        <h1><i class="fas fa-chart-pie"></i> Reports</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=manager"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/user-management"><i class="fas fa-users-cog"></i> User Management</a>
        <a href="${pageContext.request.contextPath}/stock"><i class="fas fa-warehouse"></i> Inventory</a>
        <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>
    <div class="container">
        <h2><i class="fas fa-chart-line"></i> System Reports</h2>

        <!-- Filter Section -->
        <div class="report-card">
            <h3><i class="fas fa-filter"></i> Report Filters</h3>
            <form id="reportFilterForm" method="GET" action="${pageContext.request.contextPath}/reports">
                <div class="filter-grid">
                    <div class="filter-group">
                        <label for="reportType">Report Type:</label>
                        <select id="reportType" name="reportType" onchange="toggleFilters()">
                            <option value="all" ${reportType == 'all' ? 'selected' : ''}>All Reports</option>
                            <option value="bloodStock" ${reportType == 'bloodStock' ? 'selected' : ''}>Blood Stock</option>
                            <option value="donors" ${reportType == 'donors' ? 'selected' : ''}>Donors</option>
                            <option value="requests" ${reportType == 'requests' ? 'selected' : ''}>Blood Requests</option>
                            <option value="appointments" ${reportType == 'appointments' ? 'selected' : ''}>Appointments</option>
                            <option value="feedback" ${reportType == 'feedback' ? 'selected' : ''}>Feedback</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="startDate">Start Date:</label>
                        <input type="date" id="startDate" name="startDate" value="${startDate}">
                    </div>
                    
                    <div class="filter-group">
                        <label for="endDate">End Date:</label>
                        <input type="date" id="endDate" name="endDate" value="${endDate}">
                    </div>
                    
                    <div class="filter-group" id="bloodGroupFilter">
                        <label for="bloodGroup">Blood Group:</label>
                        <select id="bloodGroup" name="bloodGroup">
                            <option value="">All Blood Groups</option>
                            <option value="A+" ${bloodGroup == 'A+' ? 'selected' : ''}>A+</option>
                            <option value="A-" ${bloodGroup == 'A-' ? 'selected' : ''}>A-</option>
                            <option value="B+" ${bloodGroup == 'B+' ? 'selected' : ''}>B+</option>
                            <option value="B-" ${bloodGroup == 'B-' ? 'selected' : ''}>B-</option>
                            <option value="AB+" ${bloodGroup == 'AB+' ? 'selected' : ''}>AB+</option>
                            <option value="AB-" ${bloodGroup == 'AB-' ? 'selected' : ''}>AB-</option>
                            <option value="O+" ${bloodGroup == 'O+' ? 'selected' : ''}>O+</option>
                            <option value="O-" ${bloodGroup == 'O-' ? 'selected' : ''}>O-</option>
                        </select>
                    </div>
                    
                    <div class="filter-group" id="statusFilter">
                        <label for="status">Status:</label>
                        <select id="status" name="status">
                            <option value="">All Status</option>
                            <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                            <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>Pending</option>
                            <option value="APPROVED" ${status == 'APPROVED' ? 'selected' : ''}>Approved</option>
                            <option value="REJECTED" ${status == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                            <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                            <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>
                    
                    <div class="filter-group" id="urgencyFilter">
                        <label for="urgency">Urgency:</label>
                        <select id="urgency" name="urgency">
                            <option value="">All Urgency</option>
                            <option value="LOW" ${urgency == 'LOW' ? 'selected' : ''}>Low</option>
                            <option value="MEDIUM" ${urgency == 'MEDIUM' ? 'selected' : ''}>Medium</option>
                            <option value="HIGH" ${urgency == 'HIGH' ? 'selected' : ''}>High</option>
                            <option value="CRITICAL" ${urgency == 'CRITICAL' ? 'selected' : ''}>Critical</option>
                        </select>
                    </div>
                </div>
                
                <div class="filter-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> Apply Filters
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="clearFilters()">
                        <i class="fas fa-times"></i> Clear Filters
                    </button>
                    <button type="button" class="btn btn-success" onclick="downloadPDF()">
                        <i class="fas fa-file-pdf"></i> Download PDF
                    </button>
                    <button type="button" class="btn btn-info" onclick="downloadHTML()">
                        <i class="fas fa-file-code"></i> Download HTML
                    </button>
                </div>
            </form>
        </div>

        <!-- Blood Stock Report -->
        <c:if test="${reportType == 'all' || reportType == 'bloodStock'}">
            <div class="report-card">
                <div class="report-header">
                    <h3><i class="fas fa-tint"></i> Blood Stock Report</h3>
                    <div class="report-actions">
                        <button class="btn btn-sm btn-success" onclick="downloadSpecificPDF('bloodStock')">
                            <i class="fas fa-file-pdf"></i> Download PDF
                        </button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Blood Group</th>
                                <th>Quantity</th>
                                <th>Expiry Date</th>
                                <th>Status</th>
                                <th>Collection Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty stocks}">
                                    <c:forEach var="stock" items="${stocks}">
                                        <tr>
                                            <td>${stock.bloodGroup}</td>
                                            <td>${stock.quantity} units</td>
                                            <td>${stock.expiryDate}</td>
                                            <td class="status-${stock.status.toLowerCase()}">${stock.status}</td>
                                            <td>${stock.collectionDate}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="text-center">No blood stock data available</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <!-- Donor Report -->
        <c:if test="${reportType == 'all' || reportType == 'donors'}">
            <div class="report-card">
                <div class="report-header">
                    <h3><i class="fas fa-user-friends"></i> Donor Report</h3>
                    <div class="report-actions">
                        <button class="btn btn-sm btn-success" onclick="downloadSpecificPDF('donors')">
                            <i class="fas fa-file-pdf"></i> Download PDF
                        </button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Blood Group</th>
                                <th>Age</th>
                                <th>Gender</th>
                                <th>Last Donation</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty donors}">
                                    <c:forEach var="donor" items="${donors}">
                                        <tr>
                                            <td>${donor.name}</td>
                                            <td>${donor.bloodGroup}</td>
                                            <td>${donor.age}</td>
                                            <td>${donor.gender}</td>
                                            <td>${donor.lastDonationDate != null ? donor.lastDonationDate : 'Never'}</td>
                                            <td class="status-${donor.status.toLowerCase()}">${donor.status}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center">No donor data available</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <!-- Blood Request Report -->
        <c:if test="${reportType == 'all' || reportType == 'requests'}">
            <div class="report-card">
                <div class="report-header">
                    <h3><i class="fas fa-hospital"></i> Blood Request Report</h3>
                    <div class="report-actions">
                        <button class="btn btn-sm btn-success" onclick="downloadSpecificPDF('requests')">
                            <i class="fas fa-file-pdf"></i> Download PDF
                        </button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Hospital</th>
                                <th>Blood Group</th>
                                <th>Quantity</th>
                                <th>Urgency</th>
                                <th>Status</th>
                                <th>Request Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requests}">
                                    <c:forEach var="request" items="${requests}">
                                        <tr>
                                            <td>${request.hospitalId}</td>
                                            <td>${request.bloodGroup}</td>
                                            <td>${request.quantity} units</td>
                                            <td class="urgency-${request.urgency.toLowerCase()}">${request.urgency}</td>
                                            <td class="status-${request.status.toLowerCase()}">${request.status}</td>
                                            <td>${request.requestDate}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center">No blood request data available</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <!-- Appointment Report -->
        <c:if test="${reportType == 'all' || reportType == 'appointments'}">
            <div class="report-card">
                <div class="report-header">
                    <h3><i class="fas fa-calendar-check"></i> Appointment Report</h3>
                    <div class="report-actions">
                        <button class="btn btn-sm btn-success" onclick="downloadSpecificPDF('appointments')">
                            <i class="fas fa-file-pdf"></i> Download PDF
                        </button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Donor Name</th>
                                <th>Appointment Date</th>
                                <th>Time Slot</th>
                                <th>Status</th>
                                <th>Created Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty appointments}">
                                    <c:forEach var="appointment" items="${appointments}">
                                        <tr>
                                            <td>${appointment.donorName}</td>
                                            <td>${appointment.appointmentDate}</td>
                                            <td>${appointment.timeSlot}</td>
                                            <td class="status-${appointment.status.toLowerCase()}">${appointment.status}</td>
                                            <td>${appointment.createdDate}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="text-center">No appointment data available</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <!-- Feedback Report -->
        <c:if test="${reportType == 'all' || reportType == 'feedback'}">
            <div class="report-card">
                <div class="report-header">
                    <h3><i class="fas fa-comments"></i> Feedback Report</h3>
                    <div class="report-actions">
                        <button class="btn btn-sm btn-success" onclick="downloadSpecificPDF('feedback')">
                            <i class="fas fa-file-pdf"></i> Download PDF
                        </button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>User</th>
                                <th>Category</th>
                                <th>Message</th>
                                <th>Status</th>
                                <th>Created Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty feedback}">
                                    <c:forEach var="fb" items="${feedback}">
                                        <tr>
                                            <td>${fb.userName}</td>
                                            <td>${fb.category}</td>
                                            <td>${fb.message}</td>
                                            <td class="status-${fb.status.toLowerCase()}">${fb.status}</td>
                                            <td>${fb.createdDate}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="text-center">No feedback data available</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
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

        // Filter functionality
        function toggleFilters() {
            const reportType = document.getElementById('reportType').value;
            const bloodGroupFilter = document.getElementById('bloodGroupFilter');
            const statusFilter = document.getElementById('statusFilter');
            const urgencyFilter = document.getElementById('urgencyFilter');
            
            // Show/hide filters based on report type
            if (reportType === 'bloodStock' || reportType === 'donors' || reportType === 'requests') {
                bloodGroupFilter.classList.remove('hidden');
            } else {
                bloodGroupFilter.classList.add('hidden');
            }
            
            if (reportType === 'donors' || reportType === 'appointments' || reportType === 'feedback') {
                statusFilter.classList.remove('hidden');
            } else {
                statusFilter.classList.add('hidden');
            }
            
            if (reportType === 'requests') {
                urgencyFilter.classList.remove('hidden');
            } else {
                urgencyFilter.classList.add('hidden');
            }
        }

        function clearFilters() {
            document.getElementById('reportFilterForm').reset();
            document.getElementById('reportType').value = 'all';
            toggleFilters();
        }

        function downloadPDF() {
            const form = document.getElementById('reportFilterForm');
            const formData = new FormData(form);
            formData.append('format', 'pdf');
            
            // Show loading state
            const container = document.querySelector('.container');
            container.classList.add('loading');
            
            // Create a temporary form for PDF download
            const tempForm = document.createElement('form');
            tempForm.method = 'GET';
            tempForm.action = '${pageContext.request.contextPath}/reports';
            tempForm.style.display = 'none';
            
            // Add all form data as hidden inputs
            for (let [key, value] of formData.entries()) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = value;
                tempForm.appendChild(input);
            }
            
            // Add format parameter
            const formatInput = document.createElement('input');
            formatInput.type = 'hidden';
            formatInput.name = 'format';
            formatInput.value = 'pdf';
            tempForm.appendChild(formatInput);
            
            document.body.appendChild(tempForm);
            tempForm.submit();
            document.body.removeChild(tempForm);
            
            // Remove loading state after a delay
            setTimeout(() => {
                container.classList.remove('loading');
            }, 2000);
        }

        function downloadHTML() {
            const form = document.getElementById('reportFilterForm');
            const formData = new FormData(form);
            formData.append('format', 'html');
            
            // Show loading state
            const container = document.querySelector('.container');
            container.classList.add('loading');
            
            // Create a temporary form for HTML download
            const tempForm = document.createElement('form');
            tempForm.method = 'GET';
            tempForm.action = '${pageContext.request.contextPath}/reports';
            tempForm.style.display = 'none';
            
            // Add all form data as hidden inputs
            for (let [key, value] of formData.entries()) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = value;
                tempForm.appendChild(input);
            }
            
            // Add format parameter
            const formatInput = document.createElement('input');
            formatInput.type = 'hidden';
            formatInput.name = 'format';
            formatInput.value = 'html';
            tempForm.appendChild(formatInput);
            
            document.body.appendChild(tempForm);
            tempForm.submit();
            document.body.removeChild(tempForm);
            
            // Remove loading state after a delay
            setTimeout(() => {
                container.classList.remove('loading');
            }, 2000);
        }

        function downloadSpecificPDF(reportType) {
            const form = document.getElementById('reportFilterForm');
            const formData = new FormData(form);
            formData.append('format', 'pdf');
            formData.append('reportType', reportType);
            
            // Show loading state
            const container = document.querySelector('.container');
            container.classList.add('loading');
            
            // Create a temporary form for PDF download
            const tempForm = document.createElement('form');
            tempForm.method = 'GET';
            tempForm.action = '${pageContext.request.contextPath}/reports';
            tempForm.style.display = 'none';
            
            // Add all form data as hidden inputs
            for (let [key, value] of formData.entries()) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = value;
                tempForm.appendChild(input);
            }
            
            // Override report type
            const reportTypeInput = document.createElement('input');
            reportTypeInput.type = 'hidden';
            reportTypeInput.name = 'reportType';
            reportTypeInput.value = reportType;
            tempForm.appendChild(reportTypeInput);
            
            // Add format parameter
            const formatInput = document.createElement('input');
            formatInput.type = 'hidden';
            formatInput.name = 'format';
            formatInput.value = 'pdf';
            tempForm.appendChild(formatInput);
            
            document.body.appendChild(tempForm);
            tempForm.submit();
            document.body.removeChild(tempForm);
            
            // Remove loading state after a delay
            setTimeout(() => {
                container.classList.remove('loading');
            }, 2000);
        }

        // Initialize filters on page load
        document.addEventListener('DOMContentLoaded', function() {
            toggleFilters();
            
            // Set default date range to last 30 days
            const today = new Date();
            const thirtyDaysAgo = new Date(today.getTime() - (30 * 24 * 60 * 60 * 1000));
            
            if (!document.getElementById('startDate').value) {
                document.getElementById('startDate').value = thirtyDaysAgo.toISOString().split('T')[0];
            }
            if (!document.getElementById('endDate').value) {
                document.getElementById('endDate').value = today.toISOString().split('T')[0];
            }
        });

        // Form validation
        document.getElementById('reportFilterForm').addEventListener('submit', function(e) {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            
            if (startDate && endDate && new Date(startDate) > new Date(endDate)) {
                e.preventDefault();
                alert('Start date cannot be after end date');
                return false;
            }
        });
    </script>
</body>
</html>