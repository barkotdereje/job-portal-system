<%@ page session="true" %>
<%@ page import="java.sql.*, db.DBConnection" %>


<%
    Integer userId = (Integer) session.getAttribute("userId");
    String role = (String) session.getAttribute("role");

    if(userId == null || !role.equals("JOBSEEKER")){
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Jobseeker Dashboard - JobPortal</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Modern Reset */
        * {margin:0;padding:0;box-sizing:border-box;}
        body {font-family:'Poppins',sans-serif;background:linear-gradient(135deg,#f5f7fa 0%,#c3cfe2 100%);color:#333;line-height:1.6;min-height:100vh;}

        /* Navigation */
        nav {background:white;padding:1rem 2rem;display:flex;justify-content:space-between;align-items:center;box-shadow:0 4px 20px rgba(0,0,0,0.08);position:sticky;top:0;z-index:1000;border-bottom:4px solid transparent;border-image:linear-gradient(90deg,#4361ee,#3a0ca3);border-image-slice:1;}
        .logo h1 {font-size:1.5rem;font-weight:700;background:linear-gradient(45deg,#4361ee,#3a0ca3);-webkit-background-clip:text;-webkit-text-fill-color:transparent;display:flex;align-items:center;gap:0.8rem;}
        .nav-links {list-style:none;display:flex;gap:1.5rem;}
        .nav-links a {text-decoration:none;color:#2b2d42;font-weight:600;font-size:0.95rem;display:flex;align-items:center;gap:0.6rem;padding:0.6rem 1rem;border-radius:8px;transition:all 0.3s ease;}
        .nav-links a:hover {background:linear-gradient(45deg,#4361ee,#3a0ca3);color:white;transform:translateY(-2px);box-shadow:0 5px 15px rgba(67,97,238,0.3);}

        /* Container */
        .container {max-width:1100px;margin:2rem auto;padding:0 1.5rem;}

        /* Welcome Banner */
        .welcome-banner {background:linear-gradient(45deg,#4361ee,#3a0ca3);color:white;padding:1.5rem;border-radius:12px;margin-bottom:2rem;box-shadow:0 6px 20px rgba(67,97,238,0.3);animation:fadeIn 0.8s ease-out;}
        .welcome-banner h2 {font-size:1.8rem;margin-bottom:0.8rem;display:flex;align-items:center;gap:1rem;}
        .user-info {display:flex;flex-wrap:wrap;gap:1.5rem;margin-top:1rem;}
        .info-item {display:flex;align-items:center;gap:0.8rem;background:rgba(255,255,255,0.2);padding:0.6rem 1rem;border-radius:8px;font-size:0.9rem;}
        .info-item i {font-size:1.1rem;}

        /* Section Title */
        .section-title {font-size:1.5rem;color:#2b2d42;margin:2rem 0 1.5rem 0;font-weight:700;background:linear-gradient(45deg,#4361ee,#3a0ca3);-webkit-background-clip:text;-webkit-text-fill-color:transparent;display:flex;align-items:center;gap:0.8rem;padding-bottom:0.5rem;border-bottom:3px solid #e5e7eb;}

        /* Jobs Grid */
        .jobs-grid {display:grid;grid-template-columns:repeat(auto-fill,minmax(500px,1fr));gap:1.5rem;margin-bottom:3rem;}
        .job-card {background:white;padding:1.8rem;border-radius:12px;box-shadow:0 5px 20px rgba(0,0,0,0.08);transition:all 0.3s ease;border-left:4px solid #4361ee;position:relative;overflow:hidden;}
        .job-card:hover {transform:translateY(-5px);box-shadow:0 12px 25px rgba(67,97,238,0.15);}
        .job-card h4 {font-size:1.3rem;color:#2b2d42;margin-bottom:1rem;font-weight:700;display:flex;align-items:center;gap:0.8rem;}
        .job-description {color:#4b5563;margin-bottom:1.2rem;line-height:1.6;font-size:0.95rem;}
        .job-meta {display:flex;flex-wrap:wrap;gap:1rem;margin-bottom:1.5rem;padding-bottom:1.2rem;border-bottom:1px solid #e5e7eb;}
        .meta-item {display:flex;align-items:center;gap:0.6rem;color:#6b7280;font-size:0.9rem;}
        .meta-item i {color:#4361ee;font-size:1rem;}
        .meta-label {font-weight:600;color:#2b2d42;}
        .apply-btn {display:inline-flex;align-items:center;gap:0.8rem;background:linear-gradient(45deg,#4361ee,#3a0ca3);color:white;text-decoration:none;padding:0.8rem 1.5rem;border-radius:8px;font-weight:600;font-size:0.95rem;transition:all 0.3s ease;box-shadow:0 5px 15px rgba(67,97,238,0.3);border:none;cursor:pointer;}
        .apply-btn:hover {transform:translateY(-3px);box-shadow:0 8px 20px rgba(67,97,238,0.4);background:linear-gradient(45deg,#3a0ca3,#4361ee);}

        /* Quick Actions */
        .quick-actions {display:flex;gap:1rem;margin:2rem 0;flex-wrap:wrap;}
        .action-card {flex:1;min-width:200px;background:white;padding:1.5rem;border-radius:12px;box-shadow:0 5px 15px rgba(0,0,0,0.08);transition:all 0.3s ease;text-align:center;border-top:4px solid #4361ee;}
        .action-card:hover {transform:translateY(-5px);box-shadow:0 10px 25px rgba(67,97,238,0.15);}
        .action-card i {font-size:2rem;color:#4361ee;margin-bottom:1rem;}
        .action-card h4 {color:#2b2d42;margin-bottom:0.5rem;font-size:1.1rem;}
        .action-card p {color:#6b7280;font-size:0.9rem;margin-bottom:1rem;}

        /* Applications Table */
        .applications-table {width:100%;border-collapse:collapse;margin-top:2rem;}
        .applications-table th, .applications-table td {padding:0.8rem 1rem;text-align:left;border-bottom:1px solid #e5e7eb;}
        .applications-table th {background:linear-gradient(45deg,#4361ee,#3a0ca3);color:white;font-weight:600;}
        .status-badge {padding:0.3rem 0.7rem;border-radius:8px;font-weight:600;color:white;font-size:0.85rem;}
        .status-pending {background:#f59e0b;}
        .status-approved {background:#10b981;}
        .status-rejected {background:#ef4444;}

        /* Responsive */
        @media (max-width:768px){.jobs-grid{grid-template-columns:1fr;}.action-card{min-width:100%;}}
        @keyframes fadeIn{from{opacity:0;transform:translateY(20px);}to{opacity:1;transform:translateY(0);}}
    </style>
</head>
<body>

<!-- Navigation -->
<nav>
    <div class="logo"><h1><i class="fas fa-briefcase"></i> JobPortal</h1></div>
    <ul class="nav-links">
        <li><a href="index.jsp"><i class="fas fa-home"></i> Home</a></li>
        <li><a href="jobSeekerProfile.jsp"><i class="fas fa-user"></i> Profile</a></li>
         <li><a href="viewJobAlerts"><i class="fas fa-user"></i> Job Alerts</a> </li>
        |
        <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</nav>

<div class="container">
    <!-- Welcome Banner -->
    <div class="welcome-banner">
        <h2><i class="fas fa-user-graduate"></i> Welcome, Job Seeker!</h2>
        <div class="user-info">
            <div class="info-item"><i class="fas fa-id-card"></i> <span><strong>User ID:</strong> <%= userId %></span></div>
            <div class="info-item"><i class="fas fa-user-tag"></i> <span><strong>Role:</strong> <%= role %></span></div>
            <div class="info-item"><i class="fas fa-calendar-day"></i> <span><strong>Date:</strong> <%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %></span></div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
         <main class="hero fade-in">
        <div class="hero-content">
        <form action="searchJobs" method="get" style="margin-bottom: 2rem;">
    <input type="text" name="keyword" placeholder="Search job title or keyword"
           style="padding:12px;width:45%;border-radius:8px;border:1px solid #ccc;">

    <select name="dateFilter"
            style="padding:12px;width:25%;border-radius:8px;border:1px solid #ccc;">
        <option value="">Any Date</option>
        <option value="1">Last 24 Hours</option>
        <option value="7">Last 7 Days</option>
        <option value="30">Last 30 Days</option>
    </select>

    <button type="submit" class="cta-button" style="padding:12px 25px;">
        <i class="fas fa-search"></i> Search
    </button>
</form>
        <div class="action-card"><i class="fas fa-file-alt"></i><h4>Applications</h4><p>Track your applications</p><a href="#applications-section" class="apply-btn" style="width:100%;justify-content:center;"><i class="fas fa-eye"></i> View</a></div>
        
         
         
        <div class="action-card"><i class="fas fa-user-cog"></i><h4>Profile</h4><p>Update your profile</p><a href="jobSeekerProfile.jsp" class="apply-btn" style="width:100%;justify-content:center;"><i class="fas fa-edit"></i> Edit</a></div>
    </div>

    <!-- Available Jobs -->
    <h3 class="section-title"><i class="fas fa-briefcase"></i> Available Jobs</h3>
    <%
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT id, title, description, company_email, created_at FROM jobs ORDER BY created_at DESC LIMIT 10");
            rs = ps.executeQuery();
            int jobCount = 0;
    %>
    <div class="jobs-grid">
        <%
            while(rs.next()){
                jobCount++;
                String jobTitle = rs.getString("title");
                String jobDesc = rs.getString("description");
                if(jobDesc.length()>200) jobDesc = jobDesc.substring(0,200)+"...";
                java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
                String formattedDate = createdAt!=null ? createdAt.toString().substring(0,16) : "";
        %>
        <div class="job-card">
            <h4><i class="fas fa-briefcase"></i> <%= jobTitle %></h4>
            <div class="job-description"><%= jobDesc %></div>
            <div class="job-meta">
                <div class="meta-item"><i class="fas fa-envelope"></i><span class="meta-label">Company Email:</span> <span><%= rs.getString("company_email") %></span></div>
                <div class="meta-item"><i class="fas fa-calendar-alt"></i><span class="meta-label">Posted on:</span> <span><%= formattedDate %></span></div>
            </div>
            <a href="applyJob?jobId=<%= rs.getInt("id") %>" class="apply-btn">
    <i class="fas fa-paper-plane"></i> Apply Now
</a>

        </div>
        <%
            }
            if(jobCount==0){
        %>
        <div style="grid-column:1/-1;text-align:center;padding:3rem;color:#6b7280;">
            <i class="fas fa-folder-open" style="font-size:3rem;color:#d1d5db;margin-bottom:1rem;"></i>
            <h3 style="color:#4b5563;">No Jobs Available</h3>
            <p>Currently there are no job postings. Check back later!</p>
        </div>
        <%
            }
        } catch(Exception e) { %>
        <div style="grid-column:1/-1;text-align:center;padding:3rem;color:#6b7280;">
            <i class="fas fa-exclamation-triangle" style="font-size:3rem;color:#ef4444;margin-bottom:1rem;"></i>
            <h3 style="color:#dc2626;">Error Loading Jobs</h3>
            <p>There was an error loading job listings. Please try again later.</p>
        </div>
        <%
        } finally {
            if(rs!=null) rs.close();
            if(ps!=null) ps.close();
        }
    %>
    </div>

    <!-- Applications Section -->
    <h3 id="applications-section" class="section-title"><i class="fas fa-file-alt"></i> Your Applications</h3>
    <%
        ResultSet appsRs = null;
        try{
            ps = con.prepareStatement("SELECT a.id, j.title, a.cover_letter, a.status, a.applied_at FROM applications a JOIN jobs j ON a.job_id=j.id WHERE a.jobseeker_id=? ORDER BY a.applied_at DESC");
            ps.setInt(1, userId);
            appsRs = ps.executeQuery();
    %>
    <table class="applications-table">
        <tr>
            <th>Job Title</th>
            <th>Cover Letter</th>
            <th>Status</th>
            <th>Applied At</th>
        </tr>
        <%
            while(appsRs.next()){
                String appStatus = appsRs.getString("status");
                String badgeClass = "status-pending";
                if("Approved".equalsIgnoreCase(appStatus)) badgeClass="status-approved";
                else if("Rejected".equalsIgnoreCase(appStatus)) badgeClass="status-rejected";
        %>
        <tr>
            <td><%= appsRs.getString("title") %></td>
            <td><%= appsRs.getString("cover_letter") %></td>
            <td><span class="status-badge <%= badgeClass %>"><%= appStatus %></span></td>
            <td><%= appsRs.getTimestamp("applied_at") %></td>
        </tr>
        <% } %>
    </table>
    <%
        } catch(Exception e){
            out.println("<p style='color:red;'>Error loading applications: "+e.getMessage()+"</p>");
        } finally {
            if(appsRs!=null) appsRs.close();
            if(ps!=null) ps.close();
            if(con!=null) con.close();
        }
    %>
</div>

</body>
</html>
