package com.blooddonation.model;

import java.util.Date;

public class Alert {
    private int id;
    private String type; // LOW_STOCK, EXPIRY_WARNING, THRESHOLD_BREACH, SYSTEM_ERROR
    private String severity; // LOW, MEDIUM, HIGH, CRITICAL
    private String title;
    private String message;
    private String bloodGroup;
    private int quantity;
    private Date expiryDate;
    private String status; // ACTIVE, ACKNOWLEDGED, RESOLVED, ESCALATED
    private int acknowledgedBy; // User ID who acknowledged
    private Date acknowledgedAt;
    private int escalatedTo; // User ID escalated to
    private Date escalatedAt;
    private String resolution;
    private Date resolvedAt;
    private int resolvedBy; // User ID who resolved
    private Date createdAt;
    private Date updatedAt;

    // Constructors
    public Alert() {}
    
    public Alert(String type, String severity, String title, String message) {
        this.type = type;
        this.severity = severity;
        this.title = title;
        this.message = message;
        this.status = "ACTIVE";
        this.createdAt = new Date();
    }
    
    public Alert(String type, String severity, String title, String message, String bloodGroup, int quantity) {
        this.type = type;
        this.severity = severity;
        this.title = title;
        this.message = message;
        this.bloodGroup = bloodGroup;
        this.quantity = quantity;
        this.status = "ACTIVE";
        this.createdAt = new Date();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public int getAcknowledgedBy() { return acknowledgedBy; }
    public void setAcknowledgedBy(int acknowledgedBy) { this.acknowledgedBy = acknowledgedBy; }
    
    public Date getAcknowledgedAt() { return acknowledgedAt; }
    public void setAcknowledgedAt(Date acknowledgedAt) { this.acknowledgedAt = acknowledgedAt; }
    
    public int getEscalatedTo() { return escalatedTo; }
    public void setEscalatedTo(int escalatedTo) { this.escalatedTo = escalatedTo; }
    
    public Date getEscalatedAt() { return escalatedAt; }
    public void setEscalatedAt(Date escalatedAt) { this.escalatedAt = escalatedAt; }
    
    public String getResolution() { return resolution; }
    public void setResolution(String resolution) { this.resolution = resolution; }
    
    public Date getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(Date resolvedAt) { this.resolvedAt = resolvedAt; }
    
    public int getResolvedBy() { return resolvedBy; }
    public void setResolvedBy(int resolvedBy) { this.resolvedBy = resolvedBy; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    // Business logic methods
    public boolean isActive() {
        return "ACTIVE".equals(status);
    }
    
    public boolean isAcknowledged() {
        return "ACKNOWLEDGED".equals(status);
    }
    
    public boolean isResolved() {
        return "RESOLVED".equals(status);
    }
    
    public boolean isEscalated() {
        return "ESCALATED".equals(status);
    }
    
    public boolean isCritical() {
        return "CRITICAL".equals(severity);
    }
    
    public boolean isHigh() {
        return "HIGH".equals(severity);
    }
    
    public boolean isLowStock() {
        return "LOW_STOCK".equals(type);
    }
    
    public boolean isExpiryWarning() {
        return "EXPIRY_WARNING".equals(type);
    }
    
    public boolean isThresholdBreach() {
        return "THRESHOLD_BREACH".equals(type);
    }
    
    public void acknowledge(int userId) {
        this.status = "ACKNOWLEDGED";
        this.acknowledgedBy = userId;
        this.acknowledgedAt = new Date();
        this.updatedAt = new Date();
    }
    
    public void escalate(int userId) {
        this.status = "ESCALATED";
        this.escalatedTo = userId;
        this.escalatedAt = new Date();
        this.updatedAt = new Date();
    }
    
    public void resolve(int userId, String resolution) {
        this.status = "RESOLVED";
        this.resolvedBy = userId;
        this.resolution = resolution;
        this.resolvedAt = new Date();
        this.updatedAt = new Date();
    }
}

