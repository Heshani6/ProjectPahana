package com.example.pahanaedu3.Servlets;

import java.io.IOException;
import java.util.List;

import com.example.pahanaedu3.Models.User;
import com.example.pahanaedu3.Services.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// UserServlet acts as a controller for user management actions.
// OOP: Inheritance (extends HttpServlet), Composition (uses UserService), Separation of Concerns (controller logic)
@WebServlet("/user")
public class UserServlet extends HttpServlet {
    // Composition: UserServlet uses UserService for business logic
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    // Handles GET requests: list all users or show a single user for editing
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userService.getUserById(id); // You need to implement this in your service/DAO if not present
            request.setAttribute("user", user);
            request.getRequestDispatcher("edit-user.jsp").forward(request, response);
        } else {
            // Default: list all users (staff and/or admin as needed)
            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("user-management.jsp").forward(request, response);
        }
    }

    // Handles POST requests for update and delete actions
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        if ("update".equals(action) && idStr != null) {
            String username = request.getParameter("username");
            String role = request.getParameter("role");
            String password = request.getParameter("password");
            int id = Integer.parseInt(idStr);
            boolean success = userService.updateUser(id, username, role, password);
            if (success) {
                request.setAttribute("success", "User updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update user.");
            }
            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/user-management.jsp").forward(request, response);
            
        } else if ("delete".equals(action) && idStr != null) {
            int id = Integer.parseInt(idStr);
            boolean success = userService.deleteUser(id);
            if (success) {
                request.setAttribute("success", "User deleted successfully!");
            } else {
                request.setAttribute("error", "Failed to delete user.");
            }
            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/user-management.jsp").forward(request, response);
        } else {
            response.sendRedirect("user");
        }
    }
}
 