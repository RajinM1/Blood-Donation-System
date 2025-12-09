package com.blooddonation.dao;

import com.blooddonation.model.AuditLog;
import com.blooddonation.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for audit log operations
 */
public class AuditLogDAO {
    
    public void addAuditLog(AuditLog auditLog) throws SQLException {
        String sql = "INSERT INTO audit_logs (user_id, action, entity_type, entity_id, details, timestamp) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, auditLog.getUserId());
            pstmt.setString(2, auditLog.getAction());
            pstmt.setString(3, auditLog.getEntityType());
            pstmt.setObject(4, auditLog.getEntityId());
            pstmt.setString(5, auditLog.getDetails());
            pstmt.setTimestamp(6, auditLog.getTimestamp());
            
            pstmt.executeUpdate();
        }
    }
    
    public List<AuditLog> getAllAuditLogs() throws SQLException {
        List<AuditLog> auditLogs = new ArrayList<>();
        String sql = "SELECT * FROM audit_logs ORDER BY timestamp DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                AuditLog auditLog = new AuditLog();
                auditLog.setId(rs.getInt("id"));
                auditLog.setUserId((Integer) rs.getObject("user_id"));
                auditLog.setAction(rs.getString("action"));
                auditLog.setEntityType(rs.getString("entity_type"));
                auditLog.setEntityId((Integer) rs.getObject("entity_id"));
                auditLog.setDetails(rs.getString("details"));
                auditLog.setTimestamp(rs.getTimestamp("timestamp"));
                
                auditLogs.add(auditLog);
            }
        }
        
        return auditLogs;
    }
    
    public List<AuditLog> getAuditLogsByUserId(int userId) throws SQLException {
        List<AuditLog> auditLogs = new ArrayList<>();
        String sql = "SELECT * FROM audit_logs WHERE user_id = ? ORDER BY timestamp DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    AuditLog auditLog = new AuditLog();
                    auditLog.setId(rs.getInt("id"));
                    auditLog.setUserId(rs.getInt("user_id"));
                    auditLog.setAction(rs.getString("action"));
                    auditLog.setEntityType(rs.getString("entity_type"));
                    auditLog.setEntityId((Integer) rs.getObject("entity_id"));
                    auditLog.setDetails(rs.getString("details"));
                    auditLog.setTimestamp(rs.getTimestamp("timestamp"));
                    
                    auditLogs.add(auditLog);
                }
            }
        }
        
        return auditLogs;
    }
    
    public List<AuditLog> getAuditLogsByAction(String action) throws SQLException {
        List<AuditLog> auditLogs = new ArrayList<>();
        String sql = "SELECT * FROM audit_logs WHERE action = ? ORDER BY timestamp DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, action);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    AuditLog auditLog = new AuditLog();
                    auditLog.setId(rs.getInt("id"));
                    auditLog.setUserId((Integer) rs.getObject("user_id"));
                    auditLog.setAction(rs.getString("action"));
                    auditLog.setEntityType(rs.getString("entity_type"));
                    auditLog.setEntityId((Integer) rs.getObject("entity_id"));
                    auditLog.setDetails(rs.getString("details"));
                    auditLog.setTimestamp(rs.getTimestamp("timestamp"));
                    
                    auditLogs.add(auditLog);
                }
            }
        }
        
        return auditLogs;
    }
}