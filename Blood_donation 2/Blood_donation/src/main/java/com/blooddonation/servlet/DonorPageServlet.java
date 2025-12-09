package com.blooddonation.servlet;

import com.blooddonation.service.DonorService;
import com.blooddonation.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

public class DonorPageServlet extends HttpServlet {
    
    private DonorService donorService;
    
    public DonorPageServlet() {
        this.donorService = new DonorService();
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
        
        // Check if user is a donor
        if (!"DONOR".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            switch (action) {
                case "/summary":
                    handleSummaryPage(request, response, user);
                    break;
                case "/notifications":
                    handleNotificationsPage(request, response, user);
                    break;
                case "/donation-history":
                    handleDonationHistoryPage(request, response, user);
                    break;
                case "/feedback":
                    handleFeedbackPage(request, response, user);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading page data: " + e.getMessage());
            request.getRequestDispatcher("/jsp/donor/donor_dashboard.jsp").forward(request, response);
        }
    }
    
    private void handleSummaryPage(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        DonorService.DonorSummary summary = donorService.getDonorSummary(user.getId());
        request.setAttribute("summary", summary);
        request.setAttribute("donor", summary.getDonor());
        request.getRequestDispatcher("/jsp/donor/donor_summary.jsp").forward(request, response);
    }
    
    private void handleNotificationsPage(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        request.setAttribute("notifications", donorService.getDonorNotifications(user.getId()));
        request.setAttribute("camps", donorService.getUpcomingCamps());
        request.getRequestDispatcher("/jsp/donor/donor_notifications.jsp").forward(request, response);
    }
    
    private void handleDonationHistoryPage(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        request.setAttribute("appointments", donorService.getDonorDonationHistory(user.getId()));
        request.getRequestDispatcher("/jsp/donor/donor_donation_history.jsp").forward(request, response);
    }
    
    private void handleFeedbackPage(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        request.setAttribute("feedbacks", donorService.getDonorFeedback(user.getId()));
        request.getRequestDispatcher("/jsp/donor/donor_feedback.jsp").forward(request, response);
    }
}
