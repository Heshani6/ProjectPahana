package com.example.pahanaedu3.Servlets;

import java.io.IOException;

import com.example.pahanaedu3.Models.Customer;
import com.example.pahanaedu3.Services.CustomerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/add-customer")
public class AddCustomerServlet extends HttpServlet {
    private CustomerService customerService;

    @Override
    public void init() throws ServletException {
        customerService = new CustomerService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accountNumber = request.getParameter("accountNumber");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        Customer customer = new Customer();
        customer.setAccountNumber(accountNumber);
        customer.setName(name);
        customer.setAddress(address);
        customer.setPhone(phone);

        boolean success = customerService.addCustomer(customer);
        if (success) {
            request.setAttribute("success", "Customer added successfully!");
        } else {
            request.setAttribute("error", "Failed to add customer. Please check the details and try again.");
        }
        // Forward back to the add-customer.jsp (fields will be empty)
        request.getRequestDispatcher("add-customer.jsp").forward(request, response);
    }
}
