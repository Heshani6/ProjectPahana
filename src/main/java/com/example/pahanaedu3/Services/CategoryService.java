package com.example.pahanaedu3.Services;

import com.example.pahanaedu3.DAO.CategoryDAO;
import com.example.pahanaedu3.Models.Category;

import java.util.List;

// CategoryService provides business logic for category operations.
// OOP: Abstraction (hides DAO details), Composition (uses CategoryDAO), Separation of Concerns (Service layer)
public class CategoryService {
    private final CategoryDAO categoryDAO;

    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }

    // Add a new category (prevents duplicate names)
    public boolean addCategory(Category category) {
        if (categoryDAO.categoryNameExists(category.getName())) {
            return false; // Duplicate name
        }
        return categoryDAO.addCategory(category);
    }

    // Get all categories
    public List<Category> getAllCategories() {
        return categoryDAO.getAllCategories();
    }

    // Update a category (prevents duplicate names)
    public boolean updateCategory(Category category) {
        // Only check for duplicate if the name is changing
        List<Category> categories = categoryDAO.getAllCategories();
        for (Category c : categories) {
            if (c.getName().equalsIgnoreCase(category.getName()) && c.getId() != category.getId()) {
                return false; // Duplicate name
            }
        }
        return categoryDAO.updateCategory(category);
    }

    // Delete a category
    public boolean deleteCategory(int id) {
        return categoryDAO.deleteCategory(id);
    }
}
