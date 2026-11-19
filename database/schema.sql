-- =====================================================================
-- DATABASE MANAGEMENT SYSTEMS (25ITT31)
-- Scenario 14: Electricity Consumption Management and Energy Usage Analysis System
-- Student: Kanishka K | Register No: 732925ITR044 | Class: 25IT3A
-- Institution: Velalar College of Engineering and Technology, Erode - 12
-- =====================================================================

-- Drop existing tables if re-initializing
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS bills;
DROP TABLE IF EXISTS meter_readings;
DROP TABLE IF EXISTS consumers;
DROP TABLE IF EXISTS tariff_plans;

-- ---------------------------------------------------------------------
-- Table 1: tariff_plans (Predefined tariff rates & fixed charges)
-- ---------------------------------------------------------------------
CREATE TABLE tariff_plans (
    tariff_id INT AUTO_INCREMENT PRIMARY KEY,
    connection_type VARCHAR(20) NOT NULL UNIQUE,
    fixed_charge DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    rate_slab_1 DECIMAL(6,2) NOT NULL, -- e.g. 0-100 units
    rate_slab_2 DECIMAL(6,2) NOT NULL, -- e.g. 101-200 units
    rate_slab_3 DECIMAL(6,2) NOT NULL, -- e.g. 201-400 units
    rate_slab_4 DECIMAL(6,2) NOT NULL, -- e.g. 401-500 units
    rate_slab_above DECIMAL(6,2) NOT NULL, -- >500 units
    tax_percentage DECIMAL(4,2) NOT NULL DEFAULT 5.00,
    description VARCHAR(255)
);

-- ---------------------------------------------------------------------
-- Table 2: consumers (Consumer profile and connection details)
-- ---------------------------------------------------------------------
CREATE TABLE consumers (
    consumer_id INT AUTO_INCREMENT PRIMARY KEY,
    consumer_number VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL DEFAULT 'Erode',
    pin_code VARCHAR(10) NOT NULL,
    connection_type VARCHAR(20) NOT NULL,
    meter_number VARCHAR(30) NOT NULL UNIQUE,
    sanctioned_load_kw DECIMAL(5,2) NOT NULL DEFAULT 1.00,
    connection_date DATE NOT NULL,
    status VARCHAR(15) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT chk_conn_type CHECK (connection_type IN ('Domestic', 'Commercial', 'Industrial', 'Agricultural')),
    CONSTRAINT chk_status CHECK (status IN ('ACTIVE', 'DISCONNECTED', 'SUSPENDED'))
);

-- ---------------------------------------------------------------------
-- Table 3: meter_readings (Monthly previous and current meter readings)
-- ---------------------------------------------------------------------
CREATE TABLE meter_readings (
    reading_id INT AUTO_INCREMENT PRIMARY KEY,
    consumer_id INT NOT NULL,
    billing_month VARCHAR(7) NOT NULL, -- Format: YYYY-MM
    reading_date DATE NOT NULL,
    previous_reading DECIMAL(10,2) NOT NULL,
    current_reading DECIMAL(10,2) NOT NULL,
    units_consumed DECIMAL(10,2) GENERATED ALWAYS AS (current_reading - previous_reading) STORED,
    meter_reader_name VARCHAR(60) DEFAULT 'Automated System',
    CONSTRAINT fk_readings_consumer FOREIGN KEY (consumer_id) REFERENCES consumers(consumer_id) ON DELETE CASCADE,
    CONSTRAINT chk_readings CHECK (current_reading >= previous_reading),
    CONSTRAINT uk_consumer_month UNIQUE (consumer_id, billing_month)
);

-- ---------------------------------------------------------------------
-- Table 4: bills (Calculated electricity bills and payment status)
-- ---------------------------------------------------------------------
CREATE TABLE bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_number VARCHAR(25) NOT NULL UNIQUE,
    reading_id INT NOT NULL UNIQUE,
    consumer_id INT NOT NULL,
    billing_month VARCHAR(7) NOT NULL,
    units_consumed DECIMAL(10,2) NOT NULL,
    energy_charges DECIMAL(10,2) NOT NULL,
    fixed_charges DECIMAL(8,2) NOT NULL,
    tax_amount DECIMAL(8,2) NOT NULL,
    total_bill_amount DECIMAL(10,2) NOT NULL,
    bill_date DATE NOT NULL,
    due_date DATE NOT NULL,
    payment_status VARCHAR(15) NOT NULL DEFAULT 'UNPAID',
    payment_date DATE NULL,
    CONSTRAINT fk_bills_reading FOREIGN KEY (reading_id) REFERENCES meter_readings(reading_id) ON DELETE CASCADE,
    CONSTRAINT fk_bills_consumer FOREIGN KEY (consumer_id) REFERENCES consumers(consumer_id) ON DELETE CASCADE,
    CONSTRAINT chk_payment_status CHECK (payment_status IN ('PAID', 'UNPAID', 'OVERDUE'))
);

-- ---------------------------------------------------------------------
-- Table 5: audit_logs (System event tracking and change history)
-- ---------------------------------------------------------------------
CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(30) NOT NULL,
    consumer_id INT,
    description TEXT NOT NULL,
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- Indexes for Query Performance Optimization
-- ---------------------------------------------------------------------
CREATE INDEX idx_consumer_type ON consumers(connection_type);
CREATE INDEX idx_reading_month ON meter_readings(billing_month);
CREATE INDEX idx_bills_status ON bills(payment_status);
CREATE INDEX idx_bills_month ON bills(billing_month);
CREATE INDEX idx_reading_units ON meter_readings(units_consumed);
