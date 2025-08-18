package com.example.pahanaedu3.Models;

// The Category class represents a book/item category in the system.
// OOP: Encapsulation (private fields, public getters/setters), Abstraction (model abstraction)
public class Category {
    private int id; // Unique identifier for the category
    private String name; // Name of the category
    private String description; // Description of the category

    // Default constructor
    public Category() {}

    // Parameterized constructor
    public Category(int id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
    }

    // Constructor without id (for creation)
    public Category(String name, String description) {
        this.name = name;
        this.description = description;
    }

    // Getter and Setter for id
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // Getter and Setter for name
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // Getter and Setter for description
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // toString method for debugging (Polymorphism)
    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
