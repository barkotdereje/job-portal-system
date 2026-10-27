package com.jobportal.servlet.cv;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jobportal.dao.CVDAO;
public class UpdateCVServlet extends HttpServlet {

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int cvId = Integer.parseInt(request.getParameter("cvId"));
        String content = request.getParameter("content");

        boolean updated = CVDAO.updateCV(cvId, content);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/cv/ViewCVServlet");
        } else {
            request.setAttribute("error", "Update failed");
            request.getRequestDispatcher("/cv/editcv.jsp").forward(request, response);
        }
    }
}
