package com.ecm.exception;

/**
 * Custom checked exception thrown when a requested consumer ID or number does not exist.
 * 
 * @author Kanishka K (Reg No: 732925ITR045, Class: 25IT3A)
 */
public class ConsumerNotFoundException extends Exception {
    private static final long serialVersionUID = 1L;

    public ConsumerNotFoundException(String message) {
        super(message);
    }

    public ConsumerNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}
