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

public class UpdateApplicationStatusServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer employerId = (Integer) session.getAttribute("employerId");
        if (employerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        String newStatus = request.getParameter("status");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                    "root", ""
            );

            // Make sure this application belongs to a job posted by this employer
            String checkSql = "SELECT j.id FROM applications a JOIN jobs j ON a.job_id=j.id WHERE a.id=? AND j.employer_id=?";
            PreparedStatement checkStmt = con.prepareStatement(checkSql);
            checkStmt.setInt(1, applicationId);
            checkStmt.setInt(2, employerId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                String updateSql = "UPDATE applications SET status=? WHERE id=?";
                PreparedStatement ps = con.prepareStatement(updateSql);
                ps.setString(1, newStatus);
                ps.setInt(2, applicationId);
                ps.executeUpdate();
                ps.close();
            }

            rs.close();
            checkStmt.close();
            con.close();

            response.sendRedirect("manageApplications.jsp?success=updated");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageApplications.jsp?error=" + e.getMessage());
        }
    }
}
