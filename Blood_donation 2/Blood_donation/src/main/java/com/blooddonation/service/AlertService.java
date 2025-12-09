package com.blooddonation.service;

import com.blooddonation.dao.AlertDAO;
import com.blooddonation.model.Alert;
import com.blooddonation.util.EmailUtil;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AlertService {
    
    private AlertDAO alertDAO;
    
    public AlertService() {
        this.alertDAO = new AlertDAO();
    }
    
    /**
     * Get all alerts as Map objects for JSP display
     */
    public List<Map<String, Object>> getAllAlerts() throws SQLException {
        List<Alert> alerts = alertDAO.getAllAlerts();
        return convertAlertsToMaps(alerts);
    }
    
    /**
     * Get active alerts as Map objects
     */
    public List<Map<String, Object>> getActiveAlerts() throws SQLException {
        List<Alert> alerts = alertDAO.getActiveAlerts();
        return convertAlertsToMaps(alerts);
    }
    
    /**
     * Get urgent alerts as Map objects
     */
    public List<Map<String, Object>> getUrgentAlerts() throws SQLException {
        List<Alert> alerts = alertDAO.getUrgentAlerts();
        return convertAlertsToMaps(alerts);
    }
    
    /**
     * Get critical alerts as Map objects
     */
    public List<Map<String, Object>> getCriticalAlerts() throws SQLException {
        List<Alert> alerts = alertDAO.getCriticalAlerts();
        return convertAlertsToMaps(alerts);
    }
    
    /**
     * Get resolved alerts as Map objects
     */
    public List<Map<String, Object>> getResolvedAlerts() throws SQLException {
        List<Alert> alerts = alertDAO.getResolvedAlerts();
        return convertAlertsToMaps(alerts);
    }
    
    /**
     * Resolve an alert
     */
    public void resolveAlert(int alertId, int resolvedBy, String resolution) throws SQLException {
        alertDAO.resolveAlert(alertId, resolvedBy, resolution);
    }
    
    /**
     * Dismiss an alert
     */
    public void dismissAlert(int alertId, int dismissedBy) throws SQLException {
        alertDAO.dismissAlert(alertId, dismissedBy);
    }
    
    /**
     * Create a new alert
     */
    public void createAlert(String title, String message, String priority, String type, int createdBy) throws SQLException {
        Alert alert = new Alert();
        alert.setTitle(title);
        alert.setMessage(message);
        alert.setSeverity(priority); // Use severity instead of priority
        alert.setType(type);
        alert.setStatus("ACTIVE");
        alertDAO.addAlert(alert);
    }
    
    /**
     * Send alert email notification
     */
    public boolean sendAlertEmail(int alertId, int sentBy) throws SQLException {
        // Get alert details
        Alert alert = alertDAO.getAlertById(alertId);
        if (alert != null) {
            // Send actual email
            return EmailUtil.sendAlertEmail(alert.getTitle(), alert.getMessage());
        }
        return false;
    }
    
    /**
     * Convert Alert objects to Map objects for JSP display
     */
    private List<Map<String, Object>> convertAlertsToMaps(List<Alert> alerts) {
        List<Map<String, Object>> alertMaps = new ArrayList<>();
        
        for (Alert alert : alerts) {
            Map<String, Object> alertMap = new HashMap<>();
            alertMap.put("id", alert.getId());
            alertMap.put("title", alert.getTitle());
            alertMap.put("message", alert.getMessage());
            alertMap.put("priority", alert.getSeverity()); // Use severity as priority
            alertMap.put("type", alert.getType());
            alertMap.put("status", alert.getStatus());
            alertMap.put("createdAt", alert.getCreatedAt());
            alertMap.put("resolvedAt", alert.getResolvedAt());
            alertMap.put("resolvedBy", alert.getResolvedBy());
            alertMap.put("resolution", alert.getResolution());
            alertMaps.add(alertMap);
        }
        
        return alertMaps;
    }
}