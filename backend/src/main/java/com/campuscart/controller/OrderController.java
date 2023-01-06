package com.campuscart.controller;

import com.campuscart.dto.CreateOrderRequest;
import com.campuscart.model.CustomerOrder;
import com.campuscart.service.OrderService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @GetMapping
    public List<CustomerOrder> listOrders() {
        return orderService.findAllOrders();
    }

    @PostMapping
    public CustomerOrder createOrder(@RequestBody CreateOrderRequest request) {
        return orderService.createOrder(request);
    }
}
