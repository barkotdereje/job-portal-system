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

public class ViewApplicationsServlet extends HttpServlet {

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer employerId = (Integer) session.getAttribute("employerId");
        if (employerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", ""
            );

            String sql = "SELECT a.id AS app_id, j.title AS job_title, u.name AS applicant_name, " +
                         "u.email AS applicant_email, a.resume, a.cover_letter, a.applied_at, a.status " +
                         "FROM applications a " +
                         "JOIN jobs j ON a.job_id = j.id " +
                         "JOIN users u ON a.jobseeker_id = u.id " +
                         "WHERE j.employer_id=? " +
                         "ORDER BY a.applied_at DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, employerId);

            ResultSet rs = ps.executeQuery();
            request.setAttribute("applications", rs);

            // Forward to JSP
            RequestDispatcher rd = request.getRequestDispatcher("viewApplications.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error retrieving applications");
        }
    }
}
