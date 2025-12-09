package com.blooddonation.dao;

import com.blooddonation.model.BloodReport;
import com.blooddonation.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BloodReportDAO {
    
    public void addBloodReport(BloodReport report) throws SQLException {
        String query = "INSERT INTO blood_reports (donor_id, appointment_id, hemoglobin, rbc, hct, mcv, mch, mchc, rdw, wbc, esr, plt, gra, lym, eos, bas, blood_pressure_systolic, blood_pressure_diastolic, pulse_rate, temperature, weight_at_donation, donation_volume, medical_staff_notes, status, tested_by, tested_at, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, report.getDonorId());
            // Set appointment_id to NULL if it's null or 0, otherwise set the actual value
            if (report.getAppointmentId() != null && report.getAppointmentId() > 0) {
                stmt.setInt(2, report.getAppointmentId());
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }
            stmt.setBigDecimal(3, report.getHemoglobin());
            stmt.setBigDecimal(4, report.getRbc());
            stmt.setBigDecimal(5, report.getHct());
            stmt.setBigDecimal(6, report.getMcv());
            stmt.setBigDecimal(7, report.getMch());
            stmt.setBigDecimal(8, report.getMchc());
            stmt.setBigDecimal(9, report.getRdw());
            stmt.setBigDecimal(10, report.getWbc());
            stmt.setBigDecimal(11, report.getEsr());
            stmt.setBigDecimal(12, report.getPlt());
            stmt.setBigDecimal(13, report.getGra());
            stmt.setBigDecimal(14, report.getLym());
            stmt.setBigDecimal(15, report.getEos());
            stmt.setBigDecimal(16, report.getBas());
            if (report.getBloodPressureSystolic() != null) {
                stmt.setInt(17, report.getBloodPressureSystolic());
            } else {
                stmt.setNull(17, java.sql.Types.INTEGER);
            }
            if (report.getBloodPressureDiastolic() != null) {
                stmt.setInt(18, report.getBloodPressureDiastolic());
            } else {
                stmt.setNull(18, java.sql.Types.INTEGER);
            }
            if (report.getPulseRate() != null) {
                stmt.setInt(19, report.getPulseRate());
            } else {
                stmt.setNull(19, java.sql.Types.INTEGER);
            }
            if (report.getTemperature() != null) {
                stmt.setBigDecimal(20, report.getTemperature());
            } else {
                stmt.setNull(20, java.sql.Types.DECIMAL);
            }
            if (report.getWeightAtDonation() != null) {
                stmt.setBigDecimal(21, report.getWeightAtDonation());
            } else {
                stmt.setNull(21, java.sql.Types.DECIMAL);
            }
            if (report.getDonationVolume() != null) {
                stmt.setInt(22, report.getDonationVolume());
            } else {
                stmt.setNull(22, java.sql.Types.INTEGER);
            }
            stmt.setString(23, report.getMedicalStaffNotes());
            stmt.setString(24, report.getStatus());
            if (report.getTestedBy() != null && report.getTestedBy() > 0) {
                stmt.setInt(25, report.getTestedBy());
            } else {
                stmt.setNull(25, java.sql.Types.INTEGER);
            }
            stmt.setTimestamp(26, report.getTestedAt() != null ? new java.sql.Timestamp(report.getTestedAt().getTime()) : new java.sql.Timestamp(System.currentTimeMillis()));
            stmt.setTimestamp(27, report.getCreatedAt() != null ? new java.sql.Timestamp(report.getCreatedAt().getTime()) : new java.sql.Timestamp(System.currentTimeMillis()));
            stmt.executeUpdate();
        }
    }
    
    public List<BloodReport> getAllBloodReports() throws SQLException {
        List<BloodReport> reports = new ArrayList<>();
        String query = "SELECT * FROM blood_reports ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                BloodReport report = mapResultSetToBloodReport(rs);
                reports.add(report);
            }
        }
        return reports;
    }
    
    public List<BloodReport> getBloodReportsByDonorId(int donorId) throws SQLException {
        List<BloodReport> reports = new ArrayList<>();
        String query = "SELECT * FROM blood_reports WHERE donor_id = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, donorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodReport report = mapResultSetToBloodReport(rs);
                    reports.add(report);
                }
            }
        }
        return reports;
    }
    
    public List<BloodReport> getBloodReportsByStatus(String status) throws SQLException {
        List<BloodReport> reports = new ArrayList<>();
        String query = "SELECT * FROM blood_reports WHERE status = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodReport report = mapResultSetToBloodReport(rs);
                    reports.add(report);
                }
            }
        }
        return reports;
    }
    
    public BloodReport getBloodReportById(int reportId) throws SQLException {
        String query = "SELECT * FROM blood_reports WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, reportId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBloodReport(rs);
                }
            }
        }
        return null;
    }
    
    public BloodReport getLatestBloodReportByDonorId(int donorId) throws SQLException {
        String query = "SELECT * FROM blood_reports WHERE donor_id = ? ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, donorId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBloodReport(rs);
                }
            }
        }
        return null;
    }
    
    public void updateBloodReport(BloodReport report) throws SQLException {
        String query = "UPDATE blood_reports SET appointment_id = ?, hemoglobin = ?, rbc = ?, hct = ?, mcv = ?, mch = ?, mchc = ?, rdw = ?, wbc = ?, esr = ?, plt = ?, gra = ?, lym = ?, eos = ?, bas = ?, blood_pressure_systolic = ?, blood_pressure_diastolic = ?, pulse_rate = ?, temperature = ?, weight_at_donation = ?, donation_volume = ?, medical_staff_notes = ?, status = ?, tested_by = ?, tested_at = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            // Set appointment_id to NULL if it's null or 0, otherwise set the actual value
            if (report.getAppointmentId() != null && report.getAppointmentId() > 0) {
                stmt.setInt(1, report.getAppointmentId());
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
            }
            stmt.setBigDecimal(2, report.getHemoglobin());
            stmt.setBigDecimal(3, report.getRbc());
            stmt.setBigDecimal(4, report.getHct());
            stmt.setBigDecimal(5, report.getMcv());
            stmt.setBigDecimal(6, report.getMch());
            stmt.setBigDecimal(7, report.getMchc());
            stmt.setBigDecimal(8, report.getRdw());
            stmt.setBigDecimal(9, report.getWbc());
            stmt.setBigDecimal(10, report.getEsr());
            stmt.setBigDecimal(11, report.getPlt());
            stmt.setBigDecimal(12, report.getGra());
            stmt.setBigDecimal(13, report.getLym());
            stmt.setBigDecimal(14, report.getEos());
            stmt.setBigDecimal(15, report.getBas());
            stmt.setInt(16, report.getBloodPressureSystolic() != null ? report.getBloodPressureSystolic() : 0);
            stmt.setInt(17, report.getBloodPressureDiastolic() != null ? report.getBloodPressureDiastolic() : 0);
            stmt.setInt(18, report.getPulseRate() != null ? report.getPulseRate() : 0);
            stmt.setBigDecimal(19, report.getTemperature());
            stmt.setBigDecimal(20, report.getWeightAtDonation());
            stmt.setInt(21, report.getDonationVolume() != null ? report.getDonationVolume() : 0);
            stmt.setString(22, report.getMedicalStaffNotes());
            stmt.setString(23, report.getStatus());
            if (report.getTestedBy() != null && report.getTestedBy() > 0) {
                stmt.setInt(24, report.getTestedBy());
            } else {
                stmt.setNull(24, java.sql.Types.INTEGER);
            }
            stmt.setTimestamp(25, report.getTestedAt() != null ? new java.sql.Timestamp(report.getTestedAt().getTime()) : null);
            stmt.setInt(26, report.getId());
            stmt.executeUpdate();
        }
    }
    
    public void updateBloodReportStatus(int reportId, String status) throws SQLException {
        String query = "UPDATE blood_reports SET status = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setInt(2, reportId);
            stmt.executeUpdate();
        }
    }
    
    public int getBloodReportCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM blood_reports";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int getBloodReportCountByDonorId(int donorId) throws SQLException {
        String query = "SELECT COUNT(*) FROM blood_reports WHERE donor_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, donorId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    public int getBloodReportCountByStatus(String status) throws SQLException {
        String query = "SELECT COUNT(*) FROM blood_reports WHERE status = ?";
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
    
    public List<BloodReport> getBloodReportsByDateRange(java.util.Date startDate, java.util.Date endDate) throws SQLException {
        List<BloodReport> reports = new ArrayList<>();
        String query = "SELECT * FROM blood_reports WHERE created_at BETWEEN ? AND ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setTimestamp(1, new java.sql.Timestamp(startDate.getTime()));
            stmt.setTimestamp(2, new java.sql.Timestamp(endDate.getTime()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodReport report = mapResultSetToBloodReport(rs);
                    reports.add(report);
                }
            }
        }
        return reports;
    }
    
    public List<BloodReport> getBloodReportsByDonorIdAndDateRange(int donorId, java.util.Date startDate, java.util.Date endDate) throws SQLException {
        List<BloodReport> reports = new ArrayList<>();
        String query = "SELECT * FROM blood_reports WHERE donor_id = ? AND created_at BETWEEN ? AND ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, donorId);
            stmt.setTimestamp(2, new java.sql.Timestamp(startDate.getTime()));
            stmt.setTimestamp(3, new java.sql.Timestamp(endDate.getTime()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodReport report = mapResultSetToBloodReport(rs);
                    reports.add(report);
                }
            }
        }
        return reports;
    }
    
    public List<BloodReport> getBloodReportsByStatusAndDateRange(String status, java.util.Date startDate, java.util.Date endDate) throws SQLException {
        List<BloodReport> reports = new ArrayList<>();
        String query = "SELECT * FROM blood_reports WHERE status = ? AND created_at BETWEEN ? AND ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setTimestamp(2, new java.sql.Timestamp(startDate.getTime()));
            stmt.setTimestamp(3, new java.sql.Timestamp(endDate.getTime()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodReport report = mapResultSetToBloodReport(rs);
                    reports.add(report);
                }
            }
        }
        return reports;
    }
    
    public List<BloodReport> getBloodReportsByDonorIdAndStatus(int donorId, String status) throws SQLException {
        List<BloodReport> reports = new ArrayList<>();
        String query = "SELECT * FROM blood_reports WHERE donor_id = ? AND status = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, donorId);
            stmt.setString(2, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodReport report = mapResultSetToBloodReport(rs);
                    reports.add(report);
                }
            }
        }
        return reports;
    }
    
    public List<BloodReport> getBloodReportsByDonorIdAndStatusAndDateRange(int donorId, String status, java.util.Date startDate, java.util.Date endDate) throws SQLException {
        List<BloodReport> reports = new ArrayList<>();
        String query = "SELECT * FROM blood_reports WHERE donor_id = ? AND status = ? AND created_at BETWEEN ? AND ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, donorId);
            stmt.setString(2, status);
            stmt.setTimestamp(3, new java.sql.Timestamp(startDate.getTime()));
            stmt.setTimestamp(4, new java.sql.Timestamp(endDate.getTime()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodReport report = mapResultSetToBloodReport(rs);
                    reports.add(report);
                }
            }
        }
        return reports;
    }
    
    public List<BloodReport> searchBloodReports(String searchTerm) throws SQLException {
        List<BloodReport> reports = new ArrayList<>();
        String query = "SELECT * FROM blood_reports WHERE status LIKE ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, "%" + searchTerm + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodReport report = mapResultSetToBloodReport(rs);
                    reports.add(report);
                }
            }
        }
        return reports;
    }
    
    public List<BloodReport> getRecentBloodReports(int limit) throws SQLException {
        List<BloodReport> reports = new ArrayList<>();
        String query = "SELECT * FROM blood_reports ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BloodReport report = mapResultSetToBloodReport(rs);
                    reports.add(report);
                }
            }
        }
        return reports;
    }
    
    private BloodReport mapResultSetToBloodReport(ResultSet rs) throws SQLException {
        BloodReport report = new BloodReport();
        report.setId(rs.getInt("id"));
        report.setDonorId(rs.getInt("donor_id"));
        report.setAppointmentId(rs.getInt("appointment_id"));
        report.setHemoglobin(rs.getBigDecimal("hemoglobin"));
        report.setRbc(rs.getBigDecimal("rbc"));
        report.setHct(rs.getBigDecimal("hct"));
        report.setMcv(rs.getBigDecimal("mcv"));
        report.setMch(rs.getBigDecimal("mch"));
        report.setMchc(rs.getBigDecimal("mchc"));
        report.setRdw(rs.getBigDecimal("rdw"));
        report.setWbc(rs.getBigDecimal("wbc"));
        report.setEsr(rs.getBigDecimal("esr"));
        report.setPlt(rs.getBigDecimal("plt"));
        report.setGra(rs.getBigDecimal("gra"));
        report.setLym(rs.getBigDecimal("lym"));
        report.setEos(rs.getBigDecimal("eos"));
        report.setBas(rs.getBigDecimal("bas"));
        report.setBloodPressureSystolic(rs.getInt("blood_pressure_systolic"));
        report.setBloodPressureDiastolic(rs.getInt("blood_pressure_diastolic"));
        report.setPulseRate(rs.getInt("pulse_rate"));
        report.setTemperature(rs.getBigDecimal("temperature"));
        report.setWeightAtDonation(rs.getBigDecimal("weight_at_donation"));
        report.setDonationVolume(rs.getInt("donation_volume"));
        report.setMedicalStaffNotes(rs.getString("medical_staff_notes"));
        report.setStatus(rs.getString("status"));
        report.setTestedBy(rs.getInt("tested_by"));
        report.setTestedAt(rs.getTimestamp("tested_at"));
        report.setCreatedAt(rs.getTimestamp("created_at"));
        return report;
    }
    
    /**
     * Delete a blood report by ID
     */
    public boolean deleteBloodReport(int reportId) throws SQLException {
        String query = "DELETE FROM blood_reports WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, reportId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    /**
     * Delete a blood report by ID and donor ID (for security - only allow donors to delete their own reports)
     */
    public boolean deleteBloodReportByDonor(int reportId, int donorId) throws SQLException {
        String query = "DELETE FROM blood_reports WHERE id = ? AND donor_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, reportId);
            stmt.setInt(2, donorId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
}