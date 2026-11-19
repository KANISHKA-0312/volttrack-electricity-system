/**
 * VOLTTRACK - Application Controller & State Manager
 * Handles Local Database Storage, Tab Navigation, Modal Forms, and Real-time Calculations.
 * 
 * Student: Kanishka K | Register No: 732925ITR045 | Class: 25IT3A
 * Institution: Velalar College of Engineering and Technology, Erode - 12
 */

// Initial Seed Data (Mirrors database/sample_data.sql)
const DEFAULT_CONSUMERS = [
  { id: 1001, number: "EB-2026-1001", name: "Kanishka K", email: "kanishka.k@vcet.ac.in", phone: "9842100001", address: "14 Thindal Hills, Perundurai Road", city: "Erode", type: "Domestic", meter: "MTR-ERD-8801", load: 3.0, status: "ACTIVE" },
  { id: 1002, number: "EB-2026-1002", name: "Aravind Swaminathan", email: "aravind.s@gmail.com", phone: "9842100002", address: "27 Brough Road, Near Clock Tower", city: "Erode", type: "Commercial", meter: "MTR-ERD-8802", load: 5.0, status: "ACTIVE" },
  { id: 1003, number: "EB-2026-1003", name: "Ramasamy Textiles Pvt Ltd", email: "contact@ramasamytextiles.com", phone: "9842100003", address: "Plot 45 SIPCOT Industrial Estate", city: "Perundurai", type: "Industrial", meter: "MTR-ERD-8803", load: 25.0, status: "ACTIVE" },
  { id: 1004, number: "EB-2026-1004", name: "Muthusamy Farm", email: "muthusamy.agri@outlook.com", phone: "9842100004", address: "Survey No 112/4, Modakkurichi", city: "Erode", type: "Agricultural", meter: "MTR-ERD-8804", load: 7.5, status: "ACTIVE" },
  { id: 1005, number: "EB-2026-1005", name: "Deepa Jayaram", email: "deepa.j@yahoo.com", phone: "9842100005", address: "56 Sampath Nagar Extension", city: "Erode", type: "Domestic", meter: "MTR-ERD-8805", load: 2.0, status: "ACTIVE" },
  { id: 1006, number: "EB-2026-1006", name: "Kavitha Murugesan", email: "kavitha.m@gmail.com", phone: "9842100006", address: "88 Gandhiji Road, Surampatti", city: "Erode", type: "Domestic", meter: "MTR-ERD-8806", load: 4.0, status: "ACTIVE" },
  { id: 1007, number: "EB-2026-1007", name: "Kongu Supermarket", email: "kongu.supermarket@gmail.com", phone: "9842100007", address: "12 Sathy Road", city: "Erode", type: "Commercial", meter: "MTR-ERD-8807", load: 10.0, status: "ACTIVE" },
  { id: 1008, number: "EB-2026-1008", name: "Suresh Kumar Spinnings", email: "suresh.spin@rediffmail.com", phone: "9842100008", address: "Village Road, Chithode", city: "Erode", type: "Industrial", meter: "MTR-ERD-8808", load: 35.0, status: "ACTIVE" }
];

const DEFAULT_READINGS = [
  { id: 1, consumerId: 1001, month: "2026-08", prev: 1200, curr: 1420, units: 220, date: "2026-08-01" },
  { id: 2, consumerId: 1002, month: "2026-08", prev: 4500, curr: 5150, units: 650, date: "2026-08-01" },
  { id: 3, consumerId: 1003, month: "2026-08", prev: 15200, curr: 19800, units: 4600, date: "2026-08-01" },
  { id: 4, consumerId: 1004, month: "2026-08", prev: 3400, curr: 3750, units: 350, date: "2026-08-01" },
  { id: 5, consumerId: 1005, month: "2026-08", prev: 890, curr: 975, units: 85, date: "2026-08-01" },
  { id: 6, consumerId: 1006, month: "2026-08", prev: 2300, curr: 2890, units: 590, date: "2026-08-01" },
  { id: 7, consumerId: 1001, month: "2026-09", prev: 1420, curr: 1680, units: 260, date: "2026-09-01" },
  { id: 8, consumerId: 1002, month: "2026-09", prev: 5150, curr: 5890, units: 740, date: "2026-09-01" },
  { id: 9, consumerId: 1006, month: "2026-09", prev: 2890, curr: 3540, units: 650, date: "2026-09-01" }
];

class App {
  constructor() {
    this.consumers = JSON.parse(localStorage.getItem('ecm_consumers')) || DEFAULT_CONSUMERS;
    this.readings = JSON.parse(localStorage.getItem('ecm_readings')) || DEFAULT_READINGS;
    this.theme = localStorage.getItem('ecm_theme') || 'light';
    this.init();
  }

