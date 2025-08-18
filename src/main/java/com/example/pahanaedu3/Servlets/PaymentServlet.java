package com.example.pahanaedu3.Servlets;

import java.io.IOException;

import com.example.pahanaedu3.Models.Bill;
import com.example.pahanaedu3.Services.BillService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private BillService billService;

    @Override
    public void init() throws ServletException {
        billService = new BillService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String billId = request.getParameter("billId");
        if (billId != null) {
            int id = Integer.parseInt(billId);
            Bill bill = billService.getBillById(id);
            if (bill != null) {
                request.setAttribute("bill", bill);
                request.setAttribute("canPay", billService.canProcessPayment(id));
                request.getRequestDispatcher("payment.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect("bill?error=Bill not found");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("process".equals(action)) {
            int billId = Integer.parseInt(request.getParameter("billId"));
            String paymentMethod = request.getParameter("paymentMethod");
            String paymentReference = request.getParameter("paymentReference");
            
            // Validate payment method
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                response.sendRedirect("payment?billId=" + billId + "&error=Payment method is required");
                return;
            }
            
            // Check if payment can be processed
            if (!billService.canProcessPayment(billId)) {
                response.sendRedirect("payment?billId=" + billId + "&error=Insufficient stock for some items");
                return;
            }
            
            // Process payment
            boolean success = billService.processPayment(billId, paymentMethod, paymentReference);
            
            if (success) {
                response.sendRedirect("bill?msg=Payment processed successfully! Inventory updated.");
            } else {
                response.sendRedirect("payment?billId=" + billId + "&error=Payment processing failed");
            }
        } else {
            response.sendRedirect("bill?error=Invalid action");
        }
    }
} 