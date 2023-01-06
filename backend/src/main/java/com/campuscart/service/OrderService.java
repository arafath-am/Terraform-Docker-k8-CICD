package com.campuscart.service;

import com.campuscart.dto.CreateOrderRequest;
import com.campuscart.dto.OrderItemRequest;
import com.campuscart.model.CustomerOrder;
import com.campuscart.model.OrderItem;
import com.campuscart.model.Product;
import com.campuscart.repository.CustomerOrderRepository;
import com.campuscart.repository.ProductRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class OrderService {

    private final CustomerOrderRepository customerOrderRepository;
    private final ProductRepository productRepository;

    public OrderService(CustomerOrderRepository customerOrderRepository, ProductRepository productRepository) {
        this.customerOrderRepository = customerOrderRepository;
        this.productRepository = productRepository;
    }

    @Transactional
    public CustomerOrder createOrder(CreateOrderRequest request) {
        if (request.getItems() == null || request.getItems().isEmpty()) {
            throw new IllegalArgumentException("Order must contain at least one item");
        }

        CustomerOrder order = new CustomerOrder();
        order.setCustomerName(request.getCustomerName());
        order.setCustomerEmail(request.getCustomerEmail());

        BigDecimal total = BigDecimal.ZERO;

        for (OrderItemRequest itemRequest : request.getItems()) {
            if (itemRequest.getQuantity() <= 0) {
                throw new IllegalArgumentException("Quantity must be greater than zero");
            }

            Product product = productRepository.findById(itemRequest.getProductId())
                    .orElseThrow(() -> new IllegalArgumentException("Product not found: " + itemRequest.getProductId()));

            if (product.getStockQuantity() < itemRequest.getQuantity()) {
                throw new IllegalArgumentException("Not enough stock for " + product.getName());
            }

            BigDecimal lineTotal = product.getPrice().multiply(BigDecimal.valueOf(itemRequest.getQuantity()));
            total = total.add(lineTotal);

            product.setStockQuantity(product.getStockQuantity() - itemRequest.getQuantity());
            productRepository.save(product);

            OrderItem orderItem = new OrderItem(
                    product.getId(),
                    product.getName(),
                    itemRequest.getQuantity(),
                    product.getPrice(),
                    lineTotal
            );
            order.addItem(orderItem);
        }

        order.setTotalAmount(total);
        return customerOrderRepository.save(order);
    }

    public List<CustomerOrder> findAllOrders() {
        return customerOrderRepository.findAll();
    }
}
