# SOFTWARE REQUIREMENTS SPECIFICATION (IEEE 830 STANDARD)
## Scenario 14: Electricity Consumption Management and Energy Usage Analysis System

---

**Institution:** Velalar College of Engineering and Technology, Erode - 12  
**Department:** Department of Information Technology  
**Academic Year:** 2026-27 (ODD) | **Class:** 25IT3A  
**Student Name:** Kanishka K  
**Register Number:** 732925ITR044  
**Assigned Register Number Series:** 14, 44, 74, 104  
**Course Code & Title:** 25ITT33 – Software Engineering  

---

### 1. INTRODUCTION

#### 1.1 Purpose
The purpose of this document is to provide a complete and detailed Software Requirements Specification (SRS) for the **Electricity Consumption Management and Energy Usage Analysis System (VoltTrack)**. It outlines both the functional and non-functional requirements, external interfaces, system architecture, database schema, and verification criteria for the software solution.

#### 1.2 Scope of the System
The system is designed for an electricity distribution office (e.g., TANGEDCO/Electricity Board) to eliminate manual record-keeping errors, automate progressive tariff calculations across diverse connection categories (Domestic, Commercial, Industrial, Agricultural), identify high-consumption patterns, generate itemized consumer invoices, and produce scientific exploratory data analytics using Python and Java.

#### 1.3 Definitions, Acronyms, and Abbreviations
* **EB:** Electricity Board
* **kWh:** Kilowatt-hour (standard unit of electrical energy measurement)
* **TANGEDCO:** Tamil Nadu Generation and Distribution Corporation
* **Slab Tariff:** Progressive tier-based pricing structure where marginal consumption costs escalate across designated unit intervals
* **SRS:** Software Requirements Specification
* **OOP:** Object-Oriented Programming
* **JDBC:** Java Database Connectivity
* **EDA:** Exploratory Data Analysis
* **IQR:** Interquartile Range (statistical outlier detection technique)

#### 1.4 References
1. IEEE Std 830-1998: IEEE Recommended Practice for Software Requirements Specifications.
2. VCET Curriculum & Syllabi: 25ITT31 (DBMS), 25ITT32 (Java), 25ITT33 (SE), 25ITC31 (Data Science).
3. TANGEDCO Tariff Schedule & Regulations for LT Consumers.

---

### 2. OVERALL DESCRIPTION

#### 2.1 Product Perspective
VoltTrack is an integrated 3-Tier enterprise system consisting of:
1. **Presentation Layer:** 24/7 Live responsive Web Dashboard (deployed to GitHub Pages) and an interactive Java Console CLI (`com.ecm.Main`).
2. **Business Logic Layer:** Java OOP billing calculation engine (`BillingService`), Streams API analytical engine (`ReportService`), and client-side JavaScript engine (`tariff.js`).
3. **Data & Analytics Layer:** Relational DBMS (`schema.sql`) and a Python Data Science analytical pipeline (`analysis.py` with Pandas, NumPy, Matplotlib, and Seaborn).

#### 2.2 Product Functions
* Maintain consumer accounts, contact details, sanctioned loads, and meter numbers.
* Record periodic meter readings (previous vs. current readings in kWh).
* Automatically compute net electricity consumption and enforce non-negative constraints.
* Compute progressive tariff bills including energy slab charges, standing charges, and statutory duties.
* Detect high-consumption anomalies and issue advisory warning alerts.
* Provide interactive statistical summaries, time-series charts, category share donuts, and correlation matrices.

#### 2.3 User Characteristics & Roles
* **Meter Reader:** Field personnel responsible for logging monthly current meter readings.
* **Billing Officer / Admin:** Administrative personnel responsible for consumer onboarding, generating monthly billing rolls, and supervising high-consumption warnings.
* **Consumer:** End-users reviewing itemized bills, consumption trends, and energy advisories.
* **Data Analyst:** Technical personnel analyzing grid demand patterns using the Python data pipeline.

#### 2.4 Constraints
* The application logic must run completely in Java (SE 17+) and modern web browsers.
* Live web portal must operate 24/7 on free hosting (GitHub Pages) with zero runtime operational cost.
* Data integrity must be enforced via relational integrity constraints (Primary Key, Foreign Key, CHECK constraints).

---

### 3. SPECIFIC FUNCTIONAL REQUIREMENTS

* **FR-1 (Consumer Master Maintenance):** The system shall create, read, update, and validate consumer profiles comprising Consumer ID, Name, Phone Number, Email, Address, Connection Type (Domestic, Commercial, Industrial, Agricultural), Sanctioned Load (kW), and Unique Meter Number.
* **FR-2 (Meter Reading Entry):** The system shall record monthly meter readings for designated billing cycles (YYYY-MM), capturing reading date, previous reading, current reading, and meter reader identity.
* **FR-3 (Net Consumption Computation):** The system shall compute net consumed units:  
  $$\text{Units Consumed} = \text{Current Meter Reading} - \text{Previous Meter Reading}$$  
  A strict validation check must guarantee that $\text{Current Reading} \ge \text{Previous Reading}$.
* **FR-4 (Automated Tariff Billing Engine):** The system shall calculate electricity charges using predefined tiered rates:
  * **Domestic:** 0–100 units: ₹0.00; 101–200 units: ₹2.25/unit; 201–400 units: ₹4.50/unit; 401–500 units: ₹6.00/unit; >500 units: ₹8.00/unit. Fixed charge: ₹35.00, Tax: 5%.
  * **Commercial:** 0–100 units: ₹5.50/unit; 101–500 units: ₹7.50/unit; >500 units: ₹9.50/unit. Fixed charge: ₹120.00, Tax: 12%.
  * **Industrial:** 0–1000 units: ₹7.00/unit; >1000 units: ₹8.50/unit. Fixed charge: ₹250.00, Tax: 18%.
  * **Agricultural:** 0–500 units: ₹0.00; >500 units: ₹1.50/unit. Fixed charge: ₹0.00, Tax: 0%.
* **FR-5 (High-Consumption Anomaly Reporting):** The system shall automatically flag accounts exceeding specific safety ceilings (Domestic > 400 kWh, Commercial > 1000 kWh, Industrial > 5000 kWh) using the Java Stream API and interactive dashboard filters.
* **FR-6 (Data Science & Visualization Pipeline):** The system shall extract consumption callsets from the relational database via Python, clean and normalize attributes, evaluate outliers via the IQR formula ($Q_3 + 1.5 \times \text{IQR}$), and export 5 publication-quality Matplotlib/Seaborn graphics.

---

### 4. NON-FUNCTIONAL REQUIREMENTS

#### 4.1 Performance Requirements
* Bill computation and receipt generation shall complete in under **10 milliseconds** for any single consumer record.
* The web application initial bundle size shall remain under **500 KB**, ensuring instantaneous first contentful paint (FCP < 1.0s) on mobile and desktop devices.

#### 4.2 Security Requirements
* Meter tampering prevention: System rejects any entry where current reading is less than previous reading.
* SQL injection safety: All SQL scripts and JDBC access utilize PreparedStatements and parameter binding.
* Audit trail: Administrative mutations are logged into the `audit_logs` table.

#### 4.3 Reliability & Availability
* Hosted 24/7 on GitHub Pages with 99.99% uptime guarantee, free tier zero-downtime architecture.
* Client-side persistent storage synchronization (`localStorage`) preserves state across browser reloads.

#### 4.4 Usability & Accessibility
* Modern responsive layout conforming to WCAG 2.1 accessibility guidelines, supporting desktop, tablet, and smartphone form factors.
* High-contrast color palettes with dynamic Light/Dark theme switching.
