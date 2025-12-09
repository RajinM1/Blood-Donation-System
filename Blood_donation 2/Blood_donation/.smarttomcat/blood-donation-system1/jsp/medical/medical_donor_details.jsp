<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Donor Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }

        header {
            background-color: #9c27b0;
            color: white;
            padding: 1rem;
            text-align: center;
        }

        nav {
            background-color: white;
            padding: 1rem;
            display: flex;
            justify-content: center;
            gap: 1rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        nav a {
            color: #333;
            text-decoration: none;
            padding: 0.5rem 1rem;
        }

        nav a:hover {
            color: #9c27b0;
        }

        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 1rem;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        h2 {
            color: #333;
            margin-bottom: 1rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        th, td {
            padding: 0.75rem;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }

        tr:hover {
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>
    <header>
        <h1>Donor Details</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/medical/dashboard">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/medical/blood-reports">
            <i class="fas fa-file-medical"></i> Blood Reports
        </a>
        <a href="${pageContext.request.contextPath}/medical/donors" class="active">
            <i class="fas fa-users"></i> Donors
        </a>
        <a href="${pageContext.request.contextPath}/medical/blood-stock">
            <i class="fas fa-boxes"></i> Blood Stock
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <!-- Statistics Banner -->
        <div class="stats-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-bottom: 2rem;">
            <div class="stat-card" style="background: white; padding: 1rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center;">
                <div style="font-size: 2rem; color: #3498db; margin-bottom: 0.5rem;">
                    <i class="fas fa-users"></i>
                </div>
                <div>
                    <h3 style="margin: 0; color: #2c3e50;">${donors.size()}</h3>
                    <p style="margin: 0; color: #7f8c8d;">Total Donors</p>
                </div>
            </div>
            <div class="stat-card" style="background: white; padding: 1rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center;">
                <div style="font-size: 2rem; color: #27ae60; margin-bottom: 0.5rem;">
                    <i class="fas fa-male"></i>
                </div>
                <div>
                    <h3 style="margin: 0; color: #2c3e50;">
                        <c:set var="maleCount" value="0" />
                        <c:forEach var="donor" items="${donors}">
                            <c:if test="${donor.gender == 'Male'}">
                                <c:set var="maleCount" value="${maleCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${maleCount}
                    </h3>
                    <p style="margin: 0; color: #7f8c8d;">Male Donors</p>
                </div>
            </div>
            <div class="stat-card" style="background: white; padding: 1rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center;">
                <div style="font-size: 2rem; color: #e91e63; margin-bottom: 0.5rem;">
                    <i class="fas fa-female"></i>
                </div>
                <div>
                    <h3 style="margin: 0; color: #2c3e50;">
                        <c:set var="femaleCount" value="0" />
                        <c:forEach var="donor" items="${donors}">
                            <c:if test="${donor.gender == 'Female'}">
                                <c:set var="femaleCount" value="${femaleCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${femaleCount}
                    </h3>
                    <p style="margin: 0; color: #7f8c8d;">Female Donors</p>
                </div>
            </div>
            <div class="stat-card" style="background: white; padding: 1rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center;">
                <div style="font-size: 2rem; color: #f39c12; margin-bottom: 0.5rem;">
                    <i class="fas fa-tint"></i>
                </div>
                <div>
                    <h3 style="margin: 0; color: #2c3e50;">
                        <c:set var="bloodGroupCount" value="0" />
                        <c:set var="uniqueGroups" value="" />
                        <c:forEach var="donor" items="${donors}">
                            <c:if test="${!fn:contains(uniqueGroups, donor.bloodGroup)}">
                                <c:set var="uniqueGroups" value="${uniqueGroups},${donor.bloodGroup}" />
                                <c:set var="bloodGroupCount" value="${bloodGroupCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${bloodGroupCount}
                    </h3>
                    <p style="margin: 0; color: #7f8c8d;">Blood Groups</p>
                </div>
            </div>
        </div>

        <h2><i class="fas fa-users"></i> Donor List</h2>
        <table>
            <tr>
                <th>Name</th>
                <th>Age</th>
                <th>Gender</th>
                <th>Blood Group</th>
                <th>Last Donation</th>
            </tr>
            <c:forEach var="donor" items="${donors}">
                <tr>
                    <td>${donor.name}</td>
                    <td>${donor.age}</td>
                    <td>${donor.gender}</td>
                    <td>${donor.bloodGroup}</td>
                    <td>${donor.lastDonationDate}</td>
                </tr>
            </c:forEach>
        </table>
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