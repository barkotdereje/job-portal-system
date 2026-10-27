<%@ page session="true" %>
<html>
<head>
    <title>Employer Dashboard - JobPortal</title>
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
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Dashboard Container */
        .dashboard-container {
            background: white;
            border-radius: 15px;
            padding: 3rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .dashboard-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #4361ee, #3a0ca3);
        }

        h2 {
            font-size: 2rem;
            color: #2b2d42;
            margin-bottom: 2rem;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Navigation Container */
        .nav {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        /* Navigation Links - Consistent with Home Page */
        .nav a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.8rem;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            text-decoration: none;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
            border: none;
            cursor: pointer;
        }

        .nav a:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* Special styling for logout button */
        .nav a[href="logout.jsp"] {
            background: linear-gradient(45deg, #ef4444, #dc2626);
            box-shadow: 0 5px 15px rgba(239, 68, 68, 0.3);
            margin-top: 1rem;
        }

        .nav a[href="logout.jsp"]:hover {
            background: linear-gradient(45deg, #dc2626, #ef4444);
            box-shadow: 0 8px 20px rgba(239, 68, 68, 0.4);
        }

        /* User Info Banner */
        .user-banner {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            padding: 0.8rem 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
        }

        .user-banner i {
            font-size: 1.2rem;
        }

        /* Quick Stats */
        .quick-stats {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            justify-content: center;
        }

        .stat-item {
            background: #f8f9fa;
            padding: 1rem 1.5rem;
            border-radius: 10px;
            border: 2px solid #e5e7eb;
            text-align: center;
            min-width: 120px;
            transition: all 0.3s ease;
        }

        .stat-item:hover {
            border-color: #4361ee;
            transform: translateY(-5px);
        }

        .stat-value {
            font-size: 1.8rem;
            color: #4361ee;
            font-weight: 700;
        }

        .stat-label {
            color: #6b7280;
            font-size: 0.9rem;
            margin-top: 0.3rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }
            
            .dashboard-container {
                padding: 2rem;
                max-width: 500px;
            }
            
            h2 {
                font-size: 1.6rem;
            }
            
            .nav a {
                padding: 0.9rem 1.2rem;
                font-size: 0.95rem;
            }
            
            .quick-stats {
                flex-wrap: wrap;
            }
            
            .stat-item {
                flex: 1;
                min-width: calc(50% - 0.5rem);
            }
        }

        @media (max-width: 480px) {
            .dashboard-container {
                padding: 1.5rem;
            }
            
            h2 {
                font-size: 1.4rem;
                margin-bottom: 1.5rem;
            }
            
            .nav a {
                padding: 0.8rem 1rem;
                font-size: 0.9rem;
            }
            
            .user-banner {
                padding: 0.6rem 1rem;
                font-size: 0.9rem;
            }
            
            .stat-item {
                min-width: 100%;
            }
            
            .stat-value {
                font-size: 1.5rem;
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

        .dashboard-container {
            animation: fadeIn 0.8s ease-out;
        }

        .nav a {
            animation: fadeIn 0.6s ease-out;
        }

        .nav a:nth-child(1) { animation-delay: 0.1s; }
        .nav a:nth-child(2) { animation-delay: 0.2s; }
        .nav a:nth-child(3) { animation-delay: 0.3s; }
        .nav a:nth-child(4) { animation-delay: 0.4s; }
        .nav a:nth-child(5) { animation-delay: 0.5s; }
    </style>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="dashboard-container">
        <h2>Welcome Employer!</h2>
        
        <div class="user-banner">
            <i class="fas fa-user-tie"></i>
            <span>Employer Dashboard</span>
        </div>
        
        <!-- Quick Stats (can be populated with dynamic data if available) -->
        <div class="quick-stats">
            <div class="stat-item">
                <div class="stat-value">5</div>
                <div class="stat-label">Active Jobs</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">12</div>
                <div class="stat-label">Applications</div>
            </div>
        </div>
        
        <div class="nav">
            <a href="postJob.jsp"><i class="fas fa-plus-circle"></i> Post a Job</a>
            <a href="manageJobsEmployer.jsp"><i class="fas fa-tasks"></i> Manage Jobs</a>
            <a href="viewApplications.jsp"><i class="fas fa-file-alt"></i> View Applications</a>
            <a href="employerProfile.jsp"><i class="fas fa-user-cog"></i> Manage Account</a>
            <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <script>
        // Add hover effects to links
        document.querySelectorAll('.nav a').forEach(link => {
            link.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-3px)';
            });
            
            link.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Add loading state to links
        document.querySelectorAll('.nav a').forEach(link => {
            link.addEventListener('click', function(e) {
                // Only add loading if it's a valid link
                if(this.getAttribute('href') !== '#') {
                    const originalText = this.innerHTML;
                    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';
                    this.style.pointerEvents = 'none';
                    
                    // Reset after 3 seconds if something goes wrong
                    setTimeout(() => {
                        this.innerHTML = originalText;
                        this.style.pointerEvents = 'auto';
                    }, 3000);
                }
            });
        });

        // Add hover effect to stat items
        document.querySelectorAll('.stat-item').forEach(stat => {
            stat.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-5px)';
                this.style.borderColor = '#4361ee';
            });
            
            stat.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
                this.style.borderColor = '#e5e7eb';
            });
        });
    </script>
</body>
</html>