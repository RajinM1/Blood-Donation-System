package com.blooddonation.observer;

import com.blooddonation.dao.AuditLogDAO;
import com.blooddonation.model.AuditLog;

import java.sql.SQLException;
import java.util.Map;

/**
 * Observer that logs all system events to the audit log
 */
public class LoggingObserver implements EventObserver {
    
    private final AuditLogDAO auditLogDAO;
    
    public LoggingObserver() {
        this.auditLogDAO = new AuditLogDAO();
    }
    
    @Override
    public void onEvent(SystemEvent event, Object data) {
        try {
            // Create audit log entry
            AuditLog auditLog = new AuditLog();
            auditLog.setAction(event.name());
            auditLog.setEntityType("SYSTEM_EVENT");
            
            // Extract user ID and entity ID from data if available
            if (data instanceof Map) {
                @SuppressWarnings("unchecked")
                Map<String, Object> eventData = (Map<String, Object>) data;
                
                Integer userId = (Integer) eventData.get("userId");
                if (userId != null) {
                    auditLog.setUserId(userId);
                }
                
                Integer entityId = (Integer) eventData.get("entityId");
                if (entityId != null) {
                    auditLog.setEntityId(entityId);
                }
                
                // Create a summary of the event data
                StringBuilder details = new StringBuilder();
                details.append("Event: ").append(event.getDescription()).append(". ");
                
                for (Map.Entry<String, Object> entry : eventData.entrySet()) {
                    if (!"userId".equals(entry.getKey()) && !"entityId".equals(entry.getKey())) {
                        details.append(entry.getKey()).append(": ").append(entry.getValue()).append(", ");
                    }
                }
                
                auditLog.setDetails(details.toString());
            } else {
                auditLog.setDetails("Event: " + event.getDescription() + ". Data: " + 
                                  (data != null ? data.toString() : "None"));
            }
            
            // Save to audit log
            auditLogDAO.addAuditLog(auditLog);
            
            // Also log to console for immediate visibility
            System.out.println("[AUDIT] " + event.getDescription() + " (Event: " + event.name() + ")");
            
        } catch (SQLException e) {
            // If audit_logs table doesn't exist, just log to console
            if (e.getMessage().contains("doesn't exist")) {
                System.out.println("[AUDIT-CONSOLE] " + event.name() + ": " + event.getDescription());
                System.out.println("[AUDIT-CONSOLE] Note: audit_logs table not found, logging to console only");
                System.out.println("[AUDIT-CONSOLE] Run database_audit_logs_table.sql to create the table");
            } else {
                System.err.println("Error logging event to audit log: " + e.getMessage());
                e.printStackTrace();
            }
        } catch (Exception e) {
            System.err.println("Unexpected error in LoggingObserver: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public String getObserverName() {
        return "LoggingObserver";
    }
}