package com.blooddonation.servlet;

import com.blooddonation.service.DonorService;
import com.blooddonation.model.User;
import com.blooddonation.model.Donor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/eligibility")
public class EligibilityServlet extends HttpServlet {
    
    private DonorService donorService;
    
    public EligibilityServlet() {
        this.donorService = new DonorService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        // Check if user is a donor
        if (!"DONOR".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            // Get donor information for eligibility check
            Donor donor = donorService.getDonorByUserId(user.getId());
            if (donor != null) {
                request.setAttribute("donor", donor);
                request.setAttribute("isEligible", donorService.isEligibleToDonate(user.getId()));
                request.setAttribute("lastDonationDate", donor.getLastDonationDate());
                request.setAttribute("bloodGroup", donor.getBloodGroup());
            }
            
            request.getRequestDispatcher("/jsp/donor/donor_eligibility.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading eligibility data: " + e.getMessage());
            request.getRequestDispatcher("/jsp/donor/donor_eligibility.jsp").forward(request, response);
        }
    }
}
