<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create Account | JobPortal</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    /* Modern Reset */
    * {margin:0;padding:0;box-sizing:border-box;}
    body {font-family:'Poppins',sans-serif;background:linear-gradient(135deg,#f5f7fa 0%,#c3cfe2 100%);color:#333;line-height:1.6;min-height:100vh;display:flex;align-items:center;justify-content:center;padding:20px;}
    
    /* Container */
    .register-wrapper {max-width:1000px;width:100%;display:flex;background:white;border-radius:12px;overflow:hidden;box-shadow:0 5px 25px rgba(0,0,0,0.1);min-height:600px;}
    
    /* Left Panel */
    .left-panel {flex:1;background:linear-gradient(45deg,#4361ee,#3a0ca3);color:white;padding:40px;display:flex;flex-direction:column;justify-content:center;position:relative;overflow:hidden;}
    .logo {font-size:1.5rem;font-weight:700;margin-bottom:2rem;display:flex;align-items:center;gap:0.8rem;}
    .logo i {font-size:1.8rem;}
    .panel-title {font-size:2rem;font-weight:700;margin-bottom:1rem;line-height:1.2;}
    .panel-subtitle {font-size:0.95rem;opacity:0.9;margin-bottom:2rem;line-height:1.5;}
    .features {list-style:none;margin-top:2rem;}
    .features li {display:flex;align-items:flex-start;margin-bottom:1.5rem;}
    .features i {background:rgba(255,255,255,0.15);width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;margin-right:15px;flex-shrink:0;}
    .feature-text h5 {font-size:1rem;font-weight:600;margin-bottom:5px;}
    .feature-text p {font-size:0.85rem;opacity:0.8;margin:0;}
    
    /* Right Panel */
    .right-panel {flex:1.2;padding:40px;display:flex;flex-direction:column;justify-content:center;}
    .form-header {margin-bottom:2rem;text-align:center;}
    .form-header h2 {color:#2b2d42;font-size:1.8rem;font-weight:700;margin-bottom:0.5rem;}
    .form-header p {color:#6b7280;font-size:0.95rem;}
    
    /* Form Styling */
    .form-container {width:100%;}
    .form-group {margin-bottom:1.5rem;}
    .form-label {display:block;font-weight:600;color:#2b2d42;margin-bottom:0.5rem;display:flex;align-items:center;gap:0.5rem;}
    .form-control, .form-select {width:100%;padding:0.8rem 1rem;border:1px solid #d1d5db;border-radius:8px;font-size:1rem;transition:all 0.3s ease;background:white;}
    .form-control:focus, .form-select:focus {outline:none;border-color:#4361ee;box-shadow:0 0 0 3px rgba(67,97,238,0.1);}
    
    /* Role Selection */
    .role-options {display:flex;gap:1rem;margin-bottom:1.5rem;}
    .role-option {flex:1;border:2px solid #e5e7eb;border-radius:8px;padding:1.2rem;cursor:pointer;transition:all 0.3s ease;text-align:center;background:white;}
    .role-option:hover {border-color:#4361ee;transform:translateY(-3px);box-shadow:0 5px 15px rgba(67,97,238,0.15);}
    .role-option.active {border-color:#4361ee;background:rgba(67,97,238,0.05);}
    .role-icon {font-size:1.5rem;color:#4361ee;margin-bottom:0.5rem;}
    .role-title {font-weight:600;color:#2b2d42;margin-bottom:0.25rem;font-size:0.95rem;}
    .role-desc {font-size:0.85rem;color:#6b7280;margin:0;}
    
    /* Jobseeker Fields */
    #jobseekerFields {background:#f8fafc;border-radius:8px;padding:1.5rem;margin-top:0.5rem;border-left:4px solid #4361ee;transition:all 0.4s ease;max-height:500px;overflow:hidden;}
    #jobseekerFields.hidden {opacity:0;max-height:0;padding:0;margin:0;border:none;}
    
    /* Button */
    .submit-btn {display:inline-flex;align-items:center;gap:0.8rem;background:linear-gradient(45deg,#4361ee,#3a0ca3);color:white;text-decoration:none;padding:0.8rem 1.5rem;border-radius:8px;font-weight:600;font-size:0.95rem;transition:all 0.3s ease;box-shadow:0 5px 15px rgba(67,97,238,0.3);border:none;cursor:pointer;width:100%;justify-content:center;}
    .submit-btn:hover {transform:translateY(-3px);box-shadow:0 8px 20px rgba(67,97,238,0.4);background:linear-gradient(45deg,#3a0ca3,#4361ee);}
    
    /* Links */
    .login-link {text-align:center;margin-top:1.5rem;color:#6b7280;font-size:0.9rem;}
    .login-link a {color:#4361ee;font-weight:600;text-decoration:none;transition:all 0.3s ease;}
    .login-link a:hover {color:#3a0ca3;text-decoration:underline;}
    .terms {font-size:0.8rem;color:#6b7280;margin-top:1rem;text-align:center;}
    .terms a {color:#4361ee;text-decoration:none;}
    .terms a:hover {text-decoration:underline;}
    
    /* Password Toggle */
    .password-toggle {position:absolute;right:15px;top:38px;background:none;border:none;color:#6b7280;cursor:pointer;font-size:1rem;}
    .password-toggle:hover {color:#4361ee;}
    
    /* Responsive */
    @media (max-width:768px){.register-wrapper{flex-direction:column;}.left-panel,.right-panel{padding:2rem;}.role-options{flex-direction:column;}}
    @media (max-width:480px){.left-panel,.right-panel{padding:1.5rem;}.panel-title{font-size:1.5rem;}}
</style>
</head>
<body>
<div class="register-wrapper">
    <!-- Left Panel -->
    <div class="left-panel">
        <div class="logo">
            <i class="fas fa-briefcase"></i> JobPortal
        </div>
        
        <h1 class="panel-title">Find Your Dream Job or Ideal Candidate</h1>
        <p class="panel-subtitle">Join our platform of professionals and companies. Whether you're looking for your next opportunity or seeking talent, we connect the right people.</p>
        
        <ul class="features">
            <li>
                <i class="fas fa-check-circle"></i>
                <div class="feature-text">
                    <h5>Access Top Opportunities</h5>
                    <p>Thousands of jobs from leading companies worldwide</p>
                </div>
            </li>
            <li>
                <i class="fas fa-users"></i>
                <div class="feature-text">
                    <h5>Network with Professionals</h5>
                    <p>Connect with industry experts and potential employers</p>
                </div>
            </li>
            <li>
                <i class="fas fa-rocket"></i>
                <div class="feature-text">
                    <h5>Accelerate Your Career</h5>
                    <p>Get personalized job recommendations and career advice</p>
                </div>
            </li>
        </ul>
    </div>
    
    <!-- Right Panel -->
    <div class="right-panel">
        <div class="form-header">
            <h2>Create Your Account</h2>
            <p>Start your journey with JobPortal today</p>
        </div>
        
        <form action="RegistrationServlet" method="post" class="form-container" id="registrationForm">
            <!-- Role Selection -->
            <div class="form-group">
                <label class="form-label">Account Type</label>
                <div class="role-options">
                    <div class="role-option active" data-role="JOBSEEKER">
                        <div class="role-icon"><i class="fas fa-user-graduate"></i></div>
                        <div class="role-title">Job Seeker</div>
                        <p class="role-desc">Looking for opportunities</p>
                    </div>
                    <div class="role-option" data-role="EMPLOYER">
                        <div class="role-icon"><i class="fas fa-building"></i></div>
                        <div class="role-title">Employer</div>
                        <p class="role-desc">Hiring talent</p>
                    </div>
                </div>
                <select name="role" class="form-select" required id="roleSelect" style="display:none;">
                    <option value="">Select Role</option>
                    <option value="JOBSEEKER" selected>Job Seeker</option>
                    <option value="EMPLOYER">Employer</option>
                </select>
            </div>
            
            <!-- Personal Information -->
            <div style="display:flex;gap:1rem;margin-bottom:1rem;">
                <div style="flex:1;">
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-user"></i> Full Name</label>
                        <input type="text" name="name" class="form-control" placeholder="Enter your name" required>
                    </div>
                </div>
                <div style="flex:1;">
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-envelope"></i> Email Address</label>
                        <input type="email" name="email" class="form-control" placeholder="your.email@example.com" required>
                    </div>
                </div>
            </div>
            
            <div style="display:flex;gap:1rem;margin-bottom:1rem;">
                <div style="flex:1;position:relative;">
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-lock"></i> Password</label>
                        <input type="password" name="password" id="password" class="form-control" placeholder="Create a secure password" required>
                        <button type="button" class="password-toggle" id="togglePassword">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>
                <div style="flex:1;">
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-phone"></i> Contact Number</label>
                        <input type="text" name="contact_number" class="form-control" placeholder="+1 (123) 456-7890">
                    </div>
                </div>
            </div>
            
            <!-- Jobseeker-specific fields -->
            <div id="jobseekerFields">
                <h5 style="color:#2b2d42;margin-bottom:1rem;font-weight:600;">
                    <i class="fas fa-user-graduate"></i> Professional Information
                </h5>
                
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-tools"></i> Skills</label>
                    <input type="text" name="skills" class="form-control" placeholder="e.g., Java, Python, Project Management, Communication">
                    <small style="color:#6b7280;font-size:0.85rem;margin-top:0.25rem;display:block;">Separate skills with commas</small>
                </div>
                
                <div style="display:flex;gap:1rem;">
                    <div style="flex:1;">
                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-graduation-cap"></i> Education</label>
                            <input type="text" name="education" class="form-control" placeholder="e.g., B.S. Computer Science">
                        </div>
                    </div>
                    <div style="flex:1;">
                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-briefcase"></i> Experience</label>
                            <input type="text" name="experience" class="form-control" placeholder="e.g., 3 years software development">
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Submit Button -->
            <button type="submit" class="submit-btn">
                <i class="fas fa-user-plus"></i> Create Account
            </button>
            
            <div class="terms">
                By creating an account, you agree to our <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>
            </div>
            
            <div class="login-link">
                Already have an account? <a href="login.jsp">Sign in here</a>
            </div>
        </form>
    </div>
</div>

<script>
    // Role selection
    const roleOptions = document.querySelectorAll('.role-option');
    const roleSelect = document.getElementById('roleSelect');
    const jobseekerFields = document.getElementById('jobseekerFields');
    
    roleOptions.forEach(option => {
        option.addEventListener('click', () => {
            roleOptions.forEach(opt => opt.classList.remove('active'));
            option.classList.add('active');
            
            const role = option.getAttribute('data-role');
            roleSelect.value = role;
            
            if (role === 'JOBSEEKER') {
                jobseekerFields.classList.remove('hidden');
            } else {
                jobseekerFields.classList.add('hidden');
            }
        });
    });
    
    // Set default selection
    roleSelect.value = 'JOBSEEKER';
    
    // Toggle password visibility
    const togglePassword = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');
    
    togglePassword.addEventListener('click', () => {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        
        const eyeIcon = togglePassword.querySelector('i');
        if (type === 'text') {
            eyeIcon.classList.remove('fa-eye');
            eyeIcon.classList.add('fa-eye-slash');
        } else {
            eyeIcon.classList.remove('fa-eye-slash');
            eyeIcon.classList.add('fa-eye');
        }
    });
    
    // Form validation
    const form = document.getElementById('registrationForm');
    form.addEventListener('submit', function(e) {
        const role = roleSelect.value;
        const name = document.querySelector('input[name="name"]').value;
        const email = document.querySelector('input[name="email"]').value;
        const password = document.querySelector('input[name="password"]').value;
        
        if (!role || !name || !email || !password) {
            e.preventDefault();
            alert('Please fill in all required fields');
            return false;
        }
        
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            e.preventDefault();
            alert('Please enter a valid email address');
            return false;
        }
    });
</script>
</body>
