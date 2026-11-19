-- =====================================================================
-- DATABASE MANAGEMENT SYSTEMS (25ITT31)
-- Scenario 14: Sample Dataset for Electricity Consumption System
-- Student: Kanishka K | Register No: 732925ITR044 | Class: 25IT3A
-- =====================================================================

-- 1. Insert Tariff Plans (TANGEDCO / Standard Electricity Board Slab Model)
INSERT INTO tariff_plans (connection_type, fixed_charge, rate_slab_1, rate_slab_2, rate_slab_3, rate_slab_4, rate_slab_above, tax_percentage, description) VALUES
('Domestic', 35.00, 0.00, 2.25, 4.50, 6.00, 8.00, 5.00, 'Residential slab: 0-100 free, 101-200 @2.25, 201-400 @4.50, 401-500 @6.00, >500 @8.00'),
('Commercial', 120.00, 5.50, 6.75, 7.50, 8.50, 9.50, 12.00, 'Commercial shops, retail outlets, and offices'),
('Industrial', 250.00, 7.00, 7.50, 8.00, 8.50, 9.00, 18.00, 'Small & medium manufacturing and textile units in Erode'),
('Agricultural', 0.00, 0.00, 0.00, 1.20, 1.50, 2.00, 0.00, 'Subsidized pump-set and agricultural irrigation');

-- 2. Insert Consumers (Diverse consumers across Erode, Tamil Nadu)
INSERT INTO consumers (consumer_number, name, email, phone, address, city, pin_code, connection_type, meter_number, sanctioned_load_kw, connection_date, status) VALUES
('EB-2026-1001', 'Kanishka K', 'kanishka.k@vcet.ac.in', '9842100001', '14 Thindal Hills, Perundurai Road', 'Erode', '638012', 'Domestic', 'MTR-ERD-8801', 3.00, '2024-01-15', 'ACTIVE'),
('EB-2026-1002', 'Aravind Swaminathan', 'aravind.s@gmail.com', '9842100002', '27 Brough Road, Near Clock Tower', 'Erode', '638001', 'Commercial', 'MTR-ERD-8802', 5.00, '2023-05-10', 'ACTIVE'),
('EB-2026-1003', 'Ramasamy Textiles Pvt Ltd', 'contact@ramasamytextiles.com', '9842100003', 'Plot 45 SIPCOT Industrial Estate', 'Perundurai', '638052', 'Industrial', 'MTR-ERD-8803', 25.00, '2022-11-20', 'ACTIVE'),
('EB-2026-1004', 'Muthusamy Farm', 'muthusamy.agri@outlook.com', '9842100004', 'Survey No 112/4, Modakkurichi', 'Erode', '638104', 'Agricultural', 'MTR-ERD-8804', 7.50, '2021-03-12', 'ACTIVE'),
('EB-2026-1005', 'Deepa Jayaram', 'deepa.j@yahoo.com', '9842100005', '56 Sampath Nagar Extension', 'Erode', '638011', 'Domestic', 'MTR-ERD-8805', 2.00, '2024-06-01', 'ACTIVE'),
('EB-2026-1006', 'Kavitha Murugesan', 'kavitha.m@gmail.com', '9842100006', '88 Gandhiji Road, Surampatti', 'Erode', '638009', 'Domestic', 'MTR-ERD-8806', 4.00, '2023-08-14', 'ACTIVE'),
('EB-2026-1007', 'Kongu Supermarket', 'kongu.supermarket@gmail.com', '9842100007', '12 Sathy Road, Veerappanchatram', 'Erode', '638004', 'Commercial', 'MTR-ERD-8807', 10.00, '2022-02-18', 'ACTIVE'),
('EB-2026-1008', 'Suresh Kumar Spinnings', 'suresh.spin@rediffmail.com', '9842100008', 'Village Road, Chithode', 'Erode', '638102', 'Industrial', 'MTR-ERD-8808', 35.00, '2021-09-05', 'ACTIVE'),
('EB-2026-1009', 'Venkatesan Agro Farms', 'venkat.farms@gmail.com', '9842100009', 'Field 19, Chennimalai Road', 'Erode', '638051', 'Agricultural', 'MTR-ERD-8809', 5.00, '2020-07-22', 'ACTIVE'),
('EB-2026-1010', 'Priya Sundaram', 'priya.sundaram@gmail.com', '9842100010', '104 Teachers Colony, Palayapalayam', 'Erode', '638011', 'Domestic', 'MTR-ERD-8810', 2.00, '2024-02-10', 'ACTIVE'),
('EB-2026-1011', 'Rajesh Electronics Store', 'rajesh.electro@gmail.com', '9842100011', '40 Park Road, Municipal Complex', 'Erode', '638001', 'Commercial', 'MTR-ERD-8811', 4.00, '2023-12-01', 'ACTIVE'),
('EB-2026-1012', 'Balamurugan Leather Works', 'contact@balaleather.com', '9842100012', 'Bhavani Main Road, BP Agraharam', 'Erode', '638005', 'Industrial', 'MTR-ERD-8812', 20.00, '2022-04-15', 'ACTIVE'),
('EB-2026-1013', 'Gomathi Narayanan', 'gomathi.n@gmail.com', '9842100013', '23 Rangampalayam Main Road', 'Erode', '638009', 'Domestic', 'MTR-ERD-8813', 3.00, '2023-01-20', 'ACTIVE'),
('EB-2026-1014', 'Naveen Kumar', 'naveen.k@gmail.com', '9842100014', '77 Solar Housing Unit', 'Erode', '638002', 'Domestic', 'MTR-ERD-8814', 2.50, '2024-04-05', 'ACTIVE'),
('EB-2026-1015', 'Erode Central Medical Center', 'admin@erodemedical.org', '9842100015', '15 EVN Road, Railway Station Area', 'Erode', '638003', 'Commercial', 'MTR-ERD-8815', 15.00, '2021-10-30', 'ACTIVE');

