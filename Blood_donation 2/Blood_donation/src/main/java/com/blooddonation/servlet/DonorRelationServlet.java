package com.blooddonation.servlet;

import com.blooddonation.dao.*;
import com.blooddonation.model.*;
import com.blooddonation.service.NotificationService;
import com.blooddonation.util.DatabaseUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class DonorRelationServlet extends HttpServlet {
    private DonorDAO donorDAO;
    private DonationCampDAO campDAO;
    private NotificationDAO notificationDAO;
    private FeedbackDAO feedbackDAO;
    private NotificationService notificationService;

    public DonorRelationServlet() {
        this.donorDAO = new DonorDAO();
        this.campDAO = new DonationCampDAO();
        this.notificationDAO = new NotificationDAO();
        this.feedbackDAO = new FeedbackDAO();
        this.notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"DONOR_RELATION".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/dashboard";
        }

        try {
            switch (pathInfo) {
                case "/dashboard":
                    handleDashboard(request, response, user);
                    break;
                case "/communication":
                    handleCommunication(request, response, user);
                    break;
                case "/camp-management":
                    handleCampManagement(request, response, user);
                    break;
                case "/donor-messages":
                    handleDonorMessages(request, response, user);
                    break;
                case "/appointments":
                    // Redirect to the appointment servlet
                    response.sendRedirect(request.getContextPath() + "/donor-relation/appointments/");
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"DONOR_RELATION".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/dashboard";
        }

        try {
            switch (pathInfo) {
                case "/send-notification":
                    handleSendNotification(request, response, user);
                    break;
                case "/add-camp":
                    handleAddCamp(request, response, user);
                    break;
                case "/delete-camp":
                    handleDeleteCamp(request, response, user);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        try {
            // Get statistics for dashboard
            int totalDonors = donorDAO.getAllDonors().size();
            int totalCamps = campDAO.getDonationCampCount();
            int activeCamps = campDAO.getActiveDonationCampCount();
            int totalFeedback = feedbackDAO.getAllFeedback().size();
            int pendingFeedback = 0;
            int urgentFeedback = 0;
            
            // Count pending and urgent feedback
            for (Feedback feedback : feedbackDAO.getAllFeedback()) {
                if ("PENDING".equals(feedback.getStatus())) {
                    pendingFeedback++;
                }
                if (feedback.isUrgent()) {
                    urgentFeedback++;
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("totalDonors", totalDonors);
            request.setAttribute("totalCamps", totalCamps);
            request.setAttribute("activeCamps", activeCamps);
            request.setAttribute("totalFeedback", totalFeedback);
            request.setAttribute("pendingFeedback", pendingFeedback);
            request.setAttribute("urgentFeedback", urgentFeedback);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Set default values if there's an error
            request.setAttribute("totalDonors", 0);
            request.setAttribute("totalCamps", 0);
            request.setAttribute("activeCamps", 0);
            request.setAttribute("totalFeedback", 0);
            request.setAttribute("pendingFeedback", 0);
            request.setAttribute("urgentFeedback", 0);
        }
        
        request.getRequestDispatcher("/jsp/donor_relation/donor_relation_dashboard.jsp").forward(request, response);
    }

    private void handleCommunication(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        try {
            List<Donor> allDonors = donorDAO.getAllDonors();
            request.setAttribute("donors", allDonors);
            
            // Get communication statistics
            int totalDonors = allDonors.size();
            int totalNotifications = notificationDAO.getAllNotifications().size();
            int unreadNotifications = 0;
            
            // Count unread notifications
            for (Notification notification : notificationDAO.getAllNotifications()) {
                if (!notification.isRead()) {
                    unreadNotifications++;
                }
            }
            
            request.setAttribute("totalDonors", totalDonors);
            request.setAttribute("totalNotifications", totalNotifications);
            request.setAttribute("unreadNotifications", unreadNotifications);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("totalDonors", 0);
            request.setAttribute("totalNotifications", 0);
            request.setAttribute("unreadNotifications", 0);
        }
        
        request.getRequestDispatcher("/jsp/donor_relation/donor_relation_communication.jsp").forward(request, response);
    }

    private void handleCampManagement(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        try {
            List<DonationCamp> allCamps = campDAO.getAllDonationCamps();
            request.setAttribute("camps", allCamps);
            
            // Get camp statistics
            int totalCamps = campDAO.getDonationCampCount();
            int activeCamps = campDAO.getActiveDonationCampCount();
            int upcomingCamps = campDAO.getUpcomingDonationCampCount();
            int pastCamps = campDAO.getPastDonationCampCount();
            
            request.setAttribute("totalCamps", totalCamps);
            request.setAttribute("activeCamps", activeCamps);
            request.setAttribute("upcomingCamps", upcomingCamps);
            request.setAttribute("pastCamps", pastCamps);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("totalCamps", 0);
            request.setAttribute("activeCamps", 0);
            request.setAttribute("upcomingCamps", 0);
            request.setAttribute("pastCamps", 0);
        }
        
        request.getRequestDispatcher("/jsp/donor_relation/donor_relation_camp_management.jsp").forward(request, response);
    }

    private void handleDonorMessages(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        try {
            List<Feedback> allFeedback = feedbackDAO.getAllFeedback();
            List<Donor> allDonors = donorDAO.getAllDonors();
            
            request.setAttribute("feedback", allFeedback);
            request.setAttribute("donors", allDonors);
            
            // Get message statistics
            int totalMessages = allFeedback.size();
            int pendingMessages = 0;
            int urgentMessages = 0;
            int respondedMessages = 0;
            
            for (Feedback feedback : allFeedback) {
                if ("PENDING".equals(feedback.getStatus())) {
                    pendingMessages++;
                }
                if (feedback.isUrgent()) {
                    urgentMessages++;
                }
                if ("RESPONDED".equals(feedback.getStatus())) {
                    respondedMessages++;
                }
            }
            
            request.setAttribute("totalMessages", totalMessages);
            request.setAttribute("pendingMessages", pendingMessages);
            request.setAttribute("urgentMessages", urgentMessages);
            request.setAttribute("respondedMessages", respondedMessages);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("totalMessages", 0);
            request.setAttribute("pendingMessages", 0);
            request.setAttribute("urgentMessages", 0);
            request.setAttribute("respondedMessages", 0);
        }
        
        request.getRequestDispatcher("/jsp/donor_relation/donor_relation_messages.jsp").forward(request, response);
    }

    private void handleSendNotification(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        try {
            int userId = Integer.parseInt(request.getParameter("user_id"));
            String message = request.getParameter("message");
            String title = request.getParameter("title");
            
            if (title == null || title.trim().isEmpty()) {
                title = "Notification from Blood Donation System";
            }
            
            // Create notification
            Notification notification = new Notification();
            notification.setUserId(userId);
            notification.setTitle(title);
            notification.setMessage(message);
            notification.setType("SYSTEM");
            notification.setChannel("IN_APP");
            notification.setPriority("MEDIUM");
            notification.setRead(false);
            notification.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            
            // Save notification
            notificationDAO.addNotification(notification);
            
            response.sendRedirect(request.getContextPath() + "/donor-relation/communication?success=Notification sent successfully");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/donor-relation/communication?error=Invalid user ID");
        }
    }

    private void handleAddCamp(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        try {
            String campName = request.getParameter("camp_name");
            String campDateStr = request.getParameter("camp_date");
            String location = request.getParameter("location");
            
            // Parse date
            java.util.Date campDate = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(campDateStr);
            
            // Create donation camp
            DonationCamp camp = new DonationCamp();
            camp.setCampName(campName);
            camp.setCampDate(campDate);
            camp.setLocation(location);
            camp.setOrganizerId(user.getId());
            camp.setStatus("PLANNED");
            camp.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            
            // Save camp
            campDAO.addDonationCamp(camp);
            
            response.sendRedirect(request.getContextPath() + "/donor-relation/camp-management?success=Camp added successfully");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/donor-relation/camp-management?error=Error adding camp: " + e.getMessage());
        }
    }
    
    private void handleDeleteCamp(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        try {
            int campId = Integer.parseInt(request.getParameter("camp_id"));
            
            // Get camp details before deletion for confirmation
            DonationCamp camp = campDAO.getDonationCampById(campId);
            if (camp == null) {
                response.sendRedirect(request.getContextPath() + "/donor-relation/camp-management?error=Donation camp not found");
                return;
            }
            
            // Delete the donation camp
            campDAO.deleteDonationCamp(campId);
            response.sendRedirect(request.getContextPath() + "/donor-relation/camp-management?success=Donation camp deleted successfully");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/donor-relation/camp-management?error=Invalid camp ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/donor-relation/camp-management?error=Error deleting donation camp: " + e.getMessage());
        }
    }
}