  save() {
    localStorage.setItem('ecm_consumers', JSON.stringify(this.consumers));
    localStorage.setItem('ecm_readings', JSON.stringify(this.readings));
    localStorage.setItem('ecm_theme', this.theme);
  }

  init() {
    document.documentElement.setAttribute('data-theme', this.theme);
    this.setupEventListeners();
    this.refreshKPIs();
    this.renderConsumersTable();
    this.populateConsumerSelect();
    this.renderReadingsTable();
    this.renderHighConsumption();
    this.renderCharts();
  }

  setupEventListeners() {
    // Theme toggle
    document.getElementById('theme-toggle')?.addEventListener('click', () => {
      this.theme = this.theme === 'light' ? 'dark' : 'light';
      document.documentElement.setAttribute('data-theme', this.theme);
      this.save();
    });

    // Reset Data
    document.getElementById('reset-demo-btn')?.addEventListener('click', () => {
      if (confirm('Reset system data to initial college benchmark demonstration state?')) {
        this.consumers = [...DEFAULT_CONSUMERS];
        this.readings = [...DEFAULT_READINGS];
        this.save();
        location.reload();
      }
    });

    // Tab Navigation
    document.querySelectorAll('.nav-tab').forEach(tab => {
      tab.addEventListener('click', (e) => {
        const target = tab.dataset.tab;
        document.querySelectorAll('.nav-tab').forEach(t => t.classList.remove('active'));
        document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
        tab.classList.add('active');
        document.getElementById(target)?.classList.add('active');
      });
    });

    // Consumer Filter
    document.getElementById('consumer-search')?.addEventListener('input', () => this.renderConsumersTable());
    document.getElementById('consumer-type-filter')?.addEventListener('change', () => this.renderConsumersTable());

    // Register Consumer Form
    document.getElementById('add-consumer-form')?.addEventListener('submit', (e) => {
      e.preventDefault();
      this.handleAddConsumer();
    });

    // Consumer Select change in Reading Form (Auto-fill previous reading)
    document.getElementById('reading-consumer-select')?.addEventListener('change', (e) => {
      const cid = parseInt(e.target.value);
      this.handleConsumerSelectForReading(cid);
    });

    // Reading inputs live calculate
    document.getElementById('curr-reading-input')?.addEventListener('input', () => {
      this.updateReadingCalculationPreview();
    });

    // Save Reading Form
    document.getElementById('record-reading-form')?.addEventListener('submit', (e) => {
      e.preventDefault();
      this.handleRecordReading();
    });

    // High Consumption threshold input
    document.getElementById('high-threshold-select')?.addEventListener('change', () => {
      this.renderHighConsumption();
    });
  }

  refreshKPIs() {
    document.getElementById('kpi-total-consumers').innerText = this.consumers.length;
    
    const totalUnits = this.readings.reduce((sum, r) => sum + r.units, 0);
    document.getElementById('kpi-total-units').innerText = totalUnits.toLocaleString() + ' kWh';

    let totalBilled = 0;
    this.readings.forEach(r => {
      const c = this.consumers.find(item => item.id === r.consumerId);
      if (c) {
        const b = TariffEngine.calculateBill(r.units, c.type);
        totalBilled += b.totalAmount;
      }
    });
    document.getElementById('kpi-total-revenue').innerText = '₹' + Math.round(totalBilled).toLocaleString();

    const highAlerts = this.readings.filter(r => {
      const c = this.consumers.find(item => item.id === r.consumerId);
      return c && TariffEngine.isHighConsumption(r.units, c.type);
    }).length;
    document.getElementById('kpi-high-alerts').innerText = highAlerts;
  }

  renderConsumersTable() {
    const tbody = document.getElementById('consumers-table-body');
    if (!tbody) return;

    const searchTerm = document.getElementById('consumer-search')?.value.toLowerCase() || '';
    const typeFilter = document.getElementById('consumer-type-filter')?.value || 'ALL';

    const filtered = this.consumers.filter(c => {
      const matchSearch = c.name.toLowerCase().includes(searchTerm) || 
                          c.number.toLowerCase().includes(searchTerm) ||
                          c.meter.toLowerCase().includes(searchTerm);
      const matchType = typeFilter === 'ALL' || c.type === typeFilter;
      return matchSearch && matchType;
    });

    tbody.innerHTML = filtered.map(c => `
      <tr>
        <td><strong>${c.number}</strong></td>
        <td>
          <div style="font-weight: 600;">${c.name}</div>
          <small class="text-muted" style="color: var(--text-muted);">${c.address}</small>
        </td>
        <td><span class="badge badge-${c.type.toLowerCase()}">${c.type}</span></td>
        <td><code>${c.meter}</code></td>
        <td>${c.load} kW</td>
        <td>${c.phone}</td>
        <td><span class="badge badge-paid">${c.status}</span></td>
        <td>
          <button class="btn btn-outline" style="padding: 0.3rem 0.6rem; font-size: 0.75rem;" onclick="app.quickBillConsumer(${c.id})">Generate Bill</button>
          <button class="btn btn-outline" style="padding: 0.3rem 0.6rem; font-size: 0.75rem; color: var(--danger);" onclick="app.deleteConsumer(${c.id})">Delete</button>
        </td>
      </tr>
    `).join('');
  }

