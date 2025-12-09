package com.blooddonation.model;

import java.sql.Timestamp;

/**
 * Model class for audit log entries
 */
public class AuditLog {
    private int id;
    private Integer userId;
    private String action;
    private String entityType;
    private Integer entityId;
    private String details;
    private Timestamp timestamp;
    
    public AuditLog() {
        this.timestamp = new Timestamp(System.currentTimeMillis());
    }
    
    // Constructor with parameters (for UserManagementService compatibility)
    public AuditLog(Integer userId, String action, String entityType, Integer entityId, String details, String ipAddress) {
        this.userId = userId;
        this.action = action;
        this.entityType = entityType;
        this.entityId = entityId;
        this.details = details;
        this.timestamp = new Timestamp(System.currentTimeMillis());
        // Note: ipAddress parameter is ignored as our current model doesn't have this field
        // You can add it later if needed
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public String getAction() {
        return action;
    }
    
    public void setAction(String action) {
        this.action = action;
    }
    
    public String getEntityType() {
        return entityType;
    }
    
    public void setEntityType(String entityType) {
        this.entityType = entityType;
    }
    
    public Integer getEntityId() {
        return entityId;
    }
    
    public void setEntityId(Integer entityId) {
        this.entityId = entityId;
    }
    
    public String getDetails() {
        return details;
    }
    
    public void setDetails(String details) {
        this.details = details;
    }
    
    public Timestamp getTimestamp() {
        return timestamp;
    }
    
    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }
    
    @Override
    public String toString() {
        return "AuditLog{" +
                "id=" + id +
                ", userId=" + userId +
                ", action='" + action + '\'' +
                ", entityType='" + entityType + '\'' +
                ", entityId=" + entityId +
                ", details='" + details + '\'' +
                ", timestamp=" + timestamp +
                '}';
    }
}