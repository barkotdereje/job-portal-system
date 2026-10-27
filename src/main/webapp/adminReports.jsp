<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    String role = (String) session.getAttribute("role");
    if(role == null || !role.equals("ADMIN")){
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Reports - JobPortal</title>
<style>
/* Modern Reset */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Poppins', 'Segoe UI', Arial, sans-serif;
}

body {
    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    min-height: 100vh;
}

/* Header - Consistent with Home Page */
header {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    padding: 1.2rem 5%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 2px 20px rgba(0, 0, 0, 0.08);
    position: sticky;
    top: 0;
    z-index: 100;
}

header h2 {
    color: #4361ee;
    font-size: 1.8rem;
    font-weight: 700;
    background: linear-gradient(45deg, #4361ee, #3a0ca3);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin: 0;
}

header a {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    background: linear-gradient(45deg, #4361ee, #3a0ca3);
    color: white;
    text-decoration: none;
    padding: 0.7rem 1.5rem;
    border-radius: 8px;
    font-weight: 600;
    font-size: 0.95rem;
    transition: all 0.3s ease;
    box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
}

header a:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(67, 97, 238, 0.4);
    background: linear-gradient(45deg, #3a0ca3, #4361ee);
}

/* Container */
.container {
    padding: 3rem 5%;
    max-width: 1200px;
    margin: 0 auto;
}

/* Page Title */
.page-title {
    font-size: 2rem;
    color: #2b2d42;
    margin-bottom: 2rem;
    font-weight: 700;
    text-align: center;
}

/* Cards Grid */
.cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 1.5rem;
    margin-top: 2rem;
}

/* Individual Card */
.card {
    background: white;
    border-radius: 15px;
    padding: 2rem;
    text-align: center;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    transition: all 0.3s ease;
    border: 1px solid transparent;
    position: relative;
    overflow: hidden;
}

.card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, #4361ee, #3a0ca3);
}

.card:hover {
    transform: translateY(-10px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
    border-color: #4361ee;
}

.card h2 {
    font-size: 3rem;
    color: #4361ee;
    margin-bottom: 0.5rem;
    font-weight: 700;
}

.card p {
    color: #4b5563;
    font-weight: 600;
    font-size: 1.1rem;
    margin: 0;
}

/* Card Icons */
.card-icon {
    width: 60px;
    height: 60px;
    background: linear-gradient(45deg, #4361ee, #3a0ca3);
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 1rem;
    color: white;
    font-size: 1.5rem;
}

/* Stats Summary */
.stats-summary {
    background: white;
    border-radius: 15px;
    padding: 2rem;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    margin-bottom: 2rem;
    position: relative;
    overflow: hidden;
}

.stats-summary::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, #4361ee, #3a0ca3);
}

.stats-summary h3 {
    font-size: 1.5rem;
    color: #2b2d42;
    margin-bottom: 1rem;
    text-align: center;
}

.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
    margin-top: 1rem;
}

.stat-item {
    text-align: center;
    padding: 1rem;
    background: #f8f9fa;
    border-radius: 10px;
    transition: all 0.3s ease;
}

.stat-item:hover {
    background: #e9ecef;
    transform: translateY(-5px);
}

.stat-item .value {
    font-size: 2rem;
    color: #4361ee;
    font-weight: 700;
    margin-bottom: 0.5rem;
}

.stat-item .label {
    color: #6b7280;
    font-weight: 500;
    font-size: 0.95rem;
}

/* Error Message */
.error-message {
    background: #fee2e2;
    border: 1px solid #fecaca;
    border-radius: 8px;
    padding: 1.5rem;
    margin: 2rem 0;
    color: #dc2626;
    text-align: center;
    font-size: 0.95rem;
}

/* Responsive Design */
@media (max-width: 768px) {
    header {
        flex-direction: column;
        gap: 1rem;
        padding: 1rem;
    }
    
    header h2 {
        font-size: 1.5rem;
    }
    
    .container {
        padding: 2rem 1.5rem;
    }
    
    .page-title {
        font-size: 1.6rem;
        margin-bottom: 1.5rem;
    }
    
    .cards {
        grid-template-columns: repeat(2, 1fr);
        gap: 1rem;
    }
    
    .card {
        padding: 1.5rem;
    }
    
    .card h2 {
        font-size: 2.5rem;
    }
    
    .stats-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 480px) {
    header h2 {
        font-size: 1.3rem;
    }
    
    header a {
        padding: 0.6rem 1rem;
        font-size: 0.9rem;
    }
    
    .cards {
        grid-template-columns: 1fr;
    }
    
    .card h2 {
        font-size: 2.2rem;
    }
    
    .stats-grid {
        grid-template-columns: 1fr;
    }
    
    .stat-item {
        padding: 0.8rem;
    }
    
    .stat-item .value {
        font-size: 1.8rem;
    }
}

