package com.ecm.model;

/**
 * Enumeration representing electricity connection types and their base parameters.
 * Aligns with TANGEDCO / Standard Electricity Board classifications.
 * 
 * @author Kanishka K (Reg No: 732925ITR045, Class: 25IT3A)
 */
public enum ConnectionType {
    DOMESTIC("Domestic Residential", 35.00, 5.00),
    COMMERCIAL("Commercial / Business", 120.00, 12.00),
    INDUSTRIAL("Industrial / Factory", 250.00, 18.00),
    AGRICULTURAL("Agricultural Irrigation", 0.00, 0.00);

    private final String displayName;
    private final double baseFixedCharge;
    private final double taxPercentage;

    ConnectionType(String displayName, double baseFixedCharge, double taxPercentage) {
        this.displayName = displayName;
        this.baseFixedCharge = baseFixedCharge;
        this.taxPercentage = taxPercentage;
    }

    public String getDisplayName() {
        return displayName;
    }

    public double getBaseFixedCharge() {
        return baseFixedCharge;
    }

    public double getTaxPercentage() {
        return taxPercentage;
    }

    public static ConnectionType fromString(String text) {
        for (ConnectionType b : ConnectionType.values()) {
            if (b.name().equalsIgnoreCase(text) || b.displayName.equalsIgnoreCase(text)) {
                return b;
            }
        }
        return DOMESTIC;
    }
}
