package com.example.pahanaedu3.Servlets;

import java.io.IOException;

import com.example.pahanaedu3.Services.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// RegisterServlet acts as a controller for user registration (staff/admin).
// OOP: Inheritance (extends HttpServlet), Composition (uses UserService), Separation of Concerns (controller logic)
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    // Composition: RegisterServlet uses UserService for business logic
    private UserService userService;

    @Override
    public void init() throws ServletException {
        // Abstraction: UserService abstracts user-related business logic
        userService = new UserService();
    }

    // Handles GET requests for registration or staff management
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String from = request.getParameter("from");
        String msg = request.getParameter("msg");
        
        if ("admin".equals(from)) {
            // Fetch all users from the database
            java.util.List<com.example.pahanaedu3.Models.User> staffUsers = userService.getAllStaffUsers();
            System.out.println("Loaded users: " + staffUsers);
            // Set the list as a request attribute
            request.setAttribute("users", staffUsers);
            // Set success message if provided
            if (msg != null) {
                request.setAttribute("msg", msg);
            }
            // Forward to the JSP
            request.getRequestDispatcher("/user-management.jsp").forward(request, response);
        } else {
            // Default: show the registration form
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    // Handles POST requests to register a new staff user
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String[] roles = request.getParameterValues("role");
        String role = (roles != null && roles.length > 0) ? roles[0] : "staff";
        String from = request.getParameter("from");

        // Basic validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required.");
        } else if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
        } else {
            // Delegates business logic to the service layer
            boolean success = userService.createUser(username, password, role);
            if (success) {
                if ("admin".equals(from)) {
                    // If adding from admin dashboard, show success message on register page first
                    request.setAttribute("success", "Staff account created successfully!");
                    request.setAttribute("clearForm", "true"); // Flag to clear form
                    request.setAttribute("autoRedirect", "true"); // Flag to auto-redirect
                    request.getRequestDispatcher("/register.jsp").forward(request, response);
                    return;
                } else {
                    // If adding from registration page, show success message and clear form
                    request.setAttribute("success", "Staff account created successfully!");
                    request.setAttribute("clearForm", "true"); // Flag to clear form
                    request.getRequestDispatcher("/register.jsp").forward(request, response);
                    return;
                }
            } else {
                request.setAttribute("error", "Registration failed. Username may already exist.");
            }
        }

        // Handle error cases or when no action was taken
        if ("admin".equals(from)) {
            java.util.List<com.example.pahanaedu3.Models.User> staffUsers = userService.getAllStaffUsers();
            request.setAttribute("users", staffUsers); // Use 'users' so the JSP works
            request.getRequestDispatcher("/user-management.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
} 