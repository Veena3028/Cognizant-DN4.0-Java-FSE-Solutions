package com.example;

import org.springframework.context.annotation.*;

@Configuration
public class AppConfig {

    @Bean
    public Library library() {
        return new Library();
    }
}
