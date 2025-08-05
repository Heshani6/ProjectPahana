package com.example.pahanaedu3.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.example.pahanaedu3.Models.Bill;
import com.example.pahanaedu3.utils.DatabaseConnection;

// BillDAO abstracts all database operations for Bill entities.
// OOP: Abstraction (DAO pattern), Composition (uses DatabaseConnection), Separation of Concerns
public class BillDAO {
    private DatabaseConnection dbConnection;

    public BillDAO() {
        this.dbConnection = DatabaseConnection.getInstance();
    }

    // Add a new bill
    public int addBill(Bill bill) {
        System.out.println("=== STARTING BILL ADD ===");
        String sql = "INSERT INTO bills (bill_number, customer_id, bill_date, subtotal, tax, total, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        System.out.println("SQL: " + sql);
        System.out.println("Bill data - Number: " + bill.getBillNumber() + ", Customer: " + bill.getCustomerId() + ", Date: " + bill.getBillDate() + ", Subtotal: " + bill.getSubtotal() + ", Tax: " + bill.getTax() + ", Total: " + bill.getTotal() + ", Status: " + bill.getStatus());
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, bill.getBillNumber());
            pstmt.setInt(2, bill.getCustomerId());
            pstmt.setDate(3, new java.sql.Date(bill.getBillDate().getTime()));
            pstmt.setDouble(4, bill.getSubtotal());
            pstmt.setDouble(5, bill.getTax());
            pstmt.setDouble(6, bill.getTotal());
            pstmt.setString(7, bill.getStatus());
            
            System.out.println("About to execute update...");
            int rows = pstmt.executeUpdate();
            System.out.println("Rows affected: " + rows);
            
            if (rows > 0) {
                try (java.sql.ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int generatedId = rs.getInt(1);
                        System.out.println("Generated ID: " + generatedId);
                        System.out.println("=== BILL ADD SUCCESS ===");
                        return generatedId;
                    } else {
                        System.err.println("No generated keys returned");
                        System.out.println("=== BILL ADD FAILED (NO GENERATED KEY) ===");
                        return -1;
                    }
                }
            } else {
                System.err.println("No rows were affected");
                System.out.println("=== BILL ADD FAILED (NO ROWS AFFECTED) ===");
                return -1;
            }
        } catch (SQLException e) {
            System.err.println("Error adding bill: " + e.getMessage());
            e.printStackTrace();
            System.out.println("=== BILL ADD FAILED (SQL EXCEPTION) ===");
            return -1;
        }
    }

    // Get all bills
    public List<Bill> getAllBills() {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT id, bill_number, customer_id, bill_date, subtotal, tax, total, status FROM bills ORDER BY bill_date DESC";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Bill bill = new Bill(
                        rs.getInt("id"),
                        rs.getString("bill_number"),
                        rs.getInt("customer_id"),
                        rs.getDate("bill_date"),
                        rs.getDouble("subtotal"),
                        rs.getDouble("tax"),
                        rs.getDouble("total"),
                        rs.getString("status")
                );
                bills.add(bill);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching bills: " + e.getMessage());
        }
        return bills;
    }

    // Get bill by ID
    public Bill getBillById(int id) {
        String sql = "SELECT id, bill_number, customer_id, bill_date, subtotal, tax, total, status FROM bills WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Bill(
                            rs.getInt("id"),
                            rs.getString("bill_number"),
                            rs.getInt("customer_id"),
                            rs.getDate("bill_date"),
                            rs.getDouble("subtotal"),
                            rs.getDouble("tax"),
                            rs.getDouble("total"),
                            rs.getString("status")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching bill: " + e.getMessage());
        }
        return null;
    }

    // Update bill
    public boolean updateBill(Bill bill) {
        String sql = "UPDATE bills SET bill_number = ?, customer_id = ?, bill_date = ?, subtotal = ?, tax = ?, total = ?, status = ? WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, bill.getBillNumber());
            pstmt.setInt(2, bill.getCustomerId());
            pstmt.setDate(3, new java.sql.Date(bill.getBillDate().getTime()));
            pstmt.setDouble(4, bill.getSubtotal());
            pstmt.setDouble(5, bill.getTax());
            pstmt.setDouble(6, bill.getTotal());
            pstmt.setString(7, bill.getStatus());
            pstmt.setInt(8, bill.getId());
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating bill: " + e.getMessage());
            return false;
        }
    }

    // Delete bill
    public boolean deleteBill(int id) {
        String sql = "DELETE FROM bills WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting bill: " + e.getMessage());
            return false;
        }
    }

    // Get next bill number
    public String getNextBillNumber() {
        String sql = "SELECT MAX(CAST(SUBSTRING(bill_number FROM 5) AS INTEGER)) FROM bills WHERE bill_number LIKE 'BILL%'";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                int maxNumber = rs.getInt(1);
                return String.format("BILL%06d", maxNumber + 1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting next bill number: " + e.getMessage());
        }
        return "BILL000001";
    }

    // Search bills by bill number or customer ID
    public List<Bill> searchBills(String searchQuery) {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT id, bill_number, customer_id, bill_date, subtotal, tax, total, status FROM bills " +
                    "WHERE bill_number ILIKE ? OR customer_id::text ILIKE ? ORDER BY bill_date DESC";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + searchQuery + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Bill bill = new Bill(
                            rs.getInt("id"),
                            rs.getString("bill_number"),
                            rs.getInt("customer_id"),
                            rs.getDate("bill_date"),
                            rs.getDouble("subtotal"),
                            rs.getDouble("tax"),
                            rs.getDouble("total"),
                            rs.getString("status")
                    );
                    bills.add(bill);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching bills: " + e.getMessage());
        }
        return bills;
    }
}