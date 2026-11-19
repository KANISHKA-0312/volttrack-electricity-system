package com.ecm.model;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * Entity representing monthly meter reading for a consumer.
 * Calculates units consumed = currentReading - previousReading.
 * 
 * @author Kanishka K (Reg No: 732925ITR044, Class: 25IT3A)
 */
public class MeterReading implements Serializable {
    private static final long serialVersionUID = 1L;

    private int readingId;
    private int consumerId;
    private String billingMonth; // Format: YYYY-MM
    private LocalDate readingDate;
    private double previousReading;
    private double currentReading;
    private double unitsConsumed;
    private String meterReaderName;

    public MeterReading() {
        this.readingDate = LocalDate.now();
        this.meterReaderName = "System Reader";
    }

    public MeterReading(int readingId, int consumerId, String billingMonth, 
                        double previousReading, double currentReading, String meterReaderName) {
        this.readingId = readingId;
        this.consumerId = consumerId;
        this.billingMonth = billingMonth;
        this.readingDate = LocalDate.now();
        this.previousReading = previousReading;
        this.currentReading = currentReading;
        this.unitsConsumed = currentReading - previousReading;
        this.meterReaderName = meterReaderName;
    }

    public int getReadingId() { return readingId; }
    public void setReadingId(int readingId) { this.readingId = readingId; }

    public int getConsumerId() { return consumerId; }
    public void setConsumerId(int consumerId) { this.consumerId = consumerId; }

    public String getBillingMonth() { return billingMonth; }
    public void setBillingMonth(String billingMonth) { this.billingMonth = billingMonth; }

    public LocalDate getReadingDate() { return readingDate; }
    public void setReadingDate(LocalDate readingDate) { this.readingDate = readingDate; }

    public double getPreviousReading() { return previousReading; }
    public void setPreviousReading(double previousReading) { 
        this.previousReading = previousReading;
        this.unitsConsumed = this.currentReading - this.previousReading;
    }

    public double getCurrentReading() { return currentReading; }
    public void setCurrentReading(double currentReading) { 
        this.currentReading = currentReading; 
        this.unitsConsumed = this.currentReading - this.previousReading;
    }

    public double getUnitsConsumed() { return unitsConsumed; }

    public String getMeterReaderName() { return meterReaderName; }
    public void setMeterReaderName(String meterReaderName) { this.meterReaderName = meterReaderName; }

    @Override
    public String toString() {
        return String.format("Reading #%d | Consumer ID: %d | Month: %s | Prev: %.2f | Curr: %.2f | Consumed: %.2f kWh",
                readingId, consumerId, billingMonth, previousReading, currentReading, unitsConsumed);
    }
}
