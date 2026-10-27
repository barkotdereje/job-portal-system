package com.jobportal.servlet.cv;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import db.DBConnection;

public class DeleteCVServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int cvId = Integer.parseInt(req.getParameter("cvId"));

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM cv WHERE id=?"
            );
            ps.setInt(1, cvId);
            ps.executeUpdate();

            res.sendRedirect("cv/viewCV.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
