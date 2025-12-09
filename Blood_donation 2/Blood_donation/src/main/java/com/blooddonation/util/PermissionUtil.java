package com.blooddonation.util;

import com.blooddonation.model.User;
import java.util.Set;
import java.util.HashSet;

public class PermissionUtil {
    
    // Role-based permissions mapping
    private static final Set<String> DONOR_PERMISSIONS = Set.of(
        "VIEW_PROFILE", "UPDATE_PROFILE", "VIEW_APPOINTMENTS", "BOOK_APPOINTMENT", 
        "CANCEL_APPOINTMENT", "VIEW_DONATION_HISTORY", "SUBMIT_FEEDBACK", 
        "VIEW_ELIGIBILITY", "VIEW_SUMMARY", "SUBMIT_BLOOD_REPORT"
    );
    
    private static final Set<String> HOSPITAL_PERMISSIONS = Set.of(
        "VIEW_PROFILE", "UPDATE_PROFILE", "SUBMIT_BLOOD_REQUEST", "VIEW_REQUEST_HISTORY",
        "SUBMIT_FEEDBACK", "VIEW_NOTIFICATIONS"
    );
    
    private static final Set<String> OFFICER_PERMISSIONS = Set.of(
        "VIEW_DONOR_PROFILES", "APPROVE_APPOINTMENTS", "REJECT_APPOINTMENTS", 
        "VIEW_FEEDBACK", "RESPOND_FEEDBACK", "ESCALATE_FEEDBACK", "VIEW_ALERTS",
        "MANAGE_DONATION_CAMPS", "VIEW_STOCK_LEVELS"
    );
    
    private static final Set<String> MANAGER_PERMISSIONS = Set.of(
        "VIEW_ALL_USERS", "MANAGE_USERS", "APPROVE_BLOOD_REQUESTS", "REJECT_BLOOD_REQUESTS",
        "VIEW_REPORTS", "MANAGE_STOCK", "RESOLVE_FEEDBACK", "VIEW_ALERTS",
        "MANAGE_DONATION_CAMPS", "VIEW_AUDIT_LOGS", "MANAGE_SYSTEM_SETTINGS"
    );
    
    private static final Set<String> MEDICAL_PERMISSIONS = Set.of(
        "VIEW_DONOR_DETAILS", "APPROVE_BLOOD_REPORTS", "REJECT_BLOOD_REPORTS",
        "VIEW_MEDICAL_HISTORY", "UPDATE_DONOR_STATUS"
    );
    
    private static final Set<String> HOSPITAL_COORDINATOR_PERMISSIONS = Set.of(
        "VIEW_BLOOD_REQUESTS", "MANAGE_DELIVERIES", "UPDATE_REQUEST_STATUS",
        "VIEW_STOCK_LEVELS", "COORDINATE_WITH_HOSPITALS"
    );
    
    /**
     * Check if user has specific permission
     */
    public static boolean hasPermission(User user, String permission) {
        if (user == null || permission == null) {
            return false;
        }
        
        // Check if user account is active
        if (!isAccountActive(user)) {
            return false;
        }
        
        Set<String> userPermissions = getUserPermissions(user.getRole());
        return userPermissions.contains(permission);
    }
    
    /**
     * Check if user can access specific resource
     */
    public static boolean canAccess(User user, String resource) {
        if (user == null || resource == null) {
            return false;
        }
        
        if (!isAccountActive(user)) {
            return false;
        }
        
        String role = user.getRole();
        
        switch (resource) {
            case "donor_dashboard":
            case "donor_profile":
            case "donor_appointment":
            case "donor_eligibility":
            case "donor_summary":
                return "DONOR".equals(role);
                
            case "hospital_dashboard":
            case "hospital_blood_request":
                return "HOSPITAL".equals(role);
                
            case "donor_relation_dashboard":
            case "donor_relation_communication":
                return "DONOR_RELATION".equals(role) || "OFFICER".equals(role);
                
            case "manager_dashboard":
            case "manager_reports":
            case "manager_user_management":
                return "MANAGER".equals(role);
                
            case "medical_dashboard":
            case "medical_blood_report":
                return "MEDICAL".equals(role);
                
            case "hospital_coordinator_dashboard":
            case "hospital_coordinator_requests":
                return "HOSPITAL_COORDINATOR".equals(role);
                
            default:
                return false;
        }
    }
    
