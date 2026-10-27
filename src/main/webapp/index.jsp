<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>

<html>
<head>
    <title>Job Portal</title>
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
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
        }

        /* Navigation Bar */
        nav {
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

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo h1 {
            color: #4361ee;
            font-size: 1.8rem;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
            list-style: none;
        }

        .nav-links a {
            color: #555;
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-links a:hover {
            color: #4361ee;
            background: rgba(67, 97, 238, 0.1);
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 50%;
            width: 0;
            height: 2px;
            background: #4361ee;
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .nav-links a:hover::after {
            width: 80%;
        }

        /* Hero Section */
        .hero {
            padding: 6rem 5%;
            text-align: center;
            max-width: 1200px;
            margin: 0 auto;
        }

        .hero-content {
            background: white;
            border-radius: 20px;
            padding: 4rem;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
        }

        .hero-content::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #4361ee, #3a0ca3);
        }

        .hero h2 {
            font-size: 3.2rem;
            color: #2b2d42;
            margin-bottom: 1.5rem;
            font-weight: 700;
            line-height: 1.2;
        }

        .hero p {
            font-size: 1.2rem;
            color: #6c757d;
            max-width: 800px;
            margin: 0 auto 3rem;
            line-height: 1.8;
        }

        .cta-button {
            display: inline-block;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            text-decoration: none;
            padding: 1.2rem 3rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 5px 20px rgba(67, 97, 238, 0.3);
            border: none;
            cursor: pointer;
        }

        .cta-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(67, 97, 238, 0.4);
        }

        .features {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
            margin-top: 4rem;
        }

        .feature-card {
            background: #f8f9fa;
            padding: 2rem;
            border-radius: 15px;
            text-align: center;
            transition: transform 0.3s ease;
            border: 1px solid #e9ecef;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            border-color: #4361ee;
        }

        .feature-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .feature-card h3 {
            color: #2b2d42;
            margin-bottom: 0.8rem;
        }

        .feature-card p {
            color: #6c757d;
            font-size: 0.95rem;
        }

        /* Footer */
        footer {
            background: #2b2d42;
            color: white;
            padding: 4rem 5% 2rem;
            margin-top: 6rem;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 3rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .footer-section h3 {
            color: #f8f9fa;
            margin-bottom: 1.5rem;
            font-size: 1.2rem;
        }

        .footer-links {
            list-style: none;
        }

        .footer-links li {
            margin-bottom: 0.8rem;
        }

        .footer-links a {
            color: #adb5bd;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: #4361ee;
        }

        .copyright {
            text-align: center;
            padding-top: 3rem;
            margin-top: 3rem;
            border-top: 1px solid #495057;
            color: #adb5bd;
            font-size: 0.9rem;
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .features {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .footer-content {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            nav {
                flex-direction: column;
                gap: 1rem;
                padding: 1rem;
            }
            
            .nav-links {
                gap: 1rem;
            }
            
            .hero {
                padding: 3rem 1rem;
            }
            
            .hero h2 {
                font-size: 2.5rem;
            }
            
            .hero-content {
                padding: 2rem;
            }
            
            .features {
                grid-template-columns: 1fr;
            }
            
            .footer-content {
                grid-template-columns: 1fr;
                text-align: center;
            }
        }

        /* Animation */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-in {
            animation: fadeIn 0.8s ease-out;
        }
    </style>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <!-- Navigation -->
    <nav>
        <div class="logo">
            <div class="logo-icon">
                <i class="fas fa-briefcase"></i>
            </div>
            <h1>JobPortal</h1>
        </div>
        <%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
%>

<ul class="nav-links">
    <li><a href="index.jsp"><i class="fas fa-home"></i> Home</a></li>
<% if(role == null){ %>
    <li><a href="login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a></li>
    <li><a href="register.jsp"><i class="fas fa-user-plus"></i> Register</a></li>
<% } else { %>
    <% if(role.equals("JOBSEEKER")) { %>
        <li><a href="jobseekerDashboard.jsp">Dashboard</a></li>
    <% } else if(role.equals("EMPLOYER")) { %>
        <li><a href="employerDashboard.jsp">Dashboard</a></li>
    <% } %>
    <li><a href="logout.jsp">Logout</a></li>
<% } %>
</ul>

    </nav>

    <!-- Hero Section -->
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
        
            <h2>Find Your Dream Job Today</h2>
            <p>
                Welcome to JobPortal, your gateway to career success. Whether you're looking for your next opportunity 
                or searching for the perfect candidate, we connect talented professionals with leading employers. 
                Join thousands who have found their perfect match through our platform.
            </p>
            <div style="margin-top:3rem;text-align:left;">
<h3 style="margin-bottom:1rem;">Latest Jobs</h3>

<%
    Connection con = DBConnection.getConnection();
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery(
        "SELECT id, title, description, company_email, created_at FROM jobs ORDER BY created_at DESC LIMIT 5"
    );

    while(rs.next()){
%>
    <div style="background:#f8f9fa;padding:1.5rem;margin-bottom:1rem;border-radius:12px;">
        <h4><%= rs.getString("title") %></h4>
        <p><%= rs.getString("description") %></p>
        <p><strong>Company Email:</strong> <%= rs.getString("company_email") %></p>
        <p><small>Posted on: <%= rs.getTimestamp("created_at") %></small></p>

     
    </div>
<%
    }
    con.close();
%>
</div>
            
            <a href="register.jsp" class="cta-button">
                <i class="fas fa-rocket"></i> Get Started Now
            </a>
            
            <div class="features">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <h3>Find Jobs</h3>
                    <p>Browse thousands of job listings from top companies across all industries.</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3>For Employers</h3>
                    <p>Post jobs, manage applications, and find the perfect candidates for your team.</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>Secure and Reliable</h3>
                    <p>Your data and privacy are protected with enterprise-grade security measures.</p>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer>
        <div class="footer-content">
            <div class="footer-section">
                <h3>JobPortal</h3>
                <p>Connecting talent with opportunity since 2023.</p>
            </div>
            
            <div class="footer-section">
                <h3>Quick Links</h3>
                <ul class="footer-links">
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="login.jsp">Login</a></li>
                    <li><a href="register.jsp">Register</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h3>Resources</h3>
                <ul class="footer-links">
                    <li><a href="#">Career Tips</a></li>
                    <li><a href="#">Resume Builder</a></li>
                    <li><a href="#">Employer Resources</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h3>Contact</h3>
                <ul class="footer-links">
                    <li><i class="fas fa-envelope"></i>hr@company.com</li>
                    <li><i class="fas fa-phone"></i> +1 (555) 123-4567</li>
                </ul>
            </div>
        </div>
        
        <div class="copyright">
            <p>&copy; 2025 JobPortal. All rights reserved.</p>
        </div>
    </footer>

</body>
</html>