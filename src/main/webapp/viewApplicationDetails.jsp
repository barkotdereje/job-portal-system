<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    Integer employerId = (Integer) session.getAttribute("employerId");
    if (employerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int applicationId = Integer.parseInt(request.getParameter("id"));

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", ""
        );

        String sql = "SELECT a.id, a.resume, a.applied_at, a.status, j.title, u.name, u.email, u.contact_number " +
                     "FROM applications a " +
                     "JOIN jobs j ON a.job_id=j.id " +
                     "JOIN users u ON a.jobseeker_id=u.id " +
                     "WHERE a.id=? AND j.employer_id=?";
        ps = con.prepareStatement(sql);
        ps.setInt(1, applicationId);
        ps.setInt(2, employerId);
        rs = ps.executeQuery();

        if (!rs.next()) {
            out.println("Application not found or access denied.");
            return;
        }
%>

<html>
<head>
    <title>Application Details - JobPortal</title>
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
            padding: 15px;
            display: flex;
            justify-content: center;
            align-items: flex-start; /* Changed from center to flex-start */
        }

        /* Container Styling */
        .details-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 800px;
            position: relative;
            overflow: visible; /* Changed from hidden */
            animation: fadeIn 0.8s ease-out;
            margin: 20px auto; /* Added margin */
        }

        .details-container::before {
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
            padding: 1.5rem 1.5rem 1rem 1.5rem; /* Reduced padding */
        }

        h2 {
            font-size: 1.6rem; /* Reduced from 2rem */
            color: #2b2d42;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 0.8rem; /* Reduced from 1rem */
            margin-bottom: 0.8rem; /* Added margin */
        }

        h2 i {
            font-size: 1.6rem; /* Reduced from 2rem */
        }

        /* Application ID Banner */
        .app-banner {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            padding: 0.7rem 1rem; /* Reduced padding */
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 0.6rem; /* Reduced from 0.8rem */
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
            font-size: 0.85rem; /* Added font-size */
        }

        .app-banner i {
            font-size: 1rem; /* Reduced from 1.2rem */
        }

        /* Content Area */
        .content-area {
            padding: 0 1.5rem 1.5rem 1.5rem; /* Adjusted padding */
        }

        /* Details Grid */
        .details-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem; /* Reduced from 1.5rem */
            margin-bottom: 1.5rem; /* Reduced from 2rem */
        }

        @media (max-width: 768px) {
            .details-grid {
                grid-template-columns: 1fr;
            }
        }

        .detail-card {
            background: linear-gradient(45deg, #f8fafc, #f1f5f9);
            border-radius: 8px;
            padding: 1rem; /* Reduced from 1.5rem */
            border-left: 4px solid #4361ee;
        }

        .detail-card h3 {
            color: #2b2d42;
            margin-bottom: 0.8rem; /* Reduced from 1rem */
            display: flex;
            align-items: center;
            gap: 0.6rem; /* Reduced from 0.8rem */
            font-size: 1rem; /* Added font-size */
        }

        .detail-card h3 i {
            color: #4361ee;
            font-size: 1rem; /* Reduced from 1.2rem */
        }

        .detail-item {
            margin-bottom: 0.8rem; /* Reduced from 1rem */
            display: flex;
            flex-direction: column;
        }

        .detail-label {
            font-size: 0.8rem; /* Reduced from 0.85rem */
            color: #6b7280;
            margin-bottom: 0.2rem; /* Reduced from 0.3rem */
            font-weight: 600;
        }

        .detail-value {
            font-weight: 600;
            color: #2b2d42;
            font-size: 0.9rem; /* Reduced from 1rem */
            padding: 0.4rem; /* Reduced from 0.5rem */
            background: white;
            border-radius: 6px;
            border: 1px solid #e5e7eb;
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

        .status-applied, .status-under-review {
            background: linear-gradient(45deg, #3b82f6, #1d4ed8);
            color: white;
        }

        .status-shortlisted {
            background: linear-gradient(45deg, #10b981, #059669);
            color: white;
        }

        .status-rejected {
            background: linear-gradient(45deg, #ef4444, #dc2626);
            color: white;
        }

        /* Resume Button */
        .resume-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem; /* Reduced from 0.8rem */
            background: linear-gradient(45deg, #3b82f6, #1d4ed8);
            color: white;
            text-decoration: none;
            padding: 0.8rem 1.2rem; /* Reduced from 1rem 1.5rem */
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9rem; /* Reduced from 1rem */
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(59, 130, 246, 0.3);
            border: none;
            cursor: pointer;
            margin-top: 0.5rem; /* Reduced from 1rem */
            width: 100%;
            justify-content: center;
        }

        .resume-btn:hover {
            background: linear-gradient(45deg, #1d4ed8, #3b82f6);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.4);
        }

        /* Status Form */
        .status-form {
            background: linear-gradient(45deg, #f8fafc, #f1f5f9);
            border-radius: 8px;
            padding: 1rem; /* Reduced from 1.5rem */
            margin-bottom: 1.5rem; /* Reduced from 2rem */
            border-left: 4px solid #10b981;
        }

        .status-form h3 {
            color: #2b2d42;
            margin-bottom: 0.8rem; /* Reduced from 1rem */
            display: flex;
            align-items: center;
            gap: 0.6rem; /* Reduced from 0.8rem */
            font-size: 1rem; /* Reduced from 1.2rem */
        }

        .status-form h3 i {
            color: #10b981;
            font-size: 1rem; /* Added font-size */
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

        select {
            width: 100%;
            padding: 0.8rem 1rem; /* Reduced from 1rem 1.2rem */
            border-radius: 8px;
            border: 2px solid #e5e7eb;
            font-size: 0.9rem; /* Reduced from 1rem */
            transition: all 0.3s ease;
            background: white;
            margin-bottom: 0.8rem; /* Reduced from 1rem */
        }

        select:focus {
            outline: none;
            border-color: #10b981;
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
        }

        .update-btn {
            background: linear-gradient(45deg, #10b981, #059669);
            color: white;
            text-decoration: none;
            padding: 0.8rem 1.2rem; /* Reduced from 1rem 1.5rem */
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9rem; /* Reduced from 1rem */
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(16, 185, 129, 0.3);
            border: none;
            cursor: pointer;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem; /* Reduced from 0.8rem */
        }

        .update-btn:hover {
            background: linear-gradient(45deg, #059669, #10b981);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4);
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

        /* Contact Info */
        .contact-info {
            display: flex;
            flex-wrap: wrap;
            gap: 0.8rem; /* Reduced from 1rem */
            margin-top: 0.8rem; /* Reduced from 1rem */
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 0.4rem; /* Reduced from 0.5rem */
            color: #6b7280;
            font-size: 0.8rem; /* Reduced from 0.9rem */
        }

        .contact-item i {
            color: #4361ee;
            font-size: 0.9rem; /* Added font-size */
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 10px;
                align-items: flex-start;
            }
            
            .header {
                padding: 1rem 1rem 0.8rem 1rem;
            }
            
            .content-area {
                padding: 0 1rem 1rem 1rem;
            }
            
            h2 {
                font-size: 1.4rem;
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
            
            .resume-btn, .update-btn {
                padding: 0.7rem 1rem;
                font-size: 0.85rem;
            }
        }

        @media (max-width: 480px) {
            .details-container {
                padding: 0;
            }
            
            .header {
                padding: 1rem 1rem 0.6rem 1rem;
            }
            
            .content-area {
                padding: 0 1rem 1rem 1rem;
            }
            
            h2 {
                font-size: 1.3rem;
                gap: 0.6rem;
            }
            
            h2 i {
                font-size: 1.3rem;
            }
            
            .app-banner {
                padding: 0.6rem 0.8rem;
                font-size: 0.8rem;
                gap: 0.4rem;
            }
            
            .detail-card {
                padding: 0.8rem;
            }
            
            .detail-card h3 {
                font-size: 0.9rem;
                margin-bottom: 0.6rem;
                gap: 0.4rem;
            }
            
            .detail-label {
                font-size: 0.75rem;
            }
            
            .detail-value {
                font-size: 0.8rem;
                padding: 0.3rem;
            }
            
            .status-form {
                padding: 0.8rem;
            }
            
            select {
                padding: 0.7rem 0.8rem;
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
            margin: 0 1.5rem 1rem 1.5rem; /* Added margin to align with content */
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
    <div class="details-container">
        <div class="header">
            <h2><i class="fas fa-file-alt"></i> Application Details</h2>
            
            <div class="app-banner">
                <i class="fas fa-hashtag"></i>
                <span>Application ID: #<%= applicationId %></span>
            </div>
        </div>

        <div class="content-area">
            <div class="details-grid">
                <div class="detail-card">
                    <h3><i class="fas fa-user"></i> Applicant Information</h3>
                    <div class="detail-item">
                        <span class="detail-label">Full Name</span>
                        <span class="detail-value"><%= rs.getString("name") %></span>
                    </div>
                    
                    <div class="contact-info">
                        <div class="contact-item">
                            <i class="fas fa-envelope"></i>
                            <span><%= rs.getString("email") %></span>
                        </div>
                        <% if (rs.getString("contact_number") != null && !rs.getString("contact_number").isEmpty()) { %>
                        <div class="contact-item">
                            <i class="fas fa-phone"></i>
                            <span><%= rs.getString("contact_number") %></span>
                        </div>
                        <% } %>
                    </div>
                </div>

                <div class="detail-card">
                    <h3><i class="fas fa-briefcase"></i> Job Information</h3>
                    <div class="detail-item">
                        <span class="detail-label">Job Title</span>
                        <span class="detail-value"><%= rs.getString("title") %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Application Date</span>
                        <span class="detail-value"><%= rs.getTimestamp("applied_at") %></span>
                    </div>
                </div>

                <div class="detail-card">
                    <h3><i class="fas fa-file-pdf"></i> Resume</h3>
                    <p style="font-size: 0.85rem; margin-bottom: 0.5rem; color: #6b7280;">Click below to download the applicant's resume:</p>
                    <% String resumeFile = rs.getString("resume"); %>
                    <a href="resumes/<%= resumeFile %>" target="_blank" class="resume-btn">
                        <i class="fas fa-download"></i> Download Resume
                    </a>
                </div>

                <div class="detail-card">
                    <h3><i class="fas fa-info-circle"></i> Current Status</h3>
                    <div class="detail-item">
                        <span class="detail-label">Status</span>
                        <%
                            String status = rs.getString("status");
                            String statusClass = "";
                            switch(status) {
                                case "APPLIED":
                                case "Under Review":
                                    statusClass = "status-under-review";
                                    break;
                                case "Shortlisted":
                                    statusClass = "status-shortlisted";
                                    break;
                                case "Rejected":
                                    statusClass = "status-rejected";
                                    break;
                            }
                        %>
                        <div class="status-badge <%= statusClass %>">
                            <i class="fas fa-circle"></i> <%= status %>
                        </div>
                    </div>
                </div>
            </div>

            <div class="status-form">
                <h3><i class="fas fa-sync-alt"></i> Update Application Status</h3>
                <form action="updateApplicationStatus" method="post">
                    <input type="hidden" name="applicationId" value="<%= rs.getInt("id") %>">
                    <div class="form-group">
                        <label class="form-label">Select New Status</label>
                        <select name="status" id="status">
                            <option value="Under Review" <%= "Under Review".equals(status) ? "selected" : "" %>>Under Review</option>
                            <option value="Shortlisted" <%= "Shortlisted".equals(status) ? "selected" : "" %>>Shortlisted</option>
                            <option value="Rejected" <%= "Rejected".equals(status) ? "selected" : "" %>>Rejected</option>
                        </select>
                    </div>
                    <button type="submit" class="update-btn">
                        <i class="fas fa-save"></i> Update Status
                    </button>
                </form>
            </div>

            <div class="action-links">
                <a href="viewApplications.jsp">
                    <i class="fas fa-arrow-left"></i> Back to Applications
                </a>
                <a href="employerDashboard.jsp">
                    <i class="fas fa-home"></i> Dashboard
                </a>
            </div>
        </div>
    </div>

    <script>
        // Form submission loading state
        document.querySelector('.status-form form').addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('.update-btn');
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

        // Resume button hover effect
        const resumeBtn = document.querySelector('.resume-btn');
        if (resumeBtn) {
            resumeBtn.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-3px)';
            });
            
            resumeBtn.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        }

        // Select focus effect
        const statusSelect = document.querySelector('select[name="status"]');
        if (statusSelect) {
            statusSelect.addEventListener('focus', function() {
                this.parentElement.style.transform = 'translateY(-2px)';
            });
            
            statusSelect.addEventListener('blur', function() {
                this.parentElement.style.transform = 'translateY(0)';
            });
            
            // Set initial status for dropdown
            const currentStatus = "<%= status %>";
            if (currentStatus) {
                statusSelect.value = currentStatus;
            }
        }
    </script>
</body>
</html>

<%
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if(rs != null) rs.close();
        if(ps != null) ps.close();
        if(con != null) con.close();
    }
%>