package com.blooddonation.dao;

import com.blooddonation.model.Appointment;
import com.blooddonation.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class AppointmentDAO {
    
    public void addAppointment(Appointment appointment) throws SQLException {
        String query = "INSERT INTO appointments (donor_id, camp_id, appointment_date, time_slot, status, notes, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, appointment.getDonorId());
            stmt.setInt(2, appointment.getCampId());
            stmt.setTimestamp(3, new java.sql.Timestamp(appointment.getAppointmentDate().getTime()));
            stmt.setString(4, appointment.getTimeSlot());
            stmt.setString(5, appointment.getStatus());
            stmt.setString(6, appointment.getNotes());
            stmt.setTimestamp(7, appointment.getCreatedAt() != null ? new java.sql.Timestamp(appointment.getCreatedAt().getTime()) : new java.sql.Timestamp(System.currentTimeMillis()));
            stmt.executeUpdate();
        }
    }
    
    public List<Appointment> getAllAppointments() throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT * FROM appointments ORDER BY appointment_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Appointment appointment = mapResultSetToAppointment(rs);
                appointments.add(appointment);
            }
        }
        return appointments;
    }
    
    public int getPendingAppointmentsCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM appointments WHERE status = 'PENDING'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public int getCompletedAppointmentsByMonth(int month, int year) throws SQLException {
        String query = "SELECT COUNT(*) FROM appointments WHERE status = 'COMPLETED' AND MONTH(appointment_date) = ? AND YEAR(appointment_date) = ?";
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
    
    public List<Appointment> getRecentAppointments(int limit) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT * FROM appointments ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    appointments.add(mapResultSetToAppointment(rs));
                }
            }
        }
        return appointments;
    }
    
    public List<Appointment> getAppointmentsByDonorId(int donorId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE donor_id = ? ORDER BY appointment_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, donorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = mapResultSetToAppointment(rs);
                    appointments.add(appointment);
                }
            }
        }
        return appointments;
    }
    
    public List<Appointment> getAppointmentsByCampId(int campId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE camp_id = ? ORDER BY appointment_date ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, campId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = mapResultSetToAppointment(rs);
                    appointments.add(appointment);
                }
            }
        }
        return appointments;
    }
    
    public List<Appointment> getAppointmentsByStatus(String status) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE status = ? ORDER BY appointment_date ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = mapResultSetToAppointment(rs);
                    appointments.add(appointment);
                }
            }
        }
        return appointments;
    }
    
    public List<Appointment> getPendingAppointments() throws SQLException {
        return getAppointmentsByStatus("PENDING");
    }
    
    public List<Appointment> getApprovedAppointments() throws SQLException {
        return getAppointmentsByStatus("APPROVED");
    }
    
    public List<Appointment> getAppointmentsByDate(Date date) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE DATE(appointment_date) = ? ORDER BY appointment_date ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setDate(1, new java.sql.Date(date.getTime()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = mapResultSetToAppointment(rs);
                    appointments.add(appointment);
                }
            }
        }
        return appointments;
    }
    
    public List<Appointment> getUpcomingAppointments(int days) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE appointment_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL ? DAY) ORDER BY appointment_date ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, days);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = mapResultSetToAppointment(rs);
                    appointments.add(appointment);
                }
            }
        }
        return appointments;
    }
    
    public Appointment getAppointmentById(int appointmentId) throws SQLException {
        String query = "SELECT * FROM appointments WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, appointmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAppointment(rs);
                }
            }
        }
        return null;
    }
    
    public void updateAppointmentStatus(int appointmentId, String status) throws SQLException {
        String query = "UPDATE appointments SET status = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            stmt.setInt(2, appointmentId);
            stmt.executeUpdate();
        }
    }
    
    public void approveAppointment(int appointmentId, int approvedBy) throws SQLException {
        String query = "UPDATE appointments SET status = 'APPROVED', updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, appointmentId);
            stmt.executeUpdate();
        }
    }
    
    public void rejectAppointment(int appointmentId, int rejectedBy) throws SQLException {
        String query = "UPDATE appointments SET status = 'REJECTED', updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, appointmentId);
            stmt.executeUpdate();
        }
    }
    
    public void cancelAppointment(int appointmentId) throws SQLException {
        String query = "UPDATE appointments SET status = 'CANCELLED', updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, appointmentId);
            stmt.executeUpdate();
        }
    }
    
    public void completeAppointment(int appointmentId) throws SQLException {
        String query = "UPDATE appointments SET status = 'COMPLETED', completed_at = NOW(), updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, appointmentId);
            stmt.executeUpdate();
        }
    }
    
    public void updateAppointment(Appointment appointment) throws SQLException {
        String query = "UPDATE appointments SET appointment_date = ?, time_slot = ?, notes = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setTimestamp(1, new java.sql.Timestamp(appointment.getAppointmentDate().getTime()));
            stmt.setString(2, appointment.getTimeSlot());
            stmt.setString(3, appointment.getNotes());
            stmt.setInt(4, appointment.getId());
            stmt.executeUpdate();
        }
    }
    
    public void deleteAppointment(int appointmentId) throws SQLException {
        String query = "DELETE FROM appointments WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, appointmentId);
            stmt.executeUpdate();
        }
    }
    
    public boolean isTimeSlotAvailable(int campId, Date appointmentDate, String timeSlot) throws SQLException {
        String query = "SELECT COUNT(*) FROM appointments WHERE camp_id = ? AND DATE(appointment_date) = ? AND time_slot = ? AND status IN ('PENDING', 'APPROVED')";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, campId);
            stmt.setDate(2, new java.sql.Date(appointmentDate.getTime()));
            stmt.setString(3, timeSlot);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        }
        return false;
    }
    
    public List<String> getAvailableTimeSlots(int campId, Date appointmentDate) throws SQLException {
        List<String> availableSlots = new ArrayList<>();
        String[] timeSlots = {"09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM"};
        
        for (String timeSlot : timeSlots) {
            if (isTimeSlotAvailable(campId, appointmentDate, timeSlot)) {
                availableSlots.add(timeSlot);
            }
        }
        
        return availableSlots;
    }
    
    public int getAppointmentCountByStatus(String status) throws SQLException {
        String query = "SELECT COUNT(*) FROM appointments WHERE status = ?";
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
    
    public List<Appointment> getAppointmentsForReminder(int hoursBefore) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE status = 'APPROVED' AND appointment_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL ? HOUR) ORDER BY appointment_date ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, hoursBefore);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = mapResultSetToAppointment(rs);
                    appointments.add(appointment);
                }
            }
        }
        return appointments;
    }
    
    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setId(rs.getInt("id"));
        appointment.setDonorId(rs.getInt("donor_id"));
        appointment.setCampId(rs.getInt("camp_id"));
        appointment.setAppointmentDate(rs.getTimestamp("appointment_date"));
        appointment.setTimeSlot(rs.getString("time_slot"));
        appointment.setStatus(rs.getString("status"));
        appointment.setNotes(rs.getString("notes"));
        appointment.setCreatedAt(rs.getTimestamp("created_at"));
        appointment.setUpdatedAt(rs.getTimestamp("updated_at"));
        // Note: approved_at and approved_by columns don't exist in the appointments table
        // These fields are set to null/default values
        appointment.setApprovedAt(null);
        appointment.setApprovedBy(0);
        return appointment;
    }
}