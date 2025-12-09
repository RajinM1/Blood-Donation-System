package com.blooddonation.service;

import com.blooddonation.dao.AlertDAO;
import com.blooddonation.dao.BloodStockDAO;
import com.blooddonation.dao.DonorDAO;
import com.blooddonation.model.Alert;
import com.blooddonation.model.BloodStock;
import com.blooddonation.model.Donor;
import com.blooddonation.util.ValidationUtil;

import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class BloodStockService {
    
    private BloodStockDAO stockDAO;
    private DonorDAO donorDAO;
    private AlertService alertService;
    private AlertDAO alertDAO;
    
    public BloodStockService() {
        this.stockDAO = new BloodStockDAO();
        this.donorDAO = new DonorDAO();
        this.alertService = new AlertService();
        this.alertDAO = new AlertDAO();
    }
    
    /**
     * Add new blood sample
     */
    public boolean addBloodSample(String bloodGroup, int quantity, Date collectionDate, String screeningResult, int donorId, double volume) throws SQLException {
        // Validate input
        if (!ValidationUtil.isValidBloodGroup(bloodGroup)) {
            throw new IllegalArgumentException("Invalid blood group");
        }
        
        if (!ValidationUtil.isValidQuantity(quantity)) {
            throw new IllegalArgumentException("Invalid quantity");
        }
        
        if (volume <= 0) {
            throw new IllegalArgumentException("Volume must be positive");
        }
        
        if (collectionDate == null) {
            throw new IllegalArgumentException("Collection date is required");
        }
        
        if (screeningResult == null || (!screeningResult.equals("NEGATIVE") && !screeningResult.equals("POSITIVE"))) {
            throw new IllegalArgumentException("Screening result must be NEGATIVE or POSITIVE");
        }
        
        // Calculate expiry date (42 days from collection)
        Calendar cal = Calendar.getInstance();
        cal.setTime(collectionDate);
        cal.add(Calendar.DAY_OF_MONTH, 42);
        Date expiryDate = cal.getTime();
        
        // Create blood stock entry
        BloodStock stock = new BloodStock(bloodGroup, quantity, expiryDate, collectionDate, screeningResult, donorId, volume);
        stockDAO.addBloodStock(stock);
        
        // Check for low stock alerts
        checkLowStockAlerts();
        
        return true;
    }
    
    /**
     * Get all blood stock
     */
    public List<BloodStock> getAllBloodStock() throws SQLException {
        return stockDAO.getAllBloodStock();
    }
    
    /**
     * Get usable blood stock
     */
    public List<BloodStock> getUsableBloodStock() throws SQLException {
        return stockDAO.getUsableBloodStock();
    }
    
    /**
     * Get blood stock by group
     */
    public List<BloodStock> getBloodStockByGroup(String bloodGroup) throws SQLException {
        if (!ValidationUtil.isValidBloodGroup(bloodGroup)) {
            throw new IllegalArgumentException("Invalid blood group");
        }
        return stockDAO.getBloodStockByGroup(bloodGroup);
    }
    
    /**
     * Get expiring blood stock
     */
    public List<BloodStock> getExpiringBloodStock(int days) throws SQLException {
        return stockDAO.getExpiringBloodStock(days);
    }
    
    /**
     * Get expired blood stock
     */
    public List<BloodStock> getExpiredBloodStock() throws SQLException {
        return stockDAO.getExpiredBloodStock();
    }
    
    /**
     * Get low stock blood groups
     */
    public List<BloodStock> getLowStockBloodGroups(int threshold) throws SQLException {
        return stockDAO.getLowStockBloodGroups(threshold);
    }
    
    /**
     * Get total units by blood group
     */
    public int getTotalUnitsByBloodGroup(String bloodGroup) throws SQLException {
        if (!ValidationUtil.isValidBloodGroup(bloodGroup)) {
            throw new IllegalArgumentException("Invalid blood group");
        }
        return stockDAO.getTotalUnitsByBloodGroup(bloodGroup);
    }
    
    /**
     * Check if enough stock is available
     */
    public boolean hasEnoughStock(String bloodGroup, int requiredQuantity) throws SQLException {
        if (!ValidationUtil.isValidBloodGroup(bloodGroup)) {
            throw new IllegalArgumentException("Invalid blood group");
        }
        
        if (!ValidationUtil.isValidQuantity(requiredQuantity)) {
            throw new IllegalArgumentException("Invalid quantity");
        }
        
        return stockDAO.hasEnoughStock(bloodGroup, requiredQuantity);
    }
    
    /**
     * Reduce stock after blood request approval
     */
    public boolean reduceStock(String bloodGroup, int quantity) throws SQLException {
        if (!ValidationUtil.isValidBloodGroup(bloodGroup)) {
            throw new IllegalArgumentException("Invalid blood group");
        }
        
        if (!ValidationUtil.isValidQuantity(quantity)) {
            throw new IllegalArgumentException("Invalid quantity");
        }
        
        if (!stockDAO.hasEnoughStock(bloodGroup, quantity)) {
            throw new IllegalArgumentException("Insufficient stock available");
        }
        
        stockDAO.reduceStock(bloodGroup, quantity);
        
        // Check for low stock alerts after reduction
        checkLowStockAlerts();
        
        return true;
    }
    
    /**
     * Update blood stock
     */
    public boolean updateBloodStock(BloodStock stock) throws SQLException {
        if (stock == null) {
            throw new IllegalArgumentException("Blood stock cannot be null");
        }
        
        if (!ValidationUtil.isValidBloodGroup(stock.getBloodGroup())) {
            throw new IllegalArgumentException("Invalid blood group");
        }
        
        if (!ValidationUtil.isValidQuantity(stock.getQuantity())) {
            throw new IllegalArgumentException("Invalid quantity");
        }
        
        stockDAO.updateBloodStock(stock);
        return true;
    }
    
    /**
     * Delete blood stock
     */
    public boolean deleteBloodStock(int stockId) throws SQLException {
        BloodStock stock = stockDAO.getBloodStockById(stockId);
        if (stock == null) {
            return false;
        }
        
        stockDAO.deleteBloodStock(stockId);
        return true;
    }
    
    /**
     * Mark blood as expired
     */
    public boolean markAsExpired(int stockId) throws SQLException {
        BloodStock stock = stockDAO.getBloodStockById(stockId);
        if (stock == null) {
            return false;
        }
        
        stockDAO.markAsExpired(stockId);
        return true;
    }
    
    /**
     * Mark blood as disposed
     */
    public boolean markAsDisposed(int stockId) throws SQLException {
        BloodStock stock = stockDAO.getBloodStockById(stockId);
        if (stock == null) {
            return false;
        }
        
        stockDAO.markAsDisposed(stockId);
        return true;
    }
    
    /**
     * Get blood stock by ID
     */
    public BloodStock getBloodStockById(int stockId) throws SQLException {
        return stockDAO.getBloodStockById(stockId);
    }
    
    /**
     * Check for low stock alerts
     */
    private void checkLowStockAlerts() throws SQLException {
        List<BloodStock> lowStockGroups = stockDAO.getLowStockBloodGroups(5); // 5 unit threshold
        
        for (BloodStock stock : lowStockGroups) {
            String severity = stock.getQuantity() <= 2 ? "CRITICAL" : "HIGH";
            String title = "Low Stock Alert - " + stock.getBloodGroup();
            String message = String.format("Blood group %s is running low. Current stock: %d units.", 
                stock.getBloodGroup(), stock.getQuantity());
            
            // Create alert
            Alert alert = new Alert();
            alert.setType("LOW_STOCK");
            alert.setSeverity(severity);
            alert.setTitle(title);
            alert.setMessage(message);
            alert.setBloodGroup(stock.getBloodGroup());
            alert.setQuantity(stock.getQuantity());
            alert.setCreatedAt(new Date());
            
            alertDAO.addAlert(alert);
        }
    }
    
    /**
     * Process expired blood
     */
    public void processExpiredBlood() throws SQLException {
        List<BloodStock> expiredStocks = stockDAO.getExpiredBloodStock();
        
        for (BloodStock stock : expiredStocks) {
            // Mark as expired
            stockDAO.markAsExpired(stock.getId());
            
            // Create alert
            Alert alert = new Alert();
            alert.setType("EXPIRED_BLOOD");
            alert.setSeverity("HIGH");
            alert.setTitle("Expired Blood - " + stock.getBloodGroup());
            alert.setMessage(String.format("Blood group %s units have expired. Quantity: %d units. Please dispose of expired units.", 
                stock.getBloodGroup(), stock.getQuantity()));
            alert.setBloodGroup(stock.getBloodGroup());
            alert.setQuantity(stock.getQuantity());
            alert.setExpiryDate(stock.getExpiryDate());
            alert.setCreatedAt(new Date());
            
            alertDAO.addAlert(alert);
        }
    }
    
    /**
     * Get blood stock statistics
     */
    public BloodStockStats getBloodStockStats() throws SQLException {
        BloodStockStats stats = new BloodStockStats();
        
        // Get total units by blood group
        String[] bloodGroups = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};
        for (String bloodGroup : bloodGroups) {
            int totalUnits = stockDAO.getTotalUnitsByBloodGroup(bloodGroup);
            stats.setBloodGroupUnits(bloodGroup, totalUnits);
        }
        
        // Get total usable units
        stats.setTotalUsableUnits(stockDAO.getTotalUnits());
        
        // Get expiring units (within 3 days)
        List<BloodStock> expiringStocks = stockDAO.getExpiringBloodStock(3);
        stats.setExpiringUnits(expiringStocks.size());
        
        // Get expired units
        List<BloodStock> expiredStocks = stockDAO.getExpiredBloodStock();
        stats.setExpiredUnits(expiredStocks.size());
        
        // Get low stock groups
        List<BloodStock> lowStockGroups = stockDAO.getLowStockBloodGroups(5);
        stats.setLowStockGroups(lowStockGroups.size());
        
        return stats;
    }
    
    /**
     * Get blood stock summary for dashboard
     */
    public BloodStockSummary getBloodStockSummary() throws SQLException {
        BloodStockSummary summary = new BloodStockSummary();
        
        // Get all usable stock
        List<BloodStock> usableStock = stockDAO.getUsableBloodStock();
        summary.setTotalUsableUnits(usableStock.size());
        
        // Get expiring stock
        List<BloodStock> expiringStock = stockDAO.getExpiringBloodStock(3);
        summary.setExpiringUnits(expiringStock.size());
        
        // Get expired stock
        List<BloodStock> expiredStock = stockDAO.getExpiredBloodStock();
        summary.setExpiredUnits(expiredStock.size());
        
        // Get low stock groups
        List<BloodStock> lowStockGroups = stockDAO.getLowStockBloodGroups(5);
        summary.setLowStockGroups(lowStockGroups.size());
        
        return summary;
    }
    
    /**
     * Search blood stock by donor
     */
    public List<BloodStock> searchBloodStockByDonor(int donorId) throws SQLException {
        List<BloodStock> allStock = stockDAO.getAllBloodStock();
        return allStock.stream()
                .filter(stock -> stock.getDonorId() == donorId)
                .collect(java.util.stream.Collectors.toList());
    }
    
    /**
     * Get blood stock by status
     */
    public List<BloodStock> getBloodStockByStatus(String status) throws SQLException {
        List<BloodStock> allStock = stockDAO.getAllBloodStock();
        return allStock.stream()
                .filter(stock -> status.equals(stock.getStatus()))
                .collect(java.util.stream.Collectors.toList());
    }
    
    /**
     * Inner class for blood stock statistics
     */
    public static class BloodStockStats {
        private java.util.Map<String, Integer> bloodGroupUnits = new java.util.HashMap<>();
        private int totalUsableUnits;
        private int expiringUnits;
        private int expiredUnits;
        private int lowStockGroups;
        
        // Getters and setters
        public java.util.Map<String, Integer> getBloodGroupUnits() { return bloodGroupUnits; }
        public void setBloodGroupUnits(String bloodGroup, int units) { this.bloodGroupUnits.put(bloodGroup, units); }
        
        public int getTotalUsableUnits() { return totalUsableUnits; }
        public void setTotalUsableUnits(int totalUsableUnits) { this.totalUsableUnits = totalUsableUnits; }
        
        public int getExpiringUnits() { return expiringUnits; }
        public void setExpiringUnits(int expiringUnits) { this.expiringUnits = expiringUnits; }
        
        public int getExpiredUnits() { return expiredUnits; }
        public void setExpiredUnits(int expiredUnits) { this.expiredUnits = expiredUnits; }
        
        public int getLowStockGroups() { return lowStockGroups; }
        public void setLowStockGroups(int lowStockGroups) { this.lowStockGroups = lowStockGroups; }
    }
    
    /**
     * Inner class for blood stock summary
     */
    public static class BloodStockSummary {
        private int totalUsableUnits;
        private int expiringUnits;
        private int expiredUnits;
        private int lowStockGroups;
        
        // Getters and setters
        public int getTotalUsableUnits() { return totalUsableUnits; }
        public void setTotalUsableUnits(int totalUsableUnits) { this.totalUsableUnits = totalUsableUnits; }
        
        public int getExpiringUnits() { return expiringUnits; }
        public void setExpiringUnits(int expiringUnits) { this.expiringUnits = expiringUnits; }
        
        public int getExpiredUnits() { return expiredUnits; }
        public void setExpiredUnits(int expiredUnits) { this.expiredUnits = expiredUnits; }
        
        public int getLowStockGroups() { return lowStockGroups; }
        public void setLowStockGroups(int lowStockGroups) { this.lowStockGroups = lowStockGroups; }
    }
    
    /**
     * Check for blood units expiring soon (static method for scheduler)
     */
    public static void checkExpiringBlood() {
        try {
            BloodStockService service = new BloodStockService();
            service.checkExpiringBloodUnits();
        } catch (Exception e) {
            System.err.println("Error checking expiring blood: " + e.getMessage());
        }
    }
    
    /**
     * Check for low stock levels (static method for scheduler)
     */
    public static void checkLowStock() {
        try {
            BloodStockService service = new BloodStockService();
            service.checkLowStockLevels();
        } catch (Exception e) {
            System.err.println("Error checking low stock: " + e.getMessage());
        }
    }
    
    /**
     * Check for blood units expiring soon
     */
    public void checkExpiringBloodUnits() throws SQLException {
        List<BloodStock> allStock = stockDAO.getAllBloodStock();
        java.util.Date now = new java.util.Date();
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(now);
        cal.add(java.util.Calendar.DAY_OF_MONTH, 3); // Check units expiring in next 3 days
        java.util.Date expiryThreshold = cal.getTime();
        
        for (BloodStock stock : allStock) {
            if (stock.getExpiryDate() != null && stock.getExpiryDate().before(expiryThreshold)) {
                // Create alert for expiring blood
                Alert alert = new Alert();
                alert.setType("EXPIRY_WARNING");
                alert.setSeverity("HIGH");
                alert.setTitle("Blood Expiring Soon");
                alert.setMessage("Blood group " + stock.getBloodGroup() + " is expiring on " + stock.getExpiryDate());
                alert.setBloodGroup(stock.getBloodGroup());
                alert.setQuantity(stock.getQuantity());
                alert.setExpiryDate(stock.getExpiryDate());
                alert.setStatus("ACTIVE");
                alert.setCreatedAt(now);
                
                try {
                    alertDAO.addAlert(alert);
                } catch (SQLException e) {
                    System.err.println("Error creating expiry alert: " + e.getMessage());
                }
            }
        }
    }
    
    /**
     * Check for low stock levels
     */
    public void checkLowStockLevels() throws SQLException {
        List<BloodStock> allStock = stockDAO.getAllBloodStock();
        int lowStockThreshold = 10; // Default threshold
        
        for (BloodStock stock : allStock) {
            if (stock.getQuantity() < lowStockThreshold) {
                // Create alert for low stock
                Alert alert = new Alert();
                alert.setType("LOW_STOCK");
                alert.setSeverity("MEDIUM");
                alert.setTitle("Low Stock Alert");
                alert.setMessage("Blood group " + stock.getBloodGroup() + " is running low. Current stock: " + stock.getQuantity() + " units");
                alert.setBloodGroup(stock.getBloodGroup());
                alert.setQuantity(stock.getQuantity());
                alert.setStatus("ACTIVE");
                alert.setCreatedAt(new java.util.Date());
                
                try {
                    alertDAO.addAlert(alert);
                } catch (SQLException e) {
                    System.err.println("Error creating low stock alert: " + e.getMessage());
                }
            }
        }
    }
}


