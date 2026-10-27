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

@WebServlet("/cv/buildCV")
public class BuildCVServlet extends HttpServlet {

    // Show Build CV page
    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/cv/buildCV.jsp").forward(request, response);
    }


    // Handle form submission (POST)
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("🔥 doPost reached");

        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");
        String content = request.getParameter("content");

        System.out.println("userId=" + userId);
        System.out.println("content=" + content);

        if (userId == null || content == null || content.trim().isEmpty()) {
            response.getWriter().println("INVALID DATA");
            return;
        }

        CV cv = new CV();
        cv.setUserId(userId);
        cv.setContent(content);

        boolean saved = CVDAO.saveCV(cv);
        System.out.println("saved=" + saved);

        response.sendRedirect(request.getContextPath() + "/cv/ViewCVServlet");
    }


}
