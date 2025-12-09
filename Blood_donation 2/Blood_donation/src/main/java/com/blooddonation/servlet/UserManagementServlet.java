package com.blooddonation.servlet;

import com.blooddonation.dao.UserDAO;
import com.blooddonation.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

public class UserManagementServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !((User) session.getAttribute("user")).getRole().equals("MANAGER")) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        try {
            request.setAttribute("users", userDAO.getAllUsers());
            request.getRequestDispatcher("/jsp/manager/manager_user_management.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving users");
            request.getRequestDispatcher("/jsp/manager/manager_user_management.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !((User) session.getAttribute("user")).getRole().equals("MANAGER")) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String action = request.getPathInfo();
        UserDAO userDAO = new UserDAO();

        try {
            if ("/add".equals(action)) {
                User user = new User();
                user.setUsername(request.getParameter("username"));
                user.setPassword(request.getParameter("password"));
                user.setRole(request.getParameter("role"));
                user.setEmail(request.getParameter("email"));
                user.setPhone(request.getParameter("phone"));
                userDAO.addUser(user);
                response.sendRedirect(request.getContextPath() + "/user-management");
            } else if ("/delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("user_id"));
                userDAO.deleteUser(userId);
                response.sendRedirect(request.getContextPath() + "/user-management");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing user action");
            request.getRequestDispatcher("/jsp/manager/manager_user_management.jsp").forward(request, response);
        }
    }
}