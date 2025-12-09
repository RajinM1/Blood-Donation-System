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
    <title>Check Eligibility</title>
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
            --success: #27ae60;
            --warning: #f39c12;
            --error: #e74c3c;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background-color: var(--background); color: var(--text-dark); line-height: 1.6; }
        header { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: var(--white); padding: 1.2rem 2rem; box-shadow: var(--shadow); display: flex; align-items: center; gap: 0.8rem; }
        nav { background-color: var(--white); padding: 0.9rem 2rem; display: flex; gap: 1.5rem; box-shadow: var(--shadow); overflow-x: auto; }
        nav a { color: var(--text-dark); text-decoration: none; font-weight: 500; padding: 0.3rem 0; position: relative; display: flex; align-items: center; gap: 0.5rem; white-space: nowrap; }
        nav a:hover { color: var(--primary); }
        nav a.active { color: var(--primary); }
        nav a.active:after { content: ''; position: absolute; bottom: 0; left: 0; width: 100%; height: 3px; background-color: var(--primary); }
        .container { padding: 2rem; max-width: 900px; margin: 0 auto; }
        h2 { color: var(--text-dark); margin-bottom: 1.2rem; display: flex; align-items: center; gap: 0.5rem; }
        .form-container { background-color: var(--white); padding: 2rem; border-radius: 8px; box-shadow: var(--shadow); border: 1px solid var(--border); margin-top: 1rem; }
        .form-group { margin-bottom: 1.2rem; }
        label { display: block; font-weight: 500; color: var(--text-dark); margin-bottom: 0.5rem; }
        input[type="date"] { width: 100%; padding: 0.8rem; border: 1px solid var(--border); border-radius: 4px; font-size: 1rem; }
        button { background-color: var(--primary); color: var(--white); border: none; padding: 0.85rem 1.4rem; border-radius: 4px; font-size: 1rem; font-weight: 500; cursor: pointer; display: inline-flex; align-items: center; gap: 0.5rem; }
        button:hover { background-color: var(--primary-dark); }
        .result { margin-top: 1.2rem; padding: 1rem; border-radius: 6px; border-left: 4px solid; }
        .eligible { background: #e8f5e9; color: var(--success); border-left-color: var(--success); }
        .not-eligible { background: #fff7e6; color: var(--warning); border-left-color: var(--warning); }
        .error { background: #fdecea; color: var(--error); border-left-color: var(--error); }
        .meta { color: var(--text-light); font-size: 0.92rem; margin-top: 0.5rem; }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-check-circle"></i>
        <h1>Check Donation Eligibility</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=donor"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/view/my-details"><i class="fas fa-user"></i> Profile</a>
        <a href="${pageContext.request.contextPath}/view/my-blood-reports"><i class="fas fa-file-medical"></i> Blood Report</a>
        <a href="${pageContext.request.contextPath}/donor-page/donation-history"><i class="fas fa-history"></i> Donation History</a>
        <a href="${pageContext.request.contextPath}/appointment-page"><i class="fas fa-calendar-check"></i> Appointments</a>
        <a href="${pageContext.request.contextPath}/jsp/donor/donor_eligibility.jsp" class="active"><i class="fas fa-clipboard-check"></i> Eligibility</a>
        <a href="${pageContext.request.contextPath}/donor-page/summary"><i class="fas fa-chart-pie"></i> Summary</a>
        <a href="${pageContext.request.contextPath}/donor-page/feedback"><i class="fas fa-comment"></i> Feedback</a>
        <a href="${pageContext.request.contextPath}/donor-page/notifications"><i class="fas fa-bell"></i> Notifications</a>
        <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>
    <div class="container">
        <h2><i class="fas fa-clipboard-check"></i> Manual Eligibility Check</h2>
        <div class="form-container">
            <form onsubmit="event.preventDefault(); checkEligibility();">
                <div class="form-group">
                    <label for="lastDonation">Last Donation Date</label>
                    <input type="date" id="lastDonation" name="lastDonation" value="${donor.lastDonationDate != null ? donor.lastDonationDate : ''}" required>
                    <div class="meta">Requirement: Minimum 3 months (90 days) between donations.</div>
                </div>
                <button type="submit"><i class="fas fa-calculator"></i> Check</button>
            </form>
            <div id="eligibilityResult" class="result" style="display:none"></div>
        </div>
    </div>
    <script>
        function daysBetween(date1, date2){
            const msPerDay = 24*60*60*1000;
            const utc1 = Date.UTC(date1.getFullYear(), date1.getMonth(), date1.getDate());
            const utc2 = Date.UTC(date2.getFullYear(), date2.getMonth(), date2.getDate());
            return Math.floor((utc2 - utc1) / msPerDay);
        }

        function checkEligibility(){
            const input = document.getElementById('lastDonation').value;
            const resultEl = document.getElementById('eligibilityResult');
            if(!input){
                resultEl.className = 'result error';
                resultEl.style.display = 'block';
                resultEl.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Please select last donation date.';
                return;
            }
            const last = new Date(input);
            const today = new Date();
            const diffDays = daysBetween(last, today);
            const needed = 90; // approx 3 months
            if (diffDays >= needed){
                resultEl.className = 'result eligible';
                resultEl.style.display = 'block';
                resultEl.innerHTML = '<i class="fas fa-check-circle"></i> Eligible to donate now. ('+diffDays+' days since last donation)';
            } else if (diffDays < 0) {
                resultEl.className = 'result error';
                resultEl.style.display = 'block';
                resultEl.innerHTML = '<i class="fas fa-times-circle"></i> Last donation date cannot be in the future.';
            } else {
                const remaining = needed - diffDays;
                const nextDate = new Date(last.getTime() + needed*24*60*60*1000);
                const y = nextDate.getFullYear();
                const m = String(nextDate.getMonth()+1).padStart(2, '0');
                const d = String(nextDate.getDate()).padStart(2, '0');
                resultEl.className = 'result not-eligible';
                resultEl.style.display = 'block';
                resultEl.innerHTML = '<i class="fas fa-hourglass-half"></i> Not eligible yet. Wait '+remaining+' days. Next eligible on '+y+'-'+m+'-'+d+'.';
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









