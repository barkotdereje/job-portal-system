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

@WebServlet("/cv/EditCVServlet")
public class EditCVServlet extends HttpServlet {

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get session and userId
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // Fetch CV by userId
        CV cv = CVDAO.getCVByUserId(userId);

        if(cv == null) {
            request.setAttribute("message", "No CV found");
            request.getRequestDispatcher("/cv/viewCV.jsp").forward(request, response);
            return;
        }

        // Set attributes for edit page
        request.setAttribute("cvId", cv.getId());
        request.setAttribute("cvContent", cv.getContent());

        // Forward to editcv.jsp
        request.getRequestDispatcher("/cv/editCV.jsp").forward(request, response);
    }
}
