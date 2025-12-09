package com.blooddonation.observer;

import com.blooddonation.util.EmailUtil;
import com.blooddonation.dao.UserDAO;
import com.blooddonation.dao.DonorDAO;
import com.blooddonation.model.User;
import com.blooddonation.model.Donor;

import java.sql.SQLException;
import java.util.Map;

/**
 * Observer that sends email notifications when events occur
 */
public class EmailNotificationObserver implements EventObserver {
    
    private final UserDAO userDAO;
    private final DonorDAO donorDAO;
    
    public EmailNotificationObserver() {
        this.userDAO = new UserDAO();
        this.donorDAO = new DonorDAO();
    }
    
    @Override
    public void onEvent(SystemEvent event, Object data) {
        try {
            switch (event) {
                case BLOOD_REPORT_APPROVED:
                    handleBloodReportApproved(data);
                    break;
                case BLOOD_REPORT_REJECTED:
                    handleBloodReportRejected(data);
                    break;

                case BLOOD_STOCK_LOW:
                    handleLowBloodStock(data);
                    break;
                default:
                    // Log other events but don't send emails (BLOOD_STOCK_ADDED, BLOOD_STOCK_EXPIRED, SYSTEM_ALERT)
                    System.out.println("📧 [EMAIL] Notification sent for: " + event.getDescription());
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in EmailNotificationObserver: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void handleBloodReportApproved(Object data) throws SQLException {
        if (data instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> reportData = (Map<String, Object>) data;
            Integer donorId = (Integer) reportData.get("donorId");
            
            if (donorId != null) {
                Donor donor = donorDAO.getDonorById(donorId);
                if (donor != null) {
                    User user = userDAO.getUserById(donor.getUserId());
                    if (user != null && user.getEmail() != null) {
                        String subject = "Blood Report Approved - Thank You!";
                        String message = "Dear " + donor.getName() + ",\n\n" +
                                       "Great news! Your blood test results have been approved by our medical staff. " +
                                       "Your donation has been added to our blood bank inventory and will help save lives.\n\n" +
                                       "Thank you for your generous contribution!\n\n" +
                                       "Best regards,\n" +
                                       "Blood Donation System Team";
                        
                        EmailUtil.sendEmail(user.getEmail(), subject, message);
                        System.out.println("Email sent to donor: " + user.getEmail());
                    }
                }
            }
        }
    }
    
    private void handleBloodReportRejected(Object data) throws SQLException {
        if (data instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> reportData = (Map<String, Object>) data;
            Integer donorId = (Integer) reportData.get("donorId");
            String reason = (String) reportData.get("reason");
            
            if (donorId != null) {
                Donor donor = donorDAO.getDonorById(donorId);
                if (donor != null) {
                    User user = userDAO.getUserById(donor.getUserId());
                    if (user != null && user.getEmail() != null) {
                        String subject = "Blood Report Update - Action Required";
                        String message = "Dear " + donor.getName() + ",\n\n" +
                                       "We have reviewed your recent blood test results. Unfortunately, we cannot " +
                                       "use your donation at this time.\n\n" +
                                       (reason != null ? "Reason: " + reason + "\n\n" : "") +
                                       "Please consult with our medical staff for more information. " +
                                       "You may be eligible to donate again in the future.\n\n" +
                                       "Thank you for your understanding.\n\n" +
                                       "Best regards,\n" +
                                       "Blood Donation System Team";
                        
                        EmailUtil.sendEmail(user.getEmail(), subject, message);
                        System.out.println("Email sent to donor: " + user.getEmail());
                    }
                }
            }
        }
    }
    

    

    
    private void handleLowBloodStock(Object data) {
        if (data instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> stockData = (Map<String, Object>) data;
            String bloodGroup = (String) stockData.get("bloodGroup");
            Integer currentStock = (Integer) stockData.get("currentStock");
            
            // Send alert to management
            String managementEmail = "management@bloodbank.com"; // This should come from config
            String subject = "URGENT: Low Blood Stock Alert - " + bloodGroup;
            String message = "URGENT ALERT\n\n" +
                           "Blood stock for " + bloodGroup + " is critically low!\n\n" +
                           "Current Stock: " + currentStock + " units\n" +
                           "Minimum Required: 10 units\n\n" +
                           "Immediate action required:\n" +
                           "1. Contact donors with " + bloodGroup + " blood type\n" +
                           "2. Schedule emergency donation drives\n" +
                           "3. Coordinate with other blood banks\n\n" +
                           "Blood Bank Management System";
            
            try {
                EmailUtil.sendEmail(managementEmail, subject, message);
                System.out.println("Low stock alert sent to management");
            } catch (Exception e) {
                System.err.println("Failed to send low stock alert: " + e.getMessage());
            }
        }
    }
    
    @Override
    public String getObserverName() {
        return "EmailNotificationObserver";
    }
}