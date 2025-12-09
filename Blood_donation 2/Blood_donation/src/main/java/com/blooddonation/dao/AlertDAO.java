package com.blooddonation.dao;

import com.blooddonation.model.Alert;
import com.blooddonation.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AlertDAO {
    
    public void addAlert(Alert alert) throws SQLException {
        String query = "INSERT INTO alerts (type, severity, title, message, blood_group, quantity, expiry_date, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, alert.getType());
            stmt.setString(2, alert.getSeverity());
            stmt.setString(3, alert.getTitle());
            stmt.setString(4, alert.getMessage());
            stmt.setString(5, alert.getBloodGroup());
            stmt.setInt(6, alert.getQuantity());
            stmt.setDate(7, alert.getExpiryDate() != null ? new java.sql.Date(alert.getExpiryDate().getTime()) : null);
            stmt.setString(8, alert.getStatus());
            stmt.setTimestamp(9, alert.getCreatedAt() != null ? new java.sql.Timestamp(alert.getCreatedAt().getTime()) : new java.sql.Timestamp(System.currentTimeMillis()));
            stmt.executeUpdate();
        }
    }
    
    public List<Alert> getAllAlerts() throws SQLException {
        List<Alert> alerts = new ArrayList<>();
        String query = "SELECT * FROM alerts ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Alert alert = mapResultSetToAlert(rs);
                alerts.add(alert);
            }
        }
        return alerts;
    }
    
    public List<Alert> getActiveAlerts() throws SQLException {
        List<Alert> alerts = new ArrayList<>();
        String query = "SELECT * FROM alerts WHERE status = 'ACTIVE' ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Alert alert = mapResultSetToAlert(rs);
                alerts.add(alert);
            }
        }
        return alerts;
    }
    
    public List<Alert> getAlertsByType(String type) throws SQLException {
        List<Alert> alerts = new ArrayList<>();
        String query = "SELECT * FROM alerts WHERE type = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, type);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Alert alert = mapResultSetToAlert(rs);
                    alerts.add(alert);
                }
            }
        }
        return alerts;
    }
    
    public List<Alert> getAlertsBySeverity(String severity) throws SQLException {
        List<Alert> alerts = new ArrayList<>();
        String query = "SELECT * FROM alerts WHERE severity = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, severity);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Alert alert = mapResultSetToAlert(rs);
                    alerts.add(alert);
                }
            }
        }
        return alerts;
    }
    
    public Alert getAlertById(int alertId) throws SQLException {
        String query = "SELECT * FROM alerts WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, alertId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAlert(rs);
                }
            }
        }
        return null;
    }
    
    public void acknowledgeAlert(int alertId, int userId) throws SQLException {
        String query = "UPDATE alerts SET status = 'ACKNOWLEDGED', acknowledged_by = ?, acknowledged_at = NOW(), updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, alertId);
            stmt.executeUpdate();
        }
    }
    
    public void escalateAlert(int alertId, int userId) throws SQLException {
        String query = "UPDATE alerts SET status = 'ESCALATED', escalated_to = ?, escalated_at = NOW(), updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, alertId);
            stmt.executeUpdate();
        }
    }
    
    public void resolveAlert(int alertId, int userId, String resolution) throws SQLException {
        // First try with resolution column
        try {
            String query = "UPDATE alerts SET status = 'RESOLVED', resolved_by = ?, resolution = ?, resolved_at = NOW(), updated_at = NOW() WHERE id = ?";
            try (Connection conn = DatabaseUtil.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, userId);
                stmt.setString(2, resolution);
                stmt.setInt(3, alertId);
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            // If resolution column doesn't exist, update without it
            if (e.getMessage().contains("resolution") || e.getMessage().contains("Unknown column")) {
                String query = "UPDATE alerts SET status = 'RESOLVED', resolved_by = ?, resolved_at = NOW(), updated_at = NOW() WHERE id = ?";
                try (Connection conn = DatabaseUtil.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setInt(1, userId);
                    stmt.setInt(2, alertId);
                    stmt.executeUpdate();
                }
            } else {
                throw e;
            }
        }
    }
    
    public List<Alert> getLowStockAlerts() throws SQLException {
        return getAlertsByType("LOW_STOCK");
    }
    
    public List<Alert> getExpiryAlerts() throws SQLException {
        return getAlertsByType("EXPIRY_WARNING");
    }
    
    public List<Alert> getCriticalAlerts() throws SQLException {
        return getAlertsBySeverity("CRITICAL");
    }
    
    public void deleteAlert(int alertId) throws SQLException {
        String query = "DELETE FROM alerts WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, alertId);
            stmt.executeUpdate();
        }
    }
    
    public int getActiveAlertCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM alerts WHERE status = 'ACTIVE'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public List<Alert> getAlertsForUser(int userId) throws SQLException {
        List<Alert> alerts = new ArrayList<>();
        String query = "SELECT * FROM alerts WHERE (acknowledged_by = ? OR escalated_to = ? OR resolved_by = ?) ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Alert alert = mapResultSetToAlert(rs);
                    alerts.add(alert);
                }
            }
        }
        return alerts;
    }
    
    private Alert mapResultSetToAlert(ResultSet rs) throws SQLException {
        Alert alert = new Alert();
        alert.setId(rs.getInt("id"));
        alert.setType(rs.getString("type"));
        alert.setSeverity(rs.getString("severity"));
        alert.setTitle(rs.getString("title"));
        alert.setMessage(rs.getString("message"));
        alert.setBloodGroup(rs.getString("blood_group"));
        alert.setQuantity(rs.getInt("quantity"));
        alert.setExpiryDate(rs.getDate("expiry_date"));
        alert.setStatus(rs.getString("status"));
        
        // Handle nullable columns safely
        int acknowledgedBy = rs.getInt("acknowledged_by");
        if (!rs.wasNull()) {
            alert.setAcknowledgedBy(acknowledgedBy);
        }
        alert.setAcknowledgedAt(rs.getTimestamp("acknowledged_at"));
        
        int resolvedBy = rs.getInt("resolved_by");
        if (!rs.wasNull()) {
            alert.setResolvedBy(resolvedBy);
        }
        alert.setResolvedAt(rs.getTimestamp("resolved_at"));
        
        alert.setCreatedAt(rs.getTimestamp("created_at"));
        alert.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Handle resolution column safely
        try {
            alert.setResolution(rs.getString("resolution"));
        } catch (SQLException e) {
            // Column doesn't exist, set to null
            alert.setResolution(null);
        }
        
        // Set default values for columns that don't exist in the current schema
        alert.setEscalatedTo(0);
        alert.setEscalatedAt(null);
        
        return alert;
    }
    
    public void dismissAlert(int alertId, int userId) throws SQLException {
        String query = "UPDATE alerts SET status = 'DISMISSED', resolved_by = ?, resolved_at = NOW(), updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, alertId);
            stmt.executeUpdate();
        }
    }
    
    public List<Alert> getUrgentAlerts() throws SQLException {
        List<Alert> alerts = new ArrayList<>();
        String query = "SELECT * FROM alerts WHERE severity = 'URGENT' AND status = 'ACTIVE' ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Alert alert = mapResultSetToAlert(rs);
                alerts.add(alert);
            }
        }
        return alerts;
    }
    
    public List<Alert> getResolvedAlerts() throws SQLException {
        List<Alert> alerts = new ArrayList<>();
        String query = "SELECT * FROM alerts WHERE status = 'RESOLVED' ORDER BY resolved_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Alert alert = mapResultSetToAlert(rs);
                alerts.add(alert);
            }
        }
        return alerts;
    }
}





