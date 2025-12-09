package com.blooddonation.service;

import com.blooddonation.dao.AppointmentDAO;
import com.blooddonation.dao.DonorDAO;
import com.blooddonation.dao.DonationCampDAO;
import com.blooddonation.dao.NotificationDAO;
import com.blooddonation.model.Appointment;
import com.blooddonation.model.Donor;
import com.blooddonation.model.DonationCamp;
import com.blooddonation.util.ValidationUtil;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class AppointmentService {
    
    private AppointmentDAO appointmentDAO;
    private DonorDAO donorDAO;
    private DonationCampDAO campDAO;
    private NotificationService notificationService;
    
    public AppointmentService() {
        this.appointmentDAO = new AppointmentDAO();
        this.donorDAO = new DonorDAO();
        this.campDAO = new DonationCampDAO();
        this.notificationService = new NotificationService();
    }
    
    /**
     * Create a new appointment
     */
    public boolean createAppointment(int userId, int campId, Date appointmentDate, String timeSlot) throws SQLException {
        // Get or create donor record
        Donor donor = donorDAO.getDonorByUserId(userId);
        if (donor == null) {
            // Create a basic donor record if it doesn't exist
            donor = new Donor();
            donor.setUserId(userId);
            donor.setName("Donor " + userId); // Temporary name
            donor.setStatus("PENDING");
            donorDAO.addDonor(donor);
            // Get the newly created donor with its ID
            donor = donorDAO.getDonorByUserId(userId);
        }
        
        // Validate donor eligibility
        if (!donor.isEligibleForDonation()) {
            throw new IllegalArgumentException("Donor is not eligible for donation");
        }
        
        // Validate appointment date
        if (!ValidationUtil.isValidAppointmentDate(appointmentDate)) {
            throw new IllegalArgumentException("Appointment date must be in the future");
        }
        
        // Check if time slot is available
        if (!appointmentDAO.isTimeSlotAvailable(campId, appointmentDate, timeSlot)) {
            throw new IllegalArgumentException("Time slot is not available");
        }
        
        // Create appointment
        Appointment appointment = new Appointment(donor.getId(), campId, appointmentDate, timeSlot);
        appointmentDAO.addAppointment(appointment);
        
        // Send confirmation notification
        notificationService.sendAppointmentConfirmation(userId, appointmentDate.toString(), timeSlot);
        
        return true;
    }
    
    /**
     * Get available time slots for a specific date and camp
     */
    public List<String> getAvailableTimeSlots(int campId, Date appointmentDate) throws SQLException {
        return appointmentDAO.getAvailableTimeSlots(campId, appointmentDate);
    }
    
    /**
     * Get appointments for a donor
     */
    public List<Appointment> getDonorAppointments(int donorId) throws SQLException {
        return appointmentDAO.getAppointmentsByDonorId(donorId);
    }
    
    /**
     * Get appointments for a camp
     */
    public List<Appointment> getCampAppointments(int campId) throws SQLException {
        return appointmentDAO.getAppointmentsByCampId(campId);
    }
    
    /**
     * Get pending appointments
     */
    public List<Appointment> getPendingAppointments() throws SQLException {
        return appointmentDAO.getPendingAppointments();
    }
    
    /**
     * Get approved appointments
     */
    public List<Appointment> getApprovedAppointments() throws SQLException {
        return appointmentDAO.getApprovedAppointments();
    }
    
    /**
     * Approve an appointment
     */
    public boolean approveAppointment(int appointmentId, int approvedBy) throws SQLException {
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
        if (appointment == null || !appointment.isPending()) {
            return false;
        }
        
        appointmentDAO.approveAppointment(appointmentId, approvedBy);
        
        // Send approval notification
        notificationService.sendAppointmentConfirmation(appointment.getDonorId(), 
            appointment.getAppointmentDate().toString(), appointment.getTimeSlot());
        
        return true;
    }
    
    /**
     * Reject an appointment
     */
    public boolean rejectAppointment(int appointmentId, int rejectedBy, String reason) throws SQLException {
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
        if (appointment == null || !appointment.isPending()) {
            return false;
        }
        
        appointmentDAO.rejectAppointment(appointmentId, rejectedBy);
        
        // Send rejection notification
        notificationService.sendAppointmentRejection(appointment.getDonorId(), reason);
        
        return true;
    }
    
    /**
     * Cancel an appointment
     */
    public boolean cancelAppointment(int appointmentId) throws SQLException {
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
        if (appointment == null || !appointment.canBeCancelled()) {
            return false;
        }
        
        appointmentDAO.cancelAppointment(appointmentId);
        
        // Send cancellation notification
        notificationService.sendAppointmentRejection(appointment.getDonorId(), "Appointment cancelled by donor");
        
        return true;
    }
    
    /**
     * Complete an appointment
     */
    public boolean completeAppointment(int appointmentId) throws SQLException {
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
        if (appointment == null || !appointment.isApproved()) {
            return false;
        }
        
        appointmentDAO.completeAppointment(appointmentId);
        
        // Update donor's last donation date
        Donor donor = donorDAO.getDonorByUserId(appointment.getDonorId());
        if (donor != null) {
            donor.setLastDonationDate(new Date());
            donorDAO.updateDonor(donor);
        }
        
        return true;
    }
    
    /**
     * Get upcoming appointments for reminders
     */
    public List<Appointment> getUpcomingAppointments(int days) throws SQLException {
        return appointmentDAO.getUpcomingAppointments(days);
    }
    
    /**
     * Send appointment reminders
     */
    public void sendAppointmentReminders() throws SQLException {
        // Get appointments for tomorrow (24 hours from now)
        List<Appointment> upcomingAppointments = appointmentDAO.getAppointmentsForReminder(24);
        
        for (Appointment appointment : upcomingAppointments) {
            notificationService.sendAppointmentReminder(appointment.getDonorId(), 
                appointment.getAppointmentDate().toString(), appointment.getTimeSlot());
        }
    }
    
    /**
     * Get appointment statistics
     */
    public int getAppointmentCountByStatus(String status) throws SQLException {
        return appointmentDAO.getAppointmentCountByStatus(status);
    }
    
    /**
     * Get appointments by date
     */
    public List<Appointment> getAppointmentsByDate(Date date) throws SQLException {
        return appointmentDAO.getAppointmentsByDate(date);
    }
    
    /**
     * Update appointment
     */
    public boolean updateAppointment(int appointmentId, Date newDate, String newTimeSlot) throws SQLException {
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
        if (appointment == null || !appointment.canBeCancelled()) {
            return false;
        }
        
        // Validate new date
        if (!ValidationUtil.isValidAppointmentDate(newDate)) {
            throw new IllegalArgumentException("Appointment date must be in the future");
        }
        
        // Check if new time slot is available
        if (!appointmentDAO.isTimeSlotAvailable(appointment.getCampId(), newDate, newTimeSlot)) {
            throw new IllegalArgumentException("Time slot is not available");
        }
        
        appointment.setAppointmentDate(newDate);
        appointment.setTimeSlot(newTimeSlot);
        appointmentDAO.updateAppointment(appointment);
        
        return true;
    }
    
    /**
     * Get appointment by ID
     */
    public Appointment getAppointmentById(int appointmentId) throws SQLException {
        return appointmentDAO.getAppointmentById(appointmentId);
    }
    
    /**
     * Delete appointment
     */
    public boolean deleteAppointment(int appointmentId) throws SQLException {
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
        if (appointment == null || !appointment.canBeCancelled()) {
            return false;
        }
        
        appointmentDAO.deleteAppointment(appointmentId);
        return true;
    }
    
    /**
     * Get available dates for a camp (next 30 days)
     */
    public List<Date> getAvailableDates(int campId) throws SQLException {
        List<Date> availableDates = new ArrayList<>();
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, 1); // Start from tomorrow
        
        for (int i = 0; i < 30; i++) {
            Date date = cal.getTime();
            List<String> timeSlots = appointmentDAO.getAvailableTimeSlots(campId, date);
            if (!timeSlots.isEmpty()) {
                availableDates.add(date);
            }
            cal.add(Calendar.DAY_OF_MONTH, 1);
        }
        
        return availableDates;
    }
    
    /**
     * Check if donor has pending appointment
     */
    public boolean hasPendingAppointment(int donorId) throws SQLException {
        List<Appointment> appointments = appointmentDAO.getAppointmentsByDonorId(donorId);
        for (Appointment appointment : appointments) {
            if (appointment.isPending() || appointment.isApproved()) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Get appointment history for a donor
     */
    public List<Appointment> getDonorAppointmentHistory(int donorId) throws SQLException {
        return appointmentDAO.getAppointmentsByDonorId(donorId);
    }
    
    /**
     * Get appointment statistics for dashboard
     */
    public AppointmentStats getAppointmentStats() throws SQLException {
        AppointmentStats stats = new AppointmentStats();
        stats.setPendingCount(appointmentDAO.getAppointmentCountByStatus("PENDING"));
        stats.setApprovedCount(appointmentDAO.getAppointmentCountByStatus("APPROVED"));
        stats.setRejectedCount(appointmentDAO.getAppointmentCountByStatus("REJECTED"));
        stats.setCompletedCount(appointmentDAO.getAppointmentCountByStatus("COMPLETED"));
        stats.setCancelledCount(appointmentDAO.getAppointmentCountByStatus("CANCELLED"));
        return stats;
    }
    
    /**
     * Inner class for appointment statistics
     */
    public static class AppointmentStats {
        private int pendingCount;
        private int approvedCount;
        private int rejectedCount;
        private int completedCount;
        private int cancelledCount;
        
        // Getters and setters
        public int getPendingCount() { return pendingCount; }
        public void setPendingCount(int pendingCount) { this.pendingCount = pendingCount; }
        
        public int getApprovedCount() { return approvedCount; }
        public void setApprovedCount(int approvedCount) { this.approvedCount = approvedCount; }
        
        public int getRejectedCount() { return rejectedCount; }
        public void setRejectedCount(int rejectedCount) { this.rejectedCount = rejectedCount; }
        
        public int getCompletedCount() { return completedCount; }
        public void setCompletedCount(int completedCount) { this.completedCount = completedCount; }
        
        public int getCancelledCount() { return cancelledCount; }
        public void setCancelledCount(int cancelledCount) { this.cancelledCount = cancelledCount; }
    }
}


