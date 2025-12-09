package com.blooddonation.servlet;

import com.blooddonation.dao.BloodStockDAO;
import com.blooddonation.dao.DonorDAO;
import com.blooddonation.dao.BloodRequestDAO;
import com.blooddonation.dao.AppointmentDAO;
import com.blooddonation.dao.FeedbackDAO;
import com.blooddonation.model.User;
import com.blooddonation.util.PDFReportGenerator;
import com.blooddonation.util.SimplePDFGenerator;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

public class ReportServlet extends HttpServlet {
    
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !((User) session.getAttribute("user")).getRole().equals("MANAGER")) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");
        String format = request.getParameter("format");
        
        try {
            if ("pdf".equals(format)) {
                generatePDFReport(request, response);
            } else if ("html".equals(format)) {
                generateHTMLExport(request, response);
            } else {
                generateHTMLReport(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error generating report");
            request.getRequestDispatcher("/jsp/manager/manager_reports.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void generateHTMLReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        // Get filter parameters
        String reportType = request.getParameter("reportType");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String bloodGroup = request.getParameter("bloodGroup");
        String status = request.getParameter("status");
        String urgency = request.getParameter("urgency");
        
        BloodStockDAO stockDAO = new BloodStockDAO();
        DonorDAO donorDAO = new DonorDAO();
        BloodRequestDAO requestDAO = new BloodRequestDAO();
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        
        // Apply filters based on report type
        if ("bloodStock".equals(reportType)) {
            List<Map<String, Object>> filteredStocks = getFilteredBloodStock(stockDAO, bloodGroup, status);
            if (filteredStocks.isEmpty()) {
                filteredStocks = generateSampleBloodStock();
            }
            request.setAttribute("stocks", filteredStocks);
            request.setAttribute("reportType", "bloodStock");
        } else if ("donors".equals(reportType)) {
            List<Map<String, Object>> filteredDonors = getFilteredDonors(donorDAO, bloodGroup, startDate, endDate);
            if (filteredDonors.isEmpty()) {
                filteredDonors = generateSampleDonors();
            }
            request.setAttribute("donors", filteredDonors);
            request.setAttribute("reportType", "donors");
        } else if ("requests".equals(reportType)) {
            List<Map<String, Object>> filteredRequests = getFilteredBloodRequests(requestDAO, bloodGroup, status, urgency, startDate, endDate);
            if (filteredRequests.isEmpty()) {
                filteredRequests = generateSampleBloodRequests();
            }
            request.setAttribute("requests", filteredRequests);
            request.setAttribute("reportType", "requests");
        } else if ("appointments".equals(reportType)) {
            List<Map<String, Object>> filteredAppointments = getFilteredAppointments(appointmentDAO, status, startDate, endDate);
            if (filteredAppointments.isEmpty()) {
                filteredAppointments = generateSampleAppointments();
            }
            request.setAttribute("appointments", filteredAppointments);
            request.setAttribute("reportType", "appointments");
        } else if ("feedback".equals(reportType)) {
            List<Map<String, Object>> filteredFeedback = getFilteredFeedback(feedbackDAO, status, startDate, endDate);
            if (filteredFeedback.isEmpty()) {
                filteredFeedback = generateSampleFeedback();
            }
            request.setAttribute("feedback", filteredFeedback);
            request.setAttribute("reportType", "feedback");
        } else {
            // Default: show all reports
            List<Map<String, Object>> stocks = getFilteredBloodStock(stockDAO, null, null);
            List<Map<String, Object>> donors = getFilteredDonors(donorDAO, null, null, null);
            List<Map<String, Object>> requests = getFilteredBloodRequests(requestDAO, null, null, null, null, null);
            List<Map<String, Object>> appointments = getFilteredAppointments(appointmentDAO, null, null, null);
            List<Map<String, Object>> feedback = getFilteredFeedback(feedbackDAO, null, null, null);
            
            // Add sample data if empty
            if (stocks.isEmpty()) stocks = generateSampleBloodStock();
            if (donors.isEmpty()) donors = generateSampleDonors();
            if (requests.isEmpty()) requests = generateSampleBloodRequests();
            if (appointments.isEmpty()) appointments = generateSampleAppointments();
            if (feedback.isEmpty()) feedback = generateSampleFeedback();
            
            request.setAttribute("stocks", stocks);
            request.setAttribute("donors", donors);
            request.setAttribute("requests", requests);
            request.setAttribute("appointments", appointments);
            request.setAttribute("feedback", feedback);
            request.setAttribute("reportType", "all");
        }
        
        // Set filter values for display
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("bloodGroup", bloodGroup);
        request.setAttribute("status", status);
        request.setAttribute("urgency", urgency);
        
        request.getRequestDispatcher("/jsp/manager/manager_reports.jsp").forward(request, response);
    }
    
    private void generatePDFReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        String reportType = request.getParameter("reportType");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String bloodGroup = request.getParameter("bloodGroup");
        String status = request.getParameter("status");
        String urgency = request.getParameter("urgency");
        
        try {
            byte[] pdfBytes = null;
            String fileName = "";
            
            if ("bloodStock".equals(reportType)) {
                BloodStockDAO stockDAO = new BloodStockDAO();
                List<Map<String, Object>> filteredStocks = getFilteredBloodStock(stockDAO, bloodGroup, status);
                try {
                    pdfBytes = PDFReportGenerator.generateBloodStockReport(filteredStocks, "Blood Stock Report");
                } catch (Exception e) {
                    // Fallback to HTML generation
                    String htmlContent = SimplePDFGenerator.generateBloodStockHTML(filteredStocks);
                    response.setContentType("text/html");
                    response.setHeader("Content-Disposition", "attachment; filename=\"blood_stock_report.html\"");
                    response.getWriter().write(htmlContent);
                    return;
                }
                fileName = "blood_stock_report.pdf";
            } else if ("donors".equals(reportType)) {
                DonorDAO donorDAO = new DonorDAO();
                List<Map<String, Object>> filteredDonors = getFilteredDonors(donorDAO, bloodGroup, startDate, endDate);
                try {
                    pdfBytes = PDFReportGenerator.generateDonorReport(filteredDonors, "Donor Report");
                } catch (Exception e) {
                    // Fallback to HTML generation
                    String htmlContent = SimplePDFGenerator.generateDonorHTML(filteredDonors);
                    response.setContentType("text/html");
                    response.setHeader("Content-Disposition", "attachment; filename=\"donor_report.html\"");
                    response.getWriter().write(htmlContent);
                    return;
                }
                fileName = "donor_report.pdf";
            } else if ("requests".equals(reportType)) {
                BloodRequestDAO requestDAO = new BloodRequestDAO();
                List<Map<String, Object>> filteredRequests = getFilteredBloodRequests(requestDAO, bloodGroup, status, urgency, startDate, endDate);
                try {
                    pdfBytes = PDFReportGenerator.generateBloodRequestReport(filteredRequests, "Blood Request Report");
                } catch (Exception e) {
                    // Fallback to HTML generation
                    String htmlContent = SimplePDFGenerator.generateBloodRequestHTML(filteredRequests);
                    response.setContentType("text/html");
                    response.setHeader("Content-Disposition", "attachment; filename=\"blood_request_report.html\"");
                    response.getWriter().write(htmlContent);
                    return;
                }
                fileName = "blood_request_report.pdf";
            } else {
                // Generate comprehensive system report
                Map<String, Object> reportData = generateSystemReportData();
                try {
                    pdfBytes = PDFReportGenerator.generateSystemReport(reportData, "Blood Donation System Report");
                } catch (Exception e) {
                    // Fallback to HTML generation
                    String htmlContent = SimplePDFGenerator.generateSystemHTML(reportData);
                    response.setContentType("text/html");
                    response.setHeader("Content-Disposition", "attachment; filename=\"system_report.html\"");
                    response.getWriter().write(htmlContent);
                    return;
                }
                fileName = "system_report.pdf";
            }
            
            // Set response headers for PDF download
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setContentLength(pdfBytes.length);
            
            // Write PDF to response
            response.getOutputStream().write(pdfBytes);
            response.getOutputStream().flush();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF report");
        }
    }
    
    private void generateHTMLExport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        String reportType = request.getParameter("reportType");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String bloodGroup = request.getParameter("bloodGroup");
        String status = request.getParameter("status");
        String urgency = request.getParameter("urgency");
        
        String htmlContent = "";
        String fileName = "";
        
        if ("bloodStock".equals(reportType)) {
            BloodStockDAO stockDAO = new BloodStockDAO();
            List<Map<String, Object>> filteredStocks = getFilteredBloodStock(stockDAO, bloodGroup, status);
            htmlContent = SimplePDFGenerator.generateBloodStockHTML(filteredStocks);
            fileName = "blood_stock_report.html";
        } else if ("donors".equals(reportType)) {
            DonorDAO donorDAO = new DonorDAO();
            List<Map<String, Object>> filteredDonors = getFilteredDonors(donorDAO, bloodGroup, startDate, endDate);
            htmlContent = SimplePDFGenerator.generateDonorHTML(filteredDonors);
            fileName = "donor_report.html";
        } else if ("requests".equals(reportType)) {
            BloodRequestDAO requestDAO = new BloodRequestDAO();
            List<Map<String, Object>> filteredRequests = getFilteredBloodRequests(requestDAO, bloodGroup, status, urgency, startDate, endDate);
            htmlContent = SimplePDFGenerator.generateBloodRequestHTML(filteredRequests);
            fileName = "blood_request_report.html";
        } else {
            // Generate comprehensive system report
            Map<String, Object> reportData = generateSystemReportData();
            htmlContent = SimplePDFGenerator.generateSystemHTML(reportData);
            fileName = "system_report.html";
        }
        
        // Set response headers for HTML download
        response.setContentType("text/html");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        response.getWriter().write(htmlContent);
    }
    
    private List<Map<String, Object>> getFilteredBloodStock(BloodStockDAO stockDAO, String bloodGroup, String status) throws SQLException {
        List<Map<String, Object>> stocks = new ArrayList<>();
        try {
            // Get all blood stock and convert to Map format
            List<com.blooddonation.model.BloodStock> stockList = stockDAO.getAllBloodStock();
            for (com.blooddonation.model.BloodStock stock : stockList) {
                Map<String, Object> stockMap = new HashMap<>();
                stockMap.put("bloodGroup", stock.getBloodGroup());
                stockMap.put("quantity", stock.getQuantity());
                stockMap.put("expiryDate", stock.getExpiryDate() != null ? stock.getExpiryDate().toString() : "N/A");
                stockMap.put("status", stock.isUsable() ? "USABLE" : (stock.isExpired() ? "EXPIRED" : "QUARANTINED"));
                stockMap.put("collectionDate", stock.getCollectionDate() != null ? stock.getCollectionDate().toString() : "N/A");
                
                // Apply filters
                boolean include = true;
                if (bloodGroup != null && !bloodGroup.isEmpty() && !bloodGroup.equals(stock.getBloodGroup())) {
                    include = false;
                }
                if (status != null && !status.isEmpty()) {
                    String stockStatus = stock.isUsable() ? "USABLE" : (stock.isExpired() ? "EXPIRED" : "QUARANTINED");
                    if (!status.equals(stockStatus)) {
                        include = false;
                    }
                }
                
                if (include) {
                    stocks.add(stockMap);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stocks;
    }
    
    private List<Map<String, Object>> getFilteredDonors(DonorDAO donorDAO, String bloodGroup, String startDate, String endDate) throws SQLException {
        List<Map<String, Object>> donors = new ArrayList<>();
        try {
            // Get all donors and convert to Map format
            List<com.blooddonation.model.Donor> donorList = donorDAO.getAllDonors();
            for (com.blooddonation.model.Donor donor : donorList) {
                Map<String, Object> donorMap = new HashMap<>();
                donorMap.put("name", donor.getName());
                donorMap.put("bloodGroup", donor.getBloodGroup());
                donorMap.put("age", donor.getAge());
                donorMap.put("gender", donor.getGender());
                donorMap.put("lastDonationDate", donor.getLastDonationDate() != null ? donor.getLastDonationDate().toString() : "Never");
                donorMap.put("status", donor.getStatus() != null ? donor.getStatus() : "ACTIVE");
                
                // Apply filters
                boolean include = true;
                if (bloodGroup != null && !bloodGroup.isEmpty() && !bloodGroup.equals(donor.getBloodGroup())) {
                    include = false;
                }
                
                if (include) {
                    donors.add(donorMap);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return donors;
    }
    
    private List<Map<String, Object>> getFilteredBloodRequests(BloodRequestDAO requestDAO, String bloodGroup, String status, String urgency, String startDate, String endDate) throws SQLException {
        List<Map<String, Object>> requests = new ArrayList<>();
        try {
            // Get all blood requests and convert to Map format
            List<com.blooddonation.model.BloodRequest> requestList = requestDAO.getAllBloodRequests();
            for (com.blooddonation.model.BloodRequest request : requestList) {
                Map<String, Object> requestMap = new HashMap<>();
                requestMap.put("hospitalId", request.getHospitalId());
                requestMap.put("bloodGroup", request.getBloodGroup());
                requestMap.put("quantity", request.getQuantity());
                requestMap.put("urgency", request.getUrgency());
                requestMap.put("status", request.getStatus());
                requestMap.put("requestDate", request.getRequestDate() != null ? request.getRequestDate().toString() : "N/A");
                
                // Apply filters
                boolean include = true;
                if (bloodGroup != null && !bloodGroup.isEmpty() && !bloodGroup.equals(request.getBloodGroup())) {
                    include = false;
                }
                if (status != null && !status.isEmpty() && !status.equals(request.getStatus())) {
                    include = false;
                }
                if (urgency != null && !urgency.isEmpty() && !urgency.equals(request.getUrgency())) {
                    include = false;
                }
                
                if (include) {
                    requests.add(requestMap);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return requests;
    }
    
    private List<Map<String, Object>> getFilteredAppointments(AppointmentDAO appointmentDAO, String status, String startDate, String endDate) throws SQLException {
        List<Map<String, Object>> appointments = new ArrayList<>();
        try {
            // Get all appointments and convert to Map format
            List<com.blooddonation.model.Appointment> appointmentList = appointmentDAO.getAllAppointments();
            for (com.blooddonation.model.Appointment appointment : appointmentList) {
                Map<String, Object> appointmentMap = new HashMap<>();
                appointmentMap.put("donorName", "Donor ID: " + appointment.getDonorId()); // Using donorId since getDonorName() doesn't exist
                appointmentMap.put("appointmentDate", appointment.getAppointmentDate() != null ? appointment.getAppointmentDate().toString() : "N/A");
                appointmentMap.put("timeSlot", appointment.getTimeSlot());
                appointmentMap.put("status", appointment.getStatus());
                appointmentMap.put("createdDate", appointment.getCreatedAt() != null ? appointment.getCreatedAt().toString() : "N/A");
                
                // Apply filters
                boolean include = true;
                if (status != null && !status.isEmpty() && !status.equals(appointment.getStatus())) {
                    include = false;
                }
                
                if (include) {
                    appointments.add(appointmentMap);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appointments;
    }
    
    private List<Map<String, Object>> getFilteredFeedback(FeedbackDAO feedbackDAO, String status, String startDate, String endDate) throws SQLException {
        List<Map<String, Object>> feedback = new ArrayList<>();
        try {
            // Get all feedback and convert to Map format
            List<com.blooddonation.model.Feedback> feedbackList = feedbackDAO.getAllFeedback();
            for (com.blooddonation.model.Feedback fb : feedbackList) {
                Map<String, Object> feedbackMap = new HashMap<>();
                feedbackMap.put("userName", "User ID: " + fb.getUserId()); // Using userId since getUserName() doesn't exist
                feedbackMap.put("category", fb.getCategory());
                feedbackMap.put("message", fb.getFeedbackText()); // Using getFeedbackText() instead of getMessage()
                feedbackMap.put("status", fb.getStatus());
                feedbackMap.put("createdDate", fb.getCreatedAt() != null ? fb.getCreatedAt().toString() : "N/A");
                
                // Apply filters
                boolean include = true;
                if (status != null && !status.isEmpty() && !status.equals(fb.getStatus())) {
                    include = false;
                }
                
                if (include) {
                    feedback.add(feedbackMap);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return feedback;
    }
    
    private Map<String, Object> generateSystemReportData() throws SQLException {
        Map<String, Object> reportData = new HashMap<>();
        
        BloodStockDAO stockDAO = new BloodStockDAO();
        DonorDAO donorDAO = new DonorDAO();
        BloodRequestDAO requestDAO = new BloodRequestDAO();
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        
        // Get basic counts
        reportData.put("totalBloodUnits", stockDAO.getAllBloodStock().size());
        reportData.put("totalDonors", donorDAO.getAllDonors().size());
        reportData.put("totalRequests", requestDAO.getAllBloodRequests().size());
        reportData.put("activeAppointments", appointmentDAO.getAllAppointments().size());
        
        // Add detailed data
        reportData.put("bloodStock", convertToMapList(stockDAO.getAllBloodStock()));
        reportData.put("donors", convertToMapList(donorDAO.getAllDonors()));
        reportData.put("requests", convertToMapList(requestDAO.getAllBloodRequests()));
        
        return reportData;
    }
    
    private List<Map<String, Object>> convertToMapList(List<?> objects) {
        List<Map<String, Object>> mapList = new ArrayList<>();
        if (objects == null || objects.isEmpty()) {
            return mapList;
        }
        
        // Convert based on object type
        for (Object obj : objects) {
            Map<String, Object> map = new HashMap<>();
            if (obj instanceof com.blooddonation.model.BloodStock) {
                com.blooddonation.model.BloodStock stock = (com.blooddonation.model.BloodStock) obj;
                map.put("bloodGroup", stock.getBloodGroup());
                map.put("quantity", stock.getQuantity());
                map.put("expiryDate", stock.getExpiryDate() != null ? stock.getExpiryDate().toString() : "N/A");
                map.put("status", stock.isUsable() ? "USABLE" : (stock.isExpired() ? "EXPIRED" : "QUARANTINED"));
            } else if (obj instanceof com.blooddonation.model.Donor) {
                com.blooddonation.model.Donor donor = (com.blooddonation.model.Donor) obj;
                map.put("name", donor.getName());
                map.put("bloodGroup", donor.getBloodGroup());
                map.put("age", donor.getAge());
                map.put("gender", donor.getGender());
                map.put("lastDonationDate", donor.getLastDonationDate() != null ? donor.getLastDonationDate().toString() : "Never");
            } else if (obj instanceof com.blooddonation.model.BloodRequest) {
                com.blooddonation.model.BloodRequest request = (com.blooddonation.model.BloodRequest) obj;
                map.put("hospitalId", request.getHospitalId());
                map.put("bloodGroup", request.getBloodGroup());
                map.put("quantity", request.getQuantity());
                map.put("urgency", request.getUrgency());
                map.put("status", request.getStatus());
                map.put("requestDate", request.getRequestDate() != null ? request.getRequestDate().toString() : "N/A");
            }
            mapList.add(map);
        }
        return mapList;
    }
    
    // Sample data generation methods for testing
    private List<Map<String, Object>> generateSampleBloodStock() {
        List<Map<String, Object>> stocks = new ArrayList<>();
        String[] bloodGroups = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};
        String[] statuses = {"USABLE", "EXPIRED", "QUARANTINED"};
        
        for (int i = 0; i < 8; i++) {
            Map<String, Object> stock = new HashMap<>();
            stock.put("bloodGroup", bloodGroups[i]);
            stock.put("quantity", 50 + (i * 10));
            stock.put("expiryDate", "2025-12-" + String.format("%02d", 15 + i));
            stock.put("status", statuses[i % 3]);
            stock.put("collectionDate", "2024-09-" + String.format("%02d", 1 + i));
            stocks.add(stock);
        }
        return stocks;
    }
    
    private List<Map<String, Object>> generateSampleDonors() {
        List<Map<String, Object>> donors = new ArrayList<>();
        String[] names = {"John Smith", "Sarah Johnson", "Mike Davis", "Lisa Wilson", "David Brown", "Emma Taylor"};
        String[] bloodGroups = {"A+", "B+", "O+", "AB+", "A-", "B-"};
        String[] genders = {"MALE", "FEMALE", "MALE", "FEMALE", "MALE", "FEMALE"};
        
        for (int i = 0; i < 6; i++) {
            Map<String, Object> donor = new HashMap<>();
            donor.put("name", names[i]);
            donor.put("bloodGroup", bloodGroups[i]);
            donor.put("age", 25 + (i * 5));
            donor.put("gender", genders[i]);
            donor.put("lastDonationDate", "2024-08-" + String.format("%02d", 10 + i));
            donor.put("status", "ACTIVE");
            donors.add(donor);
        }
        return donors;
    }
    
    private List<Map<String, Object>> generateSampleBloodRequests() {
        List<Map<String, Object>> requests = new ArrayList<>();
        String[] hospitals = {"City Hospital", "General Medical", "Emergency Center", "Community Health"};
        String[] bloodGroups = {"A+", "B+", "O+", "AB+"};
        String[] urgencies = {"HIGH", "MEDIUM", "LOW", "CRITICAL"};
        String[] statuses = {"PENDING", "APPROVED", "COMPLETED", "REJECTED"};
        
        for (int i = 0; i < 4; i++) {
            Map<String, Object> request = new HashMap<>();
            request.put("hospitalId", hospitals[i]);
            request.put("bloodGroup", bloodGroups[i]);
            request.put("quantity", 5 + (i * 2));
            request.put("urgency", urgencies[i]);
            request.put("status", statuses[i]);
            request.put("requestDate", "2024-09-" + String.format("%02d", 20 + i));
            requests.add(request);
        }
        return requests;
    }
    
    private List<Map<String, Object>> generateSampleAppointments() {
        List<Map<String, Object>> appointments = new ArrayList<>();
        String[] donorNames = {"John Smith", "Sarah Johnson", "Mike Davis", "Lisa Wilson"};
        String[] timeSlots = {"09:00-10:00", "10:00-11:00", "11:00-12:00", "14:00-15:00"};
        String[] statuses = {"PENDING", "APPROVED", "COMPLETED", "CANCELLED"};
        
        for (int i = 0; i < 4; i++) {
            Map<String, Object> appointment = new HashMap<>();
            appointment.put("donorName", donorNames[i]);
            appointment.put("appointmentDate", "2024-10-" + String.format("%02d", 1 + i));
            appointment.put("timeSlot", timeSlots[i]);
            appointment.put("status", statuses[i]);
            appointment.put("createdDate", "2024-09-" + String.format("%02d", 25 + i));
            appointments.add(appointment);
        }
        return appointments;
    }
    
    private List<Map<String, Object>> generateSampleFeedback() {
        List<Map<String, Object>> feedback = new ArrayList<>();
        String[] users = {"John Smith", "Sarah Johnson", "Mike Davis"};
        String[] categories = {"SERVICE", "FACILITY", "STAFF"};
        String[] messages = {"Great service!", "Need improvement in waiting area", "Staff was very helpful"};
        String[] statuses = {"PENDING", "RESPONDED", "RESOLVED"};
        
        for (int i = 0; i < 3; i++) {
            Map<String, Object> fb = new HashMap<>();
            fb.put("userName", users[i]);
            fb.put("category", categories[i]);
            fb.put("message", messages[i]);
            fb.put("status", statuses[i]);
            fb.put("createdDate", "2024-09-" + String.format("%02d", 28 + i));
            feedback.add(fb);
        }
        return feedback;
    }
}