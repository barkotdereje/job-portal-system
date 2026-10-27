package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeleteJobServlet extends HttpServlet {
    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if(idStr == null){
            response.sendRedirect("adminJobs1.jsp?error=missingId");
            return;
        }

        int id = Integer.parseInt(idStr);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root",""
            );

            PreparedStatement pst = con.prepareStatement("DELETE FROM jobs WHERE id=?");
            pst.setInt(1, id);
            int row = pst.executeUpdate();
            con.close();

            if(row > 0){
                response.sendRedirect("adminJobs1.jsp?success=deleted");
            } else {
                response.sendRedirect("adminJobs1.jsp?error=notfound");
            }

        } catch(Exception e){
            response.sendRedirect("adminJobs1.jsp?error=" + e.getMessage());
        }
    }
}
