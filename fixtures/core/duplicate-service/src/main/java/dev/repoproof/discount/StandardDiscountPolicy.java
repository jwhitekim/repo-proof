package dev.repoproof.discount;

import java.math.BigDecimal;
import org.springframework.stereotype.Component;

@Component
public final class StandardDiscountPolicy implements DiscountPolicy {
    private static final BigDecimal VIP_RATE = new BigDecimal("0.10");
    private static final BigDecimal VIP_THRESHOLD = new BigDecimal("100.00");

    @Override
    public BigDecimal discountFor(BigDecimal orderTotal, boolean vip) {
        if (vip && orderTotal.compareTo(VIP_THRESHOLD) >= 0) {
            return orderTotal.multiply(VIP_RATE);
        }
        return BigDecimal.ZERO;
    }
}
