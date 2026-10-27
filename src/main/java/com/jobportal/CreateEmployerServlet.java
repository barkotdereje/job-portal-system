package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CreateEmployerServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String companyName = req.getParameter("company_name");
        String contact = req.getParameter("contact_number");
        int approved = Integer.parseInt(req.getParameter("approved"));
        String status = req.getParameter("status");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", ""
            );

            String sql = "INSERT INTO users (name, email, password, role, company_name, contact_number, approved, status) " +
                         "VALUES (?, ?, ?, 'EMPLOYER', ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, companyName);
            ps.setString(5, contact);
            ps.setInt(6, approved);
            ps.setString(7, status);
            ps.executeUpdate();
            con.close();

            res.sendRedirect("listEmployers");
        } catch(Exception e) {
            e.printStackTrace();
            res.getWriter().println("Error creating employer: " + e.getMessage());
        }
    }
}
