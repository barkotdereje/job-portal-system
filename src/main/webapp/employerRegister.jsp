<%@ page session="false" %>
<html>
<head>
<title>Employer Registration</title>
</head>
<body>
<h2>Register as Employer</h2>
<form action="EmployerRegisterServlet" method="post">
    Name: <input type="text" name="name" required><br>
    Email: <input type="email" name="email" required><br>
    Password: <input type="password" name="password" required><br>
    <button type="submit">Register</button>
</form>
<p>Already registered? <a href="employerLogin.jsp">Login</a></p>
</body>
</html>
