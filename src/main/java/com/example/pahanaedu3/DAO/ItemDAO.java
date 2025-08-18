package com.example.pahanaedu3.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.example.pahanaedu3.Models.Item;
import com.example.pahanaedu3.utils.DatabaseConnection;

// ItemDAO handles all database operations for Item entities.
// OOP: Abstraction (hides DB details), Composition (uses DatabaseConnection), Separation of Concerns (DAO pattern)
public class ItemDAO {
    private DatabaseConnection dbConnection;

    public ItemDAO() {
        this.dbConnection = DatabaseConnection.getInstance();
    }

    // Create: Add a new item
    public boolean addItem(Item item) {
        String sql = "INSERT INTO items (name, category_id, price, quantity) VALUES (?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, item.getName());
            stmt.setInt(2, item.getCategoryId());
            stmt.setDouble(3, item.getPrice());
            stmt.setInt(4, item.getQuantity());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Read: Get all items (with category name)
    public List<Item> getAllItems() {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT i.id, i.name, i.category_id, c.name AS category_name, i.price, i.quantity " +
                "FROM items i JOIN categories c ON i.category_id = c.id ORDER BY i.id";
        try (Connection conn = dbConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Item item = new Item(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("category_id"),
                        rs.getString("category_name"),
                        rs.getDouble("price"),
                        rs.getInt("quantity")
                );
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    // Update: Update an item
    public boolean updateItem(Item item) {
        String sql = "UPDATE items SET name = ?, category_id = ?, price = ?, quantity = ? WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, item.getName());
            stmt.setInt(2, item.getCategoryId());
            stmt.setDouble(3, item.getPrice());
            stmt.setInt(4, item.getQuantity());
            stmt.setInt(5, item.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete: Remove an item by id
    public boolean deleteItem(int id) {
        String sql = "DELETE FROM items WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Search: Find items by name (case-insensitive)
    public List<Item> searchItemsByName(String name) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT i.id, i.name, i.category_id, c.name AS category_name, i.price, i.quantity " +
                "FROM items i JOIN categories c ON i.category_id = c.id WHERE LOWER(i.name) LIKE ? ORDER BY i.id";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + name.toLowerCase() + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getInt("category_id"),
                            rs.getString("category_name"),
                            rs.getDouble("price"),
                            rs.getInt("quantity")
                    );
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public int getItemCount() {
        String sql = "SELECT COUNT(*) FROM items";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting item count: " + e.getMessage());
        }
        return 0;
    }

    // Optional: Get item by id
    public Item getItemById(int id) {
        String sql = "SELECT i.id, i.name, i.category_id, c.name AS category_name, i.price, i.quantity " +
                "FROM items i JOIN categories c ON i.category_id = c.id WHERE i.id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Item(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getInt("category_id"),
                            rs.getString("category_name"),
                            rs.getDouble("price"),
                            rs.getInt("quantity")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


}
