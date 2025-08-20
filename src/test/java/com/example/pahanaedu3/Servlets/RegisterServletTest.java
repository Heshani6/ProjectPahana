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

class RegisterServletTest {

    private RegisterServlet registerServlet;
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

        registerServlet = new RegisterServlet();
        Field userServiceField = RegisterServlet.class.getDeclaredField("userService");
        userServiceField.setAccessible(true);
        userServiceField.set(registerServlet, mockUserService);

        request = new MockHttpServletRequest();
        response = new MockHttpServletResponse();
    }

    @Test
    void testDoPost_NewUser_SuccessfulRegistration() throws ServletException, IOException {
        request.setParameter("username", "newstaff");
        request.setParameter("password", "securepass");
        request.setParameter("role", "staff");

        registerServlet.doPost(request, response);

        Assertions.assertEquals("register.jsp", request.forwardedPath);
        Assertions.assertEquals("Staff account created successfully!", request.getAttribute("success"));
        Assertions.assertEquals("true", request.getAttribute("clearForm"));
    }


    @Test
    void testDoPost_AdminFlow_Successful() throws ServletException, IOException {
        request.setParameter("username", "staffadmin");
        request.setParameter("password", "admin123");
        request.setParameter("role", "staff");
        request.setParameter("from", "admin");

        registerServlet.doPost(request, response);

        Assertions.assertEquals("user-management.jsp", request.forwardedPath);
        Assertions.assertEquals("Staff account created successfully!", request.getAttribute("success"));
        Assertions.assertEquals("true", request.getAttribute("clearForm"));
        Assertions.assertEquals("true", request.getAttribute("autoRedirect"));
    }

    @Test
    void testDoPost_AdminFlow_RegistrationFails() throws ServletException, IOException {
        request.setParameter("username", "staff1"); // already exists
        request.setParameter("password", "any");
        request.setParameter("role", "staff");
        request.setParameter("from", "admin");

        registerServlet.doPost(request, response);

        Assertions.assertEquals("/user-management.jsp", request.forwardedPath);
        Assertions.assertEquals("Registration failed. Username may already exist.", request.getAttribute("error"));
    }

    @Test
    void testDoGet_FromAdmin_ListsUsers() throws ServletException, IOException {
        request.setParameter("from", "admin");

        registerServlet.doGet(request, response);

        Assertions.assertEquals("/user-management.jsp", request.forwardedPath);
        Assertions.assertNotNull(request.getAttribute("users"), "User list should be populated");
    }

    @Test
    void testDoGet_DefaultForwardsToRegisterForm() throws ServletException, IOException {
        registerServlet.doGet(request, response);

        Assertions.assertEquals("/register.jsp", request.forwardedPath);
    }
}
