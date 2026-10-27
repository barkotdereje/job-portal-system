package com.jobportal;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024*1024, maxFileSize = 5*1024*1024, maxRequestSize = 10*1024*1024)
public class JobSeekerProfileServlet extends HttpServlet {

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
                "root", ""
            );

            if ("updateUser".equals(action)) {
                // Update basic user info
                String name = request.getParameter("fullName");
                String email = request.getParameter("email");

                String sql = "UPDATE users SET name=?, email=? WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setInt(3, userId);
                ps.executeUpdate();

                session.setAttribute("message", "Profile updated successfully.");

            } else if ("updateCV".equals(action)) {
                // Update CV info
                String skills = request.getParameter("skills");
                String education = request.getParameter("education");
                String experience = request.getParameter("experience");

                String sql = "UPDATE cv SET skills=?, education=?, experience=? WHERE user_id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, skills);
                ps.setString(2, education);
                ps.setString(3, experience);
                ps.setInt(4, userId);
                ps.executeUpdate();

                session.setAttribute("message", "CV updated successfully.");

            } else if ("uploadResume".equals(action)) {
                Part filePart = request.getPart("resume");
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
					uploadDir.mkdir();
				}
                filePart.write(uploadPath + File.separator + fileName);

                String sql = "UPDATE cv SET resume=? WHERE user_id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, "uploads/" + fileName);
                ps.setInt(2, userId);
                ps.executeUpdate();

                session.setAttribute("message", "Resume uploaded successfully.");

            } else if ("delete".equals(action)) {
                String sql = "DELETE FROM users WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.executeUpdate();

                session.invalidate();
                response.sendRedirect("login.jsp");
                return;
            }else if ("uploadResume".equals(action)) {
                Part filePart = request.getPart("resume");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
						uploadDir.mkdir();
					}

                    filePart.write(uploadPath + File.separator + fileName);

                    String sql = "UPDATE cv SET resume=? WHERE user_id=?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setString(1, "uploads/" + fileName);
                    ps.setInt(2, userId);
                    ps.executeUpdate();

                    session.setAttribute("message", "Resume uploaded successfully.");
                } else {
                    session.setAttribute("error", "Please select a file to upload.");
                }
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
        response.sendRedirect("jobSeekerProfile.jsp");
    }
}
