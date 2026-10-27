<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    // Protect page: only ADMIN can access
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) {
        response.sendRedirect("index.jsp"); // redirect to login if not admin
    }
%>

<html>
<head>
    <title>Manage Users - JobPortal</title>
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
            min-height: 100vh;
            padding: 20px;
        }

        /* Page Header */
        .page-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .page-header h2 {
            font-size: 2rem;
            color: #2b2d42;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }

        .page-header p {
            color: #6c757d;
            font-size: 1rem;
        }

        /* Table Container */
        .table-container {
            background: white;
            border-radius: 12px;
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
        .user-id {
            color: #4361ee;
            font-weight: 600;
            font-family: 'Courier New', monospace;
        }

        .user-name {
            color: #2b2d42;
            font-weight: 600;
        }

        .user-email {
            color: #6b7280;
            font-size: 0.9rem;
        }

        .user-role {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .role-admin {
            background: rgba(67, 97, 238, 0.1);
            color: #4361ee;
        }

        .role-jobseeker {
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
        }

        .role-employer {
            background: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.8rem;
        }

        .action-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            padding: 0.6rem 1.2rem;
            border-radius: 6px;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }

        .action-btn.edit {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
        }

        .action-btn.edit:hover {
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
        }

        .action-btn.delete {
            background: linear-gradient(45deg, #ef4444, #dc2626);
            color: white;
        }

        .action-btn.delete:hover {
            background: linear-gradient(45deg, #dc2626, #ef4444);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(239, 68, 68, 0.3);
        }

        /* Back Button */
        .back-btn-container {
            text-align: center;
            margin-top: 2rem;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: linear-gradient(45deg, #6b7280, #4b5563);
            color: white;
            text-decoration: none;
            padding: 0.8rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(107, 114, 128, 0.3);
        }

        .back-btn:hover {
            background: linear-gradient(45deg, #4b5563, #6b7280);
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(107, 114, 128, 0.4);
        }

        /* Error Message */
        .error-message {
            background: #fee2e2;
            border: 1px solid #fecaca;
            border-radius: 8px;
            padding: 1rem;
            margin: 1rem 0;
            color: #dc2626;
            text-align: center;
            font-size: 0.9rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 15px;
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
            
            .action-buttons {
                flex-direction: column;
            }
            
            .action-btn {
                padding: 0.5rem 1rem;
                font-size: 0.85rem;
            }
        }

        @media (max-width: 480px) {
            .page-header h2 {
                font-size: 1.4rem;
            }
            
            th, td {
                padding: 0.8rem;
                font-size: 0.85rem;
            }
            
            .back-btn {
                padding: 0.7rem 1.5rem;
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
    <div class="page-header">
        <h2>Manage Users</h2>
        <p>View and manage all registered users in the system</p>
    </div>
    
    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root",
                ""
            );
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(
            	    "SELECT id, name, email, role, status FROM users"
            	);


            out.println("<div class='table-container'>");
            out.println("<table>");
            out.println("<thead>");
            out.println("<tr>");
            out.println("<th>ID</th>");
            out.println("<th>Name</th>");
            out.println("<th>Email</th>");
            out.println("<th>Role</th>");
            out.println("<th>Actions</th>");
            out.println("</tr>");
            out.println("</thead>");
            out.println("<tbody>");
            while(rs.next()) {
            	
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String userRole = rs.getString("role"); // renamed variable to avoid duplicate
                
                String roleClass = "";
                if (userRole.equals("ADMIN")) {
                    roleClass = "role-admin";
                } else if (userRole.equals("JOBSEEKER")) {
                    roleClass = "role-jobseeker";
                } else if (userRole.equals("EMPLOYER")) {
                    roleClass = "role-employer";
                }

                out.println("<tr>");
                out.println("<td><span class='user-id'>#" + id + "</span></td>");
                out.println("<td><div class='user-name'>" + name + "</div></td>");
                out.println("<td><div class='user-email'>" + email + "</div></td>");
                out.println("<td><span class='user-role " + roleClass + "'>" + userRole + "</span></td>");
                out.println("<td>");
                out.println("<div class='action-buttons'>");
                out.println("<a href='editUser.jsp?id=" + id + "' class='action-btn edit'><i class='fas fa-edit'></i> Edit</a>");
                out.println("<a href='deleteUser?id=" + id + "' class='action-btn delete'><i class='fas fa-trash'></i> Delete</a>");
                out.println("</div>");
                out.println("</td>");
                out.println("</tr>");
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
        <a href="adminDashboard.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
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

        // Confirm before deletion
        document.querySelectorAll('.action-btn.delete').forEach(btn => {
            btn.addEventListener('click', function(e) {
                if(!confirm('Are you sure you want to delete this user? This action cannot be undone.')) {
                    e.preventDefault();
                }
            });
        });

        // Add loading state for delete buttons
        document.querySelectorAll('.action-btn.delete').forEach(btn => {
            btn.addEventListener('click', function() {
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Deleting...';
                this.style.pointerEvents = 'none';
                
                // Reset after 5 seconds if something goes wrong
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.style.pointerEvents = 'auto';
                }, 5000);
            });
        });
    </script>
</body>
</html>