# DATABASE NORMALIZATION REPORT (1NF TO BCNF)
## Scenario 14: Electricity Consumption Management and Energy Usage Analysis System

**Student:** Kanishka K | **Register No:** 732925ITR044 | **Class:** 25IT3A  
**Institution:** Velalar College of Engineering and Technology, Erode - 12  
**Course Code:** 25ITT31 – Database Management Systems (Unit 3: Normalization)

---

### 1. UNNORMALIZED FORM (UNF)

In a legacy manual paper register or spreadsheet, an electricity distribution record contains unnormalized data with multi-valued attributes, repeating billing cycles, and embedded consumer data:

$$\text{UNF\_ELECTRICITY\_RECORD}(\underline{\text{ConsumerNo}}, \text{Name}, \text{Address}, \text{ConnectionType}, \text{FixedCharge}, \text{TariffSlabs}, \text{MeterNo}, \{\text{BillingMonth}, \text{PrevReading}, \text{CurrReading}, \text{Units}, \text{BillNo}, \text{BillAmount}, \text{Status}\})$$

#### Anomalies in UNF:
* **Insertion Anomaly:** Cannot define a new tariff category without onboarding an actual consumer.
* **Deletion Anomaly:** Deleting the sole consumer of a specific category loses the tariff rate specifications.
* **Update Anomaly:** If a consumer updates their mobile number, it must be updated across every past monthly billing row.

---

### 2. FIRST NORMAL FORM (1NF)

**Rule:** A relation is in 1NF if and only if all attribute domains contain only atomic (indivisible) values, and there are no repeating groups.

**Decomposition:**
We eliminate repeating groups by introducing a composite primary key consisting of $(\text{ConsumerNumber}, \text{BillingMonth})$:

$$\text{R1\_1NF}(\underline{\text{ConsumerNumber}}, \text{Name}, \text{Email}, \text{Phone}, \text{Address}, \text{City}, \text{PinCode}, \text{ConnectionType}, \text{FixedCharge}, \text{SlabRates}, \text{MeterNumber}, \underline{\text{BillingMonth}}, \text{PrevReading}, \text{CurrReading}, \text{UnitsConsumed}, \text{BillNo}, \text{BillAmount}, \text{PaymentStatus})$$

* All values are atomic.
* Composite Primary Key: $(\text{ConsumerNumber}, \text{BillingMonth})$.

---

### 3. SECOND NORMAL FORM (2NF)

**Rule:** A relation is in 2NF if it is in 1NF and every non-prime attribute is **fully functionally dependent** on the primary key (no partial dependencies on a subset of a composite primary key).

#### Identified Partial Dependencies in R1_1NF:
1. $\text{ConsumerNumber} \to \text{Name}, \text{Email}, \text{Phone}, \text{Address}, \text{City}, \text{PinCode}, \text{ConnectionType}, \text{FixedCharge}, \text{SlabRates}, \text{MeterNumber}$  
   *(Dependent only on ConsumerNumber, NOT on BillingMonth).*
2. $(\text{ConsumerNumber}, \text{BillingMonth}) \to \text{PrevReading}, \text{CurrReading}, \text{UnitsConsumed}, \text{BillNo}, \text{BillAmount}, \text{PaymentStatus}$  
   *(Full functional dependency).*

#### 2NF Decomposition:
* **CONSUMER_PROFILE** ($\underline{\text{ConsumerNumber}}$, Name, Email, Phone, Address, City, PinCode, ConnectionType, FixedCharge, SlabRates, MeterNumber)
* **METER_AND_BILL** ($\underline{\text{ConsumerNumber}}, \underline{\text{BillingMonth}}$, PrevReading, CurrReading, UnitsConsumed, BillNo, BillAmount, PaymentStatus)

Both tables are now in 2NF.

---

### 4. THIRD NORMAL FORM (3NF)

**Rule:** A relation is in 3NF if it is in 2NF and **no non-prime attribute is transitively dependent** on any candidate key (i.e., for any $X \to Y$, either $X$ is a superkey or $Y$ is a prime attribute).

#### Identified Transitive Dependencies:
1. In `CONSUMER_PROFILE`:
   $$\text{ConsumerNumber} \to \text{ConnectionType} \quad \text{and} \quad \text{ConnectionType} \to \text{FixedCharge}, \text{SlabRates}$$  
   *Here, FixedCharge and SlabRates depend on ConnectionType, which is not a superkey!*
