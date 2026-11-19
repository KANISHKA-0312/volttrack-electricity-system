package com.ecm.model;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * Entity representing an itemized electricity bill.
 * Contains units consumed, slab breakdowns, charges, and payment status.
 * 
 * @author Kanishka K (Reg No: 732925ITR044, Class: 25IT3A)
 */
public class Bill implements Serializable {
    private static final long serialVersionUID = 1L;

    private int billId;
    private String billNumber;
    private int readingId;
    private int consumerId;
    private String consumerName;
    private ConnectionType connectionType;
    private String billingMonth;
    private double unitsConsumed;
    private double energyCharges;
    private double fixedCharges;
    private double taxAmount;
    private double totalBillAmount;
    private LocalDate billDate;
    private LocalDate dueDate;
    private String paymentStatus; // PAID, UNPAID, OVERDUE

    public Bill() {
        this.billDate = LocalDate.now();
        this.dueDate = LocalDate.now().plusDays(15);
        this.paymentStatus = "UNPAID";
    }

    public Bill(int billId, String billNumber, int readingId, int consumerId, String consumerName,
                ConnectionType connectionType, String billingMonth, double unitsConsumed, 
                double energyCharges, double fixedCharges, double taxAmount, double totalBillAmount) {
        this.billId = billId;
        this.billNumber = billNumber;
        this.readingId = readingId;
        this.consumerId = consumerId;
        this.consumerName = consumerName;
        this.connectionType = connectionType;
        this.billingMonth = billingMonth;
        this.unitsConsumed = unitsConsumed;
        this.energyCharges = energyCharges;
        this.fixedCharges = fixedCharges;
        this.taxAmount = taxAmount;
        this.totalBillAmount = totalBillAmount;
        this.billDate = LocalDate.now();
        this.dueDate = LocalDate.now().plusDays(15);
        this.paymentStatus = "UNPAID";
    }

    // Getters and Setters
    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public String getBillNumber() { return billNumber; }
    public void setBillNumber(String billNumber) { this.billNumber = billNumber; }

    public int getReadingId() { return readingId; }
    public void setReadingId(int readingId) { this.readingId = readingId; }

    public int getConsumerId() { return consumerId; }
    public void setConsumerId(int consumerId) { this.consumerId = consumerId; }

    public String getConsumerName() { return consumerName; }
    public void setConsumerName(String consumerName) { this.consumerName = consumerName; }

    public ConnectionType getConnectionType() { return connectionType; }
    public void setConnectionType(ConnectionType connectionType) { this.connectionType = connectionType; }

    public String getBillingMonth() { return billingMonth; }
    public void setBillingMonth(String billingMonth) { this.billingMonth = billingMonth; }

    public double getUnitsConsumed() { return unitsConsumed; }
    public void setUnitsConsumed(double unitsConsumed) { this.unitsConsumed = unitsConsumed; }

    public double getEnergyCharges() { return energyCharges; }
    public void setEnergyCharges(double energyCharges) { this.energyCharges = energyCharges; }

    public double getFixedCharges() { return fixedCharges; }
    public void setFixedCharges(double fixedCharges) { this.fixedCharges = fixedCharges; }

    public double getTaxAmount() { return taxAmount; }
    public void setTaxAmount(double taxAmount) { this.taxAmount = taxAmount; }

    public double getTotalBillAmount() { return totalBillAmount; }
    public void setTotalBillAmount(double totalBillAmount) { this.totalBillAmount = totalBillAmount; }

    public LocalDate getBillDate() { return billDate; }
    public void setBillDate(LocalDate billDate) { this.billDate = billDate; }

    public LocalDate getDueDate() { return dueDate; }
    public void setDueDate(LocalDate dueDate) { this.dueDate = dueDate; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    /**
     * Generates a printable itemized text invoice.
     */
    public String generateInvoiceReceipt() {
        StringBuilder sb = new StringBuilder();
        sb.append("====================================================================\n");
        sb.append("             TAMIL NADU ELECTRICITY DISTRIBUTION BOARD             \n");
        sb.append("                 ELECTRICITY CONSUMPTION INVOICE                    \n");
        sb.append("====================================================================\n");
        sb.append(String.format(" Bill Number    : %-20s Bill Date   : %s\n", billNumber, billDate));
        sb.append(String.format(" Consumer ID    : %-20d Due Date    : %s\n", consumerId, dueDate));
        sb.append(String.format(" Consumer Name  : %-20s Tariff Type : %s\n", consumerName, connectionType));
        sb.append(String.format(" Billing Period : %-20s Status      : %s\n", billingMonth, paymentStatus));
        sb.append("--------------------------------------------------------------------\n");
        sb.append(" CHARGE PARTICULARS                                     AMOUNT (INR)\n");
        sb.append("--------------------------------------------------------------------\n");
        sb.append(String.format(" Units Consumed (kWh)         : %10.2f units\n", unitsConsumed));
        sb.append(String.format(" Energy Charges (Slab Rated)  :                     %12.2f\n", energyCharges));
        sb.append(String.format(" Fixed Standing Charges       :                     %12.2f\n", fixedCharges));
        sb.append(String.format(" Electricity Duty / Tax (5%%)  :                     %12.2f\n", taxAmount));
        sb.append("--------------------------------------------------------------------\n");
        sb.append(String.format(" TOTAL AMOUNT PAYABLE         :                INR  %12.2f\n", totalBillAmount));
        sb.append("====================================================================\n");
        sb.append(" Please pay before due date to avoid disconnection surcharge.\n");
        sb.append(" Powered by: Energy Usage Analysis System (Student: Kanishka K)\n");
        sb.append("====================================================================\n");
        return sb.toString();
    }
}
