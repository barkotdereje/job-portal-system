<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    String role = (String) session.getAttribute("role");
    if(role == null || !role.equals("ADMIN")){
        response.sendRedirect("index.jsp");
        return;
    }
%>

<html>
<head>
<title>Approve Employers</title>
<style>
body{font-family:'Segoe UI'; background:#f4f6f8;}
table{width:80%; margin:40px auto; background:white; border-collapse:collapse;}
th,td{padding:15px; border-bottom:1px solid #ddd;}
th{background:#4f46e5; color:white;}
a{padding:8px 14px; text-decoration:none; color:white; border-radius:6px;}
.approve{background:#16a34a;}
</style>
</head>

<body>
<h2 style="text-align:center">Pending Employers</h2>

<table>
<tr>
    <th>ID</th>
    <th>Company Name</th>
    <th>Email</th>
    <th>Action</th>
</tr>

<%
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/job_portal","root","");

        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(
            "SELECT * FROM users WHERE role='EMPLOYER' AND status='PENDING'");

        while(rs.next()){
%>
<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getString("name") %></td>
    <td><%= rs.getString("email") %></td>
    <td>
        <a class="approve"
           href="approveEmployer?id=<%= rs.getInt("id") %>">
           Approve
        </a>
    </td>
</tr>
<%
        }
        con.close();
    }catch(Exception e){
        out.println(e.getMessage());
    }
%>
</table>
</body>
</html>
