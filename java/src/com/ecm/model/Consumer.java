package com.ecm.model;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * Consumer entity representing an electricity customer.
 * Demonstrates OOP encapsulation, constructors, and access control.
 * 
 * @author Kanishka K (Reg No: 732925ITR044, Class: 25IT3A)
 */
public class Consumer implements Serializable {
    private static final long serialVersionUID = 1L;

    private int consumerId;
    private String consumerNumber;
    private String name;
    private String email;
    private String phone;
    private String address;
    private String city;
    private String pinCode;
    private ConnectionType connectionType;
    private String meterNumber;
    private double sanctionedLoadKw;
    private LocalDate connectionDate;
    private String status;

    // Default constructor
    public Consumer() {
        this.status = "ACTIVE";
        this.city = "Erode";
        this.connectionDate = LocalDate.now();
    }

    // Parameterized constructor
    public Consumer(int consumerId, String consumerNumber, String name, String email, String phone, 
                    String address, String city, String pinCode, ConnectionType connectionType, 
                    String meterNumber, double sanctionedLoadKw) {
        this.consumerId = consumerId;
        this.consumerNumber = consumerNumber;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.city = city;
        this.pinCode = pinCode;
        this.connectionType = connectionType;
        this.meterNumber = meterNumber;
        this.sanctionedLoadKw = sanctionedLoadKw;
        this.connectionDate = LocalDate.now();
        this.status = "ACTIVE";
    }

    // Getters and Setters
    public int getConsumerId() { return consumerId; }
    public void setConsumerId(int consumerId) { this.consumerId = consumerId; }

    public String getConsumerNumber() { return consumerNumber; }
    public void setConsumerNumber(String consumerNumber) { this.consumerNumber = consumerNumber; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getPinCode() { return pinCode; }
    public void setPinCode(String pinCode) { this.pinCode = pinCode; }

    public ConnectionType getConnectionType() { return connectionType; }
    public void setConnectionType(ConnectionType connectionType) { this.connectionType = connectionType; }

    public String getMeterNumber() { return meterNumber; }
    public void setMeterNumber(String meterNumber) { this.meterNumber = meterNumber; }

    public double getSanctionedLoadKw() { return sanctionedLoadKw; }
    public void setSanctionedLoadKw(double sanctionedLoadKw) { this.sanctionedLoadKw = sanctionedLoadKw; }

    public LocalDate getConnectionDate() { return connectionDate; }
    public void setConnectionDate(LocalDate connectionDate) { this.connectionDate = connectionDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return String.format("[%s] %-22s | Type: %-12s | Meter: %-12s | Phone: %s",
                consumerNumber, name, connectionType.name(), meterNumber, phone);
    }
}
