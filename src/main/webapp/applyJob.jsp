```jsp
<%@ page session="true" %>
<%
    // Make sure the user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    String role = (String) session.getAttribute("role");

    if(userId == null || !role.equals("JOBSEEKER")){
        response.sendRedirect("login.jsp");
        return;
    }

    // Get jobId from request parameter
    String jobIdParam = request.getParameter("jobId");
    int jobId = 0;
    if(jobIdParam != null){
        jobId = Integer.parseInt(jobIdParam);
    } else {
        out.println("Error: Job ID not specified!");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Apply for Job - JobPortal</title>
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
            padding: 15px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        /* Container Styling */
        .apply-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 700px;
            position: relative;
            overflow: visible;
            animation: fadeIn 0.8s ease-out;
            margin-top: 20px;
        }

        .apply-container::before {
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
            padding: 1.5rem 1.5rem 1rem 1.5rem;
        }

        h2 {
            font-size: 1.6rem;
            color: #2b2d42;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 0.8rem;
            margin-bottom: 1rem;
        }

        h2 i {
            font-size: 1.6rem;
            color: #4361ee;
        }

        /* Job ID Banner */
        .job-banner {
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            padding: 0.7rem 1.2rem;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
            font-size: 0.9rem;
        }

        .job-banner i {
            font-size: 1rem;
        }

        /* Form Area */
        .form-area {
            padding: 0 1.5rem 1.5rem 1.5rem;
        }

        /* Form Styling */
        .application-form {
            display: flex;
            flex-direction: column;
            gap: 1.2rem;
        }

        .form-group {
            text-align: left;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            color: #2b2d42;
            font-weight: 600;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 0.6rem;
        }

        label i {
            color: #4361ee;
            font-size: 1rem;
        }

        textarea, input[type="text"], input[type="email"] {
            width: 100%;
            padding: 0.9rem 1rem;
            border-radius: 8px;
            border: 2px solid #e5e7eb;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        textarea:focus, input[type="text"]:focus, input[type="email"]:focus {
            outline: none;
            border-color: #4361ee;
            background: white;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        textarea {
            min-height: 120px;
            resize: vertical;
            line-height: 1.5;
        }

        #notes {
            min-height: 80px;
        }

        /* Required Field Indicator */
        .required {
            color: #ef4444;
            margin-left: 3px;
        }

        /* Submit Button */
        .submit-btn {
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
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.8rem;
            margin-top: 0.5rem;
        }

        .submit-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* Character Count */
        .char-count {
            text-align: right;
            font-size: 0.8rem;
            color: #6b7280;
            margin-top: 0.3rem;
        }

        /* Action Links */
        .action-links {
            display: flex;
            gap: 0.8rem;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 2px solid #f1f1f1;
            justify-content: center;
            flex-wrap: wrap;
        }

        .action-links a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem;
            background: white;
            color: #4361ee;
            text-decoration: none;
            padding: 0.6rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.85rem;
            transition: all 0.3s ease;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
            border: 2px solid #4361ee;
        }

        .action-links a:hover {
            background: #4361ee;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
        }

        /* Form Tips */
        .form-tips {
            background: linear-gradient(45deg, #f8fafc, #f1f5f9);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid #10b981;
            font-size: 0.85rem;
            color: #4b5563;
        }

        .form-tips h4 {
            color: #10b981;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-tips ul {
            padding-left: 1.2rem;
        }

        .form-tips li {
            margin-bottom: 0.3rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .header {
                padding: 1rem 1rem 0.8rem 1rem;
            }
            
            .form-area {
                padding: 0 1rem 1rem 1rem;
            }
            
            h2 {
                font-size: 1.4rem;
            }
            
            .action-links {
                flex-direction: column;
                gap: 0.6rem;
            }
            
            .action-links a {
                width: 100%;
                justify-content: center;
            }
            
            textarea, input[type="text"], input[type="email"] {
                padding: 0.8rem;
                font-size: 0.9rem;
            }
            
            .submit-btn {
                padding: 0.8rem 1.2rem;
                font-size: 0.9rem;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 0.8rem 0.8rem 0.6rem 0.8rem;
            }
            
            .form-area {
                padding: 0 0.8rem 0.8rem 0.8rem;
            }
            
            h2 {
                font-size: 1.3rem;
                gap: 0.6rem;
            }
            
            h2 i {
                font-size: 1.3rem;
            }
            
            .job-banner {
                padding: 0.6rem 0.8rem;
                font-size: 0.85rem;
            }
            
            textarea, input[type="text"], input[type="email"] {
                padding: 0.7rem;
                font-size: 0.85rem;
            }
            
            .submit-btn {
                padding: 0.7rem 1rem;
                font-size: 0.85rem;
            }
            
            .action-links a {
                padding: 0.5rem 0.8rem;
                font-size: 0.8rem;
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
        .form-group:nth-child(3) { animation-delay: 0.3s; }
        .form-group:nth-child(4) { animation-delay: 0.4s; }
        .form-group:nth-child(5) { animation-delay: 0.5s; }
        .submit-btn { animation-delay: 0.6s; }

        /* Success/Error Messages */
        .alert {
            padding: 0.8rem 1rem;
            border-radius: 8px;
            margin: 0 1.5rem 1rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
            animation: slideIn 0.5s ease-out;
            font-size: 0.9rem;
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
    <div class="apply-container">
        <div class="header">
            <h2><i class="fas fa-paper-plane"></i> Apply for Job</h2>
            
            <div class="job-banner">
                <i class="fas fa-hashtag"></i>
                <span>Job ID: #<%= jobId %></span>
            </div>
        </div>

        <div class="form-area">
            <div class="form-tips">
                <h4><i class="fas fa-lightbulb"></i> Application Tips</h4>
                <ul>
                    <li>Write a compelling cover letter that highlights your relevant experience</li>
                    <li>Make sure your resume link is accessible and up-to-date</li>
                    <li>Provide a professional email address for contact</li>
                    <li>Be specific about why you're interested in this position</li>
                </ul>
            </div>

            <form class="application-form" action="ApplyJobServlet" method="post">
                <input type="hidden" name="jobId" value="<%= jobId %>">
                
                <div class="form-group">
                    <label for="coverLetter">
                        <i class="fas fa-file-alt"></i> Cover Letter <span class="required">*</span>
                    </label>
                    <textarea id="coverLetter" name="coverLetter" placeholder="Write your cover letter here. Explain why you're the best candidate for this position..." required></textarea>
                    <div class="char-count" id="coverLetterCount">Characters: <span id="coverLetterChar">0</span></div>
                </div>
                
                <div class="form-group">
                    <label for="resume">
                        <i class="fas fa-file-pdf"></i> Resume URL/Link
                    </label>
                    <input type="text" id="resume" name="resume" placeholder="e.g., https://drive.google.com/file/d/... or link to your resume">
                </div>
                
                <div class="form-group">
                    <label for="contactEmail">
                        <i class="fas fa-envelope"></i> Contact Email
                    </label>
                    <input type="email" id="contactEmail" name="contactEmail" placeholder="your.email@example.com">
                </div>
                
                <div class="form-group">
                    <label for="notes">
                        <i class="fas fa-sticky-note"></i> Additional Notes
                    </label>
                    <textarea id="notes" name="notes" placeholder="Any additional information you'd like to share with the employer..."></textarea>
                    <div class="char-count" id="notesCount">Characters: <span id="notesChar">0</span></div>
                </div>
                
                <button type="submit" class="submit-btn">
                    <i class="fas fa-paper-plane"></i> Submit Application
                </button>
            </form>

            <div class="action-links">
                <a href="jobseekerDashboard.jsp">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
                <a href="jobSearch.jsp">
                    <i class="fas fa-search"></i> Search More Jobs
                </a>
            </div>
        </div>
    </div>

    <script>
        // Character count for cover letter
        const coverLetterTextarea = document.getElementById('coverLetter');
        const coverLetterChar = document.getElementById('coverLetterChar');
        
        coverLetterTextarea.addEventListener('input', function() {
            coverLetterChar.textContent = this.value.length;
            
            // Color coding based on length
            if (this.value.length < 50) {
                coverLetterChar.style.color = '#ef4444';
            } else if (this.value.length < 150) {
                coverLetterChar.style.color = '#f59e0b';
            } else {
                coverLetterChar.style.color = '#10b981';
            }
        });

        // Character count for notes
        const notesTextarea = document.getElementById('notes');
        const notesChar = document.getElementById('notesChar');
        
        if (notesTextarea) {
            notesTextarea.addEventListener('input', function() {
                notesChar.textContent = this.value.length;
                
                // Color coding based on length
                if (this.value.length > 500) {
                    notesChar.style.color = '#ef4444';
                } else if (this.value.length > 300) {
                    notesChar.style.color = '#f59e0b';
                } else {
                    notesChar.style.color = '#6b7280';
                }
            });
        }

        // Form submission loading state
        document.querySelector('.application-form').addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('.submit-btn');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';
            submitBtn.style.pointerEvents = 'none';
            
            // Reset after 5 seconds if something goes wrong
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.style.pointerEvents = 'auto';
            }, 5000);
        });

        // Add focus effects to form inputs
        document.querySelectorAll('textarea, input[type="text"], input[type="email"]').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'translateY(-2px)';
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'translateY(0)';
            });
        });

        // Action links hover effect
        document.querySelectorAll('.action-links a').forEach(link => {
            link.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
            });
            
            link.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Auto-focus on first textarea
        coverLetterTextarea.focus();

        // Validate resume URL format
        const resumeInput = document.getElementById('resume');
        if (resumeInput) {
            resumeInput.addEventListener('blur', function() {
                const value = this.value.trim();
                if (value && !value.startsWith('http://') && !value.startsWith('https://')) {
                    this.style.borderColor = '#f59e0b';
                    this.style.boxShadow = '0 0 0 3px rgba(245, 158, 11, 0.1)';
                } else if (value) {
                    this.style.borderColor = '#10b981';
                    this.style.boxShadow = '0 0 0 3px rgba(16, 185, 129, 0.1)';
                }
            });
        }

        // Validate email format
        const emailInput = document.getElementById('contactEmail');
        if (emailInput) {
            emailInput.addEventListener('blur', function() {
                const value = this.value.trim();
                const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                
                if (value && !emailPattern.test(value)) {
                    this.style.borderColor = '#ef4444';
                    this.style.boxShadow = '0 0 0 3px rgba(239, 68, 68, 0.1)';
                } else if (value) {
                    this.style.borderColor = '#10b981';
                    this.style.boxShadow = '0 0 0 3px rgba(16, 185, 129, 0.1)';
                }
            });
        }
    </script>
</body>
</html>
```