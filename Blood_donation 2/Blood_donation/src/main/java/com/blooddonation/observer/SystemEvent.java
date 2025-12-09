package com.blooddonation.observer;

/**
 * Enum representing system events actually used in the Blood Donation System
 */
public enum SystemEvent {
    // Blood Report Events (Used in MedicalStaffServlet)
    BLOOD_REPORT_APPROVED("Blood report approved by medical staff"),
    BLOOD_REPORT_REJECTED("Blood report rejected by medical staff"),
    
    // Blood Stock Events (Used in MedicalStaffServlet)
    BLOOD_STOCK_ADDED("New blood stock added to inventory"),
    BLOOD_STOCK_LOW("Blood stock level is low"),
    BLOOD_STOCK_EXPIRED("Blood stock has expired"),
    
    // System Events (Used for expiring alerts and general notifications)
    SYSTEM_ALERT("System alert generated");
    
    private final String description;
    
    SystemEvent(String description) {
        this.description = description;
    }
    
    public String getDescription() {
        return description;
    }
}