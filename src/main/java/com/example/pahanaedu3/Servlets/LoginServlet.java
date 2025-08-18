package com.example.pahanaedu3.Servlets;


import java.io.IOException;

import com.example.pahanaedu3.Models.User;
import com.example.pahanaedu3.Services.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/login")
public class LoginServlet extends HttpServlet {


        private UserService userService;

        @Override
        public void init() throws ServletException {
            userService = new UserService();
        }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // Redirect based on role
            String role = (String) session.getAttribute("role");
            if ("admin".equalsIgnoreCase(role)) {
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                response.sendRedirect("staff-dashboard.jsp");
            }
            return;
        }

        // Forward to login page
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // ✅ Test 04: Empty fields
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Fields cannot be empty"); // Changed wording
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        User user = userService.login(username, password);

        if (user != null) {
            // ✅ Session setup
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());

            // ✅ Test 05: Session timeout (15 min)
            session.setMaxInactiveInterval(900);

            // ✅ Redirect based on role
            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("admin-dashboard");
            } else if ("staff".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("staff-dashboard");
            }
        } else {
            // ✅ Test 03: Invalid credentials message
            request.setAttribute("error", "Invalid Username or Password, Please try Again");
            request.setAttribute("username", username);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }





}
