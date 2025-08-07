<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.pahanaedu3.Models.Customer" %>
<%@ page import="com.example.pahanaedu3.Models.Item" %>
<%
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    List<Item> items = (List<Item>) request.getAttribute("items");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Bill - Pahana EduBill</title>
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

        /* ========== Form Section Styles ========== */
        .form-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 24px;
            border: 1px solid #e1e5e9;
        }

        .section-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* ========== Form Group Styles ========== */
        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #2c3e50;
        }

        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 2px solid #e1e5e9;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.2s;
            background: white;
        }

        .form-control:focus {
            outline: none;
            border-color: #27ae60;
        }

        /* ========== Items Section ========== */
        .items-section {
            background: white;
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 24px;
            border: 1px solid #e1e5e9;
        }

        .items-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        /* ========== Button Base Styles ========== */
        .btn {
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: background 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
        }

        /* ========== Button Variants ========== */
        .btn-primary {
            background: #7878b1;
            color: #fff;
        }

        .btn-primary:hover {
            background: #1e5bb8;
        }

        .btn-success {
            background: #27ae60;
            color: #fff;
        }

        .btn-success:hover {
            background: #1e8449;
        }

        .btn-danger {
            background: #c0392b;
            color: #fff;
        }

        .btn-danger:hover {
            background: #a93226;
        }

        /* ========== Item Row Styles ========== */
        .item-row {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr auto;
            gap: 12px;
            align-items: center;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 6px;
            margin-bottom: 12px;
            border: 1px solid #e1e5e9;
        }

        .item-row:last-child {
            margin-bottom: 0;
        }

        .item-row input,
        .item-row select {
            padding: 8px 10px;
            border: 2px solid #e1e5e9;
            border-radius: 4px;
            font-size: 13px;
            transition: border-color 0.2s;
        }

        .item-row input:focus,
        .item-row select:focus {
            outline: none;
            border-color: #27ae60;
        }

        .row-total {
            font-weight: 600;
            color: #2c3e50;
        }

        /* ========== Total Section ========== */
        .total-section {
            background: #2c3e50;
            color: white;
            border-radius: 8px;
            padding: 24px;
            margin-top: 24px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            font-size: 16px;
        }

        .total-row:last-child {
            margin-bottom: 0;
            font-size: 20px;
            font-weight: 700;
            border-top: 2px solid rgba(255,255,255,0.2);
            padding-top: 12px;
        }

        /* ========== Feedback Messages ========== */
        .feedback {
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 16px;
            font-weight: 500;
        }

        .feedback.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .feedback.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* ========== Toast Notification ========== */
        .toast {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 12px 16px;
            border-radius: 6px;
            color: white;
            font-weight: 500;
            z-index: 1000;
            opacity: 0;
            transform: translateX(100%);
            transition: all 0.3s ease;
        }

        .toast.show {
            opacity: 1;
            transform: translateX(0);
        }

        .toast.success {
            background: #27ae60;
        }

        .toast.error {
            background: #c0392b;
        }

        /* ========== Responsive Design ========== */
        @media (max-width: 768px) {
            .container {
                margin: 20px auto;
                padding: 20px;
            }
            
            .item-row {
                grid-template-columns: 1fr;
                gap: 8px;
            }
            
            .items-header {
                flex-direction: column;
                align-items: stretch;
                gap: 12px;
            }
        }
    </style>