/* Animation */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.card {
    animation: fadeInUp 0.6s ease-out;
}

.card:nth-child(1) { animation-delay: 0.1s; }
.card:nth-child(2) { animation-delay: 0.2s; }
.card:nth-child(3) { animation-delay: 0.3s; }
.card:nth-child(4) { animation-delay: 0.4s; }
.card:nth-child(5) { animation-delay: 0.5s; }
</style>
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<!-- Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<header>
    <h2>System Reports</h2>
    <a href="adminDashboard.jsp"><i class="fas fa-arrow-left"></i> Back</a>
</header>

<div class="container">

<h1 class="page-title">Dashboard Analytics</h1>

<%
    int totalUsers=0, jobseekers=0, employers=0, jobs=0, apps=0;
    String errorMessage = null;

    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
            "root",""
        );

        Statement st = con.createStatement();

        ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM users");
        if(rs.next()) totalUsers = rs.getInt(1);

        rs = st.executeQuery("SELECT COUNT(*) FROM users WHERE role='JOBSEEKER'");
        if(rs.next()) jobseekers = rs.getInt(1);

        rs = st.executeQuery("SELECT COUNT(*) FROM users WHERE role='EMPLOYER'");
        if(rs.next()) employers = rs.getInt(1);

        rs = st.executeQuery("SELECT COUNT(*) FROM jobs");
        if(rs.next()) jobs = rs.getInt(1);

        rs = st.executeQuery("SELECT COUNT(*) FROM applications");
        if(rs.next()) apps = rs.getInt(1);

        con.close();
    }catch(Exception e){
        errorMessage = e.getMessage();
    }
%>

<% if(errorMessage != null) { %>
<div class="error-message">
    <i class="fas fa-exclamation-circle"></i> Error: <%= errorMessage %>
</div>
<% } %>

<!-- Stats Summary -->
<div class="stats-summary">
    <h3><i class="fas fa-chart-line"></i> Overview</h3>
    <div class="stats-grid">
        <div class="stat-item">
            <div class="value"><%= totalUsers %></div>
            <div class="label">Total Users</div>
        </div>
        <div class="stat-item">
            <div class="value"><%= jobseekers %></div>
            <div class="label">Job Seekers</div>
        </div>
        <div class="stat-item">
            <div class="value"><%= employers %></div>
            <div class="label">Employers</div>
        </div>
        <div class="stat-item">
            <div class="value"><%= jobs %></div>
            <div class="label">Jobs Posted</div>
        </div>
        <div class="stat-item">
            <div class="value"><%= apps %></div>
            <div class="label">Applications</div>
        </div>
    </div>
</div>

<div class="cards">
    <div class="card">
        <div class="card-icon">
            <i class="fas fa-users"></i>
        </div>
        <h2><%= totalUsers %></h2>
        <p>Total Users</p>
    </div>
    <div class="card">
        <div class="card-icon">
            <i class="fas fa-search"></i>
        </div>
        <h2><%= jobseekers %></h2>
        <p>Job Seekers</p>
    </div>
    <div class="card">
        <div class="card-icon">
            <i class="fas fa-briefcase"></i>
        </div>
        <h2><%= employers %></h2>
        <p>Employers</p>
    </div>
    <div class="card">
        <div class="card-icon">
            <i class="fas fa-file-alt"></i>
        </div>
        <h2><%= jobs %></h2>
        <p>Jobs Posted</p>
    </div>
    <div class="card">
        <div class="card-icon">
            <i class="fas fa-paper-plane"></i>
        </div>
        <h2><%= apps %></h2>
        <p>Applications</p>
    </div>
</div>

</div>

<script>
// Add hover effects to cards
document.querySelectorAll('.card').forEach(card => {
    card.addEventListener('mouseenter', function() {
        this.style.transform = 'translateY(-10px)';
    });
    
    card.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0)';
    });
});

// Add hover effects to stat items
document.querySelectorAll('.stat-item').forEach(item => {
    item.addEventListener('mouseenter', function() {
        this.style.transform = 'translateY(-5px)';
    });
    
    item.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0)';
    });
});
</script>

</body>
</html>