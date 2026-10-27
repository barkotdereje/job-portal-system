<%@ page session="true" %>
<html>
<head>
    <title>Login - Job Portal</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        

        /* Navigation Bar - Same as Home Page */
        nav {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.08);
            z-index: 100;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo h1 {
            color: #4361ee;
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .logo-icon {
            width: 35px;
            height: 35px;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1rem;
        }

        .nav-links {
            display: flex;
            gap: 1.5rem;
            list-style: none;
        }

        .nav-links a {
            color: #555;
            text-decoration: none;
            font-weight: 500;
            padding: 0.4rem 0.8rem;
            border-radius: 6px;
            transition: all 0.3s ease;
            position: relative;
            font-size: 0.9rem;
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

        /* Login Box - Matching Registration Size */
        .login-box {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 380px;
            text-align: center;
            position: relative;
            overflow: hidden;
            margin-top: 70px;
        }

        .login-box::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #4361ee, #3a0ca3);
        }

        .login-box h2 {
            font-size: 1.5rem;
            color: #2b2d42;
            margin-bottom: 1.2rem;
            font-weight: 700;
        }

        /* Form Groups - Same Compact Style */
        .form-group {
            margin-bottom: 1rem;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.4rem;
            color: #4b5563;
            font-weight: 500;
            font-size: 0.85rem;
        }

        .input-with-icon {
            position: relative;
        }

        .input-with-icon i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
            font-size: 0.9rem;
        }

        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 0.8rem 0.8rem 0.8rem 2.5rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 0.9rem;
            background: #f9fafb;
            color: #2b2d42;
            transition: all 0.3s ease;
        }

        input[type="email"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #4361ee;
            background: white;
            box-shadow: 0 0 0 2px rgba(67, 97, 238, 0.1);
        }

        input::placeholder {
            color: #9ca3af;
            font-size: 0.85rem;
        }

        /* Password Toggle - Same Style */
        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #9ca3af;
            cursor: pointer;
            font-size: 0.9rem;
            transition: color 0.3s ease;
        }

        .password-toggle:hover {
            color: #4361ee;
        }

        /* Login Button - Same as Register Button */
        .login-button {
            width: 100%;
            background: linear-gradient(45deg, #4361ee, #3a0ca3);
            color: white;
            border: none;
            padding: 0.9rem;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
            margin-top: 0.8rem;
        }

        .login-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(67, 97, 238, 0.4);
        }

        /* Error Message */
        .error {
            color: #dc2626;
            background: #fef2f2;
            padding: 0.8rem;
            border-radius: 6px;
            font-size: 0.85rem;
            margin-top: 1rem;
            border: 1px solid #fecaca;
        }

        /* Login Links - More Compact */
        .login-links {
            margin-top: 1.2rem;
            padding-top: 1.2rem;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: center;
            gap: 1rem;
        }

        .login-links a {
            color: #4361ee;
            text-decoration: none;
            font-size: 0.85rem;
            transition: color 0.3s ease;
        }

        .login-links a:hover {
            color: #3a0ca3;
            text-decoration: underline;
        }

        /* Register Prompt - More Compact */
        .register-prompt {
            margin-top: 1.2rem;
            padding-top: 1.2rem;
            border-top: 1px solid #e5e7eb;
            color: #6b7280;
            font-size: 0.85rem;
        }

        .register-prompt a {
            color: #4361ee;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.85rem;
        }

        .register-prompt a:hover {
            text-decoration: underline;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            nav {
                padding: 0.8rem;
                flex-direction: column;
                gap: 0.8rem;
            }
            
            .logo h1 {
                font-size: 1.3rem;
            }
            
            .logo-icon {
                width: 30px;
                height: 30px;
                font-size: 0.9rem;
            }
            
            .nav-links {
                gap: 1rem;
            }
            
            .nav-links a {
                padding: 0.3rem 0.6rem;
                font-size: 0.85rem;
            }
            
            .login-box {
                padding: 1.5rem;
                max-width: 340px;
                margin-top: 90px;
            }
            
            .login-box h2 {
                font-size: 1.3rem;
            }
            
            .login-links {
                flex-direction: column;
                gap: 0.5rem;
                text-align: center;
            }
        }

        @media (max-width: 480px) {
            .login-box {
                padding: 1.2rem;
                max-width: 320px;
            }
            
            .nav-links {
                flex-wrap: wrap;
                justify-content: center;
                gap: 0.5rem;
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

        .login-box {
            animation: fadeIn 0.8s ease-out;
        }
    </style>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Navigation - Same as Home Page -->
    <nav>
        <div class="logo">
            <div class="logo-icon">
                <i class="fas fa-briefcase"></i>
            </div>
            <h1>JobPortal</h1>
        </div>
        <ul class="nav-links">
            <li><a href="index.jsp"><i class="fas fa-home"></i> Home</a></li>
            <li><a href="login.jsp" style="color: #4361ee; background: rgba(67, 97, 238, 0.1);"><i class="fas fa-sign-in-alt"></i> Login</a></li>
            <li><a href="register.jsp"><i class="fas fa-user-plus"></i> Register</a></li>
        </ul>
    </nav>

    <div class="login-box">
        <h2>Login</h2>
        <form action="LoginServlet" method="post" id="loginForm">
            <div class="form-group">
                <label for="email">Email</label>
                <div class="input-with-icon">
                    <i class="fas fa-envelope"></i>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <div class="input-with-icon">
                    <i class="fas fa-lock"></i>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                    <button type="button" class="password-toggle" id="togglePassword">
                        <i class="far fa-eye"></i>
                    </button>
                </div>
            </div>
            
            <button type="submit" class="login-button">
                <i class="fas fa-sign-in-alt"></i> Login
            </button>
        </form>
        
       <%
    String error = request.getParameter("error");

    if ("invalid".equals(error)) {
%>
        <p class="error">Invalid email or password</p>
<%
    } else if ("notapproved".equals(error)) {
%>
        <p class="error">Your employer account is not approved yet. Please wait.</p>
<%
    }
%>

        
        <div class="login-links">
            <a href="#"><i class="fas fa-key"></i> Forgot Password?</a>
            <a href="#"><i class="fas fa-question-circle"></i> Need Help?</a>
        </div>
        
        <div class="register-prompt">
            Don't have an account? <a href="register.jsp">Sign up here</a>
        </div>
    </div>

    <script>
        // Password toggle functionality
        const togglePassword = document.getElementById('togglePassword');
        const password = document.getElementById('password');
        
        togglePassword.addEventListener('click', function() {
            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
            password.setAttribute('type', type);
            this.innerHTML = type === 'password' ? '<i class="far fa-eye"></i>' : '<i class="far fa-eye-slash"></i>';
        });

        // Form submission
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            // Show loading state
            const submitBtn = this.querySelector('.login-button');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Logging in...';
            submitBtn.disabled = true;
            
            // Re-enable after 3 seconds if submission fails
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            }, 3000);
        });

        // Add focus effects
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'scale(1.02)';
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>