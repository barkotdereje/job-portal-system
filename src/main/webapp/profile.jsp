<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%
    Map<String, String> profile = (Map<String, String>) request.getAttribute("profile");
    if (profile == null) profile = new HashMap<>();
%>
<h2>Manage Profile</h2>
<form action="JobSeekerServlet" method="post">
    <input type="hidden" name="action" value="updateProfile">
    Name: <input type="text" name="name" value="<%= profile.get("name") != null ? profile.get("name") : "" %>"><br>
    Contact: <input type="text" name="contact_number" value="<%= profile.get("contact_number") != null ? profile.get("contact_number") : "" %>"><br>
    <button type="submit">Update Profile</button>
</form>
<form action="JobSeekerServlet" method="post">
    <input type="hidden" name="action" value="deleteAccount">
    <button type="submit">Delete Account</button>
</form>
