// Admin Portal JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Initialize admin functionality
    initializeAdmin();
});

function initializeAdmin() {
    // Mobile menu functionality
    initializeMobileMenu();
    
    // Form validation
    initializeFormValidation();
    
    // Table functionality
    initializeTableFeatures();
    
    // Modal functionality
    initializeModals();
    
    // Search functionality
    initializeSearch();
}

// Mobile menu functionality
function initializeMobileMenu() {
    const mobileMenuButton = document.getElementById('mobile-menu-button');
    const sidebar = document.getElementById('sidebar');
    
    if (mobileMenuButton && sidebar) {
        mobileMenuButton.addEventListener('click', function() {
            sidebar.classList.toggle('-translate-x-full');
            sidebar.classList.toggle('show');
        });
        
        // Close sidebar when clicking outside on mobile
        document.addEventListener('click', function(event) {
            if (window.innerWidth < 1024) {
                if (!sidebar.contains(event.target) && !mobileMenuButton.contains(event.target)) {
                    sidebar.classList.add('-translate-x-full');
                    sidebar.classList.remove('show');
                }
            }
        });
    }
}

// Form validation
function initializeFormValidation() {
    const forms = document.querySelectorAll('form');
    
    forms.forEach(form => {
        form.addEventListener('submit', function(event) {
            if (!validateForm(form)) {
                event.preventDefault();
            }
        });
        
        // Real-time validation
        const inputs = form.querySelectorAll('input, select, textarea');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                validateField(input);
            });
        });
    });
}

function validateForm(form) {
    let isValid = true;
    const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
    
    inputs.forEach(input => {
        if (!validateField(input)) {
            isValid = false;
        }
    });
    
    return isValid;
}

function validateField(field) {
    const value = field.value.trim();
    const fieldName = field.name || field.id;
    let isValid = true;
    let errorMessage = '';
    
    // Remove existing error styling
    field.classList.remove('border-red-500');
    const existingError = field.parentNode.querySelector('.error-message');
    if (existingError) {
        existingError.remove();
    }
    
    // Required field validation
    if (field.hasAttribute('required') && !value) {
        isValid = false;
        errorMessage = `${fieldName} is required`;
    }
    
    // Email validation
    if (field.type === 'email' && value) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(value)) {
            isValid = false;
            errorMessage = 'Please enter a valid email address';
        }
    }
    
    // Number validation
    if (field.type === 'number' && value) {
        if (isNaN(value) || parseFloat(value) < 0) {
            isValid = false;
            errorMessage = 'Please enter a valid positive number';
        }
    }
    
    // Password validation
    if (field.type === 'password' && value) {
        if (value.length < 6) {
            isValid = false;
            errorMessage = 'Password must be at least 6 characters long';
        }
    }
    
    // Show error if validation failed
    if (!isValid) {
        field.classList.add('border-red-500');
        const errorDiv = document.createElement('div');
        errorDiv.className = 'error-message text-red-500 text-sm mt-1';
        errorDiv.textContent = errorMessage;
        field.parentNode.appendChild(errorDiv);
    }
    
    return isValid;
}

// Table functionality
function initializeTableFeatures() {
    // Sortable tables
    const sortableHeaders = document.querySelectorAll('[data-sort]');
    sortableHeaders.forEach(header => {
        header.addEventListener('click', function() {
            sortTable(header);
        });
        header.style.cursor = 'pointer';
        header.innerHTML += ' <i class="fas fa-sort text-xs ml-1"></i>';
    });
    
    // Row selection
    const selectAllCheckbox = document.getElementById('select-all');
    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', function() {
            const rowCheckboxes = document.querySelectorAll('.row-checkbox');
            rowCheckboxes.forEach(checkbox => {
                checkbox.checked = selectAllCheckbox.checked;
            });
            updateBulkActions();
        });
    }
    
    const rowCheckboxes = document.querySelectorAll('.row-checkbox');
    rowCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', updateBulkActions);
    });
}

function sortTable(header) {
    const table = header.closest('table');
    const tbody = table.querySelector('tbody');
    const rows = Array.from(tbody.querySelectorAll('tr'));
    const columnIndex = Array.from(header.parentNode.children).indexOf(header);
    const isAscending = header.classList.contains('sort-asc');
    
    // Remove existing sort classes
    header.parentNode.querySelectorAll('th').forEach(th => {
        th.classList.remove('sort-asc', 'sort-desc');
    });
    
    // Add new sort class
    header.classList.add(isAscending ? 'sort-desc' : 'sort-asc');
    
    // Sort rows
    rows.sort((a, b) => {
        const aValue = a.children[columnIndex].textContent.trim();
        const bValue = b.children[columnIndex].textContent.trim();
        
        // Try to parse as numbers
        const aNum = parseFloat(aValue);
        const bNum = parseFloat(bValue);
        
        if (!isNaN(aNum) && !isNaN(bNum)) {
            return isAscending ? bNum - aNum : aNum - bNum;
        } else {
            return isAscending ? bValue.localeCompare(aValue) : aValue.localeCompare(bValue);
        }
    });
    
    // Reorder rows in DOM
    rows.forEach(row => tbody.appendChild(row));
}