    /**
     * Get all permissions for a role
     */
    public static Set<String> getUserPermissions(String role) {
        if (role == null) {
            return new HashSet<>();
        }
        
        switch (role.toUpperCase()) {
            case "DONOR":
                return DONOR_PERMISSIONS;
            case "HOSPITAL":
                return HOSPITAL_PERMISSIONS;
            case "OFFICER":
            case "DONOR_RELATION":
                return OFFICER_PERMISSIONS;
            case "MANAGER":
                return MANAGER_PERMISSIONS;
            case "MEDICAL":
                return MEDICAL_PERMISSIONS;
            case "HOSPITAL_COORDINATOR":
                return HOSPITAL_COORDINATOR_PERMISSIONS;
            default:
                return new HashSet<>();
        }
    }
    
    /**
     * Check if account is active
     */
    public static boolean isAccountActive(User user) {
        if (user == null) {
            return false;
        }
        
        String status = user.getStatus();
        return status != null && "ACTIVE".equals(status);
    }
    
    /**
     * Check if user can perform action on resource
     */
    public static boolean canPerformAction(User user, String action, String resource) {
        if (!canAccess(user, resource)) {
            return false;
        }
        
        // Map actions to permissions
        String permission = mapActionToPermission(action, resource);
        return hasPermission(user, permission);
    }
    
    private static String mapActionToPermission(String action, String resource) {
        switch (action) {
            case "create":
            case "add":
                return "CREATE_" + resource.toUpperCase();
            case "read":
            case "view":
                return "VIEW_" + resource.toUpperCase();
            case "update":
            case "edit":
                return "UPDATE_" + resource.toUpperCase();
            case "delete":
            case "remove":
                return "DELETE_" + resource.toUpperCase();
            case "approve":
                return "APPROVE_" + resource.toUpperCase();
            case "reject":
                return "REJECT_" + resource.toUpperCase();
            default:
                return action.toUpperCase();
        }
    }
    
    /**
     * Get accessible pages for user role
     */
    public static Set<String> getAccessiblePages(String role) {
        Set<String> pages = new HashSet<>();
        
        if (role == null) {
            return pages;
        }
        
        switch (role.toUpperCase()) {
            case "DONOR":
                pages.add("donor_dashboard");
                pages.add("donor_profile");
                pages.add("donor_appointment");
                pages.add("donor_eligibility");
                pages.add("donor_summary");
                pages.add("donor_donation_history");
                pages.add("donor_feedback");
                pages.add("donor_notifications");
                break;
                
            case "HOSPITAL":
                pages.add("hospital_dashboard");
                pages.add("hospital_blood_request");
                pages.add("hospital_request_history");
                pages.add("hospital_feedback");
                break;
                
            case "DONOR_RELATION":
            case "OFFICER":
                pages.add("donor_relation_dashboard");
                pages.add("donor_relation_communication");
                pages.add("donor_relation_camp_management");
                break;
                
            case "MANAGER":
                pages.add("manager_dashboard");
                pages.add("manager_reports");
                pages.add("manager_user_management");
                pages.add("manager_inventory");
                break;
                
            case "MEDICAL":
                pages.add("medical_dashboard");
                pages.add("medical_blood_report");
                pages.add("medical_donor_details");
                break;
                
            case "HOSPITAL_COORDINATOR":
                pages.add("hospital_coordinator_dashboard");
                pages.add("hospital_coordinator_requests");
                pages.add("hospital_coordinator_stock");
                break;
        }
        
        return pages;
    }
}
