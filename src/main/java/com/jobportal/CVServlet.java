package com.jobportal;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/cv")
public class CVServlet extends HttpServlet {

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                    "root", "");

            if ("build".equals(action) || "edit".equals(action)) {
                String skills = request.getParameter("skills");
                String education = request.getParameter("education");
                String experience = request.getParameter("experience");

                if ("build".equals(action)) {
                    String sql = "INSERT INTO cv(user_id, skills, education, experience) VALUES (?, ?, ?, ?)";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setInt(1, userId);
                    ps.setString(2, skills);
                    ps.setString(3, education);
                    ps.setString(4, experience);
                    ps.executeUpdate();
                    session.setAttribute("message", "CV created successfully.");
                } else {
                    String sql = "UPDATE cv SET skills=?, education=?, experience=? WHERE user_id=?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setString(1, skills);
                    ps.setString(2, education);
                    ps.setString(3, experience);
                    ps.setInt(4, userId);
                    ps.executeUpdate();
                    session.setAttribute("message", "CV updated successfully.");
                }

            } else if ("delete".equals(action)) {
                String sql = "DELETE FROM cv WHERE user_id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.executeUpdate();
                session.setAttribute("message", "CV deleted successfully.");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Server error. Please try again.");
        }

        response.sendRedirect("jobSeekerProfile.jsp");
    }

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("download".equals(action)) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                        "root", "");

                String sql = "SELECT * FROM cv WHERE user_id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String skills = rs.getString("skills");
                    String education = rs.getString("education");
                    String experience = rs.getString("experience");

                    response.setContentType("application/octet-stream");
                    response.setHeader("Content-Disposition", "attachment;filename=MyCV.txt");

                    PrintWriter out = response.getWriter();
                    out.println("----- MY CV -----");
                    out.println("Skills: " + skills);
                    out.println("Education: " + education);
                    out.println("Experience: " + experience);
                    out.close();
                } else {
                    session.setAttribute("error", "CV not found.");
                    response.sendRedirect("jobSeekerProfile.jsp");
                }

                con.close();
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Server error. Please try again.");
                response.sendRedirect("jobSeekerProfile.jsp");
            }
        }
    }
}
