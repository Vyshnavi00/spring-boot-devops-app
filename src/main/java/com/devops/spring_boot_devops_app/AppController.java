package com.devops.spring_boot_devops_app;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
public class AppController {

    @GetMapping("/")
    public String home() {
        return "Spring Boot DevOps App is Running!";
    }

    @GetMapping("/health")
    public Map<String, String> health() {
        return Map.of(
            "status", "healthy",
            "service", "spring-boot-devops-app"
        );
    }
}
