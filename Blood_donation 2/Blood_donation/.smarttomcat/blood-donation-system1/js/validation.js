// Form validation utilities
class FormValidator {
    constructor() {
        this.rules = {};
        this.messages = {};
    }

    addRule(fieldName, rule, message) {
        if (!this.rules[fieldName]) {
            this.rules[fieldName] = [];
            this.messages[fieldName] = [];
        }
        this.rules[fieldName].push(rule);
        this.messages[fieldName].push(message);
    }

    validate(form) {
        let isValid = true;
        const errors = {};

        // Clear previous errors
        this.clearErrors(form);

        Object.keys(this.rules).forEach(fieldName => {
            const field = form.querySelector(`[name="${fieldName}"]`);
            if (!field) return;

            const value = field.value.trim();
            const fieldRules = this.rules[fieldName];
            const fieldMessages = this.messages[fieldName];

            fieldRules.forEach((rule, index) => {
                if (!rule(value)) {
                    isValid = false;
                    if (!errors[fieldName]) {
                        errors[fieldName] = [];
                    }
                    errors[fieldName].push(fieldMessages[index]);
                }
            });
        });

        // Display errors
        this.displayErrors(form, errors);
        return isValid;
    }

    clearErrors(form) {
        const errorElements = form.querySelectorAll('.field-error');
        errorElements.forEach(element => element.remove());

        const fields = form.querySelectorAll('input, select, textarea');
        fields.forEach(field => {
            field.style.borderColor = '';
            field.classList.remove('error');
        });
    }

    displayErrors(form, errors) {
        Object.keys(errors).forEach(fieldName => {
            const field = form.querySelector(`[name="${fieldName}"]`);
            if (!field) return;

            field.style.borderColor = '#e74c3c';
            field.classList.add('error');

            const errorDiv = document.createElement('div');
            errorDiv.className = 'field-error';
            errorDiv.style.color = '#e74c3c';
            errorDiv.style.fontSize = '0.875rem';
            errorDiv.style.marginTop = '0.25rem';
            errorDiv.textContent = errors[fieldName][0]; // Show first error

            field.parentNode.appendChild(errorDiv);
        });
    }
}

// Common validation rules
const ValidationRules = {
    required: (value) => value.length > 0,
    minLength: (min) => (value) => value.length >= min,
    maxLength: (max) => (value) => value.length <= max,
    email: (value) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value),
    phone: (value) => /^[\+]?[0-9\s\-\(\)]{10,}$/.test(value),
    numeric: (value) => /^\d+$/.test(value),
    positiveNumber: (value) => parseFloat(value) > 0,
    age: (value) => {
        const age = parseInt(value);
        return age >= 18 && age <= 100;
    },
    bloodGroup: (value) => {
        const validGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
        return validGroups.includes(value);
    },
    password: (value) => {
        // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
        return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$/.test(value);
    }
};

// Specific form validators
const LoginValidator = new FormValidator();
LoginValidator.addRule('username', ValidationRules.required, 'Username is required');
LoginValidator.addRule('password', ValidationRules.required, 'Password is required');

const RegistrationValidator = new FormValidator();
RegistrationValidator.addRule('username', ValidationRules.required, 'Username is required');
RegistrationValidator.addRule('username', ValidationRules.minLength(3), 'Username must be at least 3 characters');
RegistrationValidator.addRule('password', ValidationRules.required, 'Password is required');
RegistrationValidator.addRule('password', ValidationRules.password, 'Password must be at least 8 characters with uppercase, lowercase, and number');
RegistrationValidator.addRule('email', ValidationRules.required, 'Email is required');
RegistrationValidator.addRule('email', ValidationRules.email, 'Please enter a valid email address');
RegistrationValidator.addRule('phone', ValidationRules.required, 'Phone number is required');
RegistrationValidator.addRule('phone', ValidationRules.phone, 'Please enter a valid phone number');
RegistrationValidator.addRule('role', ValidationRules.required, 'Please select a role');

const BloodRequestValidator = new FormValidator();
BloodRequestValidator.addRule('blood_group', ValidationRules.required, 'Blood group is required');
BloodRequestValidator.addRule('blood_group', ValidationRules.bloodGroup, 'Please select a valid blood group');
BloodRequestValidator.addRule('quantity', ValidationRules.required, 'Quantity is required');
BloodRequestValidator.addRule('quantity', ValidationRules.positiveNumber, 'Quantity must be a positive number');
BloodRequestValidator.addRule('urgency', ValidationRules.required, 'Please select urgency level');

const DonorProfileValidator = new FormValidator();
DonorProfileValidator.addRule('name', ValidationRules.required, 'Name is required');
DonorProfileValidator.addRule('age', ValidationRules.required, 'Age is required');
DonorProfileValidator.addRule('age', ValidationRules.age, 'Age must be between 18 and 100');
DonorProfileValidator.addRule('gender', ValidationRules.required, 'Please select gender');
DonorProfileValidator.addRule('blood_group', ValidationRules.required, 'Blood group is required');
DonorProfileValidator.addRule('blood_group', ValidationRules.bloodGroup, 'Please select a valid blood group');

// Global validation functions
function validateLoginForm() {
    const form = document.querySelector('form[action*="login"]');
    return LoginValidator.validate(form);
}

function validateRegistrationForm() {
    const form = document.querySelector('form[action*="register"]');
    return RegistrationValidator.validate(form);
}

function validateBloodRequestForm() {
    // Try to target the hospital blood request form reliably
    const form =
        document.querySelector('form[action*="/request/submit"]') ||
        document.querySelector('form[action*="blood-request"]') ||
        document.querySelector('form');
    return BloodRequestValidator.validate(form);
}

function validateDonorProfileForm() {
    const form = document.querySelector('form[action*="donor"]');
    return DonorProfileValidator.validate(form);
}

// Real-time validation
function setupRealTimeValidation() {
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        const inputs = form.querySelectorAll('input, select, textarea');
        inputs.forEach(input => {
            input.addEventListener('blur', () => {
                validateField(input);
            });
        });
    });
}

function validateField(field) {
    const fieldName = field.name;
    const value = field.value.trim();
    
    // Clear previous error
    const errorDiv = field.parentNode.querySelector('.field-error');
    if (errorDiv) {
        errorDiv.remove();
    }
    field.style.borderColor = '';
    field.classList.remove('error');

    // Basic validation
    if (field.hasAttribute('required') && !value) {
        showFieldError(field, 'This field is required');
        return false;
    }

    if (field.type === 'email' && value && !ValidationRules.email(value)) {
        showFieldError(field, 'Please enter a valid email address');
        return false;
    }

    if (field.type === 'tel' && value && !ValidationRules.phone(value)) {
        showFieldError(field, 'Please enter a valid phone number');
        return false;
    }

    return true;
}

function showFieldError(field, message) {
    field.style.borderColor = '#e74c3c';
    field.classList.add('error');

    const errorDiv = document.createElement('div');
    errorDiv.className = 'field-error';
    errorDiv.style.color = '#e74c3c';
    errorDiv.style.fontSize = '0.875rem';
    errorDiv.style.marginTop = '0.25rem';
    errorDiv.textContent = message;

    field.parentNode.appendChild(errorDiv);
}

// Initialize validation when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    setupRealTimeValidation();
});