-- 3. Insert Meter Readings (Multi-month readings for trend and high-consumption detection)
-- Billing Month: 2026-08
INSERT INTO meter_readings (consumer_id, billing_month, reading_date, previous_reading, current_reading, meter_reader_name) VALUES
(1, '2026-08', '2026-08-01', 1200.00, 1420.00, 'S. Murugan'), -- 220 units (Domestic)
(2, '2026-08', '2026-08-01', 4500.00, 5150.00, 'S. Murugan'), -- 650 units (Commercial)
(3, '2026-08', '2026-08-01', 15200.00, 19800.00, 'K. Selvam'), -- 4600 units (Industrial)
(4, '2026-08', '2026-08-01', 3400.00, 3750.00, 'K. Selvam'), -- 350 units (Agri)
(5, '2026-08', '2026-08-01', 890.00, 975.00, 'S. Murugan'), -- 85 units (Domestic - Low)
(6, '2026-08', '2026-08-01', 2300.00, 2890.00, 'S. Murugan'), -- 590 units (Domestic - High Consumer!)
(7, '2026-08', '2026-08-01', 6100.00, 7350.00, 'R. Prakash'), -- 1250 units (Commercial - High)
(8, '2026-08', '2026-08-01', 21000.00, 28200.00, 'K. Selvam'), -- 7200 units (Industrial - High)
(9, '2026-08', '2026-08-01', 1800.00, 2150.00, 'K. Selvam'), -- 350 units (Agri)
(10, '2026-08', '2026-08-01', 540.00, 710.00, 'S. Murugan'), -- 170 units (Domestic)
(11, '2026-08', '2026-08-01', 2800.00, 3250.00, 'R. Prakash'), -- 450 units (Commercial)
(12, '2026-08', '2026-08-01', 11000.00, 14800.00, 'K. Selvam'), -- 3800 units (Industrial)
(13, '2026-08', '2026-08-01', 1450.00, 1980.00, 'S. Murugan'), -- 530 units (Domestic - High Consumer!)
(14, '2026-08', '2026-08-01', 400.00, 580.00, 'S. Murugan'), -- 180 units (Domestic)
(15, '2026-08', '2026-08-01', 8500.00, 10600.00, 'R. Prakash'); -- 2100 units (Commercial)

