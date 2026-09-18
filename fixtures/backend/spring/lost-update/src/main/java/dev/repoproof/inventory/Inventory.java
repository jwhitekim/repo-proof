package dev.repoproof.inventory;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class Inventory {
    @Id
    private Long productId;
    private int quantity;

    protected Inventory() {}

    public Inventory(Long productId, int quantity) {
        this.productId = productId;
        this.quantity = quantity;
    }

    public void reserveOne() {
        if (quantity < 1) throw new IllegalStateException("out of stock");
        quantity -= 1;
    }
}
