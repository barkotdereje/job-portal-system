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

        String sql = "SELECT id, title, description, created_at FROM jobs WHERE employer_id=? ORDER BY created_at DESC";
        ps = con.prepareStatement(sql);
        ps.setInt(1, employerId);
        rs = ps.executeQuery();
%>

<html>
<head>
    <title>Manage Jobs - JobPortal</title>
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
        .container {
            background: white;
            border-radius: 15px;
            padding: 3rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 1200px;
            position: relative;
            overflow: hidden;
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
        }

        /* Action Buttons Container */
        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .action-buttons a {
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
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
        }

        .action-buttons a:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        .action-buttons a.back {
            background: white;
            color: #4361ee;
            border: 2px solid #4361ee;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
        }

        .action-buttons a.back:hover {
            background: #4361ee;
            color: white;
        }

        /* Table Styling */
        .jobs-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin: 2rem 0;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }

        .jobs-table th {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            padding: 1.2rem 1rem;
            text-align: left;
            font-weight: 600;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .jobs-table th:first-child {
            border-top-left-radius: 10px;
        }

        .jobs-table th:last-child {
            border-top-right-radius: 10px;
        }

        .jobs-table td {
            padding: 1.2rem 1rem;
            border-bottom: 1px solid #e5e7eb;
            vertical-align: top;
            transition: all 0.3s ease;
        }

        .jobs-table tr:last-child td {
            border-bottom: none;
        }

        .jobs-table tr:hover td {
            background-color: #f8f9ff;
            transform: translateX(5px);
        }

        .job-id {
            color: #6b7280;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .job-title {
            font-weight: 600;
            color: #2b2d42;
            font-size: 1.1rem;
            margin-bottom: 0.3rem;
        }

        .job-description {
            color: #6b7280;
            font-size: 0.95rem;
            line-height: 1.5;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .job-date {
            color: #6b7280;
            font-size: 0.9rem;
            background: #f8f9fa;
            padding: 0.4rem 0.8rem;
            border-radius: 6px;
            display: inline-block;
        }

        /* Action Buttons in Table */
        .table-actions {
            display: flex;
            gap: 0.8rem;
        }

        .table-actions a {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            padding: 0.6rem 1rem;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .edit-btn {
            background: linear-gradient(45deg, #10b981, #059669);
            color: white;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        .edit-btn:hover {
            background: linear-gradient(45deg, #059669, #10b981);
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(16, 185, 129, 0.4);
        }

        .delete-btn {
            background: linear-gradient(45deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        }

        .delete-btn:hover {
            background: linear-gradient(45deg, #dc2626, #ef4444);
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(239, 68, 68, 0.4);
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
            
            .container {
                padding: 2rem;
            }
            
            h2 {
                font-size: 1.6rem;
            }
            
            .jobs-table {
                display: block;
                overflow-x: auto;
            }
            
            .jobs-table th,
            .jobs-table td {
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
            
            .table-actions {
                flex-direction: column;
            }
            
            .table-actions a {
                width: 100%;
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 1.5rem;
            }
            
            h2 {
                font-size: 1.4rem;
            }
            
            h2 i {
                font-size: 1.5rem;
            }
            
            .action-buttons a {
                padding: 0.8rem 1rem;
                font-size: 0.9rem;
            }
            
            .stats-banner {
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

        .jobs-table tr {
            animation: fadeIn 0.6s ease-out;
        }

        .jobs-table tr:nth-child(1) { animation-delay: 0.1s; }
        .jobs-table tr:nth-child(2) { animation-delay: 0.2s; }
        .jobs-table tr:nth-child(3) { animation-delay: 0.3s; }
        .jobs-table tr:nth-child(4) { animation-delay: 0.4s; }
        .jobs-table tr:nth-child(5) { animation-delay: 0.5s; }

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

<div class="container">
    <div class="header">
        <h2><i class="fas fa-tasks"></i> Manage Your Job Listings</h2>
        
        <div class="stats-banner">
            <i class="fas fa-briefcase"></i>
            <span>Manage and update your job postings</span>
        </div>
    </div>

    <div class="action-buttons">
        <a href="postJob.jsp">
            <i class="fas fa-plus-circle"></i> Post New Job
        </a>
        <a href="employerDashboard.jsp" class="back">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <table class="jobs-table">
        <thead>
            <tr>
                <th style="width: 8%;">ID</th>
                <th style="width: 20%;">Job Title</th>
                <th style="width: 40%;">Description</th>
                <th style="width: 15%;">Created At</th>
                <th style="width: 17%;">Actions</th>
            </tr>
        </thead>
        <tbody>
<%
        boolean hasJobs = false;
        while (rs.next()) {
            hasJobs = true;
            String createdAt = rs.getTimestamp("created_at").toString();
            // Format the date to be more readable
            if (createdAt.length() > 16) {
                createdAt = createdAt.substring(0, 16); // Show date and time without seconds
            }
%>
            <tr>
                <td>
                    <div class="job-id">#<%= rs.getInt("id") %></div>
                </td>
                <td>
                    <div class="job-title"><%= rs.getString("title") %></div>
                </td>
                <td>
                    <div class="job-description"><%= rs.getString("description") %></div>
                </td>
                <td>
                    <div class="job-date"><%= createdAt %></div>
                </td>
                <td>
                    <div class="table-actions">
                        <a class="edit-btn" href="editJob.jsp?id=<%= rs.getInt("id") %>">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                        <a class="delete-btn" href="deleteJobEmployer?id=<%= rs.getInt("id") %>"
                           onclick="return confirmDelete()">
                            <i class="fas fa-trash-alt"></i> Delete
                        </a>
                    </div>
                </td>
            </tr>
<%
        }
        
        if (!hasJobs) {
%>
            <tr>
                <td colspan="5">
                    <div class="empty-state">
                        <i class="fas fa-folder-open"></i>
                        <h3>No Jobs Posted Yet</h3>
                        <p>You haven't posted any job listings yet. Start by posting your first job!</p>
                        <a href="postJob.jsp" class="action-buttons" style="display: inline-flex; margin-top: 1rem;">
                            <i class="fas fa-plus-circle"></i> Post Your First Job
                        </a>
                    </div>
                </td>
            </tr>
<%
        }
    } catch(Exception e) {
%>
        <tr>
            <td colspan="5">
                <div class="empty-state">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Error Loading Jobs</h3>
                    <p>There was an error loading your job listings. Please try again later.</p>
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

<script>
    // Confirm delete action
    function confirmDelete() {
        return confirm('Are you sure you want to delete this job? This action cannot be undone.');
    }

    // Add hover effects to table rows
    document.querySelectorAll('.jobs-table tbody tr').forEach(row => {
        row.addEventListener('mouseenter', function() {
            this.style.cursor = 'pointer';
        });
    });

    // Add loading state to action buttons
    document.querySelectorAll('.table-actions a').forEach(btn => {
        btn.addEventListener('click', function(e) {
            if (!this.classList.contains('delete-btn') || confirmDelete()) {
                const originalText = this.innerHTML;
                const isDelete = this.classList.contains('delete-btn');
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ' + (isDelete ? 'Deleting...' : 'Loading...');
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

    // Add loading state to top action buttons
    document.querySelectorAll('.action-buttons a').forEach(btn => {
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
</script>

</body>
</html>