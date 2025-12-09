package com.blooddonation.dao;

import com.blooddonation.model.Hospital;
import com.blooddonation.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HospitalDAO {
    
    public void addHospital(Hospital hospital) throws SQLException {
        String query = "INSERT INTO hospitals (user_id, hospital_name, hospital_type, address, city, state, postal_code, contact_person, contact_phone, contact_email, license_number, registration_number, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, hospital.getUserId());
            stmt.setString(2, hospital.getHospitalName());
            stmt.setString(3, hospital.getHospitalType());
            stmt.setString(4, hospital.getAddress());
            stmt.setString(5, hospital.getCity());
            stmt.setString(6, hospital.getState());
            stmt.setString(7, hospital.getPostalCode());
            stmt.setString(8, hospital.getContactPerson());
            stmt.setString(9, hospital.getContactPhone());
            stmt.setString(10, hospital.getContactEmail());
            stmt.setString(11, hospital.getLicenseNumber());
            stmt.setString(12, hospital.getRegistrationNumber());
            stmt.setString(13, hospital.getStatus());
            stmt.setTimestamp(14, hospital.getCreatedAt() != null ? new java.sql.Timestamp(hospital.getCreatedAt().getTime()) : new java.sql.Timestamp(System.currentTimeMillis()));
            stmt.executeUpdate();
        }
    }
    
    public List<Hospital> getAllHospitals() throws SQLException {
        List<Hospital> hospitals = new ArrayList<>();
        String query = "SELECT * FROM hospitals ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Hospital hospital = mapResultSetToHospital(rs);
                hospitals.add(hospital);
            }
        }
        return hospitals;
    }
    
    public List<Hospital> getActiveHospitals() throws SQLException {
        List<Hospital> hospitals = new ArrayList<>();
        String query = "SELECT * FROM hospitals WHERE status = 'ACTIVE' ORDER BY hospital_name ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Hospital hospital = mapResultSetToHospital(rs);
                hospitals.add(hospital);
            }
        }
        return hospitals;
    }
    
    public List<Hospital> getPendingHospitals() throws SQLException {
        List<Hospital> hospitals = new ArrayList<>();
        String query = "SELECT * FROM hospitals WHERE status = 'PENDING' ORDER BY created_at ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Hospital hospital = mapResultSetToHospital(rs);
                hospitals.add(hospital);
            }
        }
        return hospitals;
    }
    
    public List<Hospital> getHospitalsByType(String hospitalType) throws SQLException {
        List<Hospital> hospitals = new ArrayList<>();
        String query = "SELECT * FROM hospitals WHERE hospital_type = ? ORDER BY hospital_name ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, hospitalType);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Hospital hospital = mapResultSetToHospital(rs);
                    hospitals.add(hospital);
                }
            }
        }
        return hospitals;
    }
    
    public Hospital getHospitalByUserId(int userId) throws SQLException {
        String query = "SELECT * FROM hospitals WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToHospital(rs);
                }
            }
        }
        return null;
    }
    
    public Hospital getHospitalById(int hospitalId) throws SQLException {
        String query = "SELECT * FROM hospitals WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, hospitalId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToHospital(rs);
                }
            }
        }
        return null;
    }
    
    public void updateHospital(Hospital hospital) throws SQLException {
        String query = "UPDATE hospitals SET hospital_name = ?, hospital_type = ?, address = ?, city = ?, state = ?, postal_code = ?, contact_person = ?, contact_phone = ?, contact_email = ?, license_number = ?, registration_number = ?, status = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, hospital.getHospitalName());
            stmt.setString(2, hospital.getHospitalType());
            stmt.setString(3, hospital.getAddress());
            stmt.setString(4, hospital.getCity());
            stmt.setString(5, hospital.getState());
            stmt.setString(6, hospital.getPostalCode());
            stmt.setString(7, hospital.getContactPerson());
            stmt.setString(8, hospital.getContactPhone());
            stmt.setString(9, hospital.getContactEmail());
            stmt.setString(10, hospital.getLicenseNumber());
            stmt.setString(11, hospital.getRegistrationNumber());
            stmt.setString(12, hospital.getStatus());
            stmt.setInt(13, hospital.getId());
            stmt.executeUpdate();
        }
    }
    
    public void updateHospitalStatus(int hospitalId, String status) throws SQLException {
        String query = "UPDATE hospitals SET status = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setInt(2, hospitalId);
            stmt.executeUpdate();
        }
    }
    
    public void deleteHospital(int hospitalId) throws SQLException {
        String query = "DELETE FROM hospitals WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, hospitalId);
            stmt.executeUpdate();
        }
    }
    
    public int getHospitalCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM hospitals";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int getActiveHospitalCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM hospitals WHERE status = 'ACTIVE'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int getPendingHospitalCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM hospitals WHERE status = 'PENDING'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public List<Hospital> searchHospitals(String searchTerm) throws SQLException {
        List<Hospital> hospitals = new ArrayList<>();
        String query = "SELECT * FROM hospitals WHERE hospital_name LIKE ? OR city LIKE ? OR contact_person LIKE ? ORDER BY hospital_name ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Hospital hospital = mapResultSetToHospital(rs);
                    hospitals.add(hospital);
                }
            }
        }
        return hospitals;
    }
    
    private Hospital mapResultSetToHospital(ResultSet rs) throws SQLException {
        Hospital hospital = new Hospital();
        hospital.setId(rs.getInt("id"));
        hospital.setUserId(rs.getInt("user_id"));
        hospital.setHospitalName(rs.getString("hospital_name"));
        hospital.setHospitalType(rs.getString("hospital_type"));
        hospital.setAddress(rs.getString("address"));
        hospital.setCity(rs.getString("city"));
        hospital.setState(rs.getString("state"));
        hospital.setPostalCode(rs.getString("postal_code"));
        hospital.setContactPerson(rs.getString("contact_person"));
        hospital.setContactPhone(rs.getString("contact_phone"));
        hospital.setContactEmail(rs.getString("contact_email"));
        hospital.setLicenseNumber(rs.getString("license_number"));
        hospital.setRegistrationNumber(rs.getString("registration_number"));
        hospital.setStatus(rs.getString("status"));
        hospital.setCreatedAt(rs.getTimestamp("created_at"));
        hospital.setUpdatedAt(rs.getTimestamp("updated_at"));
        return hospital;
    }
}


