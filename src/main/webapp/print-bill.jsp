<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.pahanaedu3.Models.Bill" %>
<%@ page import="com.example.pahanaedu3.Models.BillItem" %>
<%@ page import="com.example.pahanaedu3.Models.Customer" %>
<%@ page import="com.example.pahanaedu3.Models.Item" %>
<%@ page import="com.example.pahanaedu3.Services.ItemService" %>
<%
    Bill bill = (Bill) request.getAttribute("bill");
    Customer customer = (Customer) request.getAttribute("customer");
    List<BillItem> billItems = (List<BillItem>) request.getAttribute("billItems");
    ItemService itemService = (ItemService) request.getAttribute("itemService");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill - <%= bill.getBillNumber() %></title>
    <style>
        @media print {
            body { margin: 0; }
            .no-print { display: none !important; }
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: white;
            color: #333;
            line-height: 1.4;
            padding: 20px;
        }

        .bill-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border: 1px solid #ccc;
            padding: 30px;
        }

        /* Company Header */
        .company-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #333;
            padding-bottom: 20px;
        }

        .company-name {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .company-details {
            font-size: 14px;
            color: #666;
        }

        .company-details p {
            margin: 5px 0;
        }

        /* Bill Info */
        .bill-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            font-size: 14px;
        }

        .bill-number {
            font-weight: bold;
        }

        .bill-date {
            color: #666;
        }

        /* Customer Info */
        .customer-info {
            margin-bottom: 30px;
            font-size: 14px;
        }

        .customer-info h3 {
            margin-bottom: 10px;
            font-size: 16px;
        }

        .customer-info p {
            margin: 5px 0;
        }

        /* Items Table */
        .items-section {
            margin-bottom: 30px;
        }

        .items-section h3 {
            margin-bottom: 15px;
            font-size: 16px;
            border-bottom: 1px solid #ccc;
            padding-bottom: 5px;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .items-table th {
            background: #f5f5f5;
            padding: 10px;
            text-align: left;
            border-bottom: 2px solid #333;
            font-weight: bold;
        }

        .items-table td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }

        .item-name {
            font-weight: bold;
        }

        .item-quantity {
            text-align: center;
        }

        .item-price {
            text-align: right;
        }

        .item-total {
            text-align: right;
            font-weight: bold;
        }

        /* Totals */
        .totals-section {
            margin-top: 20px;
            border-top: 2px solid #333;
            padding-top: 20px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .total-row.final {
            font-size: 18px;
            font-weight: bold;
            border-top: 1px solid #ccc;
            padding-top: 10px;
            margin-top: 15px;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }

        /* Action Buttons */
        .action-buttons {
            margin-top: 30px;
            text-align: center;
        }

        .btn {
            padding: 10px 20px;
            margin: 0 10px;
            border: 1px solid #333;
            background: white;
            color: #333;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
        }

        .btn:hover {
            background: #333;
            color: white;
        }
    </style>
</head>
<body>
    <div class="bill-container">
        <!-- Company Header -->
        <div class="company-header">
            <div class="company-name">Pahana EduBill</div>
            <div class="company-details">
                <p>123 Business Street, Colombo</p>
                <p>Phone: +94 11 234 5678</p>
                <p>Email: billing@pahanaedubill.com</p>
            </div>
        </div>

        <!-- Bill Info -->
        <div class="bill-info">
            <div class="bill-number">Bill #: <%= bill.getBillNumber() %></div>
            <div class="bill-date">Date: <%= bill.getBillDate() %></div>
        </div>

        <!-- Customer Info -->
        <div class="customer-info">
            <h3>Bill To:</h3>
            <p><strong>Name:</strong> <%= customer.getName() %></p>
            <p><strong>Account:</strong> <%= customer.getAccountNumber() %></p>
            <p><strong>Phone:</strong> <%= customer.getPhone() %></p>
            <p><strong>Address:</strong> <%= customer.getAddress() %></p>
        </div>

        <!-- Items -->
        <div class="items-section">
            <h3>Items:</h3>
            
            <% if (billItems != null && !billItems.isEmpty()) { %>
                <table class="items-table">
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th style="text-align: center;">Quantity</th>
                            <th style="text-align: right;">Unit Price</th>
                            <th style="text-align: right;">Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (BillItem item : billItems) { %>
                            <%
                                Item itemDetails = null;
                                if (itemService != null) {
                                    itemDetails = itemService.getItemById(item.getItemId());
                                }
                                String itemName = itemDetails != null ? itemDetails.getName() : "Item ID: " + item.getItemId();
                            %>
                            <tr>
                                <td class="item-name"><%= itemName %></td>
                                <td class="item-quantity"><%= item.getQuantity() %></td>
                                <td class="item-price">Rs <%= String.format("%.2f", item.getUnitPrice()) %></td>
                                <td class="item-total">Rs <%= String.format("%.2f", item.getTotal()) %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    No items found in this bill.
                </div>
            <% } %>
        </div>

        <!-- Totals -->
        <div class="totals-section">
            <div class="total-row">
                <span>Subtotal:</span>
                <span>Rs <%= String.format("%.2f", bill.getSubtotal()) %></span>
            </div>
            <div class="total-row">
                <span>Tax (5%):</span>
                <span>Rs <%= String.format("%.2f", bill.getTax()) %></span>
            </div>
            <div class="total-row final">
                <span>Total Amount:</span>
                <span>Rs <%= String.format("%.2f", bill.getTotal()) %></span>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons no-print">
            <button class="btn" onclick="window.print()">Print Bill</button>
            <% if ("unpaid".equals(bill.getStatus())) { %>
            <a href="payment?billId=<%= bill.getId() %>" class="btn" style="background: #28a745; color: white;">Pay Bill</a>
            <% } %>
            <a href="bill" class="btn">Back to Bills</a>
        </div>
    </div>
</body>
</html> 