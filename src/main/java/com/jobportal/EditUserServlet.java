package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class EditUserServlet extends HttpServlet {

    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String role = req.getParameter("role");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
              "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
              "root",""
            );

            PreparedStatement ps = con.prepareStatement(
              "UPDATE users SET name=?, email=?, role=? WHERE id=?"
            );
            ps.setString(1,name);
            ps.setString(2,email);
            ps.setString(3,role);
            ps.setInt(4,id);
            ps.executeUpdate();

            con.close();
            res.sendRedirect("manageUsers.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("editUser.jsp?id="+id+"&error=update");
        }
    }
}
