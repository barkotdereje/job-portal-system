<%@ page session="true" %>
<%
    Integer employerId = (Integer) session.getAttribute("employerId");
    if (employerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Change Password - JobPortal</title>
    <style>
        /* Modern Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', 'Segoe UI', Arial, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Container Styling */
        .password-container {
            background: white;
            border-radius: 15px;
            padding: 3rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            position: relative;
            overflow: hidden;
            animation: fadeIn 0.8s ease-out;
        }

        .password-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #4361ee, #3a0ca3);
        }

        /* Header Styling */
        .header {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        h2 {
            font-size: 2rem;
            color: #2b2d42;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        h2 i {
            font-size: 2rem;
            color: #4361ee;
        }

        /* Form Styling */
        .password-form {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .form-group {
            text-align: left;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: #2b2d42;
            font-weight: 600;
            font-size: 0.95rem;
        }

        input[type="password"] {
            width: 100%;
            padding: 1rem 1.2rem;
            border-radius: 8px;
            border: 2px solid #e5e7eb;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        input[type="password"]:focus {
            outline: none;
            border-color: #4361ee;
            background: white;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        /* Submit Button */
        .submit-btn {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            text-decoration: none;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
            border: none;
            cursor: pointer;
            margin-top: 1rem;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.8rem;
        }

        .submit-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* Action Links */
        .action-links {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 2px solid #f1f1f1;
            justify-content: center;
            flex-wrap: wrap;
        }

        .action-links a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.8rem;
            background: white;
            color: #4361ee;
            text-decoration: none;
            padding: 0.8rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
            border: 2px solid #4361ee;
        }

        .action-links a:hover {
            background: #4361ee;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
        }

        /* Message Styling */
        .message-container {
            margin-bottom: 2rem;
        }

        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 1rem;
            animation: slideIn 0.5s ease-out;
        }

        .alert-error {
            background: linear-gradient(45deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        }

        .alert-success {
            background: linear-gradient(45deg, #10b981, #059669);
            color: white;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        .alert i {
            font-size: 1.2rem;
        }

        /* Password Strength Indicator */
        .password-strength {
            margin-top: 0.5rem;
            font-size: 0.85rem;
        }

        .strength-text {
            font-weight: 600;
        }

        .strength-weak {
            color: #ef4444;
        }

        .strength-medium {
            color: #f59e0b;
        }

        .strength-strong {
            color: #10b981;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }
            
            .password-container {
                padding: 2rem;
            }
            
            h2 {
                font-size: 1.6rem;
            }
            
            input[type="password"] {
                padding: 0.9rem 1rem;
            }
            
            .submit-btn {
                padding: 0.9rem 1.2rem;
                font-size: 0.95rem;
            }
            
            .action-links {
                flex-direction: column;
                gap: 0.8rem;
            }
            
            .action-links a {
                width: 100%;
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .password-container {
                padding: 1.5rem;
            }
            
            h2 {
                font-size: 1.4rem;
            }
            
            h2 i {
                font-size: 1.5rem;
            }
            
            .submit-btn {
                padding: 0.8rem 1rem;
                font-size: 0.9rem;
            }
            
            .action-links a {
                padding: 0.6rem 1rem;
                font-size: 0.9rem;
            }
            
            .alert {
                padding: 0.8rem 1rem;
                font-size: 0.9rem;
            }
        }

        /* Animation */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .form-group {
            animation: fadeIn 0.6s ease-out;
        }

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .form-group:nth-child(3) { animation-delay: 0.3s; }
        .submit-btn { animation-delay: 0.4s; }
        .action-links { animation-delay: 0.5s; }

        /* Required Field Indicator */
        .required {
            color: #ef4444;
            margin-left: 4px;
        }

        /* Password Toggle */
        .password-wrapper {
            position: relative;
        }

        .toggle-password {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #6b7280;
            cursor: pointer;
            font-size: 1.2rem;
        }

        .toggle-password:hover {
            color: #4361ee;
        }
    </style>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="password-container">
        <div class="header">
            <i class="fas fa-key"></i>
            <h2>Change Password</h2>
        </div>

        <div class="message-container">
            <% 
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                
                if ("nomatch".equals(error)) { 
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>New passwords do not match!</span>
                </div>
            <% 
                } else if ("wrongold".equals(error)) { 
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>Old password is incorrect!</span>
                </div>
            <% 
                } else if ("server".equals(error)) { 
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>Server error. Please try again later.</span>
                </div>
            <% 
                } else if ("passwordChanged".equals(success)) { 
            %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>Password changed successfully!</span>
                </div>
            <% 
                } 
            %>
        </div>

        <form class="password-form" action="changePassword" method="post">
            <div class="form-group">
                <label class="form-label">Old Password <span class="required">*</span></label>
                <div class="password-wrapper">
                    <input type="password" name="oldPassword" placeholder="Enter your current password" required>
                    <button type="button" class="toggle-password" data-target="oldPassword">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label">New Password <span class="required">*</span></label>
                <div class="password-wrapper">
                    <input type="password" name="newPassword" placeholder="Enter new password" required>
                    <button type="button" class="toggle-password" data-target="newPassword">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
                <div class="password-strength" id="passwordStrength">
                    <span class="strength-text strength-weak">Weak</span>
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label">Confirm New Password <span class="required">*</span></label>
                <div class="password-wrapper">
                    <input type="password" name="confirmPassword" placeholder="Confirm new password" required>
                    <button type="button" class="toggle-password" data-target="confirmPassword">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
            </div>
            
            <button type="submit" class="submit-btn">
                <i class="fas fa-lock"></i> Change Password
            </button>
        </form>

        <div class="action-links">
            <a href="employerProfile.jsp">
                <i class="fas fa-user"></i> Back to Profile
            </a>
            <a href="employerDashboard.jsp">
                <i class="fas fa-home"></i> Dashboard
            </a>
        </div>
    </div>

    <script>
        // Password toggle visibility
        document.querySelectorAll('.toggle-password').forEach(button => {
            button.addEventListener('click', function() {
                const targetName = this.getAttribute('data-target');
                const input = document.querySelector(`input[name="${targetName}"]`);
                const icon = this.querySelector('i');
                
                if (input.type === 'password') {
                    input.type = 'text';
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                } else {
                    input.type = 'password';
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                }
            });
        });

        // Password strength checker
        const newPasswordInput = document.querySelector('input[name="newPassword"]');
        const strengthText = document.querySelector('.strength-text');
        
        newPasswordInput.addEventListener('input', function() {
            const password = this.value;
            let strength = 'weak';
            let colorClass = 'strength-weak';
            
            // Check password strength
            const hasLower = /[a-z]/.test(password);
            const hasUpper = /[A-Z]/.test(password);
            const hasNumber = /\d/.test(password);
            const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(password);
            const length = password.length;
            
            let score = 0;
            if (length >= 8) score++;
            if (length >= 12) score++;
            if (hasLower) score++;
            if (hasUpper) score++;
            if (hasNumber) score++;
            if (hasSpecial) score++;
            
            if (score >= 5) {
                strength = 'strong';
                colorClass = 'strength-strong';
            } else if (score >= 3) {
                strength = 'medium';
                colorClass = 'strength-medium';
            }
            
            // Update display
            strengthText.textContent = strength.charAt(0).toUpperCase() + strength.slice(1);
            strengthText.className = 'strength-text ' + colorClass;
        });

        // Form submission loading state
        document.querySelector('.password-form').addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('.submit-btn');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Changing Password...';
            submitBtn.style.pointerEvents = 'none';
            
            // Reset after 5 seconds if something goes wrong
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.style.pointerEvents = 'auto';
            }, 5000);
        });

        // Confirm password match
        const confirmPasswordInput = document.querySelector('input[name="confirmPassword"]');
        
        confirmPasswordInput.addEventListener('input', function() {
            const newPassword = newPasswordInput.value;
            const confirmPassword = this.value;
            
            if (confirmPassword && newPassword !== confirmPassword) {
                this.style.borderColor = '#ef4444';
                this.style.boxShadow = '0 0 0 3px rgba(239, 68, 68, 0.1)';
            } else if (confirmPassword) {
                this.style.borderColor = '#10b981';
                this.style.boxShadow = '0 0 0 3px rgba(16, 185, 129, 0.1)';
            } else {
                this.style.borderColor = '#e5e7eb';
                this.style.boxShadow = 'none';
            }
        });

        // Add focus effects to form inputs
        document.querySelectorAll('input[type="password"]').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.parentElement.style.transform = 'translateY(-2px)';
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.parentElement.style.transform = 'translateY(0)';
            });
        });

        // Auto-focus on first input field
        document.querySelector('input[name="oldPassword"]').focus();
    </script>
</body>
</html>