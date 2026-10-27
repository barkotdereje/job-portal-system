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

public class EmployerLoginServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", ""
            );

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=? AND role='EMPLOYER' AND is_approved=1"
            );
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                HttpSession session = req.getSession();
                session.setAttribute("employerId", rs.getInt("id"));
                session.setAttribute("employerName", rs.getString("name"));
                session.setAttribute("role", "EMPLOYER");
                res.sendRedirect("employerDashboard.jsp");
            } else {
                res.getWriter().println("Invalid credentials or account not approved.");
            }
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
            res.getWriter().println("Error: "+e.getMessage());
        }
    }
}
