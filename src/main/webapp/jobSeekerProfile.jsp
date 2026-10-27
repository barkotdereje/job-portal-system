<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.io.File, java.util.Map, java.util.HashMap" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) { response.sendRedirect("login.jsp"); return; }

    Map<String, String> cvData = new HashMap<>();
    boolean hasCV = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/1job_portal?useSSL=false&serverTimezone=UTC",
            "root", "");
        PreparedStatement ps = con.prepareStatement("SELECT * FROM cv WHERE user_id=?");
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            hasCV = true;
            cvData.put("skills", rs.getString("skills"));
            cvData.put("education", rs.getString("education"));
            cvData.put("experience", rs.getString("experience"));
        }
        con.close();
    } catch (Exception e) { e.printStackTrace(); }

    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("message"); session.removeAttribute("error");
%>

<style>
    /* Modern Reset - Consistent with Dashboard */
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
    
    /* Section Title */
    .section-title {font-size:1.5rem;color:#2b2d42;margin:2rem 0 1.5rem 0;font-weight:700;background:linear-gradient(45deg,#4361ee,#3a0ca3);-webkit-background-clip:text;-webkit-text-fill-color:transparent;display:flex;align-items:center;gap:0.8rem;padding-bottom:0.5rem;border-bottom:3px solid #e5e7eb;}
    
    /* CV Card */
    .cv-card {background:white;padding:2.5rem;border-radius:12px;box-shadow:0 5px 25px rgba(0,0,0,0.1);margin-bottom:2rem;border-left:4px solid #4361ee;animation:fadeIn 0.6s ease-out;}
    
    /* CV Header */
    .cv-header {background:linear-gradient(45deg,#4361ee,#3a0ca3);color:white;padding:1.5rem;border-radius:12px 12px 0 0;margin:-2.5rem -2.5rem 2rem -2.5rem;}
    .cv-header h2 {font-size:1.8rem;margin:0;font-weight:700;display:flex;align-items:center;gap:1rem;}
    .cv-header i {font-size:1.5rem;}
    
    /* Alert Messages */
    .alert {padding:1rem 1.5rem;border-radius:8px;margin-bottom:1.5rem;display:flex;align-items:center;gap:0.8rem;font-weight:500;border-left:4px solid;}
    .alert-success {background:rgba(16,185,129,0.1);border-color:#10b981;color:#065f46;}
    .alert-error {background:rgba(239,68,68,0.1);border-color:#ef4444;color:#7f1d1d;}
    
    /* Form Styling */
    .form-group {margin-bottom:1.5rem;}
    .form-label {display:block;margin-bottom:0.5rem;color:#2b2d42;font-weight:600;display:flex;align-items:center;gap:0.5rem;}
    .form-control {width:100%;padding:0.8rem 1rem;border:1px solid #d1d5db;border-radius:8px;font-size:1rem;font-family:'Poppins',sans-serif;transition:all 0.3s ease;}
    .form-control:focus {outline:none;border-color:#4361ee;box-shadow:0 0 0 3px rgba(67,97,238,0.1);}
    
    /* Button Styles */
    .btn {display:inline-flex;align-items:center;gap:0.8rem;background:linear-gradient(45deg,#4361ee,#3a0ca3);color:white;text-decoration:none;padding:0.8rem 1.5rem;border-radius:8px;font-weight:600;font-size:0.95rem;transition:all 0.3s ease;box-shadow:0 5px 15px rgba(67,97,238,0.3);border:none;cursor:pointer;}
    .btn:hover {transform:translateY(-3px);box-shadow:0 8px 20px rgba(67,97,238,0.4);background:linear-gradient(45deg,#3a0ca3,#4361ee);}
    .btn-danger {background:linear-gradient(45deg,#ef4444,#dc2626);}
    .btn-danger:hover {background:linear-gradient(45deg,#dc2626,#b91c1c);}
    .btn-success {background:linear-gradient(45deg,#10b981,#059669);}
    .btn-success:hover {background:linear-gradient(45deg,#059669,#047857);}
    .btn-warning {background:linear-gradient(45deg,#f59e0b,#d97706);}
    .btn-warning:hover {background:linear-gradient(45deg,#d97706,#b45309);}
    .btn-outline {background:transparent;color:#4361ee;border:2px solid #4361ee;}
    .btn-outline:hover {background:#4361ee;color:white;}
    
    /* CV Preview */
    .cv-preview {background:#f8fafc;border-radius:12px;padding:1.5rem;margin-bottom:1.5rem;border:1px solid #e5e7eb;}
    .cv-field {margin-bottom:1.2rem;padding-bottom:1.2rem;border-bottom:1px solid #e5e7eb;}
    .cv-field:last-child {border-bottom:none;margin-bottom:0;padding-bottom:0;}
    .field-label {font-weight:600;color:#2b2d42;margin-bottom:0.5rem;display:flex;align-items:center;gap:0.5rem;}
    .field-value {color:#4b5563;line-height:1.6;padding-left:1.5rem;}
    
    /* Resume Section */
    .resume-section {background:#fef3c7;border-radius:12px;padding:1.5rem;margin:1.5rem 0;border:2px dashed #f59e0b;}
    .resume-info {background:white;border-radius:8px;padding:1rem;margin-top:1rem;display:flex;align-items:center;justify-content:space-between;border:1px solid #e5e7eb;}
    .resume-actions {display:flex;gap:0.5rem;}
    
    /* File Upload */
    .file-upload-wrapper {position:relative;overflow:hidden;display:inline-block;width:100%;}
    .file-upload-wrapper input[type="file"] {position:absolute;left:0;top:0;opacity:0;width:100%;height:100%;cursor:pointer;}
    .file-upload-btn {display:flex;align-items:center;justify-content:center;gap:0.5rem;padding:0.8rem;background:white;border:2px dashed #d1d5db;border-radius:8px;color:#6b7280;font-weight:500;cursor:pointer;transition:all 0.3s ease;}
    .file-upload-btn:hover {border-color:#4361ee;color:#4361ee;}
    
    /* Empty State */
    .empty-state {text-align:center;padding:2rem;background:#f9fafb;border-radius:12px;border:2px dashed #d1d5db;margin:1.5rem 0;}
    .empty-state i {font-size:3rem;color:#9ca3af;margin-bottom:1rem;}
    .empty-state h4 {color:#4b5563;margin-bottom:0.5rem;}
    .empty-state p {color:#6b7280;max-width:400px;margin:0 auto 1.5rem;}
    
    /* Button Container */
    .btn-container {display:flex;gap:1rem;margin-top:1.5rem;padding-top:1.5rem;border-top:1px solid #e5e7eb;}
    
    /* Back Link */
    .back-link {display:inline-flex;align-items:center;gap:0.8rem;background:linear-gradient(45deg,#6b7280,#4b5563);color:white;text-decoration:none;padding:0.8rem 1.5rem;border-radius:8px;font-weight:600;font-size:0.95rem;transition:all 0.3s ease;box-shadow:0 5px 15px rgba(107,114,128,0.3);margin-top:1rem;}
    .back-link:hover {transform:translateY(-3px);box-shadow:0 8px 20px rgba(107,114,128,0.4);background:linear-gradient(45deg,#4b5563,#374151);}
    
    /* Animation */
    @keyframes fadeIn{from{opacity:0;transform:translateY(20px);}to{opacity:1;transform:translateY(0);}}
    
    /* Responsive */
    @media (max-width:768px){.btn-container{flex-direction:column;}.btn{width:100%;justify-content:center;}.resume-info{flex-direction:column;gap:1rem;}.resume-actions{width:100%;justify-content:flex-start;}.cv-card{padding:1.5rem;}.cv-header{margin:-1.5rem -1.5rem 1.5rem -1.5rem;}}
</style>

<!-- Navigation -->
<nav>
    <div class="logo"><h1><i class="fas fa-briefcase"></i> JobPortal</h1></div>
    <ul class="nav-links">
        <li><a href="index.jsp"><i class="fas fa-home"></i> Home</a></li>
        <li><a href="jobseekerDashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
        <li><a href="cvPage.jsp" style="background:linear-gradient(45deg,#4361ee,#3a0ca3);color:white;transform:translateY(-2px);box-shadow:0 5px 15px rgba(67,97,238,0.3);"><i class="fas fa-file-alt"></i> CV/Resume</a></li>
        <li><a href="viewJobAlerts"><i class="fas fa-bell"></i> Job Alerts</a></li>
        <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</nav>

<div class="container">
    <div class="cv-card">
        <div class="cv-header">
            <h2><i class="fas fa-file-contract"></i> Professional CV & Resume</h2>
        </div>
        
        <% if (message != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= message %>
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%= error %>
            </div>
        <% } %>
        
        <% if (!hasCV) { %>
            <div class="empty-state">
                <i class="fas fa-file-alt"></i>
                <h4>Build Your Professional CV</h4>
                <p>Create a compelling CV to showcase your skills, education, and experience to potential employers.</p>
                
                <h3 class="section-title"><i class="fas fa-plus-circle"></i> Create New CV</h3>
                
                <form action="cv" method="post">
                    <input type="hidden" name="action" value="build">
                    
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-tools"></i> Skills</label>
                        <input type="text" name="skills" class="form-control" placeholder="Java, HTML/CSS, Project Management, Communication" required>
                        <small style="color:#6b7280;font-size:0.85rem;margin-top:0.25rem;display:block;">Separate skills with commas</small>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-graduation-cap"></i> Education</label>
                        <input type="text" name="education" class="form-control" placeholder="Bachelor of Science in Computer Science, University of..." required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-briefcase"></i> Experience</label>
                        <input type="text" name="experience" class="form-control" placeholder="3+ years as Software Developer at Tech Company" required>
                    </div>
                    
                    <div class="btn-container">
                        <button type="submit" class="btn">
                            <i class="fas fa-save"></i> Save CV
                        </button>
                    </div>
                </form>
            </div>
        <% } else { %>
            <!-- CV Preview Section -->
            <div class="cv-preview">
                <h3 class="section-title"><i class="fas fa-eye"></i> CV Preview</h3>
                
                <div class="cv-field">
                    <div class="field-label"><i class="fas fa-tools"></i> Skills</div>
                    <div class="field-value"><%= cvData.get("skills") %></div>
                </div>
                
                <div class="cv-field">
                    <div class="field-label"><i class="fas fa-graduation-cap"></i> Education</div>
                    <div class="field-value"><%= cvData.get("education") %></div>
                </div>
                
                <div class="cv-field">
                    <div class="field-label"><i class="fas fa-briefcase"></i> Experience</div>
                    <div class="field-value"><%= cvData.get("experience") %></div>
                </div>
            </div>
            
            <!-- Edit CV Form -->
            <h3 class="section-title"><i class="fas fa-edit"></i> Update Your CV</h3>
            
            <form action="cv" method="post">
                <input type="hidden" name="action" value="edit">
                
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-tools"></i> Skills</label>
                    <input type="text" name="skills" value="<%= cvData.get("skills") %>" class="form-control">
                </div>
                
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-graduation-cap"></i> Education</label>
                    <input type="text" name="education" value="<%= cvData.get("education") %>" class="form-control">
                </div>
                
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-briefcase"></i> Experience</label>
                    <input type="text" name="experience" value="<%= cvData.get("experience") %>" class="form-control">
                </div>
                
                <div class="btn-container">
                    <button type="submit" class="btn btn-warning">
                        <i class="fas fa-sync-alt"></i> Update CV
                    </button>
                </div>
            </form>
            
            <!-- Resume Upload Section -->
            <div class="resume-section">
                <h3 class="section-title"><i class="fas fa-file-upload"></i> Upload Your Resume</h3>
                
                <p style="color:#6b7280;margin-bottom:1rem;">Upload a PDF or DOC file to complement your CV.</p>
                
                <form action="JobSeekerProfileServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="uploadResume">
                    
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-file-pdf"></i> Resume File</label>
                        <div class="file-upload-wrapper">
                            <input type="file" name="resume" required accept=".pdf,.doc,.docx">
                            <div class="file-upload-btn">
                                <i class="fas fa-cloud-upload-alt"></i>
                                Choose Resume File
                            </div>
                        </div>
                        <small style="color:#6b7280;font-size:0.85rem;margin-top:0.25rem;display:block;">Accepted formats: PDF, DOC, DOCX (Max 5MB)</small>
                    </div>
                    
                    <div class="btn-container">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-upload"></i> Upload Resume
                        </button>
                    </div>
                </form>
                
                <% 
                    Map<String, String> profile = (Map<String, String>) request.getAttribute("profile");
                    if (profile == null) {
                        profile = new HashMap<>();
                    }
                    String resumePath = profile.get("resume");
                %>
                
                <% if (resumePath != null && !resumePath.trim().isEmpty()) { 
                    String fileName = resumePath.substring(resumePath.lastIndexOf(File.separator) + 1);
                %>
                    <div class="resume-info">
                        <div>
                            <strong><i class="fas fa-file-alt"></i> Current Resume:</strong> 
                            <span style="color:#2b2d42;margin-left:0.5rem;"><%= fileName %></span>
                        </div>
                        <div class="resume-actions">
                            <a href="<%= resumePath %>" target="_blank" class="btn btn-outline">
                                <i class="fas fa-eye"></i> View
                            </a>
                            <a href="<%= resumePath %>" download="<%= fileName %>" class="btn">
                                <i class="fas fa-download"></i> Download
                            </a>
                        </div>
                    </div>
                <% } else { %>
                    <div class="resume-info">
                        <div>
                            <strong><i class="fas fa-exclamation-circle"></i> No resume uploaded yet.</strong>
                            <span style="color:#6b7280;margin-left:0.5rem;">Upload a resume to increase your job opportunities.</span>
                        </div>
                    </div>
                <% } %>
            </div>
            
            <!-- Action Buttons -->
            <div class="btn-container">
                <form action="cv" method="get" style="flex:1;">
                    <input type="hidden" name="action" value="download">
                    <button type="submit" class="btn">
                        <i class="fas fa-file-download"></i> Download CV (PDF)
                    </button>
                </form>
                
                <form action="cv" method="post" onsubmit="return confirmDeleteCV();" style="flex:1;">
                    <input type="hidden" name="action" value="delete">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash-alt"></i> Delete CV
                    </button>
                </form>
            </div>
        <% } %>
        
        <a href="jobseekerDashboard.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</div>

<script>
    function confirmDeleteCV() {
        return confirm("Are you sure you want to delete your CV? This action cannot be undone and all your CV data will be lost.");
    }
    
    // File input display
    document.addEventListener('DOMContentLoaded', function() {
        const fileInputs = document.querySelectorAll('input[type="file"]');
        fileInputs.forEach(input => {
            input.addEventListener('change', function() {
                const fileName = this.files[0]?.name || 'No file chosen';
                const button = this.nextElementSibling;
                if (button) {
                    button.innerHTML = `<i class="fas fa-file"></i> ${fileName}`;
                }
            });
        });
    });
</script>