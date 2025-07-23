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

    // Handles GET requests to load all users and display the management table
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = userService.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/user-management.jsp").forward(request, response);
    }

    // Handles POST requests for update and delete actions
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String msg = null;
        if ("update".equals(action) && idStr != null) {
            String username = request.getParameter("username");
            String role = request.getParameter("role");
            String password = request.getParameter("password");
            int id = Integer.parseInt(idStr);
            boolean success = userService.updateUser(id, username, role, password);
            msg = success ? "User updated successfully!" : "Failed to update user.";
        } else if ("delete".equals(action) && idStr != null) {
            int id = Integer.parseInt(idStr);
            boolean success = userService.deleteUser(id);
            msg = success ? "User deleted successfully!" : "Failed to delete user.";
        }
        if (msg != null) {
            response.sendRedirect("user?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));
        } else {
            response.sendRedirect("user");
        }
    }
}
 