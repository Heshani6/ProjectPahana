package com.example.pahanaedu3.Services;

import java.util.List;

import com.example.pahanaedu3.DAO.CustomerDAO;
import com.example.pahanaedu3.Models.Customer;

// CustomerService provides business logic for Customer operations.
// OOP: Abstraction (service layer), Composition (uses CustomerDAO), Separation of Concerns
public class CustomerService {
    private CustomerDAO customerDAO;

    public CustomerService() {
        this.customerDAO = new CustomerDAO();
    }
    // Add a customer
    public boolean addCustomer(Customer customer) {
        if (customer == null || customer.getAccountNumber() == null || customer.getAccountNumber().trim().isEmpty()) {
            return false;
        }
        return customerDAO.addCustomer(customer);
    }

    // Get a customer by ID
    public Customer getCustomerById(int id) {
        return customerDAO.getCustomerById(id);
    }

    // Get all customers
    public List<Customer> getAllCustomers() {
        return customerDAO.getAllCustomers();
    }

    public boolean updateCustomer(Customer customer) {
        Customer existing = customerDAO.getCustomerById(customer.getId());
        if (existing == null) return false;

        // If any field is null in the input, keep the old value
        if (customer.getPhone() == null) customer.setPhone(existing.getPhone());

        return customerDAO.updateCustomer(customer);
    }


    // Delete a customer
    public boolean deleteCustomer(int id) {
        return customerDAO.deleteCustomer(id);
    }

    // Search for a customer by account number
    public Customer getCustomerByAccountNumber(String accountNumber) {
        if (accountNumber == null || accountNumber.trim().isEmpty()) {
            return null;
        }
        return customerDAO.getCustomerByAccountNumber(accountNumber);
    }

    // Check if an account number already exists
    public boolean accountNumberExists(String accountNumber) {
        if (accountNumber == null || accountNumber.trim().isEmpty()) {
            return false;
        }
        return customerDAO.accountNumberExists(accountNumber);
    }
}