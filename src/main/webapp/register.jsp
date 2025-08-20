<%--
  Created by IntelliJ IDEA.
  User: Heshani
  Date: 7/22/2025
  Time: 1:06 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Pahana EduBill - Register</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-image: url('image/buddish-shop.jpg');
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .container {
      text-align: center;
      background: rgba(255, 255, 255, 0.85);
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
      width: 100%;
      max-width: 400px;
    }

    .register-btn {
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
    .register-btn:hover {
      transform: translateY(-2px);
    }

    .register-header {
      text-align: center;
      margin-bottom: 2rem;
    }
    .register-header h1 {
      color: #333;
      font-size: 2rem;
      margin-bottom: 0.5rem;
    }
    .register-header p {
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
      padding: 0.75rem 0.01rem;
      border: 2px solid #e1e5e9;
      border-radius: 5px;
      font-size: 1rem;
      transition: border-color 0.3s ease;
    }
    .form-group input:focus {
      outline: none;
      border-color: #667eea;
    }

    .form-group-role {
      display: flex;
      align-items: center;
      margin-bottom: 0.25rem;
    }
    .form-group-role label[for="staff"] {
      margin-right: 5px;
      min-width: 70px;
    }
    .form-group-role input[type="checkbox"] {
      margin-left: 2px;
    }
    .form-group-role label[for="staff"]:last-of-type {
      margin: 1px;
    }

    button {
      background: linear-gradient(to right, #667eea, #764ba2);
      color: white;
      padding: 12px 0;
      width: 100%;
      border: none;
      border-radius: 5px;
      font-size: 16px;
      cursor: pointer;
      margin-top: 15px;
    }

    .login-link {
      margin-top: 15px;
      font-size: 14px;
      text-align: center;
    }

    .login-link a {
      color: #4a00e0;
      text-decoration: none;
      font-weight: bold;
    }

    .register-link {
      margin-top: 15px;
      font-size: 14px;
      text-align: center;
    }

    .footer {
      margin-top: 20px;
      font-size: 12px;
      color: gray;
    }
    .form-label {
      text-align: left;
      display: block;
    }
    .feedback {
      color: #e53e3e;
      margin-bottom: 1rem;
      text-align: center;
    }
    .success {
      color: #38a169;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="register-header">
    <h1>Register to EduBill</h1>
    <p>Create your account</p>
  </div>
  <div class="feedback">
    <% if (request.getAttribute("error") != null) { %>
      <span><%= request.getAttribute("error") %></span>
    <% } else if (request.getAttribute("success") != null) { %>
      <span class="success"><%= request.getAttribute("success") %></span>
    <% } %>
  </div>

  <form action="register" method="post" autocomplete="off">
    <div class="form-group">
      <label for="username" class="form-label">Username</label>
      <input type="text" id="username" name="username" required autocomplete="off" />
    </div>
    <div class="form-group">
      <label for="password" class="form-label">Password</label>
      <input type="password" id="password" name="password" required autocomplete="new-password" />
    </div>

    <div class="form-group-role">
      <label for="staff">Select Role:</label>
      <input type="checkbox" id="staff" name="role" value="staff" />
      <label for="staff">Staff</label>
    </div>
    <button type="submit" class="register-btn">Sign Up</button>
    <div class="register-link">
      Already have an account? <a href="index.jsp">Sign In</a>
    </div>
  </form>

  <div class="footer">
    © 2024 Billing Management System. All rights reserved.
  </div>
</div>
</body>
</html>

