package com.example.pahanaedu3.Services;

import java.util.List;
import com.example.pahanaedu3.DAO.BillItemDAO;
import com.example.pahanaedu3.Models.BillItem;

// BillItemService provides business logic for BillItem operations.
// OOP: Abstraction (service layer), Composition (uses BillItemDAO), Separation of Concerns
public class BillItemService {
    private BillItemDAO billItemDAO;

    public BillItemService() {
        this.billItemDAO = new BillItemDAO();
    }

    // Add a bill item
    public boolean addBillItem(BillItem billItem) {
        return billItemDAO.addBillItem(billItem);
    }

    // Get bill items by bill ID
    public List<BillItem> getBillItemsByBillId(int billId) {
        return billItemDAO.getBillItemsByBillId(billId);
    }

    // Delete bill items by bill ID
    public boolean deleteBillItemsByBillId(int billId) {
        return billItemDAO.deleteBillItemsByBillId(billId);
    }
}