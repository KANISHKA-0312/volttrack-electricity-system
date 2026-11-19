# SYSTEM ARCHITECTURE & DESIGN SPECIFICATIONS
## Scenario 14: Electricity Consumption Management and Energy Usage Analysis System

**Student:** Kanishka K | **Register No:** 732925ITR044 | **Class:** 25IT3A  
**Institution:** Velalar College of Engineering and Technology, Erode - 12  
**Course Code:** 25ITT33 – Software Engineering (Unit 3: Software Design)

---

### 1. OVERALL 3-TIER ARCHITECTURE

VoltTrack is built upon a modular 3-tier architectural design pattern that cleanly decouples presentation logic, domain business logic, and persistence/analytics infrastructure.

```mermaid
graph TD
    subgraph Tier1["Tier 1: Presentation Layer"]
        A1["24/7 Live Web Dashboard (GitHub Pages)"]
        A2["Interactive Java Console CLI (com.ecm.Main)"]
    end

    subgraph Tier2["Tier 2: Business Logic & Application Layer"]
        B1["Consumer Service (Registration & Directory)"]
        B2["Billing Service & Tariff Engine (Slab Calculations)"]
        B3["Report Service (Java Streams API & Filter Engine)"]
        B4["Input Validator (Regex & Domain Integrity Checks)"]
    end

    subgraph Tier3["Tier 3: Data Persistence & Analytics Layer"]
        C1[("Relational DBMS (MySQL / SQLite / LocalStorage)")]
        C2["Python Data Science Pipeline (NumPy, Pandas, Seaborn)"]
        C3["Publication Visualizations & Export Engine"]
    end

    Tier1 --> Tier2
    Tier2 --> Tier3
```

---

### 2. DATA FLOW DIAGRAM (DFD LEVEL 1)

```mermaid
flowchart LR
    MeterReader["Meter Reader / Officer"] -->|"Enter Current Reading"| P1["1.0 Record Meter Reading"]
    P1 -->|"Fetch Previous Reading"| D1[("Meter Readings Table")]
    P1 -->|"Units = Current - Previous"| P2["2.0 Compute Net Consumption"]
    P2 -->|"Units Consumed"| P3["3.0 Evaluate Tariff Slabs"]
    TariffTable[("Tariff Plans Table")] -->|"Fetch Rates & Slabs"| P3
    P3 -->|"Energy + Fixed + Tax"| P4["4.0 Generate Bill & Invoice"]
    P4 -->|"Store Bill Record"| D2[("Bills Table")]
    P4 -->|"Itemized Receipt"| Consumer["Electricity Consumer"]
    D1 -->|"Read Historical Data"| P5["5.0 High Usage & EDA Analytics"]
    P5 -->|"Alert Horizon (>400 kWh)"| Admin["EB Officer Alert Panel"]
    P5 -->|"EDA Charts (Matplotlib)"| Analyst["Data Science Reports"]
```

---

### 3. SEQUENCE DIAGRAM: METER READING TO BILL GENERATION

```mermaid
sequenceDiagram
    autonumber
    actor Reader as Field Meter Reader
    participant UI as Dashboard / Console
    participant Validator as InputValidator
    participant BService as BillingService
    participant DB as Relational Database
    actor Consumer as Electricity Consumer

    Reader->>UI: Submit (Consumer ID, Month, Current Reading)
    UI->>DB: Query Latest Previous Reading for Consumer
    DB-->>UI: Return Previous Reading (e.g. 1200.0 kWh)
    UI->>Validator: Validate (Current >= Previous)
    alt Reading is Invalid (Current < Previous)
        Validator-->>UI: Throw InvalidMeterReadingException
        UI-->>Reader: Display Validation Error Alert
    else Reading is Valid
        Validator-->>UI: Validation OK
        UI->>BService: generateBill(Consumer, MeterReading)
        BService->>BService: Calculate Progressive Slabs (0-100 free, 101-200 @2.25, etc.)
        BService->>BService: Add Fixed Standing Charges & 5% Tax
        BService->>DB: INSERT into bills table
        DB-->>BService: Return Generated Bill Number (BILL-2026-08-001)
        BService-->>UI: Return Populated Bill Object
        UI->>Consumer: Render Itemized Printable Invoice
    end
```

---

### 4. DEPLOYMENT ARCHITECTURE

* **Production Live Hosting:** GitHub Pages static site engine serving `index.html`, `css/style.css`, and `js/` over HTTPS with automated CDN routing.
* **Local Backend Run:** Standard Java SE 17+ JVM executing `com.ecm.Main` from bytecode compiled via `javac`.
* **Data Science Server/Runtime:** Python 3.11 with Pandas, NumPy, Matplotlib, and Seaborn executing `python/analysis.py` and Jupyter Notebook `python/analysis.ipynb`.
