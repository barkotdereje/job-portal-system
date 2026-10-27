<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    Integer employerId = (Integer) session.getAttribute("employerId");
    if (employerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
            "root", ""
        );

        String sql = "SELECT name, email, company_name, contact_number, status, approved FROM users WHERE id=?";
        ps = con.prepareStatement(sql);
        ps.setInt(1, employerId);
        rs = ps.executeQuery();
        if (rs.next()) {
            String name = rs.getString("name");
            String email = rs.getString("email");
            String company = rs.getString("company_name");
            String contact = rs.getString("contact_number");
            String status = rs.getString("status");
            int approved = rs.getInt("approved");
%>

<html>
<head>
    <title>Employer Profile - JobPortal</title>
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
            align-items: flex-start; /* Changed from center to flex-start */
        }

        /* Profile Container */
        .profile-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 800px;
            position: relative;
            overflow: visible; /* Changed from hidden */
            animation: fadeIn 0.8s ease-out;
            margin: 20px auto; /* Added margin for better spacing */
        }

        .profile-container::before {
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
            padding: 2rem 2rem 1rem 2rem; /* Reduced bottom padding */
        }

        h2 {
            font-size: 1.8rem; /* Reduced from 2rem */
            color: #2b2d42;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 0.8rem; /* Reduced from 1rem */
            margin-bottom: 1rem; /* Added margin */
        }

        h2 i {
            font-size: 1.8rem; /* Reduced from 2rem */
        }

        /* Profile Banner */
        .profile-banner {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            padding: 0.8rem 1.2rem; /* Reduced padding */
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 0.6rem; /* Reduced from 0.8rem */
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
            font-size: 0.9rem; /* Added font-size */
        }

        .profile-banner i {
            font-size: 1rem; /* Reduced from 1.2rem */
        }

        /* Profile Content */
        .profile-content {
            padding: 0 2rem 2rem 2rem; /* Adjusted padding */
        }

        /* Profile Info Card */
        .profile-info {
            background: linear-gradient(45deg, #f8fafc, #f1f5f9);
            border-radius: 10px;
            padding: 1.2rem; /* Reduced from 1.5rem */
            margin-bottom: 1.5rem; /* Reduced from 2rem */
            border-left: 4px solid #4361ee;
        }

        .profile-info h3 {
            color: #2b2d42;
            margin-bottom: 0.8rem; /* Reduced from 1rem */
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.1rem; /* Added font-size */
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); /* Reduced minmax */
            gap: 0.8rem; /* Reduced from 1rem */
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            font-size: 0.8rem; /* Reduced from 0.85rem */
            color: #6b7280;
            margin-bottom: 0.2rem; /* Reduced from 0.3rem */
        }

        .info-value {
            font-weight: 600;
            color: #2b2d42;
            font-size: 0.9rem; /* Added font-size */
        }

        /* Profile Form */
        .profile-form {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem; /* Reduced from 1.5rem */
            margin-bottom: 1.5rem; /* Reduced from 2rem */
        }

        @media (max-width: 768px) {
            .profile-form {
                grid-template-columns: 1fr;
            }
        }

        .form-group {
            text-align: left;
        }

        .form-label {
            display: block;
            margin-bottom: 0.4rem; /* Reduced from 0.5rem */
            color: #2b2d42;
            font-weight: 600;
            font-size: 0.9rem; /* Reduced from 0.95rem */
        }

        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 0.8rem 1rem; /* Reduced from 1rem 1.2rem */
            border-radius: 8px;
            border: 2px solid #e5e7eb;
            font-size: 0.9rem; /* Reduced from 1rem */
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        input[type="text"]:focus, input[type="email"]:focus {
            outline: none;
            border-color: #4361ee;
            background: white;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        input[readonly] {
            background-color: #f3f4f6;
            color: #6b7280;
            cursor: not-allowed;
            border-color: #d1d5db;
        }

        /* Status Badge */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem; /* Reduced from 0.5rem */
            padding: 0.4rem 0.8rem; /* Reduced padding */
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.8rem; /* Reduced from 0.9rem */
        }

        .status-active {
            background: linear-gradient(45deg, #10b981, #059669);
            color: white;
        }

        .status-pending {
            background: linear-gradient(45deg, #f59e0b, #d97706);
            color: white;
        }

        .approved-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem; /* Reduced from 0.5rem */
            padding: 0.4rem 0.8rem; /* Reduced padding */
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.8rem; /* Reduced from 0.9rem */
        }

        .approved-yes {
            background: linear-gradient(45deg, #10b981, #059669);
            color: white;
        }

        .approved-no {
            background: linear-gradient(45deg, #ef4444, #dc2626);
            color: white;
        }

        /* Submit Button */
        .submit-btn {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            text-decoration: none;
            padding: 0.8rem 1.2rem; /* Reduced from 1rem 1.5rem */
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9rem; /* Reduced from 1rem */
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
            border: none;
            cursor: pointer;
            margin-top: 0.5rem; /* Reduced from 1rem */
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem; /* Reduced from 0.8rem */
            grid-column: 1 / -1;
        }

        .submit-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* Action Links */
        .action-links {
            display: flex;
            gap: 0.8rem; /* Reduced from 1rem */
            margin-top: 1.5rem; /* Reduced from 2rem */
            padding-top: 1.5rem; /* Reduced from 2rem */
            border-top: 2px solid #f1f1f1;
            justify-content: center;
            flex-wrap: wrap;
        }

        .action-links a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem; /* Reduced from 0.8rem */
            background: white;
            color: #4361ee;
            text-decoration: none;
            padding: 0.6rem 1rem; /* Reduced from 0.8rem 1.5rem */
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.85rem; /* Reduced from 0.95rem */
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

        .action-links a:nth-child(1) {
            background: linear-gradient(45deg, #10b981, #059669);
            color: white;
            border: none;
        }

        .action-links a:nth-child(1):hover {
            background: linear-gradient(45deg, #059669, #10b981);
        }

        .action-links a:nth-child(2) {
            background: linear-gradient(45deg, #f59e0b, #d97706);
            color: white;
            border: none;
        }

        .action-links a:nth-child(2):hover {
            background: linear-gradient(45deg, #d97706, #f59e0b);
        }

        /* Required Field Indicator */
        .required {
            color: #ef4444;
            margin-left: 3px; /* Reduced from 4px */
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 15px;
                align-items: flex-start;
            }
            
            .header {
                padding: 1.5rem 1.5rem 1rem 1.5rem;
            }
            
            .profile-content {
                padding: 0 1.5rem 1.5rem 1.5rem;
            }
            
            h2 {
                font-size: 1.5rem;
            }
            
            .profile-info {
                padding: 1rem;
                margin-bottom: 1rem;
            }
            
            .profile-form {
                gap: 0.8rem;
                margin-bottom: 1rem;
            }
            
            .action-links {
                flex-direction: column;
                gap: 0.6rem;
            }
            
            .action-links a {
                width: 100%;
                justify-content: center;
                padding: 0.7rem 1rem;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }
            
            .header {
                padding: 1rem 1rem 0.8rem 1rem;
            }
            
            .profile-content {
                padding: 0 1rem 1rem 1rem;
            }
            
            h2 {
                font-size: 1.3rem;
                gap: 0.6rem;
            }
            
            h2 i {
                font-size: 1.4rem;
            }
            
            .profile-banner {
                padding: 0.6rem 0.8rem;
                font-size: 0.8rem;
                gap: 0.4rem;
            }
            
            .profile-info h3 {
                font-size: 1rem;
                margin-bottom: 0.6rem;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
                gap: 0.6rem;
            }
            
            input[type="text"], input[type="email"] {
                padding: 0.7rem 0.8rem;
                font-size: 0.85rem;
            }
            
            .submit-btn {
                padding: 0.7rem 1rem;
                font-size: 0.85rem;
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

        /* Success/Error Messages */
        .alert {
            padding: 0.8rem 1rem; /* Reduced padding */
            border-radius: 8px;
            margin: 0 2rem 1rem 2rem; /* Added margin to align with content */
            display: flex;
            align-items: center;
            gap: 0.8rem;
            animation: slideIn 0.5s ease-out;
            font-size: 0.9rem; /* Added font-size */
        }

        .alert-success {
            background: linear-gradient(45deg, #10b981, #059669);
            color: white;
        }

        .alert-error {
            background: linear-gradient(45deg, #ef4444, #dc2626);
            color: white;
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
    </style>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="profile-container">
        <div class="header">
            <h2><i class="fas fa-user-cog"></i> My Profile</h2>
            
            <div class="profile-banner">
                <i class="fas fa-user-tie"></i>
                <span>Employer Account Management</span>
            </div>
        </div>

        <div class="profile-content">
            <div class="profile-info">
                <h3><i class="fas fa-info-circle"></i> Account Information</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Account Status</span>
                        <span class="info-value status-badge <%= "active".equals(status) ? "status-active" : "status-pending" %>">
                            <i class="fas fa-circle"></i> <%= status %>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Verification Status</span>
                        <span class="info-value approved-badge <%= approved == 1 ? "approved-yes" : "approved-no" %>">
                            <i class="fas fa-<%= approved == 1 ? "check" : "clock" %>"></i> 
                            <%= approved == 1 ? "Verified" : "Pending Verification" %>
                        </span>
                    </div>
                </div>
            </div>

            <form action="<%=request.getContextPath()%>/editEmployer" method="post">
            <input type="hidden" name="id" value="<%= employerId %>">
                <div class="form-group">
                    <label class="form-label">Full Name <span class="required">*</span></label>
                    <input type="text" name="name" value="<%= name %>" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Email Address <span class="required">*</span></label>
                    <input type="email" name="email" value="<%= email %>" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Company Name <span class="required">*</span></label>
                    <input type="text" name="company_name" value="<%= company %>" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Contact Number</label>
                    <input type="text" name="contact_number" value="<%= contact != null ? contact : "" %>" placeholder="Enter phone number">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Account Status</label>
                    <input type="text" name="status" value="<%= status %>" readonly>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Verification Status</label>
                    <input type="text" value="<%= approved == 1 ? "Verified" : "Pending Verification" %>" readonly>
                </div>
                
                <button type="submit" class="submit-btn">
                    <i class="fas fa-save"></i> Update Profile
                </button>
            </form>

            <div class="action-links">
                <a href="changePassword.jsp">
                    <i class="fas fa-key"></i> Change Password
                </a>
                <a href="manageJobsEmployer.jsp">
                    <i class="fas fa-briefcase"></i> View My Posted Jobs
                </a>
                <a href="employerDashboard.jsp">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>
    </div>

    <script>
        // Add focus effects to form inputs
        document.querySelectorAll('input[type="text"], input[type="email"]').forEach(input => {
            input.addEventListener('focus', function() {
                if (!this.readOnly) {
                    this.parentElement.style.transform = 'translateY(-2px)';
                }
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'translateY(0)';
            });
        });

        // Form submission loading state
        document.querySelector('.profile-form').addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('.submit-btn');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
            submitBtn.style.pointerEvents = 'none';
            
            // Reset after 5 seconds if something goes wrong
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.style.pointerEvents = 'auto';
            }, 5000);
        });

        // Action links hover effect
        document.querySelectorAll('.action-links a').forEach(link => {
            link.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
            });
            
            link.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Auto-focus on first editable input field
        const firstEditableInput = document.querySelector('input:not([readonly])');
        if (firstEditableInput) {
            firstEditableInput.focus();
        }

        // Show notification if contact number is empty
        const contactInput = document.querySelector('input[name="contact_number"]');
        if (contactInput && !contactInput.value.trim()) {
            contactInput.addEventListener('focus', function() {
                this.placeholder = "e.g., +1 (123) 456-7890";
            });
        }
    </script>
</body>
</html>

<%
        }
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>