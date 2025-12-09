package com.blooddonation.servlet;

import com.blooddonation.dao.*;
import com.blooddonation.model.*;
import com.blooddonation.service.NotificationService;
import com.blooddonation.util.DatabaseUtil;
import com.blooddonation.observer.*;

import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class MedicalStaffServlet extends HttpServlet {
    private BloodReportDAO bloodReportDAO;
    private DonorDAO donorDAO;
    private UserDAO userDAO;
    private NotificationService notificationService;

    public MedicalStaffServlet() {
        this.bloodReportDAO = new BloodReportDAO();
        this.donorDAO = new DonorDAO();
        this.userDAO = new UserDAO();
        this.notificationService = new NotificationService();
        
        // Initialize Observer pattern - register observers
        EventNotificationManager eventManager = EventNotificationManager.getInstance();
        eventManager.addObserver(new EmailNotificationObserver());
        eventManager.addObserver(new LoggingObserver());
        eventManager.addObserver(new AlertObserver());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"MEDICAL_STAFF".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/dashboard";
        }

        try {
            switch (pathInfo) {
                case "/dashboard":
                    handleDashboard(request, response, user);
                    break;
                case "/blood-reports":
                    handleBloodReports(request, response, user);
                    break;
                case "/donors":
                    handleDonors(request, response, user);
                    break;
                case "/blood-stock":
                    handleBloodStock(request, response, user);
                    break;
                case "/approve-report":
                    handleApproveReport(request, response, user);
                    break;
                case "/reject-report":
                    handleRejectReport(request, response, user);
                    break;
                case "/update-report":
                    handleUpdateReport(request, response, user);
                    break;
                case "/add-blood-stock":
                    handleAddBloodStock(request, response, user);
                    break;
                case "/delete-blood-stock":
                    handleDeleteBloodStock(request, response, user);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/jsp/medical/medical_dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        // Get statistics for medical staff dashboard
        List<BloodReport> pendingReports = bloodReportDAO.getBloodReportsByStatus("PENDING");
        List<BloodReport> approvedReports = bloodReportDAO.getBloodReportsByStatus("APPROVED");
        List<BloodReport> rejectedReports = bloodReportDAO.getBloodReportsByStatus("REJECTED");
        List<Donor> allDonors = donorDAO.getAllDonors();
        
        // Get recent blood reports
        List<BloodReport> recentReports = new ArrayList<>();
        for (BloodReport report : bloodReportDAO.getAllBloodReports()) {
            if (recentReports.size() < 10) {
                recentReports.add(report);
            }
        }

        request.setAttribute("pendingReports", pendingReports);
        request.setAttribute("approvedReports", approvedReports);
        request.setAttribute("rejectedReports", rejectedReports);
        request.setAttribute("allDonors", allDonors);
        request.setAttribute("recentReports", recentReports);
        
        request.getRequestDispatcher("/jsp/medical/medical_dashboard.jsp").forward(request, response);
    }

    private void handleBloodReports(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        List<BloodReport> allReports = bloodReportDAO.getAllBloodReports();
        List<Donor> allDonors = donorDAO.getAllDonors();
        
        request.setAttribute("bloodReports", allReports);
        request.setAttribute("donors", allDonors);
        
        request.getRequestDispatcher("/jsp/medical/medical_blood_report.jsp").forward(request, response);
    }


    private void handleDonors(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        List<Donor> allDonors = donorDAO.getAllDonors();
        List<User> donorUsers = userDAO.getAllDonors();
        
        request.setAttribute("donors", allDonors);
        request.setAttribute("donorUsers", donorUsers);
        
        request.getRequestDispatcher("/jsp/medical/medical_donor_details.jsp").forward(request, response);
    }


    private void handleApproveReport(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        int reportId = Integer.parseInt(request.getParameter("report_id"));
        
        BloodReport report = bloodReportDAO.getBloodReportById(reportId);
        if (report != null) {
            report.setStatus("APPROVED");
            report.setTestedBy(user.getId());
            report.setTestedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            
            bloodReportDAO.updateBloodReport(report);
            
            // Get donor information to create blood stock entry
            Donor donor = donorDAO.getDonorById(report.getDonorId());
            if (donor != null) {
                // Create blood stock entry for approved blood
                try {
                    com.blooddonation.model.BloodStock stock = new com.blooddonation.model.BloodStock();
                    stock.setBloodGroup(donor.getBloodGroup());
                    stock.setQuantity(1); // Standard: 1 unit per donation
                    
                    // Set collection date (use appointment date or current date)
                    java.util.Date collectionDate = new java.util.Date();
                    if (report.getAppointmentId() != null && report.getAppointmentId() > 0) {
                        // Try to get appointment date, fallback to current date
                        // For now, use current date - you can enhance this later
                    }
                    stock.setCollectionDate(collectionDate);
                    
                    // Set expiry date (42 days from collection)
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    cal.setTime(collectionDate);
                    cal.add(java.util.Calendar.DAY_OF_MONTH, 42);
                    stock.setExpiryDate(cal.getTime());
                    
                    stock.setDonorId(donor.getId());
                    stock.setStatus("AVAILABLE"); // Blood is available for use
                    
                    // Set volume (standard blood donation volume)
                    Integer donationVolume = report.getDonationVolume();
                    stock.setVolume(donationVolume != null && donationVolume > 0 ? donationVolume.doubleValue() : 450.0);
                    
                    // Add to blood stock
                    com.blooddonation.dao.BloodStockDAO stockDAO = new com.blooddonation.dao.BloodStockDAO();
                    stockDAO.addBloodStock(stock);
                    
                    // Update donor's last donation date and total donations
                    donor.setLastDonationDate(new java.sql.Date(collectionDate.getTime()));
                    donor.setTotalDonations(donor.getTotalDonations() + 1);
                    
                    // Calculate next eligible date (56 days for whole blood donation)
                    cal.setTime(collectionDate);
                    cal.add(java.util.Calendar.DAY_OF_MONTH, 56);
                    donor.setNextEligibleDate(new java.sql.Date(cal.getTimeInMillis()));
                    
                    donorDAO.updateDonor(donor);
                    
                } catch (Exception e) {
                    e.printStackTrace();
                    // Log error but don't fail the approval process
                    System.err.println("Error adding blood to stock: " + e.getMessage());
                }
                
                // Send notification to donor (existing method)
                notificationService.sendNotification(
                    donor.getUserId(),
                    "Your blood test results have been approved and your donation has been added to our blood bank inventory. Thank you for your contribution!",
                    "SYSTEM"
                );
                
                // NEW: Use Observer pattern to notify all observers
                EventNotificationManager eventManager = EventNotificationManager.getInstance();
                Map<String, Object> eventData = new HashMap<>();
                eventData.put("donorId", donor.getId());
                eventData.put("userId", user.getId());
                eventData.put("reportId", reportId);
                eventData.put("bloodGroup", donor.getBloodGroup());
                eventData.put("entityId", reportId);
                
                eventManager.notifyObservers(SystemEvent.BLOOD_REPORT_APPROVED, eventData);
            }
            
            response.sendRedirect(request.getContextPath() + "/medical/blood-reports?success=Report approved successfully and blood added to stock");
        } else {
            response.sendRedirect(request.getContextPath() + "/medical/blood-reports?error=Report not found");
        }
    }

    private void handleRejectReport(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        int reportId = Integer.parseInt(request.getParameter("report_id"));
        String reason = request.getParameter("reason");
        
        BloodReport report = bloodReportDAO.getBloodReportById(reportId);
        if (report != null) {
            report.setStatus("REJECTED");
            report.setTestedBy(user.getId());
            report.setTestedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            
            if (reason != null && !reason.trim().isEmpty()) {
                report.setMedicalStaffNotes(reason);
            }
            
            bloodReportDAO.updateBloodReport(report);
            
            // Send notification to donor
            Donor donor = donorDAO.getDonorById(report.getDonorId());
            if (donor != null) {
                notificationService.sendNotification(
                    donor.getUserId(),
                    "Your blood test results have been rejected. Reason: " + (reason != null ? reason : "Please contact medical staff for details."),
                    "SYSTEM"
                );
            }
            
            response.sendRedirect(request.getContextPath() + "/medical/blood-reports?success=Report rejected successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/medical/blood-reports?error=Report not found");
        }
    }

    private void handleUpdateReport(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        try {
            int reportId = Integer.parseInt(request.getParameter("report_id"));
            String status = request.getParameter("status");
            String notes = request.getParameter("notes");
            
            BloodReport report = bloodReportDAO.getBloodReportById(reportId);
            if (report != null) {
                if (status != null && !status.trim().isEmpty()) {
                    report.setStatus(status);
                }
                
                if (notes != null && !notes.trim().isEmpty()) {
                    report.setMedicalStaffNotes(notes);
                }
                
                report.setTestedBy(user.getId());
                report.setTestedAt(new java.sql.Timestamp(System.currentTimeMillis()));
                
                bloodReportDAO.updateBloodReport(report);
                
                // Send notification to donor
                Donor donor = donorDAO.getDonorById(report.getDonorId());
                if (donor != null) {
                    String message = "Your blood report has been updated. Status: " + status;
                    if (notes != null && !notes.trim().isEmpty()) {
                        message += " Notes: " + notes;
                    }
                    notificationService.sendNotification(
                        donor.getUserId(),
                        message,
                        "SYSTEM"
                    );
                }
                
                response.sendRedirect(request.getContextPath() + "/medical/blood-reports?success=Report updated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/medical/blood-reports?error=Report not found");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/medical/blood-reports?error=Invalid report ID");
        }
    }

    private void handleBloodStock(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        com.blooddonation.dao.BloodStockDAO stockDAO = new com.blooddonation.dao.BloodStockDAO();
        List<com.blooddonation.model.BloodStock> allStock = stockDAO.getAllBloodStock();
        
        // NEW: Check for expired and expiring blood stock (only trigger alerts for newly detected issues)
        java.util.Date now = new java.util.Date(); // Move this outside the if block
        
        // Only check expiry alerts if this is the first visit or if requested via parameter
        String checkAlerts = request.getParameter("check_alerts");
        if ("true".equals(checkAlerts)) {
            com.blooddonation.observer.EventNotificationManager eventManager = 
                com.blooddonation.observer.EventNotificationManager.getInstance();
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(now);
            cal.add(java.util.Calendar.DAY_OF_MONTH, 7); // 7 days from now
            java.util.Date weekFromNow = cal.getTime();
            
            int expiredCount = 0;
            int expiringCount = 0;
            
            for (com.blooddonation.model.BloodStock stock : allStock) {
                if (stock.getExpiryDate() != null && !"EXPIRED".equals(stock.getStatus()) && !"DISPOSED".equals(stock.getStatus())) {
                    
                    // Check if already expired
                    if (stock.getExpiryDate().before(now)) {
                        expiredCount++;
                        // Mark as expired in database (but don't spam alerts)
                        stockDAO.markAsExpired(stock.getId());
                    }
                    // Check if expiring within 7 days
                    else if (stock.getExpiryDate().before(weekFromNow)) {
                        expiringCount++;
                    }
                }
            }
            
            // Only trigger summary alerts if there are issues
            if (expiredCount > 0) {
                java.util.Map<String, Object> expiredSummary = new java.util.HashMap<>();
                expiredSummary.put("expiredCount", expiredCount);
                expiredSummary.put("userId", user.getId());
                expiredSummary.put("message", expiredCount + " blood stock items have expired and need disposal");
                
                eventManager.notifyObservers(com.blooddonation.observer.SystemEvent.SYSTEM_ALERT, expiredSummary);
            }
            
            if (expiringCount > 0) {
                java.util.Map<String, Object> expiringSummary = new java.util.HashMap<>();
                expiringSummary.put("expiringCount", expiringCount);
                expiringSummary.put("userId", user.getId());
                expiringSummary.put("message", expiringCount + " blood stock items are expiring within 7 days");
                
                eventManager.notifyObservers(com.blooddonation.observer.SystemEvent.SYSTEM_ALERT, expiringSummary);
            }
        }
        
        request.setAttribute("bloodStock", allStock);
        request.setAttribute("now", now);
        
        request.getRequestDispatcher("/jsp/medical/medical_blood_stock.jsp").forward(request, response);
    }
    
    /**
     * Helper method to calculate days until expiry
     */
    private int getDaysUntilExpiry(java.util.Date expiryDate, java.util.Date currentDate) {
        long diffInMillies = expiryDate.getTime() - currentDate.getTime();
        return (int) (diffInMillies / (1000 * 60 * 60 * 24));
    }

    private void handleAddBloodStock(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        try {
            String bloodGroup = request.getParameter("blood_group");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String expiryDateStr = request.getParameter("expiry_date");
            String collectionDateStr = request.getParameter("collection_date");
            String screeningResult = request.getParameter("screening_result");
            int donorId = Integer.parseInt(request.getParameter("donor_id"));
            String volumeStr = request.getParameter("volume");
            
            // Parse dates
            java.util.Date expiryDate = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(expiryDateStr);
            java.util.Date collectionDate = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(collectionDateStr);
            
            // Create blood stock entry
            com.blooddonation.model.BloodStock stock = new com.blooddonation.model.BloodStock();
            stock.setBloodGroup(bloodGroup);
            stock.setQuantity(quantity);
            stock.setExpiryDate(expiryDate);
            stock.setCollectionDate(collectionDate);
            stock.setDonorId(donorId);
            
            // Set status based on screening result
            // Since screening_result is not in DB, we'll use status field to indicate usability
            if ("NEGATIVE".equals(screeningResult)) {
                stock.setStatus("AVAILABLE");
            } else if ("POSITIVE".equals(screeningResult)) {
                stock.setStatus("RESERVED"); // Using RESERVED to indicate quarantined
            } else if ("PENDING".equals(screeningResult)) {
                stock.setStatus("DISCARDED"); // Using DISCARDED to indicate pending screening
            } else {
                stock.setStatus("AVAILABLE"); // Default fallback
            }
            
            // Set screening result and volume in model (even though they won't be saved to DB)
            stock.setScreeningResult(screeningResult);
            if (volumeStr != null && !volumeStr.trim().isEmpty()) {
                stock.setVolume(Double.parseDouble(volumeStr));
            } else {
                stock.setVolume(450.0); // Default volume
            }
            
            // Add to stock
            com.blooddonation.dao.BloodStockDAO stockDAO = new com.blooddonation.dao.BloodStockDAO();
            stockDAO.addBloodStock(stock);
            
            // NEW: Use Observer pattern to notify about new blood stock
            com.blooddonation.observer.EventNotificationManager eventManager = 
                com.blooddonation.observer.EventNotificationManager.getInstance();
            java.util.Map<String, Object> eventData = new java.util.HashMap<>();
            eventData.put("bloodGroup", bloodGroup);
            eventData.put("quantity", quantity);
            eventData.put("userId", user.getId());
            eventData.put("donorId", donorId);
            eventData.put("screeningResult", screeningResult);
            
            eventManager.notifyObservers(com.blooddonation.observer.SystemEvent.BLOOD_STOCK_ADDED, eventData);
            
            // Check if the newly added stock is expiring soon or already expired
            java.util.Date now = new java.util.Date();
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(now);
            cal.add(java.util.Calendar.DAY_OF_MONTH, 7); // 7 days from now
            java.util.Date weekFromNow = cal.getTime();
            
            if (expiryDate.before(now)) {
                // Already expired
                java.util.Map<String, Object> expiredData = new java.util.HashMap<>();
                expiredData.put("bloodGroup", bloodGroup);
                expiredData.put("expiredUnits", quantity);
                expiredData.put("expiryDate", expiryDate);
                expiredData.put("userId", user.getId());
                
                eventManager.notifyObservers(com.blooddonation.observer.SystemEvent.BLOOD_STOCK_EXPIRED, expiredData);
            } else if (expiryDate.before(weekFromNow)) {
                // Expiring within 7 days
                java.util.Map<String, Object> expiringData = new java.util.HashMap<>();
                expiringData.put("bloodGroup", bloodGroup);
                expiringData.put("quantity", quantity);
                expiringData.put("expiryDate", expiryDate);
                expiringData.put("daysUntilExpiry", getDaysUntilExpiry(expiryDate, now));
                expiringData.put("userId", user.getId());
                
                eventManager.notifyObservers(com.blooddonation.observer.SystemEvent.SYSTEM_ALERT, expiringData);
            }
            
            // Check if stock is still low after adding
            int totalStock = stockDAO.getTotalUnitsByBloodGroup(bloodGroup);
            if (totalStock < 10) { // Low stock threshold
                java.util.Map<String, Object> lowStockData = new java.util.HashMap<>();
                lowStockData.put("bloodGroup", bloodGroup);
                lowStockData.put("currentStock", totalStock);
                lowStockData.put("threshold", 10);
                
                eventManager.notifyObservers(com.blooddonation.observer.SystemEvent.BLOOD_STOCK_LOW, lowStockData);
            }
            
            response.sendRedirect(request.getContextPath() + "/medical/blood-stock?success=Blood stock added successfully");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/medical/blood-stock?error=Error adding blood stock: " + e.getMessage());
        }
    }
    
    private void handleDeleteBloodStock(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException, SQLException {
        try {
            int stockId = Integer.parseInt(request.getParameter("stock_id"));
            
            com.blooddonation.dao.BloodStockDAO stockDAO = new com.blooddonation.dao.BloodStockDAO();
            
            // Get stock details before deletion for confirmation
            com.blooddonation.model.BloodStock stock = stockDAO.getBloodStockById(stockId);
            if (stock == null) {
                response.sendRedirect(request.getContextPath() + "/medical/blood-stock?error=Blood stock not found");
                return;
            }
            
            // Delete the blood stock
            stockDAO.deleteBloodStock(stockId);
            response.sendRedirect(request.getContextPath() + "/medical/blood-stock?success=Blood stock deleted successfully");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/medical/blood-stock?error=Invalid stock ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/medical/blood-stock?error=Error deleting blood stock: " + e.getMessage());
        }
    }
}