function updateBulkActions() {
    const selectedRows = document.querySelectorAll('.row-checkbox:checked');
    const bulkActions = document.getElementById('bulk-actions');
    
    if (bulkActions) {
        if (selectedRows.length > 0) {
            bulkActions.classList.remove('hidden');
            bulkActions.querySelector('.selected-count').textContent = selectedRows.length;
        } else {
            bulkActions.classList.add('hidden');
        }
    }
}

// Modal functionality
function initializeModals() {
    // Delete confirmation modals
    const deleteButtons = document.querySelectorAll('[data-delete]');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function(event) {
            event.preventDefault();
            showDeleteConfirmation(button);
        });
    });
    
    // Close modal functionality
    document.addEventListener('click', function(event) {
        if (event.target.classList.contains('modal-overlay')) {
            closeModal(event.target);
        }
    });
    
    const closeButtons = document.querySelectorAll('[data-close-modal]');
    closeButtons.forEach(button => {
        button.addEventListener('click', function() {
            const modal = button.closest('.modal-overlay');
            closeModal(modal);
        });
    });
}

function showDeleteConfirmation(button) {
    const itemType = button.dataset.delete;
    const itemName = button.dataset.name || 'this item';
    
    const modal = document.createElement('div');
    modal.className = 'modal-overlay';
    modal.innerHTML = `
        <div class="modal-content">
            <div class="flex items-center mb-4">
                <div class="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center mr-3">
                    <i class="fas fa-exclamation-triangle text-red-600"></i>
                </div>
                <h3 class="text-lg font-semibold text-text-primary">Confirm Deletion</h3>
            </div>
            <p class="text-text-secondary mb-6">
                Are you sure you want to delete ${itemName}? This action cannot be undone.
            </p>
            <div class="flex justify-end space-x-3">
                <button type="button" class="btn btn-secondary" data-close-modal>Cancel</button>
                <button type="button" class="btn btn-danger" onclick="confirmDelete('${button.dataset.action}')">Delete</button>
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    // Close modal functionality
    modal.querySelector('[data-close-modal]').addEventListener('click', function() {
        closeModal(modal);
    });
}

function confirmDelete(action) {
    // Create and submit a form for the delete action
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = action;
    document.body.appendChild(form);
    form.submit();
}

function closeModal(modal) {
    modal.remove();
}

// Search functionality
function initializeSearch() {
    const searchInputs = document.querySelectorAll('.search-input');
    
    searchInputs.forEach(input => {
        input.addEventListener('input', function() {
            debounce(performSearch, 300)(input);
        });
    });
}

function performSearch(input) {
    const searchTerm = input.value.toLowerCase();
    const table = input.closest('.search-bar').nextElementSibling;
    
    if (table && table.tagName === 'TABLE') {
        const rows = table.querySelectorAll('tbody tr');
        
        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            if (text.includes(searchTerm)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
}

// Utility functions
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

function showLoading(element) {
    element.classList.add('loading');
    const spinner = document.createElement('div');
    spinner.className = 'spinner inline-block ml-2';
    element.appendChild(spinner);
}

function hideLoading(element) {
    element.classList.remove('loading');
    const spinner = element.querySelector('.spinner');
    if (spinner) {
        spinner.remove();
    }
}

function showNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.className = `fixed top-4 right-4 z-50 px-6 py-4 rounded-lg shadow-lg text-white ${
        type === 'success' ? 'bg-green-500' : 
        type === 'error' ? 'bg-red-500' : 
        type === 'warning' ? 'bg-yellow-500' : 
        'bg-blue-500'
    }`;
    notification.innerHTML = `
        <div class="flex items-center">
            <i class="fas ${
                type === 'success' ? 'fa-check-circle' : 
                type === 'error' ? 'fa-exclamation-circle' : 
                type === 'warning' ? 'fa-exclamation-triangle' : 
                'fa-info-circle'
            } mr-2"></i>
            <span>${message}</span>
        </div>
    `;
    
    document.body.appendChild(notification);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        notification.style.transition = 'opacity 0.5s';
        notification.style.opacity = '0';
        setTimeout(() => {
            notification.remove();
        }, 500);
    }, 5000);
}

// Export functions for global use
window.adminJS = {
    showDeleteConfirmation,
    confirmDelete,
    closeModal,
    showLoading,
    hideLoading,
    showNotification
};
