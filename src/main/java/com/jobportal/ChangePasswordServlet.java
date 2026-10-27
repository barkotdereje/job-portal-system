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

public class ChangePasswordServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer employerId = (Integer) session.getAttribute("employerId");

        if (employerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("changePassword.jsp?error=nomatch");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", ""
            );

            // Check old password
            PreparedStatement ps = con.prepareStatement(
                "SELECT password FROM users WHERE id=? AND role='EMPLOYER'"
            );
            ps.setInt(1, employerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("password");
                if (!dbPassword.equals(oldPassword)) {
                    response.sendRedirect("changePassword.jsp?error=wrongold");
                    return;
                }
            } else {
                response.sendRedirect("changePassword.jsp?error=server");
                return;
            }

            // Update new password
            ps = con.prepareStatement("UPDATE users SET password=? WHERE id=?");
            ps.setString(1, newPassword);
            ps.setInt(2, employerId);
            ps.executeUpdate();

            con.close();
            response.sendRedirect("changePassword.jsp?success=passwordChanged");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("changePassword.jsp?error=server");
        }
    }
}
