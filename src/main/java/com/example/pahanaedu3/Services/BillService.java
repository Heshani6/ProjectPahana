package com.example.pahanaedu3.Services;

import java.util.Date;
import java.util.List;

import com.example.pahanaedu3.DAO.BillDAO;
import com.example.pahanaedu3.DAO.BillItemDAO;
import com.example.pahanaedu3.DAO.ItemDAO;
import com.example.pahanaedu3.Models.Bill;
import com.example.pahanaedu3.Models.BillItem;
import com.example.pahanaedu3.Models.Item;

// BillService provides business logic for bill operations.
// OOP: Abstraction (hides DAO details), Composition (uses BillDAO), Separation of Concerns (Service layer)
public class BillService {
    private final BillDAO billDAO;
    private final BillItemDAO billItemDAO;
    private final ItemDAO itemDAO;

    public BillService() {
        this.billDAO = new BillDAO();
        this.billItemDAO = new BillItemDAO();
        this.itemDAO = new ItemDAO();
    }

    public boolean createBill(Bill bill, List<BillItem> billItems) {
        int billId = billDAO.addBill(bill);
        if (billId > 0) {
            boolean allItemsSaved = true;
            for (BillItem item : billItems) {
                item.setBillId(billId); // Set the generated bill ID
                boolean itemSaved = billItemDAO.addBillItem(item);
                if (!itemSaved) {
                    allItemsSaved = false;
                }
            }
            return allItemsSaved;
        }
        return false;
    }

    public List<Bill> getAllBills() {
        return billDAO.getAllBills();
    }

    public Bill getBillById(int id) {
        return billDAO.getBillById(id);
    }

    public List<BillItem> getBillItems(int billId) {
        return billItemDAO.getBillItemsByBillId(billId);
    }

    public List<Bill> searchBills(String searchQuery) {
        return billDAO.searchBills(searchQuery);
    }

    public boolean updateBill(Bill bill) {
        return billDAO.updateBill(bill);
    }

    // Process payment and update inventory
    public boolean processPayment(int billId, String paymentMethod, String paymentReference) {
        try {
            // 1. Get the bill
            Bill bill = billDAO.getBillById(billId);
            if (bill == null) {
                return false;
            }

            // 2. Update bill status to paid
            bill.setStatus("paid");
            bill.setPaymentMethod(paymentMethod);
            bill.setPaymentDate(new Date());
            bill.setPaymentReference(paymentReference);

            boolean billUpdated = billDAO.updateBill(bill);
            if (!billUpdated) {
                return false;
            }

            // 3. Update inventory quantities
            List<BillItem> billItems = billItemDAO.getBillItemsByBillId(billId);
            for (BillItem billItem : billItems) {
                Item item = itemDAO.getItemById(billItem.getItemId());
                if (item != null) {
                    // Reduce quantity by the amount ordered
                    int newQuantity = item.getQuantity() - billItem.getQuantity();
                    if (newQuantity < 0) {
                        // Insufficient stock - rollback payment
                        bill.setStatus("unpaid");
                        bill.setPaymentMethod(null);
                        bill.setPaymentDate(null);
                        bill.setPaymentReference(null);
                        billDAO.updateBill(bill);
                        return false;
                    }
                    item.setQuantity(newQuantity);
                    itemDAO.updateItem(item);
                }
            }

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if bill can be paid (sufficient stock)
    public boolean canProcessPayment(int billId) {
        try {
            List<BillItem> billItems = billItemDAO.getBillItemsByBillId(billId);
            for (BillItem billItem : billItems) {
                Item item = itemDAO.getItemById(billItem.getItemId());
                if (item == null || item.getQuantity() < billItem.getQuantity()) {
                    return false;
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get payment status
    public String getPaymentStatus(int billId) {
        Bill bill = billDAO.getBillById(billId);
        return bill != null ? bill.getStatus() : "unknown";
    }

    public boolean deleteBill(int billId) {
        return billDAO.deleteBill(billId);
    }
    
    // Get next bill number
    public String getNextBillNumber() {
        return billDAO.getNextBillNumber();
    }

    public int getPendingBillCount() {
        return billDAO.getPendingBillCount();
    }
}