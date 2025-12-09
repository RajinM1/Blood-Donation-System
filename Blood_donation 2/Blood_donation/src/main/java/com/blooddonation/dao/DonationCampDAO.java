package com.blooddonation.dao;

import com.blooddonation.model.DonationCamp;
import com.blooddonation.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DonationCampDAO {
    
    public void addDonationCamp(DonationCamp camp) throws SQLException {
        String query = "INSERT INTO donation_camps (camp_name, location, address, city, camp_date, start_time, end_time, max_donors, current_donors, organizer_id, status, description, special_requirements, contact_person, contact_phone, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, camp.getCampName());
            stmt.setString(2, camp.getLocation());
            stmt.setString(3, camp.getAddress());
            stmt.setString(4, camp.getCity());
            stmt.setDate(5, new java.sql.Date(camp.getCampDate().getTime()));
            stmt.setTime(6, camp.getStartTime() != null ? new java.sql.Time(camp.getStartTime().getTime()) : null);
            stmt.setTime(7, camp.getEndTime() != null ? new java.sql.Time(camp.getEndTime().getTime()) : null);
            stmt.setInt(8, camp.getMaxDonors());
            stmt.setInt(9, camp.getCurrentDonors());
            stmt.setInt(10, camp.getOrganizerId());
            stmt.setString(11, camp.getStatus());
            stmt.setString(12, camp.getDescription());
            stmt.setString(13, camp.getSpecialRequirements());
            stmt.setString(14, camp.getContactPerson());
            stmt.setString(15, camp.getContactPhone());
            stmt.setTimestamp(16, camp.getCreatedAt() != null ? new java.sql.Timestamp(camp.getCreatedAt().getTime()) : new java.sql.Timestamp(System.currentTimeMillis()));
            stmt.executeUpdate();
        }
    }
    
    public List<DonationCamp> getAllDonationCamps() throws SQLException {
        List<DonationCamp> camps = new ArrayList<>();
        String query = "SELECT * FROM donation_camps ORDER BY camp_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                DonationCamp camp = mapResultSetToDonationCamp(rs);
                camps.add(camp);
            }
        }
        return camps;
    }
    
    public List<DonationCamp> getAllCamps() throws SQLException {
        return getAllDonationCamps();
    }
    
    public List<DonationCamp> getActiveDonationCamps() throws SQLException {
        List<DonationCamp> camps = new ArrayList<>();
        String query = "SELECT * FROM donation_camps WHERE status = 'PLANNED' OR status = 'ACTIVE' ORDER BY camp_date ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                DonationCamp camp = mapResultSetToDonationCamp(rs);
                camps.add(camp);
            }
        }
        return camps;
    }
    
    public List<DonationCamp> getUpcomingDonationCamps() throws SQLException {
        List<DonationCamp> camps = new ArrayList<>();
        String query = "SELECT * FROM donation_camps WHERE status = 'ACTIVE' AND camp_date > NOW() ORDER BY camp_date ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                DonationCamp camp = mapResultSetToDonationCamp(rs);
                camps.add(camp);
            }
        }
        return camps;
    }
    
    public List<DonationCamp> getPastDonationCamps() throws SQLException {
        List<DonationCamp> camps = new ArrayList<>();
        String query = "SELECT * FROM donation_camps WHERE end_date < NOW() ORDER BY end_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                DonationCamp camp = mapResultSetToDonationCamp(rs);
                camps.add(camp);
            }
        }
        return camps;
    }
    
    public List<DonationCamp> getDonationCampsByStatus(String status) throws SQLException {
        List<DonationCamp> camps = new ArrayList<>();
        String query = "SELECT * FROM donation_camps WHERE status = ? ORDER BY camp_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DonationCamp camp = mapResultSetToDonationCamp(rs);
                    camps.add(camp);
                }
            }
        }
        return camps;
    }
    
    public List<DonationCamp> getDonationCampsByLocation(String location) throws SQLException {
        List<DonationCamp> camps = new ArrayList<>();
        String query = "SELECT * FROM donation_camps WHERE location LIKE ? ORDER BY camp_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, "%" + location + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DonationCamp camp = mapResultSetToDonationCamp(rs);
                    camps.add(camp);
                }
            }
        }
        return camps;
    }
    
    public DonationCamp getDonationCampById(int campId) throws SQLException {
        String query = "SELECT * FROM donation_camps WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, campId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDonationCamp(rs);
                }
            }
        }
        return null;
    }
    
    public void updateDonationCamp(DonationCamp camp) throws SQLException {
        String query = "UPDATE donation_camps SET camp_name = ?, location = ?, camp_date = ?, end_date = ?, max_donors = ?, status = ?, description = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, camp.getName());
            stmt.setString(2, camp.getLocation());
            stmt.setDate(3, new java.sql.Date(camp.getStartDate().getTime()));
            stmt.setDate(4, new java.sql.Date(camp.getEndDate().getTime()));
            stmt.setInt(5, camp.getMaxDonors());
            stmt.setString(6, camp.getStatus());
            stmt.setString(7, camp.getDescription());
            stmt.setInt(8, camp.getId());
            stmt.executeUpdate();
        }
    }
    
    public void updateDonationCampStatus(int campId, String status) throws SQLException {
        String query = "UPDATE donation_camps SET status = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setInt(2, campId);
            stmt.executeUpdate();
        }
    }
    
    public void deleteDonationCamp(int campId) throws SQLException {
        String query = "DELETE FROM donation_camps WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, campId);
            stmt.executeUpdate();
        }
    }
    
    public int getDonationCampCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM donation_camps";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int getActiveDonationCampCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM donation_camps WHERE status = 'ACTIVE' AND camp_date <= NOW()";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int getUpcomingDonationCampCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM donation_camps WHERE status = 'ACTIVE' AND camp_date > NOW()";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int getPastDonationCampCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM donation_camps WHERE camp_date < NOW()";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public List<DonationCamp> getDonationCampsByDateRange(java.util.Date startDate, java.util.Date endDate) throws SQLException {
        List<DonationCamp> camps = new ArrayList<>();
        String query = "SELECT * FROM donation_camps WHERE camp_date >= ? AND camp_date <= ? ORDER BY camp_date ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setDate(1, new java.sql.Date(startDate.getTime()));
            stmt.setDate(2, new java.sql.Date(endDate.getTime()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DonationCamp camp = mapResultSetToDonationCamp(rs);
                    camps.add(camp);
                }
            }
        }
        return camps;
    }
    
    public List<DonationCamp> searchDonationCamps(String searchTerm) throws SQLException {
        List<DonationCamp> camps = new ArrayList<>();
        String query = "SELECT * FROM donation_camps WHERE camp_name LIKE ? OR location LIKE ? OR description LIKE ? ORDER BY camp_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DonationCamp camp = mapResultSetToDonationCamp(rs);
                    camps.add(camp);
                }
            }
        }
        return camps;
    }
    
    public List<DonationCamp> getDonationCampsByMaxDonors(int maxDonors) throws SQLException {
        List<DonationCamp> camps = new ArrayList<>();
        String query = "SELECT * FROM donation_camps WHERE max_donors >= ? ORDER BY camp_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, maxDonors);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DonationCamp camp = mapResultSetToDonationCamp(rs);
                    camps.add(camp);
                }
            }
        }
        return camps;
    }
    
    public List<DonationCamp> getDonationCampsByStatusAndDateRange(String status, java.util.Date startDate, java.util.Date endDate) throws SQLException {
        List<DonationCamp> camps = new ArrayList<>();
        String query = "SELECT * FROM donation_camps WHERE status = ? AND camp_date >= ? AND camp_date <= ? ORDER BY camp_date ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setDate(2, new java.sql.Date(startDate.getTime()));
            stmt.setDate(3, new java.sql.Date(endDate.getTime()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DonationCamp camp = mapResultSetToDonationCamp(rs);
                    camps.add(camp);
                }
            }
        }
        return camps;
    }
    
    public List<DonationCamp> getDonationCampsByLocationAndDateRange(String location, java.util.Date startDate, java.util.Date endDate) throws SQLException {
        List<DonationCamp> camps = new ArrayList<>();
        String query = "SELECT * FROM donation_camps WHERE location LIKE ? AND camp_date >= ? AND camp_date <= ? ORDER BY camp_date ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, "%" + location + "%");
            stmt.setDate(2, new java.sql.Date(startDate.getTime()));
            stmt.setDate(3, new java.sql.Date(endDate.getTime()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DonationCamp camp = mapResultSetToDonationCamp(rs);
                    camps.add(camp);
                }
            }
        }
        return camps;
    }
    
    public List<DonationCamp> getDonationCampsByStatusAndLocation(String status, String location) throws SQLException {
        List<DonationCamp> camps = new ArrayList<>();
        String query = "SELECT * FROM donation_camps WHERE status = ? AND location LIKE ? ORDER BY camp_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setString(2, "%" + location + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DonationCamp camp = mapResultSetToDonationCamp(rs);
                    camps.add(camp);
                }
            }
        }
        return camps;
    }
    
    public List<DonationCamp> getDonationCampsByStatusAndLocationAndDateRange(String status, String location, java.util.Date startDate, java.util.Date endDate) throws SQLException {
        List<DonationCamp> camps = new ArrayList<>();
        String query = "SELECT * FROM donation_camps WHERE status = ? AND location LIKE ? AND camp_date >= ? AND end_date <= ? ORDER BY camp_date ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setString(2, "%" + location + "%");
            stmt.setDate(3, new java.sql.Date(startDate.getTime()));
            stmt.setDate(4, new java.sql.Date(endDate.getTime()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DonationCamp camp = mapResultSetToDonationCamp(rs);
                    camps.add(camp);
                }
            }
        }
        return camps;
    }
    
    private DonationCamp mapResultSetToDonationCamp(ResultSet rs) throws SQLException {
        DonationCamp camp = new DonationCamp();
        camp.setId(rs.getInt("id"));
        camp.setCampName(rs.getString("camp_name"));
        camp.setLocation(rs.getString("location"));
        camp.setAddress(rs.getString("address"));
        camp.setCity(rs.getString("city"));
        camp.setCampDate(rs.getDate("camp_date"));
        camp.setStartTime(rs.getTime("start_time"));
        camp.setEndTime(rs.getTime("end_time"));
        camp.setMaxDonors(rs.getInt("max_donors"));
        camp.setCurrentDonors(rs.getInt("current_donors"));
        camp.setOrganizerId(rs.getInt("organizer_id"));
        camp.setStatus(rs.getString("status"));
        camp.setDescription(rs.getString("description"));
        camp.setSpecialRequirements(rs.getString("special_requirements"));
        camp.setContactPerson(rs.getString("contact_person"));
        camp.setContactPhone(rs.getString("contact_phone"));
        camp.setCreatedAt(rs.getTimestamp("created_at"));
        camp.setUpdatedAt(rs.getTimestamp("updated_at"));
        return camp;
    }
}