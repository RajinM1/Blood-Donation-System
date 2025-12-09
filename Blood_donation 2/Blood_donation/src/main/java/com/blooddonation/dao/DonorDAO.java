package com.blooddonation.dao;

import com.blooddonation.model.Donor;
import com.blooddonation.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DonorDAO {
    public void addDonor(Donor donor) throws SQLException {
        String query = "INSERT INTO donors (user_id, name, age, gender, blood_group, weight, health_info, last_donation_date, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, donor.getUserId());
            stmt.setString(2, donor.getName());
            stmt.setInt(3, donor.getAge());
            stmt.setString(4, donor.getGender());
            stmt.setString(5, donor.getBloodGroup());
            stmt.setDouble(6, donor.getWeight());
            stmt.setString(7, donor.getHealthInfo());
            stmt.setDate(8, donor.getLastDonationDate() != null ? new java.sql.Date(donor.getLastDonationDate().getTime()) : null);
            stmt.setString(9, donor.getStatus());
            stmt.setTimestamp(10, donor.getCreatedAt() != null ? new java.sql.Timestamp(donor.getCreatedAt().getTime()) : new java.sql.Timestamp(System.currentTimeMillis()));
            stmt.executeUpdate();
        }
    }

    public Donor getDonorByUserId(int userId) throws SQLException {
        String query = "SELECT * FROM donors WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Donor donor = new Donor();
                donor.setId(rs.getInt("id"));
                donor.setUserId(rs.getInt("user_id"));
                donor.setName(rs.getString("name"));
                donor.setAge(rs.getInt("age"));
                donor.setGender(rs.getString("gender"));
                donor.setBloodGroup(rs.getString("blood_group"));
                donor.setWeight(rs.getDouble("weight"));
                donor.setHealthInfo(rs.getString("health_info"));
                donor.setLastDonationDate(rs.getDate("last_donation_date"));
                donor.setStatus(rs.getString("status"));
                donor.setCreatedAt(rs.getTimestamp("created_at"));
                donor.setUpdatedAt(rs.getTimestamp("updated_at"));
                return donor;
            }
            return null;
        }
    }
    
    public Donor getDonorById(int donorId) throws SQLException {
        String query = "SELECT * FROM donors WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, donorId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Donor donor = new Donor();
                donor.setId(rs.getInt("id"));
                donor.setUserId(rs.getInt("user_id"));
                donor.setName(rs.getString("name"));
                donor.setAge(rs.getInt("age"));
                donor.setGender(rs.getString("gender"));
                donor.setBloodGroup(rs.getString("blood_group"));
                donor.setWeight(rs.getDouble("weight"));
                donor.setHealthInfo(rs.getString("health_info"));
                donor.setLastDonationDate(rs.getDate("last_donation_date"));
                donor.setStatus(rs.getString("status"));
                donor.setCreatedAt(rs.getTimestamp("created_at"));
                donor.setUpdatedAt(rs.getTimestamp("updated_at"));
                return donor;
            }
            return null;
        }
    }

    public List<Donor> getAllDonors() throws SQLException {
        List<Donor> donors = new ArrayList<>();
        String query = "SELECT * FROM donors";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Donor donor = new Donor();
                donor.setId(rs.getInt("id"));
                donor.setUserId(rs.getInt("user_id"));
                donor.setName(rs.getString("name"));
                donor.setAge(rs.getInt("age"));
                donor.setGender(rs.getString("gender"));
                donor.setBloodGroup(rs.getString("blood_group"));
                donor.setWeight(rs.getDouble("weight"));
                donor.setHealthInfo(rs.getString("health_info"));
                donor.setLastDonationDate(rs.getDate("last_donation_date"));
                donor.setNextEligibleDate(rs.getDate("next_eligible_date"));
                donor.setTotalDonations(rs.getInt("total_donations"));
                donor.setStatus(rs.getString("status"));
                donor.setCreatedAt(rs.getTimestamp("created_at"));
                donor.setUpdatedAt(rs.getTimestamp("updated_at"));
                donors.add(donor);
            }
        }
        return donors;
    }

    public boolean isEligible(int userId) throws SQLException {
        Donor donor = getDonorByUserId(userId);
        if (donor == null || donor.getLastDonationDate() == null) return true;
        long diff = new java.util.Date().getTime() - donor.getLastDonationDate().getTime();
        long days = diff / (1000 * 60 * 60 * 24);
        return days > 90; // 3 months
    }

    public void updateDonor(Donor donor) throws SQLException {
        String query = "UPDATE donors SET name = ?, age = ?, gender = ?, blood_group = ?, weight = ?, health_info = ?, last_donation_date = ?, next_eligible_date = ?, total_donations = ?, status = ?, updated_at = ? WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, donor.getName());
            stmt.setInt(2, donor.getAge());
            stmt.setString(3, donor.getGender());
            stmt.setString(4, donor.getBloodGroup());
            stmt.setDouble(5, donor.getWeight());
            stmt.setString(6, donor.getHealthInfo());
            stmt.setDate(7, donor.getLastDonationDate() != null ? new java.sql.Date(donor.getLastDonationDate().getTime()) : null);
            stmt.setDate(8, donor.getNextEligibleDate() != null ? new java.sql.Date(donor.getNextEligibleDate().getTime()) : null);
            stmt.setInt(9, donor.getTotalDonations());
            stmt.setString(10, donor.getStatus());
            stmt.setTimestamp(11, new java.sql.Timestamp(System.currentTimeMillis()));
            stmt.setInt(12, donor.getUserId());
            stmt.executeUpdate();
        }
    }

    public List<Donor> getEligibleDonors() throws SQLException {
        List<Donor> eligibleDonors = new ArrayList<>();
        String query = "SELECT * FROM donors WHERE status = 'APPROVED' AND age >= 18 AND age <= 65 AND weight >= 40.0";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Donor donor = new Donor();
                donor.setId(rs.getInt("id"));
                donor.setUserId(rs.getInt("user_id"));
                donor.setName(rs.getString("name"));
                donor.setAge(rs.getInt("age"));
                donor.setGender(rs.getString("gender"));
                donor.setBloodGroup(rs.getString("blood_group"));
                donor.setWeight(rs.getDouble("weight"));
                donor.setHealthInfo(rs.getString("health_info"));
                donor.setLastDonationDate(rs.getDate("last_donation_date"));
                donor.setStatus(rs.getString("status"));
                donor.setCreatedAt(rs.getTimestamp("created_at"));
                donor.setUpdatedAt(rs.getTimestamp("updated_at"));
                eligibleDonors.add(donor);
            }
        }
        return eligibleDonors;
    }

    public List<Donor> getDonorsByBloodGroup(String bloodGroup) throws SQLException {
        List<Donor> donors = new ArrayList<>();
        String query = "SELECT * FROM donors WHERE blood_group = ? AND status = 'APPROVED'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, bloodGroup);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Donor donor = new Donor();
                    donor.setId(rs.getInt("id"));
                    donor.setUserId(rs.getInt("user_id"));
                    donor.setName(rs.getString("name"));
                    donor.setAge(rs.getInt("age"));
                    donor.setGender(rs.getString("gender"));
                    donor.setBloodGroup(rs.getString("blood_group"));
                    donor.setWeight(rs.getDouble("weight"));
                    donor.setHealthInfo(rs.getString("health_info"));
                    donor.setLastDonationDate(rs.getDate("last_donation_date"));
                    donor.setStatus(rs.getString("status"));
                    donor.setCreatedAt(rs.getTimestamp("created_at"));
                    donor.setUpdatedAt(rs.getTimestamp("updated_at"));
                    donors.add(donor);
                }
            }
        }
        return donors;
    }
    
    public void deleteDonor(int donorId) throws SQLException {
        String query = "DELETE FROM donors WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, donorId);
            stmt.executeUpdate();
        }
    }
    
    public int getActiveDonorsCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM donors WHERE status = 'APPROVED'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}