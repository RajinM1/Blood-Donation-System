package com.blooddonation.observer;

import com.blooddonation.dao.AlertDAO;
import com.blooddonation.model.Alert;

import java.sql.SQLException;
import java.util.Map;

/**
 * Observer that creates system alerts for critical events
 */
public class AlertObserver implements EventObserver {
    
    private final AlertDAO alertDAO;
    
    public AlertObserver() {
        this.alertDAO = new AlertDAO();
    }
    
    @Override
    public void onEvent(SystemEvent event, Object data) {
        try {
            // Only create alerts for critical events
            switch (event) {
                case BLOOD_STOCK_LOW:
                    createLowStockAlert(data);
                    break;
                case BLOOD_STOCK_EXPIRED:
                    createExpiredStockAlert(data);
                    break;
                case SYSTEM_ALERT:
                    createSystemAlert(data);
                    break;
                default:
                    // Don't create alerts for other events (BLOOD_REPORT_APPROVED, BLOOD_REPORT_REJECTED, BLOOD_STOCK_ADDED)
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in AlertObserver: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void createLowStockAlert(Object data) throws SQLException {
        if (data instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> stockData = (Map<String, Object>) data;
            String bloodGroup = (String) stockData.get("bloodGroup");
            Integer currentStock = (Integer) stockData.get("currentStock");
            
            Alert alert = new Alert();
            alert.setType("STOCK");
            alert.setSeverity("HIGH");
            alert.setTitle("Low Blood Stock Alert");
            alert.setMessage("Blood group " + bloodGroup + " is running low. Current stock: " + 
                           currentStock + " units. Immediate action required.");
            alert.setBloodGroup(bloodGroup);
            alert.setQuantity(currentStock);
            
            alertDAO.addAlert(alert);
            System.out.println("[ALERT] LOW STOCK: " + bloodGroup + " has only " + currentStock + " units remaining!");
        }
    }
    
    private void createExpiredStockAlert(Object data) throws SQLException {
        if (data instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> stockData = (Map<String, Object>) data;
            String bloodGroup = (String) stockData.get("bloodGroup");
            Integer expiredUnits = (Integer) stockData.get("expiredUnits");
            
            Alert alert = new Alert();
            alert.setType("EXPIRY");
            alert.setSeverity("MEDIUM");
            alert.setTitle("Expired Blood Stock");
            alert.setMessage("Blood group " + bloodGroup + " has expired units that need to be disposed. " +
                           "Expired units: " + expiredUnits);
            alert.setBloodGroup(bloodGroup);
            alert.setQuantity(expiredUnits);
            
            alertDAO.addAlert(alert);
            System.out.println("[ALERT] EXPIRED: " + bloodGroup + " (" + expiredUnits + " units) has expired and must be disposed!");
        }
    }
    

    
    private void createSystemAlert(Object data) throws SQLException {
        if (data instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> alertData = (Map<String, Object>) data;
            
            Alert alert = new Alert();
            alert.setType("SYSTEM");
            
            // Check if this is an expiring stock alert
            if (alertData.containsKey("expiryDate") && alertData.containsKey("daysUntilExpiry")) {
                Integer daysUntilExpiry = (Integer) alertData.get("daysUntilExpiry");
                String bloodGroup = (String) alertData.get("bloodGroup");
                Integer quantity = (Integer) alertData.get("quantity");
                
                alert.setSeverity(daysUntilExpiry <= 1 ? "HIGH" : "MEDIUM");
                alert.setTitle("Blood Stock Expiring Soon");
                alert.setMessage("Blood group " + bloodGroup + " (" + quantity + " units) will expire in " + 
                               daysUntilExpiry + " day(s). Please use or dispose soon.");
                alert.setBloodGroup(bloodGroup);
                alert.setQuantity(quantity);
                
                System.out.println("[ALERT] " + bloodGroup + " blood expires in " + daysUntilExpiry + " day(s) - Immediate attention required!");
            } else {
                // Regular system alert
                alert.setSeverity((String) alertData.getOrDefault("severity", "MEDIUM"));
                alert.setTitle((String) alertData.getOrDefault("title", "System Alert"));
                alert.setMessage((String) alertData.getOrDefault("message", "System event occurred"));
                
                String bloodGroup = (String) alertData.get("bloodGroup");
                if (bloodGroup != null) {
                    alert.setBloodGroup(bloodGroup);
                }
                
                Integer quantity = (Integer) alertData.get("quantity");
                if (quantity != null) {
                    alert.setQuantity(quantity);
                }
                
                System.out.println("[ALERT] " + alert.getTitle() + ": " + alert.getMessage());
            }
            
            alertDAO.addAlert(alert);
        }
    }
    
    @Override
    public String getObserverName() {
        return "AlertObserver";
    }
}