<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>User Management - Pahana EduBill</title>
  <style>
    body {
      background: linear-gradient(120deg, #b8c6db 0%, #f5f7fa 100%);
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      display: flex;
      justify-content: center;
      align-items: flex-start;
      min-height: 100vh;
      margin: 0;
    }
    .container {
      background: #fff;
      border-radius: 18px;
      box-shadow: 0 4px 24px rgba(108,99,255,0.08);
      padding: 2.5rem 2rem;
      margin-top: 3rem;
      width: 100%;
      max-width: 900px;
    }
    .title {
      font-size: 2rem;
      color: #2563eb;
      font-weight: 700;
      margin-bottom: 2rem;
      text-align: center;
      letter-spacing: 1px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 1.5rem;
    }
    th, td {
      padding: 0.6rem 0.4rem;
      text-align: left;
    }
    th {
      background: #f5f7fa;
      color: #2563eb;
      font-weight: 600;
      border-bottom: 2px solid #e0e0e0;
    }
    tr {
      border-bottom: 1px solid #e0e0e0;
    }
    tr:last-child {
      border-bottom: none;
    }
    td {
      color: #333;
    }
    .actions {
      display: flex;
      gap: 0.3rem;
    }
    .btn {
      padding: 0.25rem 0.7rem;
      border: none;
      border-radius: 5px;
      font-size: 0.98rem;
      font-weight: 500;
      cursor: pointer;
      transition: background 0.2s;
      min-width: 60px;
      min-height: 32px;
      display: inline-block;
    }
    .btn-view {
      background: #495057;
      color: #fff;
    }
    .btn-view:hover {
      background: #343a40;
    }
    .btn-edit {
      background: #2563eb;
      color: #fff;
    }
    .btn-edit:hover {
      background: #174ea6;
    }
    .btn-delete {
      background: #e53e3e;
      color: #fff;
    }
    .btn-delete:hover {
      background: #b91c1c;
    }
    .no-users {
      text-align: center;
      color: #888;
      font-size: 1.1rem;
      margin-top: 2rem;
    }
    /* Modal styles */
    .modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100vw;
      height: 100vh;
      overflow: auto;
      background: rgba(0,0,0,0.25);
      justify-content: center;
      align-items: center;
    }
    .modal-content {
      background: #fff;
      margin: auto;
      padding: 2rem 2.5rem;
      border-radius: 12px;
      box-shadow: 0 4px 24px rgba(108,99,255,0.12);
      max-width: 400px;
      width: 100%;
      position: relative;
      display: flex;
      flex-direction: column;
      gap: 1rem;
    }
    .modal-header {
      font-size: 1.3rem;
      color: #2563eb;
      font-weight: 600;
      margin-bottom: 0.5rem;
      text-align: center;
    }
    .close {
      position: absolute;
      top: 12px;
      right: 18px;
      font-size: 1.5rem;
      color: #888;
      cursor: pointer;
      background: none;
      border: none;
    }
    .modal label {
      font-size: 1rem;
      color: #333;
      margin-bottom: 0.2rem;
      display: block;
    }
    .modal input[type="text"], .modal input[type="password"] {
      width: 100%;
      padding: 0.6rem;
      border: 1px solid #ccc;
      border-radius: 6px;
      font-size: 1rem;
      margin-bottom: 0.7rem;
    }
    .modal .btn {
      width: 100%;
      margin-top: 0.5rem;
    }
    .success-message {
      background: #e6ffed;
      color: #2563eb;
      border: 1px solid #b7eb8f;
      border-radius: 6px;
      padding: 0.7rem 1rem;
      margin-bottom: 1.2rem;
      text-align: center;
      font-size: 1.08rem;
      font-weight: 600;
      box-shadow: 0 2px 8px rgba(38,99,235,0.04);
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="title">User Management</div>
    <% String msg = request.getParameter("msg"); %>
    <% if (msg != null) { %>
      <div class="success-message"><%= msg %></div>
    <% } %>
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Username</th>
          <th>Role</th>
          <th>Password</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <%
          java.util.List<com.example.pahanaedu3.Models.User> users = (java.util.List<com.example.pahanaedu3.Models.User>) request.getAttribute("users");
          if (users != null && !users.isEmpty()) {
            for (com.example.pahanaedu3.Models.User user : users) {
        %>
        <tr>
          <td><%= user.getId() %></td>
          <td><%= user.getUsername() %></td>
          <td><%= user.getRole() %></td>
          <td><%= user.getPassword() %></td>
          <td>
            <div class="actions">
              <button type="button" class="btn btn-view"
                data-id="<%= user.getId() %>"
                data-username="<%= user.getUsername().replace("\"", "&quot;") %>"
                data-role="<%= user.getRole().replace("\"", "&quot;") %>"
                data-password="<%= user.getPassword().replace("\"", "&quot;") %>"
                onclick="openViewModal(this)">View</button>
              <form action="user" method="post" style="display:inline;" onsubmit="return submitEditForm(event, this)">
                <input type="hidden" name="id" value="<%= user.getId() %>" />
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="username" />
                <input type="hidden" name="role" />
                <input type="hidden" name="password" />
                <button type="button" class="btn btn-edit"
                  data-id="<%= user.getId() %>"
                  data-username="<%= user.getUsername().replace("\"", "&quot;") %>"
                  data-role="<%= user.getRole().replace("\"", "&quot;") %>"
                  onclick="openEditModal(this)">Edit</button>
              </form>
              <form action="user" method="post" style="display:inline;">
                <input type="hidden" name="id" value="<%= user.getId() %>" />
                <input type="hidden" name="action" value="delete" />
                <button type="submit" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this user?');">Delete</button>
              </form>
            </div>
          </td>
        </tr>
        <%   }
          } else { %>
        <tr>
          <td colspan="5" class="no-users">No users found.</td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>

  <!-- Edit User Modal -->
  <div id="editModal" class="modal">
    <div class="modal-content">
      <button class="close" onclick="closeEditModal()">&times;</button>
      <div class="modal-header">Edit User</div>
      <form id="editUserForm" action="user" method="post">
        <input type="hidden" id="editUserId" name="id" />
        <label for="editUsername">Username</label>
        <input type="text" id="editUsername" name="username" required />
        <label for="editRole">Role</label>
        <input type="text" id="editRole" name="role" required />
        <label for="editPassword">Password</label>
        <input type="text" id="editPassword" name="password" required />
        <button type="submit" class="btn btn-edit">Update</button>
      </form>
    </div>
  </div>

  <!-- View User Modal -->
  <div id="viewModal" class="modal">
    <div class="modal-content">
      <button class="close" onclick="closeViewModal()">&times;</button>
      <div class="view-row"><span class="view-label">ID:</span> <span class="view-value" id="viewId"></span></div>
      <div class="view-row"><span class="view-label">Username:</span> <span class="view-value" id="viewUsername"></span></div>
      <div class="view-row"><span class="view-label">Role:</span> <span class="view-value" id="viewRole"></span></div>
      <div class="view-row"><span class="view-label">Password:</span> <span class="view-value" id="viewPassword"></span></div>
    </div>
  </div>

  <script>
    function openEditModal(btn) {
      document.getElementById('editUserId').value = btn.getAttribute('data-id');
      document.getElementById('editUsername').value = btn.getAttribute('data-username');
      document.getElementById('editRole').value = btn.getAttribute('data-role');
      var row = btn.closest('tr');
      var password = row.querySelector('td:nth-child(4)').textContent;
      document.getElementById('editPassword').value = password;
      document.getElementById('editModal').style.display = 'flex';
      // Store the form to submit on update
      window.currentEditForm = btn.closest('form');
    }
    function closeEditModal() {
      document.getElementById('editModal').style.display = 'none';
      window.currentEditForm = null;
    }
    // Submit the edit form with modal values
    function submitEditForm(event, form) {
      if (window.currentEditForm === form) {
        form.querySelector('input[name="username"]').value = document.getElementById('editUsername').value;
        form.querySelector('input[name="role"]').value = document.getElementById('editRole').value;
        form.querySelector('input[name="password"]').value = document.getElementById('editPassword').value;
        closeEditModal();
        return true;
      }
      return false;
    }
    // Close modal when clicking outside content
    window.onclick = function(event) {
      var modal = document.getElementById('editModal');
      if (event.target == modal) {
        closeEditModal();
      }
    }

    function openViewModal(btn) {
      document.getElementById('viewId').textContent = btn.getAttribute('data-id');
      document.getElementById('viewUsername').textContent = btn.getAttribute('data-username');
      document.getElementById('viewRole').textContent = btn.getAttribute('data-role');
      document.getElementById('viewPassword').textContent = btn.getAttribute('data-password');
      document.getElementById('viewModal').style.display = 'flex';
    }
    function closeViewModal() {
      document.getElementById('viewModal').style.display = 'none';
    }
  </script>
</body>
</html> 