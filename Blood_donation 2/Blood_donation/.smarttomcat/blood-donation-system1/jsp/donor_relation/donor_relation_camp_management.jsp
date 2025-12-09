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
    <title>Camp Management</title>
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
            gap: 1rem;
        }

        nav {
            background-color: var(--white);
            padding: 1rem 2rem;
            display: flex;
            gap: 2rem;
            box-shadow: var(--shadow);
            border-top: 3px solid var(--secondary);
        }

        nav a {
            color: var(--text-dark);
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 0;
            position: relative;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            white-space: nowrap;
            transition: all 0.3s ease;
        }

        nav a:hover {
            color: var(--primary);
            transform: translateY(-2px);
        }

        nav a.active {
            color: var(--primary);
            font-weight: 600;
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
            padding: 2.5rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        h2 {
            color: var(--text-dark);
            margin: 2rem 0 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert {
            padding: 1rem 1.5rem;
            margin: 1.5rem 0;
            border-radius: 8px;
            background-color: #fdecea;
            color: var(--error);
            border-left: 4px solid var(--error);
            display: flex;
            align-items: center;
            gap: 1rem;
            font-weight: 500;
        }

        .alert.success {
            background-color: #d4edda;
            color: #155724;
            border-left-color: #c3e6cb;
        }

        .form-container {
            background-color: var(--white);
            padding: 2rem;
            border-radius: 10px;
            box-shadow: var(--shadow);
            margin-bottom: 3rem;
            max-width: 600px;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            font-weight: 500;
            color: var(--text-dark);
            margin-bottom: 0.75rem;
        }

        input[type="text"], input[type="date"] {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(156, 39, 176, 0.2);
        }

        button {
            background-color: var(--primary);
            color: var(--white);
            border: none;
            padding: 0.8rem 1.75rem;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
        }

        button:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .camps-container {
            background-color: var(--white);
            padding: 2rem;
            border-radius: 10px;
            box-shadow: var(--shadow);
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
            padding: 1.25rem 1rem;
            text-align: left;
            font-weight: 500;
            position: sticky;
            top: 0;
        }

        td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }

        tr:hover {
            background-color: rgba(156, 39, 176, 0.05);
        }

        .upcoming {
            color: var(--success);
            font-weight: 500;
        }

        .past {
            color: var(--text-light);
        }

        .no-camps {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .no-camps i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--border);
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
        
        @keyframes slideIn {
            from { 
                opacity: 0;
                transform: translateY(-20px);
            }
            to { 
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
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
        
        .stat-card.total {
            border-left-color: #9c27b0;
        }
        
        .stat-card.active {
            border-left-color: #4caf50;
        }
        
        .stat-card.upcoming {
            border-left-color: #2196f3;
        }
        
        .stat-card.past {
            border-left-color: #ff9800;
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: var(--primary);
        }
        
        .stat-card.total .stat-icon {
            color: #9c27b0;
        }
        
        .stat-card.active .stat-icon {
            color: #4caf50;
        }
        
        .stat-card.upcoming .stat-icon {
            color: #2196f3;
        }
        
        .stat-card.past .stat-icon {
            color: #ff9800;
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

        @media (max-width: 768px) {
            nav {
                gap: 1rem;
                padding: 1rem;
            }

            .container {
                padding: 1.5rem;
            }

            .form-container, .camps-container {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-medkit fa-lg"></i>
        <h1>Donation Camp Management</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/donor-relation/dashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/communication">
            <i class="fas fa-comments"></i> Communication
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/camp-management" class="active">
            <i class="fas fa-medkit"></i> Camp Management
        </a>
        <a href="${pageContext.request.contextPath}/donor-relation/donor-messages">
            <i class="fas fa-envelope"></i> View Messages
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <h2><i class="fas fa-plus-circle"></i> Add New Donation Camp</h2>

        <!-- Statistics Banner -->
        <div class="stats-grid">
            <div class="stat-card total">
                <i class="fas fa-hospital stat-icon"></i>
                <div class="stat-number">${totalCamps}</div>
                <div class="stat-label">Total Camps</div>
            </div>
            <div class="stat-card active">
                <i class="fas fa-play-circle stat-icon"></i>
                <div class="stat-number">${activeCamps}</div>
                <div class="stat-label">Active Camps</div>
            </div>
            <div class="stat-card upcoming">
                <i class="fas fa-calendar-plus stat-icon"></i>
                <div class="stat-number">${upcomingCamps}</div>
                <div class="stat-label">Upcoming Camps</div>
            </div>
            <div class="stat-card past">
                <i class="fas fa-history stat-icon"></i>
                <div class="stat-number">${pastCamps}</div>
                <div class="stat-label">Past Camps</div>
            </div>
        </div>

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
            <form action="${pageContext.request.contextPath}/donor-relation/add-camp" method="post">
                <div class="form-group">
                    <label for="camp_name"><i class="fas fa-hospital"></i> Camp Name:</label>
                    <input type="text" id="camp_name" name="camp_name" placeholder="Enter camp name" required>
                </div>

                <div class="form-group">
                    <label for="camp_date"><i class="fas fa-calendar-day"></i> Date:</label>
                    <input type="date" id="camp_date" name="camp_date" required>
                </div>

                <div class="form-group">
                    <label for="location"><i class="fas fa-map-marker-alt"></i> Location:</label>
                    <input type="text" id="location" name="location" placeholder="Enter camp location" required>
                </div>

                <button type="submit">
                    <i class="fas fa-save"></i> Add Camp
                </button>
            </form>
        </div>

        <h2><i class="fas fa-list-ul"></i> Existing Donation Camps</h2>

        <div class="camps-container">
            <c:choose>
                <c:when test="${not empty camps}">
                    <table>
                        <thead>
                            <tr>
                                <th><i class="fas fa-hospital"></i> Camp Name</th>
                                <th><i class="fas fa-calendar-day"></i> Date</th>
                                <th><i class="fas fa-map-marker-alt"></i> Location</th>
                                <th><i class="fas fa-cogs"></i> Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="camp" items="${camps}">
                                <tr class="${camp.upcoming ? 'upcoming' : 'past'}">
                                    <td>${camp.campName}</td>
                                    <td>
                                        <i class="fas fa-calendar-day"></i>
                                        <fmt:formatDate value="${camp.campDate}" pattern="MMM dd, yyyy" />
                                    </td>
                                    <td>${camp.location}</td>
                                    <td>
                                        <button class="btn-delete" onclick="confirmDelete(${camp.id}, '${camp.campName}', '${camp.location}')" 
                                                title="Delete Donation Camp">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-camps">
                        <i class="fas fa-medkit"></i>
                        <h3>No donation camps scheduled</h3>
                        <p>Add a new donation camp using the form above</p>
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
        
        // Delete confirmation function
        function confirmDelete(campId, campName, location) {
            const message = `Are you sure you want to delete this donation camp?\n\n` +
                          `Camp Name: ${campName}\n` +
                          `Location: ${location}\n\n` +
                          `This action cannot be undone.`;
            
            if (confirm(message)) {
                // Create a form to submit the delete request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/donor-relation/delete-camp';
                
                const campIdInput = document.createElement('input');
                campIdInput.type = 'hidden';
                campIdInput.name = 'camp_id';
                campIdInput.value = campId;
                
                form.appendChild(campIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>