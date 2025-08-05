package com.example.pahanaedu3.Models;

import java.util.Date;


// OOP: Encapsulation (private fields, public getters/setters), Abstraction (model abstraction)
public class Bill {
    // Encapsulation: Private fields, only accessible via getters/setters
    private int id;
    private String billNumber;
    private int customerId;
    private Date billDate;
    private double subtotal;
    private double tax;
    private double total;
    private String status; // "paid" or "unpaid"


    public Bill() {}

    // Constructor with parameters for full initialization
    public Bill(int id, String billNumber, int customerId, Date billDate, double subtotal, double tax, double total, String status) {
        this.id = id;
        this.billNumber = billNumber;
        this.customerId = customerId;
        this.billDate = billDate;
        this.subtotal = subtotal;
        this.tax = tax;
        this.total = total;
        this.status = status;
    }

    // Constructor without ID (for creating new bills)
    public Bill(String billNumber, int customerId, Date billDate, double subtotal, double tax, double total, String status) {
        this.billNumber = billNumber;
        this.customerId = customerId;
        this.billDate = billDate;
        this.subtotal = subtotal;
        this.tax = tax;
        this.total = total;
        this.status = status;
    }

    // Encapsulation: Public getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getBillNumber() { return billNumber; }
    public void setBillNumber(String billNumber) { this.billNumber = billNumber; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public Date getBillDate() { return billDate; }
    public void setBillDate(Date billDate) { this.billDate = billDate; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    public double getTax() { return tax; }
    public void setTax(double tax) { this.tax = tax; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // Polymorphism: Overriding toString for custom string representation
    @Override
    public String toString() {
        return "Bill{" +
                "id=" + id +
                ", billNumber='" + billNumber + '\'' +
                ", customerId=" + customerId +
                ", billDate=" + billDate +
                ", subtotal=" + subtotal +
                ", tax=" + tax +
                ", total=" + total +
                ", status='" + status + '\'' +
                '}';
    }
}