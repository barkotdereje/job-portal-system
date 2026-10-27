package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ViewApplicationDetailsServlet extends HttpServlet {
    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer employerId = (Integer) session.getAttribute("employerId");
        if (employerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int applicationId = Integer.parseInt(request.getParameter("id"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", ""
            );

            String sql = "SELECT a.id, a.resume, a.applied_at, a.status, j.title, " +
                         "u.name, u.email, u.contact_number " +
                         "FROM applications a " +
                         "JOIN jobs j ON a.job_id=j.id " +
                         "JOIN users u ON a.jobseeker_id=u.id " +
                         "WHERE a.id=? AND j.employer_id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, applicationId);
            ps.setInt(2, employerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("application", rs);
                RequestDispatcher rd = request.getRequestDispatcher("viewApplicationDetails.jsp");
                rd.forward(request, response);
            } else {
                response.sendRedirect("manageApplications.jsp?error=notfound");
            }

            rs.close();
            ps.close();
            con.close();

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageApplications.jsp?error=" + e.getMessage());
        }
    }
}
