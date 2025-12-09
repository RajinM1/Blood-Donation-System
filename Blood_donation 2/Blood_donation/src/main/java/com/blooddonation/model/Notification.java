package com.blooddonation.model;

import java.util.Date;

public class Notification {
    private int id;
    private int userId; // Can be donor, hospital, or other user
    private String title;
    private String message;
    private String type; // APPOINTMENT, ALERT, REMINDER, CONFIRMATION, REJECTION
    private String status; // UNREAD, READ, SENT, FAILED
    private String channel; // EMAIL, SMS, IN_APP
    private String priority; // LOW, MEDIUM, HIGH, URGENT
    private boolean isRead;
    private Date scheduledAt;
    private Date sentAt;
    private Date readAt;
    private Date expiresAt;
    private String actionUrl;
    private String errorMessage;
    private int retryCount;
    private Date createdAt;
    private Date updatedAt;

    // Constructors
    public Notification() {
        this.status = "UNREAD";
        this.priority = "MEDIUM";
        this.retryCount = 0;
        this.isRead = false;
        this.createdAt = new Date();
        this.scheduledAt = new Date();
    }
    
    public Notification(int userId, String message, String type, String channel) {
        this.userId = userId;
        this.message = message;
        this.type = type;
        this.channel = channel;
        this.status = "UNREAD";
        this.priority = "MEDIUM";
        this.retryCount = 0;
        this.createdAt = new Date();
        this.scheduledAt = new Date();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    // For backward compatibility with donor-specific notifications
    public int getDonorId() { return userId; }
    public void setDonorId(int donorId) { this.userId = donorId; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getChannel() { return channel; }
    public void setChannel(String channel) { this.channel = channel; }
    
    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }
    
    public boolean isRead() { return isRead; }
    public void setRead(boolean isRead) { this.isRead = isRead; }
    
    public Date getScheduledAt() { return scheduledAt; }
    public void setScheduledAt(Date scheduledAt) { this.scheduledAt = scheduledAt; }
    
    public Date getSentAt() { return sentAt; }
    public void setSentAt(Date sentAt) { this.sentAt = sentAt; }
    
    public Date getReadAt() { return readAt; }
    public void setReadAt(Date readAt) { this.readAt = readAt; }
    
    public Date getExpiresAt() { return expiresAt; }
    public void setExpiresAt(Date expiresAt) { this.expiresAt = expiresAt; }
    
    public String getActionUrl() { return actionUrl; }
    public void setActionUrl(String actionUrl) { this.actionUrl = actionUrl; }
    
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    
    public int getRetryCount() { return retryCount; }
    public void setRetryCount(int retryCount) { this.retryCount = retryCount; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    // Business logic methods
    public boolean isUnread() {
        return !isRead;
    }
    
    public boolean isSent() {
        return "SENT".equals(status);
    }
    
    public boolean isFailed() {
        return "FAILED".equals(status);
    }
    
    public boolean isUrgent() {
        return "URGENT".equals(priority);
    }
    
    public boolean canRetry() {
        return isFailed() && retryCount < 3;
    }
    
    public void markAsRead() {
        this.isRead = true;
        this.readAt = new Date();
        this.updatedAt = new Date();
    }
    
    public void markAsSent() {
        this.status = "SENT";
        this.sentAt = new Date();
        this.updatedAt = new Date();
    }
    
    public void markAsFailed(String error) {
        this.status = "FAILED";
        this.errorMessage = error;
        this.retryCount++;
        this.updatedAt = new Date();
    }
}