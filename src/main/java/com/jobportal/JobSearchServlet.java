package com.jobportal;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class JobSearchServlet extends HttpServlet {

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if(userId == null || !"JOBSEEKER".equals(role)){
            response.sendRedirect("login.jsp");
            return;
        }

        String search = request.getParameter("search");
        String location = request.getParameter("location");
        String jobType = request.getParameter("job_type");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/job_portal",  // Changed database name
                "root",
                ""
            );

            // Build SQL query based on your actual tables
            StringBuilder sql = new StringBuilder(
                "SELECT j.*, u.company_name FROM jobs j " +
                "LEFT JOIN users u ON j.company_email = u.email " +
                "WHERE u.approved = 1 AND u.status = 'APPROVED' " // Changed to match your DB
            );

            List<Object> params = new ArrayList<>();

            if (search != null && !search.trim().isEmpty()) {
                sql.append("AND (j.title LIKE ? OR j.description LIKE ? OR u.company_name LIKE ?) ");
                params.add("%" + search + "%");
                params.add("%" + search + "%");
                params.add("%" + search + "%");
            }

            // Note: Your jobs table might not have location column - adjust as needed
            if (location != null && !location.trim().isEmpty()) {
                sql.append("AND j.location LIKE ? ");
                params.add("%" + location + "%");
            }

            if (jobType != null && !jobType.trim().isEmpty()) {
                sql.append("AND j.job_type = ? ");
                params.add(jobType);
            }

            sql.append("ORDER BY j.created_at DESC"); // Changed to match your column name

            pstmt = conn.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            rs = pstmt.executeQuery();

            List<Map<String, String>> jobs = new ArrayList<>();
            while (rs.next()) {
                Map<String, String> job = new HashMap<>();
                job.put("id", rs.getString("id"));
                job.put("title", rs.getString("title"));
                job.put("company_name", rs.getString("company_name"));
                job.put("company_email", rs.getString("company_email"));
                job.put("description", rs.getString("description"));
                job.put("created_at", rs.getString("created_at"));

                // Add other columns if they exist in your table
                if (hasColumn(rs, "location")) {
					job.put("location", rs.getString("location"));
				}
                if (hasColumn(rs, "job_type")) {
					job.put("job_type", rs.getString("job_type"));
				}
                if (hasColumn(rs, "salary_range")) {
					job.put("salary_range", rs.getString("salary_range"));
				}
                if (hasColumn(rs, "deadline")) {
					job.put("deadline", rs.getString("deadline"));
				}

                jobs.add(job);
            }

            request.setAttribute("jobs", jobs);
            request.setAttribute("search", search);
            request.setAttribute("location", location);
            request.setAttribute("job_type", jobType);

            // Forward to JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/JobSearch.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try { if (rs != null) {
				rs.close();
			} } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) {
				pstmt.close();
			} } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) {
				conn.close();
			} } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // Helper method to check if column exists
    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData meta = rs.getMetaData();
        int columns = meta.getColumnCount();
        for (int i = 1; i <= columns; i++) {
            if (columnName.equalsIgnoreCase(meta.getColumnName(i))) {
                return true;
            }
        }
        return false;
    }
}