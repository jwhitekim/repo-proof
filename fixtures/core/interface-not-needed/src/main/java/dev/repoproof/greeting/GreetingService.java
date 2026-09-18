package dev.repoproof.greeting;

import org.springframework.stereotype.Service;

/** A stable concrete service with one implementation and no demonstrated variation point. */
@Service
public final class GreetingService {
    public String greet(String name) {
        return "Hello, " + name;
    }
}
