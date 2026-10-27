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

        String sql = "SELECT a.id, a.resume, a.applied_at, a.status, j.title, u.name, u.email, u.contact_number " +
                     "FROM applications a " +
                     "JOIN jobs j ON a.job_id=j.id " +
                     "JOIN users u ON a.jobseeker_id=u.id " +
                     "WHERE j.employer_id=? " +
                     "ORDER BY a.applied_at DESC";

        ps = con.prepareStatement(sql);
        ps.setInt(1, employerId);
        rs = ps.executeQuery();
%>

<html>
<head>
    <title>Manage Applications - JobPortal</title>
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
            flex-direction: column;
            align-items: center;
        }

        /* Container Styling */
        .container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 1300px;
            position: relative;
            overflow: visible;
            animation: fadeIn 0.8s ease-out;
            margin-top: 20px;
        }

        .container::before {
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
            padding: 1.5rem 1.5rem 1rem 1.5rem;
        }

        h2 {
            font-size: 1.6rem;
            color: #2b2d42;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 0.8rem;
            margin-bottom: 1rem;
        }

        h2 i {
            font-size: 1.6rem;
            color: #4361ee;
        }

        /* Back Button */
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            text-decoration: none;
            padding: 0.7rem 1.2rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
            border: none;
            cursor: pointer;
            margin-bottom: 1rem;
        }

        .back-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* Content Area */
        .content-area {
            padding: 0 1.5rem 1.5rem 1.5rem;
        }

        /* Table Styling */
        .applications-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }

        .applications-table th {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            padding: 0.9rem 0.7rem;
            text-align: left;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        .applications-table th:first-child {
            border-top-left-radius: 10px;
        }

        .applications-table th:last-child {
            border-top-right-radius: 10px;
        }

        .applications-table td {
            padding: 0.9rem 0.7rem;
            border-bottom: 1px solid #e5e7eb;
            vertical-align: middle;
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }

        .applications-table tr:last-child td {
            border-bottom: none;
        }

        .applications-table tr:hover td {
            background-color: #f8f9ff;
        }

        /* Cell Content */
        .app-id {
            font-weight: 600;
            color: #4361ee;
            font-size: 0.85rem;
        }

        .job-title-cell {
            font-weight: 600;
            color: #2b2d42;
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .applicant-name {
            font-weight: 600;
            color: #2b2d42;
        }

        .applicant-email {
            color: #6b7280;
            font-size: 0.8rem;
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .applicant-contact {
            color: #6b7280;
            font-size: 0.85rem;
        }

        .resume-link {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            background: linear-gradient(45deg, #3b82f6, #1d4ed8);
            color: white;
            text-decoration: none;
            padding: 0.4rem 0.8rem;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.8rem;
            transition: all 0.3s ease;
            box-shadow: 0 3px 10px rgba(59, 130, 246, 0.3);
        }

        .resume-link:hover {
            background: linear-gradient(45deg, #1d4ed8, #3b82f6);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(59, 130, 246, 0.4);
        }

        .applied-date {
            color: #6b7280;
            font-size: 0.8rem;
            background: #f8f9fa;
            padding: 0.3rem 0.6rem;
            border-radius: 6px;
            display: inline-block;
        }

        /* Status Badge */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.8rem;
        }

        .status-applied {
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

        .status-under-review {
            background: linear-gradient(45deg, #f59e0b, #d97706);
            color: white;
        }

        /* Action Buttons */
        .action-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            text-decoration: none;
            padding: 0.4rem 0.8rem;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.8rem;
            transition: all 0.3s ease;
            box-shadow: 0 3px 10px rgba(67, 97, 238, 0.3);
        }

        .action-btn:hover {
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.4);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 2rem;
            color: #6b7280;
        }

        .empty-state i {
            font-size: 2.5rem;
            color: #d1d5db;
            margin-bottom: 0.8rem;
        }

        .empty-state h3 {
            color: #4b5563;
            margin-bottom: 0.5rem;
            font-size: 1.2rem;
        }

        .empty-state p {
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }

        /* Stats Banner */
        .stats-banner {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            padding: 0.8rem 1.2rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
            font-size: 0.9rem;
        }

        .stats-banner i {
            font-size: 1rem;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .container {
                max-width: 95%;
            }
            
            .applications-table {
                display: block;
                overflow-x: auto;
            }
            
            .applications-table th,
            .applications-table td {
                padding: 0.8rem 0.6rem;
                font-size: 0.8rem;
            }
        }

        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .header {
                padding: 1rem 1rem 0.8rem 1rem;
            }
            
            .content-area {
                padding: 0 1rem 1rem 1rem;
            }
            
            h2 {
                font-size: 1.4rem;
                gap: 0.6rem;
            }
            
            h2 i {
                font-size: 1.4rem;
            }
            
            .stats-banner {
                padding: 0.6rem 1rem;
                font-size: 0.85rem;
            }
            
            .back-btn {
                padding: 0.6rem 1rem;
                font-size: 0.85rem;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 0.8rem 0.8rem 0.6rem 0.8rem;
            }
            
            .content-area {
                padding: 0 0.8rem 0.8rem 0.8rem;
            }
            
            h2 {
                font-size: 1.3rem;
            }
            
            .applications-table th,
            .applications-table td {
                padding: 0.7rem 0.5rem;
                font-size: 0.75rem;
            }
            
            .applicant-email {
                max-width: 120px;
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

        .applications-table tr {
            animation: fadeIn 0.6s ease-out;
        }

        /* Success/Error Messages */
        .alert {
            padding: 0.8rem 1rem;
            border-radius: 8px;
            margin: 0 1.5rem 1rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
            animation: slideIn 0.5s ease-out;
            font-size: 0.85rem;
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
    <div class="container">
        <div class="header">
            <h2><i class="fas fa-file-alt"></i> Applications for Your Jobs</h2>
            
            <div class="stats-banner">
                <i class="fas fa-users"></i>
                <span>Manage all job applications</span>
            </div>
        </div>

        <div class="content-area">
            <a href="employerDashboard.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>

            <table class="applications-table">
                <thead>
                    <tr>
                        <th style="width: 5%;">ID</th>
                        <th style="width: 15%;">Job Title</th>
                        <th style="width: 12%;">Applicant Name</th>
                        <th style="width: 18%;">Email</th>
                        <th style="width: 10%;">Contact</th>
                        <th style="width: 8%;">Resume</th>
                        <th style="width: 12%;">Applied At</th>
                        <th style="width: 10%;">Status</th>
                        <th style="width: 10%;">Actions</th>
                    </tr>
                </thead>
                <tbody>
<%
        boolean hasApplications = false;
        while(rs.next()) {
            hasApplications = true;
            String resumeFile = rs.getString("resume");
            String appliedDate = rs.getTimestamp("applied_at").toString();
            if (appliedDate.length() > 16) {
                appliedDate = appliedDate.substring(0, 16);
            }
            String status = rs.getString("status");
            String statusClass = "";
            switch(status) {
                case "APPLIED":
                    statusClass = "status-applied";
                    break;
                case "SHORTLISTED":
                    statusClass = "status-shortlisted";
                    break;
                case "REJECTED":
                    statusClass = "status-rejected";
                    break;
                case "UNDER REVIEW":
                    statusClass = "status-under-review";
                    break;
            }
%>
        <tr>
            <td>
                <div class="app-id">#<%= rs.getInt("id") %></div>
            </td>
            <td>
                <div class="job-title-cell"><%= rs.getString("title") %></div>
            </td>
            <td>
                <div class="applicant-name"><%= rs.getString("name") %></div>
            </td>
            <td>
                <div class="applicant-email"><%= rs.getString("email") %></div>
            </td>
            <td>
                <div class="applicant-contact"><%= rs.getString("contact_number") %></div>
            </td>
            <td>
                <a class="resume-link"  href="resumes/<%= resumeFile %>" target="_blank">
                    <i class="fas fa-download"></i> Download
                </a>
               
            </td>
            <td>
                <div class="applied-date"><%= appliedDate %></div>
            </td>
            <td>
                <div class="status-badge <%= statusClass %>">
                    <i class="fas fa-circle"></i> <%= status %>
                </div>
            </td>
            <td>
                <a class="action-btn" href="viewApplicationDetails.jsp?id=<%= rs.getInt("id") %>">
                    <i class="fas fa-eye"></i> View
                </a>
            </td>
        </tr>
<%
        }
        
        if (!hasApplications) {
%>
        <tr>
            <td colspan="9">
                <div class="empty-state">
                    <i class="fas fa-folder-open"></i>
                    <h3>No Applications Found</h3>
                    <p>You haven't received any applications for your jobs yet.</p>
                </div>
            </td>
        </tr>
<%
        }
    } catch(Exception e) {
%>
        <tr>
            <td colspan="9">
                <div class="empty-state">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Error Loading Applications</h3>
                    <p>There was an error loading applications. Please try again later.</p>
                </div>
            </td>
        </tr>
<%
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Add hover effects to table rows
        document.querySelectorAll('.applications-table tbody tr').forEach(row => {
            row.addEventListener('mouseenter', function() {
                this.style.cursor = 'pointer';
            });
        });

        // Add loading state to action buttons
        document.querySelectorAll('.action-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';
                this.style.pointerEvents = 'none';
                
                // Reset after 3 seconds if something goes wrong
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.style.pointerEvents = 'auto';
                }, 3000);
            });
        });

        // Back button hover effect
        const backBtn = document.querySelector('.back-btn');
        if (backBtn) {
            backBtn.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-3px)';
            });
            
            backBtn.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        }

        // Resume download buttons hover effect
        document.querySelectorAll('.resume-link').forEach(btn => {
            btn.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
            });
            
            btn.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });
    </script>
</body>
</html>