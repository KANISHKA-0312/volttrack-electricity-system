package com.ecm.exception;

/**
 * Custom checked exception thrown when meter reading data violates business constraints
 * (e.g., current reading < previous reading, negative values, unreasonable spike).
 * 
 * @author Kanishka K (Reg No: 732925ITR045, Class: 25IT3A)
 */
public class InvalidMeterReadingException extends Exception {
    private static final long serialVersionUID = 1L;

    public InvalidMeterReadingException(String message) {
        super(message);
    }

    public InvalidMeterReadingException(String message, Throwable cause) {
        super(message, cause);
    }
}
