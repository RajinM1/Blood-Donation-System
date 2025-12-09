package com.blooddonation.model;

import java.util.Date;

public class Appointment {
    private int id;
    private int donorId;
    private int campId;
    private Date appointmentDate;
    private String status; // PENDING, APPROVED, REJECTED, COMPLETED, CANCELLED
    private String timeSlot; // 10:00 AM, 2:00 PM, etc.
    private String notes;
    private Date createdAt;
    private Date updatedAt;
    private Date approvedAt;
    private int approvedBy; // User ID who approved

    // Constructors
    public Appointment() {}
    
    public Appointment(int donorId, int campId, Date appointmentDate, String timeSlot) {
        this.donorId = donorId;
        this.campId = campId;
        this.appointmentDate = appointmentDate;
        this.timeSlot = timeSlot;
        this.status = "PENDING";
        this.createdAt = new Date();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getDonorId() { return donorId; }
    public void setDonorId(int donorId) { this.donorId = donorId; }

    public int getCampId() { return campId; }
    public void setCampId(int campId) { this.campId = campId; }

    public Date getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(Date appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public Date getApprovedAt() { return approvedAt; }
    public void setApprovedAt(Date approvedAt) { this.approvedAt = approvedAt; }

    public int getApprovedBy() { return approvedBy; }
    public void setApprovedBy(int approvedBy) { this.approvedBy = approvedBy; }
    
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
    
    public boolean isCompleted() {
        return "COMPLETED".equals(status);
    }
    
    public boolean isCancelled() {
        return "CANCELLED".equals(status);
    }
    
    public boolean canBeCancelled() {
        return isPending() || isApproved();
    }
}