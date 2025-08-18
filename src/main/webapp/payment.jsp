<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.pahanaedu3.Models.Bill" %>
<%@ page import="com.example.pahanaedu3.Models.BillItem" %>
<%@ page import="java.util.List" %>
<%
  Bill bill = (Bill) request.getAttribute("bill");
  Boolean canPay = (Boolean) request.getAttribute("canPay");
  List<BillItem> billItems = null;
  if (bill != null) {
    // Get bill items from service
    com.example.pahanaedu3.Services.BillService billService = new com.example.pahanaedu3.Services.BillService();
    billItems = billService.getBillItems(bill.getId());
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Payment - Pahana EduBill</title>
  <style>
    body {
      background: #f7f7f7;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      margin: 0;
      padding: 20px;
    }
    .container {
      max-width: 800px;
      margin: 0 auto;
      background: #fff;
      border-radius: 12px;
      box-shadow: 0 4px 24px rgba(108,99,255,0.08);
      padding: 2rem;
    }
    .header {
      text-align: center;
      margin-bottom: 2rem;
    }
    .bill-info {
      background: #f8f9fa;
      padding: 1.5rem;
      border-radius: 8px;
      margin-bottom: 2rem;
    }
    .bill-details {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1rem;
      margin-bottom: 1rem;
    }
    .items-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 2rem;
    }
    .items-table th, .items-table td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid #e1e5e9;
    }
    .items-table th {
      background: #f8f9fa;
      font-weight: 600;
    }
    .payment-form {
      background: #f8f9fa;
      padding: 1.5rem;
      border-radius: 8px;
      margin-bottom: 2rem;
    }
    .form-group {
      margin-bottom: 1rem;
    }
    label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 600;
    }
    select, input {
      width: 100%;
      padding: 0.8rem;
      border: 1px solid #ccc;
      border-radius: 6px;
      font-size: 1rem;
    }
    .btn {
      padding: 12px 24px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 1rem;
      font-weight: 600;
      margin-right: 10px;
    }
    .btn-primary {
      background: #6c63ff;
      color: white;
    }
    .btn-secondary {
      background: #6c757d;
      color: white;
    }
    .status-paid {
      color: #28a745;
      font-weight: 600;
    }
    .status-unpaid {
      color: #dc3545;
      font-weight: 600;
    }
    .error {
      color: #dc3545;
      background: #f8d7da;
      padding: 1rem;
      border-radius: 6px;
      margin-bottom: 1rem;
    }
    .success {
      color: #155724;
      background: #d4edda;
      padding: 1rem;
      border-radius: 6px;
      margin-bottom: 1rem;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>Payment Processing</h1>
    </div>

    <% if (request.getParameter("error") != null) { %>
    <div class="error">
      <%= request.getParameter("error") %>
    </div>
    <% } %>

    <% if (bill != null) { %>
    <div class="bill-info">
      <h2>Bill Details</h2>
      <div class="bill-details">
        <div>
          <strong>Bill Number:</strong> <%= bill.getBillNumber() %><br>
          <strong>Date:</strong> <%= bill.getBillDate() %><br>
          <strong>Status:</strong> 
          <span class="<%= "paid".equals(bill.getStatus()) ? "status-paid" : "status-unpaid" %>">
            <%= bill.getStatus().toUpperCase() %>
          </span>
        </div>
        <div>
          <strong>Subtotal:</strong> Rs <%= String.format("%.2f", bill.getSubtotal()) %><br>
          <strong>Tax (5%):</strong> Rs <%= String.format("%.2f", bill.getTax()) %><br>
          <strong>Total:</strong> Rs <%= String.format("%.2f", bill.getTotal()) %>
        </div>
      </div>
    </div>

    <% if (billItems != null && !billItems.isEmpty()) { %>
    <table class="items-table">
      <thead>
        <tr>
          <th>Item</th>
          <th>Quantity</th>
          <th>Unit Price</th>
          <th>Total</th>
        </tr>
      </thead>
      <tbody>
        <% for (BillItem item : billItems) { %>
        <tr>
          <td>Item ID: <%= item.getItemId() %></td>
          <td><%= item.getQuantity() %></td>
          <td>Rs <%= String.format("%.2f", item.getUnitPrice()) %></td>
          <td>Rs <%= String.format("%.2f", item.getTotal()) %></td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <% } %>

    <% if ("unpaid".equals(bill.getStatus())) { %>
    <div class="payment-form">
      <h3>Process Payment</h3>
      <% if (canPay != null && canPay) { %>
      <form action="payment" method="post">
        <input type="hidden" name="action" value="process">
        <input type="hidden" name="billId" value="<%= bill.getId() %>">
        
        <div class="form-group">
          <label for="paymentMethod">Payment Method:</label>
          <select id="paymentMethod" name="paymentMethod" required>
            <option value="">Select Payment Method</option>
            <option value="cash">Cash</option>
            <option value="card">Credit/Debit Card</option>
            <option value="online">Online Payment</option>
          </select>
        </div>
        
        <div class="form-group">
          <label for="paymentReference">Payment Reference (Optional):</label>
          <input type="text" id="paymentReference" name="paymentReference" placeholder="Transaction ID, Receipt Number, etc.">
        </div>
        
        <button type="submit" class="btn btn-primary">Process Payment</button>
        <a href="bill" class="btn btn-secondary">Back to Bills</a>
      </form>
      <% } else { %>
      <div class="error">
        Cannot process payment: Insufficient stock for some items in this bill.
      </div>
      <a href="bill" class="btn btn-secondary">Back to Bills</a>
      <% } %>
    </div>
    <% } else { %>
    <div class="success">
      <h3>Payment Completed</h3>
      <p><strong>Payment Method:</strong> <%= bill.getPaymentMethod() %></p>
      <p><strong>Payment Date:</strong> <%= bill.getPaymentDate() %></p>
      <% if (bill.getPaymentReference() != null && !bill.getPaymentReference().isEmpty()) { %>
      <p><strong>Reference:</strong> <%= bill.getPaymentReference() %></p>
      <% } %>
      <p><em>Inventory has been updated automatically.</em></p>
    </div>
    <a href="bill" class="btn btn-secondary">Back to Bills</a>
    <% } %>

    <% } else { %>
    <div class="error">
      Bill not found or invalid bill ID.
    </div>
    <a href="bill" class="btn btn-secondary">Back to Bills</a>
    <% } %>
  </div>
</body>
</html> 