<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Billing Management System - Login</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba1 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .login-container {
      background: white;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
      width: 100%;
      max-width: 400px;
    }
    .login-header {
      text-align: center;
      margin-bottom: 2rem;
    }
    .login-header h1 {
      color: #333;
      font-size: 2rem;
      margin-bottom: 0.5rem;
    }
    .login-header p {
      color: #666;
      font-size: 0.9rem;
    }
    .form-group {
      margin-bottom: 1.5rem;
    }
    .form-group label {
      display: block;
      margin-bottom: 0.5rem;
      color: #333;
      font-weight: 500;
    }
    .form-group input {
      width: 100%;
      padding: 0.75rem;
      border: 2px solid #e1e5e9;
      border-radius: 5px;
      font-size: 1rem;
      transition: border-color 0.3s ease;
    }
    .form-group input:focus {
      outline: none;
      border-color: #667eea;
    }
    .login-btn {
      width: 100%;
      padding: 0.75rem;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 5px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: transform 0.2s ease;
    }
    .login-btn:hover {
      transform: translateY(-2px);
    }

    .register-link {
      margin-top: 15px;
      font-size: 14px;
      text-align: center;
    }

    .error-message {
      background: #fee;
      color: #c33;
      padding: 0.75rem;
      border-radius: 5px;
      margin-bottom: 1rem;
      border: 1px solid #fcc;
    }
    .demo-info {
      background: #e8f4fd;
      color: #0066cc;
      padding: 0.75rem;
      border-radius: 5px;
      margin-bottom: 1rem;
      border: 1px solid #b3d9ff;
      font-size: 0.9rem;
    }
    .footer {
      text-align: center;
      margin-top: 2rem;
      color: #666;
      font-size: 0.8rem;
    }
  </style>
</head>
<body>
<div class="login-container">
  <div class="login-header">
    <h1>Pahana EduBill System</h1>
    <p>Please sign in to continue</p>
  </div>
  <% if (request.getAttribute("error") != null) { %>
  <div class="error-message">
    <%= request.getAttribute("error") %>
  </div>
  <% } %>
  <form action="login" method="post">
    <div class="form-group">
      <label for="username">Username</label>
      <input type="text" id="username" name="username"
             value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
             required autocomplete="username">
    </div>
    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password"
             required autocomplete="current-password">
    </div>
    <button type="submit" class="login-btn">Sign In</button>

    <div class="register-link">
      Don't have an account? <a href="register.jsp">Register</a>
    </div>
  </form>
  <div class="footer">
    &copy; 2024 Billing Management System. All rights reserved.
  </div>
</div>
</body>
</html>
