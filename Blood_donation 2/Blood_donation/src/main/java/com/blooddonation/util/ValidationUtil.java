package com.blooddonation.util;

import java.util.regex.Pattern;
import java.util.Date;
import java.util.Calendar;

public class ValidationUtil {
    
    // Email validation pattern
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
    );
    
    // Phone validation pattern (Sri Lankan format)
    private static final Pattern PHONE_PATTERN = Pattern.compile(
        "^0[0-9]{9}$"
    );
    
    // Blood group validation
    private static final String[] VALID_BLOOD_GROUPS = {
        "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"
    };
    
    // Gender validation
    private static final String[] VALID_GENDERS = {
        "MALE", "FEMALE", "OTHER"
    };
    
    // Urgency levels
    private static final String[] VALID_URGENCY_LEVELS = {
        "LOW", "MEDIUM", "HIGH", "CRITICAL"
    };
    
    /**
     * Validates email format
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }
    
    /**
     * Validates phone number format (Sri Lankan)
     * Accepts 10 digits starting with 0
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        return PHONE_PATTERN.matcher(phone.trim()).matches();
    }
    
    /**
     * Validates blood group
     */
    public static boolean isValidBloodGroup(String bloodGroup) {
        if (bloodGroup == null || bloodGroup.trim().isEmpty()) {
            return false;
        }
        for (String validGroup : VALID_BLOOD_GROUPS) {
            if (validGroup.equals(bloodGroup.trim().toUpperCase())) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Validates gender
     */
    public static boolean isValidGender(String gender) {
        if (gender == null || gender.trim().isEmpty()) {
            return false;
        }
        for (String validGender : VALID_GENDERS) {
            if (validGender.equals(gender.trim().toUpperCase())) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Validates urgency level
     */
    public static boolean isValidUrgency(String urgency) {
        if (urgency == null || urgency.trim().isEmpty()) {
            return false;
        }
        for (String validUrgency : VALID_URGENCY_LEVELS) {
            if (validUrgency.equals(urgency.trim().toUpperCase())) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Validates age (must be between 18 and 65)
     */
    public static boolean isValidAge(int age) {
        return age >= 18 && age <= 65;
    }
    
    /**
     * Validates weight (must be at least 40kg for donation eligibility)
     */
    public static boolean isValidWeight(double weight) {
        return weight >= 40.0;
    }
    
    /**
     * Validates quantity (must be positive)
     */
    public static boolean isValidQuantity(int quantity) {
        return quantity > 0;
    }
    
    /**
     * Validates if donor is eligible based on last donation date
     */
    public static boolean isEligibleForDonation(Date lastDonationDate) {
        if (lastDonationDate == null) {
            return true; // First time donor
        }
        
        Calendar cal = Calendar.getInstance();
        cal.setTime(lastDonationDate);
        cal.add(Calendar.DAY_OF_MONTH, 90); // 3 months
        
        return cal.getTime().before(new Date());
    }
    
    /**
     * Validates if appointment date is in the future
     */
    public static boolean isValidAppointmentDate(Date appointmentDate) {
        if (appointmentDate == null) {
            return false;
        }
        return appointmentDate.after(new Date());
    }
    
    /**
     * Validates if blood unit is expired
     */
    public static boolean isBloodExpired(Date expiryDate) {
        if (expiryDate == null) {
            return false;
        }
        return expiryDate.before(new Date());
    }
    
    /**
     * Validates if blood unit is expiring within specified days
     */
    public static boolean isBloodExpiringSoon(Date expiryDate, int days) {
        if (expiryDate == null) {
            return false;
        }
        
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, days);
        
        return expiryDate.before(cal.getTime());
    }
    
    /**
     * Validates username (alphanumeric, 3-20 characters)
     */
    public static boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        String trimmed = username.trim();
        return trimmed.length() >= 3 && trimmed.length() <= 20 && 
               trimmed.matches("^[a-zA-Z0-9_]+$");
    }
    
    /**
     * Validates password (at least 8 characters, contains letter and number)
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        return password.matches(".*[a-zA-Z].*") && password.matches(".*[0-9].*");
    }
    
    /**
     * Sanitizes input string to prevent XSS
     */
    public static String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        return input.trim()
                   .replaceAll("<", "&lt;")
                   .replaceAll(">", "&gt;")
                   .replaceAll("\"", "&quot;")
                   .replaceAll("'", "&#x27;")
                   .replaceAll("/", "&#x2F;");
    }
}

