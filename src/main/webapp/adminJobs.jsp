<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    String role = (String) session.getAttribute("role");
    if(role == null || !role.equals("ADMIN")){
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin - Manage Jobs</title>
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
}

/* Header - Consistent with Home Page */
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

header h2 {
    color: #4361ee;
    font-size: 1.8rem;
    font-weight: 700;
    background: linear-gradient(45deg, #4361ee, #3a0ca3);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin: 0;
}

header a {
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

header a:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(67, 97, 238, 0.4);
    background: linear-gradient(45deg, #3a0ca3, #4361ee);
}

/* Container */
.container {
    padding: 3rem 5%;
    max-width: 1200px;
    margin: 0 auto;
}

/* Table Styling */
table {
    width: 100%;
    border-collapse: collapse;
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    position: relative;
}

table::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, #4361ee, #3a0ca3);
    z-index: 1;
}

th {
    background: linear-gradient(45deg, #4361ee, #3a0ca3);
    color: white;
    padding: 1.2rem 1.5rem;
    text-align: left;
    font-weight: 600;
    font-size: 1rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

td {
    padding: 1.2rem 1.5rem;
    border-bottom: 1px solid #e5e7eb;
    color: #4b5563;
    font-size: 0.95rem;
}

tr {
    transition: all 0.3s ease;
}

tr:hover {
    background: #f8f9fa;
}

/* Job Info Styling */
td:first-child {
    color: #4361ee;
    font-weight: 600;
    font-family: 'Courier New', monospace;
}

td:nth-child(2) {
    color: #2b2d42;
    font-weight: 500;
}

td:nth-child(3) {
    max-width: 300px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

td:nth-child(4) {
    color: #2b2d42;
    font-weight: 500;
}

/* Delete Button */
.delete-btn {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    background: linear-gradient(45deg, #ef4444, #dc2626);
    color: white;
    text-decoration: none;
    padding: 0.6rem 1.2rem;
    border-radius: 6px;
    font-weight: 500;
    font-size: 0.9rem;
    transition: all 0.3s ease;
    border: none;
    cursor: pointer;
    box-shadow: 0 3px 10px rgba(239, 68, 68, 0.2);
}

.delete-btn:hover {
    background: linear-gradient(45deg, #dc2626, #ef4444);
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(239, 68, 68, 0.3);
}

/* Error Message Styling */
.error-message {
    background: #fee2e2;
    border: 1px solid #fecaca;
    border-radius: 8px;
    padding: 1rem;
    margin-top: 1rem;
    color: #dc2626;
    text-align: center;
    font-size: 0.9rem;
}

/* Responsive Design */
@media (max-width: 768px) {
    header {
        flex-direction: column;
        gap: 1rem;
        padding: 1rem;
    }
    
    header h2 {
        font-size: 1.5rem;
    }
    
    .container {
        padding: 2rem 1.5rem;
    }
    
    table {
        display: block;
        overflow-x: auto;
    }
    
    th, td {
        padding: 1rem;
        font-size: 0.9rem;
    }
    
    td:nth-child(3) {
        max-width: 200px;
    }
}

@media (max-width: 480px) {
    header h2 {
        font-size: 1.3rem;
    }
    
    header a {
        padding: 0.6rem 1rem;
        font-size: 0.9rem;
    }
    
    th, td {
        padding: 0.8rem;
        font-size: 0.85rem;
    }
    
    .delete-btn {
        padding: 0.5rem 1rem;
        font-size: 0.8rem;
    }
}
</style>
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<!-- Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<header>
    <h2>Manage Jobs</h2>
    <a href="adminDashboard.jsp"><i class="fas fa-arrow-left"></i> Back</a>
</header>

<div class="container">

<table>
<tr>
    <th>ID</th>
    <th>Job Title</th>
    <th>Description</th>
    <th>Employer</th>
    <th>Action</th>
</tr>

<%
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
            "root",""
        );

        String sql =
        "SELECT j.id, j.title, j.description, u.name " +
        "FROM jobs j JOIN users u ON j.employer_id = u.id";

        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(sql);

        while(rs.next()){
%>
<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getString("title") %></td>
    <td><%= rs.getString("description") %></td>
    <td><%= rs.getString("name") %></td>
    <td>
        <a class="delete-btn" 
           href="deleteJob?id=<%= rs.getInt("id") %>"
           onclick="return confirm('Delete this job?');">
           <i class="fas fa-trash"></i> Delete
        </a>
    </td>
</tr>
<%
        }
        con.close();
    }catch(Exception e){
        out.println("<tr><td colspan='5'><div class='error-message'><i class='fas fa-exclamation-circle'></i> Error: " + e.getMessage() + "</div></td></tr>");
    }
%>

</table>

</div>

<script>
// Add hover effects to table rows
document.querySelectorAll('tbody tr').forEach(row => {
    row.addEventListener('mouseenter', function() {
        this.style.backgroundColor = '#f8f9fa';
    });
    
    row.addEventListener('mouseleave', function() {
        this.style.backgroundColor = '';
    });
});

// Confirm before deletion
document.querySelectorAll('.delete-btn').forEach(btn => {
    btn.addEventListener('click', function(e) {
        if(!confirm('Are you sure you want to delete this job?')) {
            e.preventDefault();
        }
    });
});
</script>

</body>
</html>