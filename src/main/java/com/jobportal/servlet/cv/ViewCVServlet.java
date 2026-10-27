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

@WebServlet("/cv/ViewCVServlet")
public class ViewCVServlet extends HttpServlet {

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        CV cv = CVDAO.getCVByUserId(userId);

        if (cv == null) {
            request.setAttribute("message", "No CV found. Please create one.");
        } else {
            request.setAttribute("cvId", cv.getId());
            request.setAttribute("cvContent", cv.getContent());
        }

        request.getRequestDispatcher("/cv/viewCV.jsp").forward(request, response);
    }
}