  populateConsumerSelect() {
    const sel = document.getElementById('reading-consumer-select');
    if (!sel) return;
    sel.innerHTML = '<option value="">-- Choose Registered Consumer --</option>' + 
      this.consumers.map(c => `<option value="${c.id}">${c.name} (${c.number} - ${c.type})</option>`).join('');
  }

  handleConsumerSelectForReading(consumerId) {
    const prevInput = document.getElementById('prev-reading-input');
    const currInput = document.getElementById('curr-reading-input');
    if (!consumerId) {
      prevInput.value = '';
      currInput.value = '';
      return;
    }

    // Find the latest reading for this consumer
    const consumerReadings = this.readings.filter(r => r.consumerId === consumerId);
    if (consumerReadings.length > 0) {
      const latest = consumerReadings[consumerReadings.length - 1];
      prevInput.value = latest.curr;
      currInput.value = (latest.curr + 150).toFixed(0);
    } else {
      prevInput.value = '1000';
      currInput.value = '1250';
    }
    this.updateReadingCalculationPreview();
  }

  updateReadingCalculationPreview() {
    const prev = parseFloat(document.getElementById('prev-reading-input')?.value) || 0;
    const curr = parseFloat(document.getElementById('curr-reading-input')?.value) || 0;
    const cid = parseInt(document.getElementById('reading-consumer-select')?.value);
    const units = Math.max(0, curr - prev);

    const unitsEl = document.getElementById('preview-units');
    const costEl = document.getElementById('preview-cost');

    if (unitsEl) unitsEl.innerText = units.toFixed(1) + ' kWh';

    if (cid && costEl) {
      const c = this.consumers.find(item => item.id === cid);
      if (c) {
        const bill = TariffEngine.calculateBill(units, c.type);
        costEl.innerText = '₹' + bill.totalAmount.toFixed(2);
      }
    }
  }

  handleAddConsumer() {
    const name = document.getElementById('new-name').value.trim();
    const type = document.getElementById('new-type').value;
    const phone = document.getElementById('new-phone').value.trim();
    const email = document.getElementById('new-email').value.trim() || `${name.toLowerCase().replace(/\s+/g, '')}@gmail.com`;
    const address = document.getElementById('new-address').value.trim() || 'Erode City';
    const load = parseFloat(document.getElementById('new-load').value) || 2.0;

    const newId = 1000 + this.consumers.length + 1;
    const newConsumer = {
      id: newId,
      number: `EB-2026-${newId}`,
      name,
      email,
      phone,
      address,
      city: "Erode",
      type,
      meter: `MTR-ERD-${Math.floor(1000 + Math.random() * 9000)}`,
      load,
      status: "ACTIVE"
    };

    this.consumers.push(newConsumer);
    this.save();
    this.renderConsumersTable();
    this.populateConsumerSelect();
    this.refreshKPIs();
    document.getElementById('add-consumer-form').reset();
    alert(`Success: Consumer ${name} registered with Consumer Number ${newConsumer.number}`);
  }

  handleRecordReading() {
    const cid = parseInt(document.getElementById('reading-consumer-select').value);
    const month = document.getElementById('reading-month-input').value || '2026-11';
    const prev = parseFloat(document.getElementById('prev-reading-input').value);
    const curr = parseFloat(document.getElementById('curr-reading-input').value);

    if (curr < prev) {
      alert("Error: Current reading cannot be less than previous meter reading.");
      return;
    }

    const units = curr - prev;
    const newReading = {
      id: this.readings.length + 1,
      consumerId: cid,
      month,
      prev,
      curr,
      units,
      date: new Date().toISOString().split('T')[0]
    };

    this.readings.push(newReading);
    this.save();
    this.refreshKPIs();
    this.renderReadingsTable();
    this.renderHighConsumption();
    this.renderCharts();

    const c = this.consumers.find(item => item.id === cid);
    this.showInvoiceModal(c, newReading);
  }

