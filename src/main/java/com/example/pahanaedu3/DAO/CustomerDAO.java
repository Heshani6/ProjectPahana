package com.example.pahanaedu3.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.example.pahanaedu3.Models.Customer;
import com.example.pahanaedu3.utils.DatabaseConnection;

// CustomerDAO abstracts all database operations for Customer entities.
// OOP: Abstraction (DAO pattern), Composition (uses DatabaseConnection), Separation of Concerns
public class CustomerDAO {
    private DatabaseConnection dbConnection;

    public CustomerDAO() {
        this.dbConnection = DatabaseConnection.getInstance();
    }

    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT id, account_number, name, address, phone FROM customers";
        System.out.println("CustomerDAO: Executing SQL: " + sql);
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            System.out.println("CustomerDAO: SQL executed successfully");
            while (rs.next()) {
                int id = rs.getInt("id");
                String accountNumber = rs.getString("account_number");
                String name = rs.getString("name");
                String address = rs.getString("address");
                String phone = rs.getString("phone");
                
                System.out.println("CustomerDAO: Raw data - ID: " + id + 
                    ", Account: " + accountNumber + 
                    ", Name: " + name + 
                    ", Address: " + address + 
                    ", Phone: " + phone);
                
                Customer customer = new Customer(id, accountNumber, name, address, phone);
                customers.add(customer);
                System.out.println("CustomerDAO: Added customer - ID: " + customer.getId() + ", Name: " + customer.getName());
            }
            System.out.println("CustomerDAO: Total customers fetched: " + customers.size());
        } catch (SQLException e) {
            System.err.println("Error fetching customers: " + e.getMessage());
            e.printStackTrace();
        }
        return customers;
    }

    public Customer getCustomerById(int id) {
        String sql = "SELECT id, account_number, name, address, phone FROM customers WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getInt("id"),
                            rs.getString("account_number"),
                            rs.getString("name"),
                            rs.getString("address"),
                            rs.getString("phone")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching customer: " + e.getMessage());
        }
        return null;
    }

    public boolean addCustomer(Customer customer) {
        String sql = "INSERT INTO customers (account_number, name, address, phone) VALUES (?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, customer.getAccountNumber());
            pstmt.setString(2, customer.getName());
            pstmt.setString(3, customer.getAddress());
            pstmt.setString(4, customer.getPhone());
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error adding customer: " + e.getMessage());
            return false;
        }
    }

    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE customers SET account_number = ?, name = ?, address = ?, phone = ? WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, customer.getAccountNumber());
            pstmt.setString(2, customer.getName());
            pstmt.setString(3, customer.getAddress());
            pstmt.setString(4, customer.getPhone());
            pstmt.setInt(5, customer.getId());
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating customer: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteCustomer(int id) {
        String sql = "DELETE FROM customers WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting customer: " + e.getMessage());
            return false;
        }
    }

    public Customer getCustomerByAccountNumber(String accountNumber) {
        String sql = "SELECT id, account_number, name, address, phone FROM customers WHERE account_number = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, accountNumber);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getInt("id"),
                            rs.getString("account_number"),
                            rs.getString("name"),
                            rs.getString("address"),
                            rs.getString("phone")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching customer by account number: " + e.getMessage());
        }
        return null;
    }

    public boolean accountNumberExists(String accountNumber) {
        String sql = "SELECT COUNT(*) FROM customers WHERE TRIM(LOWER(account_number)) = LOWER(TRIM(?))";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, accountNumber);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking account number: " + e.getMessage());
        }
        return false;
    }


    public List<Customer> searchCustomersByAccountNumber(String accountNumber) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT id, account_number, name, address, phone FROM customers WHERE account_number LIKE ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + accountNumber + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Customer customer = new Customer(
                            rs.getInt("id"),
                            rs.getString("account_number"),
                            rs.getString("name"),
                            rs.getString("address"),
                            rs.getString("phone")
                    );
                    customers.add(customer);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching customers: " + e.getMessage());
        }
        return customers;
    }

    public int getCustomerCount() {
        String sql = "SELECT COUNT(*) FROM customers";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting customer count: " + e.getMessage());
        }
        return 0;
    }
}