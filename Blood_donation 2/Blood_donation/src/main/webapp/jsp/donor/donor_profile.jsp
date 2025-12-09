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
    <title>Donor Profile</title>
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
            position: sticky;
            top: 0;
            z-index: 100;
        }

        header i {
            font-size: 1.5rem;
        }

        nav {
            background-color: var(--white);
            padding: 0.9rem 2rem;
            display: flex;
            gap: 1.5rem;
            box-shadow: var(--shadow);
            overflow-x: auto;
            position: sticky;
            top: 60px;
            z-index: 90;
        }

        nav a {
            color: var(--text-medium);
            text-decoration: none;
            font-weight: 500;
            padding: 0.3rem 0;
            position: relative;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            white-space: nowrap;
            font-size: 0.95rem;
            transition: var(--transition);
        }

        nav a:hover {
            color: var(--primary);
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
            border-radius: 3px 3px 0 0;
        }

        .container {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        h1, h2 {
            font-weight: 600;
        }

        h2 {
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.5rem;
        }

        .alert {
            padding: 0.9rem 1.2rem;
            margin: 1rem 0;
            border-radius: var(--radius-sm);
            background-color: var(--error-light);
            color: var(--error);
            border-left: 4px solid var(--error);
            display: flex;
            align-items: center;
            gap: 0.8rem;
            font-size: 0.95rem;
        }

        .alert.success {
            background-color: var(--success-light);
            color: var(--success);
            border-left-color: var(--success);
        }

        .form-container {
            background-color: var(--white);
            padding: 2rem;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border: 1px solid var(--border-light);
            margin-top: 1rem;
            max-width: 800px;
            transition: var(--transition);
        }

        .form-container:hover {
            box-shadow: var(--shadow-hover);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-help {
            display: block;
            color: var(--text-light);
            font-size: 0.8rem;
            margin-top: 0.25rem;
            font-style: italic;
        }

        label {
            display: block;
            font-weight: 500;
            color: var(--text-medium);
            margin-bottom: 0.6rem;
            font-size: 0.95rem;
        }

        input[type="text"],
        input[type="number"],
        input[type="date"],
        input[type="email"],
        input[type="tel"],
        select,
        textarea {
            width: 100%;
            padding: 0.85rem;
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 0.95rem;
            transition: var(--transition);
            background-color: var(--white);
            color: var(--text-dark);
        }

        textarea {
            min-height: 120px;
            resize: vertical;
            line-height: 1.5;
        }

        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-light);
        }

        button {
            background-color: var(--primary);
            color: var(--white);
            border: none;
            padding: 0.9rem 1.8rem;
            border-radius: var(--radius-sm);
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.6rem;
            margin-top: 0.5rem;
        }

        button:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }

        button:active {
            transform: translateY(0);
        }

        .profile-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .profile-icon {
            font-size: 2rem;
            color: var(--primary);
            background-color: var(--primary-light);
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1.5rem;
            }

            .form-container {
                padding: 1.5rem;
            }

            nav {
                padding: 0.8rem 1rem;
                gap: 1rem;
            }

            nav a {
                font-size: 0.9rem;
            }
        }

        /* Details Grid Styles */
        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 1.5rem;
        }

        .detail-section {
            background: var(--background);
            padding: 1.5rem;
            border-radius: var(--radius);
            border: 1px solid var(--border-light);
        }

        .detail-section h4 {
            color: var(--primary);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.8rem 0;
            border-bottom: 1px solid var(--border-light);
        }

        .detail-item:last-child {
            border-bottom: none;
        }

        .detail-item label {
            font-weight: 600;
            color: var(--text-medium);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin: 0;
            flex: 1;
        }

        .detail-item span {
            color: var(--text-dark);
            font-weight: 500;
            text-align: right;
            flex: 1;
        }

        .blood-group {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.9rem;
        }

        .donation-count {
            background: var(--success);
            color: var(--white);
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.9rem;
        }

        .status-badge {
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.8rem;
            text-transform: uppercase;
        }

        .status-badge.approved {
            background: var(--success-light);
            color: var(--success);
        }

        .status-badge.pending {
            background: #fff3e0;
            color: #f57c00;
        }

        .status-badge.rejected {
            background: var(--error-light);
            color: var(--error);
        }

        .status-badge.suspended {
            background: #f3e5f5;
            color: #7b1fa2;
        }

        .no-data {
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .no-data i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: var(--text-light);
        }

        .no-data h3 {
            margin-bottom: 1rem;
            color: var(--text-medium);
        }

        /* Additional small screen adjustments */
        @media (max-width: 480px) {
            header {
                padding: 1rem;
            }

            nav {
                top: 56px;
            }

            .profile-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.8rem;
            }

            h2 {
                font-size: 1.3rem;
            }

            .details-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .detail-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .detail-item span {
                text-align: left;
            }
        }
    </style>
