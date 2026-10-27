package com.jobportal;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ApplyJobRedirectServlet extends HttpServlet {

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String jobId = request.getParameter("jobId");
        if (jobId == null) {
            response.sendRedirect("viewJobs.jsp");
            return;
        }

        response.sendRedirect("applyJob.jsp?jobId=" + jobId);
    }
}
