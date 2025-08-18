<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard - Pahana EduBill</title>
  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(120deg, #a8a8cd 0%, #f5f7fa 100%);
      min-height: 100vh;
      display: flex;
    }
    .sidebar {
      width: 250px;
      background: #2d3142;
      color: #e0e6ed;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 2rem 0;
      min-height: 100vh;
      box-shadow: 2px 0 10px rgba(0,0,0,0.07);
    }
    .sidebar h2 {
      font-size: 1.3rem;
      margin-bottom: 2rem;
      letter-spacing: 1px;
      color: #e0e6ed;
    }
    .sidebar ul {
      list-style: none;
      padding: 0;
      width: 100%;
    }
    .sidebar ul li {
      width: 100%;
      margin-bottom: 1.1rem;
    }
    .sidebar ul li a {
      display: flex;
      align-items: center;
      color: #e0e6ed;
      text-decoration: none;
      font-size: 0.98rem;
      padding: 0.7rem 1.5rem;
      border-radius: 0 24px 24px 0;
      transition: background 0.2s, color 0.2s;
      font-weight: 500;
    }
    .sidebar ul li a.active, .sidebar ul li a:hover {
      background: #a3cef1;
      color: #2d3142;
    }
    .sidebar ul li a i {
      margin-right: 0.8rem;
      font-size: 1.1rem;
    }
    .main-content {
      flex: 1;
      padding: 2.5rem 3rem;
      background: transparent;
    }
    .dashboard-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 2rem;
    }
    .dashboard-header h1 {
      font-size: 1.5rem;
      font-weight: 600;
      color: #333;
      margin-bottom: 1.5rem;
    }
    .dashboard-cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      gap: 2rem;
      margin-bottom: 2rem;
    }
    .card {
      background: #fff;
      border-radius: 18px;
      box-shadow: 0 4px 24px rgba(108,99,255,0.08);
      padding: 2rem 1.5rem;
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      transition: box-shadow 0.2s;
    }
    .card:hover {
      box-shadow: 0 8px 32px rgba(108,99,255,0.15);
    }
    .card-title {
      font-size: 1.1rem;
      color: #6c63ff;
      margin-bottom: 0.5rem;
      font-weight: 600;
    }
    .card-value {
      font-size: 2.2rem;
      color: #333;
      font-weight: 700;
    }
    .quick-actions {
      margin-top: 2rem;
    }
    .quick-actions button {
      background: #6c63ff;
      color: #fff;
      border: none;
      padding: 0.8rem 1.8rem;
      border-radius: 8px;
      font-size: 1rem;
      margin-right: 1rem;
      cursor: pointer;
      transition: background 0.2s;
    }
    .quick-actions button:hover {
      background: #5548c8;
    }
  </style>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="sidebar">
  <h2>Pahana EduBill</h2>
  <ul>
    <li><a href="admin-dashboard" class="active"><i class="fas fa-home"></i>Dashboard</a></li>
    <li><a href="register?from=admin"><i class="fas fa-users-cog"></i>User Management</a></li>
    <li><a href="customer"><i class="fas fa-user-friends"></i>Customer Management</a></li>
    <li><a href="item"><i class="fas fa-box"></i>Item Management</a></li>
    <li><a href="category"><i class="fas fa-tags"></i>Category Management</a></li>
    <li><a href="bill"><i class="fas fa-file-invoice-dollar"></i>Billing Management</a></li>
    <li><a href="logout"><i class="fas fa-sign-out-alt"></i>Logout</a></li>
    <li><a href="help.jsp"><i class="fas fa-question-circle"></i>Help</a></li>
    <li><a href="profile"><i class="fas fa-user"></i>My Profile</a></li>
  </ul>
</div>
<div class="main-content">
  <div class="dashboard-header">
    <h1>Welcome, Admin!</h1>
    <div class="quick-actions">
      <a href="add-staff.jsp" class="btn-submit" style="text-decoration:none;display:inline-block;margin-right:1rem;">Add Staff</a>
      <a href="add-customer.jsp" class="btn-submit" style="text-decoration:none;display:inline-block;">Add Customer</a>
    </div>
  </div>
  <div class="dashboard-cards">
    <div class="card">
      <div class="card-title">Total Staff</div>
      <div class="card-value"><%= request.getAttribute("staffCount") != null ? request.getAttribute("staffCount") : "0" %></div>
    </div>
    <div class="card">
      <div class="card-title">Total Customers</div>
      <div class="card-value"><%= request.getAttribute("customerCount") != null ? request.getAttribute("customerCount") : "0" %></div>
    </div>
    <div class="card">
      <div class="card-title">Total Items</div>
      <div class="card-value"><%= request.getAttribute("itemCount") != null ? request.getAttribute("itemCount") : "0" %></div>
    </div>
    <div class="card">
      <div class="card-title">Pending Bills</div>
      <div class="card-value"><%= request.getAttribute("pendingBillCount") != null ? request.getAttribute("pendingBillCount") : "0" %></div>
    </div>
  </div>
</div>
</body>
</html>