  renderReadingsTable() {
    const tbody = document.getElementById('readings-table-body');
    if (!tbody) return;

    tbody.innerHTML = this.readings.slice(-10).reverse().map(r => {
      const c = this.consumers.find(item => item.id === r.consumerId) || { name: 'Unknown', number: 'N/A', type: 'Domestic' };
      const bill = TariffEngine.calculateBill(r.units, c.type);
      const isHigh = TariffEngine.isHighConsumption(r.units, c.type);

      return `
        <tr>
          <td>${r.month}</td>
          <td><strong>${c.name}</strong><br><small style="color:var(--text-muted)">${c.number}</small></td>
          <td><span class="badge badge-${c.type.toLowerCase()}">${c.type}</span></td>
          <td>${r.prev}</td>
          <td>${r.curr}</td>
          <td><strong>${r.units} kWh</strong> ${isHigh ? '<span class="badge badge-alert">High Usage</span>' : ''}</td>
          <td><strong>₹${bill.totalAmount.toFixed(2)}</strong></td>
          <td>
            <button class="btn btn-outline" style="padding: 0.25rem 0.5rem; font-size: 0.75rem;" onclick="app.showInvoiceById(${r.id})">View Invoice</button>
          </td>
        </tr>
      `;
    }).join('');
  }

  renderHighConsumption() {
    const tbody = document.getElementById('high-consumption-table-body');
    if (!tbody) return;

    const highRecords = [];
    this.readings.forEach(r => {
      const c = this.consumers.find(item => item.id === r.consumerId);
      if (c && TariffEngine.isHighConsumption(r.units, c.type)) {
        highRecords.push({ consumer: c, reading: r });
      }
    });

    tbody.innerHTML = highRecords.map(item => `
      <tr>
        <td><strong>${item.consumer.number}</strong></td>
        <td>${item.consumer.name}</td>
        <td><span class="badge badge-${item.consumer.type.toLowerCase()}">${item.consumer.type}</span></td>
        <td>${item.reading.month}</td>
        <td><strong style="color: var(--danger); font-size: 1.05rem;">${item.reading.units} kWh</strong></td>
        <td><span class="badge badge-alert">THRESHOLD EXCEEDED</span></td>
        <td>
          <button class="btn btn-primary" style="padding: 0.25rem 0.6rem; font-size: 0.75rem;" onclick="alert('Notice issued to ${item.consumer.name} for excessive energy consumption.')">Send Advisory Notice</button>
        </td>
      </tr>
    `).join('');
  }

  showInvoiceModal(consumer, reading) {
    const modal = document.getElementById('invoice-modal');
    const bill = TariffEngine.calculateBill(reading.units, consumer.type);
    const invoiceBox = document.getElementById('invoice-modal-content');

    const billDate = new Date().toLocaleDateString();
    const dueDate = new Date(Date.now() + 15 * 86400000).toLocaleDateString();

    invoiceBox.innerHTML = `
      <div class="invoice-box">
        <div class="invoice-header">
          <h2 style="color: #1e3a8a; margin-bottom: 0.2rem;">TAMIL NADU ELECTRICITY BOARD</h2>
          <div style="font-size: 0.85rem; color: #475569;">ELECTRICITY CONSUMPTION & CHARGES INVOICE</div>
          <div style="font-size: 0.75rem; color: #64748b; margin-top: 4px;">Assessment: Scenario 14 | System Author: Kanishka K (Reg No: 732925ITR045)</div>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; font-size: 0.85rem; margin-bottom: 1rem;">
          <div>
            <strong>Consumer Details:</strong><br>
            Name: <b>${consumer.name}</b><br>
            Consumer No: <code>${consumer.number}</code><br>
            Address: ${consumer.address}<br>
            Tariff Type: <span class="badge badge-${consumer.type.toLowerCase()}">${consumer.type}</span>
          </div>
          <div>
            <strong>Billing Particulars:</strong><br>
            Invoice Ref: <code>BILL-${reading.month}-${reading.id}</code><br>
            Billing Period: <b>${reading.month}</b><br>
            Meter No: <code>${consumer.meter}</code><br>
            Bill Date: ${billDate} | Due: <b>${dueDate}</b>
          </div>
        </div>

        <table class="invoice-table">
          <thead>
            <tr style="background: #f8fafc;">
              <th>Description</th>
              <th style="text-align: right;">Consumption / Rate</th>
              <th style="text-align: right;">Amount (INR)</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Previous Reading (kWh)</td>
              <td style="text-align: right;">${reading.prev.toFixed(2)}</td>
              <td style="text-align: right;">-</td>
            </tr>
            <tr>
              <td>Current Reading (kWh)</td>
              <td style="text-align: right;">${reading.curr.toFixed(2)}</td>
              <td style="text-align: right;">-</td>
            </tr>
            <tr style="background: #eff6ff; font-weight: 600;">
              <td>Net Electricity Consumed</td>
              <td style="text-align: right;">${reading.units.toFixed(2)} kWh</td>
              <td style="text-align: right;">-</td>
            </tr>
            <tr>
              <td>Energy Charges (Slab Rates)</td>
              <td style="text-align: right;">Progressive</td>
              <td style="text-align: right;">₹${bill.energyCharges.toFixed(2)}</td>
            </tr>
            <tr>
              <td>Fixed Standing Charges</td>
              <td style="text-align: right;">Base Tariff</td>
              <td style="text-align: right;">₹${bill.fixedCharges.toFixed(2)}</td>
            </tr>
            <tr>
              <td>Electricity Duty / Tax (${bill.taxPercentage}%)</td>
              <td style="text-align: right;">Govt Levies</td>
              <td style="text-align: right;">₹${bill.taxAmount.toFixed(2)}</td>
            </tr>
            <tr class="invoice-total-row">
              <td colspan="2">TOTAL AMOUNT PAYABLE</td>
              <td style="text-align: right; color: #1e3a8a;">₹${bill.totalAmount.toFixed(2)}</td>
            </tr>
          </tbody>
        </table>

        <div style="font-size: 0.75rem; color: #64748b; text-align: center; border-top: 1px dashed #cbd5e1; padding-top: 0.75rem;">
          This is a computer-generated invoice from the Electricity Consumption Management System.<br>
          VCET IT Department | Academic Year 2026-27 | Class 25IT3A
        </div>
      </div>
    `;

    modal.style.display = 'flex';
  }

