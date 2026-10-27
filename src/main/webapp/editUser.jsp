<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<html>
<head>
    <title>Edit User</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Modern Reset */
        * {margin:0;padding:0;box-sizing:border-box;}
        body {font-family:'Poppins',sans-serif;background:linear-gradient(135deg,#f5f7fa 0%,#c3cfe2 100%);color:#333;line-height:1.6;min-height:100vh;display:flex;justify-content:center;align-items:center;padding:20px;}
        
        /* Container */
        .container {max-width:500px;width:100%;}
        
        /* Header */
        h2 {font-size:1.8rem;color:#2b2d42;margin-bottom:1.5rem;font-weight:700;background:linear-gradient(45deg,#4361ee,#3a0ca3);-webkit-background-clip:text;-webkit-text-fill-color:transparent;display:flex;align-items:center;gap:0.8rem;padding-bottom:0.5rem;border-bottom:3px solid #e5e7eb;text-align:center;justify-content:center;}
        
        /* Form Card */
        form {background:white;padding:2.5rem;border-radius:12px;box-shadow:0 5px 25px rgba(0,0,0,0.1);border-left:4px solid #4361ee;animation:fadeIn 0.6s ease-out;}
        
        /* Form Group */
        .form-group {margin-bottom:1.5rem;}
        .form-group label {display:block;margin-bottom:0.5rem;color:#2b2d42;font-weight:600;display:flex;align-items:center;gap:0.5rem;}
        
        /* Input Fields */
        input[type="text"], input[type="email"], select {width:100%;padding:0.8rem 1rem;border:1px solid #d1d5db;border-radius:8px;font-size:1rem;font-family:'Poppins',sans-serif;transition:all 0.3s ease;}
        input[type="text"]:focus, input[type="email"]:focus, select:focus {outline:none;border-color:#4361ee;box-shadow:0 0 0 3px rgba(67,97,238,0.1);}
        
        /* Submit Button */
        input[type="submit"] {display:inline-flex;align-items:center;gap:0.8rem;background:linear-gradient(45deg,#4361ee,#3a0ca3);color:white;text-decoration:none;padding:0.8rem 1.5rem;border-radius:8px;font-weight:600;font-size:0.95rem;transition:all 0.3s ease;box-shadow:0 5px 15px rgba(67,97,238,0.3);border:none;cursor:pointer;width:100%;justify-content:center;margin-top:1rem;}
        input[type="submit"]:hover {transform:translateY(-3px);box-shadow:0 8px 20px rgba(67,97,238,0.4);background:linear-gradient(45deg,#3a0ca3,#4361ee);}
        
        /* Back Link */
        .back-link {display:inline-flex;align-items:center;gap:0.8rem;background:linear-gradient(45deg,#6b7280,#4b5563);color:white;text-decoration:none;padding:0.8rem 1.5rem;border-radius:8px;font-weight:600;font-size:0.95rem;transition:all 0.3s ease;box-shadow:0 5px 15px rgba(107,114,128,0.3);margin-top:1.5rem;width:100%;justify-content:center;}
        .back-link:hover {transform:translateY(-3px);box-shadow:0 8px 20px rgba(107,114,128,0.4);background:linear-gradient(45deg,#4b5563,#374151);}
        
        /* Error Message */
        .error-message {background:#fee2e2;color:#dc2626;padding:1rem;border-radius:8px;margin-bottom:1.5rem;border-left:4px solid #dc2626;font-weight:500;}
        
        /* Select Styling */
        select {appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%234361ee' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 1rem center;background-size:16px 16px;}
        
        /* Animation */
        @keyframes fadeIn{from{opacity:0;transform:translateY(20px);}to{opacity:1;transform:translateY(0);}}
        
        /* Responsive */
        @media (max-width:600px){body{padding:15px;}form{padding:1.5rem;}}
    </style>
</head>
<body>
    <div class="container">
        <h2><i class="fas fa-user-edit"></i> Edit User</h2>
        <%
            int id = Integer.parseInt(request.getParameter("id"));
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC","root","");
                PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id=?");
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if(rs.next()) {
        %>
        <form action="editUser" method="post">
            <input type="hidden" name="id" value="<%=id%>">
            
            <div class="form-group">
                <label><i class="fas fa-user"></i> Name:</label>
                <input type="text" name="name" value="<%=rs.getString("name")%>">
            </div>
            
            <div class="form-group">
                <label><i class="fas fa-envelope"></i> Email:</label>
                <input type="email" name="email" value="<%=rs.getString("email")%>">
            </div>
            
            <div class="form-group">
                <label><i class="fas fa-user-tag"></i> Role:</label>
                <select name="role">
                    <option value="JOBSEEKER" <%= "JOBSEEKER".equals(rs.getString("role"))?"selected":"" %>>Job Seeker</option>
                    <option value="EMPLOYER" <%= "EMPLOYER".equals(rs.getString("role"))?"selected":"" %>>Employer</option>
                    <option value="ADMIN" <%= "ADMIN".equals(rs.getString("role"))?"selected":"" %>>Admin</option>
                </select>
            </div>
            
            <input type="submit" value="Update User">
        </form>
        <%
                }
                con.close();
            } catch(Exception e) { 
        %>
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i> Error: <%= e.getMessage() %>
        </div>
        <% } %>
        
        <a href="manageUsers.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Manage Users
        </a>
    </div>
</body>
</html>