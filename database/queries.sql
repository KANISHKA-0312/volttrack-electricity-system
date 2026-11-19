-- =====================================================================
-- DATABASE MANAGEMENT SYSTEMS (25ITT31)
-- Scenario 14: Comprehensive SQL Queries, Views, Triggers, & Procedures
-- Student: Kanishka K | Register No: 732925ITR044 | Class: 25IT3A
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. DATABASE VIEWS
-- ---------------------------------------------------------------------

-- View 1: Consumer Monthly Billing Summary
CREATE OR REPLACE VIEW view_consumer_monthly_summary AS
SELECT 
    c.consumer_id,
    c.consumer_number,
    c.name AS consumer_name,
    c.connection_type,
    c.meter_number,
    mr.billing_month,
    mr.previous_reading,
    mr.current_reading,
    mr.units_consumed,
    b.bill_number,
    b.total_bill_amount,
    b.payment_status,
    b.due_date
FROM consumers c
JOIN meter_readings mr ON c.consumer_id = mr.consumer_id
LEFT JOIN bills b ON mr.reading_id = b.reading_id;

-- View 2: High Consumption Consumers (Threshold: > 500 units for Domestic, > 1000 for Commercial, > 5000 for Industrial)
CREATE OR REPLACE VIEW view_high_consumption_consumers AS
SELECT 
    c.consumer_number,
    c.name,
    c.phone,
    c.connection_type,
    mr.billing_month,
    mr.units_consumed,
    CASE 
        WHEN c.connection_type = 'Domestic' AND mr.units_consumed > 400 THEN 'ALERT: Excessive Domestic Usage'
        WHEN c.connection_type = 'Commercial' AND mr.units_consumed > 1000 THEN 'ALERT: High Commercial Demand'
        WHEN c.connection_type = 'Industrial' AND mr.units_consumed > 6000 THEN 'ALERT: Heavy Industrial Load'
        ELSE 'Normal Consumption'
    END AS alert_status
FROM consumers c
JOIN meter_readings mr ON c.consumer_id = mr.consumer_id
WHERE (c.connection_type = 'Domestic' AND mr.units_consumed > 400)
   OR (c.connection_type = 'Commercial' AND mr.units_consumed > 1000)
   OR (c.connection_type = 'Industrial' AND mr.units_consumed > 6000);

-- View 3: Connection Type Analytics & Revenue Summary
CREATE OR REPLACE VIEW view_connection_type_revenue AS
SELECT 
    c.connection_type,
    COUNT(DISTINCT c.consumer_id) AS total_consumers,
    COUNT(mr.reading_id) AS total_readings,
    SUM(mr.units_consumed) AS total_energy_consumed_kwh,
    AVG(mr.units_consumed) AS avg_energy_consumed_kwh,
    COALESCE(SUM(b.total_bill_amount), 0.00) AS total_billed_amount,
    COALESCE(SUM(CASE WHEN b.payment_status = 'PAID' THEN b.total_bill_amount ELSE 0 END), 0.00) AS total_collected_revenue
FROM consumers c
LEFT JOIN meter_readings mr ON c.consumer_id = mr.consumer_id
LEFT JOIN bills b ON mr.reading_id = b.reading_id
GROUP BY c.connection_type;

-- ---------------------------------------------------------------------
-- 2. ADVANCED SQL QUERIES (Covering Unit 2 & 3 of Syllabus 25ITT31)
-- ---------------------------------------------------------------------

-- Query 1: Retrieve all consumer bills for a given month with join and calculation
SELECT 
    c.consumer_number,
    c.name,
    c.connection_type,
    mr.billing_month,
    mr.units_consumed,
    b.total_bill_amount,
    b.payment_status
FROM consumers c
INNER JOIN meter_readings mr ON c.consumer_id = mr.consumer_id
INNER JOIN bills b ON mr.reading_id = b.reading_id
WHERE mr.billing_month = '2026-08'
ORDER BY mr.units_consumed DESC;

