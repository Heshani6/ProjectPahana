package com.example.pahanaedu3.Servlets;

import java.io.IOException;
import java.util.List;
import com.google.gson.Gson;

import com.example.pahanaedu3.Models.Bill;
import com.example.pahanaedu3.Services.BillService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// BillServlet handles bill management operations.
// OOP: Inheritance (extends HttpServlet), Composition (uses BillService), Separation of Concerns
@WebServlet("/bill")
public class BillServlet extends HttpServlet {
    private BillService billService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        billService = new BillService();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("get".equals(action)) {
            // Handle AJAX request to get individual bill data
            int billId = Integer.parseInt(request.getParameter("id"));
            Bill bill = billService.getBillById(billId);
            
            if (bill != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(gson.toJson(bill));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Bill not found\"}");
            }
            return;
        }
        
        String search = request.getParameter("search");
        List<Bill> bills;
        if (search != null && !search.trim().isEmpty()) {
            bills = billService.searchBills(search.trim());
        } else {
            bills = billService.getAllBills();
        }
        request.setAttribute("bills", bills);
        String msg = request.getParameter("msg");
        if (msg != null) {
            request.setAttribute("msg", msg);
        }
        request.getRequestDispatcher("bill-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String msg = null;
        
        if ("delete".equals(action)) {
            int billId = Integer.parseInt(request.getParameter("id"));
            boolean success = billService.deleteBill(billId);
            msg = success ? "Bill deleted successfully!" : "Failed to delete bill.";
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String billNumber = request.getParameter("billNumber");
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String billDateStr = request.getParameter("billDate");
            double subtotal = Double.parseDouble(request.getParameter("subtotal"));
            double tax = Double.parseDouble(request.getParameter("tax"));
            double total = Double.parseDouble(request.getParameter("total"));
            String status = request.getParameter("status");
            
            // Convert string date to Date object
            java.sql.Date billDate = java.sql.Date.valueOf(billDateStr);
            
            Bill bill = new Bill(id, billNumber, customerId, billDate, subtotal, tax, total, status);
            boolean success = billService.updateBill(bill);
            msg = success ? "Bill updated successfully!" : "Failed to update bill.";
        }
        
        // PRG pattern: Redirect to GET with message
        response.sendRedirect("bill?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));
    }
}