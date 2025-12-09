package com.blooddonation.dao;

import com.blooddonation.model.Notification;
import com.blooddonation.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
    
    public void addNotification(Notification notification) throws SQLException {
        String query = "INSERT INTO notifications (user_id, title, message, type, channel, priority, is_read, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, notification.getUserId());
            stmt.setString(2, notification.getTitle() != null ? notification.getTitle() : "Notification");
            stmt.setString(3, notification.getMessage());
            stmt.setString(4, notification.getType());
            stmt.setString(5, notification.getChannel());
            stmt.setString(6, notification.getPriority());
            stmt.setBoolean(7, notification.isRead());
            stmt.setTimestamp(8, notification.getCreatedAt() != null ? new java.sql.Timestamp(notification.getCreatedAt().getTime()) : new java.sql.Timestamp(System.currentTimeMillis()));
            stmt.executeUpdate();
        }
    }
    
    public List<Notification> getNotificationsByUserId(int userId) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String query = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Notification notification = mapResultSetToNotification(rs);
                    notifications.add(notification);
                }
            }
        }
        return notifications;
    }
    
    public List<Notification> getUnreadNotifications(int userId) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String query = "SELECT * FROM notifications WHERE user_id = ? AND is_read = FALSE ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Notification notification = mapResultSetToNotification(rs);
                    notifications.add(notification);
                }
            }
        }
        return notifications;
    }
    
    public List<Notification> getNotificationsByType(String type) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String query = "SELECT * FROM notifications WHERE type = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, type);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Notification notification = mapResultSetToNotification(rs);
                    notifications.add(notification);
                }
            }
        }
        return notifications;
    }
    
    public List<Notification> getFailedNotifications() throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String query = "SELECT * FROM notifications WHERE is_read = FALSE ORDER BY created_at ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Notification notification = mapResultSetToNotification(rs);
                notifications.add(notification);
            }
        }
        return notifications;
    }
    
    public List<Notification> getScheduledNotifications() throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String query = "SELECT * FROM notifications WHERE is_read = FALSE ORDER BY created_at ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Notification notification = mapResultSetToNotification(rs);
                notifications.add(notification);
            }
        }
        return notifications;
    }
    
    public void markAsRead(int notificationId) throws SQLException {
        String query = "UPDATE notifications SET is_read = TRUE, read_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, notificationId);
            stmt.executeUpdate();
        }
    }
    
    public void markAsSent(int notificationId) throws SQLException {
        String query = "UPDATE notifications SET is_read = TRUE WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, notificationId);
            stmt.executeUpdate();
        }
    }
    
    public void markAsFailed(int notificationId, String errorMessage) throws SQLException {
        String query = "UPDATE notifications SET is_read = FALSE WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, notificationId);
            stmt.executeUpdate();
        }
    }
    
    public void deleteNotification(int notificationId) throws SQLException {
        String query = "DELETE FROM notifications WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, notificationId);
            stmt.executeUpdate();
        }
    }
    
    public void deleteOldNotifications(int daysOld) throws SQLException {
        String query = "DELETE FROM notifications WHERE created_at < DATE_SUB(NOW(), INTERVAL ? DAY)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, daysOld);
            stmt.executeUpdate();
        }
    }
    
    public int getUnreadCount(int userId) throws SQLException {
        String query = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    public List<Notification> getUrgentNotifications() throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String query = "SELECT * FROM notifications WHERE priority = 'URGENT' AND is_read = FALSE ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Notification notification = mapResultSetToNotification(rs);
                notifications.add(notification);
            }
        }
        return notifications;
    }
    
    public List<Notification> getAllNotifications() throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String query = "SELECT * FROM notifications ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Notification notification = mapResultSetToNotification(rs);
                notifications.add(notification);
            }
        }
        return notifications;
    }
    
    public void sendAppointmentReminder(int donorId, String message, String appointmentDate) throws SQLException {
        Notification notification = new Notification();
        notification.setUserId(donorId);
        notification.setMessage(message);
        notification.setType("APPOINTMENT");
        notification.setChannel("SMS");
        notification.setPriority("MEDIUM");
        addNotification(notification);
    }
    
    public void sendConfirmationNotification(int userId, String message) throws SQLException {
        Notification notification = new Notification();
        notification.setUserId(userId);
        notification.setMessage(message);
        notification.setType("SYSTEM");
        notification.setChannel("EMAIL");
        notification.setPriority("LOW");
        addNotification(notification);
    }
    
    public void sendAlertNotification(int userId, String message) throws SQLException {
        Notification notification = new Notification();
        notification.setUserId(userId);
        notification.setMessage(message);
        notification.setType("ALERT");
        notification.setChannel("SMS");
        notification.setPriority("HIGH");
        addNotification(notification);
    }
    
    private Notification mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setId(rs.getInt("id"));
        notification.setUserId(rs.getInt("user_id"));
        notification.setTitle(rs.getString("title"));
        notification.setMessage(rs.getString("message"));
        notification.setType(rs.getString("type"));
        notification.setChannel(rs.getString("channel"));
        notification.setPriority(rs.getString("priority"));
        notification.setRead(rs.getBoolean("is_read"));
        notification.setReadAt(rs.getTimestamp("read_at"));
        notification.setExpiresAt(rs.getTimestamp("expires_at"));
        notification.setActionUrl(rs.getString("action_url"));
        notification.setCreatedAt(rs.getTimestamp("created_at"));
        return notification;
    }
}