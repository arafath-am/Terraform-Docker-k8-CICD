package com.campuscart;

import com.campuscart.model.Product;
import com.campuscart.repository.ProductRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.math.BigDecimal;

@SpringBootApplication
public class CampusCartApplication {

    public static void main(String[] args) {
        SpringApplication.run(CampusCartApplication.class, args);
    }

    @Bean
    CommandLineRunner seedProducts(ProductRepository productRepository) {
        return args -> {
            if (productRepository.count() == 0) {
                productRepository.save(new Product("Used Java Textbook", "Books", "Good condition Java textbook for CS students", new BigDecimal("35.00"), 8));
                productRepository.save(new Product("Dell Monitor 24 inch", "Electronics", "Used monitor, works well for dorm setup", new BigDecimal("75.00"), 3));
                productRepository.save(new Product("Scientific Calculator", "Supplies", "TI-style calculator for engineering classes", new BigDecimal("18.00"), 12));
                productRepository.save(new Product("Dorm Study Table", "Furniture", "Small wooden table, pickup near campus", new BigDecimal("45.00"), 2));
                productRepository.save(new Product("Wireless Keyboard", "Electronics", "Basic wireless keyboard with USB dongle", new BigDecimal("20.00"), 5));
            }
        };
    }
}
