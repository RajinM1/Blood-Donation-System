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
    <title>Book Appointment</title>
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
            max-width: 600px;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            font-weight: 500;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        select, input[type="date"] {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        select:focus, input[type="date"]:focus {
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
        }

        button:hover {
            background-color: var(--primary-dark);
        }

        /* Appointment History Styles */
        .appointment-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            margin-top: 1rem;
        }

        .appointment-item {
            background: var(--background);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 1.5rem;
            transition: box-shadow 0.3s;
        }

        .appointment-item:hover {
            box-shadow: var(--shadow);
        }

        .appointment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            flex-wrap: wrap;
            gap: 0.5rem;
        }

        .appointment-date {
            color: var(--text-dark);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .appointment-status {
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            display: flex;
            align-items: center;
            gap: 0.5rem;
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
            background: #fce4ec;
            color: #c2185b;
        }

        .status-cancelled {
            background: #f3e5f5;
            color: #7b1fa2;
        }

        .appointment-details {
            color: var(--text-dark);
        }

        .appointment-details p {
            margin: 0.5rem 0;
        }

        .no-appointments {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .no-appointments h3 {
            margin-bottom: 1rem;
            color: var(--text-dark);
        }

        h3 {
            color: var(--primary);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        @media (max-width: 768px) {
            .form-container {
                padding: 1.5rem;
            }
            
            .appointment-header {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-calendar-plus"></i>
        <h1>Book Appointment</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=donor">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/view/my-details">
            <i class="fas fa-user"></i> Profile
        </a>
        <a href="${pageContext.request.contextPath}/view/my-blood-reports">
            <i class="fas fa-file-medical"></i> Blood Report
        </a>
        <a href="${pageContext.request.contextPath}/appointment-page" class="active">
            <i class="fas fa-calendar-check"></i> Appointments
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
        <h2><i class="fas fa-hand-holding-medical"></i> Schedule Donation Appointment</h2>
        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${param.error}
            </div>
        </c:if>
        
        <c:if test="${not empty param.success}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> Appointment booked successfully!
            </div>
        </c:if>
        <div class="form-container">
            <form action="${pageContext.request.contextPath}/appointment/book" method="post">
                <div class="form-group">
                    <label for="camp_id"><i class="fas fa-hospital"></i> Donation Camp:</label>
                    <select id="camp_id" name="camp_id" required>
                        <c:forEach var="camp" items="${camps}">
                            <option value="${camp.id}">${camp.campName} - ${camp.campDate} (${camp.location})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="appointment_date"><i class="fas fa-calendar-day"></i> Appointment Date:</label>
                    <input type="date" id="appointment_date" name="appointment_date" required>
                </div>
                <div class="form-group">
                    <label for="time_slot"><i class="fas fa-clock"></i> Time Slot:</label>
                    <select id="time_slot" name="time_slot" required>
                        <option value="">Select a time slot</option>
                        <c:forEach var="slot" items="${availableSlots}">
                            <option value="${slot}">${slot}</option>
                        </c:forEach>
                    </select>
                    <c:if test="${empty availableSlots}">
                        <div class="alert" style="margin-top: .6rem;">
                            <i class="fas fa-info-circle"></i> No slots available for the selected date.
                        </div>
                    </c:if>
                </div>
                <button type="submit">
                    <i class="fas fa-calendar-check"></i> Book Appointment
                </button>
            </form>
        </div>

        <!-- Appointment History Section -->
        <div class="form-container" style="margin-top: 2rem;">
            <h3><i class="fas fa-history"></i> Appointment History</h3>
            <c:choose>
                <c:when test="${not empty appointments}">
                    <div class="appointment-list">
                        <c:forEach var="appointment" items="${appointments}">
                            <div class="appointment-item">
                                <div class="appointment-header">
                                    <span class="appointment-date">
                                        <i class="fas fa-calendar"></i> 
                                        <fmt:formatDate value="${appointment.appointmentDate}" pattern="MMM dd, yyyy" />
                                    </span>
                                    <span class="appointment-status status-${appointment.status.toLowerCase()}">
                                        <i class="fas fa-${appointment.status eq 'PENDING' ? 'clock' : appointment.status eq 'APPROVED' ? 'check-circle' : appointment.status eq 'COMPLETED' ? 'check-double' : appointment.status eq 'REJECTED' ? 'times-circle' : 'ban'}"></i>
                                        ${appointment.status}
                                    </span>
                                </div>
                                <div class="appointment-details">
                                    <p><strong>Time:</strong> ${appointment.timeSlot}</p>
                                    <p><strong>Camp ID:</strong> ${appointment.campId}</p>
                                    <c:if test="${not empty appointment.notes}">
                                        <p><strong>Notes:</strong> ${appointment.notes}</p>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-appointments">
                        <i class="fas fa-calendar-times fa-3x" style="color: var(--text-light); margin-bottom: 1rem;"></i>
                        <h3>No appointments found</h3>
                        <p>Your appointment history will appear here</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <script>
        (function(){
            const dateInput = document.getElementById('appointment_date');
            const today = new Date();
            const yyyy = today.getFullYear();
            const mm = String(today.getMonth()+1).padStart(2,'0');
            const dd = String(today.getDate()+1).padStart(2,'0');
            dateInput.min = `${yyyy}-${mm}-${dd}`; // prevent past dates
        })();
    </script>

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