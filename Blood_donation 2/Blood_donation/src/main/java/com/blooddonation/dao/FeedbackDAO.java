package com.blooddonation.dao;

import com.blooddonation.model.Feedback;
import com.blooddonation.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    
    public void addFeedback(Feedback feedback) throws SQLException {
        String query = "INSERT INTO feedback (user_id, feedback_text, category, status, is_urgent, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, feedback.getUserId());
            stmt.setString(2, feedback.getFeedbackText());
            stmt.setString(3, feedback.getCategory());
            stmt.setString(4, feedback.getStatus());
            stmt.setBoolean(5, feedback.isUrgent());
            stmt.setTimestamp(6, feedback.getCreatedAt() != null ? new java.sql.Timestamp(feedback.getCreatedAt().getTime()) : new java.sql.Timestamp(System.currentTimeMillis()));
            stmt.executeUpdate();
        }
    }
    
    public List<Feedback> getAllFeedback() throws SQLException {
        List<Feedback> feedbacks = new ArrayList<>();
        String query = "SELECT * FROM feedback ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Feedback feedback = mapResultSetToFeedback(rs);
                feedbacks.add(feedback);
            }
        }
        return feedbacks;
    }
    
    public List<Feedback> getFeedbackByUserId(int userId) throws SQLException {
        List<Feedback> feedbacks = new ArrayList<>();
        String query = "SELECT * FROM feedback WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Feedback feedback = mapResultSetToFeedback(rs);
                    feedbacks.add(feedback);
                }
            }
        }
        return feedbacks;
    }
    
    public List<Feedback> getPendingFeedback() throws SQLException {
        List<Feedback> feedbacks = new ArrayList<>();
        String query = "SELECT * FROM feedback WHERE status = 'PENDING' ORDER BY created_at ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Feedback feedback = mapResultSetToFeedback(rs);
                feedbacks.add(feedback);
            }
        }
        return feedbacks;
    }
    
    public List<Feedback> getUrgentFeedback() throws SQLException {
        List<Feedback> feedbacks = new ArrayList<>();
        String query = "SELECT * FROM feedback WHERE is_urgent = true AND status = 'PENDING' ORDER BY created_at ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Feedback feedback = mapResultSetToFeedback(rs);
                feedbacks.add(feedback);
            }
        }
        return feedbacks;
    }
    
    public List<Feedback> getFeedbackByCategory(String category) throws SQLException {
        List<Feedback> feedbacks = new ArrayList<>();
        String query = "SELECT * FROM feedback WHERE category = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, category);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Feedback feedback = mapResultSetToFeedback(rs);
                    feedbacks.add(feedback);
                }
            }
        }
        return feedbacks;
    }
    
    public Feedback getFeedbackById(int feedbackId) throws SQLException {
        String query = "SELECT * FROM feedback WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, feedbackId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToFeedback(rs);
                }
            }
        }
        return null;
    }
    
    public void respondToFeedback(int feedbackId, int respondedBy, String response) throws SQLException {
        String query = "UPDATE feedback SET status = 'RESPONDED', response = ?, responded_by = ?, response_date = NOW(), updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, response);
            stmt.setInt(2, respondedBy);
            stmt.setInt(3, feedbackId);
            stmt.executeUpdate();
        }
    }
    
    public void escalateFeedback(int feedbackId, int escalatedTo) throws SQLException {
        String query = "UPDATE feedback SET status = 'ESCALATED', escalated_to = ?, escalated_at = NOW(), updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, escalatedTo);
            stmt.setInt(2, feedbackId);
            stmt.executeUpdate();
        }
    }
    
    public void resolveFeedback(int feedbackId, int resolvedBy) throws SQLException {
        String query = "UPDATE feedback SET status = 'RESOLVED', resolved_by = ?, resolved_at = NOW(), updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, resolvedBy);
            stmt.setInt(2, feedbackId);
            stmt.executeUpdate();
        }
    }
    
    public void updateFeedback(Feedback feedback) throws SQLException {
        String query = "UPDATE feedback SET feedback_text = ?, category = ?, is_urgent = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, feedback.getFeedbackText());
            stmt.setString(2, feedback.getCategory());
            stmt.setBoolean(3, feedback.isUrgent());
            stmt.setInt(4, feedback.getId());
            stmt.executeUpdate();
        }
    }
    
    public void deleteFeedback(int feedbackId) throws SQLException {
        String query = "DELETE FROM feedback WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, feedbackId);
            stmt.executeUpdate();
        }
    }
    
    public int getPendingFeedbackCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM feedback WHERE status = 'PENDING'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int getUrgentFeedbackCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM feedback WHERE is_urgent = true AND status = 'PENDING'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public List<Feedback> getRecentFeedback(int limit) throws SQLException {
        List<Feedback> feedbacks = new ArrayList<>();
        String query = "SELECT * FROM feedback ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    feedbacks.add(mapResultSetToFeedback(rs));
                }
            }
        }
        return feedbacks;
    }
    
    public List<Feedback> getFeedbackByStatus(String status) throws SQLException {
        List<Feedback> feedbacks = new ArrayList<>();
        String query = "SELECT * FROM feedback WHERE status = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Feedback feedback = mapResultSetToFeedback(rs);
                    feedbacks.add(feedback);
                }
            }
        }
        return feedbacks;
    }
    
    public List<Feedback> getFeedbackForUser(int userId) throws SQLException {
        List<Feedback> feedbacks = new ArrayList<>();
        String query = "SELECT * FROM feedback WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Feedback feedback = mapResultSetToFeedback(rs);
                    feedbacks.add(feedback);
                }
            }
        }
        return feedbacks;
    }
    
    public void updateFeedbackStatus(int feedbackId, String status, String response, int respondedBy) throws SQLException {
        String query = "UPDATE feedback SET status = ?, response = ?, responded_by = ?, response_date = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setString(2, response);
            stmt.setInt(3, respondedBy);
            stmt.setInt(4, feedbackId);
            stmt.executeUpdate();
        }
    }
    
    private Feedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setId(rs.getInt("id"));
        feedback.setUserId(rs.getInt("user_id"));
        feedback.setFeedbackText(rs.getString("feedback_text"));
        feedback.setCategory(rs.getString("category"));
        feedback.setStatus(rs.getString("status"));
        feedback.setResponse(rs.getString("response"));
        feedback.setRespondedBy(rs.getInt("responded_by"));
        feedback.setResponseDate(rs.getTimestamp("response_date"));
        feedback.setUrgent(rs.getBoolean("is_urgent"));
        feedback.setCreatedAt(rs.getTimestamp("created_at"));
        feedback.setUpdatedAt(rs.getTimestamp("updated_at"));
        return feedback;
    }
}