package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AdminReportServlet extends HttpServlet {
    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int totalUsers = 0, jobseekers = 0, employers = 0, jobs = 0, apps = 0;
        String errorMessage = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                    "root",
                    ""
            );

            Statement st = con.createStatement();

            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM users");
            if (rs.next()) {
				totalUsers = rs.getInt(1);
			}

            rs = st.executeQuery("SELECT COUNT(*) FROM users WHERE role='JOBSEEKER'");
            if (rs.next()) {
				jobseekers = rs.getInt(1);
			}

            rs = st.executeQuery("SELECT COUNT(*) FROM users WHERE role='EMPLOYER'");
            if (rs.next()) {
				employers = rs.getInt(1);
			}

            rs = st.executeQuery("SELECT COUNT(*) FROM jobs");
            if (rs.next()) {
				jobs = rs.getInt(1);
			}

            rs = st.executeQuery("SELECT COUNT(*) FROM applications");
            if (rs.next()) {
				apps = rs.getInt(1);
			}

            con.close();
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }

        // Set attributes to pass to JSP
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("jobseekers", jobseekers);
        request.setAttribute("employers", employers);
        request.setAttribute("jobs", jobs);
        request.setAttribute("apps", apps);
        request.setAttribute("errorMessage", errorMessage);

        // Forward request to JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("adminReports.jsp");
        dispatcher.forward(request, response);
    }
}
