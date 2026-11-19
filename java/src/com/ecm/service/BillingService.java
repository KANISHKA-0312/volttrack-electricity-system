package com.ecm.service;

import com.ecm.model.Bill;
import com.ecm.model.ConnectionType;
import com.ecm.model.Consumer;
import com.ecm.model.MeterReading;
import com.ecm.exception.InvalidMeterReadingException;

import java.time.LocalDate;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Concrete implementation of billing and tariff calculations.
 * Implements precise progressive slab calculation algorithms.
 * 
 * @author Kanishka K (Reg No: 732925ITR044, Class: 25IT3A)
 */
public class BillingService implements TariffCalculationService {

    private static final AtomicInteger BILL_COUNTER = new AtomicInteger(100);

    @Override
    public double calculateEnergyCharges(double units, ConnectionType connectionType) {
        if (units <= 0) return 0.00;

        double energyCharges = 0.0;

        switch (connectionType) {
            case DOMESTIC:
                // Progressive Slabs:
                // Slab 1: 0 - 100 units @ Rs. 0.00 (Free/Subsidized)
                // Slab 2: 101 - 200 units @ Rs. 2.25
                // Slab 3: 201 - 400 units @ Rs. 4.50
                // Slab 4: 401 - 500 units @ Rs. 6.00
                // Slab 5: Above 500 units @ Rs. 8.00
                if (units <= 100) {
                    energyCharges = 0.0;
                } else if (units <= 200) {
                    energyCharges = (units - 100) * 2.25;
                } else if (units <= 400) {
                    energyCharges = (100 * 2.25) + ((units - 200) * 4.50);
                } else if (units <= 500) {
                    energyCharges = (100 * 2.25) + (200 * 4.50) + ((units - 400) * 6.00);
                } else {
                    energyCharges = (100 * 2.25) + (200 * 4.50) + (100 * 6.00) + ((units - 500) * 8.00);
                }
                break;

            case COMMERCIAL:
                // Commercial Slabs:
                // 0 - 100 units @ Rs. 5.50
                // 101 - 500 units @ Rs. 7.50
                // Above 500 units @ Rs. 9.50
                if (units <= 100) {
                    energyCharges = units * 5.50;
                } else if (units <= 500) {
                    energyCharges = (100 * 5.50) + ((units - 100) * 7.50);
                } else {
                    energyCharges = (100 * 5.50) + (400 * 7.50) + ((units - 500) * 9.50);
                }
                break;

            case INDUSTRIAL:
                // Industrial Slabs:
                // 0 - 1000 units @ Rs. 7.00
                // Above 1000 units @ Rs. 8.50
                if (units <= 1000) {
                    energyCharges = units * 7.00;
                } else {
                    energyCharges = (1000 * 7.00) + ((units - 1000) * 8.50);
                }
                break;

            case AGRICULTURAL:
                // Agricultural Slabs:
                // 0 - 500 units @ Rs. 0.00 (Free government subsidy)
                // Above 500 units @ Rs. 1.50
                if (units <= 500) {
                    energyCharges = 0.0;
                } else {
                    energyCharges = (units - 500) * 1.50;
                }
                break;
        }

        return Math.round(energyCharges * 100.0) / 100.0;
    }

    @Override
    public double getFixedCharges(ConnectionType connectionType) {
        return connectionType.getBaseFixedCharge();
    }

    @Override
    public double calculateTaxAmount(double energyCharges, double fixedCharges, ConnectionType connectionType) {
        double taxableSubtotal = energyCharges + fixedCharges;
        double tax = (taxableSubtotal * connectionType.getTaxPercentage()) / 100.0;
        return Math.round(tax * 100.0) / 100.0;
    }

    @Override
    public double calculateTotalBill(double units, ConnectionType connectionType) {
        double energy = calculateEnergyCharges(units, connectionType);
        double fixed = getFixedCharges(connectionType);
        double tax = calculateTaxAmount(energy, fixed, connectionType);
        return Math.round((energy + fixed + tax) * 100.0) / 100.0;
    }

    /**
     * Generates a fully populated Bill object from Consumer and MeterReading.
     */
    public Bill generateBill(Consumer consumer, MeterReading reading) throws InvalidMeterReadingException {
        if (reading.getCurrentReading() < reading.getPreviousReading()) {
            throw new InvalidMeterReadingException("Current reading (" + reading.getCurrentReading() + 
                ") cannot be lower than previous reading (" + reading.getPreviousReading() + ")");
        }

        double units = reading.getUnitsConsumed();
        ConnectionType connType = consumer.getConnectionType();

        double energyCharges = calculateEnergyCharges(units, connType);
        double fixedCharges = getFixedCharges(connType);
        double taxAmount = calculateTaxAmount(energyCharges, fixedCharges, connType);
        double totalAmount = energyCharges + fixedCharges + taxAmount;

        String billNo = String.format("BILL-%s-%04d", reading.getBillingMonth(), BILL_COUNTER.incrementAndGet());

        Bill bill = new Bill(
            BILL_COUNTER.get(),
            billNo,
            reading.getReadingId(),
            consumer.getConsumerId(),
            consumer.getName(),
            connType,
            reading.getBillingMonth(),
            units,
            energyCharges,
            fixedCharges,
            taxAmount,
            Math.round(totalAmount * 100.0) / 100.0
        );

        return bill;
    }
}
