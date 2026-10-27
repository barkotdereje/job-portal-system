package com.jobportal.servlet.cv;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jobportal.dao.CVDAO;
import com.jobportal.model.CV;

@WebServlet("/cv/DownloadCVServlet")
public class DownloadCVServlet extends HttpServlet {

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        CV cv = CVDAO.getCVByUserId(userId);

        if(cv == null) {
            response.getWriter().println("No CV found to download.");
            return;
        }

        // Download as text file
        response.setContentType("text/plain");
        response.setHeader("Content-Disposition", "attachment; filename=cv_" + userId + ".txt");

        response.getWriter().write(cv.getContent());
    }
}
