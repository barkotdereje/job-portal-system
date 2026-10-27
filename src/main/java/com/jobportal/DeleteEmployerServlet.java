package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeleteEmployerServlet extends HttpServlet {
    @Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC","root","");
            PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE id=? AND role='EMPLOYER'");
            ps.setInt(1,id); ps.executeUpdate(); con.close();
            res.sendRedirect("listEmployers");
        } catch(Exception e) { e.printStackTrace(); res.getWriter().println("Error: "+e.getMessage()); }
    }
}
