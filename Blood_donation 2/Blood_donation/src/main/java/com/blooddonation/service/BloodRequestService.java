package com.blooddonation.service;

import com.blooddonation.dao.BloodRequestDAO;
import com.blooddonation.dao.BloodStockDAO;
import com.blooddonation.dao.DonorDAO;
import com.blooddonation.model.BloodRequest;
import com.blooddonation.model.BloodStock;
import com.blooddonation.util.ValidationUtil;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

public class BloodRequestService {
    
    private BloodRequestDAO requestDAO;
    private BloodStockDAO stockDAO;
    private DonorDAO donorDAO;
    private NotificationService notificationService;
    
    public BloodRequestService() {
        this.requestDAO = new BloodRequestDAO();
        this.stockDAO = new BloodStockDAO();
        this.donorDAO = new DonorDAO();
        this.notificationService = new NotificationService();
    }
    
    /**
     * Submit a new blood request
     */
    public boolean submitBloodRequest(int hospitalId, String bloodGroup, int quantity, String urgency, String patientName, String reason) throws SQLException {
        // Validate input
        if (!ValidationUtil.isValidBloodGroup(bloodGroup)) {
            throw new IllegalArgumentException("Invalid blood group");
        }
        
        if (!ValidationUtil.isValidQuantity(quantity)) {
            throw new IllegalArgumentException("Invalid quantity");
        }
        
        if (!ValidationUtil.isValidUrgency(urgency)) {
            throw new IllegalArgumentException("Invalid urgency level");
        }
        
        // Check for duplicate request
        if (requestDAO.isDuplicateRequest(hospitalId, bloodGroup, quantity, new Date())) {
            throw new IllegalArgumentException("Duplicate request detected");
        }
        
        // Create blood request
        BloodRequest request = new BloodRequest(hospitalId, bloodGroup, quantity, urgency, patientName);
        request.setReason(reason);
        requestDAO.addBloodRequest(request);
        
        // Check stock availability
        if (stockDAO.hasEnoughStock(bloodGroup, quantity)) {
            // Auto-approve if stock is available
            approveBloodRequest(request.getId(), 1); // Assuming user ID 1 is a manager
        } else {
            // Put on hold if insufficient stock
            requestDAO.putOnHold(request.getId(), "Insufficient stock available");
        }
        
        return true;
    }
    
    /**
     * Approve a blood request
     */
    public boolean approveBloodRequest(int requestId, int approvedBy) throws SQLException {
        BloodRequest request = requestDAO.getBloodRequestById(requestId);
        if (request == null || !request.isPending()) {
            return false;
        }
        
        // Check stock availability again
        if (!stockDAO.hasEnoughStock(request.getBloodGroup(), request.getQuantity())) {
            requestDAO.putOnHold(requestId, "Insufficient stock available");
            return false;
        }
        
        // Approve the request
        requestDAO.approveBloodRequest(requestId, approvedBy);
        
        // Reduce stock
        stockDAO.reduceStock(request.getBloodGroup(), request.getQuantity());
        
        // Send approval notification
        notificationService.sendBloodRequestApproval(request.getHospitalId(), 
            request.getBloodGroup(), request.getQuantity());
        
        return true;
    }
    
    /**
     * Reject a blood request
     */
    public boolean rejectBloodRequest(int requestId, int rejectedBy, String rejectionReason) throws SQLException {
        BloodRequest request = requestDAO.getBloodRequestById(requestId);
        if (request == null || !request.isPending()) {
            return false;
        }
        
        // Reject the request
        requestDAO.rejectBloodRequest(requestId, rejectedBy, rejectionReason);
        
        // Send rejection notification
        notificationService.sendBloodRequestRejection(request.getHospitalId(), 
            request.getBloodGroup(), request.getQuantity(), rejectionReason);
        
        return true;
    }
    
    /**
     * Complete a blood request
     */
    public boolean completeBloodRequest(int requestId) throws SQLException {
        BloodRequest request = requestDAO.getBloodRequestById(requestId);
        if (request == null || !request.isApproved()) {
            return false;
        }
        
        requestDAO.completeBloodRequest(requestId);
        return true;
    }
    
    /**
     * Get all blood requests
     */
    public List<BloodRequest> getAllBloodRequests() throws SQLException {
        return requestDAO.getAllBloodRequests();
    }
    
    /**
     * Get blood requests by hospital
     */
    public List<BloodRequest> getBloodRequestsByHospital(int hospitalId) throws SQLException {
        return requestDAO.getBloodRequestsByHospitalId(hospitalId);
    }
    
    /**
     * Get pending blood requests
     */
    public List<BloodRequest> getPendingBloodRequests() throws SQLException {
        return requestDAO.getPendingBloodRequests();
    }
    
    /**
     * Get approved blood requests
     */
    public List<BloodRequest> getApprovedBloodRequests() throws SQLException {
        return requestDAO.getApprovedBloodRequests();
    }
    
    /**
     * Get rejected blood requests
     */
    public List<BloodRequest> getRejectedBloodRequests() throws SQLException {
        return requestDAO.getRejectedBloodRequests();
    }
    
    /**
     * Get on-hold blood requests
     */
    public List<BloodRequest> getOnHoldBloodRequests() throws SQLException {
        return requestDAO.getOnHoldBloodRequests();
    }
    
