// Enhanced Dashboard JavaScript for Blood donation system1

// Prevent back button access after logout
window.history.pushState(null, null, window.location.href);
window.onpopstate = function(event) {
    window.history.pushState(null, null, window.location.href);
};

// Clear form data on page unload
window.addEventListener('beforeunload', function() {
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        if (form.querySelector('input[type="password"]')) {
            form.reset();
        }
    });
});

// Dashboard initialization
document.addEventListener('DOMContentLoaded', function() {
    initializeDashboard();
    loadDashboardCharts();
    setupRealTimeUpdates();
    setupNotifications();
});

// Initialize dashboard components
function initializeDashboard() {
    // Add loading states to action cards
    const actionCards = document.querySelectorAll('.action-card');
    actionCards.forEach(card => {
        card.addEventListener('click', function(e) {
            if (!this.href.includes('#')) {
                this.classList.add('loading');
                // Remove loading state after navigation
                setTimeout(() => {
                    this.classList.remove('loading');
                }, 1000);
            }
        });
    });

    // Add hover effects to stat cards
    const statCards = document.querySelectorAll('.stat-card');
    statCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-2px)';
        });
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
}

// Load dashboard charts (placeholder for Chart.js integration)
function loadDashboardCharts() {
    const chartCanvas = document.getElementById('stockChart');
    if (chartCanvas) {
        // Initialize chart with sample data
        const ctx = chartCanvas.getContext('2d');
        
        // Sample blood stock data
        const bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
        const stockLevels = [45, 32, 28, 15, 12, 8, 67, 23];
        
        // Simple bar chart implementation
        drawSimpleBarChart(ctx, bloodTypes, stockLevels);
    }
}

// Draw a simple bar chart
function drawSimpleBarChart(ctx, labels, data) {
    const canvas = ctx.canvas;
    const padding = 40;
    const chartWidth = canvas.width - (padding * 2);
    const chartHeight = canvas.height - (padding * 2);
    const barWidth = chartWidth / labels.length;
    const maxValue = Math.max(...data);
    
    // Clear canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    // Draw bars
    data.forEach((value, index) => {
        const barHeight = (value / maxValue) * chartHeight;
        const x = padding + (index * barWidth);
        const y = canvas.height - padding - barHeight;
        
        // Bar color based on stock level
        let color = '#e74c3c'; // Red for low stock
        if (value > 30) color = '#27ae60'; // Green for good stock
        else if (value > 15) color = '#f39c12'; // Orange for medium stock
        
        ctx.fillStyle = color;
        ctx.fillRect(x + 5, y, barWidth - 10, barHeight);
        
        // Draw value on top of bar
        ctx.fillStyle = '#2c3e50';
        ctx.font = '12px Poppins';
        ctx.textAlign = 'center';
        ctx.fillText(value.toString(), x + barWidth/2, y - 5);
        
        // Draw label
        ctx.fillText(labels[index], x + barWidth/2, canvas.height - 10);
    });
}

// Setup real-time updates
function setupRealTimeUpdates() {
    // Update stats every 30 seconds
    setInterval(updateDashboardStats, 30000);
    
    // Update activity feed every 60 seconds
    setInterval(updateActivityFeed, 60000);
}

// Update dashboard statistics
function updateDashboardStats() {
    // This would typically make an AJAX call to get updated stats
    console.log('Updating dashboard stats...');
    
    // Simulate stat updates
    const statNumbers = document.querySelectorAll('.stat-number');
    statNumbers.forEach(stat => {
        const currentValue = parseInt(stat.textContent);
        if (!isNaN(currentValue)) {
            // Add small random variation
            const variation = Math.floor(Math.random() * 3) - 1;
            const newValue = Math.max(0, currentValue + variation);
            stat.textContent = newValue;
        }
    });
}

// Update activity feed
function updateActivityFeed() {
    console.log('Updating activity feed...');
    
    // This would typically make an AJAX call to get new activities
    // For now, we'll just log the action
}

// Setup notifications
function setupNotifications() {
    // Check for new notifications every 2 minutes
    setInterval(checkNotifications, 120000);
    
    // Setup notification click handlers
    const notificationItems = document.querySelectorAll('.activity-item, .request-item');
    notificationItems.forEach(item => {
        item.addEventListener('click', function() {
            this.style.backgroundColor = '#e8f4fd';
            setTimeout(() => {
                this.style.backgroundColor = '';
            }, 2000);
        });
    });
}

// Check for new notifications
function checkNotifications() {
    // This would typically make an AJAX call to check for new notifications
    console.log('Checking for new notifications...');
}

// Utility function to format numbers
function formatNumber(num) {
    if (num >= 1000000) {
        return (num / 1000000).toFixed(1) + 'M';
    } else if (num >= 1000) {
        return (num / 1000).toFixed(1) + 'K';
    }
    return num.toString();
}

// Utility function to format dates
function formatDate(dateString) {
    const date = new Date(dateString);
    const now = new Date();
    const diffTime = Math.abs(now - date);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    
    if (diffDays === 0) {
        return 'Today';
    } else if (diffDays === 1) {
        return 'Yesterday';
    } else if (diffDays < 7) {
        return diffDays + ' days ago';
    } else {
        return date.toLocaleDateString();
    }
}

// Show loading state
function showLoading(element) {
    element.classList.add('loading');
}

// Hide loading state
function hideLoading(element) {
    element.classList.remove('loading');
}

// Show success message
function showSuccess(message) {
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert success';
    alertDiv.innerHTML = '<i class="fas fa-check-circle"></i> ' + message;
    
    const container = document.querySelector('.container');
    if (container) {
        container.insertBefore(alertDiv, container.firstChild);
        
        // Remove after 5 seconds
        setTimeout(() => {
            alertDiv.remove();
        }, 5000);
    }
}

// Show error message
function showError(message) {
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert';
    alertDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + message;
    
    const container = document.querySelector('.container');
    if (container) {
        container.insertBefore(alertDiv, container.firstChild);
        
        // Remove after 5 seconds
        setTimeout(() => {
            alertDiv.remove();
        }, 5000);
    }
}

// Handle form submissions with loading states
function handleFormSubmission(formSelector) {
    const form = document.querySelector(formSelector);
    if (form) {
        form.addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
            }
        });
    }
}

// Initialize all forms
document.addEventListener('DOMContentLoaded', function() {
    handleFormSubmission('form');
});

// Export functions for global use
window.dashboardUtils = {
    formatNumber,
    formatDate,
    showLoading,
    hideLoading,
    showSuccess,
    showError
};