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

public class ViewApplicationServlet extends HttpServlet {
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
            response.sendRedirect("manageApplications.jsp?error=missingId");
            return;
        }

        int applicationId = Integer.parseInt(idStr);

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
                "root", ""
            );

            String sql = "SELECT a.id, a.resume, a.applied_at, a.status, j.title, u.name, u.email, u.contact_number " +
                    "FROM applications a " +
                    "JOIN jobs j ON a.job_id=j.id " +
                    "JOIN users u ON a.jobseeker_id=u.id " +
                    "WHERE a.id=? AND j.employer_id=?";
       ps = con.prepareStatement(sql);
       ps.setInt(1, applicationId);
       ps.setInt(2, employerId);
        rs = ps.executeQuery();


            if (rs.next()) {
                request.setAttribute("applicantName", rs.getString("applicant_name"));
                request.setAttribute("email", rs.getString("applicant_email"));
                request.setAttribute("jobTitle", rs.getString("job_title"));
                request.setAttribute("resume", rs.getString("resume"));
                request.setAttribute("coverLetter", rs.getString("cover_letter"));
                request.setAttribute("status", rs.getString("status"));
                request.setAttribute("appliedAt", rs.getTimestamp("applied_at"));

                RequestDispatcher rd = request.getRequestDispatcher("viewApplicationDetails.jsp");
                rd.forward(request, response);
            } else {
                response.getWriter().println("No application found or you are not authorized.");
            }

        } catch(Exception e){
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try { if(rs != null) {
				rs.close();
			} } catch(Exception e) {}
            try { if(ps != null) {
				ps.close();
			} } catch(Exception e) {}
            try { if(con != null) {
				con.close();
			} } catch(Exception e) {}
        }
    }
}
