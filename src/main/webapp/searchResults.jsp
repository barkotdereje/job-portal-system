<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page session="true" %>

<%
    String keyword = (String) request.getAttribute("keyword");
    if(keyword == null) keyword = "";
    Connection con = DBConnection.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM jobs WHERE title LIKE ? OR description LIKE ? ORDER BY created_at DESC"
    );
    ps.setString(1, "%" + keyword + "%");
    ps.setString(2, "%" + keyword + "%");
    ResultSet rs = ps.executeQuery();
%>

<html>
<head>
    <title>Search Results - JobPortal</title>
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
            flex-direction: column;
            align-items: center;
        }

        /* Container Styling */
        .search-container {
            background: white;
            border-radius: 15px;
            padding: 2.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 1000px;
            position: relative;
            overflow: hidden;
            animation: fadeIn 0.8s ease-out;
            margin-top: 20px;
        }

        .search-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #4361ee, #3a0ca3);
        }

        /* Header Styling */
        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        h2 {
            font-size: 1.8rem;
            color: #2b2d42;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        h2 i {
            font-size: 1.8rem;
            color: #4361ee;
        }

        /* Search Banner */
        .search-banner {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
        }

        .search-banner i {
            font-size: 1.2rem;
        }

        /* Job Cards Grid */
        .job-cards {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .job-card {
            background: linear-gradient(45deg, #ffffff, #f8fafc);
            padding: 1.8rem;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border-left: 4px solid #4361ee;
            position: relative;
            overflow: hidden;
        }

        .job-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(67, 97, 238, 0.15);
            background: linear-gradient(45deg, #ffffff, #f1f5f9);
        }

        .job-card h3 {
            font-size: 1.4rem;
            color: #2b2d42;
            margin-bottom: 0.8rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .job-card h3 i {
            color: #4361ee;
            font-size: 1.3rem;
        }

        .job-description {
            color: #4b5563;
            margin-bottom: 1.2rem;
            line-height: 1.6;
            font-size: 0.95rem;
        }

        .job-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1.2rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            color: #6b7280;
            font-size: 0.9rem;
        }

        .meta-item i {
            color: #4361ee;
            font-size: 1rem;
        }

        .meta-value {
            font-weight: 600;
            color: #2b2d42;
        }

        /* Apply Button */
        .apply-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            text-decoration: none;
            padding: 0.9rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
            border: none;
            cursor: pointer;
        }

        .apply-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* Results Count */
        .results-count {
            background: linear-gradient(45deg, #10b981, #059669);
            color: white;
            padding: 0.6rem 1.2rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        /* No Results Message */
        .no-results {
            text-align: center;
            padding: 3rem 2rem;
            color: #6b7280;
        }

        .no-results i {
            font-size: 3rem;
            color: #d1d5db;
            margin-bottom: 1rem;
        }

        .no-results h3 {
            color: #4b5563;
            margin-bottom: 0.5rem;
            font-size: 1.4rem;
        }

        .no-results p {
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
        }

        .back-search-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            text-decoration: none;
            padding: 0.9rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
            border: none;
            cursor: pointer;
        }

        .back-search-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* Search Highlight */
        .highlight {
            background: linear-gradient(45deg, #fde68a, #fbbf24);
            color: #92400e;
            padding: 0.1rem 0.3rem;
            border-radius: 4px;
            font-weight: 600;
        }

        /* Footer Links */
        .footer-links {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 2px solid #f1f1f1;
            justify-content: center;
            flex-wrap: wrap;
        }

        .footer-links a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.8rem;
            background: white;
            color: #4361ee;
            text-decoration: none;
            padding: 0.8rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
            border: 2px solid #4361ee;
        }

        .footer-links a:hover {
            background: #4361ee;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }
            
            .search-container {
                padding: 2rem;
            }
            
            h2 {
                font-size: 1.5rem;
            }
            
            .job-card {
                padding: 1.5rem;
            }
            
            .job-card h3 {
                font-size: 1.2rem;
            }
            
            .job-meta {
                flex-direction: column;
                gap: 0.8rem;
            }
            
            .apply-btn {
                width: 100%;
                justify-content: center;
            }
            
            .footer-links {
                flex-direction: column;
            }
            
            .footer-links a {
                width: 100%;
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .search-container {
                padding: 1.5rem;
            }
            
            h2 {
                font-size: 1.3rem;
                gap: 0.6rem;
            }
            
            h2 i {
                font-size: 1.4rem;
            }
            
            .search-banner {
                padding: 0.8rem 1rem;
                font-size: 0.9rem;
                gap: 0.6rem;
            }
            
            .job-card {
                padding: 1.2rem;
            }
            
            .apply-btn {
                padding: 0.8rem 1.2rem;
                font-size: 0.9rem;
            }
            
            .results-count {
                padding: 0.5rem 1rem;
                font-size: 0.85rem;
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

        .job-card {
            animation: fadeIn 0.6s ease-out;
        }

        .job-card:nth-child(1) { animation-delay: 0.1s; }
        .job-card:nth-child(2) { animation-delay: 0.2s; }
        .job-card:nth-child(3) { animation-delay: 0.3s; }
        .job-card:nth-child(4) { animation-delay: 0.4s; }
        .job-card:nth-child(5) { animation-delay: 0.5s; }

        /* Success/Error Messages */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            animation: slideIn 0.5s ease-out;
        }

        .alert-success {
            background: linear-gradient(45deg, #10b981, #059669);
            color: white;
        }

        .alert-error {
            background: linear-gradient(45deg, #ef4444, #dc2626);
            color: white;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
    </style>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="search-container">
        <div class="header">
            <h2><i class="fas fa-search"></i> Search Results</h2>
            
            <div class="search-banner">
                <i class="fas fa-filter"></i>
                <span>Showing results for: "<%= keyword %>"</span>
            </div>
        </div>

        <%
            int resultCount = 0;
            boolean hasResults = false;
        %>

        <div class="job-cards">
            <%
            while(rs.next()) {
                hasResults = true;
                resultCount++;
                String jobTitle = rs.getString("title");
                String jobDescription = rs.getString("description");
                String companyEmail = rs.getString("company_email");
                java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
                
                // Format date for display
                String formattedDate = "";
                if (createdAt != null) {
                    formattedDate = createdAt.toString();
                    if (formattedDate.length() > 16) {
                        formattedDate = formattedDate.substring(0, 16);
                    }
                }
                
                // Highlight keyword in title and description
                if (!keyword.isEmpty()) {
                    jobTitle = jobTitle.replaceAll("(?i)" + keyword, "<span class='highlight'>$0</span>");
                    jobDescription = jobDescription.replaceAll("(?i)" + keyword, "<span class='highlight'>$0</span>");
                }
            %>
                <div class="job-card">
                    <h3><i class="fas fa-briefcase"></i> <%= jobTitle %></h3>
                    
                    <div class="job-description">
                        <%= jobDescription.length() > 300 ? jobDescription.substring(0, 300) + "..." : jobDescription %>
                    </div>
                    
                    <div class="job-meta">
                        <div class="meta-item">
                            <i class="fas fa-envelope"></i>
                            <span class="meta-label">Company Email:</span>
                            <span class="meta-value"><%= companyEmail %></span>
                        </div>
                        
                        <div class="meta-item">
                            <i class="fas fa-calendar-alt"></i>
                            <span class="meta-label">Posted on:</span>
                            <span class="meta-value"><%= formattedDate %></span>
                        </div>
                    </div>
                    
                     
                    <a href="applyJob?jobId=<%= rs.getInt("id") %>" class="apply-btn">
                        <i class="fas fa-paper-plane"></i> Apply Now
                    </a>
                </div>
            <%
            }
            con.close();
            
            if (!hasResults) {
            %>
                <div class="no-results">
                    <i class="fas fa-search-minus"></i>
                    <h3>No Results Found</h3>
                    <p>No jobs found matching your search for "<%= keyword %>".</p>
                    <a href="jobseekerDashboard.jsp" class="back-search-btn">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            <%
            } else {
            %>
                <div class="results-count">
                    <i class="fas fa-chart-bar"></i>
                    <span>Found <%= resultCount %> <%= resultCount == 1 ? "job" : "jobs" %> matching your search</span>
                </div>
            <%
            }
            %>
        </div>

        <div class="footer-links">
            <a href="jobseekerDashboard.jsp">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="jobSearch.jsp">
                <i class="fas fa-search"></i> New Search
            </a>
            <a href="logout.jsp">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <script>
        // Add hover effects to job cards
        document.querySelectorAll('.job-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-5px)';
                this.style.cursor = 'pointer';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Add loading state to apply buttons
        document.querySelectorAll('.apply-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Applying...';
                this.style.pointerEvents = 'none';
                
                // Reset after 5 seconds if something goes wrong
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.style.pointerEvents = 'auto';
                }, 5000);
            });
        });

        // Footer links hover effect
        document.querySelectorAll('.footer-links a').forEach(link => {
            link.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
            });
            
            link.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Back search button hover effect
        const backSearchBtn = document.querySelector('.back-search-btn');
        if (backSearchBtn) {
            backSearchBtn.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-3px)';
            });
            
            backSearchBtn.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        }

        // Show keyword highlights on page load
        const highlights = document.querySelectorAll('.highlight');
        highlights.forEach(highlight => {
            highlight.addEventListener('mouseenter', function() {
                this.style.transform = 'scale(1.05)';
            });
            
            highlight.addEventListener('mouseleave', function() {
                this.style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>