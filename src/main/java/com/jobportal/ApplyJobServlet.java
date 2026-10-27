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

public class ApplyJobServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Check session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null ||
            !"JOBSEEKER".equals(session.getAttribute("role"))) {
            res.sendRedirect("login.jsp");
            return;
        }

        int jobSeekerId = (Integer) session.getAttribute("userId");

        // Get form parameters
        String jobIdParam = req.getParameter("jobId");
        String coverLetter = req.getParameter("coverLetter");
        String resume = req.getParameter("resume"); // optional if you have a resume field
        String contactEmail = req.getParameter("contactEmail"); // optional
        String notes = req.getParameter("notes"); // optional

        if(jobIdParam == null || coverLetter == null || coverLetter.trim().isEmpty()) {
            res.getWriter().println("Error: Missing job ID or cover letter.");
            return;
        }

        int jobId = Integer.parseInt(jobIdParam);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                    "root",
                    ""
            );

            // Insert application into database
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO applications(job_id, jobseeker_id, resume, cover_letter, status, contact_email, notes, applied_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())"
            );
            ps.setInt(1, jobId);
            ps.setInt(2, jobSeekerId);
            ps.setString(3, resume); // if null, DB should accept null
            ps.setString(4, coverLetter);
            ps.setString(5, "Pending"); // default status
            ps.setString(6, contactEmail);
            ps.setString(7, notes);

            int rows = ps.executeUpdate();
            if(rows > 0){
                res.sendRedirect("jobseekerDashboard.jsp?msg=Application+submitted+successfully");
            } else {
                res.getWriter().println("Error: Could not submit application.");
            }

            ps.close();
            con.close();

        } catch(Exception e) {
            e.printStackTrace();
            res.getWriter().println("Error: " + e.getMessage());
        }
    }
}
