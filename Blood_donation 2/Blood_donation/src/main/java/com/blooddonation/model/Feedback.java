package com.blooddonation.model;

import java.util.Date;

public class Feedback {
    private int id;
    private int userId;
    private String feedbackText;
    private String category; // GENERAL, COMPLAINT, SUGGESTION, URGENT
    private String status; // PENDING, RESPONDED, ESCALATED, RESOLVED
    private String response;
    private int respondedBy; // User ID who responded
    private Date responseDate;
    private boolean isUrgent;
    private Date createdAt;
    private Date updatedAt;

    // Constructors
    public Feedback() {}
    
    public Feedback(int userId, String feedbackText, String category) {
        this.userId = userId;
        this.feedbackText = feedbackText;
        this.category = category;
        this.status = "PENDING";
        this.isUrgent = "URGENT".equals(category);
        this.createdAt = new Date();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getFeedbackText() { return feedbackText; }
    public void setFeedbackText(String feedbackText) { this.feedbackText = feedbackText; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getResponse() { return response; }
    public void setResponse(String response) { this.response = response; }
    
    public int getRespondedBy() { return respondedBy; }
    public void setRespondedBy(int respondedBy) { this.respondedBy = respondedBy; }
    
    public Date getResponseDate() { return responseDate; }
    public void setResponseDate(Date responseDate) { this.responseDate = responseDate; }
    
    public boolean isUrgent() { return isUrgent; }
    public void setUrgent(boolean urgent) { isUrgent = urgent; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    // Business logic methods
    public boolean isPending() {
        return "PENDING".equals(status);
    }
    
    public boolean isResponded() {
        return "RESPONDED".equals(status);
    }
    
    public boolean isEscalated() {
        return "ESCALATED".equals(status);
    }
    
    public boolean isResolved() {
        return "RESOLVED".equals(status);
    }
    
    public boolean needsEscalation() {
        return isUrgent && isPending();
    }
}