package com.example.pahanaedu3.Servlets;

import com.example.pahanaedu3.Mocks.MockHttpServletRequest;
import com.example.pahanaedu3.Mocks.MockHttpServletResponse;
import com.example.pahanaedu3.Mocks.MockUserDAO;
import com.example.pahanaedu3.Services.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;

import jakarta.servlet.ServletException;
import java.io.IOException;
import java.lang.reflect.Field;

class LoginServletTest {

    private LoginServlet loginServlet;
    private UserService mockUserService;
    private MockUserDAO mockUserDAO;
    private MockHttpServletRequest request;
    private MockHttpServletResponse response;

    @BeforeEach
    void setUp() throws NoSuchFieldException, IllegalAccessException {
        mockUserDAO = new MockUserDAO();
        mockUserService = new UserService();
        Field userDAOField = UserService.class.getDeclaredField("userDAO");
        userDAOField.setAccessible(true);
        userDAOField.set(mockUserService, mockUserDAO);

        loginServlet = new LoginServlet();
        try {
            Field userServiceField = LoginServlet.class.getDeclaredField("userService");
            userServiceField.setAccessible(true);
            userServiceField.set(loginServlet, mockUserService);
        } catch (NoSuchFieldException e) {
            System.err.println("Could not find userService field in LoginServlet. Adjust the field name if needed.");
        }

        request = new MockHttpServletRequest();
        response = new MockHttpServletResponse();
    }

    @Test
    void testDoPost_ValidAdminLogin_RedirectsToAdminDashboard() throws ServletException, IOException {
        request.setParameter("username", "admin");
        request.setParameter("password", "adminpass");

        loginServlet.doPost(request, response);

        Assertions.assertEquals("admin-dashboard", response.getRedirectUrl(), "Should redirect to the admin dashboard.");
        Assertions.assertNotNull(request.getSession().getAttribute("user"), "User should be set in the session.");
        Assertions.assertEquals("admin", request.getSession().getAttribute("role"), "Role should be 'admin'.");
        Assertions.assertEquals(900, request.getSession().getMaxInactiveInterval(), "Session timeout should be 900 seconds.");
    }

    @Test
    void testDoPost_ValidStaffLogin_RedirectsToStaffDashboard() throws ServletException, IOException {
        request.setParameter("username", "staff1");
        request.setParameter("password", "staffpass");

        loginServlet.doPost(request, response);

        Assertions.assertEquals("staff-dashboard", response.getRedirectUrl(), "Should redirect to the staff dashboard.");
        Assertions.assertNotNull(request.getSession().getAttribute("user"));
        Assertions.assertEquals("staff", request.getSession().getAttribute("role"));
    }

    @Test
    void testDoPost_InvalidLogin_ForwardsWithError() throws ServletException, IOException {
        request.setParameter("username", "invalid_user");
        request.setParameter("password", "wrong_password");

        loginServlet.doPost(request, response);

        Assertions.assertNull(response.getRedirectUrl(), "Should not redirect on invalid login.");
        Assertions.assertEquals("index.jsp", request.forwardedPath, "Should forward to index.jsp.");
        Assertions.assertEquals("Invalid Username or Password, Please try Again", request.getAttribute("error"), "Error message should be set.");
        Assertions.assertNull(request.getSession().getAttribute("user"), "No user should be set in session.");
    }

    @Test
    void testDoPost_EmptyFields_ForwardsWithError() throws ServletException, IOException {
        request.setParameter("username", "");
        request.setParameter("password", "password123");

        loginServlet.doPost(request, response);

        Assertions.assertNull(response.getRedirectUrl(), "Should not redirect on empty fields.");
        Assertions.assertEquals("index.jsp", request.forwardedPath, "Should forward to index.jsp.");
        Assertions.assertEquals("Fields cannot be empty", request.getAttribute("error"), "Error message for empty fields should be set.");
    }
}