/**
 * VOLTTRACK - Electricity Tariff Engine (JavaScript)
 * Mirrors com.ecm.service.BillingService (Java) exactly for client-side live computations.
 * 
 * Author: Kanishka K | Reg No: 732925ITR045 | Class: 25IT3A
 * Institution: Velalar College of Engineering and Technology, Erode - 12
 */

const TariffEngine = {
  // Predefined rates and slabs matching TANGEDCO / Standard Electricity Board
  rates: {
    Domestic: {
      fixed: 35.00,
      taxPct: 5.00,
      slabs: [
        { max: 100, rate: 0.00 },   // 0-100 free
        { max: 200, rate: 2.25 },   // 101-200
        { max: 400, rate: 4.50 },   // 201-400
        { max: 500, rate: 6.00 },   // 401-500
        { max: Infinity, rate: 8.00 } // >500
      ]
    },
    Commercial: {
      fixed: 120.00,
      taxPct: 12.00,
      slabs: [
        { max: 100, rate: 5.50 },
        { max: 500, rate: 7.50 },
        { max: Infinity, rate: 9.50 }
      ]
    },
    Industrial: {
      fixed: 250.00,
      taxPct: 18.00,
      slabs: [
        { max: 1000, rate: 7.00 },
        { max: Infinity, rate: 8.50 }
      ]
    },
    Agricultural: {
      fixed: 0.00,
      taxPct: 0.00,
      slabs: [
        { max: 500, rate: 0.00 },
        { max: Infinity, rate: 1.50 }
      ]
    }
  },

  calculateEnergyCharges(units, connectionType) {
    if (units <= 0) return 0;
    const plan = this.rates[connectionType] || this.rates.Domestic;
    let remainingUnits = units;
    let totalEnergy = 0;
    let prevMax = 0;

    for (const slab of plan.slabs) {
      const slabCapacity = slab.max - prevMax;
      if (remainingUnits > slabCapacity) {
        totalEnergy += slabCapacity * slab.rate;
        remainingUnits -= slabCapacity;
        prevMax = slab.max;
      } else {
        totalEnergy += remainingUnits * slab.rate;
        break;
      }
    }
    return Math.round(totalEnergy * 100) / 100;
  },

  calculateBill(units, connectionType) {
    const plan = this.rates[connectionType] || this.rates.Domestic;
    const energyCharges = this.calculateEnergyCharges(units, connectionType);
    const fixedCharges = plan.fixed;
    const taxableSubtotal = energyCharges + fixedCharges;
    const taxAmount = Math.round(((taxableSubtotal * plan.taxPct) / 100) * 100) / 100;
    const totalAmount = Math.round((energyCharges + fixedCharges + taxAmount) * 100) / 100;

    return {
      units,
      connectionType,
      energyCharges,
      fixedCharges,
      taxPercentage: plan.taxPct,
      taxAmount,
      totalAmount
    };
  },

  isHighConsumption(units, connectionType) {
    switch (connectionType) {
      case 'Domestic': return units > 400;
      case 'Commercial': return units > 1000;
      case 'Industrial': return units > 5000;
      case 'Agricultural': return units > 600;
      default: return units > 500;
    }
  }
};
