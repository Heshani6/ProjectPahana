package com.example.pahanaedu3.Models;

// The Customer class represents a customer entity in the system.
// OOP: Encapsulation (private fields, public getters/setters), Abstraction (model abstraction)
public class Customer {
    // Encapsulation: Private fields, only accessible via getters/setters
    private int id;
    private String accountNumber;
    private String name;
    private String address;
    private String phone;

    // Default constructor
    public Customer() {}

    // Constructor with parameters for full initialization
    public Customer(int id, String accountNumber, String name, String address, String phone) {
        this.id = id;
        this.accountNumber = accountNumber;
        this.name = name;
        this.address = address;
        this.phone = phone;
    }

    // Encapsulation: Public getter and setter for id
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    // Encapsulation: Public getter and setter for accountNumber
    public String getAccountNumber() {
        return accountNumber;
    }
    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    // Encapsulation: Public getter and setter for name
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    // Encapsulation: Public getter and setter for address
    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    // Encapsulation: Public getter and setter for phone
    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }

    // Constructor without ID (used when adding new customers)
    public Customer(String accountNumber, String name, String address, String phone) {
        this.accountNumber = accountNumber;
        this.name = name;
        this.address = address;
        this.phone = phone;
    }


    // Polymorphism: Overriding toString for custom string representation
    @Override
    public String toString() {
        return "Customer{" +
                "id=" + id +
                ", accountNumber='" + accountNumber + '\'' +
                ", name='" + name + '\'' +
                ", address='" + address + '\'' +
                ", phone='" + phone + '\'' +
                '}';
    }
} 