package com.jobportal.servlet.alert;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jobportal.dao.JobAlertDAO;

@WebServlet("/addJobAlert")
public class AddJobAlertServlet extends HttpServlet {

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String keyword = request.getParameter("keyword");

        JobAlertDAO dao = new JobAlertDAO();
        dao.addAlert(userId, keyword);

        response.sendRedirect(request.getContextPath() + "/viewJobAlerts");
    }
}
