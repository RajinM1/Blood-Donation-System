package com.blooddonation.service;

import com.blooddonation.dao.BloodReportDAO;
import com.blooddonation.dao.DonorDAO;
import com.blooddonation.model.BloodReport;
import com.blooddonation.model.Donor;
import com.blooddonation.util.ValidationUtil;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

public class BloodReportService {
    
    private BloodReportDAO reportDAO;
    private DonorDAO donorDAO;
    
    public BloodReportService() {
        this.reportDAO = new BloodReportDAO();
        this.donorDAO = new DonorDAO();
    }
    
    /**
     * Submit blood report
     */
    public boolean submitBloodReport(int donorId, BloodReport report) throws SQLException {
        // Validate donor exists
        Donor donor = donorDAO.getDonorById(donorId);
        if (donor == null) {
            throw new IllegalArgumentException("Donor not found");
        }
        
        // Set donor ID and submission date
        report.setDonorId(donorId);
        report.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));
        report.setStatus("PENDING");
        
        // Add report to database
        reportDAO.addBloodReport(report);
        
        return true;
    }
    
    /**
     * Approve blood report
     */
    public boolean approveBloodReport(int reportId, int approvedBy) throws SQLException {
        BloodReport report = reportDAO.getBloodReportById(reportId);
        if (report == null) {
            return false;
        }
        
        report.setStatus("APPROVED");
        reportDAO.updateBloodReport(report);
        
        return true;
    }
    
    /**
     * Reject blood report
     */
    public boolean rejectBloodReport(int reportId, int rejectedBy) throws SQLException {
        BloodReport report = reportDAO.getBloodReportById(reportId);
        if (report == null) {
            return false;
        }
        
        report.setStatus("REJECTED");
        reportDAO.updateBloodReport(report);
        
        return true;
    }
    
    /**
     * Get all pending reports
     */
    public List<BloodReport> getPendingReports() throws SQLException {
        return reportDAO.getBloodReportsByStatus("PENDING");
    }
    
    /**
     * Get reports by donor
     */
    public List<BloodReport> getReportsByDonor(int donorId) throws SQLException {
        return reportDAO.getBloodReportsByDonorId(donorId);
    }
    
    /**
     * Get all reports
     */
    public List<BloodReport> getAllReports() throws SQLException {
        return reportDAO.getAllBloodReports();
    }
}