  showInvoiceById(readingId) {
    const reading = this.readings.find(r => r.id === readingId);
    if (!reading) return;
    const consumer = this.consumers.find(c => c.id === reading.consumerId);
    if (!consumer) return;
    this.showInvoiceModal(consumer, reading);
  }

  quickBillConsumer(consumerId) {
    const consumer = this.consumers.find(c => c.id === consumerId);
    if (!consumer) return;
    const cReadings = this.readings.filter(r => r.consumerId === consumerId);
    if (cReadings.length === 0) {
      alert('No meter reading recorded yet for this consumer. Please record a reading first.');
      return;
    }
    this.showInvoiceModal(consumer, cReadings[cReadings.length - 1]);
  }

  closeModal() {
    document.getElementById('invoice-modal').style.display = 'none';
  }

  deleteConsumer(id) {
    if (confirm('Are you sure you want to delete this consumer? All associated readings will be removed.')) {
      this.consumers = this.consumers.filter(c => c.id !== id);
      this.readings = this.readings.filter(r => r.consumerId !== id);
      this.save();
      this.init();
    }
  }

  renderCharts() {
    // 1. Connection Type Breakdown
    const catData = ['Domestic', 'Commercial', 'Industrial', 'Agricultural'].map(type => {
      const units = this.readings.filter(r => {
        const c = this.consumers.find(item => item.id === r.consumerId);
        return c && c.type === type;
      }).reduce((sum, r) => sum + r.units, 0);

      const colors = { Domestic: '#2563eb', Commercial: '#0891b2', Industrial: '#dc2626', Agricultural: '#16a34a' };
      return { label: type, value: units, color: colors[type] };
    });
    ChartRenderer.renderCategoryComparison('chart-category-bar', catData);

    // 2. Monthly Trend Chart
    const months = ['2026-08', '2026-09', '2026-10'];
    const domesticTrend = months.map(m => {
      return this.readings.filter(r => r.month === m && this.consumers.find(c => c.id === r.consumerId)?.type === 'Domestic')
                          .reduce((s, r) => s + r.units, 0) || 500;
    });
    const commercialTrend = months.map(m => {
      return this.readings.filter(r => r.month === m && this.consumers.find(c => c.id === r.consumerId)?.type === 'Commercial')
                          .reduce((s, r) => s + r.units, 0) || 1200;
    });

    ChartRenderer.renderMonthlyTrend('chart-monthly-trend', months, [
      { name: 'Domestic', color: '#2563eb', data: domesticTrend },
      { name: 'Commercial', color: '#0891b2', data: commercialTrend }
    ]);
  }
}

let app;
window.addEventListener('DOMContentLoaded', () => {
  app = new App();
});
