package com.blooddonation.service;

import com.blooddonation.dao.UserDAO;
import com.blooddonation.dao.DonorDAO;
import com.blooddonation.dao.AuditLogDAO;
import com.blooddonation.model.User;
import com.blooddonation.model.Donor;
import com.blooddonation.model.AuditLog;
import com.blooddonation.util.PasswordUtil;
import com.blooddonation.util.ValidationUtil;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

public class UserManagementService {
    
    private UserDAO userDAO;
    private DonorDAO donorDAO;
    private AuditLogDAO auditLogDAO;
    
    public UserManagementService() {
        this.userDAO = new UserDAO();
        this.donorDAO = new DonorDAO();
        this.auditLogDAO = new AuditLogDAO();
    }
    
    /**
     * Create a new user
     */
    public boolean createUser(String username, String password, String role, String email, String phone, 
                            String name, int age, String gender, String bloodGroup, double weight) throws SQLException {
        // Validate input
        if (!ValidationUtil.isValidUsername(username)) {
            throw new IllegalArgumentException("Invalid username format");
        }
        
        if (!ValidationUtil.isValidPassword(password)) {
            throw new IllegalArgumentException("Invalid password format");
        }
        
        if (!ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Invalid email format");
        }
        
        if (!ValidationUtil.isValidPhone(phone)) {
            throw new IllegalArgumentException("Invalid phone format");
        }
        
        if (!ValidationUtil.isValidAge(age)) {
            throw new IllegalArgumentException("Invalid age");
        }
        
        if (!ValidationUtil.isValidGender(gender)) {
            throw new IllegalArgumentException("Invalid gender");
        }
        
        if (!ValidationUtil.isValidBloodGroup(bloodGroup)) {
            throw new IllegalArgumentException("Invalid blood group");
        }
        
        if (!ValidationUtil.isValidWeight(weight)) {
            throw new IllegalArgumentException("Invalid weight");
        }
        
        // Check if username already exists
        if (userDAO.getUserByUsername(username) != null) {
            throw new IllegalStateException("Username already exists");
        }
        
        // Check if email already exists
        if (userDAO.getUserByEmail(email) != null) {
            throw new IllegalStateException("Email already exists");
        }
        
        // Check if phone already exists
        if (userDAO.getUserByPhone(phone) != null) {
            throw new IllegalStateException("Phone already exists");
        }
        
        // Create user
        User user = new User();
        user.setUsername(username);
        user.setPassword(password); // Don't hash here - will be hashed in addUser
        user.setRole(role);
        user.setEmail(email);
        user.setPhone(phone);
        user.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));
        
        int userId = userDAO.addUser(user);
        user.setId(userId);
        
        // Create donor if role is DONOR
        if ("DONOR".equals(role)) {
            Donor donor = new Donor(userId, name, age, gender, bloodGroup, weight);
            donor.setStatus("ACTIVE");
            donor.setCreatedAt(new Date());
            donorDAO.addDonor(donor);
        }
        
        // Log the action
        auditLogDAO.addAuditLog(new AuditLog(userId, "USER_CREATED", "User", userId, 
            "User created with role: " + role, "127.0.0.1"));
        
        return true;
    }
    
    /**
     * Update user information
     */
    public boolean updateUser(int userId, String username, String email, String phone, 
                            String name, int age, String gender, String bloodGroup, double weight) throws SQLException {
        User user = userDAO.getUserById(userId);
        if (user == null) {
            return false;
        }
        
        // Validate input
        if (!ValidationUtil.isValidUsername(username)) {
            throw new IllegalArgumentException("Invalid username format");
        }
        
        if (!ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Invalid email format");
        }
        
        if (!ValidationUtil.isValidPhone(phone)) {
            throw new IllegalArgumentException("Invalid phone format");
        }
        
        if (!ValidationUtil.isValidAge(age)) {
            throw new IllegalArgumentException("Invalid age");
        }
        
        if (!ValidationUtil.isValidGender(gender)) {
            throw new IllegalArgumentException("Invalid gender");
        }
        
        if (!ValidationUtil.isValidBloodGroup(bloodGroup)) {
            throw new IllegalArgumentException("Invalid blood group");
        }
        
        if (!ValidationUtil.isValidWeight(weight)) {
            throw new IllegalArgumentException("Invalid weight");
        }
        
        // Check if username already exists (excluding current user)
        User existingUser = userDAO.getUserByUsername(username);
        if (existingUser != null && existingUser.getId() != userId) {
            throw new IllegalStateException("Username already exists");
        }
        
        // Check if email already exists (excluding current user)
        User existingEmail = userDAO.getUserByEmail(email);
        if (existingEmail != null && existingEmail.getId() != userId) {
            throw new IllegalStateException("Email already exists");
        }
        
        // Check if phone already exists (excluding current user)
        User existingPhone = userDAO.getUserByPhone(phone);
        if (existingPhone != null && existingPhone.getId() != userId) {
            throw new IllegalStateException("Phone already exists");
        }
        
        // Update user
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        userDAO.updateUser(user);
        
        // Update donor if role is DONOR
        if ("DONOR".equals(user.getRole())) {
            Donor donor = donorDAO.getDonorByUserId(userId);
            if (donor != null) {
                donor.setName(name);
                donor.setAge(age);
                donor.setGender(gender);
                donor.setBloodGroup(bloodGroup);
                donor.setWeight(weight);
                donor.setUpdatedAt(new Date());
                donorDAO.updateDonor(donor);
            }
        }
        
        // Log the action
        auditLogDAO.addAuditLog(new AuditLog(userId, "USER_UPDATED", "User", userId, 
            "User information updated", "127.0.0.1"));
        
        return true;
    }
    
    /**
     * Change user password
     */
    public boolean changePassword(int userId, String oldPassword, String newPassword) throws SQLException {
        User user = userDAO.getUserById(userId);
        if (user == null) {
            return false;
        }
        
        // Validate new password
        if (!ValidationUtil.isValidPassword(newPassword)) {
            throw new IllegalArgumentException("Invalid new password format");
        }
        
        // Verify old password
        if (!PasswordUtil.verifyPassword(oldPassword, user.getPassword())) {
            throw new IllegalArgumentException("Old password is incorrect");
        }
        
        // Update password
        userDAO.updateUserPassword(userId, PasswordUtil.hashPassword(newPassword));
        
        // Log the action
        auditLogDAO.addAuditLog(new AuditLog(userId, "PASSWORD_CHANGED", "User", userId, 
            "Password changed", "127.0.0.1"));
        
        return true;
    }
    
    /**
     * Reset user password
     */
    public boolean resetPassword(int userId, String newPassword) throws SQLException {
        User user = userDAO.getUserById(userId);
        if (user == null) {
            return false;
        }
        
        // Validate new password
        if (!ValidationUtil.isValidPassword(newPassword)) {
            throw new IllegalArgumentException("Invalid new password format");
        }
        
        // Update password
        userDAO.updateUserPassword(userId, PasswordUtil.hashPassword(newPassword));
        
        // Log the action
        auditLogDAO.addAuditLog(new AuditLog(userId, "PASSWORD_RESET", "User", userId, 
            "Password reset by admin", "127.0.0.1"));
        
        return true;
    }
    
    /**
     * Deactivate user
     */
    public boolean deactivateUser(int userId) throws SQLException {
        User user = userDAO.getUserById(userId);
        if (user == null) {
            return false;
        }
        
        // Deactivate user
        userDAO.updateUserStatus(userId, "INACTIVE");
        
        // Deactivate donor if role is DONOR
        if ("DONOR".equals(user.getRole())) {
            Donor donor = donorDAO.getDonorByUserId(userId);
            if (donor != null) {
                donor.setStatus("INACTIVE");
                donor.setUpdatedAt(new Date());
                donorDAO.updateDonor(donor);
            }
        }
        
        // Log the action
        auditLogDAO.addAuditLog(new AuditLog(userId, "USER_DEACTIVATED", "User", userId, 
            "User deactivated", "127.0.0.1"));
        
        return true;
    }
    
    /**
     * Activate user
     */
    public boolean activateUser(int userId) throws SQLException {
        User user = userDAO.getUserById(userId);
        if (user == null) {
            return false;
        }
        
        // Activate user
        userDAO.updateUserStatus(userId, "ACTIVE");
        
        // Activate donor if role is DONOR
        if ("DONOR".equals(user.getRole())) {
            Donor donor = donorDAO.getDonorByUserId(userId);
            if (donor != null) {
                donor.setStatus("ACTIVE");
                donor.setUpdatedAt(new Date());
                donorDAO.updateDonor(donor);
            }
        }
        
        // Log the action
        auditLogDAO.addAuditLog(new AuditLog(userId, "USER_ACTIVATED", "User", userId, 
            "User activated", "127.0.0.1"));
        
        return true;
    }
    
    /**
     * Delete user
     */
    public boolean deleteUser(int userId) throws SQLException {
        User user = userDAO.getUserById(userId);
        if (user == null) {
            return false;
        }
        
        // Delete donor if role is DONOR
        if ("DONOR".equals(user.getRole())) {
            Donor donor = donorDAO.getDonorByUserId(userId);
            if (donor != null) {
                donorDAO.deleteDonor(donor.getId());
            }
        }
        
        // Delete user
        userDAO.deleteUser(userId);
        
        // Log the action
        auditLogDAO.addAuditLog(new AuditLog(userId, "USER_DELETED", "User", userId, 
            "User deleted", "127.0.0.1"));
        
        return true;
    }
    
    /**
     * Get user by ID
     */
    public User getUserById(int userId) throws SQLException {
        return userDAO.getUserById(userId);
    }
    
    /**
     * Get user by username
     */
    public User getUserByUsername(String username) throws SQLException {
        return userDAO.getUserByUsername(username);
    }
    
    /**
     * Get user by email
     */
    public User getUserByEmail(String email) throws SQLException {
        return userDAO.getUserByEmail(email);
    }
    
    /**
     * Get all users
     */
    public List<User> getAllUsers() throws SQLException {
        return userDAO.getAllUsers();
    }
    
    /**
     * Get users by role
     */
    public List<User> getUsersByRole(String role) throws SQLException {
        return userDAO.getUsersByRole(role);
    }
    
    /**
     * Get active users
     */
    public List<User> getActiveUsers() throws SQLException {
        return userDAO.getActiveUsers();
    }
    
    /**
     * Get inactive users
     */
    public List<User> getInactiveUsers() throws SQLException {
        return userDAO.getInactiveUsers();
    }
    
    /**
     * Get users by status
     */
    public List<User> getUsersByStatus(String status) throws SQLException {
        return userDAO.getUsersByStatus(status);
    }
    
    /**
     * Search users
     */
    public List<User> searchUsers(String searchTerm) throws SQLException {
        return userDAO.searchUsers(searchTerm);
    }
    
    /**
     * Get user statistics
     */
    public UserStats getUserStats() throws SQLException {
        UserStats stats = new UserStats();
        stats.setTotalUsers(userDAO.getUserCount());
        stats.setActiveUsers(userDAO.getUserCountByStatus("ACTIVE"));
        stats.setInactiveUsers(userDAO.getUserCountByStatus("INACTIVE"));
        stats.setDonorUsers(userDAO.getUserCountByRole("DONOR"));
        stats.setManagerUsers(userDAO.getUserCountByRole("MANAGER"));
        stats.setOfficerUsers(userDAO.getUserCountByRole("OFFICER"));
        stats.setHospitalUsers(userDAO.getUserCountByRole("HOSPITAL"));
        stats.setHospitalCoordinatorUsers(userDAO.getUserCountByRole("HOSPITAL_COORDINATOR"));
        stats.setMedicalUsers(userDAO.getUserCountByRole("MEDICAL"));
        return stats;
    }
    
    /**
     * Get user summary for dashboard
     */
    public UserSummary getUserSummary() throws SQLException {
        UserSummary summary = new UserSummary();
        summary.setTotalUsers(userDAO.getUserCount());
        summary.setActiveUsers(userDAO.getUserCountByStatus("ACTIVE"));
        summary.setInactiveUsers(userDAO.getUserCountByStatus("INACTIVE"));
        summary.setDonorUsers(userDAO.getUserCountByRole("DONOR"));
        summary.setManagerUsers(userDAO.getUserCountByRole("MANAGER"));
        summary.setOfficerUsers(userDAO.getUserCountByRole("OFFICER"));
        summary.setHospitalUsers(userDAO.getUserCountByRole("HOSPITAL"));
        summary.setHospitalCoordinatorUsers(userDAO.getUserCountByRole("HOSPITAL_COORDINATOR"));
        summary.setMedicalUsers(userDAO.getUserCountByRole("MEDICAL"));
        return summary;
    }
    
    /**
     * Get recent users
     */
    public List<User> getRecentUsers(int limit) throws SQLException {
        return userDAO.getRecentUsers(limit);
    }
    
    /**
     * Get users by date range
     */
    public List<User> getUsersByDateRange(Date startDate, Date endDate) throws SQLException {
        return userDAO.getUsersByDateRange(startDate, endDate);
    }
    
    /**
     * Get users by role and status
     */
    public List<User> getUsersByRoleAndStatus(String role, String status) throws SQLException {
        return userDAO.getUsersByRoleAndStatus(role, status);
    }
    
    /**
     * Get user count by role
     */
    public int getUserCountByRole(String role) throws SQLException {
        return userDAO.getUserCountByRole(role);
    }
    
    /**
     * Get user count by status
     */
    public int getUserCountByStatus(String status) throws SQLException {
        return userDAO.getUserCountByStatus(status);
    }
    
    /**
     * Get total user count
     */
    public int getTotalUserCount() throws SQLException {
        return userDAO.getUserCount();
    }
    
    /**
     * Get active user count
     */
    public int getActiveUserCount() throws SQLException {
        return userDAO.getUserCountByStatus("ACTIVE");
    }
    
    /**
     * Get inactive user count
     */
    public int getInactiveUserCount() throws SQLException {
        return userDAO.getUserCountByStatus("INACTIVE");
    }
    
    /**
     * Get donor count
     */
    public int getDonorCount() throws SQLException {
        return userDAO.getUserCountByRole("DONOR");
    }
    
    /**
     * Get manager count
     */
    public int getManagerCount() throws SQLException {
        return userDAO.getUserCountByRole("MANAGER");
    }
    
    /**
     * Get officer count
     */
    public int getOfficerCount() throws SQLException {
        return userDAO.getUserCountByRole("OFFICER");
    }
    
    /**
     * Get hospital count
     */
    public int getHospitalCount() throws SQLException {
        return userDAO.getUserCountByRole("HOSPITAL");
    }
    
    /**
     * Get hospital coordinator count
     */
    public int getHospitalCoordinatorCount() throws SQLException {
        return userDAO.getUserCountByRole("HOSPITAL_COORDINATOR");
    }
    
    /**
     * Get medical count
     */
    public int getMedicalCount() throws SQLException {
        return userDAO.getUserCountByRole("MEDICAL");
    }
    
    /**
     * Inner class for user statistics
     */
    public static class UserStats {
        private int totalUsers;
        private int activeUsers;
        private int inactiveUsers;
        private int donorUsers;
        private int managerUsers;
        private int officerUsers;
        private int hospitalUsers;
        private int hospitalCoordinatorUsers;
        private int medicalUsers;
        
        // Getters and setters
        public int getTotalUsers() { return totalUsers; }
        public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
        
        public int getActiveUsers() { return activeUsers; }
        public void setActiveUsers(int activeUsers) { this.activeUsers = activeUsers; }
        
        public int getInactiveUsers() { return inactiveUsers; }
        public void setInactiveUsers(int inactiveUsers) { this.inactiveUsers = inactiveUsers; }
        
        public int getDonorUsers() { return donorUsers; }
        public void setDonorUsers(int donorUsers) { this.donorUsers = donorUsers; }
        
        public int getManagerUsers() { return managerUsers; }
        public void setManagerUsers(int managerUsers) { this.managerUsers = managerUsers; }
        
        public int getOfficerUsers() { return officerUsers; }
        public void setOfficerUsers(int officerUsers) { this.officerUsers = officerUsers; }
        
        public int getHospitalUsers() { return hospitalUsers; }
        public void setHospitalUsers(int hospitalUsers) { this.hospitalUsers = hospitalUsers; }
        
        public int getHospitalCoordinatorUsers() { return hospitalCoordinatorUsers; }
        public void setHospitalCoordinatorUsers(int hospitalCoordinatorUsers) { this.hospitalCoordinatorUsers = hospitalCoordinatorUsers; }
        
        public int getMedicalUsers() { return medicalUsers; }
        public void setMedicalUsers(int medicalUsers) { this.medicalUsers = medicalUsers; }
    }
    
    /**
     * Inner class for user summary
     */
    public static class UserSummary {
        private int totalUsers;
        private int activeUsers;
        private int inactiveUsers;
        private int donorUsers;
        private int managerUsers;
        private int officerUsers;
        private int hospitalUsers;
        private int hospitalCoordinatorUsers;
        private int medicalUsers;
        
        // Getters and setters
        public int getTotalUsers() { return totalUsers; }
        public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
        
        public int getActiveUsers() { return activeUsers; }
        public void setActiveUsers(int activeUsers) { this.activeUsers = activeUsers; }
        
        public int getInactiveUsers() { return inactiveUsers; }
        public void setInactiveUsers(int inactiveUsers) { this.inactiveUsers = inactiveUsers; }
        
        public int getDonorUsers() { return donorUsers; }
        public void setDonorUsers(int donorUsers) { this.donorUsers = donorUsers; }
        
        public int getManagerUsers() { return managerUsers; }
        public void setManagerUsers(int managerUsers) { this.managerUsers = managerUsers; }
        
        public int getOfficerUsers() { return officerUsers; }
        public void setOfficerUsers(int officerUsers) { this.officerUsers = officerUsers; }
        
        public int getHospitalUsers() { return hospitalUsers; }
        public void setHospitalUsers(int hospitalUsers) { this.hospitalUsers = hospitalUsers; }
        
        public int getHospitalCoordinatorUsers() { return hospitalCoordinatorUsers; }
        public void setHospitalCoordinatorUsers(int hospitalCoordinatorUsers) { this.hospitalCoordinatorUsers = hospitalCoordinatorUsers; }
        
        public int getMedicalUsers() { return medicalUsers; }
        public void setMedicalUsers(int medicalUsers) { this.medicalUsers = medicalUsers; }
    }
}