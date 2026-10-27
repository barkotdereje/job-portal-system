<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%
    Map<String, String> cv = (Map<String, String>) request.getAttribute("cv");
    if (cv == null) cv = new HashMap<>();
%>
<h2>Build / Update CV</h2>
<form action="JobSeekerServlet" method="post">
    <input type="hidden" name="action" value="updateCV">
    Skills: <input type="text" name="skills" value="<%= cv.get("skills") != null ? cv.get("skills") : "" %>"><br>
    Education: <input type="text" name="education" value="<%= cv.get("education") != null ? cv.get("education") : "" %>"><br>
    Experience: <input type="text" name="experience" value="<%= cv.get("experience") != null ? cv.get("experience") : "" %>"><br>
    <button type="submit">Update CV</button>
</form>

<% if (cv.get("resume") != null) { %>
    <a href="JobSeekerServlet?action=downloadCV">Download CV</a>
<% } %>
