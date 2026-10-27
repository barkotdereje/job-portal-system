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
    <title>Admin Dashboard - JobPortal</title>
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

        /* Header/Navigation Bar - Consistent with Home Page */
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

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo h2 {
            color: #4361ee;
            font-size: 1.8rem;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 0;
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

        nav {
            display: flex;
            gap: 1.5rem;
        }

        nav a {
            color: #555;
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            position: relative;
            font-size: 0.95rem;
        }

        nav a:hover {
            color: #4361ee;
            background: rgba(67, 97, 238, 0.1);
        }

        nav a::after {
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

        nav a:hover::after {
            width: 80%;
        }

        /* Logout Button Special Styling */
        nav a[href="logout.jsp"] {
            background: linear-gradient(45deg, #ef4444, #dc2626);
            color: white;
        }

        nav a[href="logout.jsp"]:hover {
            background: linear-gradient(45deg, #dc2626, #ef4444);
            color: white;
        }

        nav a[href="logout.jsp"]::after {
            display: none;
        }

        /* Container */
        .container {
            padding: 3rem 5%;
            max-width: 1200px;
            margin: 0 auto;
        }

        .container h2 {
            font-size: 2rem;
            color: #2b2d42;
            margin-bottom: 2rem;
            font-weight: 700;
            text-align: center;
        }

        /* Welcome Message */
        .welcome-message {
            text-align: center;
            margin-bottom: 2.5rem;
            padding: 1.5rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .welcome-message h3 {
            font-size: 1.8rem;
            color: #2b2d42;
            margin-bottom: 0.5rem;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .welcome-message p {
            color: #6c757d;
            font-size: 1rem;
        }

        /* Dashboard Cards */
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .card {
            background: white;
            border-radius: 15px;
            padding: 2.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            text-align: center;
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

        .card h3 {
            color: #2b2d42;
            font-size: 1.5rem;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .card p {
            color: #6c757d;
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        .card-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            color: white;
            font-size: 1.8rem;
        }

        /* Action Button - Consistent with Home Page */
        .card a {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            text-decoration: none;
            padding: 0.9rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
            border: none;
            cursor: pointer;
            margin-top: 1rem;
        }

        .card a:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            header {
                flex-direction: column;
                gap: 1rem;
                padding: 1rem;
            }
            
            nav {
                gap: 0.8rem;
                flex-wrap: wrap;
                justify-content: center;
            }
            
            .container {
                padding: 2rem 1.5rem;
            }
            
            .container h2 {
                font-size: 1.6rem;
                margin-bottom: 1.5rem;
            }
            
            .cards {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
            
            .card {
                padding: 2rem;
            }
            
            .welcome-message {
                padding: 1.2rem;
            }
            
            .welcome-message h3 {
                font-size: 1.5rem;
            }
        }

        @media (max-width: 480px) {
            .logo h2 {
                font-size: 1.4rem;
            }
            
            .logo-icon {
                width: 35px;
                height: 35px;
                font-size: 1rem;
            }
            
            nav a {
                padding: 0.4rem 0.8rem;
                font-size: 0.9rem;
            }
            
            .card {
                padding: 1.5rem;
            }
            
            .card-icon {
                width: 60px;
                height: 60px;
                font-size: 1.5rem;
            }
            
            .card h3 {
                font-size: 1.3rem;
            }
            
            .card a {
                padding: 0.8rem 1.5rem;
                font-size: 0.9rem;
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

        .card:nth-child(1) {
            animation-delay: 0.1s;
        }

        .card:nth-child(2) {
            animation-delay: 0.2s;
        }

        .welcome-message {
            animation: fadeInUp 0.6s ease-out;
        }
    </style>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<header>
    <div class="logo">
        <div class="logo-icon">
            <i class="fas fa-crown"></i>
        </div>
        <h2>JobPortal Admin</h2>
    </div>
    <nav>
        <a href="manageUsers.jsp"><i class="fas fa-users"></i> Manage Users</a>
        <a href="prepareCV.jsp"><i class="fas fa-file-alt"></i> CV Templates</a>
        <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>
</header>

<div class="container">
    <div class="welcome-message">
        <h3>Welcome, Administrator</h3>
        <p>Manage your portal efficiently with the tools below</p>
    </div>

    <div class="cards">
        <div class="card">
            <div class="card-icon">
                <i class="fas fa-users-cog"></i>
            </div>
            <h3>Manage Users</h3>
            <p>View, edit or delete system users. Control user permissions and access levels for all registered members.</p>
            <a href="manageUsers.jsp"><i class="fas fa-arrow-right"></i> Open User Management</a>
        </div>
          <div class="cards">
        <div class="card">
            <div class="card-icon">
                <i class="fas fa-users-cog"></i>
            </div>
            <h3>Approve the employer</h3>
            <p>View, edit or delete system users. Control user permissions and access levels for all registered members.</p>
            <a href="approveEmployers.jsp"><i class="fas fa-arrow-right"></i> Open approve</a>
        </div>
         <div class="card">
            <div class="card-icon">
                <i class="fas fa-file-pdf"></i>
            </div>
           <h3>View Reports</h3>
           <p>View detailed analytics and reports on platform usage, job postings, and user engagement metrics.</p>
             <a href="adminReports.jsp">Open</a>
           </div>
           
         <div class="card">
          <div class="card-icon">
                <i class="fas fa-file-pdf"></i>
            </div>
    <h3>Manage Jobs</h3>
    <p>View and remove posted jobs.</p>
    <a href="adminJobs1.jsp">Open</a>

        </div>
         
        <div class="card">
            <div class="card-icon">
                <i class="fas fa-file-pdf"></i>
            </div>
            <h3>CV Templates</h3>
            <p>Create and manage professional CV templates. Customize designs and layouts for job seekers.</p>
            <a href="prepareCV.jsp"><i class="fas fa-arrow-right"></i> Open CV Templates</a>
        </div>
    </div>
</div>

</body>
</html>