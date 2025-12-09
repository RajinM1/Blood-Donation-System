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

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserByUsernameAndPassword(username, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                switch (user.getRole()) {
                    case "MANAGER":
                        response.sendRedirect("dashboard?role=manager");
                        break;
                    case "DONOR":
                        response.sendRedirect("dashboard?role=donor");
                        break;
                    case "MEDICAL_STAFF":
                        response.sendRedirect("dashboard?role=medical");
                        break;
                    case "DONOR_RELATION":
                        response.sendRedirect("dashboard?role=donor_relation");
                        break;
                    case "HOSPITAL_COORDINATOR":
                        response.sendRedirect("dashboard?role=hospital_coordinator");
                        break;
                    case "HOSPITAL":
                        response.sendRedirect("dashboard?role=hospital");
                        break;
                    default:
                        request.setAttribute("error", "Invalid role");
                        request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}