-- Billing Month: 2026-09
INSERT INTO meter_readings (consumer_id, billing_month, reading_date, previous_reading, current_reading, meter_reader_name) VALUES
(1, '2026-09', '2026-09-01', 1420.00, 1680.00, 'S. Murugan'), -- 260 units (Domestic)
(2, '2026-09', '2026-09-01', 5150.00, 5890.00, 'S. Murugan'), -- 740 units (Commercial)
(3, '2026-09', '2026-09-01', 19800.00, 24900.00, 'K. Selvam'), -- 5100 units (Industrial)
(4, '2026-09', '2026-09-01', 3750.00, 4120.00, 'K. Selvam'), -- 370 units (Agri)
(5, '2026-09', '2026-09-01', 975.00, 1065.00, 'S. Murugan'), -- 90 units (Domestic - Low)
(6, '2026-09', '2026-09-01', 2890.00, 3540.00, 'S. Murugan'), -- 650 units (Domestic - High Consumer!)
(7, '2026-09', '2026-09-01', 7350.00, 8700.00, 'R. Prakash'), -- 1350 units (Commercial - High)
(8, '2026-09', '2026-09-01', 28200.00, 36100.00, 'K. Selvam'), -- 7900 units (Industrial - High)
(9, '2026-09', '2026-09-01', 2150.00, 2520.00, 'K. Selvam'), -- 370 units (Agri)
(10, '2026-09', '2026-09-01', 710.00, 895.00, 'S. Murugan'), -- 185 units (Domestic)
(11, '2026-09', '2026-09-01', 3250.00, 3720.00, 'R. Prakash'), -- 470 units (Commercial)
(12, '2026-09', '2026-09-01', 14800.00, 18900.00, 'K. Selvam'), -- 4100 units (Industrial)
(13, '2026-09', '2026-09-01', 1980.00, 2560.00, 'S. Murugan'), -- 580 units (Domestic - High Consumer!)
(14, '2026-09', '2026-09-01', 580.00, 775.00, 'S. Murugan'), -- 195 units (Domestic)
(15, '2026-09', '2026-09-01', 10600.00, 12950.00, 'R. Prakash'); -- 2350 units (Commercial)

-- Billing Month: 2026-10
INSERT INTO meter_readings (consumer_id, billing_month, reading_date, previous_reading, current_reading, meter_reader_name) VALUES
(1, '2026-10', '2026-10-01', 1680.00, 1920.00, 'S. Murugan'), -- 240 units
(2, '2026-10', '2026-10-01', 5890.00, 6580.00, 'S. Murugan'), -- 690 units
(3, '2026-10', '2026-10-01', 24900.00, 29750.00, 'K. Selvam'), -- 4850 units
(4, '2026-10', '2026-10-01', 4120.00, 4440.00, 'K. Selvam'), -- 320 units
(5, '2026-10', '2026-10-01', 1065.00, 1160.00, 'S. Murugan'), -- 95 units
(6, '2026-10', '2026-10-01', 3540.00, 4260.00, 'S. Murugan'), -- 720 units (High Domestic)
(7, '2026-10', '2026-10-01', 8700.00, 10120.00, 'R. Prakash'), -- 1420 units
(8, '2026-10', '2026-10-01', 36100.00, 44350.00, 'K. Selvam'), -- 8250 units
(9, '2026-10', '2026-10-01', 2520.00, 2860.00, 'K. Selvam'), -- 340 units
(10, '2026-10', '2026-10-01', 895.00, 1080.00, 'S. Murugan'); -- 185 units

