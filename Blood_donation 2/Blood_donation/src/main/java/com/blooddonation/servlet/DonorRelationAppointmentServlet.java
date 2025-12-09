package com.blooddonation.servlet;

import com.blooddonation.dao.AppointmentDAO;
import com.blooddonation.dao.DonorDAO;
import com.blooddonation.dao.DonationCampDAO;
import com.blooddonation.dao.UserDAO;
import com.blooddonation.model.Appointment;
import com.blooddonation.model.Donor;
import com.blooddonation.model.DonationCamp;
import com.blooddonation.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class DonorRelationAppointmentServlet extends HttpServlet {
    
    private AppointmentDAO appointmentDAO;
    private DonorDAO donorDAO;
    private DonationCampDAO campDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.appointmentDAO = new AppointmentDAO();
        this.donorDAO = new DonorDAO();
        this.campDAO = new DonationCampDAO();
        this.userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"DONOR_RELATION".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String action = request.getPathInfo();
        if (action == null || action.equals("/")) {
            action = "/list";
        }
        
        try {
            switch (action) {
                case "/list":
                    showAppointmentList(request, response);
                    break;
                case "/pending":
                    showPendingAppointments(request, response);
                    break;
                case "/approved":
                    showApprovedAppointments(request, response);
                    break;
                case "/rejected":
                    showRejectedAppointments(request, response);
                    break;
                case "/details":
                    showAppointmentDetails(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred");
            request.getRequestDispatcher("/jsp/donor_relation/donor_relation_appointments.jsp").forward(request, response);
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
        if (!"DONOR_RELATION".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String action = request.getPathInfo();
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action required");
            return;
        }
        
        try {
            switch (action) {
                case "/approve":
                    approveAppointment(request, response);
                    break;
                case "/reject":
                    rejectAppointment(request, response);
                    break;
                case "/bulk-approve":
                    bulkApproveAppointments(request, response);
                    break;
                case "/bulk-reject":
                    bulkRejectAppointments(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Action not found");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred");
            response.sendRedirect(request.getContextPath() + "/donor-relation/appointments?error=database_error");
        }
    }
    
    private void showAppointmentList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        String status = request.getParameter("status");
        String search = request.getParameter("search");
        String dateFilter = request.getParameter("date");
        
        List<Appointment> appointments;
        
        if (status != null && !status.isEmpty()) {
            appointments = appointmentDAO.getAppointmentsByStatus(status.toUpperCase());
        } else {
            appointments = appointmentDAO.getAllAppointments();
        }
        
        // Apply search filter
        if (search != null && !search.isEmpty()) {
            appointments = filterAppointmentsBySearch(appointments, search);
        }
        
        // Apply date filter
        if (dateFilter != null && !dateFilter.isEmpty()) {
            try {
                Date filterDate = new SimpleDateFormat("yyyy-MM-dd").parse(dateFilter);
                appointments = filterAppointmentsByDate(appointments, filterDate);
            } catch (Exception e) {
                // Invalid date format, ignore filter
            }
        }
        
        // Get appointment details with donor and camp information
        List<AppointmentDetails> appointmentDetails = getAppointmentDetails(appointments);
        
        request.setAttribute("appointments", appointmentDetails);
        request.setAttribute("currentStatus", status);
        request.setAttribute("searchTerm", search);
        request.setAttribute("dateFilter", dateFilter);
        
        // Get statistics
        request.setAttribute("pendingCount", appointmentDAO.getAppointmentCountByStatus("PENDING"));
        request.setAttribute("approvedCount", appointmentDAO.getAppointmentCountByStatus("APPROVED"));
        request.setAttribute("rejectedCount", appointmentDAO.getAppointmentCountByStatus("REJECTED"));
        request.setAttribute("completedCount", appointmentDAO.getAppointmentCountByStatus("COMPLETED"));
        
        request.getRequestDispatcher("/jsp/donor_relation/donor_relation_appointments.jsp").forward(request, response);
    }
    
    private void showPendingAppointments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        List<Appointment> appointments = appointmentDAO.getPendingAppointments();
        List<AppointmentDetails> appointmentDetails = getAppointmentDetails(appointments);
        
        request.setAttribute("appointments", appointmentDetails);
        request.setAttribute("currentStatus", "PENDING");
        
        request.getRequestDispatcher("/jsp/donor_relation/donor_relation_appointments.jsp").forward(request, response);
    }
    
    private void showApprovedAppointments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        List<Appointment> appointments = appointmentDAO.getApprovedAppointments();
        List<AppointmentDetails> appointmentDetails = getAppointmentDetails(appointments);
        
        request.setAttribute("appointments", appointmentDetails);
        request.setAttribute("currentStatus", "APPROVED");
        
        request.getRequestDispatcher("/jsp/donor_relation/donor_relation_appointments.jsp").forward(request, response);
    }
    
    private void showRejectedAppointments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        List<Appointment> appointments = appointmentDAO.getAppointmentsByStatus("REJECTED");
        List<AppointmentDetails> appointmentDetails = getAppointmentDetails(appointments);
        
        request.setAttribute("appointments", appointmentDetails);
        request.setAttribute("currentStatus", "REJECTED");
        
        request.getRequestDispatcher("/jsp/donor_relation/donor_relation_appointments.jsp").forward(request, response);
    }
    
    private void showAppointmentDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int appointmentId = Integer.parseInt(request.getParameter("id"));
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
        
        if (appointment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found");
            return;
        }
        
        AppointmentDetails details = getAppointmentDetail(appointment);
        request.setAttribute("appointment", details);
        
        request.getRequestDispatcher("/jsp/donor_relation/appointment_details.jsp").forward(request, response);
    }
    
    private void approveAppointment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
        String notes = request.getParameter("notes");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        appointmentDAO.approveAppointment(appointmentId, user.getId());
        
        // Update notes if provided
        if (notes != null && !notes.trim().isEmpty()) {
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            appointment.setNotes(notes);
            appointmentDAO.updateAppointment(appointment);
        }
        
        response.sendRedirect(request.getContextPath() + "/donor-relation/appointments?status=APPROVED&success=approved");
    }
    
    private void rejectAppointment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
        String reason = request.getParameter("reason");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        appointmentDAO.rejectAppointment(appointmentId, user.getId());
        
        // Update notes with rejection reason
        if (reason != null && !reason.trim().isEmpty()) {
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            appointment.setNotes("Rejection reason: " + reason);
            appointmentDAO.updateAppointment(appointment);
        }
        
        response.sendRedirect(request.getContextPath() + "/donor-relation/appointments?status=REJECTED&success=rejected");
    }
    
    private void bulkApproveAppointments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        String[] appointmentIds = request.getParameterValues("appointment_ids");
        if (appointmentIds == null || appointmentIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/donor-relation/appointments?error=no_selection");
            return;
        }
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        for (String appointmentIdStr : appointmentIds) {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            appointmentDAO.approveAppointment(appointmentId, user.getId());
        }
        
        response.sendRedirect(request.getContextPath() + "/donor-relation/appointments?status=APPROVED&success=bulk_approved&count=" + appointmentIds.length);
    }
    
    private void bulkRejectAppointments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        String[] appointmentIds = request.getParameterValues("appointment_ids");
        String reason = request.getParameter("reason");
        
        if (appointmentIds == null || appointmentIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/donor-relation/appointments?error=no_selection");
            return;
        }
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        for (String appointmentIdStr : appointmentIds) {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            appointmentDAO.rejectAppointment(appointmentId, user.getId());
            
            // Update notes with rejection reason
            if (reason != null && !reason.trim().isEmpty()) {
                Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
                appointment.setNotes("Bulk rejection reason: " + reason);
                appointmentDAO.updateAppointment(appointment);
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/donor-relation/appointments?status=REJECTED&success=bulk_rejected&count=" + appointmentIds.length);
    }
    
    private List<AppointmentDetails> getAppointmentDetails(List<Appointment> appointments) throws SQLException {
        List<AppointmentDetails> details = new ArrayList<>();
        
        for (Appointment appointment : appointments) {
            details.add(getAppointmentDetail(appointment));
        }
        
        return details;
    }
    
    private AppointmentDetails getAppointmentDetail(Appointment appointment) throws SQLException {
        AppointmentDetails details = new AppointmentDetails();
        details.setAppointment(appointment);
        
        // Get donor information
        Donor donor = donorDAO.getDonorById(appointment.getDonorId());
        if (donor != null) {
            details.setDonorName(donor.getName());
            details.setDonorBloodGroup(donor.getBloodGroup());
            
            // Get user information for email and phone
            User user = userDAO.getUserById(donor.getUserId());
            if (user != null) {
                details.setDonorEmail(user.getEmail());
                details.setDonorPhone(user.getPhone());
            }
        }
        
        // Get camp information
        DonationCamp camp = campDAO.getDonationCampById(appointment.getCampId());
        if (camp != null) {
            details.setCampName(camp.getCampName());
            details.setCampLocation(camp.getLocation());
            details.setCampDate(camp.getCampDate());
        }
        
        return details;
    }
    
    private List<Appointment> filterAppointmentsBySearch(List<Appointment> appointments, String search) {
        List<Appointment> filtered = new ArrayList<>();
        String searchLower = search.toLowerCase();
        
        for (Appointment appointment : appointments) {
            // This is a simplified search - in a real implementation, you'd search donor names, camp names, etc.
            if (appointment.getTimeSlot().toLowerCase().contains(searchLower) ||
                appointment.getStatus().toLowerCase().contains(searchLower)) {
                filtered.add(appointment);
            }
        }
        
        return filtered;
    }
    
    private List<Appointment> filterAppointmentsByDate(List<Appointment> appointments, Date filterDate) {
        List<Appointment> filtered = new ArrayList<>();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String filterDateStr = dateFormat.format(filterDate);
        
        for (Appointment appointment : appointments) {
            String appointmentDateStr = dateFormat.format(appointment.getAppointmentDate());
            if (appointmentDateStr.equals(filterDateStr)) {
                filtered.add(appointment);
            }
        }
        
        return filtered;
    }
    
    // Inner class to hold appointment details with related information
    public static class AppointmentDetails {
        private Appointment appointment;
        private String donorName;
        private String donorEmail;
        private String donorPhone;
        private String donorBloodGroup;
        private String campName;
        private String campLocation;
        private Date campDate;
        
        // Getters and setters
        public Appointment getAppointment() { return appointment; }
        public void setAppointment(Appointment appointment) { this.appointment = appointment; }
        
        public String getDonorName() { return donorName; }
        public void setDonorName(String donorName) { this.donorName = donorName; }
        
        public String getDonorEmail() { return donorEmail; }
        public void setDonorEmail(String donorEmail) { this.donorEmail = donorEmail; }
        
        public String getDonorPhone() { return donorPhone; }
        public void setDonorPhone(String donorPhone) { this.donorPhone = donorPhone; }
        
        public String getDonorBloodGroup() { return donorBloodGroup; }
        public void setDonorBloodGroup(String donorBloodGroup) { this.donorBloodGroup = donorBloodGroup; }
        
        public String getCampName() { return campName; }
        public void setCampName(String campName) { this.campName = campName; }
        
        public String getCampLocation() { return campLocation; }
        public void setCampLocation(String campLocation) { this.campLocation = campLocation; }
        
        public Date getCampDate() { return campDate; }
        public void setCampDate(Date campDate) { this.campDate = campDate; }
    }
}
