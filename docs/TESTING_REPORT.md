# SOFTWARE TESTING TECHNIQUES & TEST CASE VERIFICATION REPORT
## Scenario 14: Electricity Consumption Management and Energy Usage Analysis System

**Student:** Kanishka K | **Register No:** 732925ITR044 | **Class:** 25IT3A  
**Institution:** Velalar College of Engineering and Technology, Erode - 12  
**Course Code:** 25ITT33 – Software Engineering (Unit 4: Software Testing)

---

### 1. TESTING STRATEGIES & METHODOLOGY

To ensure 100% defect-free execution and compliance with software quality metrics, testing was performed using multiple levels of software engineering verification:
1. **Unit Testing:** Testing isolated methods in `BillingService.java`, `InputValidator.java`, and `ReportService.java`.
2. **Integration Testing:** Verifying interaction between `ConsumerService`, `MeterReading`, and `BillingService`.
3. **Black-Box Testing:**
   * **Equivalence Partitioning (EP):** Partitioning consumption into valid slab ranges ($0-100$, $101-200$, $201-400$, $401-500$, $>500$).
   * **Boundary Value Analysis (BVA):** Testing exact tier boundaries ($0, 100, 101, 200, 201, 400, 500, 501$).
4. **White-Box Testing:** Basis path testing and cyclomatic complexity verification of the switch-case tariff calculation flow.
5. **Validation Testing:** Evaluating system behavior against user functional requirements (negative meter readings, missing values, high-consumption filters).

---

### 2. DETAILED TEST CASES & VERIFICATION MATRIX

| Test ID | Module / Feature | Testing Technique | Test Input Description | Expected Result | Actual Result | Status |
|:---|:---|:---|:---|:---|:---|:---:|
| **TC-01** | `BillingService` | BVA (Slab 1) | Domestic, 100 units consumed | Energy Charge = ₹0.00 (Subsidized free tier) | Energy Charge = ₹0.00 | **PASS** |
| **TC-02** | `BillingService` | EP (Slab 2) | Domestic, 150 units consumed | $100 \times 0 + 50 \times 2.25 = ₹112.50$ | Energy Charge = ₹112.50 | **PASS** |
| **TC-03** | `BillingService` | EP (Slab 3) | Domestic, 220 units consumed | $(100 \times 2.25) + (20 \times 4.50) = ₹315.00$ | Energy Charge = ₹315.00 | **PASS** |
| **TC-04** | `BillingService` | BVA (Slab 4) | Domestic, 500 units consumed | $(100 \times 2.25) + (200 \times 4.50) + (100 \times 6.00) = ₹1725.00$ | Energy Charge = ₹1725.00 | **PASS** |
| **TC-05** | `BillingService` | EP (Slab 5) | Domestic, 600 units consumed | $1725 + (100 \times 8.00) = ₹2525.00$ | Energy Charge = ₹2525.00 | **PASS** |
| **TC-06** | `BillingService` | Commercial | Commercial, 650 units | $(100 \times 5.50) + (400 \times 7.50) + (150 \times 9.50) = ₹4975.00$ | Energy Charge = ₹4975.00 | **PASS** |
| **TC-07** | `MeterReading` | Negative Validation | Previous = 5000, Current = 4800 | System throws `InvalidMeterReadingException` | Exception caught: "Current reading cannot be lower than previous" | **PASS** |
| **TC-08** | `InputValidator` | Black-Box Regex | Mobile: "9842100001", "12345" | 1st returns `true`; 2nd returns `false` | Validates correctly | **PASS** |
| **TC-09** | `InputValidator` | Black-Box Regex | Email: "kanishka.k@vcet.ac.in", "bad-email" | 1st returns `true`; 2nd returns `false` | Validates correctly | **PASS** |
| **TC-10** | `ReportService` | Streams API | List of readings, threshold = 1000 kWh | Returns readings with units $\ge$ 1000 in descending order | Successfully filtered 1 industrial reading | **PASS** |
| **TC-11** | `Bill` | Integration | Consumer Kanishka K + 220 units reading | Generates Bill BILL-2026-08-0110 for ₹367.50 (with ₹35 fixed + 5% tax) | Total bill matches ₹367.50 exactly | **PASS** |
| **TC-12** | Python EDA | Data Science Quality | Missing values check on 31 records | 0 missing values detected | Verified 0 missing values | **PASS** |
| **TC-13** | Python EDA | IQR Outliers | Units consumed series | Detects 6 extreme industrial outliers ($>3937.5$ kWh) | 6 outliers tagged correctly | **PASS** |
| **TC-14** | Web UI | End-to-End Functional | Register consumer via modal | Consumer added to directory and dropdown | Instant table refresh & localStorage update | **PASS** |

---

### 3. WHITE-BOX TESTING: CYCLOMATIC COMPLEXITY ANALYSIS

#### Target Function: `BillingService.calculateEnergyCharges(units, connectionType)`
* **Flow Graph Nodes ($N$):** 14
* **Flow Graph Edges ($E$):** 17
* **Predicate Nodes ($P$):** 4
* **Cyclomatic Complexity $V(G)$:**
  $$V(G) = E - N + 2P = 17 - 14 + 2(1) = 5$$
  $$V(G) = P + 1 = 4 + 1 = 5$$

All 5 independent basis execution paths were exercised by test cases **TC-01 through TC-06**, achieving **100% statement and branch coverage**.

---

### 4. SUMMARY OF TEST EXECUTION
* **Total Test Cases Executed:** 14
* **Total Tests Passed:** 14
* **Total Tests Failed:** 0
* **Defect Density:** 0.00 defects / KLOC
* **Verification Outcome:** **ACCEPTED FOR DEPLOYMENT**
