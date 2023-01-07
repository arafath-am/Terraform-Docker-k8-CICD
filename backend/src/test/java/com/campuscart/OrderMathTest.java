package com.campuscart;

import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;

class OrderMathTest {

    @Test
    void calculatesLineTotal() {
        BigDecimal unitPrice = new BigDecimal("19.99");
        int quantity = 3;
        BigDecimal total = unitPrice.multiply(BigDecimal.valueOf(quantity));
        assertEquals(new BigDecimal("59.97"), total);
    }
}
