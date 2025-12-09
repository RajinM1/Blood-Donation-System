package com.blooddonation.servlet;

import com.blooddonation.dao.BloodReportDAO;
import com.blooddonation.dao.DonorDAO;
import com.blooddonation.model.BloodReport;
import com.blooddonation.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

public class BloodReportServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward to the submit blood report page
        request.getRequestDispatcher("/jsp/donor/submit_blood_report.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("BloodReportServlet doPost called");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("No session or user found");
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        System.out.println("User found: " + user.getUsername());
        
        DonorDAO donorDAO = new DonorDAO();
        BloodReportDAO bloodReportDAO = new BloodReportDAO();

        // Check if this is a delete request
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            handleDeleteBloodReport(request, response, user, donorDAO, bloodReportDAO);
            return;
        }

        try {
            // Debug: Print all parameters
            System.out.println("Request parameters:");
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                System.out.println(paramName + " = " + paramValue);
            }
            
            // Get or create donor record
            int userId = user.getId();
            com.blooddonation.model.Donor donor = donorDAO.getDonorByUserId(userId);
            if (donor == null) {
                donor = new com.blooddonation.model.Donor();
                donor.setUserId(userId);
                donor.setName(user.getUsername()); // Fallback name
                donorDAO.addDonor(donor); // Insert new donor
            }
            int donorId = donor.getId(); // Use the donor's id, not user_id

            // Create and populate blood report
            BloodReport report = new BloodReport();
            report.setDonorId(donorId);
            // Don't set appointment_id for donor-submitted reports
            report.setHemoglobin(new java.math.BigDecimal(request.getParameter("hemoglobin")));
            report.setRbc(new java.math.BigDecimal(request.getParameter("rbc")));
            report.setHct(new java.math.BigDecimal(request.getParameter("hct")));
            report.setMcv(new java.math.BigDecimal(request.getParameter("mcv")));
            report.setMch(new java.math.BigDecimal(request.getParameter("mch")));
            report.setMchc(new java.math.BigDecimal(request.getParameter("mchc")));
            report.setRdw(new java.math.BigDecimal(request.getParameter("rdw")));
            report.setWbc(new java.math.BigDecimal(request.getParameter("wbc")));
            report.setEsr(new java.math.BigDecimal(request.getParameter("esr")));
            report.setPlt(new java.math.BigDecimal(request.getParameter("plt")));
            report.setGra(new java.math.BigDecimal(request.getParameter("gra")));
            report.setLym(new java.math.BigDecimal(request.getParameter("lym")));
            report.setEos(new java.math.BigDecimal(request.getParameter("eos")));
            report.setBas(new java.math.BigDecimal(request.getParameter("bas")));
            
            // Additional fields - handle null values gracefully
            String bloodPressureSystolic = request.getParameter("blood_pressure_systolic");
            if (bloodPressureSystolic != null && !bloodPressureSystolic.trim().isEmpty()) {
                report.setBloodPressureSystolic(Integer.parseInt(bloodPressureSystolic));
            }
            
            String bloodPressureDiastolic = request.getParameter("blood_pressure_diastolic");
            if (bloodPressureDiastolic != null && !bloodPressureDiastolic.trim().isEmpty()) {
                report.setBloodPressureDiastolic(Integer.parseInt(bloodPressureDiastolic));
            }
            
            String pulseRate = request.getParameter("pulse_rate");
            if (pulseRate != null && !pulseRate.trim().isEmpty()) {
                report.setPulseRate(Integer.parseInt(pulseRate));
            }
            
            String temperature = request.getParameter("temperature");
            if (temperature != null && !temperature.trim().isEmpty()) {
                report.setTemperature(new java.math.BigDecimal(temperature));
            }
            
            String weightAtDonation = request.getParameter("weight_at_donation");
            if (weightAtDonation != null && !weightAtDonation.trim().isEmpty()) {
                report.setWeightAtDonation(new java.math.BigDecimal(weightAtDonation));
            }
            
            String donationVolume = request.getParameter("donation_volume");
            if (donationVolume != null && !donationVolume.trim().isEmpty()) {
                report.setDonationVolume(Integer.parseInt(donationVolume));
            }
            
            String medicalStaffNotes = request.getParameter("medical_staff_notes");
            if (medicalStaffNotes != null && !medicalStaffNotes.trim().isEmpty()) {
                report.setMedicalStaffNotes(medicalStaffNotes.trim());
            }
            
            report.setStatus("PENDING");
            report.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));

            // Save blood report
            bloodReportDAO.addBloodReport(report);
            response.sendRedirect(request.getContextPath() + "/blood-report/submit?success=true");
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing blood report: " + e.getMessage());
            request.getRequestDispatcher("/jsp/donor/submit_blood_report.jsp").forward(request, response);
        }
    }
    
    private void handleDeleteBloodReport(HttpServletRequest request, HttpServletResponse response, User user, DonorDAO donorDAO, BloodReportDAO bloodReportDAO) throws ServletException, IOException {
        try {
            int reportId = Integer.parseInt(request.getParameter("reportId"));
            
            // Get donor to ensure user can only delete their own reports
            com.blooddonation.model.Donor donor = donorDAO.getDonorByUserId(user.getId());
            if (donor == null) {
                response.sendRedirect(request.getContextPath() + "/view/my-blood-reports?error=Donor profile not found");
                return;
            }
            
            // Delete the blood report (with security check)
            boolean deleted = bloodReportDAO.deleteBloodReportByDonor(reportId, donor.getId());
            
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/view/my-blood-reports?success=Blood report deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/view/my-blood-reports?error=Blood report not found or you don't have permission to delete it");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/view/my-blood-reports?error=Invalid report ID");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view/my-blood-reports?error=Error deleting blood report: " + e.getMessage());
        }
    }
}