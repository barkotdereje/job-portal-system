package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ViewCVServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        System.out.println("VIEW CV → userId = " + userId);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = java.sql.DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", ""
            );

            PreparedStatement ps = con.prepareStatement(
                "SELECT skills, education, experience, resume, created_at " +
                "FROM cv WHERE user_id=? ORDER BY id DESC LIMIT 1"
            );

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("skills", rs.getString("skills"));
                request.setAttribute("education", rs.getString("education"));
                request.setAttribute("experience", rs.getString("experience"));
                request.setAttribute("resume", rs.getString("resume"));
                request.setAttribute("createdAt", rs.getString("created_at"));
            } else {
                request.setAttribute("error", "No CV found. Please build your CV first.");
            }

            rs.close();
            ps.close();
            con.close();

            request.getRequestDispatcher("cv/viewCV.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jobseekerDashboard.jsp?error=server");
        }
    }
}
