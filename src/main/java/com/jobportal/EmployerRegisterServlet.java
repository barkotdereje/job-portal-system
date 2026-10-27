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

public class EmployerRegisterServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", ""
            );

            // Check if email exists
            PreparedStatement check = con.prepareStatement("SELECT * FROM users WHERE email=?");
            check.setString(1, email);
            ResultSet rs = check.executeQuery();
            if(rs.next()) {
                res.getWriter().println("Email already registered!");
                return;
            }

            // Insert employer
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(name,email,password,role,is_approved) VALUES(?,?,?,?,?)"
            );
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, "EMPLOYER");
            ps.setInt(5, 0); // pending admin approval
            ps.executeUpdate();
            con.close();

            res.getWriter().println("Registration successful! Wait for admin approval.");
        } catch(Exception e){
            e.printStackTrace();
            res.getWriter().println("Error: "+e.getMessage());
        }
    }
}
