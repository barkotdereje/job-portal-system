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

public class DeleteJobEmployerServlet extends HttpServlet {
    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer employerId = (Integer) session.getAttribute("employerId");
        if (employerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("manageJobsEmployer.jsp?error=missingId");
            return;
        }

        int jobId = Integer.parseInt(idStr);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root",""
            );

            String sql = "DELETE FROM jobs WHERE id=? AND employer_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, jobId);
            ps.setInt(2, employerId);

            int row = ps.executeUpdate();
            con.close();

            if(row > 0){
                response.sendRedirect("manageJobsEmployer.jsp?success=deleted");
            } else {
                response.sendRedirect("manageJobsEmployer.jsp?error=notfound");
            }

        } catch(Exception e){
            e.printStackTrace();
            response.sendRedirect("manageJobsEmployer.jsp?error=" + e.getMessage());
        }
    }
}
