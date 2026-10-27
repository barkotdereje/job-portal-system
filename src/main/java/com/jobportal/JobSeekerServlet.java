package com.jobportal;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import db.DBConnection;
public class JobSeekerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
			action = "dashboard";
		}

        try {
            switch (action) {
                case "profile":
                    loadProfile(userId, request);
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                    break;
                case "cv":
                    loadCV(userId, request);
                    request.getRequestDispatcher("cv.jsp").forward(request, response);
                    break;
                case "downloadCV":
                    downloadCV(userId, response);
                    break;
                default:
                    request.getRequestDispatcher("jobseekerDashboard.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Operation failed: " + e.getMessage());
            response.sendRedirect("jobseekerDashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        try {
            switch (action) {
                case "updateProfile":
                    updateProfile(request, userId);
                    session.setAttribute("message", "Profile updated successfully");
                    break;
                case "updateCV":
                    updateCV(request, userId);
                    session.setAttribute("message", "CV updated successfully");
                    break;
                case "deleteAccount":
                    deleteAccount(userId);
                    session.invalidate();
                    response.sendRedirect("login.jsp");
                    return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Operation failed: " + e.getMessage());
        }

        response.sendRedirect("JobSeekerServlet?action=profile");
    }

    // =========================
    // METHODS
    // =========================

    private void loadProfile(int userId, HttpServletRequest request) throws Exception {
        Map<String, String> profile = new HashMap<>();
        String sql = "SELECT name, email, contact_number FROM users WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                profile.put("name", rs.getString("name"));
                profile.put("email", rs.getString("email"));
                profile.put("contact_number", rs.getString("contact_number"));
            }
        }
        request.setAttribute("profile", profile);
    }

    private void loadCV(int userId, HttpServletRequest request) throws Exception {
        Map<String, String> cv = new HashMap<>();
        String sql = "SELECT skills, education, experience, resume FROM users WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                cv.put("skills", rs.getString("skills"));
                cv.put("education", rs.getString("education"));
                cv.put("experience", rs.getString("experience"));
                cv.put("resume", rs.getString("resume"));
            }
        }
        request.setAttribute("cv", cv);
    }

    private void updateProfile(HttpServletRequest request, int userId) throws Exception {
        String name = request.getParameter("name");
        String contact = request.getParameter("contact_number");
        String sql = "UPDATE users SET name=?, contact_number=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, contact);
            ps.setInt(3, userId);
            ps.executeUpdate();
        }
    }

    private void updateCV(HttpServletRequest request, int userId) throws Exception {
        String skills = request.getParameter("skills");
        String education = request.getParameter("education");
        String experience = request.getParameter("experience");
        String sql = "UPDATE users SET skills=?, education=?, experience=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, skills);
            ps.setString(2, education);
            ps.setString(3, experience);
            ps.setInt(4, userId);
            ps.executeUpdate();
        }
    }

    private void deleteAccount(int userId) throws Exception {
        String sql = "DELETE FROM users WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    private void downloadCV(int userId, HttpServletResponse response) throws Exception {
        String sql = "SELECT resume FROM users WHERE id=?";
        String filePath = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
				filePath = rs.getString("resume");
			}
        }

        if (filePath == null || filePath.isEmpty()) {
			return;
		}

        File file = new File(filePath);
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int len;
            while ((len = in.read(buffer)) > 0) {
				out.write(buffer, 0, len);
			}
        }
    }
}
