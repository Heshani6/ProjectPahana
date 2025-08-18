<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.pahanaedu3.Models.User" %>
<%
    List<User> users = (List<User>) request.getAttribute("users");
    String msg = (String) request.getAttribute("msg");
    String searchTerm = request.getParameter("search");
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Management</title>
    <style>
      body {
        font-family: 'Segoe UI', Arial, sans-serif;
        background: #f7f7f7;
        margin: 0;
      }

      /* ========== Container Styles ========== */
      .container {
        max-width: 900px;
        margin: 40px auto;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 8px #0001;
        padding: 32px 32px 24px 32px;
      }

      /* ========== Heading Styles ========== */
      h2 {
        color: #2c3e50;
        margin-bottom: 24px;
      }

      /* ========== Top Bar ========== */
      .top-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
        flex-wrap: wrap;
        gap: 16px;
      }

      .search-section {
        display: flex;
        gap: 12px;
        flex: 1;
        max-width: 600px;
      }

      .search-input {
        flex: 1;
        padding: 8px 12px;
        border: 2px solid #e1e5e9;
        border-radius: 4px;
        font-size: 14px;
        transition: border-color 0.2s;
      }

      .search-input:focus {
        outline: none;
        border-color: #27ae60;
      }

      /* ========== Button Base Styles ========== */
      .btn {
        border: none;
        padding: 6px 16px;
        border-radius: 4px;
        cursor: pointer;
        font-weight: 500;
        transition: background 0.2s;
      }


              .btn-success {
          background: #059669;
          color: #fff;
          margin-left: 8px;
          text-decoration: none;
        }

      .btn-edit {
        background: #2563eb;
        color: #fff;
      }

      .btn-delete {
        background: #dc2626;
        color: #fff;
      }

      .btn-view {
        background: #4b5563;
        color: #fff;
      }

      .btn-search {
        background: #8989dd;
        color: #fff;
      }

      .btn-search:hover {
        background: #7c3aed;
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
        gap: 6px;
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
        background: rgba(0,0,0,0.25);
      }

      .modal-content {
        background: #fff;
        margin: 8% auto;
        padding: 24px 32px;
        border-radius: 8px;
        width: 350px;
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

      /* ========== Toast (Notification) Styles ========== */
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
<a href="admin-dashboard.jsp" class="back-arrow" title="Back to admin Dashboard">
    &#8592;
</a>
<div class="container">
    <h2>User Management</h2>

    <!-- Top Bar -->
    <div class="top-bar">
        <div class="search-section">
            <input type="text" class="search-input" placeholder="Search by username..." id="searchInput" value="<%= searchTerm != null ? searchTerm : "" %>">
            <button type="button" class="btn btn-search" onclick="searchUsers()">
                <i class="fas fa-search"></i> Search
            </button>
            <button type="button" class="btn btn-delete" onclick="clearSearch()">
                <i class="fas fa-times"></i> Clear
            </button>
        </div>
        <a href="add-staff.jsp" class="btn btn-success">
            <i class="fas fa-plus"></i> Add User
        </a>
    </div>
    <table>
        <thead>
        <tr>
            <th style="width:60px;">ID</th>
            <th>Username</th>
            <th>Role</th>
            <th>Password</th>
            <th style="width:220px;">Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (users != null && !users.isEmpty()) { %>
            <% for (User user : users) { %>
                <tr>
                    <td><%= user.getId() %></td>
                    <td><%= user.getUsername() %></td>
                    <td><%= user.getRole() %></td>
                    <td><%= user.getPassword() %></td>
                    <td class="actions">
                        <button class="btn btn-view" onclick="openViewModal('<%= user.getId() %>', '<%= user.getUsername().replace("'", "\\'") %>', '<%= user.getRole().replace("'", "\\'") %>', '<%= user.getPassword().replace("'", "\\'") %>')">View</button>
                        <button class="btn btn-edit" onclick="openEditModal('<%= user.getId() %>', '<%= user.getUsername().replace("'", "\\'") %>', '<%= user.getRole().replace("'", "\\'") %>', '<%= user.getPassword().replace("'", "\\'") %>')">Edit</button>
                        <button type="button" class="btn btn-delete" onclick="openDeleteModal('<%= user.getId() %>', '<%= user.getUsername() != null ? user.getUsername().replace("'", "\\'") : "" %>')">Delete</button>
                    </td>
                </tr>
            <% } %>
        <% } else { %>
            <tr><td colspan="5" style="text-align:center; color:#888;">No users found.</td></tr>
        <% } %>
        </tbody>
    </table>
</div>

<!-- Edit User Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeEditModal()">&times;</span>
        <h3>Edit User</h3>
        <form id="editForm" action="user" method="post" onsubmit="return validateEditForm()">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="id" id="editUserId" />
            <div style="margin-bottom:12px;">
                <label for="editUsername">Username:</label><br/>
                <input type="text" name="username" id="editUsername" required maxlength="50" style="width:100%; padding:7px 10px; margin-top:6px;" />
            </div>
            <div style="margin-bottom:12px;">
                <label for="editRole">Role:</label><br/>
                <input type="text" name="role" id="editRole" required maxlength="20" style="width:100%; padding:7px 10px; margin-top:6px;" />
            </div>
            <div style="margin-bottom:18px;">
                <label for="editPassword">Password:</label><br/>
                <input type="text" name="password" id="editPassword" required maxlength="50" style="width:100%; padding:7px 10px; margin-top:6px;" />
            </div>
            <button type="submit" class="btn btn-edit" style="width:100%;">Update</button>
        </form>
    </div>
</div>

<!-- View User Modal -->
<div id="viewModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeViewModal()">&times;</span>
        <h3>User Details</h3>
        <div style="margin-bottom:12px;"><b>ID:</b> <span id="viewUserId"></span></div>
        <div style="margin-bottom:12px;"><b>Username:</b> <span id="viewUsername"></span></div>
        <div style="margin-bottom:12px;"><b>Role:</b> <span id="viewRole"></span></div>
        <div style="margin-bottom:12px;"><b>Password:</b> <span id="viewPassword"></span></div>
        <button class="btn btn-view" style="width:100%; margin-top:10px;" onclick="closeViewModal()">Close</button>
    </div>
</div>

<!-- Delete User Modal -->
<div id="deleteModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeDeleteModal()">&times;</span>
        <p>Are you sure you want to delete this user?</p>
        <div style="margin-bottom:18px;">
            <strong>Username:</strong> <span id="deleteUsername"></span>
        </div>
        <form id="deleteForm" action="user" method="post" style="display:inline;">
            <input type="hidden" name="action" value="delete" />
            <input type="hidden" name="id" id="deleteUserId" />
            <button type="submit" class="btn btn-delete" style="width:48%; margin-right:2%;">Yes, Delete</button>
            <button type="button" class="btn btn-view" style="width:48%;" onclick="closeDeleteModal()">Cancel</button>
        </form>
    </div>
</div>

<!-- Toast Notification -->
<div id="toast" class="toast"></div>

<script>
// Edit Modal logic
function openEditModal(id, username, role, password) {
    document.getElementById('editUserId').value = id;
    document.getElementById('editUsername').value = username;
    document.getElementById('editRole').value = role;
    document.getElementById('editPassword').value = password;
    document.getElementById('editModal').style.display = 'block';
}
function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
}
// View Modal logic
function openViewModal(id, username, role, password) {
    document.getElementById('viewUserId').textContent = id;
    document.getElementById('viewUsername').textContent = username;
    document.getElementById('viewRole').textContent = role;
    document.getElementById('viewPassword').textContent = password;
    document.getElementById('viewModal').style.display = 'block';
}
function closeViewModal() {
    document.getElementById('viewModal').style.display = 'none';
}
window.onclick = function(event) {
    var editModal = document.getElementById('editModal');
    var viewModal = document.getElementById('viewModal');
    var deleteModal = document.getElementById('deleteModal');
    if (event.target === editModal) closeEditModal();
    if (event.target === viewModal) closeViewModal();
    if (event.target === deleteModal) closeDeleteModal();
}

