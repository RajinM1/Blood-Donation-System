package com.blooddonation.service;

import com.blooddonation.dao.NotificationDAO;
import com.blooddonation.model.Notification;
import com.blooddonation.util.EmailUtil;
import com.blooddonation.util.SMSUtil;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

public class NotificationService {
    
    private NotificationDAO notificationDAO;
    
    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
    }
    
    /**
     * Send notification to user
     */
    public boolean sendNotification(int userId, String message, String type) throws SQLException {
        Notification notification = new Notification();
        notification.setUserId(userId);
        notification.setMessage(message);
        notification.setType(type);
        notification.setCreatedAt(new Date());
        
        notificationDAO.addNotification(notification);
        return true;
    }
    
    /**
     * Get user notifications
     */
    public List<Notification> getUserNotifications(int userId) throws SQLException {
        return notificationDAO.getNotificationsByUserId(userId);
    }
    
    /**
     * Mark notification as read
     */
    public boolean markAsRead(int notificationId) throws SQLException {
        notificationDAO.markAsRead(notificationId);
        return true;
    }
    
    /**
     * Send email notification
     */
    public boolean sendEmailNotification(String email, String subject, String message) {
        try {
            EmailUtil.sendEmail(email, subject, message);
            return true;
                } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Send SMS notification
     */
    public boolean sendSMSNotification(String phone, String message) {
        try {
            SMSUtil.sendSMS(phone, message);
            return true;
            } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Send notification with Notification object
     */
    public boolean sendNotification(Notification notification) throws SQLException {
        notificationDAO.addNotification(notification);
        return true;
    }
    
    /**
     * Send appointment confirmation
     */
    public boolean sendAppointmentConfirmation(int donorId, String appointmentDate, String timeSlot) throws SQLException {
        String message = "Your blood donation appointment is confirmed for " + appointmentDate + " at " + timeSlot;
        return sendNotification(donorId, message, "APPOINTMENT");
    }
    
    /**
     * Send blood request approval
     */
    public boolean sendBloodRequestApproval(int hospitalId, String bloodGroup, int quantity) throws SQLException {
        String message = "Your blood request for " + quantity + " units of " + bloodGroup + " has been approved";
        return sendNotification(hospitalId, message, "REQUEST");
    }
    
    /**
     * Send blood request rejection
     */
    public boolean sendBloodRequestRejection(int hospitalId, String bloodGroup, int quantity, String reason) throws SQLException {
        String message = "Your blood request for " + quantity + " units of " + bloodGroup + " has been rejected. Reason: " + reason;
        return sendNotification(hospitalId, message, "REQUEST");
    }
    
    /**
     * Send appointment rejection
     */
    public boolean sendAppointmentRejection(int donorId, String reason) throws SQLException {
        String message = "Your blood donation appointment has been rejected. Reason: " + reason;
        return sendNotification(donorId, message, "APPOINTMENT");
    }
    
    /**
     * Send appointment reminder
     */
    public boolean sendAppointmentReminder(int donorId, String appointmentDate, String timeSlot) throws SQLException {
        String message = "Reminder: Your blood donation appointment is scheduled for " + appointmentDate + " at " + timeSlot;
        return sendNotification(donorId, message, "REMINDER");
    }
    
    /**
     * Send appointment reminders to all users with upcoming appointments (static method for scheduler)
     */
    public static void sendAppointmentReminders() {
        try {
            NotificationService service = new NotificationService();
            // This would typically query the database for upcoming appointments
            // and send reminders to those users
            System.out.println("Sending appointment reminders...");
        } catch (Exception e) {
            System.err.println("Error sending appointment reminders: " + e.getMessage());
        }
    }
}