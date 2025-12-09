package com.blooddonation.servlet;

import com.blooddonation.dao.UserDAO;
import com.blooddonation.dao.BloodStockDAO;
import com.blooddonation.dao.BloodRequestDAO;
import com.blooddonation.dao.DonationCampDAO;
import com.blooddonation.dao.BloodReportDAO;
import com.blooddonation.model.BloodReport;
import com.blooddonation.model.User;
import com.blooddonation.service.DashboardService;
import com.blooddonation.service.DonorService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

public class DashboardServlet extends HttpServlet {
    // Map simplified roles to full session roles
    private static final Map<String, String> ROLE_MAPPINGS = new HashMap<>();
    static {
        ROLE_MAPPINGS.put("manager", "manager");
        ROLE_MAPPINGS.put("donor", "donor");
        ROLE_MAPPINGS.put("medical", "medical_staff");
        ROLE_MAPPINGS.put("donor_relation", "donor_relation");
        ROLE_MAPPINGS.put("hospital_coordinator", "hospital_coordinator");
        ROLE_MAPPINGS.put("hospital", "hospital");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        String role = request.getParameter("role");

        // Debug output
        System.out.println("Session Role: " + user.getRole());
        System.out.println("URL Parameter Role: " + role);

        // Normalize session role
        String sessionRole = user.getRole().toLowerCase();
        String mappedRole = (role != null) ? ROLE_MAPPINGS.getOrDefault(role.toLowerCase(), null) : null;

        if (mappedRole == null || !mappedRole.equals(sessionRole)) {
            request.setAttribute("error", "Invalid role access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String dashboardJsp;
        switch (mappedRole) {
            case "manager":
                dashboardJsp = "/jsp/manager/manager_dashboard.jsp";
                break;
            case "donor":
                dashboardJsp = "/jsp/donor/donor_dashboard.jsp";
                break;
            case "medical_staff":
                dashboardJsp = "/jsp/medical/medical_dashboard.jsp";
                break;
            case "donor_relation":
                dashboardJsp = "/jsp/donor_relation/donor_relation_dashboard.jsp";
                break;
            case "hospital_coordinator":
                dashboardJsp = "/jsp/hospital_coordinator/hospital_coordinator_dashboard.jsp";
                break;
            case "hospital":
                dashboardJsp = "/jsp/hospital/hospital_dashboard.jsp";
                break;
            default:
                request.setAttribute("error", "Invalid role");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
        }

        if ("manager".equals(mappedRole)) {
            try {
                DashboardService dashboardService = new DashboardService();
                DashboardService.DashboardStats stats = dashboardService.getManagerDashboardStats();
                
                // Set real data for the dashboard
                request.setAttribute("totalUsers", stats.getTotalUsers());
                request.setAttribute("activeDonors", stats.getActiveDonors());
                request.setAttribute("totalBloodUnits", stats.getTotalBloodUnits());
                request.setAttribute("totalHospitals", stats.getTotalHospitals());
                request.setAttribute("pendingAppointments", stats.getPendingAppointments());
                request.setAttribute("pendingBloodRequests", stats.getPendingBloodRequests());
                request.setAttribute("pendingFeedback", stats.getPendingFeedback());
                request.setAttribute("urgentFeedback", stats.getUrgentFeedback());
                request.setAttribute("lowStockAlerts", stats.getLowStockAlerts());
                request.setAttribute("recentActivities", stats.getRecentActivities());
                request.setAttribute("bloodStockByGroup", stats.getBloodStockByGroup());
                request.setAttribute("monthlyStats", stats.getMonthlyStats());
                
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Error loading dashboard data: " + e.getMessage());
            }
        } else if ("hospital".equals(mappedRole)) {
            // Redirect to hospital servlet for proper dashboard handling
            response.sendRedirect(request.getContextPath() + "/hospital/dashboard");
            return;
        } else if ("hospital_coordinator".equals(mappedRole)) {
            try {
                BloodRequestDAO requestDAO = new BloodRequestDAO();
                BloodStockDAO stockDAO = new BloodStockDAO();
                request.setAttribute("requests", requestDAO.getAllBloodRequests());
                request.setAttribute("stocks", stockDAO.getAllBloodStock());
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Error loading data");
            }
        } else if ("donor_relation".equals(mappedRole)) {
            try {
                UserDAO userDAO = new UserDAO();
                DonationCampDAO campDAO = new DonationCampDAO();
                request.setAttribute("donors", userDAO.getAllDonors());
                request.setAttribute("camps", campDAO.getAllCamps());
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Error loading data");
            }
        } else if ("medical_staff".equals(mappedRole)) {
            try {
                UserDAO userDAO = new UserDAO();
                BloodReportDAO reportDAO = new BloodReportDAO();
                List<User> donors = userDAO.getAllDonors();
                List<BloodReport> allReports = new ArrayList<>();
                for (User donor : donors) {
                    allReports.addAll(reportDAO.getBloodReportsByDonorId(donor.getId()));
                }
                request.setAttribute("donors", donors);
                request.setAttribute("bloodReports", allReports);
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Error loading data");
            }
        } else if ("donor".equals(mappedRole)) {
            try {
                DonorService donorService = new DonorService();
                DonorService.DonorDashboardData dashboardData = donorService.getDonorDashboardData(user.getId());
                
                // Set real data for the donor dashboard
                request.setAttribute("donor", dashboardData.getDonor());
                request.setAttribute("totalDonations", dashboardData.getTotalDonations());
                request.setAttribute("lastDonationDate", dashboardData.getLastDonationDate());
                request.setAttribute("bloodGroup", dashboardData.getBloodGroup());
                request.setAttribute("status", dashboardData.getStatus());
                request.setAttribute("eligible", dashboardData.isEligible());
                request.setAttribute("nextEligibleDate", dashboardData.getNextEligibleDate());
                request.setAttribute("donorLevel", dashboardData.getDonorLevel());
                request.setAttribute("notifications", dashboardData.getNotifications());
                request.setAttribute("recentBloodReports", dashboardData.getRecentBloodReports());
                
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Error loading donor dashboard data: " + e.getMessage());
            }
        }

        request.getRequestDispatcher(dashboardJsp).forward(request, response);
    }
}