-- Query 2: Ranking Consumers by Consumption using Window Function (DENSE_RANK)
SELECT 
    c.consumer_number,
    c.name,
    c.connection_type,
    mr.billing_month,
    mr.units_consumed,
    DENSE_RANK() OVER (PARTITION BY c.connection_type ORDER BY mr.units_consumed DESC) AS rank_within_category
FROM consumers c
JOIN meter_readings mr ON c.consumer_id = mr.consumer_id
WHERE mr.billing_month = '2026-08';

-- Query 3: Consumers whose consumption is higher than their category's average (Correlated Subquery)
SELECT 
    c.consumer_number,
    c.name,
    c.connection_type,
    mr.units_consumed,
    (SELECT ROUND(AVG(mr2.units_consumed), 2)
     FROM meter_readings mr2 
     JOIN consumers c2 ON mr2.consumer_id = c2.consumer_id 
     WHERE c2.connection_type = c.connection_type AND mr2.billing_month = mr.billing_month
    ) AS category_avg_units
FROM consumers c
JOIN meter_readings mr ON c.consumer_id = mr.consumer_id
WHERE mr.units_consumed > (
    SELECT AVG(mr2.units_consumed)
    FROM meter_readings mr2 
    JOIN consumers c2 ON mr2.consumer_id = c2.consumer_id 
    WHERE c2.connection_type = c.connection_type AND mr2.billing_month = mr.billing_month
)
AND mr.billing_month = '2026-08';

-- Query 4: Month-over-Month Consumption Growth using LAG() Window Function
SELECT 
    c.consumer_number,
    c.name,
    mr.billing_month,
    mr.units_consumed AS current_month_units,
    LAG(mr.units_consumed, 1) OVER (PARTITION BY c.consumer_id ORDER BY mr.billing_month) AS previous_month_units,
    ROUND(mr.units_consumed - LAG(mr.units_consumed, 1) OVER (PARTITION BY c.consumer_id ORDER BY mr.billing_month), 2) AS units_variance,
    ROUND(((mr.units_consumed - LAG(mr.units_consumed, 1) OVER (PARTITION BY c.consumer_id ORDER BY mr.billing_month)) / 
           NULLIF(LAG(mr.units_consumed, 1) OVER (PARTITION BY c.consumer_id ORDER BY mr.billing_month), 0)) * 100, 2) AS percentage_change
FROM consumers c
JOIN meter_readings mr ON c.consumer_id = mr.consumer_id
ORDER BY c.consumer_id, mr.billing_month;

-- Query 5: Outstanding and Unpaid Bills Report
SELECT 
    b.bill_number,
    c.consumer_number,
    c.name,
    c.phone,
    b.billing_month,
    b.total_bill_amount,
    b.due_date,
    DATEDIFF(CURRENT_DATE, b.due_date) AS days_overdue
FROM bills b
JOIN consumers c ON b.consumer_id = c.consumer_id
WHERE b.payment_status IN ('UNPAID', 'OVERDUE')
ORDER BY b.due_date ASC;

-- ---------------------------------------------------------------------
-- 3. TRIGGERS FOR INTEGRITY AND AUDIT LOGGING
-- ---------------------------------------------------------------------

-- Trigger 1: Automatic Audit Logging on New Consumer Registration
DELIMITER //
CREATE TRIGGER trg_after_consumer_insert
AFTER INSERT ON consumers
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (action_type, consumer_id, description)
    VALUES ('CONSUMER_REGISTERED', NEW.consumer_id, 
            CONCAT('New consumer registered: ', NEW.name, ' (', NEW.consumer_number, '), Type: ', NEW.connection_type));
END;
//
DELIMITER ;

-- Trigger 2: Prevent Meter Tampering / Invalid Decreasing Reading
DELIMITER //
CREATE TRIGGER trg_before_reading_insert
BEFORE INSERT ON meter_readings
FOR EACH ROW
BEGIN
    IF NEW.current_reading < NEW.previous_reading THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Current meter reading cannot be less than previous meter reading.';
    END IF;
END;
//
DELIMITER ;
