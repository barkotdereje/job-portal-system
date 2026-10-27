package com.jobportal.servlet.profile;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jobportal.dao.UserDAO;
import com.jobportal.model.User;

public class UpdateProfileServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if(userId != null) {
            String name = req.getParameter("fullName");
            String email = req.getParameter("email");

            User user = new User();
            user.setId(userId);
            user.setFullName(name);
            user.setEmail(email);

            UserDAO dao = new UserDAO();
            dao.update(user);
            res.sendRedirect("profile/viewProfile.jsp"); // after update

        } else {
            res.sendRedirect("login.jsp");
        }
    }
}