</head>
<body>
    <!-- The rest of your JSP body content remains exactly the same -->
    <header>
        <i class="fas fa-user-circle"></i>
        <h1>Donor Profile</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=donor">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/view/my-details" class="active">
            <i class="fas fa-user"></i> Profile
        </a>
        <a href="${pageContext.request.contextPath}/view/my-blood-reports">
            <i class="fas fa-file-medical"></i> Blood Report
        </a>
        <a href="${pageContext.request.contextPath}/donor-page/donation-history">
            <i class="fas fa-history"></i> Donation History
        </a>
        <a href="${pageContext.request.contextPath}/appointment-page">
            <i class="fas fa-calendar-check"></i> Appointments
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
        <!-- Success Message -->
        <c:if test="${not empty success}">
            <div class="alert success" style="margin-bottom: 2rem;">
                <i class="fas fa-check-circle"></i> Profile updated successfully!
            </div>
        </c:if>
        
        <div class="profile-header">
            <i class="fas fa-user-edit profile-icon"></i>
            <h2>Update Your Profile</h2>
        </div>

        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        <c:if test="${param.success == 'true'}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> Profile updated successfully!
            </div>
        </c:if>

        <!-- View Details Section -->
        <div class="form-container">
            <h3><i class="fas fa-user-circle"></i> My Personal Details</h3>
            <c:choose>
                <c:when test="${not empty donor}">
                    <div class="details-grid">
                        <div class="detail-section">
                            <h4><i class="fas fa-user"></i> Personal Information</h4>
                            <div class="detail-item">
                                <label><i class="fas fa-signature"></i> Full Name:</label>
                                <span>${donor.name != null ? donor.name : 'Not provided'}</span>
                            </div>
                            <div class="detail-item">
                                <label><i class="fas fa-birthday-cake"></i> Age:</label>
                                <span>${donor.age != null ? donor.age : 'Not provided'}</span>
                            </div>
                            <div class="detail-item">
                                <label><i class="fas fa-venus-mars"></i> Gender:</label>
                                <span>${donor.gender != null ? donor.gender : 'Not provided'}</span>
                            </div>
                            <div class="detail-item">
                                <label><i class="fas fa-tint"></i> Blood Group:</label>
                                <span class="blood-group">${donor.bloodGroup != null ? donor.bloodGroup : 'Not provided'}</span>
                            </div>
                        </div>

                        <div class="detail-section">
                            <h4><i class="fas fa-address-book"></i> Contact Information</h4>
                            <div class="detail-item">
                                <label><i class="fas fa-envelope"></i> Email:</label>
                                <span>${sessionScope.user.email}</span>
                            </div>
                        </div>

                        <div class="detail-section">
                            <h4><i class="fas fa-heartbeat"></i> Health Information</h4>
                            <div class="detail-item">
                                <label><i class="fas fa-weight"></i> Weight:</label>
                                <span>${donor.weight != null ? donor.weight : 'Not provided'} kg</span>
                            </div>
                            <div class="detail-item">
                                <label><i class="fas fa-heart"></i> Health Info:</label>
                                <span>${donor.healthInfo != null ? donor.healthInfo : 'None provided'}</span>
                            </div>
                        </div>

                        <div class="detail-section">
                            <h4><i class="fas fa-tint"></i> Donation Information</h4>
                            <div class="detail-item">
                                <label><i class="fas fa-calendar-alt"></i> Last Donation:</label>
                                <span>
                                    <c:choose>
                                        <c:when test="${donor.lastDonationDate != null}">
                                            <fmt:formatDate value="${donor.lastDonationDate}" pattern="MMM dd, yyyy" />
                                        </c:when>
                                        <c:otherwise>Never donated</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="detail-item">
                                <label><i class="fas fa-calendar-check"></i> Next Eligible:</label>
                                <span>
                                    <c:choose>
                                        <c:when test="${donor.lastDonationDate != null}">
                                            <fmt:formatDate value="${donor.nextEligibleDate}" pattern="MMM dd, yyyy" />
                                        </c:when>
                                        <c:otherwise>Available now</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="detail-item">
                                <label><i class="fas fa-check-circle"></i> Status:</label>
                                <span class="status-badge ${donor.status != null ? donor.status.toLowerCase() : 'pending'}">${donor.status != null ? donor.status : 'PENDING'}</span>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <i class="fas fa-user-slash"></i>
                        <h3>No Profile Found</h3>
                        <p>Your donor profile information is not available. Please contact support or try updating your profile.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Update Profile Section -->
        <div class="form-container" style="margin-top: 2rem;">
            <h3><i class="fas fa-user-edit"></i> Update Profile</h3>
            <form action="${pageContext.request.contextPath}/donor/update" method="post">
                <div class="form-group">
                    <label for="name"><i class="fas fa-signature"></i> Full Name:</label>
                    <input type="text" id="name" name="name" value="${donor.name != null ? donor.name : sessionScope.user.username}" required>
                </div>

                <div class="form-group">
                    <label for="age"><i class="fas fa-birthday-cake"></i> Age:</label>
                    <input type="number" id="age" name="age" value="${donor.age != null ? donor.age : ''}" required min="18" max="65">
                </div>

                <div class="form-group">
                    <label for="gender"><i class="fas fa-venus-mars"></i> Gender:</label>
                    <select id="gender" name="gender" required>
                        <option value="MALE" ${donor.gender == 'MALE' ? 'selected' : ''}>Male</option>
                        <option value="FEMALE" ${donor.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                        <option value="OTHER" ${donor.gender == 'OTHER' ? 'selected' : ''}>Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="blood_group"><i class="fas fa-tint"></i> Blood Group:</label>
                    <select id="blood_group" name="blood_group" required>
                        <option value="A+" ${donor.bloodGroup == 'A+' ? 'selected' : ''}>A+</option>
                        <option value="A-" ${donor.bloodGroup == 'A-' ? 'selected' : ''}>A-</option>
                        <option value="B+" ${donor.bloodGroup == 'B+' ? 'selected' : ''}>B+</option>
                        <option value="B-" ${donor.bloodGroup == 'B-' ? 'selected' : ''}>B-</option>
                        <option value="AB+" ${donor.bloodGroup == 'AB+' ? 'selected' : ''}>AB+</option>
                        <option value="AB-" ${donor.bloodGroup == 'AB-' ? 'selected' : ''}>AB-</option>
                        <option value="O+" ${donor.bloodGroup == 'O+' ? 'selected' : ''}>O+</option>
                        <option value="O-" ${donor.bloodGroup == 'O-' ? 'selected' : ''}>O-</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="health_info"><i class="fas fa-heartbeat"></i> Health Information:</label>
                    <textarea id="health_info" name="health_info" placeholder="Any relevant health conditions or medications...">${donor.healthInfo != null ? donor.healthInfo : ''}</textarea>
                </div>

                <div class="form-group">
                    <label for="weight"><i class="fas fa-weight"></i> Weight (kg):</label>
                    <input type="number" id="weight" name="weight" value="${donor.weight != null ? donor.weight : ''}" min="40" step="0.1" required>
                </div>

                <div class="form-group">
                    <label for="last_donation_date"><i class="fas fa-calendar-alt"></i> Last Donation Date:</label>
                    <input type="date" id="last_donation_date" name="last_donation_date" value="${donor.lastDonationDate != null ? donor.lastDonationDate : ''}" max="" onchange="validateLastDonationDate(this)">
                    <small class="form-help">Leave empty if you have never donated before</small>
                </div>

                <button type="submit">
                    <i class="fas fa-save"></i> Update Profile
                </button>
            </form>
        </div>
    </div>

    <script>
        // Set max date to today for last donation date
        document.addEventListener('DOMContentLoaded', function() {
            const lastDonationInput = document.getElementById('last_donation_date');
            if (lastDonationInput) {
                const today = new Date().toISOString().split('T')[0];
                lastDonationInput.setAttribute('max', today);
            }
        });

        // Validate last donation date
        function validateLastDonationDate(input) {
            const selectedDate = new Date(input.value);
            const today = new Date();
            const tenYearsAgo = new Date();
            tenYearsAgo.setFullYear(today.getFullYear() - 10);
            
            if (input.value) {
                if (selectedDate > today) {
                    input.setCustomValidity('Last donation date cannot be in the future');
                    input.reportValidity();
                    return false;
                } else if (selectedDate < tenYearsAgo) {
                    input.setCustomValidity('Last donation date must be within the last 10 years');
                    input.reportValidity();
                    return false;
                } else {
                    input.setCustomValidity('');
                    return true;
                }
            } else {
                input.setCustomValidity('');
                return true;
            }
        }

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