</head>
<body>
    <a href="bill" class="back-arrow" title="Back to Bill Management">
        &#8592;
    </a>
    <div class="container">
        <h2>Create New Bill</h2>

        <!-- Feedback Messages -->
        <% if (request.getAttribute("success") != null) { %>
            <div class="feedback success">
                <i class="fas fa-check-circle"></i> <%= request.getAttribute("success") %>
            </div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="feedback error">
                <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form id="billForm" action="create-bill" method="post">
            <!-- Customer Selection -->
            <div class="form-section">
                <div class="section-title">
                    <i class="fas fa-user"></i> Customer Information
                </div>
                <div class="form-group">
                    <label for="customerId">Select Customer *</label>
                    <select id="customerId" name="customerId" class="form-control" required>
                        <option value="">Choose a customer...</option>
                        <% if (customers != null) { %>
                            <% for (Customer customer : customers) { %>
                                <option value="<%= customer.getId() %>">
                                    <%= customer.getName() %> - <%= customer.getAccountNumber() %>
                                </option>
                            <% } %>
                        <% } %>
                    </select>
                </div>
            </div>

            <!-- Items Section -->
            <div class="items-section">
                <div class="items-header">
                    <div class="section-title">
                        <i class="fas fa-shopping-cart"></i> Bill Items
                    </div>
                    <button type="button" class="btn btn-primary" onclick="addItemRow()">
                        <i class="fas fa-plus"></i> Add Item
                    </button>
                </div>
                
                <div id="itemsContainer">
                    <!-- Item rows will be added here dynamically -->
                </div>
            </div>

            <!-- Totals Section -->
            <div class="total-section">
                <div class="total-row">
                    <span>Subtotal:</span>
                    <span id="subtotal">Rs 0.00</span>
                </div>
                <div class="total-row">
                    <span>Tax (5%):</span>
                    <span id="tax">Rs 0.00</span>
                </div>
                <div class="total-row">
                    <span>Total:</span>
                    <span id="total">Rs 0.00</span>
                </div>
            </div>

            <!-- Submit Button -->
            <div style="text-align: center; margin-top: 24px;">
                <button type="submit" class="btn btn-success" style="padding: 12px 32px; font-size: 16px;">
                    <i></i> Create Bill
                </button>
            </div>
        </form>
    </div>

    <!-- Toast Notification -->
    <div id="toast" class="toast"></div>

    <script>
        let itemCounter = 0;
        const items = [
            <% if (items != null) { %>
                <% for (Item item : items) { %>
                    {id: <%= item.getId() %>, name: '<%= item.getName() %>', price: <%= item.getPrice() %>},
                <% } %>
            <% } %>
        ];

        // Initialize with one item row
        document.addEventListener('DOMContentLoaded', function() {
            addItemRow();
        });

        function addItemRow() {
            const container = document.getElementById('itemsContainer');
            const row = document.createElement('div');
            row.className = 'item-row';
            row.id = 'item-row-' + itemCounter;
            
            // Create the select element
            const select = document.createElement('select');
            select.name = 'itemId';
            select.className = 'form-control';
            select.setAttribute('onchange', 'updatePrice(' + itemCounter + ')');
            select.required = true;
            
            // Add default option
            const defaultOption = document.createElement('option');
            defaultOption.value = '';
            defaultOption.textContent = 'Select item...';
            select.appendChild(defaultOption);
            
            // Add item options
            items.forEach(function(item) {
                const option = document.createElement('option');
                option.value = item.id;
                option.setAttribute('data-price', item.price);
                option.textContent = item.name + ' - Rs' + item.price;
                select.appendChild(option);
            });
            
            // Create quantity input
            const quantityInput = document.createElement('input');
            quantityInput.type = 'number';
            quantityInput.name = 'quantity';
            quantityInput.placeholder = 'Qty';
            quantityInput.min = '1';
            quantityInput.value = '1';
            quantityInput.setAttribute('onchange', 'calculateRowTotal(' + itemCounter + ')');
            quantityInput.required = true;
            
            // Create price input
            const priceInput = document.createElement('input');
            priceInput.type = 'number';
            priceInput.name = 'unitPrice';
            priceInput.placeholder = 'Price';
            priceInput.step = '0.01';
            priceInput.readOnly = true;
            
            // Create total span
            const totalSpan = document.createElement('span');
            totalSpan.className = 'row-total';
            totalSpan.textContent = 'Rs 0.00';
            
            // Create remove button
            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            removeBtn.className = 'btn btn-danger';
            removeBtn.setAttribute('onclick', 'removeItemRow(' + itemCounter + ')');
            removeBtn.innerHTML = '<i class="fas fa-trash"></i>';
            
            // Append all elements to row
            row.appendChild(select);
            row.appendChild(quantityInput);
            row.appendChild(priceInput);
            row.appendChild(totalSpan);
            row.appendChild(removeBtn);
            
            container.appendChild(row);
            itemCounter++;
        }

        function removeItemRow(index) {
            const row = document.getElementById('item-row-' + index);
            if (row) {
                row.remove();
                calculateTotals();
            }
        }
            
        function updatePrice(index) {
            const row = document.getElementById('item-row-' + index);
            const select = row.querySelector('select');
            const priceInput = row.querySelector('input[name="unitPrice"]');
            const option = select.options[select.selectedIndex];
            
            if (option.value) {
                priceInput.value = option.getAttribute('data-price');
                calculateRowTotal(index);
            }
        }

        function calculateRowTotal(index) {
            const row = document.getElementById('item-row-' + index);
            const quantity = parseFloat(row.querySelector('input[name="quantity"]').value) || 0;
            const price = parseFloat(row.querySelector('input[name="unitPrice"]').value) || 0;
            const total = quantity * price;
            
            row.querySelector('.row-total').textContent = 'Rs' + total.toFixed(2);
            calculateTotals();
        }

        function calculateTotals() {
            let subtotal = 0;
            const rows = document.querySelectorAll('.item-row');
            
            rows.forEach(row => {
                const quantity = parseFloat(row.querySelector('input[name="quantity"]').value) || 0;
                const price = parseFloat(row.querySelector('input[name="unitPrice"]').value) || 0;
                subtotal += quantity * price;
            });
            
            const tax = subtotal * 0.05;
            const total = subtotal + tax;
            
            document.getElementById('subtotal').textContent = 'Rs' + subtotal.toFixed(2);
            document.getElementById('tax').textContent = 'Rs' + tax.toFixed(2);
            document.getElementById('total').textContent = 'Rs' + total.toFixed(2);
        }

        // Form validation
        document.getElementById('billForm').addEventListener('submit', function(e) {
            console.log('Form submission started...');
            
            const customerId = document.getElementById('customerId').value;
            console.log('Customer ID selected:', customerId);
            
            if (!customerId) {
                showToast('Please select a customer', 'error');
                e.preventDefault();
                return false;
            }
            
            const itemRows = document.querySelectorAll('.item-row');
            let hasItems = false;
            let itemCount = 0;
            
            itemRows.forEach(row => {
                const itemId = row.querySelector('select[name="itemId"]').value;
                const quantity = row.querySelector('input[name="quantity"]').value;
                const unitPrice = row.querySelector('input[name="unitPrice"]').value;
                console.log('Item row - ID:', itemId, 'Qty:', quantity, 'Price:', unitPrice);
                if (itemId) {
                    hasItems = true;
                    itemCount++;
                }
            });
            
            console.log('Total items selected:', itemCount);
            
            if (!hasItems) {
                showToast('Please add at least one item', 'error');
                e.preventDefault();
                return false;
            }
            
            // If validation passes, allow form submission
            console.log('Form validation passed, submitting form...');
            console.log('Form action:', this.action);
            console.log('Form method:', this.method);
            return true;
        });

        function showToast(message, type) {
            const toast = document.getElementById('toast');
            toast.textContent = message;
            toast.className = `toast ${type}`;
            toast.classList.add('show');
            
            setTimeout(() => {
                toast.classList.remove('show');
            }, 3000);
        }
    </script>
</body>
</html>