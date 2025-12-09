package com.blooddonation.dao;

import com.blooddonation.model.BloodRequest;
import com.blooddonation.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BloodRequestDAO {
    
    public void addBloodRequest(BloodRequest bloodRequest) throws SQLException {
        String query = "INSERT INTO blood_requests (hospital_id, blood_group, quantity, urgency, status, patient_info, request_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, bloodRequest.getHospitalId());
            stmt.setString(2, bloodRequest.getBloodGroup());
            stmt.setInt(3, bloodRequest.getQuantity());
            stmt.setString(4, bloodRequest.getUrgency());
            stmt.setString(5, bloodRequest.getStatus());
            // Combine patient name and reason into patient_info
            String patientInfo = "Patient: " + (bloodRequest.getPatientName() != null ? bloodRequest.getPatientName() : "N/A");
            if (bloodRequest.getReason() != null && !bloodRequest.getReason().trim().isEmpty()) {
                patientInfo += "\nReason: " + bloodRequest.getReason();
            }
            stmt.setString(6, patientInfo);
            stmt.setTimestamp(7, bloodRequest.getRequestDate() != null ? new java.sql.Timestamp(bloodRequest.getRequestDate().getTime()) : new java.sql.Timestamp(System.currentTimeMillis()));
            stmt.executeUpdate();
        }
    }
    
    public List<BloodRequest> getAllBloodRequests() throws SQLException {
        List<BloodRequest> requests = new ArrayList<>();
        String query = "SELECT * FROM blood_requests ORDER BY request_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                BloodRequest request = mapResultSetToBloodRequest(rs);
                requests.add(request);
            }
        }
        return requests;
    }
    
    public int getPendingRequestsCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM blood_requests WHERE status = 'PENDING'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int getBloodRequestsByMonth(int month, int year) throws SQLException {
        String query = "SELECT COUNT(*) FROM blood_requests WHERE MONTH(request_date) = ? AND YEAR(request_date) = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, month);
            stmt.setInt(2, year);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    public List<BloodRequest> getRecentBloodRequests(int limit) throws SQLException {
        List<BloodRequest> requests = new ArrayList<>();
        String query = "SELECT * FROM blood_requests ORDER BY request_date DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    requests.add(mapResultSetToBloodRequest(rs));
                }
            }
        }
        return requests;
    }
    
    public List<BloodRequest> getBloodRequestsByHospitalId(int hospitalId) throws SQLException {
        List<BloodRequest> requests = new ArrayList<>();
        String query = "SELECT * FROM blood_requests WHERE hospital_id = ? ORDER BY request_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, hospitalId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodRequest request = mapResultSetToBloodRequest(rs);
                    requests.add(request);
                }
            }
        }
        return requests;
    }
    
    public List<BloodRequest> getBloodRequestsByStatus(String status) throws SQLException {
        List<BloodRequest> requests = new ArrayList<>();
        String query = "SELECT * FROM blood_requests WHERE status = ? ORDER BY request_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodRequest request = mapResultSetToBloodRequest(rs);
                    requests.add(request);
                }
            }
        }
        return requests;
    }
    
    public List<BloodRequest> getPendingBloodRequests() throws SQLException {
        return getBloodRequestsByStatus("PENDING");
    }
    
    public List<BloodRequest> getApprovedBloodRequests() throws SQLException {
        return getBloodRequestsByStatus("APPROVED");
    }
    
    public List<BloodRequest> getRejectedBloodRequests() throws SQLException {
        return getBloodRequestsByStatus("REJECTED");
    }
    
    public List<BloodRequest> getOnHoldBloodRequests() throws SQLException {
        return getBloodRequestsByStatus("ON_HOLD");
    }
    
    public List<BloodRequest> getBloodRequestsByUrgency(String urgency) throws SQLException {
        List<BloodRequest> requests = new ArrayList<>();
        String query = "SELECT * FROM blood_requests WHERE urgency = ? ORDER BY request_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, urgency);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodRequest request = mapResultSetToBloodRequest(rs);
                    requests.add(request);
                }
            }
        }
        return requests;
    }
    
    public List<BloodRequest> getBloodRequestsByBloodGroup(String bloodGroup) throws SQLException {
        List<BloodRequest> requests = new ArrayList<>();
        String query = "SELECT * FROM blood_requests WHERE blood_group = ? ORDER BY request_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, bloodGroup);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodRequest request = mapResultSetToBloodRequest(rs);
                    requests.add(request);
                }
            }
        }
        return requests;
    }
    
    public BloodRequest getBloodRequestById(int requestId) throws SQLException {
        String query = "SELECT * FROM blood_requests WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, requestId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBloodRequest(rs);
                }
            }
        }
        return null;
    }
    
    public void updateBloodRequestStatus(int requestId, String status) throws SQLException {
        String query = "UPDATE blood_requests SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setInt(2, requestId);
            stmt.executeUpdate();
        }
    }
    
    public void updateBloodRequestStatus(int requestId, String status, java.util.Date deliveryDate) throws SQLException {
        String query = "UPDATE blood_requests SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setInt(2, requestId);
            stmt.executeUpdate();
        }
    }
    
    public void approveBloodRequest(int requestId, int approvedBy) throws SQLException {
        String query = "UPDATE blood_requests SET status = 'APPROVED' WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, requestId);
            stmt.executeUpdate();
        }
    }
    
    public void rejectBloodRequest(int requestId, int rejectedBy, String rejectionReason) throws SQLException {
        String query = "UPDATE blood_requests SET status = 'REJECTED' WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, requestId);
            stmt.executeUpdate();
        }
    }
    
    public void putOnHold(int requestId, String reason) throws SQLException {
        String query = "UPDATE blood_requests SET status = 'ON_HOLD' WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, requestId);
            stmt.executeUpdate();
        }
    }
    
    public void completeBloodRequest(int requestId) throws SQLException {
        String query = "UPDATE blood_requests SET status = 'COMPLETED' WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, requestId);
            stmt.executeUpdate();
        }
    }
    
    public void updateBloodRequest(BloodRequest bloodRequest) throws SQLException {
        String query = "UPDATE blood_requests SET blood_group = ?, quantity = ?, urgency = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, bloodRequest.getBloodGroup());
            stmt.setInt(2, bloodRequest.getQuantity());
            stmt.setString(3, bloodRequest.getUrgency());
            stmt.setInt(4, bloodRequest.getId());
            stmt.executeUpdate();
        }
    }
    
    public void deleteBloodRequest(int requestId) throws SQLException {
        String query = "DELETE FROM blood_requests WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, requestId);
            stmt.executeUpdate();
        }
    }
    
    public int getRequestCountByStatus(String status) throws SQLException {
        String query = "SELECT COUNT(*) FROM blood_requests WHERE status = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    public List<BloodRequest> getCriticalBloodRequests() throws SQLException {
        return getBloodRequestsByUrgency("CRITICAL");
    }
    
    public List<BloodRequest> getHighPriorityBloodRequests() throws SQLException {
        List<BloodRequest> requests = new ArrayList<>();
        String query = "SELECT * FROM blood_requests WHERE priority = 'HIGH' OR priority = 'CRITICAL' ORDER BY request_date ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                BloodRequest request = mapResultSetToBloodRequest(rs);
                requests.add(request);
            }
        }
        return requests;
    }
    
    public boolean isDuplicateRequest(int hospitalId, String bloodGroup, int quantity, java.util.Date requestDate) throws SQLException {
        String query = "SELECT COUNT(*) FROM blood_requests WHERE hospital_id = ? AND blood_group = ? AND quantity = ? AND DATE(request_date) = ? AND status IN ('PENDING', 'APPROVED')";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, hospitalId);
            stmt.setString(2, bloodGroup);
            stmt.setInt(3, quantity);
            stmt.setDate(4, new java.sql.Date(requestDate.getTime()));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    private BloodRequest mapResultSetToBloodRequest(ResultSet rs) throws SQLException {
        BloodRequest request = new BloodRequest();
        request.setId(rs.getInt("id"));
        request.setHospitalId(rs.getInt("hospital_id"));
        request.setBloodGroup(rs.getString("blood_group"));
        request.setQuantity(rs.getInt("quantity"));
        request.setUrgency(rs.getString("urgency"));
        request.setStatus(rs.getString("status"));
        request.setRequestDate(rs.getTimestamp("request_date"));
        
        // Parse patient_info to extract patient name and reason
        String patientInfo = rs.getString("patient_info");
        if (patientInfo != null) {
            String[] lines = patientInfo.split("\n");
            for (String line : lines) {
                if (line.startsWith("Patient: ")) {
                    request.setPatientName(line.substring(9));
                } else if (line.startsWith("Reason: ")) {
                    request.setReason(line.substring(8));
                }
            }
        }
        
        // Set default values for fields that don't exist in the database
        request.setPriority("0");
        request.setRejectionReason(null);
        request.setDeliveryDate(null);
        request.setApprovedAt(null);
        request.setApprovedBy(0);
        request.setCreatedAt(rs.getTimestamp("request_date")); // Use request_date as created_at
        request.setUpdatedAt(null);
        
        return request;
    }
}