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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String username = (String) session.getAttribute("username");
        User user = userService.getUserByUsername(username);

        if (user != null) {
            request.setAttribute("user", user);
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String username = (String) session.getAttribute("username");
        User user = userService.getUserByUsername(username);

        if (user != null) {
            // Verify current password
            if (userService.login(username, currentPassword) != null) {
                if (newPassword.equals(confirmPassword)) {
                    // Update password
                    boolean success = userService.updateUserPassword(user.getId(), newPassword);
                    if (success) {
                        request.setAttribute("success", "Password updated successfully!");
                    } else {
                        request.setAttribute("error", "Failed to update password");
                    }
                } else {
                    request.setAttribute("error", "New passwords do not match");
                }
            } else {
                request.setAttribute("error", "Current password is incorrect");
            }
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}