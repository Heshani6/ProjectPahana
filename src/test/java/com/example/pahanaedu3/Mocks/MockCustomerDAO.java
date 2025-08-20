package com.example.pahanaedu3.Mocks;

import com.example.pahanaedu3.DAO.CustomerDAO;
import com.example.pahanaedu3.Models.Customer;

import java.util.ArrayList;
import java.util.List;

public class MockCustomerDAO extends CustomerDAO {
    private final List<Customer> customers = new ArrayList<>();

    public MockCustomerDAO() {
        customers.add(new Customer(1, "ACC01", "John Doe", "123 Main St", "1234567890"));
        customers.add(new Customer(2, "ACC02", "Jane Smith", "456 Elm St", "0987654321"));
    }

    @Override
    public boolean addCustomer(Customer customer) {
        if (accountNumberExists(customer.getAccountNumber())) {
            return false;
        }
        customer.setId(customers.size() + 1);
        return customers.add(customer);
    }

    @Override
    public Customer getCustomerById(int id) {
        return customers.stream()
                .filter(c -> c.getId() == id)
                .findFirst()
                .orElse(null);
    }

    @Override
    public boolean updateCustomer(Customer customer) {
        Customer existing = getCustomerById(customer.getId());
        if (existing != null) {
            existing.setAccountNumber(customer.getAccountNumber());
            existing.setName(customer.getName());
            existing.setAddress(customer.getAddress());
            existing.setPhone(customer.getPhone());
            return true;
        }
        return false;
    }

    @Override
    public boolean deleteCustomer(int id) {
        return customers.removeIf(c -> c.getId() == id);
    }

    @Override
    public Customer getCustomerByAccountNumber(String accountNumber) {
        return customers.stream()
                .filter(c -> c.getAccountNumber().equalsIgnoreCase(accountNumber))
                .findFirst()
                .orElse(null);
    }

    @Override
    public boolean accountNumberExists(String accountNumber) {
        return customers.stream()
                .anyMatch(c -> c.getAccountNumber().equalsIgnoreCase(accountNumber));
    }

    @Override
    public List<Customer> searchCustomersByAccountNumber(String accountNumber) {
        List<Customer> result = new ArrayList<>();
        for (Customer c : customers) {
            if (c.getAccountNumber().contains(accountNumber)) {
                result.add(c);
            }
        }
        return result;
    }

    @Override
    public int getCustomerCount() {
        return customers.size();
    }
}
