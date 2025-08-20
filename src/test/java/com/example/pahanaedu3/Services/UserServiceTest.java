package com.example.pahanaedu3.Services;

import com.example.pahanaedu3.Models.User;
import com.example.pahanaedu3.Mocks.MockUserDAO;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.lang.reflect.Field;

class UserServiceTest {

    private UserService userService;
    private MockUserDAO mockUserDAO;

    @BeforeEach
    void setUp() throws NoSuchFieldException, IllegalAccessException {
        mockUserDAO = new MockUserDAO();
        userService = new UserService();

        Field userDAOField = UserService.class.getDeclaredField("userDAO");
        userDAOField.setAccessible(true);
        userDAOField.set(userService, mockUserDAO);
    }

    @Test
    void testLogin_ValidCredentials_ReturnsUser() {
        User loggedInUser = userService.login("admin", "adminpass");

        Assertions.assertNotNull(loggedInUser, "Login should succeed for valid credentials.");
        Assertions.assertEquals("admin", loggedInUser.getUsername());
        Assertions.assertEquals("admin", loggedInUser.getRole());
    }

    @Test
    void testLogin_InvalidCredentials_ReturnsNull() {
        User loggedInUser = userService.login("invalid_user", "wrong_password");

        Assertions.assertNull(loggedInUser, "Login should fail for invalid credentials.");
    }

    @Test
    void testAddUser_NewUser_ReturnsTrue() {
        boolean success = userService.addUser("new_staff", "staff", "new_pass");
        Assertions.assertTrue(success, "Adding a new user should be successful.");
    }

    @Test
    void testAddUser_ExistingUsername_ReturnsFalse() {
        boolean success = userService.addUser("staff1", "staff", "some_password");
        Assertions.assertFalse(success, "Adding a user with an existing username should fail.");
    }
}