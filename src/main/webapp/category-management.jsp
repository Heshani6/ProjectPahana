<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.pahanaedu3.Models.Category" %>
<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String msg = (String) request.getAttribute("msg");
    String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Category Management</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f7f7f7; margin: 0; }
        .container { max-width: 1100px; margin: 40px auto; background: #fff; border-radius: 8px; box-shadow: 0 2px 8px #0001; padding: 32px; }
        h2 { color: #2c3e50; margin-bottom: 24px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 24px; }
        th, td { padding: 12px 10px; text-align: left; }
        th { background: #2c3e50; color: #fff; }
        tr:nth-child(even) { background: #f2f2f2; }
        .actions { display: flex; gap: 8px; }
        .btn { border: none; padding: 6px 16px; border-radius: 4px; cursor: pointer; font-weight: 500; transition: background 0.2s; }
        .btn-add { background: #27ae60; color: #fff; }
        .btn-edit { background: #2269ef; color: #fff; }
        .btn-delete { background: #c0392b; color: #fff; }
        .btn:hover { opacity: 0.9; }
        .form-inline { display: flex; gap: 12px; align-items: center; margin-bottom: 24px; flex-wrap: wrap; }
        .form-inline input[type="text"], .form-inline select { padding: 7px 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 1em; }
        .modal { display: none; position: fixed; z-index: 10; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.25); }
        .modal-content { background: #fff; margin: 8% auto; padding: 24px 32px; border-radius: 8px; width: 350px; box-shadow: 0 2px 8px #0002; position: relative; }
        .close { color: #aaa; position: absolute; right: 18px; top: 12px; font-size: 28px; font-weight: bold; cursor: pointer; }
        .close:hover { color: #c0392b; }
        .toast { visibility: hidden; min-width: 240px; background: #333; color: #fff; text-align: center; border-radius: 6px; padding: 14px 24px; position: fixed; z-index: 100; right: 32px; bottom: 32px; font-size: 1em; opacity: 0; transition: opacity 0.5s, visibility 0.5s; }
        .toast.show { visibility: visible; opacity: 1; }
        .toast.success { background: #27ae60; }
        .toast.error { background: #c0392b; }
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

<a href="admin-dashboard.jsp" class="back-arrow" title="Back to Admin Dashboard">&#8592;</a>
<div class="container">
    <h2>Category Management</h2>

    <!-- Add Category Form -->
    <form class="form-inline" action="category" method="post" onsubmit="return validateAddForm()">
        <input type="hidden" name="action" value="add" />
        <input type="text" name="name" id="addCategoryName" placeholder="New Category Name" required maxlength="50" />
        <input type="text" name="description" id="addCategoryDesc" placeholder="Description" maxlength="255" />
        <button type="submit" class="btn btn-add">Add Category</button>
    </form>

    <!-- Search Category -->
    <div style="margin-bottom:16px; display:flex; gap:8px; align-items:center;">
        <input type="text" id="searchCategoryInput" placeholder="Search category by name..."
               style="flex:1; padding:8px 12px; border-radius:4px; border:1px solid #ccc;" />
        <button type="button" class="btn btn-edit" onclick="searchCategory()">Search</button>
        <button type="button" class="btn btn-add" onclick="clearSearch()">Clear</button>
    </div>
    <!-- Category Table -->
    <table>
        <thead>
        <tr>
            <th style="width:60px;">ID</th>
            <th>Name</th>
            <th>Description</th>
            <th style="width:160px;">Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (categories != null && !categories.isEmpty()) { %>
        <% for (Category cat : categories) { %>
        <tr>
            <td><%= cat.getId() %></td>
            <td><%= cat.getName() %></td>
            <td><%= cat.getDescription() != null ? cat.getDescription() : "" %></td>
            <td class="actions">
                <button class="btn btn-edit"
                        onclick="openEditModal(<%= cat.getId() %>, '<%= cat.getName().replace("'", "\\'") %>', '<%= (cat.getDescription() != null ? cat.getDescription().replace("'", "\\'") : "") %>')">
                    Edit
                </button>
                <button type="button" class="btn btn-delete"
                        onclick="openDeleteCategoryModal(<%= cat.getId() %>, '<%= cat.getName().replace("'", "\\'") %>')">
                    Delete
                </button>
            </td>
        </tr>
        <% } %>
        <% } else { %>
        <tr><td colspan="4" style="text-align:center; color:#888;">No categories found.</td></tr>
        <% } %>
        </tbody>
    </table>
</div>

<!-- Edit Category Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeEditModal()">&times;</span>
        <h3>Edit Category</h3>
        <form id="editForm" action="category" method="post" onsubmit="return validateEditForm()">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="id" id="editCategoryId" />
            <div style="margin-bottom:16px;">
                <label for="editCategoryName">Name:</label><br/>
                <input type="text" name="name" id="editCategoryName" required maxlength="50" style="width:100%; padding:7px 10px; margin-top:6px;" />
            </div>
            <div style="margin-bottom:16px;">
                <label for="editCategoryDesc">Description:</label><br/>
                <input type="text" name="description" id="editCategoryDesc" maxlength="255" style="width:100%; padding:7px 10px; margin-top:6px;" />
            </div>
            <button type="submit" class="btn btn-edit" style="width:100%;">Update</button>
        </form>
    </div>
</div>

<!-- Delete Category Modal -->
<div id="deleteCategoryModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeDeleteCategoryModal()">&times;</span>
        <p>Are you sure you want to delete this category?</p>
        <div style="margin-bottom:18px;">
            <strong>Category Name:</strong> <span id="deleteCategoryName"></span>
        </div>
        <form id="deleteCategoryForm" action="category" method="post" style="display:inline;">
            <input type="hidden" name="action" value="delete" />
            <input type="hidden" name="id" id="deleteCategoryId" />
            <button type="submit" class="btn btn-delete" style="width:48%; margin-right:2%;">Yes, Delete</button>
            <button type="button" class="btn btn-edit" style="width:48%;" onclick="closeDeleteCategoryModal()">Cancel</button>
        </form>
    </div>
</div>

<!-- Toast Notification -->
<div id="toast" class="toast"></div>

<script>
    // Edit Modal
    function openEditModal(id, name, description) {
        document.getElementById('editCategoryId').value = id;
        document.getElementById('editCategoryName').value = name;
        document.getElementById('editCategoryDesc').value = description;
        document.getElementById('editModal').style.display = 'block';
    }
    function closeEditModal() { document.getElementById('editModal').style.display = 'none'; }

    // Delete Modal
    function openDeleteCategoryModal(id, name) {
        document.getElementById('deleteCategoryId').value = id;
        document.getElementById('deleteCategoryName').textContent = name;
        document.getElementById('deleteCategoryModal').style.display = 'block';
    }
    function closeDeleteCategoryModal() { document.getElementById('deleteCategoryModal').style.display = 'none'; }

    // Close modal if clicked outside
    window.onclick = function(event) {
        var editModal = document.getElementById('editModal');
        var deleteModal = document.getElementById('deleteCategoryModal');
        if (event.target === editModal) { closeEditModal(); }
        if (event.target === deleteModal) { closeDeleteCategoryModal(); }
    }

    // Toast
    function showToast(message, type) {
        var toast = document.getElementById('toast');
        toast.className = 'toast ' + (type || '');
        toast.textContent = message;
        toast.classList.add('show');
        setTimeout(function() { toast.classList.remove('show'); }, 3500);
    }

    // Show message if available
    <% if (msg != null && !msg.isEmpty()) { %>
    showToast('<%= msg.replace("'", "\\'") %>', '<%= msg.toLowerCase().contains("success") ? "success" : "error" %>');
    <% } %>

    // Validation
    function validateAddForm() {
        var name = document.getElementById('addCategoryName').value.trim();
        if (name.length === 0) { showToast('Category name is required.', 'error'); return false; }
        return true;
    }
    function validateEditForm() {
        var name = document.getElementById('editCategoryName').value.trim();
        if (name.length === 0) { showToast('Category name is required.', 'error'); return false; }
        return true;
    }

    // Filter table by category name
    function filterCategories(filter) {
        var table = document.querySelector('table tbody');
        var rows = table.getElementsByTagName('tr');

        for (var i = 0; i < rows.length; i++) {
            var tdName = rows[i].getElementsByTagName('td')[1]; // Name column
            if (tdName) {
                var txtValue = tdName.textContent || tdName.innerText;
                if (txtValue.toLowerCase().indexOf(filter.toLowerCase()) > -1) {
                    rows[i].style.display = "";
                } else {
                    rows[i].style.display = "none";
                }
            }
        }
    }

    // Triggered by Search button
    function searchCategory() {
        var input = document.getElementById('searchCategoryInput');
        filterCategories(input.value.trim());
    }

    // Triggered by Clear button
    function clearSearch() {
        document.getElementById('searchCategoryInput').value = '';
        filterCategories(''); // Show all rows
    }

    // Optional: live search as user types
    document.getElementById('searchCategoryInput').addEventListener('keyup', function() {
        filterCategories(this.value.trim());
    });

</script>
</body>
</html>


