package dev.repoproof.catalog;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
public class ProductCatalogService {
    private final ProductGateway products;

    public ProductCatalogService(ProductGateway products) {
        this.products = products;
    }

    @Cacheable(cacheNames = "products", key = "#productId")
    public Product find(Long productId) {
        return products.find(productId);
    }

    public interface ProductGateway { Product find(Long productId); }
    public record Product(Long id, String name) {}
}
