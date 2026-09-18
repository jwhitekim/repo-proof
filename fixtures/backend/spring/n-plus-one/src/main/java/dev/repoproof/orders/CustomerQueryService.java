package dev.repoproof.orders;

import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CustomerQueryService {
    private final CustomerRepository customers;

    public CustomerQueryService(CustomerRepository customers) {
        this.customers = customers;
    }

    @Transactional(readOnly = true)
    public List<CustomerSummary> listCustomers() {
        return customers.findAll().stream()
            .map(customer -> new CustomerSummary(customer.id(), customer.name(), customer.orders().size()))
            .toList();
    }

    public record CustomerSummary(Long id, String name, int orderCount) {}
}
