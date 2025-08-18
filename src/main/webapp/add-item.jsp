<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.pahanaedu3.Models.Category" %>
<%
  List<Category> categories = (List<Category>) request.getAttribute("categories");
  String msg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Add Item - Pahana EduBill</title>
  <style>
    body {
      background: #f7f7f7;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }
    .form-card {
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
    .form-title {
      font-size: 1.5rem;
      font-weight: 700;
      margin-bottom: 1.5rem;
      text-align: center;
      color: #2c3e50;
    }
    .form-group {
      margin-bottom: 1.2rem;
      position: relative;
    }
    label {
      font-size: 1rem;
      color: #333;
      margin-bottom: 0.3rem;
      display: block;
    }
    input[type="text"], input[type="number"], select {
      width: 100%;
      padding: 0.8rem;
      border: 1px solid #ccc;
      border-radius: 8px;
      font-size: 1rem;
      margin-top: 0.2rem;
      transition: border 0.2s;
    }
    input[type="text"]:focus, input[type="number"]:focus, select:focus {
      border: 1.5px solid #6c63ff;
      outline: none;
    }
    .btn-submit {
      background: #8e8ad8;
      color: #fff;
      border: none;
      padding: 0.9rem 0;
      border-radius: 8px;
      font-size: 1.1rem;
      font-weight: 600;
      cursor: pointer;
      margin-top: 1rem;
      transition: background 0.2s;
    }
    .btn-submit:hover {
      background: #5548c8;
    }
    .feedback {
      color: #e53e3e;
      margin-bottom: 1rem;
      text-align: center;
    }
    .success {
      color: #38a169;
    }
    .back-arrow {
      position: absolute;
      top: 30px;
      left: 30px;
      font-size: 2rem;
      color: #2563eb;
      text-decoration: none;
      font-weight: bold;
      background: #fff;
      border-radius: 50%;
      width: 40px;
      height: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 2px 8px rgba(38,99,235,0.08);
      transition: background 0.2s, color 0.2s;
      z-index: 10;
    }
    .back-arrow:hover {
      background: #babae3;
      color: #fff;
    }
  </style>
</head>
<body>
<%
  String backUrl = "item";
  String role = (String) session.getAttribute("role");
%>
<a href="<%= backUrl %>" class="back-arrow" title="Back to Item Management">&#8592;</a>

<form class="form-card" action="item" method="post" autocomplete="off">
  <input type="hidden" name="action" value="add">
  <div class="form-title">Add Item</div>

  <div class="feedback">
    <% if (msg != null) { %>
    <span class="<%= msg.toLowerCase().contains("success") ? "success" : "error" %>"><%= msg %></span>
    <% } %>
  </div>

  <div class="form-group">
    <label for="name">Name</label>
    <input type="text" id="name" name="name" required maxlength="50">
  </div>

  <div class="form-group">
    <label for="category">Category</label>
    <select id="category" name="category" required>
      <option value="">-- Select Category --</option>
      <% if (categories != null) {
        for (Category cat : categories) { %>
      <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
      <%   }
      } %>
    </select>
  </div>

  <div class="form-group">
    <label for="price">Price</label>
    <input type="number" id="price" name="price" required min="0" step="0.01">
  </div>

  <div class="form-group">
    <label for="quantity">Quantity</label>
    <input type="number" id="quantity" name="quantity" required min="0" step="1">
  </div>

  <button type="submit" class="btn-submit">Add Item</button>
</form>
</body>
</html>
