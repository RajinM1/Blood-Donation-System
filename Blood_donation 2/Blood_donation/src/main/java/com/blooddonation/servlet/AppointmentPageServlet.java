package com.blooddonation.servlet;

import com.blooddonation.dao.DonationCampDAO;
import com.blooddonation.dao.AppointmentDAO;
import com.blooddonation.dao.DonorDAO;
import com.blooddonation.model.DonationCamp;
import com.blooddonation.model.Appointment;
import com.blooddonation.model.Donor;
import com.blooddonation.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class AppointmentPageServlet extends HttpServlet {
    
    private DonationCampDAO campDAO;
    private AppointmentDAO appointmentDAO;
    private DonorDAO donorDAO;
    
    public AppointmentPageServlet() {
        this.campDAO = new DonationCampDAO();
        this.appointmentDAO = new AppointmentDAO();
        this.donorDAO = new DonorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"DONOR".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            // Load available donation camps
            List<DonationCamp> camps = campDAO.getActiveDonationCamps();
            request.setAttribute("camps", camps);
            
            // Generate available time slots
            List<String> timeSlots = generateTimeSlots();
            request.setAttribute("availableSlots", timeSlots);
            
            // Load appointment history for the donor
            Donor donor = donorDAO.getDonorByUserId(user.getId());
            if (donor != null) {
                List<Appointment> appointments = appointmentDAO.getAppointmentsByDonorId(donor.getId());
                request.setAttribute("appointments", appointments);
            }
            
            // Forward to the appointment JSP
            request.getRequestDispatcher("/jsp/donor/donor_appointment.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading appointment data: " + e.getMessage());
            request.getRequestDispatcher("/jsp/donor/donor_appointment.jsp").forward(request, response);
        }
    }
    
    private List<String> generateTimeSlots() {
        List<String> slots = new ArrayList<>();
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        
        // Generate time slots from 9:00 AM to 5:00 PM with 1-hour intervals
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 9);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        
        for (int i = 0; i < 8; i++) { // 8 slots from 9 AM to 5 PM
            slots.add(timeFormat.format(cal.getTime()) + " - " + 
                     timeFormat.format(cal.getTimeInMillis() + 60 * 60 * 1000));
            cal.add(Calendar.HOUR_OF_DAY, 1);
        }
        
        return slots;
    }
}
