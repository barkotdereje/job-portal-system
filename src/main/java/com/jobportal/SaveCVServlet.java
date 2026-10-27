package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SaveCVServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String templateName = req.getParameter("templateName");
        String content = req.getParameter("content");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root",
                ""
            );

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO cv_templates(name, content) VALUES(?,?)"
            );
            ps.setString(1, templateName);
            ps.setString(2, content);
            ps.executeUpdate();
            con.close();

            res.sendRedirect("prepareCV.jsp"); // back to template page

        } catch(Exception e) {
            e.printStackTrace();
            res.getWriter().println("Error: "+e.getMessage());
        }
    }
}
