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

@WebServlet("/user")
public class UserServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    // Handles GET requests: list all users or search
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        List<User> users;

        if (search != null && !search.trim().isEmpty()) {
            users = userService.searchUsersByUsername(search.trim());
        } else {
            users = userService.getAllUsers();
        }

        request.setAttribute("users", users);

        String msg = request.getParameter("msg");
        if (msg != null) {
            request.setAttribute("msg", msg);
        }

        request.getRequestDispatcher("user-management.jsp").forward(request, response);
    }

    // Handles POST requests: add, update, delete, register
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            // ✅ Add Staff (from add-staff.jsp)
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            boolean success = userService.addUser(username, password, role);
            String msg = success ? "Staff added successfully!" : "Failed to add staff (username may exist).";

            // reload user list
            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);
            request.setAttribute("msg", msg);
            request.getRequestDispatcher("user-management.jsp").forward(request, response);
            return;

        } else if ("update".equals(action)) {
            // ✅ Update user
            int id = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String role = request.getParameter("role");
            String password = request.getParameter("password");

            boolean success = userService.updateUser(id, username, role, password);
            String msg = success ? "User updated successfully!" : "Failed to update user.";

            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);
            request.setAttribute("msg", msg);
            request.getRequestDispatcher("user-management.jsp").forward(request, response);
            return;

        } else if ("delete".equals(action)) {
            // ✅ Delete user
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = userService.deleteUser(id);
            String msg = success ? "User deleted successfully!" : "Failed to delete user.";

            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);
            request.setAttribute("msg", msg);
            request.getRequestDispatcher("user-management.jsp").forward(request, response);
            return;

        } else if ("register".equals(action)) {
            // ✅ Self registration (signup.jsp)
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            // check if username already exists
            User existingUser = userService.getUserByUsername(username);
            if (existingUser != null) {
                request.setAttribute("error", "User with this username already exists");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            boolean success = userService.addUser(username, role, password);
            if (success) {
                response.sendRedirect("login.jsp?msg="
                        + java.net.URLEncoder.encode("Account created successfully! Please login.", "UTF-8"));
            } else {
                request.setAttribute("error", "Failed to register. Try again.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
            }
            return;
        }

        // fallback
        response.sendRedirect("user");
    }
}

