package com.jobportal;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DownloadResumeServlet extends HttpServlet {

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fileName = request.getParameter("file");

        if (fileName == null || fileName.trim().isEmpty()) {
            response.getWriter().println("Resume file not specified");
            return;
        }

        String resumePath = getServletContext().getRealPath("/resumes/" + fileName);
        File file = new File(resumePath);

        if (!file.exists()) {
            response.getWriter().println("Resume file not found");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader(
            "Content-Disposition",
            "attachment; filename=\"" + file.getName() + "\""
        );

        Files.copy(file.toPath(), response.getOutputStream());
    }
}
