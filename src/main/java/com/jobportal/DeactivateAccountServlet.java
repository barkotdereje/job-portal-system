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

public class DeactivateAccountServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

            PreparedStatement ps = con.prepareStatement("UPDATE users SET status='INACTIVE' WHERE id=?");
            ps.setInt(1, employerId);
            ps.executeUpdate();
            con.close();

            // Invalidate session after deactivation
            session.invalidate();

            response.sendRedirect("login.jsp?success=deactivated");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("employerProfile.jsp?error=server");
        }
    }
}
