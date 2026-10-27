package com.jobportal.servlet.alert;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import db.DBConnection;

public class ViewJobAlertsServlet extends HttpServlet {
    @Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int userId = (int) req.getSession().getAttribute("userId");
        List<String[]> alerts = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            // Get user keywords
            PreparedStatement ps = con.prepareStatement(
                "SELECT keyword FROM job_alerts WHERE user_id=?"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            List<String> keywords = new ArrayList<>();
            while (rs.next()) {
                keywords.add(rs.getString("keyword"));
            }

            // Find matching jobs
            for(String keyword : keywords){
                PreparedStatement ps2 = con.prepareStatement(
                    "SELECT * FROM jobs WHERE title LIKE ? OR company LIKE ?"
                );
                String pattern = "%" + keyword + "%";
                ps2.setString(1, pattern);
                ps2.setString(2, pattern);
                ResultSet rs2 = ps2.executeQuery();

                while(rs2.next()){
                    alerts.add(new String[]{
                        rs2.getString("title"),
                        rs2.getString("company"),
                        rs2.getString("location"),
                        rs2.getString("company_email")
                    });
                }
            }

            req.setAttribute("alerts", alerts);
            req.getRequestDispatcher("alerts/jobAlerts.jsp").forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
