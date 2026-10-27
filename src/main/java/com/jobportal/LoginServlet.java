package com.jobportal;


import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {


    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", ""
            );

            // ✅ INCLUDE name IN QUERY
            String sql = "SELECT id, name, role FROM users WHERE email=? AND password=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {

                HttpSession session = req.getSession(true);

                int userId = rs.getInt("id");
                String name = rs.getString("name");
                String role = rs.getString("role");

                // ✅ COMMON SESSION DATA
                session.setAttribute("userId", userId);
                session.setAttribute("name", name);
                session.setAttribute("role", role);

                // ✅ ROLE BASED LOGIN
                if ("EMPLOYER".equalsIgnoreCase(role)) {
                    session.setAttribute("employerId", userId);
                    session.setAttribute("employerName", name);
                    res.sendRedirect("employerDashboard.jsp");

                } else if ("ADMIN".equalsIgnoreCase(role)) {
                    res.sendRedirect("adminDashboard.jsp");

                } else {
                    res.sendRedirect("jobseekerDashboard.jsp");
                }

            } else {
                // ❌ INVALID LOGIN
                res.sendRedirect("login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("login.jsp?error=server");

        } finally {
            try { if (rs != null) {
				rs.close();
			} } catch (Exception e) {}
            try { if (ps != null) {
				ps.close();
			} } catch (Exception e) {}
            try { if (con != null) {
				con.close();
			} } catch (Exception e) {}
        }
    }
}