// Delete Modal logic
function openDeleteModal(id, username) {
    document.getElementById('deleteUserId').value = id;
    document.getElementById('deleteUsername').textContent = username;
    document.getElementById('deleteModal').style.display = 'block';
}
function closeDeleteModal() {
    document.getElementById('deleteModal').style.display = 'none';
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
    showToast('<%= msg.replace("'", "\\'") %>', '<%= msg.toLowerCase().contains("success") ? "success" : "error" %>');
<% } %>

function searchUsers() {
    const searchTerm = document.getElementById('searchInput').value;
    if (searchTerm.trim() !== '') {
        window.location.href = 'user?search=' + encodeURIComponent(searchTerm);
    } else {
        showToast('Please enter a search term.', 'error');
    }
}

function clearSearch() {
    document.getElementById('searchInput').value = '';
    window.location.href = 'user';
}

function handleSearchKeyPress(event) {
    if (event.key === 'Enter') {
        event.preventDefault();
        searchUsers();
    }
}

// Edit form validation
function validateEditForm() {
    var username = document.getElementById('editUsername').value.trim();
    var role = document.getElementById('editRole').value.trim();
    var password = document.getElementById('editPassword').value.trim();
    if (!username || !role || !password) {
        showToast('All fields are required.', 'error');
        return false;
    }
    return true;
}
</script>
</body>
</html> 