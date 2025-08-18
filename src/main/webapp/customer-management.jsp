<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.pahanaedu3.Models.Customer" %>
<%
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    String msg = (String) request.getAttribute("msg");
    String userRole = (String) request.getAttribute("userRole");
    if (userRole == null) userRole = "staff"; // Default to staff for security
    String searchTerm = (String) request.getAttribute("searchTerm");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Management</title>
    <style>
        /* ========== Body Styles ========== */
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f7f7f7;
            margin: 0;
        }

        /* ========== Container Styles ========== */
        .container {
            max-width: 1100px;
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
            padding: 12px 24px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }

        /* ========== Button Variants ========== */
        .btn-add {
            background: #059669;
            color: #fff;
            margin-left: 8px;
        }

        .btn-success {
            background: #059669;
            color: #fff;
            margin-left: 8px;
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
            transform: translateY(-1px);
        }

        .btn-search:active {
            transform: translateY(0);
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

        /* ========== Actions Button Group ========== */
        .actions {
            display: flex;
            gap: 6px;
        }

        /* ========== Compact Action Buttons ========== */
        .actions .btn {
            padding: 6px 12px;
            font-size: 12px;
            gap: 4px;
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
            width: 400px;
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

        /* ========== Role Badge ========== */
        .role-badge {
            background: #e74c3c;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            margin-left: 10px;
        }

        .role-badge.staff {
            background: #f39c12;
        }

        .role-badge.admin {
            background: #e74c3c;
        }

    </style>
</head>
<body>
<%
    String dashboardPage = "login.jsp"; // default fallback
    if ("admin".equals(userRole)) {
        dashboardPage = "admin-dashboard.jsp";
    } else if ("staff".equals(userRole)) {
        dashboardPage = "staff-dashboard.jsp";
    }
%>

<a href="<%= dashboardPage %>" class="back-arrow" title="Back to Dashboard">
    &#8592;
</a>
<div class="container">
    <h2>
        Customer Management
    </h2>

    <!-- Top Bar -->
    <div class="top-bar">
        <div class="search-section">
            <input type="text" class="search-input" placeholder="Search by account number..." id="searchInput" value="<%= searchTerm != null ? searchTerm : "" %>" onkeypress="handleSearchKeyPress(event)">
            <button type="button" class="btn btn-search" onclick="searchCustomers()">
                <i class="fas fa-search"></i> Search
            </button>
            <button type="button" class="btn btn-delete" onclick="clearSearch()">
                <i class="fas fa-times"></i> Clear
            </button>
        </div>
        <a href="add-customer.jsp" class="btn btn-success">
            <i class="fas fa-plus"></i> Add Customer
        </a>
    </div>
    <table>
        <thead>
        <tr>
            <th style="width:60px;">ID</th>
            <th>Account Number</th>
            <th>Name</th>
            <th>Address</th>
            <th>Telephone</th>
            <th style="width:240px;">Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (customers != null && !customers.isEmpty()) { %>
            <% for (Customer customer : customers) { %>
                <tr>
                    <td><%= customer.getId() %></td>
                    <td><%= customer.getAccountNumber() %></td>
                    <td><%= customer.getName() %></td>
                    <td><%= customer.getAddress() %></td>
                    <td><%= customer.getPhone() %></td>
                    <td class="actions">
                        <button class="btn btn-view" onclick="openViewModal('<%= customer.getId() %>', '<%= customer.getAccountNumber() != null ? customer.getAccountNumber().replace("'", "\\'") : "" %>', '<%= customer.getName() != null ? customer.getName().replace("'", "\\'") : "" %>', '<%= customer.getAddress() != null ? customer.getAddress().replace("'", "\\'") : "" %>', '<%= customer.getPhone() != null ? customer.getPhone().replace("'", "\\'") : "" %>')">View</button>
                        <button class="btn btn-edit" onclick="openEditModal('<%= customer.getId() %>', '<%= customer.getAccountNumber() != null ? customer.getAccountNumber().replace("'", "\\'") : "" %>', '<%= customer.getName() != null ? customer.getName().replace("'", "\\'") : "" %>', '<%= customer.getAddress() != null ? customer.getAddress().replace("'", "\\'") : "" %>', '<%= customer.getPhone() != null ? customer.getPhone().replace("'", "\\'") : "" %>')">Edit</button>
                        <% if ("admin".equalsIgnoreCase(userRole)) { %>
                            <button type="button" class="btn btn-delete" onclick="openDeleteModal('<%= customer.getId() %>', '<%= customer.getName() != null ? customer.getName().replace("'", "\\'") : "" %>')">Delete</button>
                        <% } %>
                    </td>
                </tr>
            <% } %>
        <% } else { %>
            <tr><td colspan="6" style="text-align:center; color:#888;">No customers found.</td></tr>
        <% } %>
        </tbody>
    </table>
</div>

<!-- Edit Customer Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeEditModal()">&times;</span>
        <h3>Edit Customer</h3>
        <form id="editForm" action="customer" method="post" onsubmit="return validateEditForm()">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="id" id="editCustomerId" />
            <div style="margin-bottom:12px;">
                <label for="editAccountNumber">Account Number:</label><br/>
                <input type="text" name="accountNumber" id="editAccountNumber" required maxlength="20" style="width:100%; padding:7px 10px; margin-top:6px;" />
            </div>
            <div style="margin-bottom:12px;">
                <label for="editName">Name:</label><br/>
                <input type="text" name="name" id="editName" required maxlength="50" style="width:100%; padding:7px 10px; margin-top:6px;" />
            </div>
            <div style="margin-bottom:12px;">
                <label for="editAddress">Address:</label><br/>
                <input type="text" name="address" id="editAddress" required maxlength="100" style="width:100%; padding:7px 10px; margin-top:6px;" />
            </div>
            <div style="margin-bottom:18px;">
                <label for="editTelephone">Telephone:</label><br/>
                <input type="text" name="telephone" id="editTelephone" required maxlength="15" style="width:100%; padding:7px 10px; margin-top:6px;" />
            </div>
            <button type="submit" class="btn btn-edit" style="width:100%;">Update</button>
        </form>
    </div>
</div>

<!-- View Customer Modal -->
<div id="viewModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeViewModal()">&times;</span>
        <h3>Customer Details</h3>
        <div style="margin-bottom:12px;"><b>ID:</b> <span id="viewCustomerId"></span></div>
        <div style="margin-bottom:12px;"><b>Account Number:</b> <span id="viewAccountNumber"></span></div>
        <div style="margin-bottom:12px;"><b>Name:</b> <span id="viewName"></span></div>
        <div style="margin-bottom:12px;"><b>Address:</b> <span id="viewAddress"></span></div>
        <div style="margin-bottom:12px;"><b>Telephone:</b> <span id="viewTelephone"></span></div>
        <button class="btn btn-view" style="width:100%; margin-top:10px;" onclick="closeViewModal()">Close</button>
    </div>
</div>

<!-- Delete Customer Modal -->
<div id="deleteModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeDeleteModal()">&times;</span>
        <p>Are you sure you want to delete this customer?</p>
        <div style="margin-bottom:18px;">
            <strong>Customer Name:</strong> <span id="deleteCustomerName"></span>
        </div>
        <form id="deleteForm" action="customer" method="post" style="display:inline;">
            <input type="hidden" name="action" value="delete" />
            <input type="hidden" name="id" id="deleteCustomerId" />
            <button type="submit" class="btn btn-delete" style="width:48%; margin-right:2%;">Yes, Delete</button>
            <button type="button" class="btn btn-view" style="width:48%;" onclick="closeDeleteModal()">Cancel</button>
        </form>
    </div>
</div>

<!-- Toast Notification -->
<div id="toast" class="toast"></div>

<script>
// Edit Modal logic
function openEditModal(id, accountNumber, name, address, telephone) {
    document.getElementById('editCustomerId').value = id;
    document.getElementById('editAccountNumber').value = accountNumber;
    document.getElementById('editName').value = name;
    document.getElementById('editAddress').value = address;
    document.getElementById('editTelephone').value = telephone;
    document.getElementById('editModal').style.display = 'block';
}
function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
}
// View Modal logic
function openViewModal(id, accountNumber, name, address, telephone) {
    document.getElementById('viewCustomerId').textContent = id;
    document.getElementById('viewAccountNumber').textContent = accountNumber;
    document.getElementById('viewName').textContent = name;
    document.getElementById('viewAddress').textContent = address;
    document.getElementById('viewTelephone').textContent = telephone;
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
function openDeleteModal(id, name) {
    document.getElementById('deleteCustomerId').value = id;
    document.getElementById('deleteCustomerName').textContent = name;
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

function searchCustomers() {
    const searchTerm = document.getElementById('searchInput').value;
    if (searchTerm.trim() !== '') {
        window.location.href = 'customer?search=' + encodeURIComponent(searchTerm);
    } else {
        showToast('Please enter a search term.', 'error');
    }
}


function clearSearch() {
    document.getElementById('searchInput').value = '';
    window.location.href = 'customer';
}

// Edit form validation
function validateEditForm() {
    var accountNumber = document.getElementById('editAccountNumber').value.trim();
    var name = document.getElementById('editName').value.trim();
    var address = document.getElementById('editAddress').value.trim();
    var telephone = document.getElementById('editTelephone').value.trim();
    if (!accountNumber || !name || !address || !telephone) {
        showToast('All fields are required.', 'error');
        return false;
    }
    return true;
}
</script>
</body>
</html>