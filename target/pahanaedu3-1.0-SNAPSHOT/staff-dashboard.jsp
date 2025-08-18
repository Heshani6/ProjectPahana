<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Staff Dashboard - Pahana EduBill</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(to right, #7f7fd5, #86a8e7, #91eae4);
      min-height: 100vh;
      margin: 0;
      display: flex;
    }
    .sidebar {
      background: #fff;
      width: 240px;
      min-height: 100vh;
      box-shadow: 2px 0 10px rgba(0,0,0,0.07);
      padding: 2rem 1rem;
    }
    .sidebar h2 {
      font-size: 1.3rem;
      color: #333;
      margin-bottom: 2rem;
      text-align: center;
    }
    .sidebar ul {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    .sidebar ul li {
      margin-bottom: 1.2rem;
    }
    .sidebar ul li a {
      color: #333;
      text-decoration: none;
      font-size: 1rem;
      font-weight: 500;
      transition: color 0.2s;
    }
    .sidebar ul li a:hover {
      color: #667eea;
    }
    .main-content {
      flex: 1;
      padding: 2.5rem 3rem;
    }
    .welcome {
      font-size: 1.5rem;
      font-weight: 600;
      color: #333;
      margin-bottom: 1.5rem;
    }
    .desc {
      color: #666;
      font-size: 1.1rem;
      margin-bottom: 2rem;
    }
  </style>
</head>
<body>
  <div class="sidebar">
    <h2>Staff Menu</h2>
    <ul>
      <li><a href="#">Customer Management</a></li>
      <li><a href="#">Billing</a></li>
      <li><a href="#">Help</a></li>
      <li><a href="logout">Logout</a></li>
    </ul>
  </div>
  <div class="main-content">
    <div class="welcome">Welcome, Staff!</div>
    <div class="desc">
      Use the menu to manage customers, calculate bills, and assist customers.<br>
      Your access is limited to customer service functions.
    </div>
    <!-- Add dashboard widgets or quick stats here if needed -->
  </div>
</body>
</html> 