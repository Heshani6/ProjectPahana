package com.example.pahanaedu3.Models;

// The Item class represents an item/product in the system.
// OOP: Encapsulation (private fields, public getters/setters), Abstraction (model abstraction)
public class Item {
    private int id;
    private String name;
    private int categoryId;
    private String categoryName; // For display purposes
    private double price;
    private int quantity;

    // Default constructor
    public Item(int i, String newItem, double v) {}

    // Constructor with all fields
    public Item(int id, String name, int categoryId, String categoryName, double price, int quantity) {
        this.id = id;
        this.name = name;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.price = price;
        this.quantity = quantity;
    }

    // Constructor without id (for creation)
    public Item(String name, int categoryId, double price, int quantity) {
        this.name = name;
        this.categoryId = categoryId;
        this.price = price;
        this.quantity = quantity;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    // toString method for debugging (Polymorphism)
    @Override
    public String toString() {
        return "Item{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", categoryId=" + categoryId +
                ", categoryName='" + categoryName + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                '}';
    }
} 