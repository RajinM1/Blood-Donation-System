package com.blooddonation.servlet;

import com.blooddonation.model.User;
import com.blooddonation.service.AlertService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class AlertsServlet extends HttpServlet {
    private final AlertService alertService = new AlertService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"MANAGER".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String action = request.getPathInfo();
        
        try {
            if (action == null || action.equals("/")) {
                // Show all alerts
                List<Map<String, Object>> allAlerts = alertService.getAllAlerts();
                request.setAttribute("alerts", allAlerts);
                request.setAttribute("title", "All Alerts");
                request.getRequestDispatcher("/jsp/manager/manager_alerts.jsp").forward(request, response);
                
            } else if (action.equals("/active")) {
                // Show active alerts
                List<Map<String, Object>> activeAlerts = alertService.getActiveAlerts();
                request.setAttribute("alerts", activeAlerts);
                request.setAttribute("title", "Active Alerts");
                request.getRequestDispatcher("/jsp/manager/manager_alerts.jsp").forward(request, response);
                
            } else if (action.equals("/urgent")) {
                // Show critical alerts
                List<Map<String, Object>> criticalAlerts = alertService.getCriticalAlerts();
                request.setAttribute("alerts", criticalAlerts);
                request.setAttribute("title", "Urgent Alerts");
                request.getRequestDispatcher("/jsp/manager/manager_alerts.jsp").forward(request, response);
                
            } else if (action.equals("/resolved")) {
                // Show resolved alerts
                List<Map<String, Object>> resolvedAlerts = alertService.getResolvedAlerts();
                request.setAttribute("alerts", resolvedAlerts);
                request.setAttribute("title", "Resolved Alerts");
                request.getRequestDispatcher("/jsp/manager/manager_alerts.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving alerts: " + e.getMessage());
            request.getRequestDispatcher("/jsp/manager/manager_alerts.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"MANAGER".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String action = request.getPathInfo();
        
        try {
            if (action.equals("/resolve")) {
                // Resolve alert
                int alertId = Integer.parseInt(request.getParameter("alert_id"));
                String resolution = request.getParameter("resolution");
                
                // Validate resolution length
                if (resolution != null && resolution.length() > 255) {
                    request.setAttribute("error", "Resolution text is too long. Maximum 255 characters allowed.");
                    request.getRequestDispatcher("/jsp/manager/manager_alerts.jsp").forward(request, response);
                    return;
                }
                
                alertService.resolveAlert(alertId, user.getId(), resolution);
                response.sendRedirect(request.getContextPath() + "/alerts?success=resolved");
                
            } else if (action.equals("/dismiss")) {
                // Dismiss alert
                int alertId = Integer.parseInt(request.getParameter("alert_id"));
                alertService.dismissAlert(alertId, user.getId());
                response.sendRedirect(request.getContextPath() + "/alerts?success=dismissed");
                
            } else if (action.equals("/create")) {
                // Create new alert
                String title = request.getParameter("title");
                String message = request.getParameter("message");
                String priority = request.getParameter("priority");
                String type = request.getParameter("type");
                
                alertService.createAlert(title, message, priority, type, user.getId());
                response.sendRedirect(request.getContextPath() + "/alerts?success=created");
                
            } else if (action.equals("/sendmail")) {
                // Send mail for alert
                int alertId = Integer.parseInt(request.getParameter("alert_id"));
                try {
                    boolean emailSent = alertService.sendAlertEmail(alertId, user.getId());
                    if (emailSent) {
                        response.sendRedirect(request.getContextPath() + "/alerts?success=mailsent");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/alerts?success=mailsimulated");
                    }
                } catch (Exception e) {
                    System.err.println("Email sending error: " + e.getMessage());
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/alerts?error=emailfailed");
                }
            }
            
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing alert: " + e.getMessage());
            request.getRequestDispatcher("/jsp/manager/manager_alerts.jsp").forward(request, response);
        }
    }
}

