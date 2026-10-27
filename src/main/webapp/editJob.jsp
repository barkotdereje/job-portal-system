<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    Integer employerId = (Integer) session.getAttribute("employerId");
    if (employerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int jobId = Integer.parseInt(request.getParameter("id"));
    String title = "";
    String description = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
            "root", ""
        );
        PreparedStatement ps = con.prepareStatement(
            "SELECT title, description FROM jobs WHERE id=? AND employer_id=?"
        );
        ps.setInt(1, jobId);
        ps.setInt(2, employerId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            title = rs.getString("title");
            description = rs.getString("description");
        } else {
            response.sendRedirect("manageJobsEmployer.jsp");
        }
        con.close();
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<html>
<head>
    <title>Edit Job - JobPortal</title>
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

        /* Form Container */
        .form-container {
            background: white;
            border-radius: 15px;
            padding: 3rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            text-align: center;
            position: relative;
            overflow: hidden;
            animation: fadeIn 0.8s ease-out;
        }

        .form-container::before {
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
            justify-content: center;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        h2 {
            font-size: 2rem;
            color: #2b2d42;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        h2 i {
            font-size: 2rem;
            color: #4361ee;
        }

        /* Form Styling */
        .edit-form {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .form-group {
            text-align: left;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: #2b2d42;
            font-weight: 600;
            font-size: 0.95rem;
        }

        input, textarea {
            width: 100%;
            padding: 1rem 1.2rem;
            border-radius: 8px;
            border: 2px solid #e5e7eb;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: #4361ee;
            background: white;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        textarea {
            min-height: 200px;
            resize: vertical;
            line-height: 1.6;
        }

        /* Hidden Input */
        input[type="hidden"] {
            display: none;
        }

        /* Submit Button */
        .submit-btn {
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
            margin-top: 1rem;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.8rem;
        }

        .submit-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* Back Link */
        .back-link {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 2px solid #f1f1f1;
        }

        .back-link a {
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
            font-size: 0.95rem;
            transition: all 0.3s ease;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
            border: 2px solid #4361ee;
        }

        .back-link a:hover {
            background: #4361ee;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
        }

        /* Job ID Banner */
        .job-banner {
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

        .job-banner i {
            font-size: 1.2rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }
            
            .form-container {
                padding: 2rem;
            }
            
            h2 {
                font-size: 1.6rem;
            }
            
            input, textarea {
                padding: 0.9rem 1rem;
            }
            
            .submit-btn {
                padding: 0.9rem 1.2rem;
                font-size: 0.95rem;
            }
        }

        @media (max-width: 480px) {
            .form-container {
                padding: 1.5rem;
            }
            
            h2 {
                font-size: 1.4rem;
                margin-bottom: 1.5rem;
            }
            
            .header i {
                font-size: 1.5rem;
            }
            
            .submit-btn {
                padding: 0.8rem 1rem;
                font-size: 0.9rem;
            }
            
            .back-link a {
                padding: 0.6rem 1rem;
                font-size: 0.9rem;
            }
            
            .job-banner {
                padding: 0.6rem 1rem;
                font-size: 0.9rem;
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

        .form-group {
            animation: fadeIn 0.6s ease-out;
        }

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .submit-btn { animation-delay: 0.3s; }
        .back-link { animation-delay: 0.4s; }

        /* Required Field Indicator */
        .required {
            color: #ef4444;
            margin-left: 4px;
        }

        /* Character Count */
        .char-count {
            text-align: right;
            font-size: 0.85rem;
            color: #6b7280;
            margin-top: 0.3rem;
        }

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
    <div class="form-container">
        <div class="header">
            <i class="fas fa-edit"></i>
            <h2>Edit Job Listing</h2>
        </div>
        
        <div class="job-banner">
            <i class="fas fa-hashtag"></i>
            <span>Editing Job ID: #<%= jobId %></span>
        </div>
        
        <form class="edit-form" action="editJob" method="post">
            <input type="hidden" name="id" value="<%= jobId %>">
            
            <div class="form-group">
                <label class="form-label">Job Title <span class="required">*</span></label>
                <input type="text" name="title" value="<%= title %>" placeholder="Enter job title" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">Job Description <span class="required">*</span></label>
                <textarea name="description" placeholder="Enter job description, requirements, responsibilities..." required><%= description %></textarea>
                <div class="char-count" id="charCount">Characters: <span id="count"><%= description.length() %></span></div>
            </div>
            
            <button type="submit" class="submit-btn">
                <i class="fas fa-save"></i> Update Job
            </button>
        </form>
        
        <div class="back-link">
            <a href="manageJobsEmployer.jsp">
                <i class="fas fa-arrow-left"></i> Back to Manage Jobs
            </a>
        </div>
    </div>

    <script>
        // Character count for description textarea
        const textarea = document.querySelector('textarea[name="description"]');
        const charCount = document.getElementById('count');
        
        textarea.addEventListener('input', function() {
            charCount.textContent = this.value.length;
            
            // Optional: Add color coding for character count
            if (this.value.length < 50) {
                charCount.style.color = '#ef4444';
            } else if (this.value.length < 100) {
                charCount.style.color = '#f59e0b';
            } else {
                charCount.style.color = '#10b981';
            }
        });

        // Add focus effects to form inputs
        document.querySelectorAll('input, textarea').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'translateY(-2px)';
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'translateY(0)';
            });
        });

        // Form submission loading state
        document.querySelector('.edit-form').addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('.submit-btn');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
            submitBtn.style.pointerEvents = 'none';
            
            // Reset after 5 seconds if something goes wrong
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.style.pointerEvents = 'auto';
            }, 5000);
        });

        // Back link hover effect
        const backLink = document.querySelector('.back-link a');
        backLink.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-2px)';
        });
        
        backLink.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });

        // Auto-focus on first input field
        document.querySelector('input[name="title"]').focus();
    </script>
</body>
</html>