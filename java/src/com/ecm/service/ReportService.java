package com.ecm.service;

import com.ecm.model.Bill;
import com.ecm.model.ConnectionType;
import com.ecm.model.Consumer;
import com.ecm.model.MeterReading;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Service for generating statistical reports and high-consumption analytics.
 * Heavily utilizes Java 8+ Stream API, Lambdas, and Collectors (Unit 5, 25ITT32).
 * 
 * @author Kanishka K (Reg No: 732925ITR045, Class: 25IT3A)
 */
public class ReportService {

    /**
     * Identifies consumers exceeding a specific consumption threshold.
     * Uses Stream filter(), map(), sorted(), and collect().
     */
    public List<MeterReading> getHighConsumptionReadings(List<MeterReading> readings, double thresholdUnits) {
        return readings.stream()
                .filter(r -> r.getUnitsConsumed() >= thresholdUnits)
                .sorted(Comparator.comparingDouble(MeterReading::getUnitsConsumed).reversed())
                .collect(Collectors.toList());
    }

    /**
     * Categorized High Consumption Alert according to Connection Type
     */
    public boolean isHighConsumption(ConnectionType type, double units) {
        switch (type) {
            case DOMESTIC: return units > 400.0;
            case COMMERCIAL: return units > 1000.0;
            case INDUSTRIAL: return units > 5000.0;
            case AGRICULTURAL: return units > 600.0;
            default: return units > 500.0;
        }
    }

    /**
     * Aggregates total units consumed for a given billing month.
     */
    public double getTotalUnitsForMonth(List<MeterReading> readings, String billingMonth) {
        return readings.stream()
                .filter(r -> r.getBillingMonth().equalsIgnoreCase(billingMonth))
                .mapToDouble(MeterReading::getUnitsConsumed)
                .sum();
    }

    /**
     * Calculates average consumption by Connection Type.
     */
    public Map<ConnectionType, Double> getAverageConsumptionByType(List<Consumer> consumers, List<MeterReading> readings) {
        Map<Integer, ConnectionType> consumerTypeMap = consumers.stream()
                .collect(Collectors.toMap(Consumer::getConsumerId, Consumer::getConnectionType, (a, b) -> a));

        return readings.stream()
                .filter(r -> consumerTypeMap.containsKey(r.getConsumerId()))
                .collect(Collectors.groupingBy(
                        r -> consumerTypeMap.get(r.getConsumerId()),
                        Collectors.averagingDouble(MeterReading::getUnitsConsumed)
                ));
    }

    /**
     * Formats and prints a monthly summary table to console.
     */
    public void printMonthlySummary(String billingMonth, List<Consumer> consumers, List<MeterReading> readings, List<Bill> bills) {
        Map<Integer, Consumer> consumerMap = consumers.stream()
                .collect(Collectors.toMap(Consumer::getConsumerId, c -> c, (a, b) -> a));

        System.out.println("==========================================================================================");
        System.out.printf("                    MONTHLY CONSUMPTION & BILLING REPORT: %s\n", billingMonth);
        System.out.println("==========================================================================================");
        System.out.printf("%-14s | %-20s | %-12s | %-10s | %-12s | %-10s\n", 
                "Consumer No", "Name", "Type", "Units (kWh)", "Bill (INR)", "Status");
        System.out.println("------------------------------------------------------------------------------------------");

        double totalUnits = 0.0;
        double totalBilled = 0.0;

        for (MeterReading r : readings) {
            if (r.getBillingMonth().equalsIgnoreCase(billingMonth)) {
                Consumer c = consumerMap.get(r.getConsumerId());
                String cName = c != null ? c.getName() : "Unknown";
                String cNum = c != null ? c.getConsumerNumber() : "N/A";
                String cType = c != null ? c.getConnectionType().name() : "N/A";

                Optional<Bill> matchingBill = bills.stream()
                        .filter(b -> b.getReadingId() == r.getReadingId())
                        .findFirst();

                double billAmt = matchingBill.map(Bill::getTotalBillAmount).orElse(0.0);
                String status = matchingBill.map(Bill::getPaymentStatus).orElse("PENDING");

                totalUnits += r.getUnitsConsumed();
                totalBilled += billAmt;

                System.out.printf("%-14s | %-20s | %-12s | %10.2f | %12.2f | %-10s\n",
                        cNum, cName, cType, r.getUnitsConsumed(), billAmt, status);
            }
        }
        System.out.println("------------------------------------------------------------------------------------------");
        System.out.printf(" TOTAL SUMMARY: %-37s | %10.2f | %12.2f |\n", "", totalUnits, totalBilled);
        System.out.println("==========================================================================================\n");
    }
}
