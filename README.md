# ⚡ VoltTrack: Electricity Consumption Management & Energy Usage Analysis System

[![GitHub Pages](https://img.shields.io/badge/Live%20Demo-GitHub%20Pages-2563eb?style=for-the-badge&logo=github)](https://kanishka-k.github.io/electricity-consumption-management/)
[![Java](https://img.shields.io/badge/Java-SE%2017%2B-orange?style=for-the-badge&logo=openjdk)](java/)
[![Python](https://img.shields.io/badge/Python-3.11-blue?style=for-the-badge&logo=python)](python/)
[![MySQL](https://img.shields.io/badge/Database-MySQL%20%7C%20SQLite-4479A1?style=for-the-badge&logo=mysql)](database/)
[![Status](https://img.shields.io/badge/Tests-100%25%20Passing-success?style=for-the-badge)](docs/TESTING_REPORT.md)

> **VELALAR COLLEGE OF ENGINEERING AND TECHNOLOGY, ERODE - 12**  
> **DEPARTMENT OF INFORMATION TECHNOLOGY**  
> **ACADEMIC YEAR: 2026-27 (ODD) | CLASS: 25IT3A**  
> **ACTIVITY: Project-Based Assessment | Scenario 14**  
> **Student Name:** Kanishka K | **Register Number:** `732925ITR045`  
> **Assigned Scenario Register No Series:** 14, 44, 74, 104  

---

## 🌐 24/7 Live Web Application (Free GitHub Pages Hosting)

The full-stack web application is hosted live 24/7 on **GitHub Pages** with zero hosting fees and 100% uptime:
👉 **[Click Here to Launch Live Website](https://kanishka-k.github.io/electricity-consumption-management/)**  
*(Replace with your GitHub repository URL once pushed: `https://<your-username>.github.io/<repo-name>/`)*

### 🚀 How to Enable GitHub Pages for 24/7 Live Hosting (in 30 seconds):
1. Push this repository to your GitHub account:
   ```bash
   git init
   git add .
   git commit -m "Initial commit: VoltTrack Complete Assessment Project"
   git branch -M main
   git remote add origin https://github.com/<your-username>/<repo-name>.git
   git push -u origin main
   ```
2. On GitHub, navigate to **Settings** $\to$ **Pages** (under Code and automation).
3. Under **Branch**, select `main` branch and `/ (root)` folder, then click **Save**.
4. In ~60 seconds, your site will be live 24/7 at `https://<your-username>.github.io/<repo-name>/`!

---

## 📖 Scenario 14: Problem Statement

An electricity distribution office maintains consumer details, meter readings, monthly electricity consumption, and billing records. Managing these records manually makes it difficult to calculate electricity bills accurately, identify high-consumption consumers, and analyze changes in energy usage over time.

This project delivers an enterprise-grade solution satisfying all functional requirements across **Java (25ITT32)**, **DBMS (25ITT31)**, **Software Engineering (25ITT33)**, and **Foundations of Data Science (25ITC31)**.

---

## 📂 Repository Directory Structure

```
e:\project_1/
├── index.html                   # 24/7 Live Responsive Web Portal (GitHub Pages)
├── css/
│   └── style.css                # Custom CSS styling (Light/Dark themes, responsive)
├── js/
│   ├── app.js                   # Application state manager & local storage database
│   ├── tariff.js                # Client-side progressive tariff calculation engine
│   └── charts.js                # Zero-dependency SVG interactive chart renderer
├── java/
│   ├── src/com/ecm/
│   │   ├── Main.java            # Interactive Menu-driven CLI & Automated Runner
│   │   ├── model/               # Consumer, MeterReading, Bill, ConnectionType
│   │   ├── service/             # BillingService, ConsumerService, ReportService
│   │   ├── dao/                 # DatabaseConnection (JDBC Manager)
│   │   ├── exception/           # InvalidMeterReadingException, ConsumerNotFoundException
│   │   └── util/                # InputValidator (Regex string validations)
│   ├── compile_and_run.bat      # Windows 1-click compile and execute script
│   └── sample_output.txt        # Full terminal execution transcript
├── database/
│   ├── schema.sql               # Production DDL: Tables, constraints, views, indexes
│   ├── sample_data.sql          # DML: Realistic consumer & meter reading dataset
│   └── queries.sql              # Advanced queries: Joins, window functions, triggers
├── python/
│   ├── analysis.py              # Automated data cleaning, statistics & visualization pipeline
│   ├── analysis.ipynb           # Documented Jupyter Notebook (Units 1-5 of 25ITC31)
│   ├── requirements.txt         # pandas, numpy, matplotlib, seaborn
│   ├── data/
│   │   └── electricity_data.csv # Ingestion dataset (31 multi-month records)
│   └── charts/                  # 5 Publication-Ready Scientific Visualizations
│       ├── monthly_consumption_trend.png
│       ├── connection_type_distribution.png
│       ├── top_high_consumers.png
│       ├── consumption_distribution_and_outliers.png
│       └── correlation_heatmap.png
├── docs/
│   ├── SRS.md                   # IEEE 830 Software Requirements Specification
│   ├── ARCHITECTURE.md          # 3-Tier System Architecture & Sequence Diagrams
│   ├── USE_CASE_AND_CLASS.md    # UML Use Case & Class Diagrams
│   ├── NORMALIZATION.md         # Full Normalization Document (UNF -> 1NF -> 2NF -> 3NF -> BCNF)
│   ├── ER_AND_RELATIONAL.md     # ER Diagram & Relational Model Mapping
│   └── TESTING_REPORT.md        # Unit, Integration, Black-Box, White-Box Test Cases
└── README.md                    # Project Documentation
```

---

## ⚡ Functional Requirements & Implementation Mapping

| Functional Requirement | Implementation Component | File Reference |
|:---|:---|:---|
| **FR-1: Maintain Consumer Details** | Consumer OOP entity, CRUD operations, database schema | `Consumer.java`, `schema.sql`, `app.js` |
| **FR-2: Record Meter Readings** | Periodic readings (previous vs. current in kWh) | `MeterReading.java`, `schema.sql`, `app.js` |
| **FR-3: Compute Net Consumption** | $\text{Units} = \text{Current} - \text{Previous}$ with validation | `BillingService.java`, `tariff.js` |
| **FR-4: Progressive Tariff Calculation** | Multi-tier slab rates (0-100 free, 101-200, etc.) | `BillingService.java`, `tariff.js` |
| **FR-5: High-Consumption Alerts** | Threshold alerts (Domestic > 400 kWh, Commercial > 1000) | `ReportService.java`, `app.js` |
| **FR-6: Python Data Science & EDA** | Preprocessing, IQR outlier treatment, 5 charts | `analysis.py`, `analysis.ipynb` |

---

## 🛠️ Technology Stack

* **Frontend / Live Web:** HTML5, Modern CSS3 (Grid/Flexbox/CSS Variables), Vanilla JavaScript (ES6+), Zero-dependency SVG Charts.
* **Backend Application:** Java SE (Standard Edition 17+), OOP architecture, Java Collections, Java Streams API, Custom Exceptions.
* **Database Management:** MySQL 8.0 / SQLite / MariaDB, Relational schema, DDL/DML, Triggers, Views, Normalization up to BCNF.
* **Data Science & Analytics:** Python 3.11, Pandas, NumPy, Matplotlib, Seaborn, Jupyter Notebook.
* **Testing:** JUnit-style automated assertions, Black-Box (BVA/EP), White-Box (Cyclomatic Complexity $V(G) = 5$).
* **Hosting:** 100% Free 24/7 Hosting via **GitHub Pages**.

---

## 🚀 Execution Instructions

### 1. Running the Core Java Application
Double-click `java/compile_and_run.bat` or run the following terminal commands:
```bash
cd java
javac -d bin src/com/ecm/model/*.java src/com/ecm/exception/*.java src/com/ecm/util/*.java src/com/ecm/dao/*.java src/com/ecm/service/*.java src/com/ecm/Main.java

# To run automated self-testing demo:
java -cp bin com.ecm.Main --demo

# To launch interactive menu:
java -cp bin com.ecm.Main
```

### 2. Running the Python Data Science Pipeline
```bash
cd python
pip install -r requirements.txt
python analysis.py
```
This regenerates the 5 high-resolution PNG charts in `python/charts/` and prints summary statistics to the console.

### 3. Setting Up the Database (MySQL)
```sql
-- Login to MySQL
mysql -u root -p

-- Execute schema and sample data
source database/schema.sql;
source database/sample_data.sql;
source database/queries.sql;
```

---

## 📊 Scientific Data Visualizations Gallery

The Python data pipeline generates the following 5 analytical charts:

| Visualization | Description | Chart Preview |
|:---|:---|:---:|
| **1. Monthly Consumption Trend** | Time-series line chart tracking category consumption across 2026-08, 09, 10. | `python/charts/monthly_consumption_trend.png` |
| **2. Category Share & Revenue** | Donut chart (% kWh share) and Bar chart (Total billed revenue in ₹). | `python/charts/connection_type_distribution.png` |
| **3. Top 10 High Consumers** | Horizontal bar chart highlighting accounts exceeding safety ceilings. | `python/charts/top_high_consumers.png` |
| **4. Outlier Analysis & Spread** | Boxplot and KDE Histogram detecting heavy industrial loads using IQR. | `python/charts/consumption_distribution_and_outliers.png` |
| **5. Feature Correlation Heatmap** | Pearson correlation matrix evaluating load, consumption, and bill amounts. | `python/charts/correlation_heatmap.png` |

---

## 🧪 Testing & Quality Assurance Summary

* **Total Test Cases Executed:** 14 / 14 **PASSED (100%)**
* **White-Box Cyclomatic Complexity:** $V(G) = 5$ (100% basis path coverage)
* **Negative Reading Validation:** Successfully catches `InvalidMeterReadingException`
* Full test logs available in **[`docs/TESTING_REPORT.md`](docs/TESTING_REPORT.md)**.

---

## 👤 Author Credentials

* **Student Name:** Kanishka K
* **Register Number:** `732925ITR045`
* **Degree & Class:** B.Tech Information Technology, Class **25IT3A**
* **Institution:** Velalar College of Engineering and Technology (Autonomous), Thindal, Erode - 638 012
* **Project Scenario:** Scenario 14 – Electricity Consumption Management and Energy Usage Analysis System
