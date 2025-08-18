package com.example.pahanaedu3.Servlets;

import java.io.IOException;
import java.util.List;

import com.example.pahanaedu3.Models.Customer;
import com.example.pahanaedu3.Services.CustomerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/customer")
public class CustomerServlet extends HttpServlet {
    private CustomerService customerService;

    @Override
    public void init() throws ServletException {
        customerService = new CustomerService();
    }

    // Handles GET requests: list all customers or show a single customer for editing
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Customer customer = customerService.getCustomerById(id);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("edit-customer.jsp").forward(request, response);
        } else {
            // Handle search parameter - same pattern as UserServlet
            String search = request.getParameter("search");
            List<Customer> customers;
            if (search != null && !search.trim().isEmpty()) {
                customers = customerService.searchCustomersByAccountNumber(search.trim());
            } else {
                customers = customerService.getAllCustomers();
            }
            request.setAttribute("customers", customers);

            // Get user role from session for role-based access control
            jakarta.servlet.http.HttpSession session = request.getSession(false);
            String userRole = "staff"; // Default to staff role for security
            if (session != null && session.getAttribute("role") != null) {
                userRole = (String) session.getAttribute("role");
            }
            request.setAttribute("userRole", userRole);

            // Check for success message from URL parameter (from add customer)
            String msg = request.getParameter("msg");
            if (msg != null) {
                request.setAttribute("msg", msg);
            }

            // Pass search term to JSP for input field persistence
            request.setAttribute("searchTerm", search);

            request.getRequestDispatcher("customer-management.jsp").forward(request, response);
        }
    }

    // Handles POST requests: update or delete customer
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // Get user role from session for role-based access control
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        String userRole = "staff"; // Default to staff role for security
        if (session != null && session.getAttribute("role") != null) {
            userRole = (String) session.getAttribute("role");
        }

        if ("update".equals(action)) {
            // Both admin and staff can update customers
            int id = Integer.parseInt(request.getParameter("id"));
            String accountNumber = request.getParameter("accountNumber");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");

            Customer customer = new Customer(id, accountNumber, name, address, phone);
            boolean success = customerService.updateCustomer(customer);

            String msg = success ? "Customer updated successfully!" : "Failed to update customer.";
            response.sendRedirect("customer?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));

        } else if ("delete".equals(action)) {
            System.out.println("DEBUG: Delete action triggered");
            System.out.println("DEBUG: User role: " + userRole);

            // Only admin can delete customers
            if (!"admin".equalsIgnoreCase(userRole)) {
                System.out.println("DEBUG: Access denied - user is not admin");
                String errorMsg = "Access denied. Only administrators can delete customers.";
                response.sendRedirect("customer?msg=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
                return;
            }

            int id = Integer.parseInt(request.getParameter("id"));
            System.out.println("DEBUG: Attempting to delete customer with ID: " + id);
            boolean success = customerService.deleteCustomer(id);
            System.out.println("DEBUG: Delete result: " + success);

            String msg = success ? "Customer deleted successfully!" : "Failed to delete customer.";
            response.sendRedirect("customer?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));

        } else {
            // Unknown action, redirect to list
            response.sendRedirect("customer-management.jsp");
        }
    }
}