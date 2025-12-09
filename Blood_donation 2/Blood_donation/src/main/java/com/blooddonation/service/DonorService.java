package com.blooddonation.service;

import com.blooddonation.dao.DonorDAO;
import com.blooddonation.dao.BloodReportDAO;
import com.blooddonation.dao.NotificationDAO;
import com.blooddonation.dao.FeedbackDAO;
import com.blooddonation.dao.DonationCampDAO;
import com.blooddonation.dao.AppointmentDAO;
import com.blooddonation.model.Donor;
import com.blooddonation.model.BloodReport;
import com.blooddonation.model.Notification;
import com.blooddonation.model.Feedback;
import com.blooddonation.model.DonationCamp;
import com.blooddonation.model.Appointment;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;

public class DonorService {
    
    private DonorDAO donorDAO;
    private BloodReportDAO bloodReportDAO;
    private NotificationDAO notificationDAO;
    private FeedbackDAO feedbackDAO;
    private DonationCampDAO donationCampDAO;
    private AppointmentDAO appointmentDAO;
    
    public DonorService() {
        this.donorDAO = new DonorDAO();
        this.bloodReportDAO = new BloodReportDAO();
        this.notificationDAO = new NotificationDAO();
        this.feedbackDAO = new FeedbackDAO();
        this.donationCampDAO = new DonationCampDAO();
        this.appointmentDAO = new AppointmentDAO();
    }
    
    /**
     * Get donor information by user ID
     */
    public Donor getDonorByUserId(int userId) throws SQLException {
        return donorDAO.getDonorByUserId(userId);
    }
    
    /**
     * Get donor summary data
     */
    public DonorSummary getDonorSummary(int userId) throws SQLException {
        DonorSummary summary = new DonorSummary();
        Donor donor = donorDAO.getDonorByUserId(userId);
        
        if (donor != null) {
            summary.setDonor(donor);
            summary.setTotalDonations(bloodReportDAO.getBloodReportCountByDonorId(donor.getId()));
            summary.setLastDonationDate(donor.getLastDonationDate());
            summary.setBloodGroup(donor.getBloodGroup());
            summary.setStatus(donor.getStatus());
            summary.setEligible(donorDAO.isEligible(userId));
            
            // Calculate next eligible date (90 days from last donation)
            if (donor.getLastDonationDate() != null) {
                long nextEligibleTime = donor.getLastDonationDate().getTime() + (90L * 24 * 60 * 60 * 1000);
                summary.setNextEligibleDate(new Date(nextEligibleTime));
            }
        }
        
        return summary;
    }
    
    /**
     * Get donor donation history (appointments)
     */
    public List<Appointment> getDonorDonationHistory(int userId) throws SQLException {
        Donor donor = donorDAO.getDonorByUserId(userId);
        if (donor != null) {
            return appointmentDAO.getAppointmentsByDonorId(donor.getId());
        }
        return new ArrayList<>();
    }
    
    /**
     * Get donor blood reports
     */
    public List<BloodReport> getDonorBloodReports(int userId) throws SQLException {
        System.out.println("Getting blood reports for user ID: " + userId);
        Donor donor = donorDAO.getDonorByUserId(userId);
        if (donor != null) {
            System.out.println("Found donor with ID: " + donor.getId());
            List<BloodReport> reports = bloodReportDAO.getBloodReportsByDonorId(donor.getId());
            System.out.println("Retrieved " + reports.size() + " blood reports from database");
            return reports;
        } else {
            System.out.println("No donor found for user ID: " + userId);
        }
        return new ArrayList<>();
    }
    
    /**
     * Get donor notifications
     */
    public List<Notification> getDonorNotifications(int userId) throws SQLException {
        return notificationDAO.getNotificationsByUserId(userId);
    }
    
    /**
     * Get donor feedback
     */
    public List<Feedback> getDonorFeedback(int userId) throws SQLException {
        return feedbackDAO.getFeedbackByUserId(userId);
    }
    
    /**
     * Submit feedback
     */
    public boolean submitFeedback(int userId, String feedbackText, String category) throws SQLException {
        if (feedbackText == null || feedbackText.trim().isEmpty()) {
            throw new IllegalArgumentException("Feedback text cannot be empty");
        }
        
        if (category == null || category.trim().isEmpty()) {
            category = "GENERAL";
        }
        
        Feedback feedback = new Feedback(userId, feedbackText, category);
        feedbackDAO.addFeedback(feedback);
        return true;
    }
    
    /**
     * Get upcoming donation camps
     */
    public List<DonationCamp> getUpcomingCamps() throws SQLException {
        return donationCampDAO.getAllCamps();
    }
    
