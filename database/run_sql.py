"""
================================================================================
DATABASE MANAGEMENT SYSTEMS (25ITT31) - SQL RUNNER & TABLE VIEWER
Student: Kanishka K | Register No: 732925ITR044 | Class: 25IT3A
Institution: Velalar College of Engineering and Technology, Erode - 12
================================================================================
This script creates a local SQLite database, executes the schema, loads sample data,
runs all advanced analytical queries, and prints formatted tables to the console.
Requires ZERO setup and runs on any computer with Python!
"""

import sqlite3
import os
import pandas as pd

pd.set_option('display.max_columns', None)
pd.set_option('display.width', 1000)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DB_FILE = os.path.join(BASE_DIR, "electricity_system.db")

def init_database():
    if os.path.exists(DB_FILE):
        os.remove(DB_FILE)
    
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()

    # Create Tables
    cursor.executescript("""
    -- 1. Tariff Plans
    CREATE TABLE tariff_plans (
        tariff_id INTEGER PRIMARY KEY AUTOINCREMENT,
        connection_type TEXT NOT NULL UNIQUE,
        fixed_charge REAL NOT NULL DEFAULT 0.0,
        rate_slab_1 REAL NOT NULL,
        rate_slab_2 REAL NOT NULL,
        rate_slab_3 REAL NOT NULL,
        rate_slab_4 REAL NOT NULL,
        rate_slab_above REAL NOT NULL,
        tax_percentage REAL NOT NULL DEFAULT 5.0,
        description TEXT
    );

    -- 2. Consumers
    CREATE TABLE consumers (
        consumer_id INTEGER PRIMARY KEY AUTOINCREMENT,
        consumer_number TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        city TEXT NOT NULL DEFAULT 'Erode',
        pin_code TEXT NOT NULL,
        connection_type TEXT NOT NULL,
        meter_number TEXT NOT NULL UNIQUE,
        sanctioned_load_kw REAL NOT NULL DEFAULT 1.0,
        connection_date TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'ACTIVE'
    );

    -- 3. Meter Readings
    CREATE TABLE meter_readings (
        reading_id INTEGER PRIMARY KEY AUTOINCREMENT,
        consumer_id INTEGER NOT NULL,
        billing_month TEXT NOT NULL,
        reading_date TEXT NOT NULL,
        previous_reading REAL NOT NULL,
        current_reading REAL NOT NULL,
        units_consumed REAL NOT NULL,
        meter_reader_name TEXT DEFAULT 'Automated System',
        FOREIGN KEY (consumer_id) REFERENCES consumers(consumer_id)
    );

    -- 4. Bills
    CREATE TABLE bills (
        bill_id INTEGER PRIMARY KEY AUTOINCREMENT,
        bill_number TEXT NOT NULL UNIQUE,
        reading_id INTEGER NOT NULL UNIQUE,
        consumer_id INTEGER NOT NULL,
        billing_month TEXT NOT NULL,
        units_consumed REAL NOT NULL,
        energy_charges REAL NOT NULL,
        fixed_charges REAL NOT NULL,
        tax_amount REAL NOT NULL,
        total_bill_amount REAL NOT NULL,
        bill_date TEXT NOT NULL,
        due_date TEXT NOT NULL,
        payment_status TEXT NOT NULL DEFAULT 'UNPAID',
        payment_date TEXT,
        FOREIGN KEY (reading_id) REFERENCES meter_readings(reading_id),
        FOREIGN KEY (consumer_id) REFERENCES consumers(consumer_id)
    );

    -- 5. Audit Logs
    CREATE TABLE audit_logs (
        log_id INTEGER PRIMARY KEY AUTOINCREMENT,
        action_type TEXT NOT NULL,
        consumer_id INTEGER,
        description TEXT NOT NULL,
        log_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    """)

    # Load Tariff Plans
    cursor.executescript("""
    INSERT INTO tariff_plans (connection_type, fixed_charge, rate_slab_1, rate_slab_2, rate_slab_3, rate_slab_4, rate_slab_above, tax_percentage, description) VALUES
    ('Domestic', 35.00, 0.00, 2.25, 4.50, 6.00, 8.00, 5.00, 'Residential slab: 0-100 free, 101-200 @2.25, 201-400 @4.50, >500 @8.00'),
    ('Commercial', 120.00, 5.50, 6.75, 7.50, 8.50, 9.50, 12.00, 'Commercial shops, retail outlets, and offices'),
    ('Industrial', 250.00, 7.00, 7.50, 8.00, 8.50, 9.00, 18.00, 'Small & medium manufacturing and textile units in Erode'),
    ('Agricultural', 0.00, 0.00, 0.00, 1.20, 1.50, 2.00, 0.00, 'Subsidized pump-set and agricultural irrigation');
    """)

    # Load Consumers
    consumers_data = [
        ('EB-2026-1001', 'Kanishka K', 'kanishka.k@vcet.ac.in', '9842100001', '14 Thindal Hills, Perundurai Road', 'Erode', '638012', 'Domestic', 'MTR-ERD-8801', 3.00, '2024-01-15', 'ACTIVE'),
        ('EB-2026-1002', 'Aravind Swaminathan', 'aravind.s@gmail.com', '9842100002', '27 Brough Road, Near Clock Tower', 'Erode', '638001', 'Commercial', 'MTR-ERD-8802', 5.00, '2023-05-10', 'ACTIVE'),
        ('EB-2026-1003', 'Ramasamy Textiles Pvt Ltd', 'contact@ramasamytextiles.com', '9842100003', 'Plot 45 SIPCOT Industrial Estate', 'Perundurai', '638052', 'Industrial', 'MTR-ERD-8803', 25.00, '2022-11-20', 'ACTIVE'),
        ('EB-2026-1004', 'Muthusamy Farm', 'muthusamy.agri@outlook.com', '9842100004', 'Survey No 112/4, Modakkurichi', 'Erode', '638104', 'Agricultural', 'MTR-ERD-8804', 7.50, '2021-03-12', 'ACTIVE'),
        ('EB-2026-1005', 'Deepa Jayaram', 'deepa.j@yahoo.com', '9842100005', '56 Sampath Nagar Extension', 'Erode', '638011', 'Domestic', 'MTR-ERD-8805', 2.00, '2024-06-01', 'ACTIVE'),
        ('EB-2026-1006', 'Kavitha Murugesan', 'kavitha.m@gmail.com', '9842100006', '88 Gandhiji Road, Surampatti', 'Erode', '638009', 'Domestic', 'MTR-ERD-8806', 4.00, '2023-08-14', 'ACTIVE'),
        ('EB-2026-1007', 'Kongu Supermarket', 'kongu.supermarket@gmail.com', '9842100007', '12 Sathy Road, Veerappanchatram', 'Erode', '638004', 'Commercial', 'MTR-ERD-8807', 10.00, '2022-02-18', 'ACTIVE'),
        ('EB-2026-1008', 'Suresh Kumar Spinnings', 'suresh.spin@rediffmail.com', '9842100008', 'Village Road, Chithode', 'Erode', '638102', 'Industrial', 'MTR-ERD-8808', 35.00, '2021-09-05', 'ACTIVE')
    ]
    cursor.executemany("""
    INSERT INTO consumers (consumer_number, name, email, phone, address, city, pin_code, connection_type, meter_number, sanctioned_load_kw, connection_date, status)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, consumers_data)

    # Load Readings
    readings_data = [
        (1, '2026-08', '2026-08-01', 1200.0, 1420.0, 220.0, 'S. Murugan'),
        (2, '2026-08', '2026-08-01', 4500.0, 5150.0, 650.0, 'S. Murugan'),
        (3, '2026-08', '2026-08-01', 15200.0, 19800.0, 4600.0, 'K. Selvam'),
        (4, '2026-08', '2026-08-01', 3400.0, 3750.0, 350.0, 'K. Selvam'),
        (5, '2026-08', '2026-08-01', 890.0, 975.0, 85.0, 'S. Murugan'),
        (6, '2026-08', '2026-08-01', 2300.0, 2890.0, 590.0, 'S. Murugan'),
        (7, '2026-08', '2026-08-01', 6100.0, 7350.0, 1250.0, 'R. Prakash'),
        (8, '2026-08', '2026-08-01', 21000.0, 28200.0, 7200.0, 'K. Selvam')
    ]
    cursor.executemany("""
    INSERT INTO meter_readings (consumer_id, billing_month, reading_date, previous_reading, current_reading, units_consumed, meter_reader_name)
    VALUES (?, ?, ?, ?, ?, ?, ?)
    """, readings_data)

    # Load Bills
    bills_data = [
        ('BILL-2026-08-001', 1, 1, '2026-08', 220.0, 315.00, 35.00, 17.50, 367.50, '2026-08-03', '2026-08-20', 'PAID'),
        ('BILL-2026-08-002', 2, 2, '2026-08', 650.0, 4950.00, 120.00, 608.40, 5678.40, '2026-08-03', '2026-08-20', 'PAID'),
        ('BILL-2026-08-003', 3, 3, '2026-08', 4600.0, 38500.00, 250.00, 6975.00, 45725.00, '2026-08-03', '2026-08-20', 'PAID'),
        ('BILL-2026-08-004', 4, 4, '2026-08', 350.0, 180.00, 0.00, 0.00, 180.00, '2026-08-03', '2026-08-20', 'PAID'),
        ('BILL-2026-08-005', 5, 5, '2026-08', 85.0, 0.00, 35.00, 1.75, 36.75, '2026-08-03', '2026-08-20', 'PAID'),
        ('BILL-2026-08-006', 6, 6, '2026-08', 590.0, 2445.00, 35.00, 124.00, 2604.00, '2026-08-03', '2026-08-20', 'OVERDUE')
    ]
    cursor.executemany("""
    INSERT INTO bills (bill_number, reading_id, consumer_id, billing_month, units_consumed, energy_charges, fixed_charges, tax_amount, total_bill_amount, bill_date, due_date, payment_status)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, bills_data)

    conn.commit()
    conn.close()

