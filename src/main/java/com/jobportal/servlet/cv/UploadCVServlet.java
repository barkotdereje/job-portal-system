package com.jobportal.servlet.cv;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import db.DBConnection;

@MultipartConfig
public class UploadCVServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute("userId");
        Part cvPart = req.getPart("cv");
        if(cvPart != null && cvPart.getSize() > 0){
            String fileName = System.currentTimeMillis() + "_" + cvPart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("/uploads/") + fileName;
            cvPart.write(uploadPath);
            String cvPath = "uploads/" + fileName;

            try{
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(
                    "UPDATE users SET uploaded_cv=? WHERE id=?"
                );
                ps.setString(1, cvPath);
                ps.setInt(2, userId);
                ps.executeUpdate();
                res.sendRedirect("cv/viewCV.jsp");
            } catch(Exception e){ e.printStackTrace(); }
        } else { res.sendRedirect("cv/viewCV.jsp"); // after uploading
 }
    }
}
