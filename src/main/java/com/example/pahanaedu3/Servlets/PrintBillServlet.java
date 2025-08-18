package com.example.pahanaedu3.Servlets;

import java.io.IOException;
import java.util.List;

import com.example.pahanaedu3.Models.Bill;
import com.example.pahanaedu3.Models.BillItem;
import com.example.pahanaedu3.Models.Customer;
import com.example.pahanaedu3.Models.Item;
import com.example.pahanaedu3.Services.BillService;
import com.example.pahanaedu3.Services.CustomerService;
import com.example.pahanaedu3.Services.ItemService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// PrintBillServlet handles bill printing functionality.
// OOP: Inheritance (extends HttpServlet), Composition (uses Services), Separation of Concerns
@WebServlet("/print-bill")
public class PrintBillServlet extends HttpServlet {
    private BillService billService;
    private CustomerService customerService;
    private ItemService itemService;

    @Override
    public void init() throws ServletException {
        billService = new BillService();
        customerService = new CustomerService();
        itemService = new ItemService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String billIdStr = request.getParameter("id");
        
        if (billIdStr == null || billIdStr.trim().isEmpty()) {
            response.sendRedirect("bill?msg=" + java.net.URLEncoder.encode("Bill ID is required", "UTF-8"));
            return;
        }
        
        try {
            int billId = Integer.parseInt(billIdStr);
            
            // Get bill details
            Bill bill = billService.getBillById(billId);
            if (bill == null) {
                response.sendRedirect("bill?msg=" + java.net.URLEncoder.encode("Bill not found", "UTF-8"));
                return;
            }
            
            // Get customer details
            Customer customer = customerService.getCustomerById(bill.getCustomerId());
            
            // Get bill items
            List<BillItem> billItems = billService.getBillItems(billId);
            System.out.println("PrintBillServlet: Retrieved " + (billItems != null ? billItems.size() : 0) + " bill items for bill ID: " + billId);
            
            // Debug: Check if bill items exist in database
            if (billItems == null || billItems.isEmpty()) {
                System.out.println("PrintBillServlet: WARNING - No bill items found for bill ID: " + billId);
                System.out.println("PrintBillServlet: This might indicate:");
                System.out.println("1. Bill items were not saved during bill creation");
                System.out.println("2. Database connection issue");
                System.out.println("3. Bill items were deleted");
                
                // Additional debugging - check if bill exists
                Bill retrievedBill = billService.getBillById(billId);
                if (retrievedBill != null) {
                    System.out.println("PrintBillServlet: Bill exists with ID: " + retrievedBill.getId());
                    System.out.println("PrintBillServlet: Bill customer ID: " + retrievedBill.getCustomerId());
                    System.out.println("PrintBillServlet: Bill total: " + retrievedBill.getTotal());
                } else {
                    System.out.println("PrintBillServlet: ERROR - Bill not found in database!");
                }
            }
            
            // Get item details for each bill item
            if (billItems != null && !billItems.isEmpty()) {
                for (BillItem item : billItems) {
                    Item itemDetails = itemService.getItemById(item.getItemId());
                    if (itemDetails != null) {
                        System.out.println("PrintBillServlet: Bill Item - ID: " + item.getId() + ", Item: " + itemDetails.getName() + ", Quantity: " + item.getQuantity() + ", Unit Price: " + item.getUnitPrice() + ", Total: " + item.getTotal());
                    } else {
                        System.out.println("PrintBillServlet: Bill Item - ID: " + item.getId() + ", Item ID: " + item.getItemId() + " (Item not found), Quantity: " + item.getQuantity() + ", Unit Price: " + item.getUnitPrice() + ", Total: " + item.getTotal());
                    }
                }
            } else {
                System.out.println("PrintBillServlet: No bill items found for bill ID: " + billId);
            }
            
            // Set attributes for the JSP
            request.setAttribute("bill", bill);
            request.setAttribute("customer", customer);
            request.setAttribute("billItems", billItems);
            request.setAttribute("itemService", itemService);
            
            // Forward to print bill page
            request.getRequestDispatcher("/print-bill.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("bill?msg=" + java.net.URLEncoder.encode("Invalid bill ID", "UTF-8"));
        }
    }
} 