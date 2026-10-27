package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class EditJobServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Integer employerId = (Integer) session.getAttribute("employerId");
        if (employerId == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int jobId = Integer.parseInt(req.getParameter("id"));
        String title = req.getParameter("title");
        String description = req.getParameter("description");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", ""
            );

            String sql = "UPDATE jobs SET title=?, description=? WHERE id=? AND employer_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setInt(3, jobId);
            ps.setInt(4, employerId);
            ps.executeUpdate();
            con.close();

            res.sendRedirect("manageJobsEmployer.jsp");
        } catch(Exception e) {
            e.printStackTrace();
            res.getWriter().println("Error updating job");
        }
    }
}
