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
    <title>Submit Blood Report</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
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

        .alert.success {
            background-color: #e8f5e8;
            color: var(--success);
            border-left-color: var(--success);
        }

        .form-container {
            background-color: var(--white);
            padding: 2rem;
            border-radius: 8px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
            margin-top: 1rem;
            max-width: 800px;
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

        input[type="number"] {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        input[type="number"]:focus {
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

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        @media (max-width: 768px) {
            .form-container {
                padding: 1.5rem;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-plus-circle"></i>
        <h1>Submit Blood Report</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=donor">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/view/my-details">
            <i class="fas fa-user"></i> Profile
        </a>
        <a href="${pageContext.request.contextPath}/view/my-blood-reports">
            <i class="fas fa-file-medical"></i> View Blood Reports
        </a>
        <a href="${pageContext.request.contextPath}/blood-report/submit" class="active">
            <i class="fas fa-plus-circle"></i> Submit Blood Report
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
        <h2><i class="fas fa-plus-circle"></i> Submit Your Blood Report</h2>
        
        <c:if test="${not empty error}">
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty param.success}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> Blood report submitted successfully!
            </div>
        </c:if>
        
        <div class="form-container">
            <form action="${pageContext.request.contextPath}/blood-report/submit" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label for="hemoglobin"><i class="fas fa-tint"></i> Hemoglobin (g/dL):</label>
                        <input type="number" id="hemoglobin" name="hemoglobin" step="0.1" min="0" max="20" required>
                    </div>
                    <div class="form-group">
                        <label for="rbc"><i class="fas fa-circle"></i> RBC (M/μL):</label>
                        <input type="number" id="rbc" name="rbc" step="0.01" min="0" max="10" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="hct"><i class="fas fa-percentage"></i> Hematocrit (%):</label>
                        <input type="number" id="hct" name="hct" step="0.1" min="0" max="60" required>
                    </div>
                    <div class="form-group">
                        <label for="mcv"><i class="fas fa-cube"></i> MCV (fL):</label>
                        <input type="number" id="mcv" name="mcv" step="0.1" min="0" max="120" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="mch"><i class="fas fa-weight"></i> MCH (pg):</label>
                        <input type="number" id="mch" name="mch" step="0.1" min="0" max="40" required>
                    </div>
                    <div class="form-group">
                        <label for="mchc"><i class="fas fa-concentration"></i> MCHC (g/dL):</label>
                        <input type="number" id="mchc" name="mchc" step="0.1" min="0" max="40" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="rdw"><i class="fas fa-chart-line"></i> RDW (%):</label>
                        <input type="number" id="rdw" name="rdw" step="0.1" min="0" max="20" required>
                    </div>
                    <div class="form-group">
                        <label for="wbc"><i class="fas fa-shield-alt"></i> WBC (K/μL):</label>
                        <input type="number" id="wbc" name="wbc" step="0.1" min="0" max="50" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="esr"><i class="fas fa-arrow-down"></i> ESR (mm/hr):</label>
                        <input type="number" id="esr" name="esr" step="0.1" min="0" max="100" required>
                    </div>
                    <div class="form-group">
                        <label for="plt"><i class="fas fa-dot-circle"></i> Platelets (K/μL):</label>
                        <input type="number" id="plt" name="plt" step="0.1" min="0" max="1000" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="gra"><i class="fas fa-circle"></i> Granulocytes (%):</label>
                        <input type="number" id="gra" name="gra" step="0.1" min="0" max="100" required>
                    </div>
                    <div class="form-group">
                        <label for="lym"><i class="fas fa-circle"></i> Lymphocytes (%):</label>
                        <input type="number" id="lym" name="lym" step="0.1" min="0" max="100" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="eos"><i class="fas fa-circle"></i> Eosinophils (%):</label>
                        <input type="number" id="eos" name="eos" step="0.1" min="0" max="20" required>
                    </div>
                    <div class="form-group">
                        <label for="bas"><i class="fas fa-circle"></i> Basophils (%):</label>
                        <input type="number" id="bas" name="bas" step="0.1" min="0" max="5" required>
                    </div>
                </div>
                
                <h3 style="margin: 2rem 0 1rem 0; color: var(--text-dark); border-top: 2px solid var(--border); padding-top: 1rem;">Additional Information</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="blood_pressure_systolic"><i class="fas fa-heartbeat"></i> Blood Pressure - Systolic (mmHg):</label>
                        <input type="number" id="blood_pressure_systolic" name="blood_pressure_systolic" min="60" max="250">
                    </div>
                    <div class="form-group">
                        <label for="blood_pressure_diastolic"><i class="fas fa-heartbeat"></i> Blood Pressure - Diastolic (mmHg):</label>
                        <input type="number" id="blood_pressure_diastolic" name="blood_pressure_diastolic" min="40" max="150">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="pulse_rate"><i class="fas fa-heart"></i> Pulse Rate (bpm):</label>
                        <input type="number" id="pulse_rate" name="pulse_rate" min="40" max="200">
                    </div>
                    <div class="form-group">
                        <label for="temperature"><i class="fas fa-thermometer-half"></i> Temperature (°C):</label>
                        <input type="number" id="temperature" name="temperature" step="0.1" min="35" max="42">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="weight_at_donation"><i class="fas fa-weight"></i> Weight at Donation (kg):</label>
                        <input type="number" id="weight_at_donation" name="weight_at_donation" step="0.1" min="40" max="200">
                    </div>
                    <div class="form-group">
                        <label for="donation_volume"><i class="fas fa-tint"></i> Donation Volume (ml):</label>
                        <input type="number" id="donation_volume" name="donation_volume" min="200" max="500">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="medical_staff_notes"><i class="fas fa-stethoscope"></i> Medical Staff Notes:</label>
                    <textarea id="medical_staff_notes" name="medical_staff_notes" rows="3" style="width: 100%; padding: 0.8rem; border: 1px solid var(--border); border-radius: 4px; font-size: 1rem; resize: vertical;" placeholder="Any additional notes from medical staff..."></textarea>
                </div>
                
                <button type="submit">
                    <i class="fas fa-save"></i> Submit Blood Report
                </button>
            </form>
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