2. In `METER_AND_BILL`:
   $$(\text{ConsumerNumber}, \text{BillingMonth}) \to \text{ReadingId} \quad \text{and} \quad \text{ReadingId} \to \text{BillNo}, \text{BillAmount}$$  
   *Reading details and Bill details can be separated into distinct reading and invoice entities.*

#### 3NF Decomposition:
1. **TARIFF_PLANS** ($\underline{\text{TariffId}}$, $\text{ConnectionType}^\text{AK}$, FixedCharge, RateSlab1, RateSlab2, RateSlab3, RateSlab4, RateSlabAbove, TaxPercentage)
2. **CONSUMERS** ($\underline{\text{ConsumerId}}$, $\text{ConsumerNumber}^\text{AK}$, Name, Email, Phone, Address, City, PinCode, $\text{ConnectionType}^\text{FK}$, $\text{MeterNumber}^\text{AK}$, SanctionedLoadKw, Status)
3. **METER_READINGS** ($\underline{\text{ReadingId}}$, $\text{ConsumerId}^\text{FK}$, BillingMonth, ReadingDate, PrevReading, CurrReading, UnitsConsumed)
4. **BILLS** ($\underline{\text{BillId}}$, $\text{BillNumber}^\text{AK}$, $\text{ReadingId}^\text{FK}$, $\text{ConsumerId}^\text{FK}$, BillingMonth, UnitsConsumed, EnergyCharges, FixedCharges, TaxAmount, TotalBillAmount, DueDate, PaymentStatus)

---

### 5. BOYCE-CODD NORMAL FORM (BCNF)

**Rule:** A relation is in BCNF if and only if for every non-trivial functional dependency $X \to Y$, **$X$ is a superkey**.

Let us test every decomposed relation:
1. **TARIFF_PLANS:**
   * $\text{TariffId} \to \text{ConnectionType}, \text{FixedCharge}, \dots$ (TariffId is PK $\to$ Superkey)
   * $\text{ConnectionType} \to \text{TariffId}, \text{FixedCharge}, \dots$ (ConnectionType is Candidate Key $\to$ Superkey)  
   $\implies$ **Satisfies BCNF.**
2. **CONSUMERS:**
   * $\text{ConsumerId} \to \text{ConsumerNumber}, \text{Name}, \dots$ (ConsumerId is PK $\to$ Superkey)
   * $\text{ConsumerNumber} \to \text{ConsumerId}, \text{Name}, \dots$ (ConsumerNumber is Candidate Key $\to$ Superkey)
   * $\text{MeterNumber} \to \text{ConsumerId}, \dots$ (MeterNumber is Candidate Key $\to$ Superkey)  
   $\implies$ **Satisfies BCNF.**
3. **METER_READINGS:**
   * $\text{ReadingId} \to \text{ConsumerId}, \text{BillingMonth}, \dots$ (ReadingId is PK $\to$ Superkey)
   * $(\text{ConsumerId}, \text{BillingMonth}) \to \text{ReadingId}, \dots$ (Alternate unique key $\to$ Superkey)  
   $\implies$ **Satisfies BCNF.**
4. **BILLS:**
   * $\text{BillId} \to \text{BillNumber}, \text{ReadingId}, \dots$ (BillId is PK $\to$ Superkey)
   * $\text{BillNumber} \to \text{BillId}, \dots$ (Candidate Key $\to$ Superkey)  
   $\implies$ **Satisfies BCNF.**

---

### 6. SUMMARY OF FUNCTIONAL DEPENDENCY (FD) SET

| Entity / Table | Primary Key | Alternate Keys | Functional Dependencies ($X \to Y$) | Normal Form |
|---|---|---|---|---|
| `tariff_plans` | `tariff_id` | `connection_type` | `tariff_id` $\to$ all; `connection_type` $\to$ all | **BCNF** |
| `consumers` | `consumer_id` | `consumer_number`, `meter_number` | `consumer_id` $\to$ all; `meter_number` $\to$ all | **BCNF** |
| `meter_readings` | `reading_id` | `(consumer_id, billing_month)` | `reading_id` $\to$ all; `(consumer_id, billing_month)` $\to$ all | **BCNF** |
| `bills` | `bill_id` | `bill_number`, `reading_id` | `bill_id` $\to$ all; `bill_number` $\to$ all | **BCNF** |

**Conclusion:** The database schema is completely free of update, insertion, and deletion anomalies, with guaranteed **lossless join decomposition** and **dependency preservation**.
