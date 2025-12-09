package com.blooddonation.servlet;

import com.blooddonation.dao.DonorDAO;
import com.blooddonation.model.Donor;
import com.blooddonation.model.User;
import com.blooddonation.util.ValidationUtil;

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

public class DonorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        DonorDAO donorDAO = new DonorDAO();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            if ("/register".equals(action)) {
                Donor donor = new Donor();
                donor.setUserId(user.getId());
                donor.setName(request.getParameter("name"));
                donor.setAge(Integer.parseInt(request.getParameter("age")));
                donor.setGender(request.getParameter("gender"));
                donor.setBloodGroup(request.getParameter("blood_group"));
                donor.setHealthInfo(request.getParameter("health_info"));
                // Weight and eligibility checks
                String weightStr = request.getParameter("weight");
                if (weightStr != null && !weightStr.trim().isEmpty()) {
                    double weight = Double.parseDouble(weightStr);
                    if (!ValidationUtil.isValidWeight(weight)) {
                        request.setAttribute("error", "Weight must be at least 50kg for donation eligibility.");
                        request.getRequestDispatcher("/jsp/donor/donor_profile.jsp").forward(request, response);
                        return;
                    }
                    donor.setWeight(weight);
                }
                String lastDonationDate = request.getParameter("last_donation_date");
                if (lastDonationDate != null && !lastDonationDate.isEmpty()) {
                    java.util.Date parsed = new SimpleDateFormat("yyyy-MM-dd").parse(lastDonationDate);
                    if (!isValidLastDonationDate(parsed)) {
                        request.setAttribute("error", "Last donation date cannot be in the future and must be within the last 10 years.");
                        request.getRequestDispatcher("/jsp/donor/donor_profile.jsp").forward(request, response);
                        return;
                    }
                    donor.setLastDonationDate(parsed);
                }
                donorDAO.addDonor(donor);
                response.sendRedirect(request.getContextPath() + "/jsp/donor/donor_dashboard.jsp");
            } else if ("/update".equals(action)) {
                Donor donor = donorDAO.getDonorByUserId(user.getId());
                if (donor == null) {
                    donor = new Donor();
                    donor.setUserId(user.getId());
                    // Set initial values before adding
                    donor.setName(request.getParameter("name"));
                    if (donor.getName() == null || donor.getName().trim().isEmpty()) {
                        donor.setName(user.getUsername()); // Fallback to username
                    }
                    donor.setAge(Integer.parseInt(request.getParameter("age")));
                    donor.setGender(request.getParameter("gender"));
                    donor.setBloodGroup(request.getParameter("blood_group"));
                    donor.setHealthInfo(request.getParameter("health_info"));
                    // Weight and eligibility checks
                    String weightStr = request.getParameter("weight");
                    if (weightStr != null && !weightStr.trim().isEmpty()) {
                        double weight = Double.parseDouble(weightStr);
                        if (!ValidationUtil.isValidWeight(weight)) {
                            request.setAttribute("error", "Weight must be at least 50kg for donation eligibility.");
                            request.getRequestDispatcher("/jsp/donor/donor_profile.jsp").forward(request, response);
                            return;
                        }
                        donor.setWeight(weight);
                    }
                    String lastDonationDate = request.getParameter("last_donation_date");
                    if (lastDonationDate != null && !lastDonationDate.isEmpty()) {
                        java.util.Date parsed = new SimpleDateFormat("yyyy-MM-dd").parse(lastDonationDate);
                    if (!isValidLastDonationDate(parsed)) {
                        request.setAttribute("error", "Last donation date cannot be in the future and must be within the last 10 years.");
                        request.getRequestDispatcher("/jsp/donor/donor_profile.jsp").forward(request, response);
                        return;
                    }
                        donor.setLastDonationDate(parsed);
                    } else {
                        donor.setLastDonationDate(null);
                    }
                    donorDAO.addDonor(donor); // Insert new donor with initial data
                } else {
                    // Update existing donor
                    donor.setName(request.getParameter("name"));
                    if (donor.getName() == null || donor.getName().trim().isEmpty()) {
                        donor.setName(user.getUsername()); // Fallback to username
                    }
                    donor.setAge(Integer.parseInt(request.getParameter("age")));
                    donor.setGender(request.getParameter("gender"));
                    donor.setBloodGroup(request.getParameter("blood_group"));
                    donor.setHealthInfo(request.getParameter("health_info"));
                    // Weight and eligibility checks
                    String weightStr = request.getParameter("weight");
                    if (weightStr != null && !weightStr.trim().isEmpty()) {
                        double weight = Double.parseDouble(weightStr);
                        if (!ValidationUtil.isValidWeight(weight)) {
                            request.setAttribute("error", "Weight must be at least 50kg for donation eligibility.");
                            request.getRequestDispatcher("/jsp/donor/donor_profile.jsp").forward(request, response);
                            return;
                        }
                        donor.setWeight(weight);
                    }
                    String lastDonationDate = request.getParameter("last_donation_date");
                    if (lastDonationDate != null && !lastDonationDate.isEmpty()) {
                        java.util.Date parsed = new SimpleDateFormat("yyyy-MM-dd").parse(lastDonationDate);
                    if (!isValidLastDonationDate(parsed)) {
                        request.setAttribute("error", "Last donation date cannot be in the future and must be within the last 10 years.");
                        request.getRequestDispatcher("/jsp/donor/donor_profile.jsp").forward(request, response);
                        return;
                    }
                        donor.setLastDonationDate(parsed);
                    } else {
                        donor.setLastDonationDate(null);
                    }
                    donorDAO.updateDonor(donor);
                }
                response.sendRedirect(request.getContextPath() + "/view/my-details?success=true");
            }
        } catch (SQLException | ParseException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing donor data: " + e.getMessage());
            request.getRequestDispatcher("/jsp/donor/donor_profile.jsp").forward(request, response);
        }
    }
    
    /**
     * Validates last donation date for profile updates
     * Date cannot be in the future and must be within reasonable range (last 10 years)
     */
    private boolean isValidLastDonationDate(java.util.Date lastDonationDate) {
        if (lastDonationDate == null) {
            return true; // Empty date is allowed
        }
        
        java.util.Date now = new java.util.Date();
        
        // Check if date is in the future
        if (lastDonationDate.after(now)) {
            return false;
        }
        
        // Check if date is within last 10 years (reasonable range)
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(now);
        cal.add(java.util.Calendar.YEAR, -10);
        java.util.Date tenYearsAgo = cal.getTime();
        
        return lastDonationDate.after(tenYearsAgo);
    }
}