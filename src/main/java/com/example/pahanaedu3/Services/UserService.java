package com.example.pahanaedu3.Services;

import java.util.List;

import com.example.pahanaedu3.DAO.UserDAO;
import com.example.pahanaedu3.Models.User;

// UserService provides business logic for User operations.
// OOP: Abstraction (service layer), Composition (uses UserDAO), Separation of Concerns
public class UserService {
    // Composition: UserService uses UserDAO to access data
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    // Abstraction: getAllUsers hides data access details from controllers
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    // Abstraction: updateUser hides data access details from controllers
    public boolean updateUser(int id, String username, String role, String password) {
        if (username == null || username.trim().isEmpty() ||
            role == null || role.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            return false;
        }
        return userDAO.updateUser(id, username.trim(), role.trim(), password);
    }

    // Abstraction: deleteUser hides data access details from controllers
    public boolean deleteUser(int id) {
        return userDAO.deleteUser(id);
    }

    // Authenticates a user by username and password
    public User login(String username, String password) {
        return userDAO.authenticateUser(username, password);
    }

    public boolean createUser(String username, String password, String role) {
        // Implement as before
        return userDAO.createUser(username, password, role);
    }

    public List<User> getAllStaffUsers() {
        return userDAO.getAllStaffUsers();
    }

    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }
}


