<%@ page import="java.util.List" %>
<%@ page import="com.jobportal.model.JobAlert" %>
<%
    List<JobAlert> alerts = (List<JobAlert>) request.getAttribute("alerts");
%>

<style>
    /* Modern Reset */
    * {margin:0;padding:0;box-sizing:border-box;}
    body {font-family:'Poppins',sans-serif;background:linear-gradient(135deg,#f5f7fa 0%,#c3cfe2 100%);color:#333;line-height:1.6;min-height:100vh;padding:20px;}
    
    /* Container */
    .container {max-width:1100px;margin:0 auto;padding:20px;}
    
    /* Header */
    h2 {font-size:1.8rem;color:#2b2d42;margin:1.5rem 0;font-weight:700;background:linear-gradient(45deg,#4361ee,#3a0ca3);-webkit-background-clip:text;-webkit-text-fill-color:transparent;display:flex;align-items:center;gap:0.8rem;padding-bottom:0.5rem;border-bottom:3px solid #e5e7eb;}
    
    /* Form Styling */
    form {background:white;padding:1.8rem;border-radius:12px;box-shadow:0 5px 20px rgba(0,0,0,0.08);margin-bottom:2rem;border-left:4px solid #10b981;animation:fadeIn 0.6s ease-out;}
    input[type="text"] {width:100%;padding:0.8rem 1rem;border:1px solid #d1d5db;border-radius:8px;font-size:1rem;transition:all 0.3s ease;margin-bottom:1rem;}
    input[type="text"]:focus {outline:none;border-color:#4361ee;box-shadow:0 0 0 3px rgba(67,97,238,0.1);}
    
    /* Button Styles */
    button {display:inline-flex;align-items:center;gap:0.8rem;background:linear-gradient(45deg,#4361ee,#3a0ca3);color:white;text-decoration:none;padding:0.8rem 1.5rem;border-radius:8px;font-weight:600;font-size:0.95rem;transition:all 0.3s ease;box-shadow:0 5px 15px rgba(67,97,238,0.3);border:none;cursor:pointer;}
    button:hover {transform:translateY(-3px);box-shadow:0 8px 20px rgba(67,97,238,0.4);background:linear-gradient(45deg,#3a0ca3,#4361ee);}
    
    /* Divider */
    hr {border:none;height:1px;background:linear-gradient(90deg,transparent,#e5e7eb,transparent);margin:2rem 0;}
    
    /* Empty State */
    p {color:#6b7280;font-size:1rem;text-align:center;padding:2rem;background:white;border-radius:12px;box-shadow:0 5px 15px rgba(0,0,0,0.05);}
    
    /* Alerts List */
    ul {list-style:none;display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:1.5rem;margin-top:2rem;}
    li {background:white;padding:1.8rem;border-radius:12px;box-shadow:0 5px 20px rgba(0,0,0,0.08);transition:all 0.3s ease;border-left:4px solid #f59e0b;position:relative;overflow:hidden;animation:fadeIn 0.6s ease-out;}
    li:hover {transform:translateY(-5px);box-shadow:0 12px 25px rgba(245,158,11,0.15);}
    
    /* Alert Content */
    li span {font-size:1.1rem;font-weight:600;color:#2b2d42;display:block;margin-bottom:1rem;background:#fef3c7;padding:0.4rem 0.8rem;border-radius:6px;}
    
    /* Delete Link */
    li a {display:inline-flex;align-items:center;gap:0.5rem;background:linear-gradient(45deg,#ef4444,#dc2626);color:white;text-decoration:none;padding:0.5rem 1rem;border-radius:8px;font-weight:600;font-size:0.85rem;transition:all 0.3s ease;box-shadow:0 5px 15px rgba(239,68,68,0.3);}
    li a:hover {transform:translateY(-3px);box-shadow:0 8px 20px rgba(239,68,68,0.4);background:linear-gradient(45deg,#dc2626,#b91c1c);}
    
    /* Back Link */
    a[href*="jobseekerDashboard.jsp"] {display:inline-flex;align-items:center;gap:0.8rem;background:linear-gradient(45deg,#6b7280,#4b5563);color:white;text-decoration:none;padding:0.8rem 1.5rem;border-radius:8px;font-weight:600;font-size:0.95rem;transition:all 0.3s ease;box-shadow:0 5px 15px rgba(107,114,128,0.3);margin-top:2rem;}
    a[href*="jobseekerDashboard.jsp"]:hover {transform:translateY(-3px);box-shadow:0 8px 20px rgba(107,114,128,0.4);background:linear-gradient(45deg,#4b5563,#374151);}
    
    /* Responsive */
    @media (max-width:768px){ul{grid-template-columns:1fr;}}
    @keyframes fadeIn{from{opacity:0;transform:translateY(20px);}to{opacity:1;transform:translateY(0);}}
</style>

<div class="container">
    <h2><i class="fas fa-bell"></i> My Job Alerts</h2>
    
    <!-- Add new alert -->
    <form action="<%=request.getContextPath()%>/addJobAlert" method="post">
        Keyword: <input type="text" name="keyword" required>
        <button type="submit"><i class="fas fa-plus"></i> Add Alert</button>
    </form>
    
    <hr>
    
    <% if(alerts == null || alerts.isEmpty()) { %>
        <p>No job alerts found.</p>
    <% } else { %>
        <ul>
        <% for(JobAlert a : alerts) { %>
            <li>
                <span><i class="fas fa-search"></i> <%= a.getKeyword() %></span>
                <a href="<%=request.getContextPath()%>/deleteJobAlert?id=<%=a.getId()%>"><i class="fas fa-trash"></i> Delete</a>
            </li>
        <% } %>
        </ul>
    <% } %>
    
    <a href="<%=request.getContextPath()%>/jobseekerDashboard.jsp"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
</div>