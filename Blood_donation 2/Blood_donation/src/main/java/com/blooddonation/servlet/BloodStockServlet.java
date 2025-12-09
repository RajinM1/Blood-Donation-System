package com.blooddonation.servlet;

import com.blooddonation.dao.BloodStockDAO;
import com.blooddonation.model.BloodStock;
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

public class BloodStockServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        System.out.println("User role in GET: " + (user != null ? user.getRole() : "null"));
        if (session == null || user == null || !user.getRole().equals("MANAGER")) {
            request.setAttribute("error", "Unauthorized access. Role: " + (user != null ? user.getRole() : "null"));
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        BloodStockDAO stockDAO = new BloodStockDAO();
        try {
            request.setAttribute("stocks", stockDAO.getAllBloodStock());
            request.getRequestDispatcher("/jsp/manager/manager_inventory.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving inventory");
            request.getRequestDispatcher("/jsp/manager/manager_inventory.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        System.out.println("User role in POST: " + (user != null ? user.getRole() : "null") + ", Action: " + request.getPathInfo());
        if (session == null || user == null) {
            request.setAttribute("error", "Unauthorized access. No session or user.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String action = request.getPathInfo();
        BloodStockDAO stockDAO = new BloodStockDAO();

        try {
            if ("/add".equals(action)) {
                if (!user.getRole().equals("HOSPITAL_COORDINATOR")) {
                    request.setAttribute("error", "Unauthorized access. Only hospital coordinators can add stock. Role: " + user.getRole());
                    request.getRequestDispatcher("/jsp/hospital_coordinator/hospital_coordinator_stock.jsp").forward(request, response);
                    return;
                }
                BloodStock stock = new BloodStock();
                stock.setBloodGroup(request.getParameter("blood_group"));
                stock.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                stock.setExpiryDate(new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("expiry_date")));
                stockDAO.addBloodStock(stock);
                response.sendRedirect(request.getContextPath() + "/stock");
            }
        } catch (SQLException | ParseException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error adding blood stock: " + e.getMessage());
            request.getRequestDispatcher("/jsp/hospital_coordinator/hospital_coordinator_stock.jsp").forward(request, response);
        }
    }
}