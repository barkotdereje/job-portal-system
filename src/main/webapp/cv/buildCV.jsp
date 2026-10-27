<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Map<String, String> cvData = (Map<String, String>) request.getAttribute("cvData");
    if (cvData == null) cvData = new HashMap<>();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Build CV</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Build / Update CV</h2>
    <form action="<%=request.getContextPath()%>/BuildCVServlet" method="post">
        <input type="hidden" name="user_id" value="<%=userId%>">

        <div class="mb-3">
            <label>Skills (comma separated)</label>
            <input type="text" class="form-control" name="skills"
                   value="<%= cvData.getOrDefault("skills", "") %>" required>
        </div>

        <div class="mb-3">
            <label>Education</label>
            <input type="text" class="form-control" name="education"
                   value="<%= cvData.getOrDefault("education", "") %>" required>
        </div>

        <div class="mb-3">
            <label>Experience</label>
            <input type="text" class="form-control" name="experience"
                   value="<%= cvData.getOrDefault("experience", "") %>" required>
        </div>

        <div class="mb-3">
            <label>Resume (file path / URL)</label>
            <input type="text" class="form-control" name="resume"
                   value="<%= cvData.getOrDefault("resume", "") %>">
            <small class="form-text text-muted">Optional: You can add a link or path to your resume.</small>
        </div>

        <button type="submit" class="btn btn-primary">Save CV</button>
    </form>
</div>
</body>
</html>
