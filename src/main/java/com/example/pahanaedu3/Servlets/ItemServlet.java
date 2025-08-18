package com.example.pahanaedu3.Servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.example.pahanaedu3.Models.Category;
import com.example.pahanaedu3.Models.Item;
import com.example.pahanaedu3.Services.CategoryService;
import com.example.pahanaedu3.Services.ItemService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// ItemServlet acts as the controller for item management (MVC, Front Controller pattern)
// OOP: Composition (uses ItemService), Abstraction (hides business logic), Separation of Concerns
@WebServlet({"/item", "/add-item"})
public class ItemServlet extends HttpServlet {
    private ItemService itemService;
    private CategoryService categoryService;

    @Override
    public void init() throws ServletException {
        itemService = new ItemService();
        categoryService = new CategoryService();
    }

    // Handle GET: List/search items, pass categories for dropdowns
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String requestURI = request.getRequestURI();
        String page = request.getParameter("page");

        // Check if this is an add-item request
        if (requestURI.endsWith("/add-item") || "add".equals(page)) {
            // Handle add-item page - just get categories for dropdown
            List<Category> categories = categoryService.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("add-item.jsp").forward(request, response);
            return;
        }

        // Handle item management page (existing code)
        String search = request.getParameter("search");
        List<Item> items;
        if (search != null && !search.trim().isEmpty()) {
            items = itemService.searchItemsByName(search.trim());
        } else {
            items = itemService.getAllItems();
        }

        // Group items by name for display
        Map<String, List<Item>> groupedItems = new HashMap<>();
        for (Item item : items) {
            String itemName = item.getName();
            if (groupedItems.containsKey(itemName)) {
                groupedItems.get(itemName).add(item);
            } else {
                List<Item> itemList = new ArrayList<>();
                itemList.add(item);
                groupedItems.put(itemName, itemList);
            }
        }

        // Create a flat list with items grouped by name
        List<Item> groupedItemsList = new ArrayList<>();
        for (Map.Entry<String, List<Item>> entry : groupedItems.entrySet()) {
            List<Item> itemGroup = entry.getValue();
            // Add all items in the group
            for (Item item : itemGroup) {
                groupedItemsList.add(item);
            }
        }

        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("items", groupedItemsList);
        request.setAttribute("categories", categories);
        String msg = request.getParameter("msg");
        if (msg != null) {
            request.setAttribute("msg", msg);
        }
        request.getRequestDispatcher("item-management.jsp").forward(request, response);
    }


    // Handle POST: Add, update, delete item
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Get user role from session for role-based access control
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        String userRole = "staff"; // Default to staff role for security
        if (session != null && session.getAttribute("role") != null) {
            userRole = (String) session.getAttribute("role");
        }

        String msg = null;
        if ("add".equals(action)) {
            String name = request.getParameter("name");
            int category = Integer.parseInt(request.getParameter("category"));
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            boolean success = itemService.addItem(new Item(name, category, price, quantity));
            msg = success ? "Item added successfully!" : "Failed to add item.";

        }else if ("update".equals(action)) {
                // Both admin and staff can update items
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                int category = Integer.parseInt(request.getParameter("category"));
                double price = Double.parseDouble(request.getParameter("price"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                Item item = new Item(id, name, category, null, price, quantity);
                boolean success = itemService.updateItem(item);
                msg = success ? "Item updated successfully!" : "Failed to update item.";

                response.sendRedirect("item?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));

            } else if ("delete".equals(action)) {
                System.out.println("DEBUG: Delete action triggered");
                System.out.println("DEBUG: User role: " + userRole);

                // Only admin can delete items
                if (!"admin".equalsIgnoreCase(userRole)) {
                    System.out.println("DEBUG: Access denied - user is not admin");
                    String errorMsg = "Access denied. Only administrators can delete items.";
                    response.sendRedirect("item?msg=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
                    return;
                }

                int id = Integer.parseInt(request.getParameter("id"));
                System.out.println("DEBUG: Attempting to delete item with ID: " + id);
                boolean success = itemService.deleteItem(id);
                System.out.println("DEBUG: Delete result: " + success);

                msg = success ? "Item deleted successfully!" : "Failed to delete item.";
                response.sendRedirect("item?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));


            } else {
            // PRG pattern: Redirect to GET with message
            response.sendRedirect("item-management.jsp");
        }
    }
}