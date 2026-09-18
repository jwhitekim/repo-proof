package dev.repoproof.discount;

import java.math.BigDecimal;
import org.springframework.stereotype.Service;

/** Added later without using the repository's DiscountPolicy extension point. */
@Service
public final class QuickCheckoutService {
    private static final BigDecimal VIP_RATE = new BigDecimal("0.10");
    private static final BigDecimal VIP_THRESHOLD = new BigDecimal("100.00");

    public BigDecimal total(BigDecimal subtotal, boolean vip) {
        BigDecimal discount = BigDecimal.ZERO;
        if (vip && subtotal.compareTo(VIP_THRESHOLD) >= 0) {
            discount = subtotal.multiply(VIP_RATE);
        }
        return subtotal.subtract(discount);
    }
}
