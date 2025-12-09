<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Donation Summary</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --primary:#e74c3c; --primary-dark:#c0392b; --text-dark:#2c3e50; --text-light:#7f8c8d; --background:#f9f9f9; --white:#ffffff; --border:#ecf0f1; --shadow:0 4px 6px rgba(0,0,0,0.1); --success:#27ae60; }
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
        body { background-color:var(--background); color:var(--text-dark); line-height:1.6; }
        header { background:linear-gradient(135deg,var(--primary),var(--primary-dark)); color:var(--white); padding:1.2rem 2rem; box-shadow:var(--shadow); display:flex; align-items:center; gap:.8rem; }
        nav { background-color:var(--white); padding:.9rem 2rem; display:flex; gap:1.5rem; box-shadow:var(--shadow); overflow-x:auto; }
        nav a { color:var(--text-dark); text-decoration:none; font-weight:500; padding:.3rem 0; position:relative; display:flex; align-items:center; gap:.5rem; white-space:nowrap; }
        nav a:hover { color:var(--primary); }
        nav a.active { color:var(--primary); }
        nav a.active:after { content:''; position:absolute; bottom:0; left:0; width:100%; height:3px; background-color:var(--primary); }
        .container { padding:2rem; max-width:1100px; margin:0 auto; }
        h2 { color:var(--text-dark); margin-bottom:1.2rem; display:flex; align-items:center; gap:.5rem; }
        .cards { display:grid; grid-template-columns: repeat(auto-fit, minmax(240px,1fr)); gap:1rem; margin-top:1rem; }
        .card { background:var(--white); border:1px solid var(--border); border-radius:8px; box-shadow:var(--shadow); padding:1.2rem; }
        .card h3 { font-size:1rem; color:var(--text-light); margin-bottom:.4rem; }
        .value { font-size:1.6rem; font-weight:600; color:var(--text-dark); }
        .note { font-size:.9rem; color:var(--text-light); margin-top:.4rem; }
        .actions { margin-top:1.2rem; display:flex; gap:.8rem; flex-wrap:wrap; }
        .btn { background:var(--primary); color:#fff; border:none; border-radius:4px; padding:.7rem 1rem; display:inline-flex; align-items:center; gap:.5rem; cursor:pointer; text-decoration:none; }
        .btn:hover { background:var(--primary-dark); }
    </style>
</head>
<body>
    <header>
        <i class="fas fa-chart-pie"></i>
        <h1>Donation Summary</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=donor"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/view/my-details"><i class="fas fa-user"></i> Profile</a>
        <a href="${pageContext.request.contextPath}/view/my-blood-reports"><i class="fas fa-file-medical"></i> Blood Report</a>
        <a href="${pageContext.request.contextPath}/donor-page/donation-history"><i class="fas fa-history"></i> Donation History</a>
        <a href="${pageContext.request.contextPath}/appointment-page"><i class="fas fa-calendar-check"></i> Appointments</a>
        <a href="${pageContext.request.contextPath}/jsp/donor/donor_eligibility.jsp"><i class="fas fa-clipboard-check"></i> Eligibility</a>
        <a href="${pageContext.request.contextPath}/donor-page/summary" class="active"><i class="fas fa-chart-pie"></i> Summary</a>
        <a href="${pageContext.request.contextPath}/donor-page/feedback"><i class="fas fa-comment"></i> Feedback</a>
        <a href="${pageContext.request.contextPath}/donor-page/notifications"><i class="fas fa-bell"></i> Notifications</a>
        <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>
    <div class="container">
        <c:set var="totalDonationsCount" value="${summary.totalDonations != null ? summary.totalDonations : 0}" />
        <c:set var="lastDonationStr" value="${summary.lastDonationDate != null ? summary.lastDonationDate : (not empty donor.lastDonationDate ? donor.lastDonationDate : '')}" />
        <h2><i class="fas fa-hand-holding-heart"></i> Your Donation at a Glance</h2>
        <div class="cards">
            <div class="card">
                <h3>Total Donations</h3>
                <div class="value">${totalDonationsCount}</div>
                <div class="note">Completed donations recorded</div>
            </div>
            <div class="card">
                <h3>Last Donation Date</h3>
                <div class="value">${summary.lastDonationDate != null ? summary.lastDonationDate : (not empty donor.lastDonationDate ? donor.lastDonationDate : 'N/A')}</div>
                <div class="note">Based on your records</div>
            </div>
            <div class="card">
                <h3>Next Eligible</h3>
                <div class="value" id="nextEligible">Calculating...</div>
                <div class="note">3-month interval policy</div>
            </div>
            <div class="card">
                <h3>Blood Group</h3>
                <div class="value">${donor.bloodGroup != null ? donor.bloodGroup : sessionScope.user.bloodGroup}</div>
                <div class="note">From your profile</div>
            </div>
        </div>
        <div class="actions">
            <a class="btn" href="${pageContext.request.contextPath}/appointment-page"><i class="fas fa-calendar-plus"></i> Book Appointment</a>
            <a class="btn" href="${pageContext.request.contextPath}/jsp/donor/donor_eligibility.jsp"><i class="fas fa-clipboard-check"></i> Check Eligibility</a>
            <a class="btn" href="${pageContext.request.contextPath}/donor-page/donation-history"><i class="fas fa-list"></i> View History</a>
        </div>
    </div>
    <script>
        (function(){
            function addDays(date, days){ const d = new Date(date.getTime()); d.setDate(d.getDate()+days); return d; }
            function fmt(d){ const y=d.getFullYear(), m=String(d.getMonth()+1).padStart(2,'0'), dd=String(d.getDate()).padStart(2,'0'); return y+'-'+m+'-'+dd; }
            var last = '${lastDonationStr}';
            var el = document.getElementById('nextEligible');
            if(!last){ el.textContent = 'N/A'; return; }
            var lastDate = new Date(last);
            if(isNaN(lastDate.getTime())){ el.textContent = 'N/A'; return; }
            var next = addDays(lastDate, 90);
            el.textContent = fmt(next);
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

