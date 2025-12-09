package com.blooddonation.servlet;

import com.blooddonation.dao.BloodRequestDAO;
import com.blooddonation.dao.BloodStockDAO;
import com.blooddonation.model.User;
import com.blooddonation.model.BloodStock;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.util.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class CoordinatorRequestServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        System.out.println("Coordinator role: " + user.getRole()); // Debug log
        if (!user.getRole().equalsIgnoreCase("hospital_coordinator")) {
            request.setAttribute("error", "Unauthorized access. Role: " + user.getRole());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        BloodRequestDAO requestDAO = new BloodRequestDAO();
        try {
            // Fetch all blood requests
            List<com.blooddonation.model.BloodRequest> allRequests = requestDAO.getAllBloodRequests();
            System.out.println("Total requests fetched: " + (allRequests != null ? allRequests.size() : "null")); // Debug log
            if (allRequests != null) {
                for (com.blooddonation.model.BloodRequest req : allRequests) {
                    System.out.println("Raw Request ID: " + req.getId() + ", Hospital ID: " + req.getHospitalId() + ", Status: " + (req.getStatus() != null ? req.getStatus() : "null"));
                }
            } else {
                System.out.println("allRequests is null");
            }
            // Filter for PENDING
            List<com.blooddonation.model.BloodRequest> requests = (allRequests != null) ? allRequests.stream()
                    .filter(r -> "PENDING".equalsIgnoreCase(r.getStatus()))
                    .collect(Collectors.toList()) : new ArrayList<>();
            System.out.println("Number of pending requests fetched: " + (requests != null ? requests.size() : "null")); // Debug log
            if (requests != null) {
                for (com.blooddonation.model.BloodRequest req : requests) {
                    System.out.println("Filtered Request ID: " + req.getId() + ", Hospital ID: " + req.getHospitalId() + ", Status: " + (req.getStatus() != null ? req.getStatus() : "null"));
                }
            } else {
                System.out.println("requests is null");
            }
            // Set attribute and debug
            System.out.println("Setting requests attribute with size: " + (requests != null ? requests.size() : "null"));
            request.setAttribute("requests", requests);
            session.setAttribute("requests", requests); // Fallback to session
            System.out.println("Before forward: requests attribute = " + (request.getAttribute("requests") != null ? ((List)request.getAttribute("requests")).size() : "null"));
            // Check for interference
            Object existingRequests = request.getAttribute("requests");
            System.out.println("Existing requests attribute before forward: " + (existingRequests != null ? existingRequests.getClass().getName() + ", size = " + ((List)existingRequests).size() : "null"));
            System.out.println("Forwarding to JSP...");
            request.getRequestDispatcher("/jsp/hospital_coordinator/hospital_coordinator_requests.jsp").forward(request, response);
            System.out.println("Forward completed (should not reach here)");
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQLException: " + e.getMessage()); // Debug log
            request.setAttribute("error", "Error fetching requests: " + e.getMessage());
            request.getRequestDispatcher("/jsp/hospital_coordinator/hospital_coordinator_requests.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Unexpected exception: " + e.getMessage()); // Catch any other exceptions
            request.setAttribute("error", "Unexpected error: " + e.getMessage());
            request.getRequestDispatcher("/jsp/hospital_coordinator/hospital_coordinator_requests.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.getRole().equalsIgnoreCase("hospital_coordinator")) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String action = request.getPathInfo();
        BloodRequestDAO requestDAO = new BloodRequestDAO();
        BloodStockDAO stockDAO = new BloodStockDAO();

        try {
            System.out.println("CoordinatorRequestServlet doPost - Action: " + action);
            if ("/approve".equals(action)) {
                int requestId = Integer.parseInt(request.getParameter("request_id"));
                System.out.println("CoordinatorRequestServlet doPost - Approving request ID: " + requestId);
                com.blooddonation.model.BloodRequest bloodRequest = requestDAO.getBloodRequestById(requestId);
                System.out.println("CoordinatorRequestServlet doPost - Blood request found: " + (bloodRequest != null));
                
                if (bloodRequest != null) {
                    // Check if there's enough stock
                    List<BloodStock> availableStock = stockDAO.getBloodStockByGroup(bloodRequest.getBloodGroup());
                    int totalAvailable = availableStock.stream()
                            .mapToInt(BloodStock::getQuantity)
                            .sum();
                    
                    if (totalAvailable >= bloodRequest.getQuantity()) {
                        // Reduce stock quantity
                        int remainingQuantity = bloodRequest.getQuantity();
                        for (BloodStock stock : availableStock) {
                            if (remainingQuantity <= 0) break;
                            
                            if (stock.getQuantity() >= remainingQuantity) {
                                stock.setQuantity(stock.getQuantity() - remainingQuantity);
                                stockDAO.updateBloodStock(stock);
                                remainingQuantity = 0;
                            } else {
                                remainingQuantity -= stock.getQuantity();
                                stock.setQuantity(0);
                                stockDAO.updateBloodStock(stock);
                            }
                        }
                        
                        // Update request status
                        requestDAO.updateBloodRequestStatus(requestId, "APPROVED");
                        response.sendRedirect(request.getContextPath() + "/coordinator-request/?success=approved");
                    } else {
                        request.setAttribute("error", "Insufficient blood stock available");
                        doGet(request, response);
                    }
                } else {
                    request.setAttribute("error", "Blood request not found");
                    doGet(request, response);
                }
            } else if ("/reject".equals(action)) {
                int requestId = Integer.parseInt(request.getParameter("request_id"));
                String reason = request.getParameter("reason");
                requestDAO.updateBloodRequestStatus(requestId, "REJECTED");
                response.sendRedirect(request.getContextPath() + "/coordinator-request/?success=rejected");
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            doGet(request, response);
        }
    }
}