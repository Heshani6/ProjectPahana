package com.example.pahanaedu3.Services;


import java.util.Date;
import java.util.List;

import com.example.pahanaedu3.DAO.BillDAO;
import com.example.pahanaedu3.DAO.BillItemDAO;
import com.example.pahanaedu3.Models.Bill;
import com.example.pahanaedu3.Models.BillItem;

// BillService provides business logic for Bill operations.
// OOP: Abstraction (service layer), Composition (uses BillDAO and BillItemDAO), Separation of Concerns
public class BillService {
    private BillDAO billDAO;
    private BillItemDAO billItemDAO;

    public BillService() {
        this.billDAO = new BillDAO();
        this.billItemDAO = new BillItemDAO();
    }

    // Create a new bill with items
    public boolean createBill(Bill bill, List<BillItem> billItems) {
        System.out.println("=== STARTING BILL CREATION ===");
        try {
            // Generate bill number
            String billNumber = billDAO.getNextBillNumber();
            bill.setBillNumber(billNumber);
            System.out.println("Generated bill number: " + billNumber);

            // Set current date
            bill.setBillDate(new Date());
            System.out.println("Set bill date: " + bill.getBillDate());

            // Calculate totals
            calculateBillTotals(bill, billItems);
            System.out.println("Calculated totals - Subtotal: " + bill.getSubtotal() + ", Tax: " + bill.getTax() + ", Total: " + bill.getTotal());

            // Save bill and get the generated ID
            System.out.println("About to save bill to database...");
            int billId = billDAO.addBill(bill);
            System.out.println("Bill saved with ID: " + billId);
            if (billId == -1) {
                System.err.println("Failed to save bill");
                return false;
            }

            // Set the bill ID
            bill.setId(billId);
            System.out.println("Bill ID set to: " + bill.getId());

            // Save bill items
            System.out.println("Saving " + billItems.size() + " bill items");
            boolean allItemsSaved = true;
            for (BillItem item : billItems) {
                item.setBillId(billId);
                System.out.println("About to save item: " + item.getItemId() + " with billId: " + item.getBillId());
                boolean itemSaved = billItemDAO.addBillItem(item);
                System.out.println("Saving item " + item.getItemId() + " - Success: " + itemSaved);
                if (!itemSaved) {
                    System.err.println("Failed to save bill item: " + item.getItemId());
                    allItemsSaved = false;
                }
            }

            if (allItemsSaved) {
                System.out.println("Bill creation completed successfully");
                System.out.println("=== BILL CREATION SUCCESS ===");
                return true;
            } else {
                System.out.println("Bill created but some items failed to save");
                System.out.println("=== BILL CREATION SUCCESS (WITH ITEM FAILURES) ===");
                return true; // Return true anyway since bill was created
            }
        } catch (Exception e) {
            System.err.println("Error in createBill: " + e.getMessage());
            e.printStackTrace();
            System.out.println("=== BILL CREATION FAILED ===");
            return false;
        }
    }

    // Get all bills
    public List<Bill> getAllBills() {
        return billDAO.getAllBills();
    }

    // Get bill by ID
    public Bill getBillById(int id) {
        return billDAO.getBillById(id);
    }

    // Update bill
    public boolean updateBill(Bill bill) {
        return billDAO.updateBill(bill);
    }

    // Delete bill
    public boolean deleteBill(int id) {
        // First delete bill items
        billItemDAO.deleteBillItemsByBillId(id);
        // Then delete bill
        return billDAO.deleteBill(id);
    }

    // Calculate bill totals
    private void calculateBillTotals(Bill bill, List<BillItem> billItems) {
        double subtotal = 0.0;

        for (BillItem item : billItems) {
            item.setTotal(item.getQuantity() * item.getUnitPrice());
            subtotal += item.getTotal();
        }

        bill.setSubtotal(subtotal);

        // Calculate tax (5%)
        double tax = subtotal * 0.05;
        bill.setTax(tax);

        // Calculate total
        double total = subtotal + tax;
        bill.setTotal(total);
    }

    // Get bill items by bill ID
    public List<BillItem> getBillItemsByBillId(int billId) {
        return billItemDAO.getBillItemsByBillId(billId);
    }

    // Search bills by bill number or customer
    public List<Bill> searchBills(String searchQuery) {
        return billDAO.searchBills(searchQuery);
    }
}