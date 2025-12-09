package com.blooddonation.model;

import java.util.Date;

public class BloodStock {
    private int id;
    private String bloodGroup;
    private int quantity;
    private Date expiryDate;
    private Date collectionDate;
    private String status; // USABLE, QUARANTINED, EXPIRED, DISPOSED
    private String screeningResult; // NEGATIVE, POSITIVE
    private int donorId;
    private double volume; // Volume in ml
    private String notes;
    private Date createdAt;
    private Date updatedAt;

    // Constructors
    public BloodStock() {}
    
    public BloodStock(String bloodGroup, int quantity, Date expiryDate, Date collectionDate, 
                     String screeningResult, int donorId, double volume) {
        this.bloodGroup = bloodGroup;
        this.quantity = quantity;
        this.expiryDate = expiryDate;
        this.collectionDate = collectionDate;
        this.screeningResult = screeningResult;
        this.donorId = donorId;
        this.volume = volume;
        this.status = "NEGATIVE".equals(screeningResult) ? "USABLE" : "QUARANTINED";
        this.createdAt = new Date();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }
    
    public Date getCollectionDate() { return collectionDate; }
    public void setCollectionDate(Date collectionDate) { this.collectionDate = collectionDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getScreeningResult() { return screeningResult; }
    public void setScreeningResult(String screeningResult) { this.screeningResult = screeningResult; }
    
    public int getDonorId() { return donorId; }
    public void setDonorId(int donorId) { this.donorId = donorId; }
    
    public double getVolume() { return volume; }
    public void setVolume(double volume) { this.volume = volume; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    // Business logic methods
    public boolean isExpired() {
        Date currentDate = new Date();
        return expiryDate != null && expiryDate.before(currentDate);
    }
    
    public boolean isUsable() {
        return "USABLE".equals(status) && !isExpired();
    }
    
    public boolean isQuarantined() {
        return "QUARANTINED".equals(status);
    }
    
    public boolean isDisposed() {
        return "DISPOSED".equals(status);
    }
    
    public boolean isExpiringSoon(int days) {
        if (expiryDate == null) return false;
        
        long diffInMilliseconds = expiryDate.getTime() - new Date().getTime();
        long diffInDays = diffInMilliseconds / (1000 * 60 * 60 * 24);
        return diffInDays <= days && diffInDays >= 0;
    }
    
    public int getDaysUntilExpiry() {
        if (expiryDate == null) return -1;
        
        long diffInMilliseconds = expiryDate.getTime() - new Date().getTime();
        return (int) (diffInMilliseconds / (1000 * 60 * 60 * 24));
    }
}