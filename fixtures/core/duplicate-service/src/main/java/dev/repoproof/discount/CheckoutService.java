package dev.repoproof.discount;

import java.math.BigDecimal;
import org.springframework.stereotype.Service;

@Service
public final class CheckoutService {
    private final DiscountPolicy discountPolicy;

    public CheckoutService(DiscountPolicy discountPolicy) {
        this.discountPolicy = discountPolicy;
    }

    public BigDecimal total(BigDecimal subtotal, boolean vip) {
        return subtotal.subtract(discountPolicy.discountFor(subtotal, vip));
    }
}
