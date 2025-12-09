package com.blooddonation.servlet;

import com.blooddonation.service.FeedbackService;
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

public class AdminFeedbackServlet extends HttpServlet {
    private final FeedbackService feedbackService = new FeedbackService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"MANAGER".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String action = request.getPathInfo();
        
        try {
            if (action == null || action.equals("/")) {
                // Show all feedback
                List<Feedback> allFeedback = feedbackService.getAllFeedback();
                request.setAttribute("feedbacks", allFeedback);
                request.setAttribute("title", "All Feedback");
                request.getRequestDispatcher("/jsp/manager/manager_feedback.jsp").forward(request, response);
                
            } else if (action.equals("/pending")) {
                // Show pending feedback
                List<Feedback> pendingFeedback = feedbackService.getPendingFeedback();
                request.setAttribute("feedbacks", pendingFeedback);
                request.setAttribute("title", "Pending Feedback");
                request.getRequestDispatcher("/jsp/manager/manager_feedback.jsp").forward(request, response);
                
            } else if (action.equals("/urgent")) {
                // Show urgent feedback
                List<Feedback> urgentFeedback = feedbackService.getUrgentFeedback();
                request.setAttribute("feedbacks", urgentFeedback);
                request.setAttribute("title", "Urgent Feedback");
                request.getRequestDispatcher("/jsp/manager/manager_feedback.jsp").forward(request, response);
                
            } else if (action.equals("/resolved")) {
                // Show resolved feedback
                List<Feedback> resolvedFeedback = feedbackService.getFeedbackByStatus("RESOLVED");
                request.setAttribute("feedbacks", resolvedFeedback);
                request.setAttribute("title", "Resolved Feedback");
                request.getRequestDispatcher("/jsp/manager/manager_feedback.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving feedback: " + e.getMessage());
            request.getRequestDispatcher("/jsp/manager/manager_feedback.jsp").forward(request, response);
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
        if (!"MANAGER".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String action = request.getPathInfo();
        
        try {
            if (action.equals("/resolve")) {
                // Resolve feedback
                int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
                feedbackService.resolveFeedback(feedbackId, user.getId());
                response.sendRedirect(request.getContextPath() + "/admin-feedback?success=resolved");
                
            } else if (action.equals("/delete")) {
                // Delete feedback
                int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
                feedbackService.deleteFeedback(feedbackId);
                response.sendRedirect(request.getContextPath() + "/admin-feedback?success=deleted");
            }
            
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing feedback: " + e.getMessage());
            request.getRequestDispatcher("/jsp/manager/manager_feedback.jsp").forward(request, response);
        }
    }
}

