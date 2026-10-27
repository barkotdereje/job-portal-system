package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class EditEmployerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read ID safely
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("employerDashboard.jsp?error=invalidId");
            return;
        }
        int employerId = Integer.parseInt(idStr);

        // Read form parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String company = request.getParameter("company_name");
        String contact = request.getParameter("contact_number");

        // Approved may be null, default to 0
        String approvedStr = request.getParameter("approved");
        int approved = (approvedStr != null && !approvedStr.isEmpty()) ? Integer.parseInt(approvedStr) : 0;

        String status = request.getParameter("status");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                    "root", "");

            String sql = "UPDATE users SET name=?, email=?, company_name=?, contact_number=?, approved=?, status=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, company);
            ps.setString(4, contact);
            ps.setInt(5, approved);
            ps.setString(6, status);
            ps.setInt(7, employerId);

            int updated = ps.executeUpdate();
            System.out.println("ROWS UPDATED = " + updated);

            con.close();

            if (updated > 0) {
                response.sendRedirect("employerDashboard.jsp?success=1");
            } else {
                response.sendRedirect("employerDashboard.jsp?error=updateFailed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("employerDashboard.jsp?error=server");
        }
    }
}
