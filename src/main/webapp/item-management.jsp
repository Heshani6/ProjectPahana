<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.pahanaedu3.Models.Item" %>
<%@ page import="com.example.pahanaedu3.Models.Category" %>
<%
  List<Item> items = (List<Item>) request.getAttribute("items");
  List<Category> categories = (List<Category>) request.getAttribute("categories");
  String msg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Item Management</title>
  <style>

    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      background: #f7f7f7;
      margin: 0;
    }

    /* ========== Main Container ========== */
    .container {
      max-width: 1200px;
      margin: 40px auto;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 8px #0001;
      padding: 32px 32px 24px 32px;
    }

    /* ========== Heading ========== */
    h2 {
      color: #2c3e50;
      margin-bottom: 24px;
    }

    /* ========== Top Bar ========== */
    .top-bar {
      display: flex;
      justify-content: flex-end;
      margin-bottom: 18px;
    }

    /* ========== Button Styles ========== */
    .btn {
      border: none;
      padding: 6px 16px;
      border-radius: 4px;
      cursor: pointer;
      font-weight: 500;
      transition: background 0.2s;
    }

    .btn-add {
      background: #27ae60;
      color: #fff;
      margin-left: 8px;
    }

    .btn-edit {
      background: #2f69e4;
      color: #fff;
    }

    .btn-delete {
      background: #c0392b;
      color: #fff;
    }

    .btn-view {
      background: rgb(57, 60, 64);
      color: #fff;
    }

    .btn-search {
      background: rgb(141, 141, 214);
      color: #fff;
    }

    .btn:hover {
      opacity: 0.9;
    }

    /* ========== Table Styles ========== */
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 24px;
    }

    th, td {
      padding: 12px 10px;
      text-align: left;
    }

    th {
      background: #2c3e50;
      color: #fff;
    }

    tr:nth-child(even) {
      background: #f2f2f2;
    }

    /* ========== Action Buttons Container ========== */
    .actions {
      display: flex;
      gap: 8px;
    }

    /* ========== Modal Styles ========== */
    .modal {
      display: none;
      position: fixed;
      z-index: 10;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background: rgba(0, 0, 0, 0.25);
    }

    .modal-content {
      background: #fff;
      margin: 8% auto;
      padding: 24px 32px;
      border-radius: 8px;
      width: 420px;
      box-shadow: 0 2px 8px #0002;
      position: relative;
    }

    .close {
      color: #aaa;
      position: absolute;
      right: 18px;
      top: 12px;
      font-size: 28px;
      font-weight: bold;
      cursor: pointer;
    }

    .close:hover {
      color: #c0392b;
    }

    /* ========== Toast Notifications ========== */
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
<a href="admin-dashboard.jsp" class="back-arrow" title="Back to Admin Dashboard">
  &#8592;
</a>
<div class="container">
  <h2>Item Management</h2>
  <div class="top-bar">
    <a href="add-item" class="btn btn-add">Add Item</a>
  </div>
  <div class="search-bar" style="margin-bottom: 18px; display: flex; gap: 10px;">
    <form action="item" method="get" style="display: flex; gap: 10px; width: 100%;">
      <input type="text" name="search" placeholder="Search by item name..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" style="flex:1; padding: 7px 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 1em;">
      <button type="submit" class="btn btn-search">Search</button>
      <a href="item" class="btn btn-delete" style="text-decoration:none;">Clear</a>
    </form>
  </div>
  <table>
    <thead>
    <tr>
      <th style="width:60px;">ID</th>
      <th>Name</th>
      <th>Category</th>
      <th>Price</th>
      <th>Quantity</th>
      <th style="width:240px;">Actions</th>
    </tr>
    </thead>
    <tbody>
    <% if (items != null && !items.isEmpty()) { %>
    <% for (Item item : items) { %>
    <tr>
      <td><%= item.getId() %></td>
      <td><%= item.getName() %></td>
      <td><%= item.getCategoryName() %></td>
      <td><%= item.getPrice() %></td>
      <td><%= item.getQuantity() %></td>
      <td class="actions">
        <button class="btn btn-view" data-id="<%= item.getId() %>" data-name="<%= item.getName().replace("\"", "&quot;") %>" data-category="<%= item.getCategoryName().replace("\"", "&quot;") %>" data-price="<%= item.getPrice() %>" data-quantity="<%= item.getQuantity() %>" onclick="openViewModal(this)">View</button>
        <button class="btn btn-edit" data-id="<%= item.getId() %>" data-name="<%= item.getName().replace("\"", "&quot;") %>" data-category="<%= item.getCategoryName().replace("\"", "&quot;") %>" data-price="<%= item.getPrice() %>" data-quantity="<%= item.getQuantity() %>" onclick="openEditModal(this)">Edit</button>
        <form action="item" method="post" style="display:inline;" onsubmit="return confirm('Delete this item?');">
          <input type="hidden" name="action" value="delete" />
          <input type="hidden" name="id" value="<%= item.getId() %>" />
          <button type="submit" class="btn btn-delete">Delete</button>
        </form>
      </td>
    </tr>
    <% } %>
    <% } else { %>
    <tr><td colspan="6" style="text-align:center; color:#888;">No items found.</td></tr>
    <% } %>
    </tbody>
  </table>
