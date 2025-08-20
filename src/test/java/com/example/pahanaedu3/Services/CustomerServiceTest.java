package com.example.pahanaedu3.Services;

import com.example.pahanaedu3.Mocks.MockCustomerDAO;
import com.example.pahanaedu3.Models.Customer;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Field;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class CustomerServiceTest {

    private CustomerService customerService;
    private MockCustomerDAO mockCustomerDAO;

    @BeforeEach
    void setUp() throws NoSuchFieldException, IllegalAccessException {
        customerService = new CustomerService();
        mockCustomerDAO = new MockCustomerDAO();

        // Inject mock DAO using reflection
        Field daoField = CustomerService.class.getDeclaredField("customerDAO");
        daoField.setAccessible(true);
        daoField.set(customerService, mockCustomerDAO);
    }

    @Test
    void testAddCustomer_Success() {
        Customer customer = new Customer(0, "AC003", "Alice Blue", "789 Pine St", "1112223333");
        boolean added = customerService.addCustomer(customer);
        assertTrue(added);
    }

    @Test
    void testAddCustomer_DuplicateAccountNumber_Fails() {
        Customer customer = new Customer(0, "AC001", "Bob Brown", "1010 Oak St", "9998887777");
        boolean added = customerService.addCustomer(customer);
        assertFalse(added);
    }

    @Test
    void testGetCustomerById_Valid() {
        Customer customer = customerService.getCustomerById(1);
        assertNotNull(customer);
        assertEquals("John Doe", customer.getName());
    }

    @Test
    void testUpdateCustomer_Success() {
        Customer updated = new Customer(1, "AC001", "John Updated", "New Address", "0000000000");
        boolean result = customerService.updateCustomer(updated);
        assertTrue(result);
        assertEquals("John Updated", customerService.getCustomerById(1).getName());
    }

    @Test
    void testDeleteCustomer_Success() {
        boolean deleted = customerService.deleteCustomer(2);
        assertTrue(deleted);
        assertNull(customerService.getCustomerById(2));
    }

    @Test
    void testSearchByAccountNumber_PartialMatch() {
        List<Customer> result = customerService.searchCustomersByAccountNumber("AC00");
        assertFalse(result.isEmpty());
    }

    @Test
    void testAccountNumberExists_True() {
        assertTrue(customerService.accountNumberExists("AC001"));
    }

    @Test
    void testAccountNumberExists_False() {
        assertFalse(customerService.accountNumberExists("AC999"));
    }

    @Test
    void testGetCustomerCount() {
        int count = customerService.getCustomerCount();
        assertEquals(2, count); // based on MockCustomerDAO default
    }
}
