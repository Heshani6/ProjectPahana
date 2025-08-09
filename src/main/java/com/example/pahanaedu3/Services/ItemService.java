package com.example.pahanaedu3.Services;

import com.example.pahanaedu3.DAO.ItemDAO;
import com.example.pahanaedu3.Models.Item;

import java.util.List;

// ItemService provides business logic for item operations.
// OOP: Abstraction (hides DAO details), Composition (uses ItemDAO), Separation of Concerns (Service layer)
public class ItemService {
    private final ItemDAO itemDAO;

    public ItemService() {
        this.itemDAO = new ItemDAO();
    }

    public boolean addItem(Item item) {
        return itemDAO.addItem(item);
    }

    public List<Item> getAllItems() {
        return itemDAO.getAllItems();
    }

    public boolean updateItem(Item item) {
        return itemDAO.updateItem(item);
    }

    public boolean deleteItem(int id) {
        return itemDAO.deleteItem(id);
    }

    public List<Item> searchItemsByName(String name) {
        return itemDAO.searchItemsByName(name);
    }

    public Item getItemById(int id) {
        return itemDAO.getItemById(id);
    }

    public int getItemCount() {
        return itemDAO.getItemCount();
    }
}
