package com.blooddonation.servlet;

import com.blooddonation.dao.UserDAO;
import com.blooddonation.dao.DonorDAO;
import com.blooddonation.dao.HospitalDAO;
import com.blooddonation.model.User;
import com.blooddonation.model.Donor;
import com.blooddonation.model.Hospital;
import com.blooddonation.util.ValidationUtil;
import com.blooddonation.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;

public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get and sanitize input parameters
        String username = ValidationUtil.sanitizeInput(request.getParameter("username"));
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String email = ValidationUtil.sanitizeInput(request.getParameter("email"));
        String phone = ValidationUtil.sanitizeInput(request.getParameter("phone"));
        
        // Additional donor-specific fields
        String name = ValidationUtil.sanitizeInput(request.getParameter("name"));
        String ageStr = request.getParameter("age");
        String gender = request.getParameter("gender");
        String bloodGroup = request.getParameter("bloodGroup");
        String weightStr = request.getParameter("weight");
        String healthInfo = ValidationUtil.sanitizeInput(request.getParameter("health_info"));
        
        // Additional hospital-specific fields
        String hospitalName = ValidationUtil.sanitizeInput(request.getParameter("hospitalName"));
        String hospitalType = request.getParameter("hospitalType");
        String hospitalAddress = ValidationUtil.sanitizeInput(request.getParameter("hospitalAddress"));
        String hospitalCity = ValidationUtil.sanitizeInput(request.getParameter("hospitalCity"));
        String hospitalState = ValidationUtil.sanitizeInput(request.getParameter("hospitalState"));
        String hospitalPostalCode = ValidationUtil.sanitizeInput(request.getParameter("hospitalPostalCode"));
        String contactPerson = ValidationUtil.sanitizeInput(request.getParameter("contactPerson"));
        String contactPhone = ValidationUtil.sanitizeInput(request.getParameter("contactPhone"));
        String contactEmail = ValidationUtil.sanitizeInput(request.getParameter("contactEmail"));
        String licenseNumber = ValidationUtil.sanitizeInput(request.getParameter("licenseNumber"));
        String registrationNumber = ValidationUtil.sanitizeInput(request.getParameter("registrationNumber"));

        // Validation
        StringBuilder errors = new StringBuilder();
        
        if (!ValidationUtil.isValidUsername(username)) {
            errors.append("Username must be 3-20 characters long and contain only letters, numbers, and underscores.<br>");
        }
        
        if (!ValidationUtil.isValidPassword(password)) {
            errors.append("Password must be at least 8 characters long and contain both letters and numbers.<br>");
        }
        
        if (!ValidationUtil.isValidEmail(email)) {
            errors.append("Please enter a valid email address.<br>");
        }
        
        if (!ValidationUtil.isValidPhone(phone)) {
            errors.append("Please enter a valid Sri Lankan phone number (10 digits starting with 0).<br>");
        }
        
        // Donor-specific validation
        if ("DONOR".equals(role)) {
            if (name == null || name.trim().isEmpty()) {
                errors.append("Name is required for donors.<br>");
            }
            if (ageStr == null || ageStr.trim().isEmpty()) {
                errors.append("Age is required for donors.<br>");
            } else {
                try {
                    int age = Integer.parseInt(ageStr);
                    if (age < 18 || age > 65) {
                        errors.append("Age must be between 18 and 65 years for donors.<br>");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Please enter a valid age.<br>");
                }
            }
            if (gender == null || gender.trim().isEmpty()) {
                errors.append("Gender is required for donors.<br>");
            }
            if (bloodGroup == null || bloodGroup.trim().isEmpty()) {
                errors.append("Blood group is required for donors.<br>");
            }
            if (weightStr == null || weightStr.trim().isEmpty()) {
                errors.append("Weight is required for donors.<br>");
            } else {
                try {
                    double weight = Double.parseDouble(weightStr);
                    if (weight < 40.0 || weight > 200.0) {
                        errors.append("Weight must be between 40 and 200 kg for donors.<br>");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Please enter a valid weight.<br>");
                }
            }
        }
        
        // Hospital-specific validation
        if ("HOSPITAL".equals(role)) {
            if (hospitalName == null || hospitalName.trim().isEmpty()) {
                errors.append("Hospital name is required.<br>");
            }
            if (hospitalType == null || hospitalType.trim().isEmpty()) {
                errors.append("Hospital type is required.<br>");
            }
            if (hospitalAddress == null || hospitalAddress.trim().isEmpty()) {
                errors.append("Hospital address is required.<br>");
            }
            if (hospitalCity == null || hospitalCity.trim().isEmpty()) {
                errors.append("Hospital city is required.<br>");
            }
            if (hospitalState == null || hospitalState.trim().isEmpty()) {
                errors.append("Hospital state is required.<br>");
            }
            if (hospitalPostalCode == null || hospitalPostalCode.trim().isEmpty()) {
                errors.append("Hospital postal code is required.<br>");
            }
            if (contactPerson == null || contactPerson.trim().isEmpty()) {
                errors.append("Contact person is required.<br>");
            }
            if (contactPhone == null || contactPhone.trim().isEmpty()) {
                errors.append("Contact phone is required.<br>");
            }
            if (contactEmail == null || contactEmail.trim().isEmpty()) {
                errors.append("Contact email is required.<br>");
            } else if (!ValidationUtil.isValidEmail(contactEmail)) {
                errors.append("Please enter a valid contact email address.<br>");
            }
            if (licenseNumber == null || licenseNumber.trim().isEmpty()) {
                errors.append("License number is required.<br>");
            }
            if (registrationNumber == null || registrationNumber.trim().isEmpty()) {
                errors.append("Registration number is required.<br>");
            }
        }

        // If there are validation errors, return to registration form
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            
            // Check if username already exists
            User existingUser = userDAO.getUserByUsername(username);
            if (existingUser != null) {
                request.setAttribute("error", "Username already exists. Please choose a different username.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            // Check if email already exists
            User existingEmail = userDAO.getUserByEmail(email);
            if (existingEmail != null) {
                request.setAttribute("error", "Email already registered. Please use a different email address.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // Check if phone already exists
            User existingPhone = userDAO.getUserByPhone(phone);
            if (existingPhone != null) {
                request.setAttribute("error", "Phone number already registered. Please use a different phone number.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // Create new user
            User user = new User();
            user.setUsername(username);
            user.setPassword(password); // Don't hash here - will be hashed in addUser
            user.setRole(role);
            user.setEmail(email);
            user.setPhone(phone);
            user.setStatus("ACTIVE"); // Set status to ACTIVE for new users
            user.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            int userId = userDAO.addUser(user);
            user.setId(userId);

            // If donor, create donor profile with validation
            if ("DONOR".equals(role)) {
                DonorDAO donorDAO = new DonorDAO();
                
                int age = Integer.parseInt(ageStr);
                double weight = Double.parseDouble(weightStr);
                
                // Check if donor is eligible
                if (age < 18 || age > 65 || weight < 40.0) {
                    request.setAttribute("error", "You are not eligible to donate due to age or weight criteria.");
                    request.getRequestDispatcher("/register.jsp").forward(request, response);
                    return;
                }
                
                Donor donor = new Donor();
                donor.setUserId(user.getId());
                donor.setName(name);
                donor.setAge(age);
                donor.setGender(gender.toUpperCase());
                donor.setBloodGroup(bloodGroup.toUpperCase());
                donor.setWeight(weight);
                donor.setHealthInfo(healthInfo != null ? healthInfo : "No known issues");
                donor.setStatus("PENDING");
                donor.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                
                donorDAO.addDonor(donor);
            }
            
            // If hospital, create hospital profile
            if ("HOSPITAL".equals(role)) {
                HospitalDAO hospitalDAO = new HospitalDAO();
                
                Hospital hospital = new Hospital();
                hospital.setUserId(user.getId());
                hospital.setHospitalName(hospitalName);
                hospital.setHospitalType(hospitalType.toUpperCase());
                hospital.setAddress(hospitalAddress);
                hospital.setCity(hospitalCity);
                hospital.setState(hospitalState);
                hospital.setPostalCode(hospitalPostalCode);
                hospital.setContactPerson(contactPerson);
                hospital.setContactPhone(contactPhone);
                hospital.setContactEmail(contactEmail);
                hospital.setLicenseNumber(licenseNumber);
                hospital.setRegistrationNumber(registrationNumber);
                hospital.setStatus("PENDING");
                hospital.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                
                hospitalDAO.addHospital(hospital);
            }

            request.setAttribute("success", "Registration successful! Please login to continue.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed due to a database error. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}