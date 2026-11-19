package com.ecm.service;

import com.ecm.model.ConnectionType;

/**
 * Service interface defining tariff calculation contracts.
 * Demonstrates Java interface principles (Unit 2, 25ITT32).
 * 
 * @author Kanishka K (Reg No: 732925ITR045, Class: 25IT3A)
 */
public interface TariffCalculationService {
    double calculateEnergyCharges(double units, ConnectionType connectionType);
    double getFixedCharges(ConnectionType connectionType);
    double calculateTaxAmount(double energyCharges, double fixedCharges, ConnectionType connectionType);
    double calculateTotalBill(double units, ConnectionType connectionType);
}
