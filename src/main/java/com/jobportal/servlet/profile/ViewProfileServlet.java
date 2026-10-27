package com.jobportal.servlet.profile;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jobportal.dao.UserDAO;
import com.jobportal.model.User;

public class ViewProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // use existing session
        if(session == null || session.getAttribute("userId") == null) {
            request.setAttribute("errorMessage", "User not found. Please log in.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        User user = UserDAO.getUserById(userId);

        request.setAttribute("user", user);
        request.getRequestDispatcher("/profile/viewProfile.jsp").forward(request, response);
    }

    }

