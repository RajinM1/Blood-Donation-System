package com.blooddonation.servlet;

import com.blooddonation.dao.FeedbackDAO;
import com.blooddonation.dao.UserDAO;
import com.blooddonation.model.Feedback;
import com.blooddonation.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class CoordinatorFeedbackServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.getRole().equalsIgnoreCase("hospital_coordinator")) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        UserDAO userDAO = new UserDAO();
        
        try {
            // Get all feedback from hospital users
            System.out.println("CoordinatorFeedbackServlet - Getting all feedback...");
            List<Feedback> allFeedback = feedbackDAO.getAllFeedback();
            System.out.println("CoordinatorFeedbackServlet - Total feedback count: " + (allFeedback != null ? allFeedback.size() : "null"));
            
            // Test database connection
            System.out.println("CoordinatorFeedbackServlet - Testing database connection...");
            try {
                com.blooddonation.util.DatabaseUtil.getConnection();
                System.out.println("CoordinatorFeedbackServlet - Database connection successful");
            } catch (Exception e) {
                System.out.println("CoordinatorFeedbackServlet - Database connection failed: " + e.getMessage());
            }
            
            System.out.println("CoordinatorFeedbackServlet - Getting all users...");
            List<User> allUsers = userDAO.getAllUsers();
            System.out.println("CoordinatorFeedbackServlet - Total users count: " + (allUsers != null ? allUsers.size() : "null"));
            
            // Filter feedback from hospital users only
            List<Feedback> hospitalFeedback = allFeedback.stream()
                    .filter(feedback -> allUsers.stream()
                            .anyMatch(u -> u.getId() == feedback.getUserId() && 
                                    u.getRole().equalsIgnoreCase("hospital")))
                    .toList();
            
            // Debug: If no hospital feedback, show all feedback for debugging
            if (hospitalFeedback.isEmpty()) {
                System.out.println("CoordinatorFeedbackServlet - No hospital feedback found, showing all feedback for debugging");
                hospitalFeedback = allFeedback;
            }
            
            System.out.println("CoordinatorFeedbackServlet - Hospital feedback count: " + (hospitalFeedback != null ? hospitalFeedback.size() : "null"));
            
            // Debug: Print user roles
            System.out.println("CoordinatorFeedbackServlet - User roles:");
            for (User u : allUsers) {
                System.out.println("User ID: " + u.getId() + ", Role: " + u.getRole() + ", Username: " + u.getUsername());
            }
            
            // Debug: Print feedback details
            System.out.println("CoordinatorFeedbackServlet - All feedback details:");
            for (Feedback f : allFeedback) {
                System.out.println("Feedback ID: " + f.getId() + ", User ID: " + f.getUserId() + ", Text: " + f.getFeedbackText());
            }
            
            request.setAttribute("feedbacks", hospitalFeedback);
            request.setAttribute("users", allUsers);
            request.getRequestDispatcher("/jsp/hospital_coordinator/hospital_coordinator_feedback.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving feedback: " + e.getMessage());
            request.getRequestDispatcher("/jsp/hospital_coordinator/hospital_coordinator_feedback.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.getRole().equalsIgnoreCase("hospital_coordinator")) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String action = request.getPathInfo();
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        
        try {
            if ("/update-status".equals(action)) {
                int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
                String newStatus = request.getParameter("status");
                String responseText = request.getParameter("response");
                
                feedbackDAO.updateFeedbackStatus(feedbackId, newStatus, responseText, user.getId());
                response.sendRedirect(request.getContextPath() + "/coordinator-feedback/?success=updated");
            } else if ("/send-message".equals(action)) {
                int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
                int userId = Integer.parseInt(request.getParameter("user_id"));
                String subject = request.getParameter("subject");
                String message = request.getParameter("message");
                
                // Create a notification for the hospital user
                com.blooddonation.dao.NotificationDAO notificationDAO = new com.blooddonation.dao.NotificationDAO();
                com.blooddonation.model.Notification notification = new com.blooddonation.model.Notification();
                notification.setUserId(userId);
                notification.setTitle("Message from Coordinator: " + subject);
                notification.setMessage(message);
                notification.setType("SYSTEM");
                notification.setChannel("IN_APP");
                notification.setPriority("MEDIUM");
                notification.setRead(false);
                notification.setCreatedAt(new java.util.Date());
                notification.setScheduledAt(new java.util.Date());
                
                notificationDAO.addNotification(notification);
                response.sendRedirect(request.getContextPath() + "/coordinator-feedback/?success=message_sent");
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating feedback: " + e.getMessage());
            doGet(request, response);
        }
    }
}