-- 4. Insert Pre-Calculated Bills for Meter Readings
-- Domestic Calculation for Reading 1 (220 units):
-- 0-100: 0 | 101-200: 100*2.25=225 | 201-220: 20*4.50=90. Energy=315, Fixed=35, Tax(5%)=17.50, Total=367.50
INSERT INTO bills (bill_number, reading_id, consumer_id, billing_month, units_consumed, energy_charges, fixed_charges, tax_amount, total_bill_amount, bill_date, due_date, payment_status, payment_date) VALUES
('BILL-2026-08-001', 1, 1, '2026-08', 220.00, 315.00, 35.00, 17.50, 367.50, '2026-08-03', '2026-08-20', 'PAID', '2026-08-14'),
('BILL-2026-08-002', 2, 2, '2026-08', 650.00, 4950.00, 120.00, 608.40, 5678.40, '2026-08-03', '2026-08-20', 'PAID', '2026-08-18'),
('BILL-2026-08-003', 3, 3, '2026-08', 4600.00, 38500.00, 250.00, 6975.00, 45725.00, '2026-08-03', '2026-08-20', 'PAID', '2026-08-19'),
('BILL-2026-08-004', 4, 4, '2026-08', 350.00, 180.00, 0.00, 0.00, 180.00, '2026-08-03', '2026-08-20', 'PAID', '2026-08-10'),
('BILL-2026-08-005', 5, 5, '2026-08', 85.00, 0.00, 35.00, 1.75, 36.75, '2026-08-03', '2026-08-20', 'PAID', '2026-08-12'),
('BILL-2026-08-006', 6, 6, '2026-08', 590.00, 2445.00, 35.00, 124.00, 2604.00, '2026-08-03', '2026-08-20', 'OVERDUE', NULL),
('BILL-2026-08-007', 7, 7, '2026-08', 1250.00, 10250.00, 120.00, 1244.40, 11614.40, '2026-08-03', '2026-08-20', 'PAID', '2026-08-17'),
('BILL-2026-08-008', 8, 8, '2026-08', 7200.00, 61400.00, 250.00, 11097.00, 72747.00, '2026-08-03', '2026-08-20', 'PAID', '2026-08-15'),
('BILL-2026-08-009', 9, 9, '2026-08', 350.00, 180.00, 0.00, 0.00, 180.00, '2026-08-03', '2026-08-20', 'PAID', '2026-08-11'),
('BILL-2026-08-010', 10, 10, '2026-08', 170.00, 157.50, 35.00, 9.63, 202.13, '2026-08-03', '2026-08-20', 'PAID', '2026-08-16'),
('BILL-2026-09-001', 16, 1, '2026-09', 260.00, 495.00, 35.00, 26.50, 556.50, '2026-09-03', '2026-09-20', 'PAID', '2026-09-12'),
('BILL-2026-09-006', 21, 6, '2026-09', 650.00, 2925.00, 35.00, 148.00, 3108.00, '2026-09-03', '2026-09-20', 'UNPAID', NULL),
('BILL-2026-10-001', 31, 1, '2026-10', 240.00, 405.00, 35.00, 22.00, 462.00, '2026-10-03', '2026-10-20', 'UNPAID', NULL);

-- 5. Insert Sample Audit Logs
INSERT INTO audit_logs (action_type, consumer_id, description) VALUES
('SYSTEM_INIT', NULL, 'Database schema initialized and baseline tariff plans configured.'),
('NEW_CONSUMER', 1, 'Consumer Kanishka K registered with Domestic 3.0kW connection.'),
('METER_RECORDED', 1, 'Meter reading recorded for period 2026-08: Previous=1200, Current=1420 (220 Units).'),
('BILL_GENERATED', 1, 'Bill BILL-2026-08-001 generated for Rs. 367.50.');
