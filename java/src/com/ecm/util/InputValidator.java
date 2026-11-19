package com.ecm.util;

import java.util.regex.Pattern;

/**
 * Utility class providing validation methods for user and system inputs.
 * Demonstrates String operations, Regex pattern matching (Unit 4, 25ITT32).
 * 
 * @author Kanishka K (Reg No: 732925ITR044, Class: 25IT3A)
 */
public class InputValidator {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[6-9]\\d{9}$");
    private static final Pattern METER_PATTERN = Pattern.compile("^MTR-[A-Z0-9-]{4,15}$");

    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    public static boolean isValidMeterNumber(String meterNo) {
        return meterNo != null && METER_PATTERN.matcher(meterNo.trim()).matches();
    }

    public static boolean isValidReadings(double previous, double current) {
        return previous >= 0 && current >= previous;
    }
}
