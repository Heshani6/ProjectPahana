package com.example.pahanaedu3.Servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.example.pahanaedu3.Models.Bill;
import com.example.pahanaedu3.Models.BillItem;
import com.example.pahanaedu3.Services.BillService;
import com.example.pahanaedu3.Services.CustomerService;
import com.example.pahanaedu3.Services.ItemService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// CreateBillServlet handles bill creation.
// OOP: Inheritance (extends HttpServlet), Composition (uses Services), Separation of Concerns
@WebServlet("/create-bill")
public class CreateBillServlet extends HttpServlet {
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
        // Load customers and items for dropdowns
        request.setAttribute("customers", customerService.getAllCustomers());
        request.setAttribute("items", itemService.getAllItems());
        request.getRequestDispatcher("/create-bill.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== CREATE BILL SERVLET POST METHOD CALLED ===");
        try {
            // Get form data
            System.out.println("Getting form parameters...");
            String customerIdStr = request.getParameter("customerId");
            System.out.println("Customer ID parameter: " + customerIdStr);
            
            if (customerIdStr == null || customerIdStr.trim().isEmpty()) {
                System.err.println("Customer ID is null or empty");
                request.setAttribute("error", "Please select a customer.");
                request.setAttribute("customers", customerService.getAllCustomers());
                request.setAttribute("items", itemService.getAllItems());
                request.getRequestDispatcher("/create-bill.jsp").forward(request, response);
                return;
            }
            
            int customerId = Integer.parseInt(customerIdStr);
            System.out.println("Parsed customer ID: " + customerId);
            
            String[] itemIds = request.getParameterValues("itemId");
            String[] quantities = request.getParameterValues("quantity");
            String[] unitPrices = request.getParameterValues("unitPrice");
            
            System.out.println("Item IDs: " + (itemIds != null ? java.util.Arrays.toString(itemIds) : "null"));
            System.out.println("Quantities: " + (quantities != null ? java.util.Arrays.toString(quantities) : "null"));
            System.out.println("Unit Prices: " + (unitPrices != null ? java.util.Arrays.toString(unitPrices) : "null"));
            
            // Debug: Check if any items were selected
            if (itemIds == null || itemIds.length == 0) {
                System.out.println("ERROR: No item IDs received from form!");
                System.out.println("This means no items were selected when creating the bill.");
            } else {
                System.out.println("Received " + itemIds.length + " item IDs from form");
                for (int i = 0; i < itemIds.length; i++) {
                    System.out.println("Item " + i + ": ID=" + itemIds[i] + ", Qty=" + quantities[i] + ", Price=" + unitPrices[i]);
                }
            }

            // Create bill
            System.out.println("Creating Bill object...");
            Bill bill = new Bill();
            bill.setCustomerId(customerId);
            bill.setStatus("unpaid");
            System.out.println("Bill object created with customer ID: " + customerId + ", status: unpaid");

            // Create bill items
            System.out.println("Creating bill items...");
            List<BillItem> billItems = new ArrayList<>();
            if (itemIds != null) {
                for (int i = 0; i < itemIds.length; i++) {
                    if (itemIds[i] != null && !itemIds[i].trim().isEmpty()) {
                        System.out.println("Processing item " + i + ": ID=" + itemIds[i] + ", Qty=" + quantities[i] + ", Price=" + unitPrices[i]);
                        BillItem item = new BillItem();
                        item.setItemId(Integer.parseInt(itemIds[i]));
                        item.setQuantity(Integer.parseInt(quantities[i]));
                        item.setUnitPrice(Double.parseDouble(unitPrices[i]));
                        billItems.add(item);
                        System.out.println("Added bill item: " + item);
                    }
                }
            }
            System.out.println("Created " + billItems.size() + " bill items");

            // Save bill
            System.out.println("About to call billService.createBill()...");
            boolean success = billService.createBill(bill, billItems);
            System.out.println("Bill creation result: " + success);

            if (success) {
                // Redirect to bill management with success message
                System.out.println("Redirecting to bill management with success message");
                response.sendRedirect("bill?msg=" + java.net.URLEncoder.encode("Bill created successfully!", "UTF-8"));
                return;
            } else {
                response.sendRedirect("bill");
            }

        } catch (Exception e) {
            request.setAttribute("error", "Error creating bill: " + e.getMessage());
        }

        // Reload form data for error cases
        request.setAttribute("customers", customerService.getAllCustomers());
        request.setAttribute("items", itemService.getAllItems());
        request.getRequestDispatcher("/create-bill.jsp").forward(request, response);
    }
}