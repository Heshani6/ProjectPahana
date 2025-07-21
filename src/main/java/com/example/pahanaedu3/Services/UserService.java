package com.example.pahanaedu3.Services;


import com.example.pahanaedu3.DAO.UserDAO;
import com.example.pahanaedu3.Models.User;

public class UserService {
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    // ✅ Login method
    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty()) {
            return null;
        }
        if (password == null || password.trim().isEmpty()) {
            return null;
        }

        return userDAO.authenticateUser(username.trim(), password);
    }

    // ✅ Create user with role
    public boolean createUser(String username, String password, String role) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        if (password == null || password.trim().isEmpty()) {
            return false;
        }
        if (role == null || role.trim().isEmpty()) {
            return false;
        }

        if (userDAO.userExists(username.trim())) {
            return false;
        }

        return userDAO.createUser(username.trim(), password, role.trim().toLowerCase());
    }
}


