<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blood Stock Management - Medical Staff</title>
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

        nav a.active {
            background-color: var(--primary);
            color: var(--white);
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

        .status-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: bold;
            text-transform: uppercase;
        }
        .status-usable {
            background-color: #d4edda;
            color: #155724;
        }
        .status-quarantined {
            background-color: #f8d7da;
            color: #721c24;
        }
        .status-expired {
            background-color: #f5c6cb;
            color: #721c24;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .btn-add {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
            margin-bottom: 1rem;
        }
        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(40, 167, 69, 0.4);
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.6);
            backdrop-filter: blur(2px);
            animation: fadeIn 0.3s ease;
            overflow-y: auto;
        }
        .modal-content {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            margin: 2% auto;
            padding: 0;
            border-radius: 16px;
            width: 95%;
            max-width: 800px;
            max-height: 90vh;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            animation: slideIn 0.3s ease;
            overflow: hidden;
            position: relative;
            display: flex;
            flex-direction: column;
        }
        .modal-header {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            padding: 1.5rem 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .modal-header h3 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 600;
        }
        .modal-body {
            padding: 2rem;
            flex: 1;
            overflow-y: auto;
            min-height: 0;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.75rem;
            font-weight: 600;
            color: #2c3e50;
            font-size: 0.95rem;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid #e1e8ed;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #fafbfc;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #e74c3c;
            background: white;
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.1);
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }
        .form-section {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            border-left: 4px solid #e74c3c;
        }
        .form-section h4 {
            margin: 0 0 1rem 0;
            color: #2c3e50;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-add {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }
        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(40, 167, 69, 0.4);
        }
        .modal-footer {
            background: #f8f9fa;
            padding: 1.5rem 2rem;
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            border-top: 1px solid #e1e8ed;
            flex-shrink: 0;
            min-height: 80px;
            align-items: center;
        }
        .btn-submit {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            min-width: 140px;
            justify-content: center;
            white-space: nowrap;
        }
        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }
        .btn-submit:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        .btn-cancel {
            background: #6c757d;
            color: white;
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            min-width: 140px;
            justify-content: center;
            white-space: nowrap;
        }
        .btn-cancel:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            border: none;
            padding: 0.5rem 0.75rem;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            box-shadow: 0 2px 4px rgba(220, 53, 69, 0.3);
        }
        
        .btn-delete:hover {
            background: linear-gradient(135deg, #c82333, #bd2130);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.4);
        }
        
        .btn-delete:active {
            transform: translateY(0);
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes slideIn {
            from { 
                opacity: 0;
                transform: translateY(-50px) scale(0.95);
            }
            to { 
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        .required {
            color: #e74c3c;
        }
        .form-help {
            font-size: 0.85rem;
            color: #6c757d;
            margin-top: 0.25rem;
        }
        
        /* Responsive modal */
        @media (max-width: 768px) {
            .modal-content {
                width: 98%;
                margin: 1% auto;
                max-height: 95vh;
            }
            .modal-body {
                padding: 1rem;
                flex: 1;
                min-height: 0;
            }
            .form-row {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            .modal-header {
                padding: 1rem;
            }
            .modal-footer {
                padding: 1rem;
                flex-direction: column;
                gap: 0.75rem;
                min-height: 100px;
            }
            .btn-submit, .btn-cancel {
                width: 100%;
                justify-content: center;
                padding: 0.875rem 1.5rem;
                font-size: 1rem;
            }
        }
        .alert {
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 4px;
        }
        .table-container {
            background: var(--white);
            border-radius: 8px;
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-top: 1rem;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            font-size: 0.9rem;
        }
        td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
        }
        tr:hover {
            background-color: #f8f9fa;
        }
        tr:last-child td {
            border-bottom: none;
        }
        .alert.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #e74c3c;
        }
        .stat-label {
            color: #7f8c8d;
            margin-top: 0.5rem;
        }
        
        .alert {
            padding: 1rem 1.5rem;
            margin: 1rem 0;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
            animation: slideIn 0.3s ease-out;
        }
        
        .alert.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-boxes"></i>
        <h1>Blood Stock Management</h1>
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
        <a href="${pageContext.request.contextPath}/medical/blood-stock" class="active">
            <i class="fas fa-boxes"></i> Blood Stock
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    
    <div class="container">
        <!-- Success/Error Messages -->
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
                <div class="stat-number">
                    <c:set var="totalUnits" value="0" />
                    <c:forEach var="stock" items="${bloodStock}">
                        <c:set var="totalUnits" value="${totalUnits + stock.quantity}" />
                    </c:forEach>
                    ${totalUnits}
                </div>
                <div class="stat-label">Total Units</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:set var="usableUnits" value="0" />
                    <c:forEach var="stock" items="${bloodStock}">
                        <c:if test="${stock.status == 'AVAILABLE' && stock.expiryDate >= now}">
                            <c:set var="usableUnits" value="${usableUnits + stock.quantity}" />
                        </c:if>
                    </c:forEach>
                    ${usableUnits}
                </div>
                <div class="stat-label">Usable Units</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:set var="expiredUnits" value="0" />
                    <c:forEach var="stock" items="${bloodStock}">
                        <c:if test="${stock.expiryDate < now}">
                            <c:set var="expiredUnits" value="${expiredUnits + stock.quantity}" />
                        </c:if>
                    </c:forEach>
                    ${expiredUnits}
                </div>
                <div class="stat-label">Expired Units</div>
            </div>
        </div>

        <!-- Add Blood Stock Button -->
        <button class="btn-add" onclick="openAddStockModal()">
            <i class="fas fa-plus"></i> Add Blood Stock
        </button>

        <!-- Blood Stock Table -->
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> ID</th>
                        <th><i class="fas fa-tint"></i> Blood Group</th>
                        <th><i class="fas fa-cubes"></i> Quantity</th>
                        <th><i class="fas fa-calendar-plus"></i> Collection Date</th>
                        <th><i class="fas fa-calendar-times"></i> Expiry Date</th>
                        <th><i class="fas fa-flask"></i> Volume (ml)</th>
                        <th><i class="fas fa-vial"></i> Screening</th>
                        <th><i class="fas fa-info-circle"></i> Status</th>
                        <th><i class="fas fa-user"></i> Donor ID</th>
                        <th><i class="fas fa-cogs"></i> Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty bloodStock}">
                            <tr>
                                <td colspan="10" style="text-align: center; padding: 2rem; color: #7f8c8d;">
                                    <i class="fas fa-boxes" style="font-size: 2rem; margin-bottom: 1rem; display: block;"></i>
                                    No blood stock found.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="stock" items="${bloodStock}">
                                <tr>
                                    <td>#${stock.id}</td>
                                    <td>
                                        <span style="font-weight: bold; color: #e74c3c;">${stock.bloodGroup}</span>
                                    </td>
                                    <td>${stock.quantity}</td>
                                    <td>
                                        <fmt:formatDate value="${stock.collectionDate}" pattern="MMM dd, yyyy" />
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${stock.expiryDate}" pattern="MMM dd, yyyy" />
                                        <c:if test="${stock.expiryDate < now}">
                                            <br><small style="color: #e74c3c;">EXPIRED</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${stock.volume > 0}">
                                                ${stock.volume}
                                            </c:when>
                                            <c:otherwise>
                                                450.0
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${stock.status == 'AVAILABLE'}">
                                                NEGATIVE
                                            </c:when>
                                            <c:when test="${stock.status == 'RESERVED'}">
                                                POSITIVE
                                            </c:when>
                                            <c:when test="${stock.status == 'DISCARDED'}">
                                                PENDING
                                            </c:when>
                                            <c:otherwise>
                                                PENDING
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${stock.expiryDate < now}">
                                                <span class="status-badge status-expired">EXPIRED</span>
                                            </c:when>
                                            <c:when test="${stock.status == 'AVAILABLE'}">
                                                <span class="status-badge status-usable">USABLE</span>
                                            </c:when>
                                            <c:when test="${stock.status == 'RESERVED'}">
                                                <span class="status-badge status-quarantined">QUARANTINED</span>
                                            </c:when>
                                            <c:when test="${stock.status == 'DISCARDED'}">
                                                <span class="status-badge status-pending">PENDING</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-quarantined">QUARANTINED</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>#${stock.donorId}</td>
                                    <td>
                                        <button class="btn-delete" onclick="confirmDelete('${stock.id}', '${stock.bloodGroup}', '${stock.quantity}')" 
                                                title="Delete Blood Stock">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Add Blood Stock Modal -->
    <div id="addStockModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <i class="fas fa-plus-circle"></i>
                <h3>Add Blood Stock</h3>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/medical/add-blood-stock" method="post" id="addStockForm">
                    <!-- Basic Information Section -->
                    <div class="form-section">
                        <h4><i class="fas fa-info-circle"></i> Basic Information</h4>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="blood_group">Blood Group <span class="required">*</span></label>
                                <select name="blood_group" id="blood_group" required>
                                    <option value="">Select Blood Group</option>
                                    <option value="A+">A+ (A Positive)</option>
                                    <option value="A-">A- (A Negative)</option>
                                    <option value="B+">B+ (B Positive)</option>
                                    <option value="B-">B- (B Negative)</option>
                                    <option value="AB+">AB+ (AB Positive)</option>
                                    <option value="AB-">AB- (AB Negative)</option>
                                    <option value="O+">O+ (O Positive)</option>
                                    <option value="O-">O- (O Negative)</option>
                                </select>
                                <div class="form-help">Select the blood group type</div>
                            </div>
                            <div class="form-group">
                                <label for="quantity">Quantity (units) <span class="required">*</span></label>
                                <input type="number" name="quantity" id="quantity" min="1" max="100" value="1" required>
                                <div class="form-help">Number of blood units (1 unit = 450ml)</div>
                            </div>
                        </div>
                    </div>

                    <!-- Collection Details Section -->
                    <div class="form-section">
                        <h4><i class="fas fa-calendar-alt"></i> Collection Details</h4>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="collection_date">Collection Date <span class="required">*</span></label>
                                <input type="date" name="collection_date" id="collection_date" required>
                                <div class="form-help">Date when blood was collected</div>
                            </div>
                            <div class="form-group">
                                <label for="expiry_date">Expiry Date <span class="required">*</span></label>
                                <input type="date" name="expiry_date" id="expiry_date" required>
                                <div class="form-help">Blood expires after 42 days from collection</div>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="volume">Volume (ml) <span class="required">*</span></label>
                                <input type="number" name="volume" id="volume" min="200" max="500" value="450" step="0.1" required>
                                <div class="form-help">Volume in milliliters (standard: 450ml)</div>
                            </div>
                            <div class="form-group">
                                <label for="donor_id">Donor ID <span class="required">*</span></label>
                                <input type="number" name="donor_id" id="donor_id" min="1" required>
                                <div class="form-help">ID of the donor who provided blood</div>
                            </div>
                        </div>
                    </div>

                    <!-- Screening Information Section -->
                    <div class="form-section">
                        <h4><i class="fas fa-vial"></i> Screening Information</h4>
                        <div class="form-group">
                            <label for="screening_result">Screening Result <span class="required">*</span></label>
                            <select name="screening_result" id="screening_result" required>
                                <option value="NEGATIVE">NEGATIVE - Safe for transfusion</option>
                                <option value="POSITIVE">POSITIVE - Requires quarantine</option>
                                <option value="PENDING">PENDING - Awaiting results</option>
                            </select>
                            <div class="form-help">Blood screening test results</div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" onclick="closeAddStockModal()" class="btn-cancel">
                    <i class="fas fa-times"></i> Cancel
                </button>
                <button type="submit" form="addStockForm" class="btn-submit">
                    <i class="fas fa-plus"></i> Add Blood Stock
                </button>
            </div>
        </div>
    </div>

    <script>
        // Initialize form with default values
        function initializeForm() {
            // Set today's date as default for collection date
            document.getElementById('collection_date').valueAsDate = new Date();
            
            // Set expiry date to 42 days from today
            const expiryDate = new Date();
            expiryDate.setDate(expiryDate.getDate() + 42);
            document.getElementById('expiry_date').valueAsDate = expiryDate;
        }

        // Initialize form when page loads
        document.addEventListener('DOMContentLoaded', initializeForm);

        function openAddStockModal() {
            const modal = document.getElementById('addStockModal');
            if (modal) {
                modal.style.display = 'block';
                modal.style.visibility = 'visible';
                modal.style.opacity = '1';
                
                // Reset form when opening
                const form = document.getElementById('addStockForm');
                if (form) {
                    form.reset();
                }
                initializeForm();
                
                // Focus on first input after a short delay
                setTimeout(() => {
                    const firstInput = document.getElementById('blood_group');
                    if (firstInput) {
                        firstInput.focus();
                    }
                }, 100);
                
                // Prevent body scroll when modal is open
                document.body.style.overflow = 'hidden';
            } else {
                console.error('Modal element not found');
            }
        }

        function closeAddStockModal() {
            const modal = document.getElementById('addStockModal');
            if (modal) {
                modal.style.display = 'none';
                modal.style.visibility = 'hidden';
                modal.style.opacity = '0';
                
                // Restore body scroll
                document.body.style.overflow = 'auto';
            }
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('addStockModal');
            if (event.target == modal) {
                closeAddStockModal();
            }
        }

        // Close modal with Escape key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeAddStockModal();
            }
        });

        // Form validation
        document.getElementById('addStockForm').addEventListener('submit', function(event) {
            const bloodGroup = document.getElementById('blood_group').value;
            const quantity = document.getElementById('quantity').value;
            const collectionDate = document.getElementById('collection_date').value;
            const expiryDate = document.getElementById('expiry_date').value;
            const volume = document.getElementById('volume').value;
            const donorId = document.getElementById('donor_id').value;
            const screeningResult = document.getElementById('screening_result').value;

            // Basic validation
            if (!bloodGroup || !quantity || !collectionDate || !expiryDate || !volume || !donorId || !screeningResult) {
                event.preventDefault();
                alert('Please fill in all required fields.');
                return;
            }

            // Validate dates
            const collection = new Date(collectionDate);
            const expiry = new Date(expiryDate);
            const today = new Date();
            today.setHours(0, 0, 0, 0);

            if (collection > today) {
                event.preventDefault();
                alert('Collection date cannot be in the future.');
                return;
            }

            if (expiry <= collection) {
                event.preventDefault();
                alert('Expiry date must be after collection date.');
                return;
            }

            // Validate volume
            if (volume < 200 || volume > 500) {
                event.preventDefault();
                alert('Volume must be between 200ml and 500ml.');
                return;
            }

            // Validate quantity
            if (quantity < 1 || quantity > 100) {
                event.preventDefault();
                alert('Quantity must be between 1 and 100 units.');
                return;
            }

            // Validate donor ID
            if (donorId < 1) {
                event.preventDefault();
                alert('Donor ID must be a positive number.');
                return;
            }

            // Show loading state
            const submitBtn = document.querySelector('.btn-submit');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding...';
            submitBtn.disabled = true;

            // Re-enable button after 3 seconds (in case of slow response)
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            }, 3000);
        });

        // Auto-calculate expiry date when collection date changes
        document.getElementById('collection_date').addEventListener('change', function() {
            const collectionDate = new Date(this.value);
            if (collectionDate) {
                const expiryDate = new Date(collectionDate);
                expiryDate.setDate(expiryDate.getDate() + 42);
                document.getElementById('expiry_date').valueAsDate = expiryDate;
            }
        });

        // Auto-calculate quantity when volume changes
        document.getElementById('volume').addEventListener('input', function() {
            const volume = parseFloat(this.value);
            if (volume && volume > 0) {
                const quantity = Math.ceil(volume / 450); // 1 unit = 450ml
                document.getElementById('quantity').value = quantity;
            }
        });

        // Prevent back button access after logout
        window.history.pushState(null, null, window.location.href);
        window.onpopstate = function(event) {
            window.history.pushState(null, null, window.location.href);
        };
        
        // Delete confirmation function
        function confirmDelete(stockId, bloodGroup, quantity) {
            const message = 'Are you sure you want to delete this blood stock?\n\n' +
                          'Blood Group: ' + bloodGroup + '\n' +
                          'Quantity: ' + quantity + ' units\n\n' +
                          'This action cannot be undone.';
            
            if (confirm(message)) {
                // Create a form to submit the delete request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/medical/delete-blood-stock';
                
                const stockIdInput = document.createElement('input');
                stockIdInput.type = 'hidden';
                stockIdInput.name = 'stock_id';
                stockIdInput.value = stockId;
                
                form.appendChild(stockIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
