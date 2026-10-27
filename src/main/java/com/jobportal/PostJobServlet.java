package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class PostJobServlet extends HttpServlet {

    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer employerId = (Integer) session.getAttribute("employerId");

        if (employerId == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String company_email = req.getParameter("company_email");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", ""
            );

            String sql = "INSERT INTO jobs (title, description,company_email, employer_id) VALUES (?, ?, ?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3,company_email);
            ps.setInt(4, employerId);
            ps.executeUpdate();

            con.close();
            res.sendRedirect("manageJobs.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println("Database Error");
        }
    }
}
