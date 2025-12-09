package com.blooddonation.service;

import com.blooddonation.dao.BloodStockDAO;
import com.blooddonation.dao.BloodRequestDAO;
import com.blooddonation.dao.AppointmentDAO;
import com.blooddonation.dao.DonorDAO;
import com.blooddonation.dao.FeedbackDAO;
import com.blooddonation.dao.UserDAO;
import com.blooddonation.model.BloodStock;
import com.blooddonation.model.BloodRequest;
import com.blooddonation.model.Appointment;
import com.blooddonation.model.Donor;
import com.blooddonation.model.Feedback;
import com.blooddonation.model.User;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class ReportService {
    
    private BloodStockDAO stockDAO;
    private BloodRequestDAO requestDAO;
    private AppointmentDAO appointmentDAO;
    private DonorDAO donorDAO;
    private FeedbackDAO feedbackDAO;
    private UserDAO userDAO;
    
    public ReportService() {
        this.stockDAO = new BloodStockDAO();
        this.requestDAO = new BloodRequestDAO();
        this.appointmentDAO = new AppointmentDAO();
        this.donorDAO = new DonorDAO();
        this.feedbackDAO = new FeedbackDAO();
        this.userDAO = new UserDAO();
    }
    
    /**
     * Generate monthly inventory report
     */
    public InventoryReport generateMonthlyInventoryReport(Date month) throws SQLException {
        InventoryReport report = new InventoryReport();
        
        // Get all blood stock
        List<BloodStock> allStock = stockDAO.getAllBloodStock();
        
        // Calculate statistics
        int totalUnits = 0;
        int usableUnits = 0;
        int expiredUnits = 0;
        int quarantinedUnits = 0;
        
        Map<String, Integer> bloodGroupCounts = new HashMap<>();
        Map<String, Integer> bloodGroupUsable = new HashMap<>();
        Map<String, Integer> bloodGroupExpired = new HashMap<>();
        
        for (BloodStock stock : allStock) {
            totalUnits += stock.getQuantity();
            
            if (stock.isUsable()) {
                usableUnits += stock.getQuantity();
                bloodGroupUsable.put(stock.getBloodGroup(), 
                    bloodGroupUsable.getOrDefault(stock.getBloodGroup(), 0) + stock.getQuantity());
            } else if (stock.isExpired()) {
                expiredUnits += stock.getQuantity();
                bloodGroupExpired.put(stock.getBloodGroup(), 
                    bloodGroupExpired.getOrDefault(stock.getBloodGroup(), 0) + stock.getQuantity());
            } else if (stock.isQuarantined()) {
                quarantinedUnits += stock.getQuantity();
            }
            
            bloodGroupCounts.put(stock.getBloodGroup(), 
                bloodGroupCounts.getOrDefault(stock.getBloodGroup(), 0) + stock.getQuantity());
        }
        
        report.setTotalUnits(totalUnits);
        report.setUsableUnits(usableUnits);
        report.setExpiredUnits(expiredUnits);
        report.setQuarantinedUnits(quarantinedUnits);
        report.setBloodGroupCounts(bloodGroupCounts);
        report.setBloodGroupUsable(bloodGroupUsable);
        report.setBloodGroupExpired(bloodGroupExpired);
        report.setReportDate(month);
        
        return report;
    }
    
    /**
     * Generate donor statistics report
     */
    public DonorStatisticsReport generateDonorStatisticsReport(Date startDate, Date endDate) throws SQLException {
        DonorStatisticsReport report = new DonorStatisticsReport();
        
        // Get all donors
        List<Donor> allDonors = donorDAO.getAllDonors();
        
        // Calculate statistics
        int totalDonors = allDonors.size();
        int eligibleDonors = 0;
        int pendingDonors = 0;
        int approvedDonors = 0;
        
        Map<String, Integer> bloodGroupCounts = new HashMap<>();
        Map<String, Integer> genderCounts = new HashMap<>();
        Map<String, Integer> ageGroups = new HashMap<>();
        
        for (Donor donor : allDonors) {
            if (donor.isEligibleForDonation()) {
                eligibleDonors++;
            }
            
            if ("PENDING".equals(donor.getStatus())) {
                pendingDonors++;
            } else if ("APPROVED".equals(donor.getStatus())) {
                approvedDonors++;
            }
            
            bloodGroupCounts.put(donor.getBloodGroup(), 
                bloodGroupCounts.getOrDefault(donor.getBloodGroup(), 0) + 1);
            
            genderCounts.put(donor.getGender(), 
                genderCounts.getOrDefault(donor.getGender(), 0) + 1);
            
            String ageGroup = getAgeGroup(donor.getAge());
            ageGroups.put(ageGroup, ageGroups.getOrDefault(ageGroup, 0) + 1);
        }
        
        report.setTotalDonors(totalDonors);
        report.setEligibleDonors(eligibleDonors);
        report.setPendingDonors(pendingDonors);
        report.setApprovedDonors(approvedDonors);
        report.setBloodGroupCounts(bloodGroupCounts);
        report.setGenderCounts(genderCounts);
        report.setAgeGroups(ageGroups);
        report.setStartDate(startDate);
        report.setEndDate(endDate);
        
        return report;
    }
    
    /**
     * Generate blood request report
     */
    public BloodRequestReport generateBloodRequestReport(Date startDate, Date endDate) throws SQLException {
        BloodRequestReport report = new BloodRequestReport();
        
        // Get all blood requests
        List<BloodRequest> allRequests = requestDAO.getAllBloodRequests();
        
        // Filter by date range
        List<BloodRequest> filteredRequests = allRequests.stream()
                .filter(request -> request.getRequestDate().after(startDate) && request.getRequestDate().before(endDate))
                .collect(java.util.stream.Collectors.toList());
        
        // Calculate statistics
        int totalRequests = filteredRequests.size();
        int pendingRequests = 0;
        int approvedRequests = 0;
        int rejectedRequests = 0;
        int onHoldRequests = 0;
        int completedRequests = 0;
        
        Map<String, Integer> bloodGroupCounts = new HashMap<>();
        Map<String, Integer> urgencyCounts = new HashMap<>();
        Map<String, Integer> priorityCounts = new HashMap<>();
        
        for (BloodRequest request : filteredRequests) {
            if (request.isPending()) pendingRequests++;
            else if (request.isApproved()) approvedRequests++;
            else if (request.isRejected()) rejectedRequests++;
            else if (request.isOnHold()) onHoldRequests++;
            else if (request.isCompleted()) completedRequests++;
            
            bloodGroupCounts.put(request.getBloodGroup(), 
                bloodGroupCounts.getOrDefault(request.getBloodGroup(), 0) + 1);
            
            urgencyCounts.put(request.getUrgency(), 
                urgencyCounts.getOrDefault(request.getUrgency(), 0) + 1);
            
            priorityCounts.put(request.getPriority(), 
                priorityCounts.getOrDefault(request.getPriority(), 0) + 1);
        }
        
        report.setTotalRequests(totalRequests);
        report.setPendingRequests(pendingRequests);
        report.setApprovedRequests(approvedRequests);
        report.setRejectedRequests(rejectedRequests);
        report.setOnHoldRequests(onHoldRequests);
        report.setCompletedRequests(completedRequests);
        report.setBloodGroupCounts(bloodGroupCounts);
        report.setUrgencyCounts(urgencyCounts);
        report.setPriorityCounts(priorityCounts);
        report.setStartDate(startDate);
        report.setEndDate(endDate);
        
        return report;
    }
    
    /**
     * Generate appointment report
     */
    public AppointmentReport generateAppointmentReport(Date startDate, Date endDate) throws SQLException {
        AppointmentReport report = new AppointmentReport();
        
        // Get all appointments
        List<Appointment> allAppointments = appointmentDAO.getAllAppointments();
        
        // Filter by date range
        List<Appointment> filteredAppointments = allAppointments.stream()
                .filter(appointment -> appointment.getAppointmentDate().after(startDate) && appointment.getAppointmentDate().before(endDate))
                .collect(java.util.stream.Collectors.toList());
        
        // Calculate statistics
        int totalAppointments = filteredAppointments.size();
        int pendingAppointments = 0;
        int approvedAppointments = 0;
        int rejectedAppointments = 0;
        int completedAppointments = 0;
        int cancelledAppointments = 0;
        
        Map<String, Integer> statusCounts = new HashMap<>();
        Map<String, Integer> timeSlotCounts = new HashMap<>();
        
        for (Appointment appointment : filteredAppointments) {
            if (appointment.isPending()) pendingAppointments++;
            else if (appointment.isApproved()) approvedAppointments++;
            else if (appointment.isRejected()) rejectedAppointments++;
            else if (appointment.isCompleted()) completedAppointments++;
            else if (appointment.isCancelled()) cancelledAppointments++;
            
            statusCounts.put(appointment.getStatus(), 
                statusCounts.getOrDefault(appointment.getStatus(), 0) + 1);
            
            timeSlotCounts.put(appointment.getTimeSlot(), 
                timeSlotCounts.getOrDefault(appointment.getTimeSlot(), 0) + 1);
        }
        
        report.setTotalAppointments(totalAppointments);
        report.setPendingAppointments(pendingAppointments);
        report.setApprovedAppointments(approvedAppointments);
        report.setRejectedAppointments(rejectedAppointments);
        report.setCompletedAppointments(completedAppointments);
        report.setCancelledAppointments(cancelledAppointments);
        report.setStatusCounts(statusCounts);
        report.setTimeSlotCounts(timeSlotCounts);
        report.setStartDate(startDate);
        report.setEndDate(endDate);
        
        return report;
    }
    
    /**
     * Generate feedback report
     */
    public FeedbackReport generateFeedbackReport(Date startDate, Date endDate) throws SQLException {
        FeedbackReport report = new FeedbackReport();
        
        // Get all feedback
        List<Feedback> allFeedback = feedbackDAO.getAllFeedback();
        
        // Filter by date range
        List<Feedback> filteredFeedback = allFeedback.stream()
                .filter(feedback -> feedback.getCreatedAt().after(startDate) && feedback.getCreatedAt().before(endDate))
                .collect(java.util.stream.Collectors.toList());
        
        // Calculate statistics
        int totalFeedback = filteredFeedback.size();
        int pendingFeedback = 0;
        int respondedFeedback = 0;
        int escalatedFeedback = 0;
        int resolvedFeedback = 0;
        int urgentFeedback = 0;
        
        Map<String, Integer> categoryCounts = new HashMap<>();
        Map<String, Integer> statusCounts = new HashMap<>();
        
        for (Feedback feedback : filteredFeedback) {
            if (feedback.isPending()) pendingFeedback++;
            else if (feedback.isResponded()) respondedFeedback++;
            else if (feedback.isEscalated()) escalatedFeedback++;
            else if (feedback.isResolved()) resolvedFeedback++;
            
            if (feedback.isUrgent()) urgentFeedback++;
            
            categoryCounts.put(feedback.getCategory(), 
                categoryCounts.getOrDefault(feedback.getCategory(), 0) + 1);
            
            statusCounts.put(feedback.getStatus(), 
                statusCounts.getOrDefault(feedback.getStatus(), 0) + 1);
        }
        
        report.setTotalFeedback(totalFeedback);
        report.setPendingFeedback(pendingFeedback);
        report.setRespondedFeedback(respondedFeedback);
        report.setEscalatedFeedback(escalatedFeedback);
        report.setResolvedFeedback(resolvedFeedback);
        report.setUrgentFeedback(urgentFeedback);
        report.setCategoryCounts(categoryCounts);
        report.setStatusCounts(statusCounts);
        report.setStartDate(startDate);
        report.setEndDate(endDate);
        
        return report;
    }
    
    /**
     * Generate compliance report
     */
    public ComplianceReport generateComplianceReport() throws SQLException {
        ComplianceReport report = new ComplianceReport();
        
        // Get all data
        List<BloodStock> allStock = stockDAO.getAllBloodStock();
        List<BloodRequest> allRequests = requestDAO.getAllBloodRequests();
        List<Appointment> allAppointments = appointmentDAO.getAllAppointments();
        List<Donor> allDonors = donorDAO.getAllDonors();
        
        // Calculate compliance metrics
        int totalBloodUnits = allStock.size();
        int expiredUnits = 0;
        int quarantinedUnits = 0;
        int usableUnits = 0;
        
        for (BloodStock stock : allStock) {
            if (stock.isExpired()) expiredUnits++;
            else if (stock.isQuarantined()) quarantinedUnits++;
            else if (stock.isUsable()) usableUnits++;
        }
        
        int totalRequests = allRequests.size();
        int approvedRequests = 0;
        int rejectedRequests = 0;
        
        for (BloodRequest request : allRequests) {
            if (request.isApproved()) approvedRequests++;
            else if (request.isRejected()) rejectedRequests++;
        }
        
        int totalAppointments = allAppointments.size();
        int completedAppointments = 0;
        
        for (Appointment appointment : allAppointments) {
            if (appointment.isCompleted()) completedAppointments++;
        }
        
        int totalDonors = allDonors.size();
        int eligibleDonors = 0;
        
        for (Donor donor : allDonors) {
            if (donor.isEligibleForDonation()) eligibleDonors++;
        }
        
        report.setTotalBloodUnits(totalBloodUnits);
        report.setExpiredUnits(expiredUnits);
        report.setQuarantinedUnits(quarantinedUnits);
        report.setUsableUnits(usableUnits);
        report.setTotalRequests(totalRequests);
        report.setApprovedRequests(approvedRequests);
        report.setRejectedRequests(rejectedRequests);
        report.setTotalAppointments(totalAppointments);
        report.setCompletedAppointments(completedAppointments);
        report.setTotalDonors(totalDonors);
        report.setEligibleDonors(eligibleDonors);
        report.setReportDate(new Date());
        
        return report;
    }
    
    /**
     * Get age group for donor
     */
    private String getAgeGroup(int age) {
        if (age < 25) return "18-24";
        else if (age < 35) return "25-34";
        else if (age < 45) return "35-44";
        else if (age < 55) return "45-54";
        else return "55+";
    }
    
    /**
     * Inner class for inventory report
     */
    public static class InventoryReport {
        private int totalUnits;
        private int usableUnits;
        private int expiredUnits;
        private int quarantinedUnits;
        private Map<String, Integer> bloodGroupCounts;
        private Map<String, Integer> bloodGroupUsable;
        private Map<String, Integer> bloodGroupExpired;
        private Date reportDate;
        
        // Getters and setters
        public int getTotalUnits() { return totalUnits; }
        public void setTotalUnits(int totalUnits) { this.totalUnits = totalUnits; }
        
        public int getUsableUnits() { return usableUnits; }
        public void setUsableUnits(int usableUnits) { this.usableUnits = usableUnits; }
        
        public int getExpiredUnits() { return expiredUnits; }
        public void setExpiredUnits(int expiredUnits) { this.expiredUnits = expiredUnits; }
        
        public int getQuarantinedUnits() { return quarantinedUnits; }
        public void setQuarantinedUnits(int quarantinedUnits) { this.quarantinedUnits = quarantinedUnits; }
        
        public Map<String, Integer> getBloodGroupCounts() { return bloodGroupCounts; }
        public void setBloodGroupCounts(Map<String, Integer> bloodGroupCounts) { this.bloodGroupCounts = bloodGroupCounts; }
        
        public Map<String, Integer> getBloodGroupUsable() { return bloodGroupUsable; }
        public void setBloodGroupUsable(Map<String, Integer> bloodGroupUsable) { this.bloodGroupUsable = bloodGroupUsable; }
        
        public Map<String, Integer> getBloodGroupExpired() { return bloodGroupExpired; }
        public void setBloodGroupExpired(Map<String, Integer> bloodGroupExpired) { this.bloodGroupExpired = bloodGroupExpired; }
        
        public Date getReportDate() { return reportDate; }
        public void setReportDate(Date reportDate) { this.reportDate = reportDate; }
    }
    
    /**
     * Inner class for donor statistics report
     */
    public static class DonorStatisticsReport {
        private int totalDonors;
        private int eligibleDonors;
        private int pendingDonors;
        private int approvedDonors;
        private Map<String, Integer> bloodGroupCounts;
        private Map<String, Integer> genderCounts;
        private Map<String, Integer> ageGroups;
        private Date startDate;
        private Date endDate;
        
        // Getters and setters
        public int getTotalDonors() { return totalDonors; }
        public void setTotalDonors(int totalDonors) { this.totalDonors = totalDonors; }
        
        public int getEligibleDonors() { return eligibleDonors; }
        public void setEligibleDonors(int eligibleDonors) { this.eligibleDonors = eligibleDonors; }
        
        public int getPendingDonors() { return pendingDonors; }
        public void setPendingDonors(int pendingDonors) { this.pendingDonors = pendingDonors; }
        
        public int getApprovedDonors() { return approvedDonors; }
        public void setApprovedDonors(int approvedDonors) { this.approvedDonors = approvedDonors; }
        
        public Map<String, Integer> getBloodGroupCounts() { return bloodGroupCounts; }
        public void setBloodGroupCounts(Map<String, Integer> bloodGroupCounts) { this.bloodGroupCounts = bloodGroupCounts; }
        
        public Map<String, Integer> getGenderCounts() { return genderCounts; }
        public void setGenderCounts(Map<String, Integer> genderCounts) { this.genderCounts = genderCounts; }
        
        public Map<String, Integer> getAgeGroups() { return ageGroups; }
        public void setAgeGroups(Map<String, Integer> ageGroups) { this.ageGroups = ageGroups; }
        
        public Date getStartDate() { return startDate; }
        public void setStartDate(Date startDate) { this.startDate = startDate; }
        
        public Date getEndDate() { return endDate; }
        public void setEndDate(Date endDate) { this.endDate = endDate; }
    }
    
    /**
     * Inner class for blood request report
     */
    public static class BloodRequestReport {
        private int totalRequests;
        private int pendingRequests;
        private int approvedRequests;
        private int rejectedRequests;
        private int onHoldRequests;
        private int completedRequests;
        private Map<String, Integer> bloodGroupCounts;
        private Map<String, Integer> urgencyCounts;
        private Map<String, Integer> priorityCounts;
        private Date startDate;
        private Date endDate;
        
        // Getters and setters
        public int getTotalRequests() { return totalRequests; }
        public void setTotalRequests(int totalRequests) { this.totalRequests = totalRequests; }
        
        public int getPendingRequests() { return pendingRequests; }
        public void setPendingRequests(int pendingRequests) { this.pendingRequests = pendingRequests; }
        
        public int getApprovedRequests() { return approvedRequests; }
        public void setApprovedRequests(int approvedRequests) { this.approvedRequests = approvedRequests; }
        
        public int getRejectedRequests() { return rejectedRequests; }
        public void setRejectedRequests(int rejectedRequests) { this.rejectedRequests = rejectedRequests; }
        
        public int getOnHoldRequests() { return onHoldRequests; }
        public void setOnHoldRequests(int onHoldRequests) { this.onHoldRequests = onHoldRequests; }
        
        public int getCompletedRequests() { return completedRequests; }
        public void setCompletedRequests(int completedRequests) { this.completedRequests = completedRequests; }
        
        public Map<String, Integer> getBloodGroupCounts() { return bloodGroupCounts; }
        public void setBloodGroupCounts(Map<String, Integer> bloodGroupCounts) { this.bloodGroupCounts = bloodGroupCounts; }
        
        public Map<String, Integer> getUrgencyCounts() { return urgencyCounts; }
        public void setUrgencyCounts(Map<String, Integer> urgencyCounts) { this.urgencyCounts = urgencyCounts; }
        
        public Map<String, Integer> getPriorityCounts() { return priorityCounts; }
        public void setPriorityCounts(Map<String, Integer> priorityCounts) { this.priorityCounts = priorityCounts; }
        
        public Date getStartDate() { return startDate; }
        public void setStartDate(Date startDate) { this.startDate = startDate; }
        
        public Date getEndDate() { return endDate; }
        public void setEndDate(Date endDate) { this.endDate = endDate; }
    }
    
    /**
     * Inner class for appointment report
     */
    public static class AppointmentReport {
        private int totalAppointments;
        private int pendingAppointments;
        private int approvedAppointments;
        private int rejectedAppointments;
        private int completedAppointments;
        private int cancelledAppointments;
        private Map<String, Integer> statusCounts;
        private Map<String, Integer> timeSlotCounts;
        private Date startDate;
        private Date endDate;
        
        // Getters and setters
        public int getTotalAppointments() { return totalAppointments; }
        public void setTotalAppointments(int totalAppointments) { this.totalAppointments = totalAppointments; }
        
        public int getPendingAppointments() { return pendingAppointments; }
        public void setPendingAppointments(int pendingAppointments) { this.pendingAppointments = pendingAppointments; }
        
        public int getApprovedAppointments() { return approvedAppointments; }
        public void setApprovedAppointments(int approvedAppointments) { this.approvedAppointments = approvedAppointments; }
        
        public int getRejectedAppointments() { return rejectedAppointments; }
        public void setRejectedAppointments(int rejectedAppointments) { this.rejectedAppointments = rejectedAppointments; }
        
        public int getCompletedAppointments() { return completedAppointments; }
        public void setCompletedAppointments(int completedAppointments) { this.completedAppointments = completedAppointments; }
        
        public int getCancelledAppointments() { return cancelledAppointments; }
        public void setCancelledAppointments(int cancelledAppointments) { this.cancelledAppointments = cancelledAppointments; }
        
        public Map<String, Integer> getStatusCounts() { return statusCounts; }
        public void setStatusCounts(Map<String, Integer> statusCounts) { this.statusCounts = statusCounts; }
        
        public Map<String, Integer> getTimeSlotCounts() { return timeSlotCounts; }
        public void setTimeSlotCounts(Map<String, Integer> timeSlotCounts) { this.timeSlotCounts = timeSlotCounts; }
        
        public Date getStartDate() { return startDate; }
        public void setStartDate(Date startDate) { this.startDate = startDate; }
        
        public Date getEndDate() { return endDate; }
        public void setEndDate(Date endDate) { this.endDate = endDate; }
    }
    
    /**
     * Inner class for feedback report
     */
    public static class FeedbackReport {
        private int totalFeedback;
        private int pendingFeedback;
        private int respondedFeedback;
        private int escalatedFeedback;
        private int resolvedFeedback;
        private int urgentFeedback;
        private Map<String, Integer> categoryCounts;
        private Map<String, Integer> statusCounts;
        private Date startDate;
        private Date endDate;
        
        // Getters and setters
        public int getTotalFeedback() { return totalFeedback; }
        public void setTotalFeedback(int totalFeedback) { this.totalFeedback = totalFeedback; }
        
        public int getPendingFeedback() { return pendingFeedback; }
        public void setPendingFeedback(int pendingFeedback) { this.pendingFeedback = pendingFeedback; }
        
        public int getRespondedFeedback() { return respondedFeedback; }
        public void setRespondedFeedback(int respondedFeedback) { this.respondedFeedback = respondedFeedback; }
        
        public int getEscalatedFeedback() { return escalatedFeedback; }
        public void setEscalatedFeedback(int escalatedFeedback) { this.escalatedFeedback = escalatedFeedback; }
        
        public int getResolvedFeedback() { return resolvedFeedback; }
        public void setResolvedFeedback(int resolvedFeedback) { this.resolvedFeedback = resolvedFeedback; }
        
        public int getUrgentFeedback() { return urgentFeedback; }
        public void setUrgentFeedback(int urgentFeedback) { this.urgentFeedback = urgentFeedback; }
        
        public Map<String, Integer> getCategoryCounts() { return categoryCounts; }
        public void setCategoryCounts(Map<String, Integer> categoryCounts) { this.categoryCounts = categoryCounts; }
        
        public Map<String, Integer> getStatusCounts() { return statusCounts; }
        public void setStatusCounts(Map<String, Integer> statusCounts) { this.statusCounts = statusCounts; }
        
        public Date getStartDate() { return startDate; }
        public void setStartDate(Date startDate) { this.startDate = startDate; }
        
        public Date getEndDate() { return endDate; }
        public void setEndDate(Date endDate) { this.endDate = endDate; }
    }
    
    /**
     * Inner class for compliance report
     */
    public static class ComplianceReport {
        private int totalBloodUnits;
        private int expiredUnits;
        private int quarantinedUnits;
        private int usableUnits;
        private int totalRequests;
        private int approvedRequests;
        private int rejectedRequests;
        private int totalAppointments;
        private int completedAppointments;
        private int totalDonors;
        private int eligibleDonors;
        private Date reportDate;
        
        // Getters and setters
        public int getTotalBloodUnits() { return totalBloodUnits; }
        public void setTotalBloodUnits(int totalBloodUnits) { this.totalBloodUnits = totalBloodUnits; }
        
        public int getExpiredUnits() { return expiredUnits; }
        public void setExpiredUnits(int expiredUnits) { this.expiredUnits = expiredUnits; }
        
        public int getQuarantinedUnits() { return quarantinedUnits; }
        public void setQuarantinedUnits(int quarantinedUnits) { this.quarantinedUnits = quarantinedUnits; }
        
        public int getUsableUnits() { return usableUnits; }
        public void setUsableUnits(int usableUnits) { this.usableUnits = usableUnits; }
        
        public int getTotalRequests() { return totalRequests; }
        public void setTotalRequests(int totalRequests) { this.totalRequests = totalRequests; }
        
        public int getApprovedRequests() { return approvedRequests; }
        public void setApprovedRequests(int approvedRequests) { this.approvedRequests = approvedRequests; }
        
        public int getRejectedRequests() { return rejectedRequests; }
        public void setRejectedRequests(int rejectedRequests) { this.rejectedRequests = rejectedRequests; }
        
        public int getTotalAppointments() { return totalAppointments; }
        public void setTotalAppointments(int totalAppointments) { this.totalAppointments = totalAppointments; }
        
        public int getCompletedAppointments() { return completedAppointments; }
        public void setCompletedAppointments(int completedAppointments) { this.completedAppointments = completedAppointments; }
        
        public int getTotalDonors() { return totalDonors; }
        public void setTotalDonors(int totalDonors) { this.totalDonors = totalDonors; }
        
        public int getEligibleDonors() { return eligibleDonors; }
        public void setEligibleDonors(int eligibleDonors) { this.eligibleDonors = eligibleDonors; }
        
        public Date getReportDate() { return reportDate; }
        public void setReportDate(Date reportDate) { this.reportDate = reportDate; }
    }
}








