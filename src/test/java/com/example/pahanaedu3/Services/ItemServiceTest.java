package com.example.pahanaedu3.Services;

import com.example.pahanaedu3.DAO.ItemDAO;
import com.example.pahanaedu3.Models.Item;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

class ItemServiceTest {

    private ItemService itemService;
    private MockItemDAO mockItemDAO;

    // Mock DAO to simulate data store behavior
    static class MockItemDAO extends ItemDAO {
        private final List<Item> items = new ArrayList<>();

        public MockItemDAO() {
            items.add(new Item(1, "Item1", 10.0));
            items.add(new Item(2, "Item2", 20.0));
        }

        @Override
        public boolean addItem(Item item) {
            return items.add(item);
        }

        @Override
        public List<Item> getAllItems() {
            return new ArrayList<>(items);
        }

        @Override
        public boolean updateItem(Item item) {
            for (int i = 0; i < items.size(); i++) {
                if (items.get(i).getId() == item.getId()) {
                    items.set(i, item);
                    return true;
                }
            }
            return false;
        }

        @Override
        public boolean deleteItem(int id) {
            return items.removeIf(i -> i.getId() == id);
        }

        @Override
        public List<Item> searchItemsByName(String name) {
            List<Item> result = new ArrayList<>();
            for (Item i : items) {
                if (i.getName().contains(name)) {
                    result.add(i);
                }
            }
            return result;
        }

        @Override
        public Item getItemById(int id) {
            return items.stream().filter(i -> i.getId() == id).findFirst().orElse(null);
        }

        @Override
        public int getItemCount() {
            return items.size();
        }
    }

    @BeforeEach
    void setUp() throws Exception {
        mockItemDAO = new MockItemDAO();
        itemService = new ItemService();

        // Inject mock DAO into service using reflection
        Field daoField = ItemService.class.getDeclaredField("itemDAO");
        daoField.setAccessible(true);
        daoField.set(itemService, mockItemDAO);
    }

    @Test
    void testAddItem() {
        Item newItem = new Item(3, "NewItem", 30.0);
        boolean added = itemService.addItem(newItem);
        Assertions.assertTrue(added);
        Assertions.assertEquals(3, itemService.getItemCount());
    }

    @Test
    void testGetAllItems() {
        List<Item> items = itemService.getAllItems();
        Assertions.assertEquals(2, items.size());
    }

    @Test
    void testUpdateItem_Success() {
        Item updated = new Item(1, "UpdatedItem", 15.0);
        boolean result = itemService.updateItem(updated);
        Assertions.assertTrue(result);
        Assertions.assertEquals("UpdatedItem", itemService.getItemById(1).getName());
    }

    @Test
    void testUpdateItem_Failure() {
        Item nonExistent = new Item(999, "NoItem", 0);
        boolean result = itemService.updateItem(nonExistent);
        Assertions.assertFalse(result);
    }

    @Test
    void testDeleteItem_Success() {
        boolean result = itemService.deleteItem(1);
        Assertions.assertTrue(result);
        Assertions.assertNull(itemService.getItemById(1));
    }

    @Test
    void testDeleteItem_Failure() {
        boolean result = itemService.deleteItem(999);
        Assertions.assertFalse(result);
    }

    @Test
    void testSearchItemsByName() {
        List<Item> found = itemService.searchItemsByName("Item");
        Assertions.assertEquals(2, found.size());

        found = itemService.searchItemsByName("1");
        Assertions.assertEquals(1, found.size());
        Assertions.assertEquals("Item1", found.get(0).getName());
    }

    @Test
    void testGetItemById() {
        Item item = itemService.getItemById(2);
        Assertions.assertNotNull(item);
        Assertions.assertEquals("Item2", item.getName());

        Item none = itemService.getItemById(999);
        Assertions.assertNull(none);
    }

    @Test
    void testGetItemCount() {
        Assertions.assertEquals(2, itemService.getItemCount());
    }
}
