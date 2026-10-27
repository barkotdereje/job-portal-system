<%@ page session="true" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) {
        response.sendRedirect("index.jsp"); // redirect to login if not admin
    }
%>

<html>
<head>
    <title>Prepare CV Template - JobPortal Admin</title>
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

        .back-button {
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

        .back-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* Container */
        .container {
            padding: 3rem 5%;
            max-width: 800px;
            margin: 0 auto;
        }

        /* Page Header */
        .page-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .page-header h2 {
            font-size: 2rem;
            color: #2b2d42;
            margin-bottom: 0.5rem;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .page-header p {
            color: #6c757d;
            font-size: 1rem;
        }

        /* Form Container */
        .form-container {
            background: white;
            border-radius: 15px;
            padding: 2.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
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

        /* Form Groups */
        .form-group {
            margin-bottom: 1.8rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.8rem;
            color: #2b2d42;
            font-weight: 600;
            font-size: 1rem;
        }

        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 1rem;
            color: #4b5563;
            background: #f9fafb;
            transition: all 0.3s ease;
            resize: vertical;
        }

        .form-group input[type="text"]:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #4361ee;
            background: white;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }

        .form-group textarea {
            min-height: 200px;
            font-family: 'Courier New', monospace;
            line-height: 1.6;
        }

        /* Submit Button */
        .submit-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            border: none;
            padding: 1rem 2.5rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
            margin-top: 1rem;
        }

        .submit-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
            background: linear-gradient(45deg, #3a0ca3, #4361ee);
        }

        /* CV Template Preview */
        .preview-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-top: 2rem;
            border: 2px dashed #d1d5db;
        }

        .preview-section h3 {
            color: #2b2d42;
            margin-bottom: 1rem;
            font-size: 1.3rem;
        }

        .preview-box {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            min-height: 150px;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
            line-height: 1.5;
            color: #4b5563;
            border: 1px solid #e5e7eb;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            header {
                flex-direction: column;
                gap: 1rem;
                padding: 1rem;
            }
            
            .logo h2 {
                font-size: 1.5rem;
            }
            
            .logo-icon {
                width: 35px;
                height: 35px;
                font-size: 1rem;
            }
            
            .container {
                padding: 2rem 1.5rem;
            }
            
            .page-header h2 {
                font-size: 1.6rem;
            }
            
            .form-container {
                padding: 2rem;
            }
            
            .form-group textarea {
                min-height: 150px;
            }
        }

        @media (max-width: 480px) {
            .logo h2 {
                font-size: 1.3rem;
            }
            
            .back-button {
                padding: 0.6rem 1rem;
                font-size: 0.9rem;
            }
            
            .form-container {
                padding: 1.5rem;
            }
            
            .form-group {
                margin-bottom: 1.5rem;
            }
            
            .submit-button {
                width: 100%;
                justify-content: center;
                padding: 1rem;
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

        .form-container {
            animation: fadeIn 0.8s ease-out;
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
            <i class="fas fa-file-alt"></i>
        </div>
        <h2>CV Template Editor</h2>
    </div>
    <a href="adminDashboard.jsp" class="back-button">
        <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
</header>

<div class="container">
    <div class="page-header">
        <h2>Create CV Template</h2>
        <p>Design professional CV templates for job seekers</p>
    </div>

    <div class="form-container">
        <form action="SaveCVServlet" method="post" id="cvForm">
            <div class="form-group">
                <label for="templateName">
                    <i class="fas fa-heading"></i> Template Name
                </label>
                <input type="text" id="templateName" name="templateName" placeholder="Enter template name (e.g., Professional, Modern, Creative)" required>
            </div>
            
            <div class="form-group">
                <label for="content">
                    <i class="fas fa-code"></i> Template Content (HTML allowed)
                </label>
                <textarea id="content" name="content" placeholder="Enter template content. You can use HTML tags for formatting. Example: &#60;h1&#62;{name}&#60;/h1&#62; &#60;p&#62;{email}&#60;/p&#62;" required></textarea>
            </div>
            
            <div class="preview-section">
                <h3><i class="fas fa-eye"></i> Preview Note</h3>
                <div class="preview-box">
                    <strong>Available Variables:</strong><br>
                    {name} - User's full name<br>
                    {email} - User's email<br>
                    {phone} - User's phone number<br>
                    {education} - Education details<br>
                    {experience} - Work experience<br>
                    {skills} - Skills list<br>
                    <br>
                    <strong>Example:</strong><br>
                    &lt;h1&gt;{name}&lt;/h1&gt;<br>
                    &lt;p&gt;Email: {email}&lt;/p&gt;<br>
                    &lt;h2&gt;Education&lt;/h2&gt;<br>
                    &lt;p&gt;{education}&lt;/p&gt;
                </div>
            </div>
            
            <button type="submit" class="submit-button">
                <i class="fas fa-save"></i> Save Template
            </button>
        </form>
    </div>
</div>

<script>
    // Form validation and preview
    const form = document.getElementById('cvForm');
    const contentTextarea = document.getElementById('content');
    const previewBox = document.querySelector('.preview-box');
    
    // Update preview when typing
    contentTextarea.addEventListener('input', function() {
        const previewText = this.value
            .replace(/{name}/g, '<span style="color: #4361ee;">[Full Name]</span>')
            .replace(/{email}/g, '<span style="color: #4361ee;">[Email Address]</span>')
            .replace(/{phone}/g, '<span style="color: #4361ee;">[Phone Number]</span>')
            .replace(/{education}/g, '<span style="color: #4361ee;">[Education Details]</span>')
            .replace(/{experience}/g, '<span style="color: #4361ee;">[Work Experience]</span>')
            .replace(/{skills}/g, '<span style="color: #4361ee;">[Skills List]</span>');
        
        previewBox.innerHTML = '<strong>Template Preview:</strong><br><br>' + previewText;
    });
    
    // Form submission with loading state
    form.addEventListener('submit', function(e) {
        const submitButton = this.querySelector('.submit-button');
        const originalText = submitButton.innerHTML;
        
        // Show loading state
        submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving Template...';
        submitButton.disabled = true;
        
        // Reset after 5 seconds if something goes wrong
        setTimeout(() => {
            submitButton.innerHTML = originalText;
            submitButton.disabled = false;
        }, 5000);
    });
    
    // Add focus effects
    document.querySelectorAll('input, textarea').forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.style.transform = 'translateY(-2px)';
        });
        
        input.addEventListener('blur', function() {
            this.parentElement.style.transform = 'translateY(0)';
        });
    });
</script>

</body>
</html>