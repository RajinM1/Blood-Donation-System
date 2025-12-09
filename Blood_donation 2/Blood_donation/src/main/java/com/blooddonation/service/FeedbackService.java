package com.blooddonation.service;

import com.blooddonation.dao.FeedbackDAO;
import com.blooddonation.model.Feedback;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

public class FeedbackService {
    
    private FeedbackDAO feedbackDAO;
    
    public FeedbackService() {
        this.feedbackDAO = new FeedbackDAO();
    }
    
    /**
     * Submit new feedback
     */
    public void submitFeedback(int userId, String feedbackText, String category) throws SQLException {
        if (feedbackText == null || feedbackText.trim().isEmpty()) {
            throw new IllegalArgumentException("Feedback text cannot be empty");
        }
        
        if (category == null || category.trim().isEmpty()) {
            category = "GENERAL";
        }
        
        Feedback feedback = new Feedback(userId, feedbackText, category);
        feedbackDAO.addFeedback(feedback);
    }
    
    /**
     * Respond to feedback
     */
    public void respondToFeedback(int feedbackId, int respondedBy, String response) throws SQLException {
        if (response == null || response.trim().isEmpty()) {
            throw new IllegalArgumentException("Response text cannot be empty");
        }
        
        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);
        if (feedback == null) {
            throw new IllegalArgumentException("Feedback not found");
        }
        
        if (!feedback.isPending()) {
            throw new IllegalArgumentException("Cannot respond to feedback that is not pending");
        }
        
        feedbackDAO.respondToFeedback(feedbackId, respondedBy, response);
    }
    
    /**
     * Escalate feedback to manager
     */
    public void escalateFeedback(int feedbackId, int managerId) throws SQLException {
        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);
        if (feedback == null) {
            throw new IllegalArgumentException("Feedback not found");
        }
        
        if (!feedback.isPending()) {
            throw new IllegalArgumentException("Cannot escalate feedback that is not pending");
        }
        
        feedbackDAO.escalateFeedback(feedbackId, managerId);
    }
    
    /**
     * Resolve feedback
     */
    public void resolveFeedback(int feedbackId, int resolvedBy) throws SQLException {
        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);
        if (feedback == null) {
            throw new IllegalArgumentException("Feedback not found");
        }
        
        if (feedback.isResolved()) {
            throw new IllegalArgumentException("Feedback is already resolved");
        }
        
        feedbackDAO.resolveFeedback(feedbackId, resolvedBy);
    }
    
    /**
     * Get all feedback
     */
    public List<Feedback> getAllFeedback() throws SQLException {
        return feedbackDAO.getAllFeedback();
    }
    
    /**
     * Get pending feedback
     */
    public List<Feedback> getPendingFeedback() throws SQLException {
        return feedbackDAO.getPendingFeedback();
    }
    
    /**
     * Get urgent feedback
     */
    public List<Feedback> getUrgentFeedback() throws SQLException {
        return feedbackDAO.getUrgentFeedback();
    }
    
    /**
     * Get feedback by user ID
     */
    public List<Feedback> getFeedbackByUserId(int userId) throws SQLException {
        return feedbackDAO.getFeedbackByUserId(userId);
    }
    
    /**
     * Get feedback by category
     */
    public List<Feedback> getFeedbackByCategory(String category) throws SQLException {
        return feedbackDAO.getFeedbackByCategory(category);
    }
    
    /**
     * Get feedback by status
     */
    public List<Feedback> getFeedbackByStatus(String status) throws SQLException {
        return feedbackDAO.getFeedbackByStatus(status);
    }
    
    /**
     * Get feedback by ID
     */
    public Feedback getFeedbackById(int feedbackId) throws SQLException {
        return feedbackDAO.getFeedbackById(feedbackId);
    }
    
    /**
     * Update feedback
     */
    public void updateFeedback(Feedback feedback) throws SQLException {
        if (feedback == null) {
            throw new IllegalArgumentException("Feedback cannot be null");
        }
        
        feedback.setUpdatedAt(new Date());
        feedbackDAO.updateFeedback(feedback);
    }
    
    /**
     * Delete feedback
     */
    public void deleteFeedback(int feedbackId) throws SQLException {
        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);
        if (feedback == null) {
            throw new IllegalArgumentException("Feedback not found");
        }
        
        feedbackDAO.deleteFeedback(feedbackId);
    }
    
    /**
     * Get pending feedback count
     */
    public int getPendingFeedbackCount() throws SQLException {
        return feedbackDAO.getPendingFeedbackCount();
    }
    
    /**
     * Get urgent feedback count
     */
    public int getUrgentFeedbackCount() throws SQLException {
        return feedbackDAO.getUrgentFeedbackCount();
    }
    
    /**
     * Get feedback statistics
     */
    public FeedbackStats getFeedbackStats() throws SQLException {
        FeedbackStats stats = new FeedbackStats();
        
        List<Feedback> allFeedback = feedbackDAO.getAllFeedback();
        
        int total = allFeedback.size();
        int pending = 0;
        int responded = 0;
        int escalated = 0;
        int resolved = 0;
        int urgent = 0;
        
        for (Feedback feedback : allFeedback) {
            if (feedback.isPending()) pending++;
            else if (feedback.isResponded()) responded++;
            else if (feedback.isEscalated()) escalated++;
            else if (feedback.isResolved()) resolved++;
            
            if (feedback.isUrgent()) urgent++;
        }
        
        stats.setTotalFeedback(total);
        stats.setPendingFeedback(pending);
        stats.setRespondedFeedback(responded);
        stats.setEscalatedFeedback(escalated);
        stats.setResolvedFeedback(resolved);
        stats.setUrgentFeedback(urgent);
        
        return stats;
    }
    
    /**
     * Inner class for feedback statistics
     */
    public static class FeedbackStats {
        private int totalFeedback;
        private int pendingFeedback;
        private int respondedFeedback;
        private int escalatedFeedback;
        private int resolvedFeedback;
        private int urgentFeedback;
        
        // Getters and setters
        public int getTotalFeedback() { return totalFeedback; }
        public void setTotalFeedback(int totalFeedback) { this.totalFeedback = totalFeedback; }
        
        public int getPendingFeedback() { return pendingFeedback; }
        public void setPendingFeedback(int pendingFeedback) { this.pendingFeedback = pendingFeedback; }
        
        public int getRespondedFeedback() { return respondedFeedback; }
        public void setRespondedFeedback(int respondedFeedback) { this.respondedFeedback = respondedFeedback; }
        
        public int getEscalatedFeedback() { return escalatedFeedback; }
        public void setEscalatedFeedback(int escalatedFeedback) { this.escalatedFeedback = escalatedFeedback; }
        
        public int getResolvedFeedback() { return resolvedFeedback; }
        public void setResolvedFeedback(int resolvedFeedback) { this.resolvedFeedback = resolvedFeedback; }
        
        public int getUrgentFeedback() { return urgentFeedback; }
        public void setUrgentFeedback(int urgentFeedback) { this.urgentFeedback = urgentFeedback; }
    }
}