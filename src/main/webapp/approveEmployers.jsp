<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) {
        response.sendRedirect("index.jsp"); // redirect to login if not admin
    }
%>

<html>
<head>
    <title>Approve Employers - JobPortal Admin</title>
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
        }

        /* Page Container */
        .container {
            padding: 3rem 5%;
            max-width: 1000px;
            margin: 0 auto;
        }

        /* Page Header */
        .page-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .page-header h2 {
            font-size: 2rem;
            color: #2b2d42;
            margin-bottom: 0.5rem;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .page-header p {
            color: #6c757d;
            font-size: 1rem;
        }

        /* Header/Navigation Bar - Consistent with Home Page */
        header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 1.2rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.08);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo h2 {
            color: #4361ee;
            font-size: 1.8rem;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 0;
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            text-decoration: none;
            padding: 0.7rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
        }

        .back-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* Table Container */
        .table-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
            position: relative;
        }

        .table-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #4361ee, #3a0ca3);
            z-index: 1;
        }

        /* Table Styling */
        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
        }

        th {
            padding: 1.2rem 1.5rem;
            color: white;
            font-weight: 600;
            font-size: 1rem;
            text-align: left;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 1.2rem 1.5rem;
            border-bottom: 1px solid #e5e7eb;
            color: #4b5563;
            font-size: 0.95rem;
        }

        tbody tr {
            transition: all 0.3s ease;
        }

        tbody tr:hover {
            background: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        /* User Info Styling */
        .employer-id {
            color: #4361ee;
            font-weight: 600;
            font-family: 'Courier New', monospace;
        }

        .employer-name {
            color: #2b2d42;
            font-weight: 600;
        }

        .employer-email {
            color: #6b7280;
            font-size: 0.9rem;
        }

        /* Status Badge */
        .status-badge {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            background: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
        }

        /* Approve Button */
        .approve-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: linear-gradient(45deg, #10b981, #059669);
            color: white;
            text-decoration: none;
            padding: 0.6rem 1.5rem;
            border-radius: 6px;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            box-shadow: 0 3px 10px rgba(16, 185, 129, 0.2);
        }

        .approve-btn:hover {
            background: linear-gradient(45deg, #059669, #10b981);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(16, 185, 129, 0.3);
        }

        /* Back Button Container */
        .back-btn-container {
            text-align: center;
            margin-top: 2rem;
        }

        /* No Data Message */
        .no-data {
            text-align: center;
            padding: 3rem 2rem;
            color: #6b7280;
        }

        .no-data i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #9ca3af;
        }

        .no-data h3 {
            color: #4b5563;
            margin-bottom: 0.5rem;
        }

        /* Error Message */
        .error-message {
            background: #fee2e2;
            border: 1px solid #fecaca;
            border-radius: 8px;
            padding: 1.5rem;
            margin: 2rem 0;
            color: #dc2626;
            text-align: center;
            font-size: 0.95rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            header {
                flex-direction: column;
                gap: 1rem;
                padding: 1rem;
            }
            
            .logo h2 {
                font-size: 1.5rem;
            }
            
            .logo-icon {
                width: 35px;
                height: 35px;
                font-size: 1rem;
            }
            
            .container {
                padding: 2rem 1.5rem;
            }
            
            .page-header h2 {
                font-size: 1.6rem;
            }
            
            table {
                display: block;
                overflow-x: auto;
            }
            
            th, td {
                padding: 1rem;
                font-size: 0.9rem;
            }
        }

        @media (max-width: 480px) {
            .logo h2 {
                font-size: 1.3rem;
            }
            
            .back-button {
                padding: 0.6rem 1rem;
                font-size: 0.9rem;
            }
            
            th, td {
                padding: 0.8rem;
                font-size: 0.85rem;
            }
            
            .approve-btn {
                padding: 0.5rem 1rem;
                font-size: 0.8rem;
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

        .table-container {
            animation: fadeIn 0.8s ease-out;
        }

        tbody tr {
            animation: fadeIn 0.5s ease-out;
        }
    </style>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<header>
    <div class="logo">
        <div class="logo-icon">
            <i class="fas fa-user-check"></i>
        </div>
        <h2>Approve Employers</h2>
    </div>
    <a href="adminDashboard.jsp" class="back-button">
        <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
</header>

<div class="container">
    <div class="page-header">
        <h2>Pending Employer Approvals</h2>
        <p>Review and approve employer registration requests</p>
    </div>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC","root","");
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM users WHERE role='EMPLOYER' AND approved=0");

            out.println("<div class='table-container'>");
            out.println("<table>");
            out.println("<thead>");
            out.println("<tr>");
            out.println("<th>ID</th>");
            out.println("<th>Name</th>");
            out.println("<th>Email</th>");
            out.println("<th>Status</th>");
            out.println("<th>Action</th>");
            out.println("</tr>");
            out.println("</thead>");
            out.println("<tbody>");
            
            boolean hasData = false;
            while(rs.next()) {
                hasData = true;
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                out.println("<tr>");
                out.println("<td><span class='employer-id'>#" + id + "</span></td>");
                out.println("<td><div class='employer-name'>" + name + "</div></td>");
                out.println("<td><div class='employer-email'>" + email + "</div></td>");
                out.println("<td><span class='status-badge'><i class='fas fa-clock'></i> Pending</span></td>");
                out.println("<td><a href='approveEmployer?id=" + id + "' class='approve-btn'><i class='fas fa-check'></i> Approve</a></td>");
                out.println("</tr>");
            }
            
            if (!hasData) {
                out.println("<tr><td colspan='5'>");
                out.println("<div class='no-data'>");
                out.println("<i class='fas fa-check-circle'></i>");
                out.println("<h3>No Pending Approvals</h3>");
                out.println("<p>All employers have been approved</p>");
                out.println("</div>");
                out.println("</td></tr>");
            }
            
            out.println("</tbody>");
            out.println("</table>");
            out.println("</div>");
            con.close();
        } catch(Exception e) { 
            out.println("<div class='error-message'><i class='fas fa-exclamation-circle'></i> Error: " + e.getMessage() + "</div>");
        }
    %>
    
    <div class="back-btn-container">
        <a href="adminDashboard.jsp" class="back-button">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</div>

<script>
    // Add row hover effects
    document.querySelectorAll('tbody tr').forEach(row => {
        row.addEventListener('mouseenter', function() {
            this.style.backgroundColor = '#f8f9fa';
        });
        
        row.addEventListener('mouseleave', function() {
            this.style.backgroundColor = '';
        });
    });

    // Confirm before approval
    document.querySelectorAll('.approve-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            if(!confirm('Are you sure you want to approve this employer? This will grant them full access to post jobs.')) {
                e.preventDefault();
            } else {
                // Show loading state
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Approving...';
                this.style.pointerEvents = 'none';
                
                // Reset after 5 seconds if something goes wrong
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.style.pointerEvents = 'auto';
                }, 5000);
            }
        });
    });

    // Add success message if URL contains success parameter
    const urlParams = new URLSearchParams(window.location.search);
    if(urlParams.has('success')) {
        const successDiv = document.createElement('div');
        successDiv.className = 'error-message';
        successDiv.style.background = '#d1fae5';
        successDiv.style.borderColor = '#a7f3d0';
        successDiv.style.color = '#065f46';
        successDiv.innerHTML = '<i class="fas fa-check-circle"></i> Employer approved successfully!';
        document.querySelector('.container').insertBefore(successDiv, document.querySelector('.table-container'));
        
        // Remove success parameter from URL
        setTimeout(() => {
            window.history.replaceState({}, document.title, window.location.pathname);
        }, 3000);
    }
</script>

</body>
</html>