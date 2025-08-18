<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>View User - Pahana EduBill</title>
  <style>
    body {
      background: linear-gradient(120deg, #b8c6db 0%, #f5f7fa 100%);
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      margin: 0;
    }
    .view-card {
      background: #fff;
      border-radius: 18px;
      box-shadow: 0 4px 24px rgba(108,99,255,0.08);
      padding: 2.5rem 2rem;
      width: 100%;
      max-width: 400px;
      display: flex;
      flex-direction: column;
      align-items: stretch;
    }
    .view-title {
      font-size: 1.5rem;
      color: #2563eb;
      font-weight: 700;
      margin-bottom: 1.5rem;
      text-align: center;
    }
    .view-row {
      margin-bottom: 1.1rem;
      display: flex;
      justify-content: space-between;
      font-size: 1.08rem;
    }
    .view-label {
      color: #6c63ff;
      font-weight: 600;
    }
    .view-value {
      color: #333;
    }
    .btn-back {
      background: #2563eb;
      color: #fff;
      border: none;
      padding: 0.7rem 0;
      border-radius: 8px;
      font-size: 1.1rem;
      font-weight: 600;
      cursor: pointer;
      margin-top: 1.5rem;
      transition: background 0.2s;
      width: 100%;
    }
    .btn-back:hover {
      background: #174ea6;
    }
  </style>
</head>
<body>
  <div class="view-card">
    <div class="view-title">User Details</div>
    <% com.example.pahanaedu3.Models.User user = (com.example.pahanaedu3.Models.User) request.getAttribute("user"); %>
    <% if (user != null) { %>
      <div class="view-row"><span class="view-label">ID:</span> <span class="view-value"><%= user.getId() %></span></div>
      <div class="view-row"><span class="view-label">Username:</span> <span class="view-value"><%= user.getUsername() %></span></div>
      <div class="view-row"><span class="view-label">Role:</span> <span class="view-value"><%= user.getRole() %></span></div>
      <div class="view-row"><span class="view-label">Password:</span> <span class="view-value"><%= user.getPassword() %></span></div>
    <% } else { %>
      <div class="view-row">User not found.</div>
    <% } %>
    <form action="user-management.jsp" method="get">
      <input type="hidden" name="from" value="admin" />
      <button type="submit" class="btn-back">Back to User Management</button>
    </form>
  </div>
</body>
</html> 