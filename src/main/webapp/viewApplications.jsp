<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    Integer employerId = (Integer) session.getAttribute("employerId");
    if (employerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html>
<head>
    <title>View Applications - JobPortal</title>
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
            flex-direction: column;
            align-items: center;
        }

        /* Container Styling */
        .applications-container {
            background: white;
            border-radius: 15px;
            padding: 3rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 1200px;
            position: relative;
            overflow: visible;
            animation: fadeIn 0.8s ease-out;
            margin-top: 20px;
        }

        .applications-container::before {
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
            justify-content: space-between;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        h2 {
            font-size: 2rem;
            color: #2b2d42;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        h2 i {
            font-size: 2rem;
            color: #4361ee;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .action-buttons a {
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            text-decoration: none;
            padding: 0.8rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
            border: none;
            cursor: pointer;
        }

        .action-buttons a:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* Filter Form */
        .filter-form {
            background: linear-gradient(45deg, #f8fafc, #f1f5f9);
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border-left: 4px solid #4361ee;
        }

        .filter-form h3 {
            color: #2b2d42;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
            font-size: 1.2rem;
        }

        .filter-form h3 i {
            color: #4361ee;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            align-items: end;
        }

        .form-group {
            text-align: left;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: #2b2d42;
            font-weight: 600;
            font-size: 0.9rem;
        }

        input[type="text"], select {
            width: 100%;
            padding: 0.8rem 1rem;
            border-radius: 8px;
            border: 2px solid #e5e7eb;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: white;
        }

        input[type="text"]:focus, select:focus {
            outline: none;
            border-color: #4361ee;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        .filter-btn {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            text-decoration: none;
            padding: 0.8rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
            border: none;
            cursor: pointer;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.8rem;
        }

        .filter-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* Table Styling */
        .applications-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin: 2rem 0;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }

        .applications-table th {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            padding: 1.2rem 1rem;
            text-align: left;
            font-weight: 600;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .applications-table th:first-child {
            border-top-left-radius: 10px;
        }

        .applications-table th:last-child {
            border-top-right-radius: 10px;
        }

        .applications-table td {
            padding: 1.2rem 1rem;
            border-bottom: 1px solid #e5e7eb;
            vertical-align: middle;
            transition: all 0.3s ease;
        }

        .applications-table tr:last-child td {
            border-bottom: none;
        }

        .applications-table tr:hover td {
            background-color: #f8f9ff;
            transform: translateX(5px);
        }

        .applicant-name {
            font-weight: 600;
            color: #2b2d42;
            font-size: 1rem;
        }

        .applicant-email {
            color: #6b7280;
            font-size: 0.85rem;
            margin-top: 0.2rem;
        }

        .job-title {
            font-weight: 600;
            color: #2b2d42;
            font-size: 1rem;
        }

        .resume-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: linear-gradient(45deg, #3b82f6, #1d4ed8);
            color: white;
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.85rem;
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
            font-size: 0.9rem;
            background: #f8f9fa;
            padding: 0.4rem 0.8rem;
            border-radius: 6px;
            display: inline-block;
        }

        /* Status Badge */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85rem;
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

        /* Action Buttons in Table */
        .table-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .table-actions a {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            text-decoration: none;
            padding: 0.5rem 0.8rem;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.8rem;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .view-btn {
            background: linear-gradient(45deg, #3b82f6, #1d4ed8);
            color: white;
            box-shadow: 0 3px 10px rgba(59, 130, 246, 0.3);
        }

        .view-btn:hover {
            background: linear-gradient(45deg, #1d4ed8, #3b82f6);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(59, 130, 246, 0.4);
        }

        .update-btn {
            background: linear-gradient(45deg, #10b981, #059669);
            color: white;
            box-shadow: 0 3px 10px rgba(16, 185, 129, 0.3);
        }

        .update-btn:hover {
            background: linear-gradient(45deg, #059669, #10b981);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(16, 185, 129, 0.4);
        }

        .reject-btn {
            background: linear-gradient(45deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 3px 10px rgba(239, 68, 68, 0.3);
        }

        .reject-btn:hover {
            background: linear-gradient(45deg, #dc2626, #ef4444);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(239, 68, 68, 0.4);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: #6b7280;
        }

        .empty-state i {
            font-size: 3rem;
            color: #d1d5db;
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            color: #4b5563;
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            margin-bottom: 1.5rem;
        }

        /* Stats Banner */
        .stats-banner {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
        }

        .stats-banner i {
            font-size: 1.2rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }
            
            .applications-container {
                padding: 2rem;
            }
            
            h2 {
                font-size: 1.6rem;
            }
            
            .applications-table {
                display: block;
                overflow-x: auto;
            }
            
            .applications-table th,
            .applications-table td {
                padding: 1rem 0.8rem;
                font-size: 0.9rem;
            }
            
            .header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .action-buttons {
                flex-direction: column;
                width: 100%;
            }
            
            .action-buttons a {
                width: 100%;
                justify-content: center;
            }
            
            .filter-grid {
                grid-template-columns: 1fr;
            }
            
            .table-actions {
                flex-direction: column;
            }
            
            .table-actions a {
                width: 100%;
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .applications-container {
                padding: 1.5rem;
            }
            
            h2 {
                font-size: 1.4rem;
            }
            
            h2 i {
                font-size: 1.5rem;
            }
            
            .action-buttons a {
                padding: 0.7rem 1rem;
                font-size: 0.9rem;
            }
            
            .stats-banner {
                padding: 0.8rem 1rem;
                font-size: 0.9rem;
            }
            
            .filter-form {
                padding: 1rem;
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

        .applications-table tr:nth-child(1) { animation-delay: 0.1s; }
        .applications-table tr:nth-child(2) { animation-delay: 0.2s; }
        .applications-table tr:nth-child(3) { animation-delay: 0.3s; }
        .applications-table tr:nth-child(4) { animation-delay: 0.4s; }
        .applications-table tr:nth-child(5) { animation-delay: 0.5s; }

        /* Success/Error Messages */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            animation: slideIn 0.5s ease-out;
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

<div class="applications-container">
    <div class="header">
        <h2><i class="fas fa-file-alt"></i> Applications for Your Jobs</h2>
        
        <div class="stats-banner">
            <i class="fas fa-users"></i>
            <span>Review and manage job applications</span>
        </div>
    </div>

    <div class="action-buttons">
        <a href="employerDashboard.jsp">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
        <a href="postJob.jsp">
            <i class="fas fa-plus-circle"></i> Post New Job
        </a>
        
    </div>

    <div class="filter-form">
        <h3><i class="fas fa-filter"></i> Filter Applications</h3>
        <form class="filter-grid" method="get" action="viewApplications.jsp">
            <div class="form-group">
                <label class="form-label">Job Title</label>
                <input type="text" name="jobTitle" placeholder="Search by job title">
            </div>
            
            <div class="form-group">
                <label class="form-label">Status</label>
                <select name="status">
                    <option value="">All Status</option>
                    <option value="APPLIED">Applied</option>
                    <option value="SHORTLISTED">Shortlisted</option>
                    <option value="REJECTED">Rejected</option>
                    <option value="UNDER REVIEW">Under Review</option>
                </select>
            </div>
            
            <div class="form-group">
                <button type="submit" class="filter-btn">
                    <i class="fas fa-search"></i> Filter Applications
                </button>
            </div>
        </form>
    </div>

<%
    // Fetch applications again with optional filters
    String filterJob = request.getParameter("jobTitle");
    String filterStatus = request.getParameter("status");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
            "root", ""
        );

        String sql = "SELECT a.id AS app_id, j.title AS job_title, u.name AS applicant_name, " +
                     "u.email AS applicant_email, a.resume, a.cover_letter, a.applied_at, a.status " +
                     "FROM applications a " +
                     "JOIN jobs j ON a.job_id = j.id " +
                     "JOIN users u ON a.jobseeker_id = u.id " +
                     "WHERE j.employer_id=? ";

        if (filterJob != null && !filterJob.isEmpty()) {
            sql += "AND j.title LIKE ? ";
        }
        if (filterStatus != null && !filterStatus.isEmpty()) {
            sql += "AND a.status=? ";
        }

        sql += "ORDER BY a.applied_at DESC";

        ps = con.prepareStatement(sql);
        ps.setInt(1, employerId);

        int paramIndex = 2;
        if (filterJob != null && !filterJob.isEmpty()) {
            ps.setString(paramIndex++, "%" + filterJob + "%");
        }
        if (filterStatus != null && !filterStatus.isEmpty()) {
            ps.setString(paramIndex++, filterStatus);
        }

        rs = ps.executeQuery();
        
        boolean hasApplications = false;
%>

    <table class="applications-table">
        <thead>
            <tr>
                <th style="width: 20%;">Applicant</th>
                <th style="width: 20%;">Job Title</th>
                <th style="width: 15%;">Resume</th>
                <th style="width: 15%;">Applied Date</th>
                <th style="width: 15%;">Status</th>
                <th style="width: 15%;">Actions</th>
            </tr>
        </thead>
        <tbody>
<%
        while(rs.next()) {
            hasApplications = true;
            String appliedDate = rs.getTimestamp("applied_at").toString();
            if (appliedDate.length() > 16) {
                appliedDate = appliedDate.substring(0, 16);
            }
            String status = rs.getString("status");
            String statusClass = "";
            switch(status) {
                case "APPLIED": statusClass = "status-applied"; break;
                case "SHORTLISTED": statusClass = "status-shortlisted"; break;
                case "REJECTED": statusClass = "status-rejected"; break;
                case "UNDER REVIEW": statusClass = "status-under-review"; break;
            }
%>
        <tr>
            <td>
                <div class="applicant-name"><%= rs.getString("applicant_name") %></div>
                <div class="applicant-email"><%= rs.getString("applicant_email") %></div>
            </td>
            <td>
                <div class="job-title"><%= rs.getString("job_title") %></div>
            </td>
            <td>
                <a href="<%= rs.getString("resume") %>" target="_blank" class="resume-link">
                    <i class="fas fa-file-pdf"></i> View Resume
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
                <div class="table-actions">
                    <a class="view-btn" href="viewApplicationDetails.jsp?id=<%= rs.getInt("app_id") %>">
                        <i class="fas fa-eye"></i> View
                    </a>
                    <a class="update-btn" href="updateApplicationStatus?id=<%= rs.getInt("app_id") %>&status=SHORTLISTED">
                        <i class="fas fa-check"></i> Shortlist
                    </a>
                    <a class="reject-btn" href="updateApplicationStatus?id=<%= rs.getInt("app_id") %>&status=REJECTED">
                        <i class="fas fa-times"></i> Reject
                    </a>
                </div>
            </td>
        </tr>
<%
        }
        
        if (!hasApplications) {
%>
        <tr>
            <td colspan="6">
                <div class="empty-state">
                    <i class="fas fa-folder-open"></i>
                    <h3>No Applications Found</h3>
                    <p>No applications match your current filter criteria.</p>
                </div>
            </td>
        </tr>
<%
        }
    } catch(Exception e){
%>
        <tr>
            <td colspan="6">
                <div class="empty-state">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Error Loading Applications</h3>
                    <p>There was an error loading applications. Please try again later.</p>
                </div>
            </td>
        </tr>
<%
    } finally {
        if(rs != null) rs.close();
        if(ps != null) ps.close();
        if(con != null) con.close();
    }
%>
        </tbody>
    </table>
</div>

<script>
    // Confirm action for reject buttons
    document.querySelectorAll('.reject-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            if (!confirm('Are you sure you want to reject this application? This action cannot be undone.')) {
                e.preventDefault();
            }
        });
    });

    // Add loading state to action buttons
    document.querySelectorAll('.table-actions a').forEach(btn => {
        btn.addEventListener('click', function(e) {
            const isReject = this.classList.contains('reject-btn');
            if (!isReject || confirm('Are you sure you want to reject this application?')) {
                const originalText = this.innerHTML;
                const action = this.classList.contains('view-btn') ? 'Viewing...' : 
                             this.classList.contains('update-btn') ? 'Shortlisting...' : 'Rejecting...';
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ' + action;
                this.style.pointerEvents = 'none';
                
                // Reset after 5 seconds if something goes wrong
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.style.pointerEvents = 'auto';
                }, 5000);
            } else {
                e.preventDefault();
            }
        });
    });

    // Preserve filter values
    const urlParams = new URLSearchParams(window.location.search);
    const jobTitle = urlParams.get('jobTitle');
    const status = urlParams.get('status');
    
    if (jobTitle) {
        document.querySelector('input[name="jobTitle"]').value = jobTitle;
    }
    if (status) {
        document.querySelector('select[name="status"]').value = status;
    }

    // Add hover effects to table rows
    document.querySelectorAll('.applications-table tbody tr').forEach(row => {
        row.addEventListener('mouseenter', function() {
            this.style.cursor = 'pointer';
        });
    });

    // Filter form submission loading state
    document.querySelector('.filter-form form').addEventListener('submit', function(e) {
        const filterBtn = this.querySelector('.filter-btn');
        const originalText = filterBtn.innerHTML;
        filterBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Filtering...';
        filterBtn.style.pointerEvents = 'none';
        
        // Reset after 3 seconds if something goes wrong
        setTimeout(() => {
            filterBtn.innerHTML = originalText;
            filterBtn.style.pointerEvents = 'auto';
        }, 3000);
    });
</script>
</body>
</html>