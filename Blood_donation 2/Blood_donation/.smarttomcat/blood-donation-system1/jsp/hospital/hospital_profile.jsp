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
    <title>Hospital Profile</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #e74c3c;
            --primary-dark: #c0392b;
            --primary-light: #ffebe9;
            --text-dark: #2c3e50;
            --text-medium: #34495e;
            --text-light: #7f8c8d;
            --background: #f5f7fa;
            --white: #ffffff;
            --border: #dfe6e9;
            --border-light: #ecf0f1;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --shadow-hover: 0 6px 16px rgba(0, 0, 0, 0.12);
            --success: #27ae60;
            --success-light: #e8f5e9;
            --error: #e74c3c;
            --error-light: #fdecea;
            --warning: #f39c12;
            --warning-light: #fef9e7;
            --radius: 8px;
            --radius-sm: 4px;
            --transition: all 0.3s ease;
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
            min-height: 100vh;
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
            transition: var(--transition);
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

        .profile-header {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 2rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: var(--white);
            box-shadow: var(--shadow);
        }

        .profile-info h1 {
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            font-size: 2rem;
            font-weight: 600;
        }

        .profile-info .hospital-type {
            background: var(--primary-light);
            color: var(--primary);
            padding: 0.3rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
            display: inline-block;
            margin-bottom: 1rem;
        }

        .profile-info .status-badge {
            padding: 0.3rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.8rem;
            text-transform: uppercase;
            display: inline-block;
        }

        .status-badge.active {
            background: var(--success-light);
            color: var(--success);
        }

        .status-badge.pending {
            background: var(--warning-light);
            color: var(--warning);
        }

        .status-badge.suspended {
            background: var(--error-light);
            color: var(--error);
        }

        .profile-actions {
            margin-left: auto;
            display: flex;
            gap: 1rem;
        }

        .btn {
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: var(--radius-sm);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: var(--primary);
            color: var(--white);
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: var(--white);
            color: var(--text-dark);
            border: 2px solid var(--border);
        }

        .btn-secondary:hover {
            background: var(--background);
            border-color: var(--primary);
        }

        .profile-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
        }

        .profile-section {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 2rem;
        }

        .section-title {
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            font-size: 1.3rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border-light);
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid var(--border-light);
        }

        .detail-item:last-child {
            border-bottom: none;
        }

        .detail-label {
            color: var(--text-medium);
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .detail-value {
            color: var(--text-dark);
            font-weight: 600;
            text-align: right;
            flex: 1;
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

        .full-width {
            grid-column: 1 / -1;
        }

        .contact-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem;
            background: var(--background);
            border-radius: var(--radius-sm);
        }

        .contact-item i {
            color: var(--primary);
            width: 20px;
        }

        .contact-item span {
            color: var(--text-dark);
            font-weight: 500;
        }

        @media (max-width: 768px) {
            .profile-header {
                flex-direction: column;
                text-align: center;
            }

            .profile-actions {
                margin-left: 0;
                margin-top: 1rem;
            }

            .profile-content {
                grid-template-columns: 1fr;
            }

            .contact-info {
                grid-template-columns: 1fr;
            }

            .detail-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .detail-value {
                text-align: left;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-hospital"></i>
        <h1>Hospital Profile</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/hospital/dashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/jsp/hospital/hospital_blood_request.jsp">
            <i class="fas fa-tint"></i> Blood Request
        </a>
        <a href="${pageContext.request.contextPath}/blood-request/history">
            <i class="fas fa-history"></i> Request History
        </a>
        <a href="${pageContext.request.contextPath}/feedback/hospital">
            <i class="fas fa-comment"></i> Feedback
        </a>
        <a href="${pageContext.request.contextPath}/hospital/profile" class="active">
            <i class="fas fa-user"></i> Profile
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
        <c:if test="${not empty error}">
            <div class="alert error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <div class="profile-header">
            <div class="profile-avatar">
                <i class="fas fa-hospital"></i>
            </div>
            <div class="profile-info">
                <h1>${hospital.hospitalName}</h1>
                <div class="hospital-type">${hospital.hospitalType}</div>
                <div class="status-badge ${hospital.status.toLowerCase()}">${hospital.status}</div>
            </div>
            <div class="profile-actions">
                <a href="${pageContext.request.contextPath}/hospital/profile/edit" class="btn btn-primary">
                    <i class="fas fa-edit"></i> Edit Profile
                </a>
            </div>
        </div>

        <div class="profile-content">
            <div class="profile-section">
                <h2 class="section-title">
                    <i class="fas fa-info-circle"></i> Basic Information
                </h2>
                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-hospital"></i> Hospital Name
                    </div>
                    <div class="detail-value">${hospital.hospitalName}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-building"></i> Hospital Type
                    </div>
                    <div class="detail-value">${hospital.hospitalType}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-certificate"></i> License Number
                    </div>
                    <div class="detail-value">${hospital.licenseNumber}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-file-alt"></i> Registration Number
                    </div>
                    <div class="detail-value">${hospital.registrationNumber}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-calendar"></i> Registration Date
                    </div>
                    <div class="detail-value">
                        <fmt:formatDate value="${hospital.createdAt}" pattern="MMM dd, yyyy" />
                    </div>
                </div>
            </div>

            <div class="profile-section">
                <h2 class="section-title">
                    <i class="fas fa-map-marker-alt"></i> Location Information
                </h2>
                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-map-pin"></i> Address
                    </div>
                    <div class="detail-value">${hospital.address}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-city"></i> City
                    </div>
                    <div class="detail-value">${hospital.city}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-map"></i> State
                    </div>
                    <div class="detail-value">${hospital.state}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-mail-bulk"></i> Postal Code
                    </div>
                    <div class="detail-value">${hospital.postalCode}</div>
                </div>
            </div>

            <div class="profile-section full-width">
                <h2 class="section-title">
                    <i class="fas fa-phone"></i> Contact Information
                </h2>
                <div class="contact-info">
                    <div class="contact-item">
                        <i class="fas fa-user-tie"></i>
                        <span>${hospital.contactPerson}</span>
                    </div>
                    <div class="contact-item">
                        <i class="fas fa-phone"></i>
                        <span>${hospital.contactPhone}</span>
                    </div>
                    <div class="contact-item">
                        <i class="fas fa-envelope"></i>
                        <span>${hospital.contactEmail}</span>
                    </div>
                    <div class="contact-item">
                        <i class="fas fa-user"></i>
                        <span>${sessionScope.user.username}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Prevent back button access after logout
        window.history.pushState(null, null, window.location.href);
        window.onpopstate = function(event) {
            window.history.pushState(null, null, window.location.href);
        };
    </script>
</body>
</html>
