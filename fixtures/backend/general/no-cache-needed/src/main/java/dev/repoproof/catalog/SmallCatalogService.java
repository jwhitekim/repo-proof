package dev.repoproof.catalog;

import java.util.List;
import org.springframework.stereotype.Service;

/** Three process-local constants; there is no remote origin or demonstrated cache need. */
@Service
public final class SmallCatalogService {
    private static final List<String> PRODUCTS = List.of("pen", "paper", "stapler");

    public List<String> list() {
        return PRODUCTS;
    }
}
