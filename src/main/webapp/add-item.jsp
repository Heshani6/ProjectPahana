<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.pahanaedu3.Models.Category" %>
<%
  List<Category> categories = (List<Category>) request.getAttribute("categories");
  String msg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Add Item</title>
  <style>
    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      background: #f7f7f7;
      margin: 0;
    }

    .container {
      max-width: 480px;
      margin: 48px auto;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 8px #0001;
      padding: 32px 32px 24px 32px;
    }

    /* ========== Heading ========== */
    h2 {
      color: #2c3e50;
      margin-bottom: 24px;
      text-align: center;
    }

    /* ========== Form Layout ========== */
    form {
      display: flex;
      flex-direction: column;
      gap: 18px;
    }

    label {
      font-weight: 500;
      color: #2c3e50;
      margin-bottom: 6px;
    }

    input[type="text"],
    input[type="number"],
    select {
      padding: 8px 12px;
      border: 1px solid #ccc;
      border-radius: 4px;
      font-size: 1em;
    }

    /* ========== Form Actions (Buttons) ========== */
    .form-actions {
      display: flex;
      gap: 12px;
      justify-content: flex-end;
      margin-top: 10px;
    }

    .btn {
      border: none;
      padding: 8px 22px;
      border-radius: 4px;
      cursor: pointer;
      font-weight: 500;
      transition: background 0.2s;
      font-size: 1em;
    }

    .btn-add {
      background: #27ae60;
      color: #fff;
    }

    .btn-cancel {
      background: #c0392b;
      color: #fff;
    }

    .btn:hover {
      opacity: 0.9;
    }

    /* ========== Toast Notification Styles ========== */
    .toast {
      visibility: hidden;
      min-width: 240px;
      background: #333;
      color: #fff;
      text-align: center;
      border-radius: 6px;
      padding: 14px 24px;
      position: fixed;
      z-index: 100;
      right: 32px;
      bottom: 32px;
      font-size: 1em;
      opacity: 0;
      transition: opacity 0.5s, visibility 0.5s;
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

    .toast.show {
      visibility: visible;
      opacity: 1;
    }

    .toast.success {
      background: #27ae60;
    }

    .toast.error {
      background: #c0392b;
    }

  </style>
</head>
<body>
<%
  String backUrl = "item";
  String role = (String) session.getAttribute("role");
  if ("admin".equalsIgnoreCase(role)) {
    backUrl = "item";
  }
%>
<a href="<%= backUrl %>" class="back-arrow" title="Back to Customer Management">
  &#8592;
</a>
<div class="container">
  <h2>Add New Item</h2>
  <form action="add-item" method="post" onsubmit="return validateForm()">
    <input type="hidden" name="action" value="add" />
    <div>
      <label for="name">Name:</label>
      <input type="text" id="name" name="name" required maxlength="50" />
    </div>
    <div>
      <label for="categoryId">Category:</label>
      <select id="categoryId" name="categoryId" required>
        <option value="">-- Select Category --</option>
        <% if (categories != null) { for (Category cat : categories) { %>
        <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
        <% } } %>
      </select>
    </div>
    <div>
      <label for="price">Price:</label>
      <input type="number" id="price" name="price" required min="0" step="0.01" />
    </div>
    <div>
      <label for="quantity">Quantity:</label>
      <input type="number" id="quantity" name="quantity" required min="0" step="1" />
    </div>
    <div class="form-actions">
      <button type="submit" class="btn btn-add">Add Item</button>
      <a href="item" class="btn btn-cancel" style="text-decoration:none;">Cancel</a>
    </div>
  </form>
</div>
<!-- Toast Notification -->
<div id="toast" class="toast"></div>
<script>
  function showToast(message, type) {
    var toast = document.getElementById('toast');
    toast.className = 'toast ' + (type || '');
    toast.textContent = message;
    toast.classList.add('show');
    setTimeout(function() {
      toast.classList.remove('show');
    }, 3500);
  }
  // Show toast if message is present from server
  <% if (msg != null) { %>
  showToast('<%= msg.replace("'", "\\'") %>', <%= msg.toLowerCase().contains("success") ? "'success'" : "'error'" %>);
  <% } %>
  function validateForm() {
    var name = document.getElementById('name').value.trim();
    var categoryId = document.getElementById('categoryId').value;
    var price = document.getElementById('price').value.trim();
    var quantity = document.getElementById('quantity').value.trim();
    if (!name || !categoryId || !price || !quantity) {
      showToast('All fields are required.', 'error');
      return false;
    }
    if (parseFloat(price) < 0) {
      showToast('Price must be non-negative.', 'error');
      return false;
    }
    if (parseInt(quantity) < 0) {
      showToast('Quantity must be non-negative.', 'error');
      return false;
    }
    return true;
  }
</script>
</body>
</html>
