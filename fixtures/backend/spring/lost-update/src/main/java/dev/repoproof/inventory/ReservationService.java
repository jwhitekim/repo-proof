package dev.repoproof.inventory;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ReservationService {
    private final InventoryRepository inventories;

    public ReservationService(InventoryRepository inventories) {
        this.inventories = inventories;
    }

    @Transactional
    public void reserve(Long productId) {
        Inventory inventory = inventories.findById(productId).orElseThrow();
        inventory.reserveOne();
    }
}
