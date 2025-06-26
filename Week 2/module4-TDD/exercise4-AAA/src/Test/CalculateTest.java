package com.example;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class CalculateTest {

    private Calculate calculate;

    @BeforeEach
    public void setUp() {
        // Arrange
        calculate = new Calculate();
        System.out.println("Setup executed");
    }

    @AfterEach
    public void tearDown() {
        // Teardown
        System.out.println("Teardown executed");
    }

    @Test
    public void testAddition() {
        // Act
        int result = calculate.add(10, 5);

        // Assert
        assertEquals(15, result);
    }

    @Test
    public void testSubtraction() {
        // Act
        int result = calculate.subtract(10, 5);

        // Assert
        assertEquals(5, result);
    }
}


