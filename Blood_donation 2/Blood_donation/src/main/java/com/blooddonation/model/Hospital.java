package com.blooddonation.model;

import java.util.Date;

public class Hospital {
    private int id;
    private int userId; // Reference to the user account
    private String hospitalName;
    private String hospitalType; // PRIVATE or GOVERNMENT
    private String address;
    private String city;
    private String state;
    private String postalCode;
    private String contactPerson;
    private String contactPhone;
    private String contactEmail;
    private String licenseNumber;
    private String registrationNumber;
    private String status; // ACTIVE, PENDING, SUSPENDED
    private Date createdAt;
    private Date updatedAt;

    // Constructors
    public Hospital() {}

    public Hospital(int userId, String hospitalName, String hospitalType) {
        this.userId = userId;
        this.hospitalName = hospitalName;
        this.hospitalType = hospitalType;
        this.status = "PENDING";
        this.createdAt = new Date();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getHospitalName() { return hospitalName; }
    public void setHospitalName(String hospitalName) { this.hospitalName = hospitalName; }

    public String getHospitalType() { return hospitalType; }
    public void setHospitalType(String hospitalType) { this.hospitalType = hospitalType; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }

    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public String getContactEmail() { return contactEmail; }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }

    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }

    public String getRegistrationNumber() { return registrationNumber; }
    public void setRegistrationNumber(String registrationNumber) { this.registrationNumber = registrationNumber; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    // Business logic methods
    public boolean isPrivate() {
        return "PRIVATE".equals(hospitalType);
    }

    public boolean isGovernment() {
        return "GOVERNMENT".equals(hospitalType);
    }

    public boolean isActive() {
        return "ACTIVE".equals(status);
    }

    public boolean isPending() {
        return "PENDING".equals(status);
    }

    public boolean isSuspended() {
        return "SUSPENDED".equals(status);
    }

    public void activate() {
        this.status = "ACTIVE";
        this.updatedAt = new Date();
    }

    public void suspend() {
        this.status = "SUSPENDED";
        this.updatedAt = new Date();
    }

    public String getFullAddress() {
        StringBuilder address = new StringBuilder();
        if (this.address != null && !this.address.trim().isEmpty()) {
            address.append(this.address);
        }
        if (this.city != null && !this.city.trim().isEmpty()) {
            if (address.length() > 0) address.append(", ");
            address.append(this.city);
        }
        if (this.state != null && !this.state.trim().isEmpty()) {
            if (address.length() > 0) address.append(", ");
            address.append(this.state);
        }
        if (this.postalCode != null && !this.postalCode.trim().isEmpty()) {
            if (address.length() > 0) address.append(" ");
            address.append(this.postalCode);
        }
        return address.toString();
    }
}


