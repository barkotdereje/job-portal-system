package com.jobportal.servlet.alert;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jobportal.dao.JobAlertDAO;
import com.jobportal.model.JobAlert;

@WebServlet("/viewJobAlerts")
public class JobAlertServlet extends HttpServlet {

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        JobAlertDAO dao = new JobAlertDAO();
        List<JobAlert> alerts = dao.getAlertsByUserId(userId);

        request.setAttribute("alerts", alerts);
        request.getRequestDispatcher("/alerts/jobAlerts.jsp").forward(request, response);
    }
}
