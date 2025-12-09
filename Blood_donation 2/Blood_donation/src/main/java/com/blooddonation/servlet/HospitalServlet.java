package com.blooddonation.servlet;

import com.blooddonation.dao.BloodRequestDAO;
import com.blooddonation.dao.HospitalDAO;
import com.blooddonation.dao.NotificationDAO;
import com.blooddonation.dao.UserDAO;
import com.blooddonation.model.BloodRequest;
import com.blooddonation.model.Hospital;
import com.blooddonation.model.Notification;
import com.blooddonation.model.User;
import com.blooddonation.util.ValidationUtil;
import com.blooddonation.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class HospitalServlet extends HttpServlet {
    
    private BloodRequestDAO bloodRequestDAO;
    private HospitalDAO hospitalDAO;
    private UserDAO userDAO;
    private NotificationDAO notificationDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.bloodRequestDAO = new BloodRequestDAO();
        this.hospitalDAO = new HospitalDAO();
        this.userDAO = new UserDAO();
        this.notificationDAO = new NotificationDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.getRole().equalsIgnoreCase("hospital")) {
            request.setAttribute("error", "Unauthorized access. Role: " + user.getRole());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            if ("/dashboard".equals(action) || action == null) {
                handleDashboard(request, response, user);
            } else if ("/profile".equals(action)) {
                handleProfile(request, response, user);
            } else if ("/profile/edit".equals(action)) {
                handleProfileEdit(request, response, user);
            } else if ("/profile/update".equals(action)) {
                handleProfileUpdate(request, response, user);
            } else if ("/notifications".equals(action)) {
                handleNotifications(request, response, user);
            } else if ("/blood-request".equals(action)) {
                handleBloodRequestForm(request, response, user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading data: " + e.getMessage());
            request.getRequestDispatcher("/jsp/hospital/hospital_dashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.getRole().equalsIgnoreCase("hospital")) {
            request.setAttribute("error", "Unauthorized access. Role: " + user.getRole());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            if ("/profile/update".equals(action)) {
                handleProfileUpdate(request, response, user);
            } else if ("/notifications".equals(action)) {
                handleNotificationAction(request, response, user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/jsp/hospital/hospital_dashboard.jsp").forward(request, response);
        }
    }
    
    private void handleDashboard(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        BloodRequestDAO requestDAO = new BloodRequestDAO();
        HospitalDAO hospitalDAO = new HospitalDAO();
        
        // Get hospital information
        Hospital hospital = hospitalDAO.getHospitalByUserId(user.getId());
        
        // Get blood request statistics
        List<BloodRequest> allRequests = requestDAO.getBloodRequestsByHospitalId(user.getId());
        
        int pendingRequests = 0;
        int approvedRequests = 0;
        int completedRequests = 0;
        int totalBloodUnits = 0;
        
        for (BloodRequest bloodRequest : allRequests) {
            if ("PENDING".equals(bloodRequest.getStatus())) {
                pendingRequests++;
            } else if ("APPROVED".equals(bloodRequest.getStatus())) {
                approvedRequests++;
            } else if ("COMPLETED".equals(bloodRequest.getStatus())) {
                completedRequests++;
                totalBloodUnits += bloodRequest.getQuantity();
            }
        }
        
        // Get recent requests (last 5)
        List<BloodRequest> recentRequests = allRequests.stream()
                .limit(5)
                .toList();
        
        // Set attributes for JSP
        request.setAttribute("hospital", hospital);
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("approvedRequests", approvedRequests);
        request.setAttribute("completedRequests", completedRequests);
        request.setAttribute("totalBloodUnits", totalBloodUnits);
        request.setAttribute("recentRequests", recentRequests);
        
        request.getRequestDispatcher("/jsp/hospital/hospital_dashboard.jsp").forward(request, response);
    }
    
    private void handleProfile(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        HospitalDAO hospitalDAO = new HospitalDAO();
        Hospital hospital = hospitalDAO.getHospitalByUserId(user.getId());
        
        if (hospital == null) {
            request.setAttribute("error", "Hospital profile not found");
            request.getRequestDispatcher("/jsp/hospital/hospital_dashboard.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("hospital", hospital);
        request.getRequestDispatcher("/jsp/hospital/hospital_profile.jsp").forward(request, response);
    }
    
    private void handleProfileEdit(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        HospitalDAO hospitalDAO = new HospitalDAO();
        Hospital hospital = hospitalDAO.getHospitalByUserId(user.getId());
        
        if (hospital == null) {
            request.setAttribute("error", "Hospital profile not found");
            request.getRequestDispatcher("/jsp/hospital/hospital_dashboard.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("hospital", hospital);
        request.getRequestDispatcher("/jsp/hospital/hospital_profile_edit.jsp").forward(request, response);
    }
    
    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        HospitalDAO hospitalDAO = new HospitalDAO();
        Hospital hospital = hospitalDAO.getHospitalByUserId(user.getId());
        
        if (hospital == null) {
            request.setAttribute("error", "Hospital profile not found");
            request.getRequestDispatcher("/jsp/hospital/hospital_dashboard.jsp").forward(request, response);
            return;
        }
        
        try {
            // Get form parameters
            String hospitalName = request.getParameter("hospitalName");
            String hospitalType = request.getParameter("hospitalType");
            String licenseNumber = request.getParameter("licenseNumber");
            String registrationNumber = request.getParameter("registrationNumber");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String postalCode = request.getParameter("postalCode");
            String contactPerson = request.getParameter("contactPerson");
            String contactPhone = request.getParameter("contactPhone");
            String contactEmail = request.getParameter("contactEmail");
            
            // Validate input
            if (hospitalName == null || hospitalName.trim().isEmpty()) {
                throw new IllegalArgumentException("Hospital name is required");
            }
            if (hospitalType == null || hospitalType.trim().isEmpty()) {
                throw new IllegalArgumentException("Hospital type is required");
            }
            if (licenseNumber == null || licenseNumber.trim().isEmpty()) {
                throw new IllegalArgumentException("License number is required");
            }
            if (registrationNumber == null || registrationNumber.trim().isEmpty()) {
                throw new IllegalArgumentException("Registration number is required");
            }
            if (address == null || address.trim().isEmpty()) {
                throw new IllegalArgumentException("Address is required");
            }
            if (city == null || city.trim().isEmpty()) {
                throw new IllegalArgumentException("City is required");
            }
            if (state == null || state.trim().isEmpty()) {
                throw new IllegalArgumentException("State is required");
            }
            if (postalCode == null || postalCode.trim().isEmpty()) {
                throw new IllegalArgumentException("Postal code is required");
            }
            if (contactPerson == null || contactPerson.trim().isEmpty()) {
                throw new IllegalArgumentException("Contact person is required");
            }
            if (contactPhone == null || contactPhone.trim().isEmpty()) {
                throw new IllegalArgumentException("Contact phone is required");
            }
            if (contactEmail == null || contactEmail.trim().isEmpty()) {
                throw new IllegalArgumentException("Contact email is required");
            }
            
            // Validate email format
            if (!ValidationUtil.isValidEmail(contactEmail)) {
                throw new IllegalArgumentException("Invalid email format");
            }
            
            // Validate phone format
            if (!ValidationUtil.isValidPhone(contactPhone)) {
                throw new IllegalArgumentException("Invalid phone format");
            }
            
            // Update hospital information
            hospital.setHospitalName(hospitalName.trim());
            hospital.setHospitalType(hospitalType);
            hospital.setLicenseNumber(licenseNumber.trim());
            hospital.setRegistrationNumber(registrationNumber.trim());
            hospital.setAddress(address.trim());
            hospital.setCity(city.trim());
            hospital.setState(state.trim());
            hospital.setPostalCode(postalCode.trim());
            hospital.setContactPerson(contactPerson.trim());
            hospital.setContactPhone(contactPhone.trim());
            hospital.setContactEmail(contactEmail.trim());
            hospital.setUpdatedAt(new java.util.Date());
            
            // Update in database
            hospitalDAO.updateHospital(hospital);
            response.sendRedirect(request.getContextPath() + "/hospital/profile?success=Profile updated successfully");
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("hospital", hospital);
            request.getRequestDispatcher("/jsp/hospital/hospital_profile_edit.jsp").forward(request, response);
        }
    }
    
    private void handleNotifications(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        try {
            // Get all notifications for this hospital user
            List<Notification> notifications = notificationDAO.getNotificationsByUserId(user.getId());
            
            // Calculate statistics
            int totalNotifications = notifications.size();
            int unreadNotifications = (int) notifications.stream().filter(n -> !n.isRead()).count();
            int systemNotifications = (int) notifications.stream().filter(n -> "SYSTEM".equals(n.getType())).count();
            int alertNotifications = (int) notifications.stream().filter(n -> "ALERT".equals(n.getType())).count();
            
            // Set attributes for JSP
            request.setAttribute("notifications", notifications);
            request.setAttribute("totalNotifications", totalNotifications);
            request.setAttribute("unreadNotifications", unreadNotifications);
            request.setAttribute("systemNotifications", systemNotifications);
            request.setAttribute("alertNotifications", alertNotifications);
            
            // Forward to notifications JSP
            request.getRequestDispatcher("/jsp/hospital/hospital_notifications.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading notifications: " + e.getMessage());
            request.getRequestDispatcher("/jsp/hospital/hospital_notifications.jsp").forward(request, response);
        }
    }
    
    private void handleNotificationAction(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        String action = request.getParameter("action");
        
        try {
            if ("markRead".equals(action)) {
                int notificationId = Integer.parseInt(request.getParameter("id"));
                notificationDAO.markAsRead(notificationId);
                response.sendRedirect(request.getContextPath() + "/hospital/notifications?success=Notification marked as read");
            } else if ("delete".equals(action)) {
                int notificationId = Integer.parseInt(request.getParameter("id"));
                notificationDAO.deleteNotification(notificationId);
                response.sendRedirect(request.getContextPath() + "/hospital/notifications?success=Notification deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/hospital/notifications?error=Invalid action");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/hospital/notifications?error=Invalid notification ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/hospital/notifications?error=Error processing notification: " + e.getMessage());
        }
    }
    
    private void handleBloodRequestForm(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        // Simply forward to the blood request form JSP
        request.getRequestDispatcher("/jsp/hospital/hospital_blood_request.jsp").forward(request, response);
    }
}