</div>

<!-- Edit Item Modal -->
<div id="editModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeEditModal()">&times;</span>
    <h3>Edit Item</h3>
    <form id="editForm" action="item" method="post" onsubmit="return validateEditForm()">
      <input type="hidden" name="action" value="update" />
      <input type="hidden" name="id" id="editItemId" />
      <div style="margin-bottom:12px;">
        <label for="editName">Name:</label><br/>
        <input type="text" name="name" id="editName" required maxlength="50" style="width:100%; padding:7px 10px; margin-top:6px;" />
      </div>
      <div style="margin-bottom:12px;">
        <label for="editCategory">Category:</label><br/>
        <input type="text" name="category" id="editCategory" required maxlength="50" style="width:100%; padding:7px 10px; margin-top:6px;" />
      </div>
      <div style="margin-bottom:12px;">
        <label for="editPrice">Price:</label><br/>
        <input type="number" name="price" id="editPrice" required min="0" step="0.01" style="width:100%; padding:7px 10px; margin-top:6px;" />
      </div>
      <div style="margin-bottom:18px;">
        <label for="editQuantity">Quantity:</label><br/>
        <input type="number" name="quantity" id="editQuantity" required min="0" step="1" style="width:100%; padding:7px 10px; margin-top:6px;" />
      </div>
      <button type="submit" class="btn btn-edit" style="width:100%;">Update</button>
    </form>
  </div>
</div>

<!-- View Item Modal -->
<div id="viewModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeViewModal()">&times;</span>
    <h3>Item Details</h3>
    <div style="margin-bottom:12px;"><b>ID:</b> <span id="viewItemId"></span></div>
    <div style="margin-bottom:12px;"><b>Name:</b> <span id="viewItemName"></span></div>
    <div style="margin-bottom:12px;"><b>Category:</b> <span id="viewItemCategory"></span></div>
    <div style="margin-bottom:12px;"><b>Price:</b> <span id="viewItemPrice"></span></div>
    <div style="margin-bottom:12px;"><b>Quantity:</b> <span id="viewItemQuantity"></span></div>
    <button class="btn btn-view" style="width:100%; margin-top:10px;" onclick="closeViewModal()">Close</button>
  </div>
</div>

<!-- Toast Notification -->
<div id="toast" class="toast"></div>

<script>
  // Edit Modal logic
  function openEditModal(btn) {
    document.getElementById('editItemId').value = btn.getAttribute('data-id');
    document.getElementById('editName').value = btn.getAttribute('data-name');
    document.getElementById('editCategory').value = btn.getAttribute('data-category');
    document.getElementById('editPrice').value = btn.getAttribute('data-price');
    document.getElementById('editQuantity').value = btn.getAttribute('data-quantity');
    document.getElementById('editModal').style.display = 'block';
  }
  function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
  }
  // View Modal logic
  function openViewModal(btn) {
    document.getElementById('viewItemId').textContent = btn.getAttribute('data-id');
    document.getElementById('viewItemName').textContent = btn.getAttribute('data-name');
    document.getElementById('viewItemCategory').textContent = btn.getAttribute('data-category');
    document.getElementById('viewItemPrice').textContent = btn.getAttribute('data-price');
    document.getElementById('viewItemQuantity').textContent = btn.getAttribute('data-quantity');
    document.getElementById('viewModal').style.display = 'block';
  }
  function closeViewModal() {
    document.getElementById('viewModal').style.display = 'none';
  }
  window.onclick = function(event) {
    var editModal = document.getElementById('editModal');
    var viewModal = document.getElementById('viewModal');
    if (event.target === editModal) closeEditModal();
    if (event.target === viewModal) closeViewModal();
  }
  // Toast logic
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
  // Edit form validation
  function validateEditForm() {
    var name = document.getElementById('editName').value.trim();
    var category = document.getElementById('editCategory').value.trim();
    var price = document.getElementById('editPrice').value.trim();
    var quantity = document.getElementById('editQuantity').value.trim();
    if (!name || !category || !price || !quantity) {
      showToast('All fields are required.', 'error');
      return false;
    }
    return true;
  }
</script>
</body>
</html>