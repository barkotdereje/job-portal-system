package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class JobSeekerDashboardServlet extends HttpServlet {
    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int jobseekerId = (Integer) session.getAttribute("userId");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                    "root",
                    ""
            );

            PreparedStatement ps = con.prepareStatement(
                "SELECT a.id, j.title, a.cover_letter, a.status, a.applied_at " +
                "FROM applications a JOIN jobs j ON a.job_id = j.id " +
                "WHERE a.jobseeker_id = ? ORDER BY a.applied_at DESC"
            );

            ps.setInt(1, jobseekerId);
            ResultSet rs = ps.executeQuery();

            request.setAttribute("applications", rs);
            RequestDispatcher rd = request.getRequestDispatcher("jobseekerDashboard.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
