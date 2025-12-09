package com.blooddonation.servlet;

import com.blooddonation.dao.NotificationDAO;
import com.blooddonation.dao.UserDAO;
import com.blooddonation.model.Notification;
import com.blooddonation.model.User;
import com.blooddonation.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;

public class NotificationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        NotificationDAO notificationDAO = new NotificationDAO();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in first");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.getRole().equalsIgnoreCase("donor_relation")) {
            request.setAttribute("error", "Unauthorized access");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            if ("/send".equals(action)) {
                Notification notification = new Notification();
                notification.setDonorId(Integer.parseInt(request.getParameter("user_id")));
                notification.setMessage(request.getParameter("message"));
                notification.setType("SYSTEM");
                notification.setChannel("IN_APP");
                notification.setPriority("MEDIUM");
                notification.setRead(false);
                notification.setCreatedAt(new Date()); // Set createdAt instead of sentDate
                notificationDAO.addNotification(notification);

                // Send email notification
                User targetUser = new UserDAO().getUserById(notification.getDonorId());
                if (targetUser != null) {
                    try {
                        EmailUtil.sendEmail(targetUser.getEmail(), "Blood Donation Notification", notification.getMessage());
                    } catch (Exception e) {
                        request.setAttribute("error", "Failed to send email notification");
                        request.getRequestDispatcher("/jsp/donor_relation/donor_relation_communication.jsp").forward(request, response);
                        return;
                    }
                } else {
                    request.setAttribute("error", "Target user not found");
                    request.getRequestDispatcher("/jsp/donor_relation/donor_relation_communication.jsp").forward(request, response);
                    return;
                }

                response.sendRedirect(request.getContextPath() + "/jsp/donor_relation/donor_relation_communication.jsp");
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing notification");
            request.getRequestDispatcher("/jsp/donor_relation/donor_relation_communication.jsp").forward(request, response);
        }
    }
}