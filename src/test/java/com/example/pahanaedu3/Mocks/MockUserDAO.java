package com.example.pahanaedu3.Mocks;

import com.example.pahanaedu3.DAO.UserDAO;
import com.example.pahanaedu3.Models.User;
import java.util.ArrayList;
import java.util.List;

public class MockUserDAO extends UserDAO {
    private List<User> users = new ArrayList<>();

    public MockUserDAO() {
        users.add(new User(1, "admin", "adminpass", "admin"));
        users.add(new User(2, "staff1", "staffpass", "staff"));
        users.add(new User(3, "staff2", "staffpass", "staff"));
    }

    @Override
    public User authenticateUser(String username, String password) {
        for (User user : users) {
            if (user.getUsername().equals(username) && user.getPassword().equals(password)) {
                return user;
            }
        }
        return null;
    }

    @Override
    public boolean createUser(String username, String password, String role) {
        for (User user : users) {
            if (user.getUsername().equals(username)) {
                return false;
            }
        }
        User newUser = new User(users.size() + 1, username, password, role);
        return users.add(newUser);
    }

    @Override
    public List<User> getAllUsers() {
        return new ArrayList<>(users);
    }

    // Since your UserService's addUser calls createUser, we need to override that as well.
    @Override
    public boolean addUser(String username, String role, String password) {
        return createUser(username, password, role);
    }

    // You can add more mock methods here if your tests for UserService or UserServlet need them.
}