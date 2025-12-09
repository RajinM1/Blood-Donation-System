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
    <title>Inventory Management</title>
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
        }

        header h1 {
            font-size: 1.5rem;
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
        }

        nav a {
            color: var(--text-dark);
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.3rem 0;
            position: relative;
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
            max-width: 1400px;
            margin: 0 auto;
        }

        h2 {
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
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

        .stat-icon.total { background: linear-gradient(135deg, #3498db, #2980b9); }
        .stat-icon.low { background: linear-gradient(135deg, #e74c3c, #c0392b); }
        .stat-icon.expiring { background: linear-gradient(135deg, #f39c12, #e67e22); }
        .stat-icon.available { background: linear-gradient(135deg, #27ae60, #229954); }

        .stat-info h3 {
            font-size: 2rem;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0;
        }

        .stat-info p {
            color: var(--text-light);
            margin: 0;
            font-size: 0.9rem;
        }

        .inventory-section {
            background: var(--white);
            border-radius: 8px;
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        .section-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            padding: 1rem 1.5rem;
            display: flex;
            justify-content: between;
            align-items: center;
        }

        .inventory-table {
            width: 100%;
            border-collapse: collapse;
        }

        .inventory-table th {
            background-color: #f8f9fa;
            color: var(--text-dark);
            padding: 1rem 1.5rem;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid var(--border);
        }

        .inventory-table td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border);
        }

        .inventory-table tr:last-child td {
            border-bottom: none;
        }

        .inventory-table tr:hover {
            background-color: var(--background);
        }

        .blood-type {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .blood-icon {
            color: var(--primary);
            font-size: 1.2rem;
        }

        .quantity-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.9rem;
        }

        .quantity-high {
            background: #d4edda;
            color: #155724;
        }

        .quantity-medium {
            background: #fff3cd;
            color: #856404;
        }

        .quantity-low {
            background: #f8d7da;
            color: #721c24;
        }

        .expiry-status {
            padding: 0.3rem 0.6rem;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .expiry-good {
            background: #d4edda;
            color: #155724;
        }

        .expiry-warning {
            background: #fff3cd;
            color: #856404;
        }

        .expiry-critical {
            background: #f8d7da;
            color: #721c24;
        }



        .filters {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 0.5rem 1rem;
            border: 2px solid var(--border);
            background: var(--white);
            color: var(--text-dark);
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.2s;
        }

        .filter-btn:hover,
        .filter-btn.active {
            border-color: var(--primary);
            background: var(--primary);
            color: var(--white);
        }

        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .inventory-table {
                font-size: 0.9rem;
            }
            
            .inventory-table th,
            .inventory-table td {
                padding: 0.8rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1><i class="fas fa-warehouse"></i> Inventory Management</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=manager">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/user-management">
            <i class="fas fa-users-cog"></i> User Management
        </a>
        <a href="${pageContext.request.contextPath}/stock" class="active">
            <i class="fas fa-warehouse"></i> Inventory
        </a>
        <a href="${pageContext.request.contextPath}/reports">
            <i class="fas fa-chart-bar"></i> Reports
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <h2><i class="fas fa-warehouse"></i> Blood Inventory Overview</h2>
        
        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon total">
                    <i class="fas fa-tint"></i>
                </div>
                <div class="stat-info">
                    <h3>1,247</h3>
                    <p>Total Units</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon available">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-info">
                    <h3>1,089</h3>
                    <p>Available Units</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon low">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div class="stat-info">
                    <h3>3</h3>
                    <p>Low Stock Types</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon expiring">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-info">
                    <h3>158</h3>
                    <p>Expiring Soon</p>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="filters">
            <button class="filter-btn active" onclick="filterStock('all')">All Types</button>
            <button class="filter-btn" onclick="filterStock('low')">Low Stock</button>
            <button class="filter-btn" onclick="filterStock('expiring')">Expiring Soon</button>
            <button class="filter-btn" onclick="filterStock('available')">Available</button>
        </div>

        <!-- Inventory Table -->
        <div class="inventory-section">
            <div class="section-header">
                <h3><i class="fas fa-tint"></i> Blood Stock Details</h3>
            </div>
            <table class="inventory-table">
                <thead>
                    <tr>
                        <th>Blood Group</th>
                        <th>Current Stock</th>
                        <th>Status</th>
                        <th>Expiry Date</th>
                        <th>Last Updated</th>
                    </tr>
                </thead>
                <tbody>
                    <tr data-type="available">
                        <td class="blood-type">
                            <i class="fas fa-tint blood-icon"></i> A+
                        </td>
                        <td>
                            <span class="quantity-badge quantity-high">
                                <i class="fas fa-check"></i> 156 units
                            </span>
                        </td>
                        <td><span class="expiry-status expiry-good">Good Stock</span></td>
                        <td>Dec 25, 2025</td>
                        <td>2 hours ago</td>
                    </tr>
                    <tr data-type="low">
                        <td class="blood-type">
                            <i class="fas fa-tint blood-icon"></i> O-
                        </td>
                        <td>
                            <span class="quantity-badge quantity-low">
                                <i class="fas fa-exclamation-triangle"></i> 8 units
                            </span>
                        </td>
                        <td><span class="expiry-status expiry-critical">Low Stock</span></td>
                        <td>Dec 20, 2025</td>
                        <td>1 hour ago</td>
                    </tr>
                    <tr data-type="expiring">
                        <td class="blood-type">
                            <i class="fas fa-tint blood-icon"></i> B+
                        </td>
                        <td>
                            <span class="quantity-badge quantity-medium">
                                <i class="fas fa-clock"></i> 45 units
                            </span>
                        </td>
                        <td><span class="expiry-status expiry-warning">Expiring Soon</span></td>
                        <td>Dec 18, 2025</td>
                        <td>30 min ago</td>
                    </tr>
                    <c:forEach var="stock" items="${stocks}">
                        <tr data-type="available">
                            <td class="blood-type">
                                <i class="fas fa-tint blood-icon"></i> ${stock.bloodGroup}
                            </td>
                            <td>
                                <span class="quantity-badge quantity-high">
                                    <i class="fas fa-check"></i> ${stock.quantity} units
                                </span>
                            </td>
                            <td><span class="expiry-status expiry-good">Available</span></td>
                            <td>${stock.expiryDate}</td>
                            <td>Recently</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>

    <script>
        // Filter functionality
        function filterStock(type) {
            const rows = document.querySelectorAll('tbody tr');
            const buttons = document.querySelectorAll('.filter-btn');
            
            // Update active button
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            // Filter rows
            rows.forEach(row => {
                if (type === 'all' || row.dataset.type === type) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        // Prevent back button access after logout
        window.history.pushState(null, null, window.location.href);
        window.onpopstate = function(event) {
            window.history.pushState(null, null, window.location.href);
        };
        
        // Clear form data on page unload
        window.addEventListener('beforeunload', function() {
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