package com.example.pahanaedu3.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.DatabaseMetaData;

public class DatabaseConnection {
    private static DatabaseConnection instance;
    private static final String URL = "jdbc:postgresql://localhost:5432/pahana_edu3";
    private static final String USERNAME = "postgres";
    private static final String PASSWORD = "123456";

    private DatabaseConnection() {
        try {
            Class.forName("org.postgresql.Driver"); // Ensure driver is loaded
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("PostgreSQL JDBC Driver not found", e);
        }
    }

    public static DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    // Test database connection and table existence
    public static void testDatabaseConnection() {
        try {
            Connection conn = DatabaseConnection.getInstance().getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Database connection successful!");
                
                // Check if tables exist
                DatabaseMetaData metaData = conn.getMetaData();
                String[] tables = {"customers", "categories", "items", "bills", "bill_items"};
                
                for (String table : tables) {
                    try (ResultSet rs = metaData.getTables(null, null, table, null)) {
                        if (rs.next()) {
                            System.out.println("✅ Table '" + table + "' exists");
                        } else {
                            System.out.println("❌ Table '" + table + "' does NOT exist");
                        }
                    }
                }
                
                conn.close();
            } else {
                System.out.println("❌ Database connection failed!");
            }
        } catch (Exception e) {
            System.err.println("❌ Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        testDatabaseConnection();
    }
}