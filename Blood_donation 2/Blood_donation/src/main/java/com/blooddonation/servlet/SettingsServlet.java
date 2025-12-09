package com.blooddonation.servlet;

import com.blooddonation.model.User;
import com.blooddonation.service.SystemSettingsService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

public class SettingsServlet extends HttpServlet {
    private final SystemSettingsService settingsService = new SystemSettingsService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"MANAGER".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            // Get all system settings
            Map<String, String> settings = settingsService.getAllSettings();
            request.setAttribute("settings", settings);
            request.getRequestDispatcher("/jsp/manager/manager_settings.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving settings: " + e.getMessage());
            request.getRequestDispatcher("/jsp/manager/manager_settings.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"MANAGER".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String action = request.getPathInfo();
        
        try {
            if (action == null || action.equals("/")) {
                // Update settings
                String systemName = request.getParameter("system_name");
                String systemEmail = request.getParameter("system_email");
                String systemPhone = request.getParameter("system_phone");
                String minDonationAge = request.getParameter("min_donation_age");
                String maxDonationAge = request.getParameter("max_donation_age");
                String minDonationWeight = request.getParameter("min_donation_weight");
                String donationInterval = request.getParameter("donation_interval");
                String bloodExpiryDays = request.getParameter("blood_expiry_days");
                String lowStockThreshold = request.getParameter("low_stock_threshold");
                String emailNotifications = request.getParameter("email_notifications");
                String smsNotifications = request.getParameter("sms_notifications");
                
                // Update each setting
                if (systemName != null) settingsService.updateSetting("system_name", systemName);
                if (systemEmail != null) settingsService.updateSetting("system_email", systemEmail);
                if (systemPhone != null) settingsService.updateSetting("system_phone", systemPhone);
                if (minDonationAge != null) settingsService.updateSetting("min_donation_age", minDonationAge);
                if (maxDonationAge != null) settingsService.updateSetting("max_donation_age", maxDonationAge);
                if (minDonationWeight != null) settingsService.updateSetting("min_donation_weight", minDonationWeight);
                if (donationInterval != null) settingsService.updateSetting("donation_interval", donationInterval);
                if (bloodExpiryDays != null) settingsService.updateSetting("blood_expiry_days", bloodExpiryDays);
                if (lowStockThreshold != null) settingsService.updateSetting("low_stock_threshold", lowStockThreshold);
                if (emailNotifications != null) settingsService.updateSetting("email_notifications", emailNotifications);
                if (smsNotifications != null) settingsService.updateSetting("sms_notifications", smsNotifications);
                
                response.sendRedirect(request.getContextPath() + "/settings?success=updated");
                
            } else if (action.equals("/reset")) {
                // Reset to default settings
                settingsService.resetToDefaults();
                response.sendRedirect(request.getContextPath() + "/settings?success=reset");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating settings: " + e.getMessage());
            request.getRequestDispatcher("/jsp/manager/manager_settings.jsp").forward(request, response);
        }
    }
}

