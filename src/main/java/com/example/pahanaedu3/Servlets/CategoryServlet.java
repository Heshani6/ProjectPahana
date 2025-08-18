package com.example.pahanaedu3.Servlets;

import java.io.IOException;
import java.util.List;

import com.example.pahanaedu3.Services.CategoryService;
import com.example.pahanaedu3.Models.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// CategoryServlet acts as the controller for category management (MVC, Front Controller pattern)
// OOP: Composition (uses CategoryService), Abstraction (hides business logic), Separation of Concerns
@WebServlet("/category")
public class CategoryServlet extends HttpServlet {
    private CategoryService categoryService;

    @Override
    public void init() throws ServletException {
        categoryService = new CategoryService();
    }

    // Handle GET: List all categories
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        String msg = request.getParameter("msg");
        if (msg != null) {
            request.setAttribute("msg", msg);
        }
        request.getRequestDispatcher("category-management.jsp").forward(request, response);
    }

    // Handle POST: Add, update, delete category
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Get user role from session (for delete access control if needed)
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        String userRole = "staff"; // Default role
        if (session != null && session.getAttribute("role") != null) {
            userRole = (String) session.getAttribute("role");
        }

        String msg = null;

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            boolean success = categoryService.addCategory(new Category(name, description));
            msg = success ? "Category added successfully!" : "Category name already exists or failed to add.";

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            boolean success = categoryService.updateCategory(new Category(id, name, description));
            msg = success ? "Category updated successfully!" : "Failed to update category.";

        } else if ("delete".equals(action)) {
            // Only admin can delete category
            if (!"admin".equalsIgnoreCase(userRole)) {
                String errorMsg = "Access denied. Only administrators can delete categories.";
                response.sendRedirect("category?msg=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
                return;
            }

            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = categoryService.deleteCategory(id);
            msg = success ? "Category deleted successfully!" : "Failed to delete category.";

            response.sendRedirect("category?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));
            return; // Important: stop further processing
        } else {
            // Unknown action, redirect to category list
            response.sendRedirect("category?msg");
            return;
        }

        // For add/update, use PRG pattern to avoid resubmission
        response.sendRedirect("category?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));
    }


}