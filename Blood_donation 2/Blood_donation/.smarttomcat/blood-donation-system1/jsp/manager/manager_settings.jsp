<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Blood Donation System - System Settings</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #e74c3c;
            --primary-dark: #c0392b;
            --text-dark: #2c3e50;
            --text-light: #7f8c8d;
            --background: #f9f9f9;
            --white: #ffffff;
            --border: #ecf0f1;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --success: #27ae60;
            --warning: #f39c12;
            --danger: #e74c3c;
            --info: #3498db;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background-color: var(--background);
            color: var(--text-dark);
            line-height: 1.6;
        }

        header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            padding: 1.2rem 2rem;
            box-shadow: var(--shadow);
        }

        nav {
            background-color: var(--white);
            padding: 0.9rem 2rem;
            display: flex;
            gap: 1.5rem;
            box-shadow: var(--shadow);
        }

        nav a {
            color: var(--text-dark);
            text-decoration: none;
            font-weight: 500;
            padding: 0.3rem 0;
            position: relative;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        nav a:hover {
            color: var(--primary);
        }

        nav a.active {
            color: var(--primary);
        }

        nav a.active:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background-color: var(--primary);
        }

        .container {
            padding: 2rem;
            max-width: 1000px;
            margin: 0 auto;
        }

        .alert {
            padding: 0.8rem 1rem;
            margin: 1rem 0;
            border-radius: 4px;
            background-color: #fdecea;
            color: var(--primary-dark);
            border-left: 4px solid var(--primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert.success {
            background-color: #d4edda;
            color: #155724;
            border-left-color: var(--success);
        }

        .alert.error {
            background-color: #f8d7da;
            color: #721c24;
            border-left-color: var(--danger);
        }

        .settings-form {
            background: var(--white);
            border-radius: 8px;
            box-shadow: var(--shadow);
            padding: 2rem;
            margin: 1rem 0;
        }

        .form-section {
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid var(--border);
        }

        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .form-section h3 {
            color: var(--primary);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text-dark);
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 0.9rem;
            transition: border-color 0.2s;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(231, 76, 60, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-group .help-text {
            font-size: 0.8rem;
            color: var(--text-light);
            margin-top: 0.25rem;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .checkbox-group input[type="checkbox"] {
            width: auto;
            margin: 0;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid var(--border);
        }

        .btn {
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s;
        }

        .btn-primary {
            background-color: var(--primary);
            color: var(--white);
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
        }

        .btn-secondary {
            background-color: var(--text-light);
            color: var(--white);
        }

        .btn-secondary:hover {
            background-color: #6c757d;
        }

        .btn-warning {
            background-color: var(--warning);
            color: var(--white);
        }

        .btn-warning:hover {
            background-color: #e67e22;
        }

        .settings-preview {
            background: #f8f9fa;
            border: 1px solid var(--border);
            border-radius: 4px;
            padding: 1rem;
            margin-top: 1rem;
        }

        .settings-preview h4 {
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .settings-preview p {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1><i class="fas fa-cog"></i> System Settings</h1>
    </header>
    <nav>
        <a href="${pageContext.request.contextPath}/dashboard?role=manager">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/user-management">
            <i class="fas fa-users-cog"></i> User Management
        </a>
        <a href="${pageContext.request.contextPath}/stock">
            <i class="fas fa-warehouse"></i> Inventory
        </a>
        <a href="${pageContext.request.contextPath}/reports">
            <i class="fas fa-chart-bar"></i> Reports
        </a>
        <a href="${pageContext.request.contextPath}/settings" class="active">
            <i class="fas fa-cog"></i> Settings
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
    <div class="container">
        <h2><i class="fas fa-cog"></i> System Configuration</h2>
        
        <c:if test="${not empty error}">
            <div class="alert error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert success">
                <i class="fas fa-check-circle"></i> Settings ${success} successfully!
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/settings">
            <div class="settings-form">
                <!-- System Information -->
                <div class="form-section">
                    <h3><i class="fas fa-info-circle"></i> System Information</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="system_name">System Name</label>
                            <input type="text" id="system_name" name="system_name" 
                                   value="${settings.system_name}" required>
                            <div class="help-text">The name displayed throughout the system</div>
                        </div>
                        <div class="form-group">
                            <label for="system_email">System Email</label>
                            <input type="email" id="system_email" name="system_email" 
                                   value="${settings.system_email}" required>
                            <div class="help-text">Contact email for system notifications</div>
                        </div>
<div class="form-group">
    <label for="system_phone">System Phone</label>
    <input type="tel" id="system_phone" name="system_phone"
           value="${settings.system_phone}"
           pattern="^0[0-9]{9}$"
           required
           title="Enter a valid Sri Lankan phone number (must start with 0 and be 10 digits)">
    <div class="help-text">Contact phone number for the system (e.g., 0712345678)</div>
</div>

                    </div>
                </div>

                <!-- Donation Rules -->
                <div class="form-section">
                    <h3><i class="fas fa-heart"></i> Donation Rules</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="min_donation_age">Minimum Donation Age</label>
                            <input type="number" id="min_donation_age" name="min_donation_age" 
                                   value="${settings.min_donation_age}" min="16" max="100" required>
                            <div class="help-text">Minimum age required to donate blood</div>
                        </div>
                        <div class="form-group">
                            <label for="max_donation_age">Maximum Donation Age</label>
                            <input type="number" id="max_donation_age" name="max_donation_age" 
                                   value="${settings.max_donation_age}" min="16" max="100" required>
                            <div class="help-text">Maximum age allowed to donate blood</div>
                        </div>
                        <div class="form-group">
                            <label for="min_donation_weight">Minimum Weight (kg)</label>
                            <input type="number" id="min_donation_weight" name="min_donation_weight" 
                                   value="${settings.min_donation_weight}" min="40" max="200" step="0.1" required>
                            <div class="help-text">Minimum weight required to donate blood</div>
                        </div>
                        <div class="form-group">
                            <label for="donation_interval">Donation Interval (days)</label>
                            <input type="number" id="donation_interval" name="donation_interval" 
                                   value="${settings.donation_interval}" min="1" max="365" required>
                            <div class="help-text">Minimum days between donations</div>
                        </div>
                    </div>
                </div>

                <!-- Blood Management -->
                <div class="form-section">
                    <h3><i class="fas fa-tint"></i> Blood Management</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="blood_expiry_days">Blood Expiry Days</label>
                            <input type="number" id="blood_expiry_days" name="blood_expiry_days" 
                                   value="${settings.blood_expiry_days}" min="1" max="365" required>
                            <div class="help-text">Number of days before blood units expire</div>
                        </div>
                        <div class="form-group">
                            <label for="low_stock_threshold">Low Stock Threshold</label>
                            <input type="number" id="low_stock_threshold" name="low_stock_threshold" 
                                   value="${settings.low_stock_threshold}" min="1" max="1000" required>
                            <div class="help-text">Minimum units before low stock alert</div>
                        </div>
                    </div>
                </div>

                <!-- Notifications -->
                <div class="form-section">
                    <h3><i class="fas fa-bell"></i> Notifications</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <div class="checkbox-group">
                                <input type="checkbox" id="email_notifications" name="email_notifications" 
                                       value="true" ${settings.email_notifications == 'true' ? 'checked' : ''}>
                                <label for="email_notifications">Enable Email Notifications</label>
                            </div>
                            <div class="help-text">Send notifications via email</div>
                        </div>
                        <div class="form-group">
                            <div class="checkbox-group">
                                <input type="checkbox" id="sms_notifications" name="sms_notifications" 
                                       value="true" ${settings.sms_notifications == 'true' ? 'checked' : ''}>
                                <label for="sms_notifications">Enable SMS Notifications</label>
                            </div>
                            <div class="help-text">Send notifications via SMS</div>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/settings/reset" 
                       class="btn btn-warning" 
                       onclick="return confirm('Are you sure you want to reset all settings to default values?')">
                        <i class="fas fa-undo"></i> Reset to Defaults
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Save Settings
                    </button>
                </div>
            </div>
        </form>

        <!-- Settings Preview -->
        <div class="settings-preview">
            <h4><i class="fas fa-eye"></i> Current Settings Preview</h4>
            <p><strong>System:</strong> ${settings.system_name} | <strong>Email:</strong> ${settings.system_email}</p>
            <p><strong>Donation Rules:</strong> Age ${settings.min_donation_age}-${settings.max_donation_age}, 
               Weight ≥${settings.min_donation_weight}kg, Interval ${settings.donation_interval} days</p>
            <p><strong>Blood Management:</strong> Expires in ${settings.blood_expiry_days} days, 
               Low stock alert at ${settings.low_stock_threshold} units</p>
        </div>
    </div>

    <script>
        // Prevent back button access after logout
        window.history.pushState(null, null, window.location.href);
        window.onpopstate = function(event) {
            window.history.pushState(null, null, window.location.href);
        };

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const minAge = parseInt(document.getElementById('min_donation_age').value);
            const maxAge = parseInt(document.getElementById('max_donation_age').value);
            
            if (minAge >= maxAge) {
                e.preventDefault();
                alert('Minimum age must be less than maximum age');
                return false;
            }
        });
    </script>
</body>
</html>