    /**
     * Get blood requests by status
     */
    public List<BloodRequest> getBloodRequestsByStatus(String status) throws SQLException {
        return requestDAO.getBloodRequestsByStatus(status);
    }
    
    /**
     * Get blood requests by urgency
     */
    public List<BloodRequest> getBloodRequestsByUrgency(String urgency) throws SQLException {
        return requestDAO.getBloodRequestsByUrgency(urgency);
    }
    
    /**
     * Get blood requests by blood group
     */
    public List<BloodRequest> getBloodRequestsByBloodGroup(String bloodGroup) throws SQLException {
        return requestDAO.getBloodRequestsByBloodGroup(bloodGroup);
    }
    
    /**
     * Get critical blood requests
     */
    public List<BloodRequest> getCriticalBloodRequests() throws SQLException {
        return requestDAO.getCriticalBloodRequests();
    }
    
    /**
     * Get high priority blood requests
     */
    public List<BloodRequest> getHighPriorityBloodRequests() throws SQLException {
        return requestDAO.getHighPriorityBloodRequests();
    }
    
    /**
     * Get blood request by ID
     */
    public BloodRequest getBloodRequestById(int requestId) throws SQLException {
        return requestDAO.getBloodRequestById(requestId);
    }
    
    /**
     * Update blood request
     */
    public boolean updateBloodRequest(int requestId, String bloodGroup, int quantity, String urgency, String patientName, String reason) throws SQLException {
        BloodRequest request = requestDAO.getBloodRequestById(requestId);
        if (request == null || !request.canBeEdited()) {
            return false;
        }
        
        // Validate input
        if (!ValidationUtil.isValidBloodGroup(bloodGroup)) {
            throw new IllegalArgumentException("Invalid blood group");
        }
        
        if (!ValidationUtil.isValidQuantity(quantity)) {
            throw new IllegalArgumentException("Invalid quantity");
        }
        
        if (!ValidationUtil.isValidUrgency(urgency)) {
            throw new IllegalArgumentException("Invalid urgency level");
        }
        
        request.setBloodGroup(bloodGroup);
        request.setQuantity(quantity);
        request.setUrgency(urgency);
        request.setPatientName(patientName);
        request.setReason(reason);
        
        requestDAO.updateBloodRequest(request);
        return true;
    }
    
    /**
     * Delete blood request
     */
    public boolean deleteBloodRequest(int requestId) throws SQLException {
        BloodRequest request = requestDAO.getBloodRequestById(requestId);
        if (request == null || !request.canBeEdited()) {
            return false;
        }
        
        requestDAO.deleteBloodRequest(requestId);
        return true;
    }
    
    /**
     * Get blood request statistics
     */
    public BloodRequestStats getBloodRequestStats() throws SQLException {
        BloodRequestStats stats = new BloodRequestStats();
        stats.setPendingCount(requestDAO.getRequestCountByStatus("PENDING"));
        stats.setApprovedCount(requestDAO.getRequestCountByStatus("APPROVED"));
        stats.setRejectedCount(requestDAO.getRequestCountByStatus("REJECTED"));
        stats.setOnHoldCount(requestDAO.getRequestCountByStatus("ON_HOLD"));
        stats.setCompletedCount(requestDAO.getRequestCountByStatus("COMPLETED"));
        return stats;
    }
    
    /**
     * Check stock availability for a blood request
     */
    public boolean checkStockAvailability(String bloodGroup, int quantity) throws SQLException {
        return stockDAO.hasEnoughStock(bloodGroup, quantity);
    }
    
    /**
     * Get available stock for a blood group
     */
    public int getAvailableStock(String bloodGroup) throws SQLException {
        return stockDAO.getTotalUnitsByBloodGroup(bloodGroup);
    }
    
    /**
     * Process on-hold requests when stock becomes available
     */
    public void processOnHoldRequests() throws SQLException {
        List<BloodRequest> onHoldRequests = requestDAO.getOnHoldBloodRequests();
        
        for (BloodRequest request : onHoldRequests) {
            if (stockDAO.hasEnoughStock(request.getBloodGroup(), request.getQuantity())) {
                // Auto-approve if stock is now available
                approveBloodRequest(request.getId(), 1); // Assuming user ID 1 is a manager
            }
        }
    }
    
    /**
     * Get blood request statistics for dashboard
     */
    public BloodRequestStats getDashboardStats() throws SQLException {
        return getBloodRequestStats();
    }
    
    /**
     * Inner class for blood request statistics
     */
    public static class BloodRequestStats {
        private int pendingCount;
        private int approvedCount;
        private int rejectedCount;
        private int onHoldCount;
        private int completedCount;
        
        // Getters and setters
        public int getPendingCount() { return pendingCount; }
        public void setPendingCount(int pendingCount) { this.pendingCount = pendingCount; }
        
        public int getApprovedCount() { return approvedCount; }
        public void setApprovedCount(int approvedCount) { this.approvedCount = approvedCount; }
        
        public int getRejectedCount() { return rejectedCount; }
        public void setRejectedCount(int rejectedCount) { this.rejectedCount = rejectedCount; }
        
        public int getOnHoldCount() { return onHoldCount; }
        public void setOnHoldCount(int onHoldCount) { this.onHoldCount = onHoldCount; }
        
        public int getCompletedCount() { return completedCount; }
        public void setCompletedCount(int completedCount) { this.completedCount = completedCount; }
    }
}










