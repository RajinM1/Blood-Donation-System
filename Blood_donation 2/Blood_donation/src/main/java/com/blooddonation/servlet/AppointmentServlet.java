package com.blooddonation.servlet;

import com.blooddonation.service.AppointmentService;
import com.blooddonation.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class AppointmentServlet extends HttpServlet {
    private final AppointmentService appointmentService = new AppointmentService();

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
        if (!"DONOR".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            if ("/book".equals(action)) {
                int campId = Integer.parseInt(request.getParameter("camp_id"));
                Date appointmentDate = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("appointment_date"));
                String timeSlot = request.getParameter("time_slot");

                appointmentService.createAppointment(user.getId(), campId, appointmentDate, timeSlot);
                response.sendRedirect(request.getContextPath() + "/appointment-page?success=true");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Action not found");
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/appointment-page?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (SQLException | ParseException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error booking appointment");
            response.sendRedirect(request.getContextPath() + "/appointment-page?error=" + java.net.URLEncoder.encode("Error booking appointment", "UTF-8"));
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"DONOR".equalsIgnoreCase(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
            boolean ok = appointmentService.cancelAppointment(appointmentId);
            if (!ok) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}