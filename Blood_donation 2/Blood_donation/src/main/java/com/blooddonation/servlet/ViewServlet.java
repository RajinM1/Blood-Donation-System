package com.blooddonation.servlet;

import com.blooddonation.service.DonorService;
import com.blooddonation.dao.BloodReportDAO;
import com.blooddonation.dao.DonorDAO;
import com.blooddonation.model.BloodReport;
import com.blooddonation.model.Donor;
import com.blooddonation.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class ViewServlet extends HttpServlet {
    
    private DonorService donorService;
    private BloodReportDAO bloodReportDAO;
    private DonorDAO donorDAO;
    
    public ViewServlet() {
        this.donorService = new DonorService();
        this.bloodReportDAO = new BloodReportDAO();
        this.donorDAO = new DonorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            switch (action) {
                case "/blood-report":
                    handleBloodReportView(request, response, user);
                    break;
                case "/donor-details":
                    handleDonorDetailsView(request, response, user);
                    break;
                case "/my-blood-reports":
                    handleMyBloodReportsView(request, response, user);
                    break;
                case "/submit-blood-report":
                    handleSubmitBloodReportView(request, response, user);
                    break;
                case "/my-details":
                    handleMyDetailsView(request, response, user);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading data: " + e.getMessage());
            request.getRequestDispatcher("/jsp/donor/donor_dashboard.jsp").forward(request, response);
        }
    }
    
    private void handleBloodReportView(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        String reportId = request.getParameter("id");
        if (reportId != null) {
            try {
                int id = Integer.parseInt(reportId);
                BloodReport report = bloodReportDAO.getBloodReportById(id);
                if (report != null) {
                    request.setAttribute("bloodReport", report);
                    request.getRequestDispatcher("/jsp/medical/medical_blood_report.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Blood report not found");
                    request.getRequestDispatcher("/jsp/medical/medical_dashboard.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid report ID");
                request.getRequestDispatcher("/jsp/medical/medical_dashboard.jsp").forward(request, response);
            }
        } else {
            // Show all blood reports for medical staff
            if ("MEDICAL_STAFF".equals(user.getRole())) {
                request.setAttribute("bloodReports", bloodReportDAO.getAllBloodReports());
                request.getRequestDispatcher("/jsp/medical/medical_blood_report.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            }
        }
    }
    
    private void handleDonorDetailsView(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        String donorId = request.getParameter("id");
        if (donorId != null) {
            try {
                int id = Integer.parseInt(donorId);
                Donor donor = donorDAO.getDonorById(id);
                if (donor != null) {
                    request.setAttribute("donor", donor);
                    request.getRequestDispatcher("/jsp/medical/medical_donor_details.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Donor not found");
                    request.getRequestDispatcher("/jsp/medical/medical_dashboard.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid donor ID");
                request.getRequestDispatcher("/jsp/medical/medical_dashboard.jsp").forward(request, response);
            }
        } else {
            // Show all donors for medical staff
            if ("MEDICAL_STAFF".equals(user.getRole())) {
                request.setAttribute("donors", donorDAO.getAllDonors());
                request.getRequestDispatcher("/jsp/medical/medical_donor_details.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            }
        }
    }
    
    private void handleMyBloodReportsView(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        // For donors to view their own blood reports
        if ("DONOR".equals(user.getRole())) {
            System.out.println("Loading blood reports for user: " + user.getUsername() + " (ID: " + user.getId() + ")");
            List<BloodReport> bloodReports = donorService.getDonorBloodReports(user.getId());
            System.out.println("Found " + bloodReports.size() + " blood reports");
            request.setAttribute("bloodReports", bloodReports);
            request.getRequestDispatcher("/jsp/donor/view_blood_reports.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
        }
    }
    
    private void handleMyDetailsView(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        // For donors to view their own details
        if ("DONOR".equals(user.getRole())) {
            Donor donor = donorService.getDonorByUserId(user.getId());
            if (donor != null) {
                request.setAttribute("donor", donor);
                // Pass success parameter to JSP
                String success = request.getParameter("success");
                if (success != null) {
                    request.setAttribute("success", success);
                }
                request.getRequestDispatcher("/jsp/donor/donor_profile.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Donor profile not found");
                request.getRequestDispatcher("/jsp/donor/donor_dashboard.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
        }
    }
    
    private void handleSubmitBloodReportView(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        // For donors to submit blood reports
        if ("DONOR".equals(user.getRole())) {
            request.getRequestDispatcher("/jsp/donor/submit_blood_report.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
        }
    }
}
