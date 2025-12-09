package com.blooddonation.servlet;

import com.blooddonation.dao.DonationCampDAO;
import com.blooddonation.model.DonationCamp;
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

public class DonationCampServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        DonationCampDAO campDAO = new DonationCampDAO();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.getRole().equalsIgnoreCase("donor_relation")) { // Changed to equalsIgnoreCase for consistency
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            if ("/add".equals(action)) {
                DonationCamp camp = new DonationCamp();
                camp.setCampName(request.getParameter("camp_name"));
                camp.setCampDate(new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("camp_date")));
                camp.setLocation(request.getParameter("location"));
                camp.setCreatedBy(user.getId());
                campDAO.addDonationCamp(camp);
                response.sendRedirect(request.getContextPath() + "/jsp/donor_relation/donor_relation_camp_management.jsp");
            }
        } catch (SQLException | ParseException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error adding donation camp");
            request.getRequestDispatcher("/jsp/donor_relation/donor_relation_camp_management.jsp").forward(request, response);
        }
    }
}