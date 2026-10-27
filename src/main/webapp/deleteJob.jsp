<%@ page import="java.sql.*" %>
<%
    String idStr = request.getParameter("id");
    if(idStr != null) {
        int id = Integer.parseInt(idStr);
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                    "root",""
            );
            PreparedStatement ps = con.prepareStatement("DELETE FROM jobs WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
            con.close();
        } catch(Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
    response.sendRedirect("adminJobs.jsp");
%>
