package com.blooddonation.model;

import java.util.Date;

public class DonationCamp {
    private int id;
    private String campName;
    private String location;
    private String address;
    private String city;
    private Date campDate;
    private Date startTime;
    private Date endTime;
    private int maxDonors;
    private int currentDonors;
    private int organizerId;
    private String status; // PLANNED, ACTIVE, COMPLETED, CANCELLED
    private String description;
    private String specialRequirements;
    private String contactPerson;
    private String contactPhone;
    private Date createdAt;
    private Date updatedAt;
    
    // Legacy fields for backward compatibility
    private String name;
    private Date startDate;
    private Date endDate;

    // Constructors
    public DonationCamp() {}
    
    public DonationCamp(String name, String location, Date startDate, Date endDate, int maxDonors) {
        this.name = name;
        this.location = location;
        this.startDate = startDate;
        this.endDate = endDate;
        this.maxDonors = maxDonors;
        this.status = "PLANNED";
        this.createdAt = new Date();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getCampName() { return campName; }
    public void setCampName(String campName) { 
        this.campName = campName; 
        this.name = campName; // Legacy compatibility
    }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    
    public Date getCampDate() { return campDate; }
    public void setCampDate(Date campDate) { 
        this.campDate = campDate; 
        this.startDate = campDate; // Legacy compatibility
    }
    
    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }
    
    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }
    
    public int getMaxDonors() { return maxDonors; }
    public void setMaxDonors(int maxDonors) { this.maxDonors = maxDonors; }
    
    public int getCurrentDonors() { return currentDonors; }
    public void setCurrentDonors(int currentDonors) { this.currentDonors = currentDonors; }
    
    public int getOrganizerId() { return organizerId; }
    public void setOrganizerId(int organizerId) { this.organizerId = organizerId; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getSpecialRequirements() { return specialRequirements; }
    public void setSpecialRequirements(String specialRequirements) { this.specialRequirements = specialRequirements; }
    
    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }
    
    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
    
    // Legacy getters and setters for backward compatibility
    public String getName() { return name != null ? name : campName; }
    public void setName(String name) { 
        this.name = name; 
        this.campName = name;
    }
    
    public Date getStartDate() { return startDate != null ? startDate : campDate; }
    public void setStartDate(Date startDate) { 
        this.startDate = startDate; 
        this.campDate = startDate;
    }
    
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    
    // Additional methods for compatibility
    public void setCreatedBy(int createdBy) { /* Store in a field if needed */ }

    // Business logic methods
    public boolean isPlanned() {
        return "PLANNED".equals(status);
    }
    
    public boolean isActive() {
        return "ACTIVE".equals(status);
    }
    
    public boolean isCompleted() {
        return "COMPLETED".equals(status);
    }
    
    public boolean isCancelled() {
        return "CANCELLED".equals(status);
    }
    
    public boolean isUpcoming() {
        return isPlanned() && campDate != null && campDate.after(new Date());
    }
    
    public boolean isPast() {
        return endDate != null && endDate.before(new Date());
    }
    
    public boolean isCurrentlyActive() {
        Date now = new Date();
        return isActive() && campDate != null && campDate.before(now) && (endDate == null || endDate.after(now));
    }
    
    public long getDurationInDays() {
        if (campDate == null || endDate == null) {
            return 0;
        }
        long diffInMilliseconds = endDate.getTime() - campDate.getTime();
        return diffInMilliseconds / (1000 * 60 * 60 * 24);
    }
    
    public boolean isWithinDateRange(Date date) {
        if (campDate == null || endDate == null || date == null) {
            return false;
        }
        return date.after(campDate) && date.before(endDate);
    }
    
    public boolean canAcceptDonors() {
        return isCurrentlyActive() && maxDonors > 0;
    }
    
    public void activate() {
        if (isPlanned()) {
            this.status = "ACTIVE";
            this.updatedAt = new Date();
        }
    }
    
    public void complete() {
        if (isActive()) {
            this.status = "COMPLETED";
            this.updatedAt = new Date();
        }
    }
    
    public void cancel() {
        if (isPlanned() || isActive()) {
            this.status = "CANCELLED";
            this.updatedAt = new Date();
        }
    }
}