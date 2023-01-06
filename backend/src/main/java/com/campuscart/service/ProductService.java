package com.campuscart.service;

import com.campuscart.model.Product;
import com.campuscart.repository.ProductRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<Product> findProducts(String search) {
        if (search == null || search.trim().isEmpty()) {
            return productRepository.findAll();
        }
        return productRepository.findByNameContainingIgnoreCaseOrCategoryContainingIgnoreCase(search, search);
    }

    public Product createProduct(Product product) {
        return productRepository.save(product);
    }
}
