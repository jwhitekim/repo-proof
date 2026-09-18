package dev.repoproof.discount;

import java.math.BigDecimal;

/** The repository's established owner of the order discount rule. */
public interface DiscountPolicy {
    BigDecimal discountFor(BigDecimal orderTotal, boolean vip);
}
