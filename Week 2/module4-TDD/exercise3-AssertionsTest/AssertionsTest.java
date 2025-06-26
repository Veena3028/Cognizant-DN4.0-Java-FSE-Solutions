package com.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AssertionsTest {

    @Test
    public void testAssertions() {
        // Assert equals: checks if 2 + 3 == 5
        assertEquals(5, 2 + 3);

        // Assert true: checks if condition is true
        assertTrue(5 > 3);

        // Assert false: checks if condition is false
        assertFalse(5 < 3);

        // Assert null: checks if value is null
        assertNull(null);

        // Assert not null: checks if object is not null
        assertNotNull(new Object());
    }
}

