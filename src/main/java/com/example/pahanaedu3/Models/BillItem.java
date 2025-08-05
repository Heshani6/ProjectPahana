package com.example.pahanaedu3.Models;

// BillItem class represents a line item in a bill.
// OOP: Encapsulation (private fields, public getters/setters), Abstraction (model abstraction)
public class BillItem {
    // Encapsulation: Private fields, only accessible via getters/setters
    private int id;
    private int billId;
    private int itemId;
    private int quantity;
    private double unitPrice;
    private double total;

    // Default constructor
    public BillItem() {}

    // Constructor with parameters for full initialization
    public BillItem(int id, int billId, int itemId, int quantity, double unitPrice, double total) {
        this.id = id;
        this.billId = billId;
        this.itemId = itemId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.total = total;
    }

    // Constructor without ID (for creating new bill items)
    public BillItem(int billId, int itemId, int quantity, double unitPrice, double total) {
        this.billId = billId;
        this.itemId = itemId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.total = total;
    }

    // Encapsulation: Public getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    // Polymorphism: Overriding toString for custom string representation
    @Override
    public String toString() {
        return "BillItem{" +
                "id=" + id +
                ", billId=" + billId +
                ", itemId=" + itemId +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", total=" + total +
                '}';
    }
}