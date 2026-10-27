<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    // Only allow admin
    String role = (String) session.getAttribute("role");
    if (!"ADMIN".equals(role)) {
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

        String sql = "SELECT id, name, email, company_name, contact_number, approved, status, created_at FROM users WHERE role='EMPLOYER' ORDER BY created_at DESC";
        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();
%>

<html>
<head><title>Employers List</title></head>
<body>
<h2>Employer Accounts</h2>
<a href="createEmployer.jsp">Create New Employer</a><br><br>
<table border="1" cellpadding="5">
<tr>
    <th>ID</th>
    <th>Name</th>
    <th>Email</th>
    <th>Company</th>
    <th>Contact</th>
    <th>Approved</th>
    <th>Status</th>
    <th>Created At</th>
    <th>Actions</th>
</tr>
<%
    while(rs.next()) {
%>
<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getString("name") %></td>
    <td><%= rs.getString("email") %></td>
    <td><%= rs.getString("company_name") %></td>
    <td><%= rs.getString("contact_number") %></td>
    <td><%= rs.getInt("approved") == 1 ? "Yes" : "No" %></td>
    <td><%= rs.getString("status") %></td>
    <td><%= rs.getTimestamp("created_at") %></td>
    <td>
        <a href="editEmployer?id=<%= rs.getInt("id") %>">Edit</a> |
        <a href="deleteEmployer?id=<%= rs.getInt("id") %>" onclick="return confirm('Delete this employer?');">Delete</a>
    </td>
</tr>
<%
    }
} catch(Exception e){
    out.println("Error: " + e.getMessage());
} finally {
    if(rs!=null) rs.close();
    if(ps!=null) ps.close();
    if(con!=null) con.close();
}
%>
</table>
</body>
</html>
