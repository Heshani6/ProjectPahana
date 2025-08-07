package com.example.pahanaedu3.Servlets;

import java.io.IOException;
import com.example.pahanaedu3.Services.UserService;
import com.example.pahanaedu3.Services.CustomerService;
import com.example.pahanaedu3.Services.ItemService;
import com.example.pahanaedu3.Services.BillService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private UserService userService;
    private CustomerService customerService;
    private ItemService itemService;
    private BillService billService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
        customerService = new CustomerService();
        itemService = new ItemService();
        billService = new BillService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get counts from services
            int staffCount = userService.getStaffCount();
            int customerCount = customerService.getCustomerCount();
            int itemCount = itemService.getItemCount();
            int pendingBillCount = billService.getPendingBillCount();

            // Set attributes for JSP
            request.setAttribute("staffCount", staffCount);
            request.setAttribute("customerCount", customerCount);
            request.setAttribute("itemCount", itemCount);
            request.setAttribute("pendingBillCount", pendingBillCount);

            System.out.println("Dashboard Data - Staff: " + staffCount + ", Customers: " + customerCount + ", Items: " + itemCount + ", Pending Bills: " + pendingBillCount);

            // Forward to JSP
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in AdminDashboardServlet: " + e.getMessage());
            e.printStackTrace();
            // Set default values if there's an error
            request.setAttribute("staffCount", 0);
            request.setAttribute("customerCount", 0);
            request.setAttribute("itemCount", 0);
            request.setAttribute("pendingBillCount", 0);
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
        }
    }
}