    /**
     * Check if donor is eligible to donate
     */
    public boolean isEligibleToDonate(int userId) throws SQLException {
        return donorDAO.isEligible(userId);
    }
    
    /**
     * Get donor dashboard data
     */
    public DonorDashboardData getDonorDashboardData(int userId) throws SQLException {
        DonorDashboardData data = new DonorDashboardData();
        Donor donor = donorDAO.getDonorByUserId(userId);
        
        if (donor != null) {
            data.setDonor(donor);
            data.setTotalDonations(bloodReportDAO.getBloodReportCountByDonorId(donor.getId()));
            data.setLastDonationDate(donor.getLastDonationDate());
            data.setBloodGroup(donor.getBloodGroup());
            data.setStatus(donor.getStatus());
            data.setEligible(donorDAO.isEligible(userId));
            
            // Get recent notifications
            data.setNotifications(notificationDAO.getNotificationsByUserId(userId));
            
            // Get recent blood reports
            data.setRecentBloodReports(bloodReportDAO.getBloodReportsByDonorId(donor.getId()));
            
            // Calculate next eligible date
            if (donor.getLastDonationDate() != null) {
                long nextEligibleTime = donor.getLastDonationDate().getTime() + (90L * 24 * 60 * 60 * 1000);
                data.setNextEligibleDate(new Date(nextEligibleTime));
            }
            
            // Determine donor level based on total donations
            if (data.getTotalDonations() >= 10) {
                data.setDonorLevel("Gold");
            } else if (data.getTotalDonations() >= 5) {
                data.setDonorLevel("Silver");
            } else if (data.getTotalDonations() >= 1) {
                data.setDonorLevel("Bronze");
            } else {
                data.setDonorLevel("New");
            }
        }
        
        return data;
    }
    
    /**
     * Inner class for donor summary
     */
    public static class DonorSummary {
        private Donor donor;
        private int totalDonations;
        private Date lastDonationDate;
        private String bloodGroup;
        private String status;
        private boolean eligible;
        private Date nextEligibleDate;
        
        // Getters and setters
        public Donor getDonor() { return donor; }
        public void setDonor(Donor donor) { this.donor = donor; }
        
        public int getTotalDonations() { return totalDonations; }
        public void setTotalDonations(int totalDonations) { this.totalDonations = totalDonations; }
        
        public Date getLastDonationDate() { return lastDonationDate; }
        public void setLastDonationDate(Date lastDonationDate) { this.lastDonationDate = lastDonationDate; }
        
        public String getBloodGroup() { return bloodGroup; }
        public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
        
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        
        public boolean isEligible() { return eligible; }
        public void setEligible(boolean eligible) { this.eligible = eligible; }
        
        public Date getNextEligibleDate() { return nextEligibleDate; }
        public void setNextEligibleDate(Date nextEligibleDate) { this.nextEligibleDate = nextEligibleDate; }
    }
    
    /**
     * Inner class for donor dashboard data
     */
    public static class DonorDashboardData {
        private Donor donor;
        private int totalDonations;
        private Date lastDonationDate;
        private String bloodGroup;
        private String status;
        private boolean eligible;
        private Date nextEligibleDate;
        private String donorLevel;
        private List<Notification> notifications;
        private List<BloodReport> recentBloodReports;
        
        // Getters and setters
        public Donor getDonor() { return donor; }
        public void setDonor(Donor donor) { this.donor = donor; }
        
        public int getTotalDonations() { return totalDonations; }
        public void setTotalDonations(int totalDonations) { this.totalDonations = totalDonations; }
        
        public Date getLastDonationDate() { return lastDonationDate; }
        public void setLastDonationDate(Date lastDonationDate) { this.lastDonationDate = lastDonationDate; }
        
        public String getBloodGroup() { return bloodGroup; }
        public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
        
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        
        public boolean isEligible() { return eligible; }
        public void setEligible(boolean eligible) { this.eligible = eligible; }
        
        public Date getNextEligibleDate() { return nextEligibleDate; }
        public void setNextEligibleDate(Date nextEligibleDate) { this.nextEligibleDate = nextEligibleDate; }
        
        public String getDonorLevel() { return donorLevel; }
        public void setDonorLevel(String donorLevel) { this.donorLevel = donorLevel; }
        
        public List<Notification> getNotifications() { return notifications; }
        public void setNotifications(List<Notification> notifications) { this.notifications = notifications; }
        
        public List<BloodReport> getRecentBloodReports() { return recentBloodReports; }
        public void setRecentBloodReports(List<BloodReport> recentBloodReports) { this.recentBloodReports = recentBloodReports; }
    }
}
