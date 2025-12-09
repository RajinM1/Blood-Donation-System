package com.blooddonation.model;

import java.util.Date;

public class Donor {
    private int id;
    private int userId;
    private String name;
    private int age;
    private String gender;
    private String bloodGroup;
    private double weight; // Added weight field for eligibility check
    private String healthInfo;
    private Date lastDonationDate;
    private Date nextEligibleDate;
    private int totalDonations;
    private String status; // Added status field (PENDING, APPROVED, REJECTED)
    private Date createdAt;
    private Date updatedAt;

    // Constructors
    public Donor() {}
    
    public Donor(int userId, String name, int age, String gender, String bloodGroup, double weight) {
        this.userId = userId;
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.bloodGroup = bloodGroup;
        this.weight = weight;
        this.status = "PENDING";
        this.createdAt = new Date();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    
    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
    
    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }
    
    public String getHealthInfo() { return healthInfo; }
    public void setHealthInfo(String healthInfo) { this.healthInfo = healthInfo; }
    
    public Date getLastDonationDate() { return lastDonationDate; }
    public void setLastDonationDate(Date lastDonationDate) { this.lastDonationDate = lastDonationDate; }
    
    public Date getNextEligibleDate() { return nextEligibleDate; }
    public void setNextEligibleDate(Date nextEligibleDate) { this.nextEligibleDate = nextEligibleDate; }
    
    public int getTotalDonations() { return totalDonations; }
    public void setTotalDonations(int totalDonations) { this.totalDonations = totalDonations; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
    
    // Business logic methods
    public boolean isEligibleForDonation() {
        return age >= 18 && age <= 65 && weight >= 40.0 && 
               (lastDonationDate == null || isEligibleBasedOnLastDonation());
    }
    
    private boolean isEligibleBasedOnLastDonation() {
        if (lastDonationDate == null) return true;
        
        long diffInMilliseconds = new Date().getTime() - lastDonationDate.getTime();
        long diffInDays = diffInMilliseconds / (1000 * 60 * 60 * 24);
        return diffInDays >= 90; // 3 months
    }
    
    public Date calculateNextEligibleDate() {
        if (lastDonationDate == null) {
            return new Date(); // Available now
        }
        
        // Add 56 days to last donation date (standard for whole blood)
        long nextEligibleTime = lastDonationDate.getTime() + (56L * 24 * 60 * 60 * 1000);
        return new Date(nextEligibleTime);
    }
}