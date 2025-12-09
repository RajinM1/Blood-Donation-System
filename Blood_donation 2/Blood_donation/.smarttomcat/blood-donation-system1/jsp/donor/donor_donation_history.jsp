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
    <title>Donation History</title>
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
        }

        td {
            padding: 0.8rem 1rem;
            border-bottom: 1px solid var(--border);
        }

        tr:hover {
            background-color: rgba(231, 76, 60, 0.05);
        }

        .status-completed {
            color: var(--success);
            font-weight: 500;
        }

        .status-pending {
            color: #f39c12;
            font-weight: 500;
        }

        .no-history {
            text-align: center;
            padding: 2rem;
            color: var(--text-light);
        }

        @media (max-width: 768px) {
            .history-container {
                padding: 1rem;
            }

            th, td {
                padding: 0.6rem;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-history"></i>
        <h1>Donation History</h1>
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
        <a href="${pageContext.request.contextPath}/appointment-page">
            <i class="fas fa-calendar-check"></i> Appointments
        </a>
        <a href="${pageContext.request.contextPath}/donor-page/donation-history" class="active">
            <i class="fas fa-history"></i> Donation History
        </a>
        <a href="${pageContext.request.contextPath}/jsp/donor/donor_eligibility.jsp">
            <i class="fas fa-clipboard-check"></i> Eligibility
        </a>
        <a href="${pageContext.request.contextPath}/donor-page/summary">
            <i class="fas fa-chart-pie"></i> Summary
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
        <h2><i class="fas fa-hand-holding-heart"></i> Your Donation History</h2>
        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        <div class="history-container">
            <c:choose>
                <c:when test="${not empty appointments}">
                    <table>
                        <thead>
                            <tr>
                                <th><i class="fas fa-calendar"></i> Date</th>
                                <th><i class="fas fa-clock"></i> Time</th>
                                <th><i class="fas fa-map-marker-alt"></i> Camp ID</th>
                                <th><i class="fas fa-info-circle"></i> Status</th>
                                <th><i class="fas fa-ellipsis-h"></i> Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="appointment" items="${appointments}">
                                <tr>
                                    <td>
                                        <fmt:formatDate value="${appointment.appointmentDate}" pattern="MMM dd, yyyy" />
                                    </td>
                                    <td>${appointment.timeSlot}</td>
                                    <td>#${appointment.campId}</td>
                                    <td class="status-${appointment.status.toLowerCase()}">
                                        <i class="fas fa-${appointment.status eq 'COMPLETED' ? 'check-circle' : appointment.status eq 'APPROVED' ? 'check' : appointment.status eq 'PENDING' ? 'clock' : appointment.status eq 'REJECTED' ? 'times-circle' : 'ban'}"></i> ${appointment.status}
                                    </td>
                                    <td>
                                        <c:if test="${appointment.status == 'PENDING' || appointment.status == 'APPROVED'}">
                                            <button onclick="cancelAppointment(${appointment.id})" class="btn-cancel"><i class="fas fa-times"></i> Cancel</button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-history">
                        <i class="fas fa-clipboard-list fa-3x" style="color: var(--text-light); margin-bottom: 1rem;"></i>
                        <h3>No donation history found</h3>
                        <p>Your donation records will appear here once you've made your first donation</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <script>
        async function cancelAppointment(id){
            if(!confirm('Cancel this appointment?')) return;
            try {
                const res = await fetch(`${window.location.origin}${'${pageContext.request.contextPath}'}\/donor\/appointment?appointment_id=`+id, { method: 'DELETE' });
                if(res.status === 204){
                    location.reload();
                } else {
                    alert('Unable to cancel. The appointment may no longer be cancellable.');
                }
            } catch(e){
                alert('Error cancelling appointment');
            }
        }
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