package com.example.pahanaedu3.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.example.pahanaedu3.Models.BillItem;
import com.example.pahanaedu3.utils.DatabaseConnection;

// BillItemDAO abstracts all database operations for BillItem entities.
// OOP: Abstraction (DAO pattern), Composition (uses DatabaseConnection), Separation of Concerns
public class BillItemDAO {
    private DatabaseConnection dbConnection;

    public BillItemDAO() {
        this.dbConnection = DatabaseConnection.getInstance();
    }

    // Add a new bill item
    public boolean addBillItem(BillItem billItem) {
        String sql = "INSERT INTO bill_items (bill_id, item_id, quantity, unit_price, total) VALUES (?, ?, ?, ?, ?)";
        System.out.println("BillItemDAO: Adding bill item - Bill ID: " + billItem.getBillId() + ", Item ID: " + billItem.getItemId() + ", Quantity: " + billItem.getQuantity() + ", Unit Price: " + billItem.getUnitPrice() + ", Total: " + billItem.getTotal());
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, billItem.getBillId());
            pstmt.setInt(2, billItem.getItemId());
            pstmt.setInt(3, billItem.getQuantity());
            pstmt.setDouble(4, billItem.getUnitPrice());
            pstmt.setDouble(5, billItem.getTotal());
            int rows = pstmt.executeUpdate();
            System.out.println("BillItemDAO: Insert result - Rows affected: " + rows);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error adding bill item: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Get bill items by bill ID
    public List<BillItem> getBillItemsByBillId(int billId) {
        List<BillItem> billItems = new ArrayList<>();
        String sql = "SELECT id, bill_id, item_id, quantity, unit_price, total FROM bill_items WHERE bill_id = ?";
        System.out.println("BillItemDAO: Executing query for bill ID: " + billId);
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, billId);
            try (ResultSet rs = pstmt.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    count++;
                    BillItem billItem = new BillItem(
                            rs.getInt("id"),
                            rs.getInt("bill_id"),
                            rs.getInt("item_id"),
                            rs.getInt("quantity"),
                            rs.getDouble("unit_price"),
                            rs.getDouble("total")
                    );
                    billItems.add(billItem);
                    System.out.println("BillItemDAO: Found bill item - ID: " + billItem.getId() + ", Item ID: " + billItem.getItemId() + ", Quantity: " + billItem.getQuantity());
                }
                System.out.println("BillItemDAO: Total bill items found: " + count);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching bill items: " + e.getMessage());
            e.printStackTrace();
        }
        return billItems;
    }

    // Delete bill items by bill ID
    public boolean deleteBillItemsByBillId(int billId) {
        String sql = "DELETE FROM bill_items WHERE bill_id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, billId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting bill items: " + e.getMessage());
            return false;
        }
    }
}