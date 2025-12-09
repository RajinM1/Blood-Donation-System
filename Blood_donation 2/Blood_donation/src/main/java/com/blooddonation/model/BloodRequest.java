package com.blooddonation.model;

import java.util.Date;

public class BloodRequest {
    private int id;
    private int hospitalId;
    private String bloodGroup;
    private int quantity;
    private String urgency;
    private String status; // PENDING, APPROVED, REJECTED, ON_HOLD, COMPLETED
    private String priority; // LOW, MEDIUM, HIGH, CRITICAL
    private String patientName;
    private String reason;
    private String rejectionReason;
    private Date requestDate;
    private Date deliveryDate;
    private Date approvedAt;
    private int approvedBy; // User ID who approved
    private Date createdAt;
    private Date updatedAt;

    // Constructors
    public BloodRequest() {}
    
    public BloodRequest(int hospitalId, String bloodGroup, int quantity, String urgency, String patientName) {
        this.hospitalId = hospitalId;
        this.bloodGroup = bloodGroup;
        this.quantity = quantity;
        this.urgency = urgency;
        this.patientName = patientName;
        this.status = "PENDING";
        this.requestDate = new Date();
        this.createdAt = new Date();
        calculatePriority();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getHospitalId() { return hospitalId; }
    public void setHospitalId(int hospitalId) { this.hospitalId = hospitalId; }
    
    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public String getUrgency() { return urgency; }
    public void setUrgency(String urgency) { this.urgency = urgency; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }
    
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    
    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }
    
    public Date getRequestDate() { return requestDate; }
    public void setRequestDate(Date requestDate) { this.requestDate = requestDate; }
    
    public Date getDeliveryDate() { return deliveryDate; }
    public void setDeliveryDate(Date deliveryDate) { this.deliveryDate = deliveryDate; }
    
    public Date getApprovedAt() { return approvedAt; }
    public void setApprovedAt(Date approvedAt) { this.approvedAt = approvedAt; }
    
    public int getApprovedBy() { return approvedBy; }
    public void setApprovedBy(int approvedBy) { this.approvedBy = approvedBy; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    // Business logic methods
    public boolean isPending() {
        return "PENDING".equals(status);
    }
    
    public boolean isApproved() {
        return "APPROVED".equals(status);
    }
    
    public boolean isRejected() {
        return "REJECTED".equals(status);
    }
    
    public boolean isOnHold() {
        return "ON_HOLD".equals(status);
    }
    
    public boolean isCompleted() {
        return "COMPLETED".equals(status);
    }
    
    public boolean canBeEdited() {
        return isPending();
    }
    
    private void calculatePriority() {
        if ("CRITICAL".equals(urgency)) {
            this.priority = "CRITICAL";
        } else if ("HIGH".equals(urgency)) {
            this.priority = "HIGH";
        } else if ("MEDIUM".equals(urgency)) {
            this.priority = "MEDIUM";
        } else {
            this.priority = "LOW";
        }
    }
}