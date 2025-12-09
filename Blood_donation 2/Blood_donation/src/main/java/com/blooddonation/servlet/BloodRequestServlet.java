package com.blooddonation.servlet;

import com.blooddonation.dao.BloodRequestDAO;
import com.blooddonation.dao.BloodStockDAO;
import com.blooddonation.model.BloodRequest;
import com.blooddonation.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

public class BloodRequestServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.getRole().equalsIgnoreCase("hospital") && !user.getRole().equalsIgnoreCase("hospital_coordinator")) {
            request.setAttribute("error", "Unauthorized access. Role: " + user.getRole());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            if ("/history".equals(action)) {
                BloodRequestDAO requestDAO = new BloodRequestDAO();
                List<BloodRequest> requests = requestDAO.getBloodRequestsByHospitalId(user.getId());
                request.setAttribute("requests", requests);
                request.getRequestDispatcher("/jsp/hospital/hospital_request_history.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading request history");
            request.getRequestDispatcher("/jsp/hospital/hospital_request_history.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        BloodRequestDAO requestDAO = new BloodRequestDAO();
        BloodStockDAO stockDAO = new BloodStockDAO();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        System.out.println("User role: " + user.getRole()); // Debug log
        if (!user.getRole().equalsIgnoreCase("hospital") && !user.getRole().equalsIgnoreCase("hospital_coordinator")) {
            request.setAttribute("error", "Unauthorized access. Role: " + user.getRole());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            if ("/submit".equals(action)) {
                BloodRequest bloodRequest = new BloodRequest();
                int hospitalId = user.getId();
                bloodRequest.setHospitalId(hospitalId);
                bloodRequest.setBloodGroup(request.getParameter("blood_group"));
                bloodRequest.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                bloodRequest.setUrgency(request.getParameter("urgency"));
                bloodRequest.setPatientName(request.getParameter("patient_name"));
                bloodRequest.setReason(request.getParameter("reason"));
                bloodRequest.setStatus("PENDING");
                bloodRequest.setRequestDate(new Date());
                bloodRequest.setCreatedAt(new Date());
                requestDAO.addBloodRequest(bloodRequest);
                response.sendRedirect(request.getContextPath() + "/blood-request/history?success=true");
            } else if ("/approve".equals(action) && user.getRole().equalsIgnoreCase("hospital_coordinator")) {
                int requestId = Integer.parseInt(request.getParameter("request_id"));
                BloodRequest bloodRequest = requestDAO.getBloodRequestsByHospitalId(user.getId()).stream()
                        .filter(r -> r.getId() == requestId).findFirst().orElse(null);
                if (bloodRequest != null) {
                    if (stockDAO.getAllBloodStock().stream()
                            .anyMatch(stock -> stock.getBloodGroup().equals(bloodRequest.getBloodGroup())
                                    && stock.getQuantity() >= bloodRequest.getQuantity())) {
                        requestDAO.updateBloodRequestStatus(requestId, "APPROVED", new Date());
                        response.sendRedirect(request.getContextPath() + "/coordinator/requests?success=true"); // Redirect to GET
                    } else {
                        request.setAttribute("error", "Insufficient stock");
                        request.getRequestDispatcher("/jsp/hospital_coordinator/hospital_coordinator_requests.jsp").forward(request, response);
                    }
                }
            } else if ("/reject".equals(action) && user.getRole().equalsIgnoreCase("hospital_coordinator")) {
                int requestId = Integer.parseInt(request.getParameter("request_id"));
                requestDAO.updateBloodRequestStatus(requestId, "REJECTED", null);
                response.sendRedirect(request.getContextPath() + "/coordinator/requests?success=true"); // Redirect to GET
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            String forwardJsp = user.getRole().equalsIgnoreCase("hospital")
                    ? "/jsp/hospital/hospital_blood_request.jsp"
                    : "/jsp/hospital_coordinator/hospital_coordinator_requests.jsp";
            request.getRequestDispatcher(forwardJsp).forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid input: " + e.getMessage());
            String forwardJsp = user.getRole().equalsIgnoreCase("hospital")
                    ? "/jsp/hospital/hospital_blood_request.jsp"
                    : "/jsp/hospital_coordinator/hospital_coordinator_requests.jsp";
            request.getRequestDispatcher(forwardJsp).forward(request, response);
        }
    }
}