def run_query_and_print(title, query):
    print("\n" + "=" * 90)
    print(f" {title}")
    print("=" * 90)
    print(f"[SQL QUERY]:\n{query.strip()}\n")
    conn = sqlite3.connect(DB_FILE)
    df = pd.read_sql_query(query, conn)
    conn.close()
    print(df.to_string(index=False))

def main():
    print("*" * 90)
    print(" VELALAR COLLEGE OF ENGINEERING AND TECHNOLOGY | DEPARTMENT OF IT")
    print(" 25ITT31 - DATABASE MANAGEMENT SYSTEMS: SQL QUERY RUNNER")
    print(" Student: Kanishka K | Register No: 732925ITR044 | Class: 25IT3A")
    print("*" * 90)

    init_database()
    print(f"\n[OK] Database initialized successfully at: {DB_FILE}")

    # 1. SHOW TABLES
    run_query_and_print(
        "1. SHOW TABLES (All Relational Entities in Schema)",
        "SELECT name AS table_name, type FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';"
    )

    # 2. TABLE CONTENTS: CONSUMERS
    run_query_and_print(
        "2. TABLE DATA: consumers (Sample Registered Accounts)",
        "SELECT consumer_id, consumer_number, name, connection_type, meter_number, sanctioned_load_kw, status FROM consumers LIMIT 6;"
    )

    # 3. TABLE CONTENTS: TARIFF_PLANS
    run_query_and_print(
        "3. TABLE DATA: tariff_plans (Predefined Slabs & Charges)",
        "SELECT tariff_id, connection_type, fixed_charge, rate_slab_1, rate_slab_2, rate_slab_3, rate_slab_above, tax_percentage FROM tariff_plans;"
    )

    # 4. JOIN QUERY: CONSUMERS + READINGS + BILLS
    run_query_and_print(
        "4. JOIN QUERY: Monthly Consumer Bills Summary (Consumers + MeterReadings + Bills)",
        """
        SELECT 
            c.consumer_number,
            c.name,
            c.connection_type,
            mr.billing_month,
            mr.units_consumed,
            b.total_bill_amount,
            b.payment_status
        FROM consumers c
        JOIN meter_readings mr ON c.consumer_id = mr.consumer_id
        LEFT JOIN bills b ON mr.reading_id = b.reading_id
        ORDER BY mr.units_consumed DESC;
        """
    )

    # 5. HIGH-CONSUMPTION DETECTION QUERY
    run_query_and_print(
        "5. SCENARIO 14 REQUIREMENT 5: High-Consumption Consumers Alert Query",
        """
        SELECT 
            c.consumer_number,
            c.name,
            c.connection_type,
            mr.billing_month,
            mr.units_consumed,
            CASE 
                WHEN c.connection_type = 'Domestic' AND mr.units_consumed > 400 THEN 'ALERT: High Domestic Usage (>400)'
                WHEN c.connection_type = 'Commercial' AND mr.units_consumed > 1000 THEN 'ALERT: High Commercial Usage (>1000)'
                WHEN c.connection_type = 'Industrial' AND mr.units_consumed > 4000 THEN 'ALERT: High Industrial Usage (>4000)'
                ELSE 'Normal Usage'
            END AS alert_status
        FROM consumers c
        JOIN meter_readings mr ON c.consumer_id = mr.consumer_id
        WHERE (c.connection_type = 'Domestic' AND mr.units_consumed > 400)
           OR (c.connection_type = 'Commercial' AND mr.units_consumed > 1000)
           OR (c.connection_type = 'Industrial' AND mr.units_consumed > 4000);
        """
    )

    # 6. CATEGORY AGGREGATION & REVENUE
    run_query_and_print(
        "6. AGGREGATE QUERY: Total Energy (kWh) and Revenue by Connection Type",
        """
        SELECT 
            c.connection_type,
            COUNT(DISTINCT c.consumer_id) AS total_consumers,
            SUM(mr.units_consumed) AS total_kwh,
            ROUND(AVG(mr.units_consumed), 2) AS avg_kwh,
            ROUND(SUM(b.total_bill_amount), 2) AS total_revenue_inr
        FROM consumers c
        JOIN meter_readings mr ON c.consumer_id = mr.consumer_id
        JOIN bills b ON mr.reading_id = b.reading_id
        GROUP BY c.connection_type;
        """
    )

    # 7. RANKING USING WINDOW FUNCTION
    run_query_and_print(
        "7. WINDOW FUNCTION: DENSE_RANK() by Consumption within Category",
        """
        SELECT 
            c.consumer_number,
            c.name,
            c.connection_type,
            mr.units_consumed,
            DENSE_RANK() OVER (PARTITION BY c.connection_type ORDER BY mr.units_consumed DESC) AS category_rank
        FROM consumers c
        JOIN meter_readings mr ON c.consumer_id = mr.consumer_id;
        """
    )

    print("\n" + "=" * 90)
    print(" >>> ALL SQL QUERIES EXECUTED AND TABLES DISPLAYED SUCCESSFULLY! <<<")
    print("=" * 90)

if __name__ == "__main__":
    main()
