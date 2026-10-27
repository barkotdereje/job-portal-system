package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/BuildCVServlet")
public class BuildCVServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("user_id"));
        String skills = request.getParameter("skills");
        String education = request.getParameter("education");
        String experience = request.getParameter("experience");
        String resume = request.getParameter("resume");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                    "root", "");

            // Check if user already has a CV
            PreparedStatement check = con.prepareStatement("SELECT id FROM cv WHERE user_id=?");
            check.setInt(1, userId);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
            	// Update existing CV
            	PreparedStatement ps = con.prepareStatement(
            	    "UPDATE cv SET skills=?, education=?, experience=?, resume=? WHERE user_id=?"
            	);
            	ps.setString(1, skills);
            	ps.setString(2, education);
            	ps.setString(3, experience);
            	ps.setString(4, resume);
            	ps.setInt(5, userId);
            	ps.executeUpdate();


            } else {
            	// Insert new CV
            	PreparedStatement ps = con.prepareStatement(
            	    "INSERT INTO cv (user_id, skills, education, experience, resume) VALUES (?, ?, ?, ?, ?)"
            	);
            	ps.setInt(1, userId);
            	ps.setString(2, skills);
            	ps.setString(3, education);
            	ps.setString(4, experience);
            	ps.setString(5, resume);
            	ps.executeUpdate();

            }PreparedStatement psUser = con.prepareStatement(
            	    "UPDATE users SET skills=?, education=?, experience=?, resume=? WHERE id=?"
            		);
            		psUser.setString(1, skills);
            		psUser.setString(2, education);
            		psUser.setString(3, experience);
            		psUser.setString(4, resume);
            		psUser.setInt(5, userId);
            		psUser.executeUpdate();


            con.close();
            response.sendRedirect("cv/buildCV.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cv/buildCV.jsp?error=server");
        }
    }
}
