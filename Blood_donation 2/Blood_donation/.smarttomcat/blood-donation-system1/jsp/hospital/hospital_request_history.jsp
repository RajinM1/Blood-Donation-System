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
    <title>Request History</title>
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
            --success-light: #d5f4e6;
            --error: #e74c3c;
            --error-light: #fdecea;
            --urgent: #f39c12;
            --pending: #f1c40f;
            --completed: #2ecc71;
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

        .history-container {
            background-color: var(--white);
            padding: 2rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
            margin-top: 1rem;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        th {
            background-color: var(--primary);
            color: var(--white);
            padding: 1rem;
            text-align: left;
            position: sticky;
            top: 0;
        }

        td {
            padding: 0.8rem 1rem;
            border-bottom: 1px solid var(--border);
        }

        tr:hover {
            background-color: rgba(231, 76, 60, 0.05);
        }

        .status-pending {
            color: var(--pending);
            font-weight: 500;
        }

        .status-completed {
            color: var(--completed);
            font-weight: 500;
        }

        .status-urgent {
            color: var(--urgent);
            font-weight: 500;
        }

        .urgency-normal {
            color: var(--text-dark);
        }

        .urgency-urgent {
            color: var(--urgent);
            font-weight: 500;
        }

        .urgency-critical {
            color: var(--error);
            font-weight: 600;
        }

        .no-requests {
            text-align: center;
            padding: 2rem;
            color: var(--text-light);
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert.success {
            background-color: var(--success-light);
            color: var(--success);
            border-left: 4px solid var(--success);
        }

        .alert.error {
            background-color: var(--error-light);
            color: var(--error);
            border-left: 4px solid var(--error);
        }

        .sortable {
            cursor: pointer;
            user-select: none;
            position: relative;
            transition: background-color 0.2s;
        }

        .sortable:hover {
            background-color: var(--border);
        }

        .sortable i.fa-sort {
            opacity: 0.5;
            margin-left: 0.5rem;
        }

        .sortable.asc i.fa-sort:before {
            content: "\f0de";
            opacity: 1;
        }

        .sortable.desc i.fa-sort:before {
            content: "\f0dd";
            opacity: 1;
        }

        .table-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 1.5rem 0;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .search-box {
            position: relative;
            flex: 1;
            min-width: 250px;
        }

        .search-box i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
        }

        .search-box input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.5rem;
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 0.9rem;
            transition: border-color 0.3s;
        }

        .search-box input:focus {
            outline: none;
            border-color: var(--primary);
        }

        .filter-options {
            display: flex;
            gap: 1rem;
        }

        .filter-options select {
            padding: 0.75rem;
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 0.9rem;
            background: var(--white);
            cursor: pointer;
            transition: border-color 0.3s;
        }

        .filter-options select:focus {
            outline: none;
            border-color: var(--primary);
        }

        @media (max-width: 768px) {
            .history-container {
                padding: 1rem;
            }

            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-history"></i>
        <h1>Request History</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/hospital/dashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/jsp/hospital/hospital_blood_request.jsp">
            <i class="fas fa-tint"></i> Blood Request
        </a>
        <a href="${pageContext.request.contextPath}/blood-request/history" class="active">
            <i class="fas fa-history"></i> Request History
        </a>
        <a href="${pageContext.request.contextPath}/feedback/hospital">
            <i class="fas fa-comment"></i> Feedback
        </a>
        <a href="${pageContext.request.contextPath}/hospital/profile">
            <i class="fas fa-user"></i> Profile
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <c:if test="${not empty param.success}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> Blood request submitted successfully!
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <h2><i class="fas fa-clipboard-list"></i> Your Request History</h2>

        <div class="table-controls">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput" placeholder="Search requests..." onkeyup="filterTable()">
            </div>
            <div class="filter-options">
                <select id="statusFilter" onchange="filterTable()">
                    <option value="">All Status</option>
                    <option value="PENDING">Pending</option>
                    <option value="APPROVED">Approved</option>
                    <option value="REJECTED">Rejected</option>
                    <option value="COMPLETED">Completed</option>
                </select>
                <select id="urgencyFilter" onchange="filterTable()">
                    <option value="">All Urgency</option>
                    <option value="LOW">Low</option>
                    <option value="MEDIUM">Medium</option>
                    <option value="HIGH">High</option>
                    <option value="URGENT">Urgent</option>
                    <option value="CRITICAL">Critical</option>
                </select>
            </div>
        </div>

        <div class="history-container">
            <c:choose>
                <c:when test="${not empty requests}">
                    <table id="requestsTable">
                        <thead>
                            <tr>
                                <th onclick="sortTable(0)" class="sortable"><i class="fas fa-tint"></i> Blood Group <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable(1)" class="sortable"><i class="fas fa-flask"></i> Quantity <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable(2)" class="sortable"><i class="fas fa-user"></i> Patient <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable(3)" class="sortable"><i class="fas fa-exclamation"></i> Urgency <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable(4)" class="sortable"><i class="fas fa-info-circle"></i> Status <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable(5)" class="sortable"><i class="fas fa-calendar-plus"></i> Request Date <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable(6)" class="sortable"><i class="fas fa-calendar-check"></i> Delivery Date <i class="fas fa-sort"></i></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="request" items="${requests}">
                                <tr>
                                    <td>${request.bloodGroup}</td>
                                    <td>${request.quantity} units</td>
                                    <td>${request.patientName}</td>
                                    <td class="urgency-${request.urgency.toLowerCase()}">
                                        <i class="fas fa-${request.urgency == 'URGENT' || request.urgency == 'CRITICAL' ? 'exclamation-triangle' : 'clock'}"></i>
                                        ${request.urgency}
                                    </td>
                                    <td class="status-${request.status.toLowerCase()}">
                                        <i class="fas fa-${request.status == 'COMPLETED' ? 'check-circle' : 'hourglass-half'}"></i>
                                        ${request.status}
                                    </td>
                                    <td>${request.requestDate}</td>
                                    <td>${request.deliveryDate}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-requests">
                        <i class="fas fa-clipboard-list fa-3x" style="color: var(--text-light); margin-bottom: 1rem;"></i>
                        <h3>No blood requests found</h3>
                        <p>Your blood request history will appear here once you make your first request</p>
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

        // Table sorting functionality
        let sortDirection = {};
        
        function sortTable(columnIndex) {
            const table = document.getElementById('requestsTable');
            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr'));
            
            // Toggle sort direction
            if (sortDirection[columnIndex] === 'asc') {
                sortDirection[columnIndex] = 'desc';
            } else {
                sortDirection[columnIndex] = 'asc';
            }
            
            // Clear other column sort indicators
            const headers = table.querySelectorAll('th.sortable');
            headers.forEach((header, index) => {
                if (index !== columnIndex) {
                    header.classList.remove('asc', 'desc');
                }
            });
            
            // Set current column sort indicator
            const currentHeader = headers[columnIndex];
            currentHeader.classList.remove('asc', 'desc');
            currentHeader.classList.add(sortDirection[columnIndex]);
            
            // Sort rows
            rows.sort((a, b) => {
                const aValue = a.cells[columnIndex].textContent.trim();
                const bValue = b.cells[columnIndex].textContent.trim();
                
                // Handle different data types
                let comparison = 0;
                
                if (columnIndex === 1) { // Quantity column
                    const aNum = parseInt(aValue.replace(' units', ''));
                    const bNum = parseInt(bValue.replace(' units', ''));
                    comparison = aNum - bNum;
                } else if (columnIndex === 5 || columnIndex === 6) { // Date columns
                    const aDate = new Date(aValue);
                    const bDate = new Date(bValue);
                    comparison = aDate - bDate;
                } else { // Text columns
                    comparison = aValue.localeCompare(bValue);
                }
                
                return sortDirection[columnIndex] === 'asc' ? comparison : -comparison;
            });
            
            // Re-append sorted rows
            rows.forEach(row => tbody.appendChild(row));
        }

        // Table filtering functionality
        function filterTable() {
            const searchInput = document.getElementById('searchInput');
            const statusFilter = document.getElementById('statusFilter');
            const urgencyFilter = document.getElementById('urgencyFilter');
            
            const searchTerm = searchInput.value.toLowerCase();
            const statusValue = statusFilter.value;
            const urgencyValue = urgencyFilter.value;
            
            const table = document.getElementById('requestsTable');
            const tbody = table.querySelector('tbody');
            const rows = tbody.querySelectorAll('tr');
            
            rows.forEach(row => {
                const bloodGroup = row.cells[0].textContent.toLowerCase();
                const quantity = row.cells[1].textContent.toLowerCase();
                const patient = row.cells[2].textContent.toLowerCase();
                const urgency = row.cells[3].textContent.trim();
                const status = row.cells[4].textContent.trim();
                const requestDate = row.cells[5].textContent.toLowerCase();
                const deliveryDate = row.cells[6].textContent.toLowerCase();
                
                const matchesSearch = searchTerm === '' || 
                    bloodGroup.includes(searchTerm) ||
                    quantity.includes(searchTerm) ||
                    patient.includes(searchTerm) ||
                    urgency.toLowerCase().includes(searchTerm) ||
                    status.toLowerCase().includes(searchTerm) ||
                    requestDate.includes(searchTerm) ||
                    deliveryDate.includes(searchTerm);
                
                const matchesStatus = statusValue === '' || status === statusValue;
                const matchesUrgency = urgencyValue === '' || urgency === urgencyValue;
                
                if (matchesSearch && matchesStatus && matchesUrgency) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>