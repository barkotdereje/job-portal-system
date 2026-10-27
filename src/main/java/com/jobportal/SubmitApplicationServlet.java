package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SubmitApplicationServlet extends HttpServlet {

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int jobId = Integer.parseInt(request.getParameter("jobId"));
        int jobseekerId = (Integer) session.getAttribute("userId");
        String resume = request.getParameter("resume");

        try {
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", ""
            );

            // 🔒 Prevent duplicate applications
            PreparedStatement check = con.prepareStatement(
                "SELECT id FROM applications WHERE jobid=? AND jobseekerid=?"
            );
            check.setInt(1, jobId);
            check.setInt(2, jobseekerId);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                response.sendRedirect("viewJobs.jsp?error=alreadyApplied");
                return;
            }

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO applications(jobid, jobseekerid, resume) VALUES (?,?,?)"
            );
            ps.setInt(1, jobId);
            ps.setInt(2, jobseekerId);
            ps.setString(3, resume);

            ps.executeUpdate();
            con.close();

            response.sendRedirect("myApplications.jsp?success=applied");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Application error");
        }
    }
}
