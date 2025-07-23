package com.example.pahanaedu3.Models;

// The User class represents a user entity in the system.
// OOP: Encapsulation (private fields, public getters/setters), Abstraction (model abstraction)
public class User {
    // Encapsulation: Private fields, only accessible via getters/setters
    private int id;
    private String username;
    private String password;
    private String role;

    // Default constructor
    public User() {}

    // Constructor with parameters for full initialization
    public User(int id, String username, String password, String role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
    }

    // Encapsulation: Public getter and setter for id
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    // Encapsulation: Public getter and setter for username
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    // Encapsulation: Public getter and setter for password
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    // Encapsulation: Public getter and setter for role
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    // Polymorphism: Overriding toString for custom string representation
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}
