<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.List" %>
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
      <title>Coordinator Requests</title>
      <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
      <style>
          :root {
              --primary: #3498db;
              --primary-dark: #2980b9;
              --secondary: #e74c3c;
              --text-dark: #2c3e50;
              --text-light: #7f8c8d;
              --background: #f8f9fa;
              --white: #ffffff;
              --border: #dfe6e9;
              --shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
              --success: #27ae60;
              --error: #e74c3c;
              --warning: #f39c12;
              --pending: #f1c40f;
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
              color: var(--secondary);
              font-weight: 600;
          }

          nav a.active:after {
              content: '';
              position: absolute;
              bottom: 0;
              left: 0;
              width: 100%;
              height: 3px;
              background-color: var(--secondary);
          }

          .container {
              padding: 2.5rem;
              max-width: 1400px;
              margin: 0 auto;
          }

          h2 {
              color: var(--text-dark);
              margin-bottom: 1.75rem;
              font-weight: 600;
              display: flex;
              align-items: center;
              gap: 0.75rem;
              font-size: 1.75rem;
          }

          .alert {
              padding: 1rem 1.5rem;
              margin: 1.5rem 0;
              border-radius: 8px;
              background-color: #e8f5e9;
              color: var(--success);
              border-left: 4px solid var(--success);
              display: flex;
              align-items: center;
              gap: 1rem;
              font-weight: 500;
          }

          .alert.error {
              background-color: #fdecea;
              color: var(--error);
              border-left: 4px solid var(--error);
          }

          .requests-container {
              background-color: var(--white);
              padding: 2rem;
              border-radius: 10px;
              box-shadow: var(--shadow);
              margin-top: 1.5rem;
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
              background-color: rgba(52, 152, 219, 0.05);
          }

          .status-pending {
              color: var(--pending);
              font-weight: 600;
          }

          .status-approved {
              color: var(--success);
              font-weight: 600;
          }

          .status-rejected {
              color: var(--error);
              font-weight: 600;
          }

          .urgency-normal {
              color: var(--text-dark);
          }

          .urgency-urgent {
              color: var(--warning);
              font-weight: 600;
          }

          .action-buttons {
              display: flex;
              gap: 0.75rem;
          }

          .btn {
              padding: 0.5rem 1rem;
              border: none;
              border-radius: 6px;
              font-weight: 500;
              cursor: pointer;
              transition: all 0.3s ease;
              display: inline-flex;
              align-items: center;
              gap: 0.5rem;
          }

          .btn-approve {
              background-color: var(--success);
              color: white;
          }

          .btn-approve:hover {
              background-color: #219653;
              transform: translateY(-2px);
          }

          .btn-reject {
              background-color: var(--error);
              color: white;
          }

          .btn-reject:hover {
              background-color: #c0392b;
              transform: translateY(-2px);
          }

          .no-requests {
              text-align: center;
              padding: 3rem;
              color: var(--text-light);
          }

          .no-requests i {
              font-size: 3rem;
              margin-bottom: 1rem;
              color: var(--border);
          }

          @media (max-width: 768px) {
              nav {
                  gap: 1rem;
                  padding: 1rem;
              }

              .container {
                  padding: 1.5rem;
              }

              .requests-container {
                  padding: 1rem;
              }

              .action-buttons {
                  flex-direction: column;
                  gap: 0.5rem;
              }

              .btn {
                  width: 100%;
                  justify-content: center;
              }
          }
      </style>
  </head>
  <body>
      <header>
          <i class="fas fa-clipboard-list fa-lg"></i>
          <h1>Coordinator Requests</h1>
      </header>
      <nav>
          <a href="${pageContext.request.contextPath}/dashboard?role=hospital_coordinator">
              <i class="fas fa-tachometer-alt"></i> Dashboard
          </a>
          <a href="${pageContext.request.contextPath}/coordinator-request/" class="active">
              <i class="fas fa-tint"></i> Blood Requests
          </a>
          <a href="${pageContext.request.contextPath}/coordinator-stock/">
              <i class="fas fa-flask"></i> Blood Stock
          </a>
          <a href="${pageContext.request.contextPath}/coordinator-feedback/">
              <i class="fas fa-comment"></i> Hospital Feedbacks
          </a>
          <a href="${pageContext.request.contextPath}/logout">
              <i class="fas fa-sign-out-alt"></i> Logout
          </a>
      </nav>
      <div class="container">
          <h2><i class="fas fa-hourglass-half"></i> Pending Requests</h2>

          <c:if test="${not empty success}">
              <div class="alert">
                  <i class="fas fa-check-circle"></i> Request processed successfully!
              </div>
          </c:if>
          <c:if test="${not empty error}">
              <div class="alert error">
                  <i class="fas fa-exclamation-circle"></i> ${error}
              </div>
          </c:if>
          <c:if test="${param.success == 'approved'}">
              <div class="alert success">
                  <i class="fas fa-check-circle"></i> Blood request approved successfully!
              </div>
          </c:if>
          <c:if test="${param.success == 'rejected'}">
              <div class="alert success">
                  <i class="fas fa-times-circle"></i> Blood request rejected successfully!
              </div>
          </c:if>

          <div class="requests-container">
              <%
              Object reqs = request.getAttribute("requests");
              if (reqs == null) {
                  reqs = session.getAttribute("requests"); // Fallback to session
              }
              System.out.println("JSP Debug: requests object = " + (reqs != null ? reqs.getClass().getName() : "null") + ", size = " + (reqs instanceof List ? ((List)reqs).size() : "not a List"));
              %>
              <c:choose>
                  <c:when test="${not empty requests}">
                      <table>
                          <thead>
                              <tr>
                                  <th><i class="fas fa-id-card"></i> ID</th>
                                  <th><i class="fas fa-tint"></i> Blood Group</th>
                                  <th><i class="fas fa-flask"></i> Quantity</th>
                                  <th><i class="fas fa-clock"></i> Urgency</th>
                                  <th><i class="fas fa-info-circle"></i> Status</th>
                                  <th><i class="fas fa-cogs"></i> Actions</th>
                              </tr>
                          </thead>
                          <tbody>
                              <c:forEach var="request" items="${requests}">
                                  <tr>
                                      <td>${request.id}</td>
                                      <td>${request.bloodGroup}</td>
                                      <td>${request.quantity} units</td>
                                      <td class="urgency-${request.urgency.toLowerCase()}">
                                          <i class="fas fa-${request.urgency == 'URGENT' ? 'exclamation-triangle' : 'clock'}"></i>
                                          ${request.urgency}
                                      </td>
                                      <td class="status-${request.status.toLowerCase()}">
                                          <i class="fas fa-${request.status == 'APPROVED' ? 'check-circle' :
                                              (request.status == 'REJECTED' ? 'times-circle' : 'hourglass-half')}"></i>
                                          ${request.status}
                                      </td>
                                      <td>
                                          <div class="action-buttons">
                                              <form action="${pageContext.request.contextPath}/coordinator-request/approve" method="post" onsubmit="return confirm('Are you sure you want to approve this blood request? This will reduce the blood stock.')">
                                                  <input type="hidden" name="request_id" value="${request.id}">
                                                  <button type="submit" class="btn btn-approve">
                                                      <i class="fas fa-check"></i> Approve
                                                  </button>
                                              </form>
                                              <form action="${pageContext.request.contextPath}/coordinator-request/reject" method="post" onsubmit="return confirm('Are you sure you want to reject this blood request?')">
                                                  <input type="hidden" name="request_id" value="${request.id}">
                                                  <button type="submit" class="btn btn-reject">
                                                      <i class="fas fa-times"></i> Reject
                                                  </button>
                                              </form>
                                          </div>
                                      </td>
                                  </tr>
                              </c:forEach>
                          </tbody>
                      </table>
                  </c:when>
                  <c:otherwise>
                      <div class="no-requests">
                          <i class="fas fa-clipboard-list"></i>
                          <h3>No pending requests</h3>
                          <p>There are currently no blood requests awaiting approval</p>
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
    </script>
</body>
  </html>