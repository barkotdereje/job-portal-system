package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegistrationServlet")
public class RegisterServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String contact = request.getParameter("contact_number");

        String skills = request.getParameter("skills");
        String education = request.getParameter("education");
        String experience = request.getParameter("experience");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", "");

            // Insert into users table
            String userSql = "INSERT INTO users (name, email, password, contact_number, role) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, contact);
            ps.setString(5, role);
            ps.executeUpdate();

            // Get the generated user_id
            ResultSet rs = ps.getGeneratedKeys();
            int userId = 0;
            if (rs.next()) {
                userId = rs.getInt(1);
            }

            // If Jobseeker, insert into CV table
            if ("JOBSEEKER".equals(role)) {
                String cvSql = "INSERT INTO cv (user_id, skills, education, experience) VALUES (?, ?, ?, ?)";
                PreparedStatement psCV = con.prepareStatement(cvSql);
                psCV.setInt(1, userId);
                psCV.setString(2, skills);
                psCV.setString(3, education);
                psCV.setString(4, experience);
                psCV.executeUpdate();
            }

            con.close();
            response.sendRedirect("login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
