<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.pahanaedu3.Models.Bill" %>
<%
    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    String msg = (String) request.getAttribute("msg");
    // Also check for msg parameter from URL
    if (msg == null) {
        msg = request.getParameter("msg");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill Management - Pahana EduBill</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* ========== Body Styles ========== */
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f7f7f7;
            margin: 0;
        }

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

        /* ========== Back Arrow ========== */
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
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }

        /* ========== Button Variants ========== */
        .btn-primary {
            background: #3b82f6;
            color: #fff;
        }

        .btn-primary:hover {
            background: #2563eb;
        }

        .btn-success {
            background: #10b981;
            color: #fff;
        }

        .btn-success:hover {
            background: #059669;
        }

        .btn-info {
            background: #6b7280;
            color: #fff;
        }

        .btn-info:hover {
            background: #4b5563;
        }

        .btn-danger {
            background: #ef4444;
            color: #fff;
        }

        .btn-danger:hover {
            background: #dc2626;
        }

        .btn-search {
            background: #8b5cf6;
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
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px #0001;
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
            background: #f8f9fa;
        }

        tr:hover {
            background: #e9ecef;
        }

        /* ========== Status Badge ========== */
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-paid {
            background: #d4edda;
            color: #155724;
        }

        .status-unpaid {
            background: #f8d7da;
            color: #721c24;
        }

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

        /* ========== Toast Notification ========== */
        .toast {
            position: fixed;
            bottom: 32px;
            right: 32px;
            min-width: 240px;
            background: #333;
            color: #fff;
            text-align: center;
            border-radius: 6px;
            padding: 14px 24px;
            font-size: 1em;
            z-index: 1000;
            visibility: hidden;
            opacity: 0;
            transition: opacity 0.5s, visibility 0.5s;
        }

        .toast.show {
            visibility: visible;
            opacity: 1;
        }

        .toast.success {
            background: transparent;
            color: #333;
            border: 2px solid #27ae60;
        }

        .toast.error {
            background: transparent;
            color: #333;
            border: 2px solid #c0392b;
        }

        /* ========== Empty State ========== */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        /* ========== Responsive Design ========== */
        @media (max-width: 768px) {
            .container {
                margin: 20px auto;
                padding: 20px;
            }
            
            .top-bar {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-section {
                flex-direction: column;
                max-width: none;
            }
            
            table {
                font-size: 13px;
            }
            
            th, td {
                padding: 8px 6px;
            }
            
            .actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<%
    String backUrl = "dashboard";
    String role = (String) session.getAttribute("role");
    if ("admin".equals(role)) {
        backUrl = "admin-dashboard.jsp";
    } else if ("staff".equals(role)) {
        backUrl= "staff-dashboard.jsp";

    }
%>
<a href="<%= backUrl %>" class="back-arrow" title="Back to Dashboard">
    &#8592;
</a>
    <div class="container">
        <h2>Bill Management</h2>

        <!-- Top Bar -->
        <div class="top-bar">
            <div class="search-section">
                <input type="text" class="search-input" placeholder="Search bills by number, customer..." id="searchInput" 
                       value="<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>">
                <button type="button" class="btn btn-search" onclick="searchBills()">
                    <i class=""></i> Search
                </button>
                <button type="button" class="btn btn-info" onclick="clearSearch()">
                    <i class=""></i> Clear
                </button>
            </div>
            <a href="create-bill" class="btn btn-success">
                <i class=""></i> Create New Bill
            </a>
        </div>

        <!-- Bills Table -->
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Bill Number</th>
                        <th>Customer</th>
                        <th>Date</th>
                        <th>Subtotal</th>
                        <th>Discount</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (bills != null && !bills.isEmpty()) { %>
                        <% for (Bill bill : bills) { %>
                            <tr>
                                <td><strong><%= bill.getBillNumber() %></strong></td>
                                <td>Customer ID: <%= bill.getCustomerId() %></td>
                                <td><%= bill.getBillDate() %></td>
                                <td>Rs <%= String.format("%.2f", bill.getSubtotal()) %></td>
                                <td>Rs <%= String.format("%.2f", bill.getTax()) %></td>
                                <td><strong>Rs <%= String.format("%.2f", bill.getTotal()) %></strong></td>
                                <td>
                                    <span class="status-badge <%= "paid".equals(bill.getStatus()) ? "status-paid" : "status-unpaid" %>">
                                        <%= bill.getStatus() %>
                                    </span>
                                </td>
                                <td class="actions">
                                    <button class="btn btn-info" onclick="openViewModal(<%= bill.getId() %>)">
                                        <i class=""></i> View
                                    </button>
                                    <button class="btn btn-primary" onclick="openEditModal(<%= bill.getId() %>)">
                                        <i class=""></i> Edit
                                    </button>
                                    <a href="print-bill?id=<%= bill.getId() %>" class="btn btn-success" target="_blank">
                                        <i class=""></i> Print
                                    </a>
                                    <form action="bill" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this bill? This action cannot be undone.');">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="id" value="<%= bill.getId() %>" />
                                        <button type="submit" class="btn btn-danger">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="8">
                                <div class="empty-state">
                                    <i class="fas fa-file-invoice"></i>
                                    <h3>No bills found</h3>
                                    <p>Create your first bill to get started</p>
                                    <a href="create-bill" class="btn btn-success" style="margin-top: 20px;">
                                        <i class="fas fa-plus"></i> Create First Bill
                                    </a>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Edit Bill Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditModal()">&times;</span>
            <h3>Edit Bill</h3>
            <form id="editForm" action="bill" method="post" onsubmit="return validateEditForm()">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="id" id="editBillId" />
                <div style="margin-bottom:12px;">
                    <label for="editBillNumber">Bill Number:</label><br/>
                    <input type="text" name="billNumber" id="editBillNumber" required maxlength="50" style="width:100%; padding:7px 10px; margin-top:6px;" />
                </div>
                <div style="margin-bottom:12px;">
                    <label for="editCustomerId">Customer ID:</label><br/>
                    <input type="number" name="customerId" id="editCustomerId" required style="width:100%; padding:7px 10px; margin-top:6px;" />
                </div>
                <div style="margin-bottom:12px;">
                    <label for="editBillDate">Bill Date:</label><br/>
                    <input type="date" name="billDate" id="editBillDate" required style="width:100%; padding:7px 10px; margin-top:6px;" />
                </div>
                <div style="margin-bottom:12px;">
                    <label for="editSubtotal">Subtotal:</label><br/>
                    <input type="number" step="0.01" name="subtotal" id="editSubtotal" required style="width:100%; padding:7px 10px; margin-top:6px;" />
                </div>
                <div style="margin-bottom:12px;">
                    <label for="editTax">Tax:</label><br/>
                    <input type="number" step="0.01" name="tax" id="editTax" required style="width:100%; padding:7px 10px; margin-top:6px;" />
                </div>
                <div style="margin-bottom:12px;">
                    <label for="editTotal">Total:</label><br/>
                    <input type="number" step="0.01" name="total" id="editTotal" required style="width:100%; padding:7px 10px; margin-top:6px;" />
                </div>
                <div style="margin-bottom:18px;">
                    <label for="editStatus">Status:</label><br/>
                    <select name="status" id="editStatus" required style="width:100%; padding:7px 10px; margin-top:6px;">
                        <option value="paid">Paid</option>
                        <option value="unpaid">Unpaid</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%;">Update</button>
            </form>
        </div>
    </div>

    <!-- View Bill Modal -->
    <div id="viewModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeViewModal()">&times;</span>
            <h3>Bill Details</h3>
            <div style="margin-bottom:12px;"><b>ID:</b> <span id="viewBillId"></span></div>
            <div style="margin-bottom:12px;"><b>Bill Number:</b> <span id="viewBillNumber"></span></div>
            <div style="margin-bottom:12px;"><b>Customer ID:</b> <span id="viewCustomerId"></span></div>
            <div style="margin-bottom:12px;"><b>Bill Date:</b> <span id="viewBillDate"></span></div>
            <div style="margin-bottom:12px;"><b>Subtotal:</b> Rs <span id="viewSubtotal"></span></div>
            <div style="margin-bottom:12px;"><b>Tax:</b> Rs <span id="viewTax"></span></div>
            <div style="margin-bottom:12px;"><b>Total:</b> Rs <span id="viewTotal"></span></div>
            <div style="margin-bottom:12px;"><b>Status:</b> <span id="viewStatus"></span></div>
            <button class="btn btn-info" style="width:100%; margin-top:10px;" onclick="closeViewModal()">Close</button>
        </div>
    </div>

    <!-- Toast Notification -->
    <div id="toast" class="toast"></div>

    <script>
        // Search bills function
        function searchBills() {
            const searchQuery = document.getElementById('searchInput').value.trim();
            if (searchQuery) {
                window.location.href = 'bill?search=' + encodeURIComponent(searchQuery);
            } else {
                showToast('Please enter a search term', 'error');
            }
        }

        // Clear search function
        function clearSearch() {
            document.getElementById('searchInput').value = '';
            window.location.href = 'bill';
        }

        // Edit Modal logic
        function openEditModal(id) {
            // Fetch bill data from server
            fetch('bill?action=get&id=' + id)
                .then(response => response.json())
                .then(bill => {
                    document.getElementById('editBillId').value = bill.id;
                    document.getElementById('editBillNumber').value = bill.billNumber;
                    document.getElementById('editCustomerId').value = bill.customerId;
                    document.getElementById('editBillDate').value = bill.billDate;
                    document.getElementById('editSubtotal').value = bill.subtotal;
                    document.getElementById('editTax').value = bill.tax;
                    document.getElementById('editTotal').value = bill.total;
                    document.getElementById('editStatus').value = bill.status;
                    document.getElementById('editModal').style.display = 'block';
                })
                .catch(error => {
                    console.error('Error fetching bill data:', error);
                    showToast('Error loading bill data', 'error');
                });
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        // View Modal logic
        function openViewModal(id) {
            // Fetch bill data from server
            fetch('bill?action=get&id=' + id)
                .then(response => response.json())
                .then(bill => {
                    document.getElementById('viewBillId').textContent = bill.id;
                    document.getElementById('viewBillNumber').textContent = bill.billNumber;
                    document.getElementById('viewCustomerId').textContent = bill.customerId;
                    document.getElementById('viewBillDate').textContent = bill.billDate;
                    document.getElementById('viewSubtotal').textContent = bill.subtotal;
                    document.getElementById('viewTax').textContent = bill.tax;
                    document.getElementById('viewTotal').textContent = bill.total;
                    document.getElementById('viewStatus').textContent = bill.status;
                    document.getElementById('viewModal').style.display = 'block';
                })
                .catch(error => {
                    console.error('Error fetching bill data:', error);
                    showToast('Error loading bill data', 'error');
                });
        }

        function closeViewModal() {
            document.getElementById('viewModal').style.display = 'none';
        }

        // Close modals when clicking outside
        window.onclick = function(event) {
            var editModal = document.getElementById('editModal');
            var viewModal = document.getElementById('viewModal');
            if (event.target === editModal) closeEditModal();
            if (event.target === viewModal) closeViewModal();
        }

        // Show toast function
        function showToast(message, type) {
            var toast = document.getElementById('toast');
            toast.className = 'toast ' + (type || '');
            toast.textContent = message;
            toast.classList.add('show');
            setTimeout(function() {
                toast.classList.remove('show');
            }, 5000);
        }

        // Edit form validation
        function validateEditForm() {
            var billNumber = document.getElementById('editBillNumber').value.trim();
            var customerId = document.getElementById('editCustomerId').value.trim();
            var billDate = document.getElementById('editBillDate').value.trim();
            var subtotal = document.getElementById('editSubtotal').value.trim();
            var tax = document.getElementById('editTax').value.trim();
            var total = document.getElementById('editTotal').value.trim();
            var status = document.getElementById('editStatus').value.trim();
            
            if (!billNumber || !customerId || !billDate || !subtotal || !tax || !total || !status) {
                showToast('All fields are required.', 'error');
                return false;
            }
            return true;
        }

        // Show toast if message is present from server
        <% if (msg != null && !msg.trim().isEmpty()) { %>
            showToast('<%= msg.replace("'", "\\'") %>', '<%= msg.toLowerCase().contains("success") ? "success" : "error" %>');
        <% } %>
    </script>
</body>
</html> 