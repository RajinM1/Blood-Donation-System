package com.blooddonation.util;

import com.blooddonation.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class SecurityFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Skip security check for public resources
        if (isPublicResource(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        HttpSession session = httpRequest.getSession(false);
        User user = null;
        
        if (session != null) {
            user = (User) session.getAttribute("user");
        }
        
        // Check if user is logged in
        if (user == null) {
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }
        
        // Check if account is active
        if (!PermissionUtil.isAccountActive(user)) {
            System.out.println("DEBUG: User " + user.getUsername() + " has status: " + user.getStatus());
            session.invalidate();
            httpRequest.setAttribute("error", "Your account has been deactivated. Please contact administrator.");
            httpRequest.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Check if user has permission to access the resource
        if (!hasAccessToResource(user, path)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    private boolean isPublicResource(String path) {
        return path.startsWith("/login.jsp") ||
               path.startsWith("/register.jsp") ||
               path.startsWith("/login") ||
               path.startsWith("/register") ||
               path.startsWith("/css/") ||
               path.startsWith("/js/") ||
               path.startsWith("/images/") ||
               path.startsWith("/WEB-INF/") ||
               path.equals("/") ||
               path.equals("/index.jsp") ||
               path.contains("favicon.ico");
    }
    
    private boolean hasAccessToResource(User user, String path) {
        // Map JSP paths to resource names
        String resource = mapPathToResource(path);
        
        if (resource == null) {
            return true; // Allow access to unmapped resources
        }
        
        return PermissionUtil.canAccess(user, resource);
    }
    
    private String mapPathToResource(String path) {
        if (path.startsWith("/jsp/donor/")) {
            if (path.contains("donor_dashboard")) return "donor_dashboard";
            if (path.contains("donor_profile")) return "donor_profile";
            if (path.contains("donor_appointment")) return "donor_appointment";
            if (path.contains("donor_eligibility")) return "donor_eligibility";
            if (path.contains("donor_summary")) return "donor_summary";
            if (path.contains("donor_donation_history")) return "donor_donation_history";
            if (path.contains("donor_feedback")) return "donor_feedback";
            if (path.contains("donor_notifications")) return "donor_notifications";
        }
        
        if (path.startsWith("/jsp/hospital/")) {
            if (path.contains("hospital_dashboard")) return "hospital_dashboard";
            if (path.contains("hospital_blood_request")) return "hospital_blood_request";
            if (path.contains("hospital_request_history")) return "hospital_request_history";
            if (path.contains("hospital_feedback")) return "hospital_feedback";
        }
        
        if (path.startsWith("/jsp/donor_relation/")) {
            if (path.contains("donor_relation_dashboard")) return "donor_relation_dashboard";
            if (path.contains("donor_relation_communication")) return "donor_relation_communication";
            if (path.contains("donor_relation_camp_management")) return "donor_relation_camp_management";
        }
        
        if (path.startsWith("/jsp/manager/")) {
            if (path.contains("manager_dashboard")) return "manager_dashboard";
            if (path.contains("manager_reports")) return "manager_reports";
            if (path.contains("manager_user_management")) return "manager_user_management";
            if (path.contains("manager_inventory")) return "manager_inventory";
        }
        
        if (path.startsWith("/jsp/medical/")) {
            if (path.contains("medical_dashboard")) return "medical_dashboard";
            if (path.contains("medical_blood_report")) return "medical_blood_report";
            if (path.contains("medical_donor_details")) return "medical_donor_details";
        }
        
        if (path.startsWith("/jsp/hospital_coordinator/")) {
            if (path.contains("hospital_coordinator_dashboard")) return "hospital_coordinator_dashboard";
            if (path.contains("hospital_coordinator_requests")) return "hospital_coordinator_requests";
            if (path.contains("hospital_coordinator_stock")) return "hospital_coordinator_stock";
        }
        
        return null;
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}




