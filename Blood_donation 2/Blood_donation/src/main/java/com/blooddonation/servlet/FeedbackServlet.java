package com.blooddonation.servlet;

import com.blooddonation.service.FeedbackService;
import com.blooddonation.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

public class FeedbackServlet extends HttpServlet {
    private final FeedbackService feedbackService = new FeedbackService();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        System.out.println("FeedbackServlet doPost - Action: " + action);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("FeedbackServlet doPost - No session or user");
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        System.out.println("FeedbackServlet doPost - User role: " + user.getRole());

        try {
            if ("/submit".equals(action)) {
                System.out.println("FeedbackServlet doPost - Processing submit action");
                String feedbackText = request.getParameter("feedback_text");
                String category = request.getParameter("category");
                
                System.out.println("FeedbackServlet doPost - Feedback text: " + feedbackText);
                System.out.println("FeedbackServlet doPost - Category: " + category);
                
                if (feedbackText == null || feedbackText.trim().isEmpty()) {
                    System.out.println("FeedbackServlet doPost - Empty feedback text");
                    request.setAttribute("error", "Feedback text is required");
                    forwardToFeedbackPage(request, response, user);
                    return;
                }
                
                System.out.println("FeedbackServlet doPost - Submitting feedback");
                feedbackService.submitFeedback(user.getId(), feedbackText, category != null ? category : "GENERAL");
                
                // Redirect based on user role
                if (user.getRole().equalsIgnoreCase("hospital")) {
                    System.out.println("FeedbackServlet doPost - Redirecting to hospital feedback page");
                    response.sendRedirect(request.getContextPath() + "/feedback/hospital?success=true");
                } else {
                    System.out.println("FeedbackServlet doPost - Redirecting to donor feedback page");
                    response.sendRedirect(request.getContextPath() + "/donor-page/feedback?success=true");
                }
                
            } else if ("/respond".equals(action)) {
                // Officer response to feedback
                if (!isOfficer(user)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                
                int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
                String responseText = request.getParameter("response");
                
                if (responseText == null || responseText.trim().isEmpty()) {
                    request.setAttribute("error", "Response text is required");
                    forwardToOfficerPage(request, response);
                    return;
                }
                
                feedbackService.respondToFeedback(feedbackId, user.getId(), responseText);
                response.sendRedirect(request.getContextPath() + "/jsp/donor_relation/donor_relation_communication.jsp?success=true");
                
            } else if ("/escalate".equals(action)) {
                // Escalate feedback to manager
                if (!isOfficer(user)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                
                int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
                int managerId = Integer.parseInt(request.getParameter("manager_id"));
                
                feedbackService.escalateFeedback(feedbackId, managerId);
                response.sendRedirect(request.getContextPath() + "/jsp/donor_relation/donor_relation_communication.jsp?success=true");
                
            } else if ("/resolve".equals(action)) {
                // Resolve feedback
                if (!isManager(user)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                
                int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
                feedbackService.resolveFeedback(feedbackId, user.getId());
                response.sendRedirect(request.getContextPath() + "/jsp/manager/manager_dashboard.jsp?success=true");
            }
            
        } catch (SQLException | IllegalArgumentException e) {
            e.printStackTrace();
            System.out.println("FeedbackServlet doPost - Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error processing feedback: " + e.getMessage());
            forwardToFeedbackPage(request, response, user);
        }
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
            if ("/hospital".equals(action) && user.getRole().equalsIgnoreCase("hospital")) {
                // Hospital feedback page
                request.getRequestDispatcher("/jsp/hospital/hospital_feedback.jsp").forward(request, response);
                
            } else if ("/list".equals(action) && isOfficer(user)) {
                // Officer view of all feedback
                request.setAttribute("feedbacks", feedbackService.getAllFeedback());
                request.getRequestDispatcher("/jsp/donor_relation/donor_relation_communication.jsp").forward(request, response);
                
            } else if ("/pending".equals(action) && isOfficer(user)) {
                // Pending feedback for officer
                request.setAttribute("feedbacks", feedbackService.getPendingFeedback());
                request.getRequestDispatcher("/jsp/donor_relation/donor_relation_communication.jsp").forward(request, response);
                
            } else if ("/urgent".equals(action) && isOfficer(user)) {
                // Urgent feedback for officer
                request.setAttribute("feedbacks", feedbackService.getUrgentFeedback());
                request.getRequestDispatcher("/jsp/donor_relation/donor_relation_communication.jsp").forward(request, response);
            } else {
                // For other actions or non-officer users, redirect to appropriate feedback page
                String feedbackPage = getFeedbackPage(user);
                request.getRequestDispatcher(feedbackPage).forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving feedback");
            forwardToFeedbackPage(request, response, user);
        }
    }
    
    private boolean isOfficer(User user) {
        return "DONOR_RELATION".equals(user.getRole()) || "OFFICER".equals(user.getRole());
    }
    
    private boolean isManager(User user) {
        return "MANAGER".equals(user.getRole());
    }
    
    private String getFeedbackPage(User user) {
        return user.getRole().equals("HOSPITAL") 
            ? "/jsp/hospital/hospital_feedback.jsp"
            : "/jsp/donor/donor_feedback.jsp";
    }
    
    private void forwardToFeedbackPage(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        request.getRequestDispatcher(getFeedbackPage(user)).forward(request, response);
    }
    
    private void forwardToOfficerPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/donor_relation/donor_relation_communication.jsp").forward(request, response);
    }
}