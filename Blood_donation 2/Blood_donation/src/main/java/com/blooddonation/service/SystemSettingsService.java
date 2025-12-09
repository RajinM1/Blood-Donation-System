package com.blooddonation.service;

import com.blooddonation.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class SystemSettingsService {
    
    private static final Map<String, String> DEFAULT_SETTINGS = new HashMap<>();
    
    static {
        DEFAULT_SETTINGS.put("system_name", "Blood Donation System");
        DEFAULT_SETTINGS.put("system_email", "admin@bloodbank.com");
        DEFAULT_SETTINGS.put("system_phone", "0112345678");
        DEFAULT_SETTINGS.put("min_donation_age", "18");
        DEFAULT_SETTINGS.put("max_donation_age", "65");
        DEFAULT_SETTINGS.put("min_donation_weight", "40.0");
        DEFAULT_SETTINGS.put("donation_interval", "90");
        DEFAULT_SETTINGS.put("blood_expiry_days", "42");
        DEFAULT_SETTINGS.put("low_stock_threshold", "10");
        DEFAULT_SETTINGS.put("email_notifications", "true");
        DEFAULT_SETTINGS.put("sms_notifications", "false");
    }
    
    /**
     * Get all system settings
     */
    public Map<String, String> getAllSettings() throws SQLException {
        Map<String, String> settings = new HashMap<>();
        
        // Initialize settings table if it doesn't exist
        initializeSettingsTable();
        
        String query = "SELECT setting_key, setting_value FROM system_settings";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                settings.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        }
        
        // Fill in any missing settings with defaults
        for (Map.Entry<String, String> entry : DEFAULT_SETTINGS.entrySet()) {
            if (!settings.containsKey(entry.getKey())) {
                settings.put(entry.getKey(), entry.getValue());
            }
        }
        
        return settings;
    }
    
    /**
     * Update a specific setting
     */
    public void updateSetting(String key, String value) throws SQLException {
        initializeSettingsTable();
        
        String query = "INSERT INTO system_settings (setting_key, setting_value) VALUES (?, ?) " +
                      "ON DUPLICATE KEY UPDATE setting_value = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, key);
            stmt.setString(2, value);
            stmt.setString(3, value);
            stmt.executeUpdate();
        }
    }
    
    /**
     * Get a specific setting value
     */
    public String getSetting(String key) throws SQLException {
        Map<String, String> settings = getAllSettings();
        return settings.getOrDefault(key, DEFAULT_SETTINGS.get(key));
    }
    
    /**
     * Reset all settings to default values
     */
    public void resetToDefaults() throws SQLException {
        initializeSettingsTable();
        
        // Clear existing settings
        String clearQuery = "DELETE FROM system_settings";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(clearQuery)) {
            stmt.executeUpdate();
        }
        
        // Insert default settings
        String insertQuery = "INSERT INTO system_settings (setting_key, setting_value) VALUES (?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(insertQuery)) {
            
            for (Map.Entry<String, String> entry : DEFAULT_SETTINGS.entrySet()) {
                stmt.setString(1, entry.getKey());
                stmt.setString(2, entry.getValue());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }
    
    /**
     * Initialize the system_settings table if it doesn't exist
     */
    private void initializeSettingsTable() throws SQLException {
        String createTableQuery = "CREATE TABLE IF NOT EXISTS system_settings (" +
                                 "id INT PRIMARY KEY AUTO_INCREMENT, " +
                                 "setting_key VARCHAR(100) UNIQUE NOT NULL, " +
                                 "setting_value TEXT, " +
                                 "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                                 "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
                                 ")";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(createTableQuery)) {
            stmt.executeUpdate();
        }
    }
    
    /**
     * Check if a setting exists
     */
    public boolean settingExists(String key) throws SQLException {
        String query = "SELECT COUNT(*) FROM system_settings WHERE setting_key = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, key);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }
    
    /**
     * Delete a setting
     */
    public void deleteSetting(String key) throws SQLException {
        String query = "DELETE FROM system_settings WHERE setting_key = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, key);
            stmt.executeUpdate();
        }
    }
    
    /**
     * Get settings by category
     */
    public Map<String, String> getSettingsByCategory(String category) throws SQLException {
        Map<String, String> settings = new HashMap<>();
        Map<String, String> allSettings = getAllSettings();
        
        String prefix = category + "_";
        for (Map.Entry<String, String> entry : allSettings.entrySet()) {
            if (entry.getKey().startsWith(prefix)) {
                settings.put(entry.getKey(), entry.getValue());
            }
        }
        
        return settings;
    }
}





