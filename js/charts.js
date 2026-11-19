/**
 * VOLTTRACK - Client-Side Interactive Data Visualizations
 * Zero-dependency SVG/Canvas chart renderer for 100% offline & GitHub Pages reliability.
 * 
 * Author: Kanishka K | Reg No: 732925ITR045 | Class: 25IT3A
 */

const ChartRenderer = {
  // Render an interactive SVG Multi-Bar Chart
  renderCategoryComparison(containerId, data) {
    const container = document.getElementById(containerId);
    if (!container) return;

    const width = 500;
    const height = 260;
    const padding = { top: 30, right: 20, bottom: 40, left: 60 };
    const chartWidth = width - padding.left - padding.right;
    const chartHeight = height - padding.top - padding.bottom;

    const maxVal = Math.max(...data.map(d => d.value), 100);
    const barWidth = chartWidth / data.length - 20;

    let barsSvg = '';
    data.forEach((d, i) => {
      const barHeight = (d.value / maxVal) * chartHeight;
      const x = padding.left + i * (barWidth + 20) + 10;
      const y = padding.top + (chartHeight - barHeight);

      barsSvg += `
        <rect x="${x}" y="${y}" width="${barWidth}" height="${barHeight}" rx="4" fill="${d.color}" opacity="0.85">
          <title>${d.label}: ${d.value.toLocaleString()} kWh</title>
        </rect>
        <text x="${x + barWidth / 2}" y="${y - 6}" text-anchor="middle" font-size="11" font-weight="bold" fill="currentColor">${Math.round(d.value)}</text>
        <text x="${x + barWidth / 2}" y="${height - 12}" text-anchor="middle" font-size="11" fill="currentColor">${d.label}</text>
      `;
    });

    container.innerHTML = `
      <svg viewBox="0 0 ${width} ${height}" style="width: 100%; height: auto; max-height: 280px; overflow: visible;">
        <!-- Grid lines -->
        <line x1="${padding.left}" y1="${padding.top}" x2="${width - padding.right}" y2="${padding.top}" stroke="#e2e8f0" stroke-dasharray="3"/>
        <line x1="${padding.left}" y1="${padding.top + chartHeight / 2}" x2="${width - padding.right}" y2="${padding.top + chartHeight / 2}" stroke="#e2e8f0" stroke-dasharray="3"/>
        <line x1="${padding.left}" y1="${height - padding.bottom}" x2="${width - padding.right}" y2="${height - padding.bottom}" stroke="#cbd5e1" stroke-width="1.5"/>
        ${barsSvg}
      </svg>
    `;
  },

  // Render Trend Line SVG Chart
  renderMonthlyTrend(containerId, months, series) {
    const container = document.getElementById(containerId);
    if (!container) return;

    const width = 600;
    const height = 260;
    const padding = { top: 30, right: 30, bottom: 40, left: 60 };
    const chartW = width - padding.left - padding.right;
    const chartH = height - padding.top - padding.bottom;

    const allValues = series.flatMap(s => s.data);
    const maxVal = Math.max(...allValues, 1000);

    const getX = (idx) => padding.left + (idx / (months.length - 1)) * chartW;
    const getY = (val) => padding.top + chartH - (val / maxVal) * chartH;

    let pathD = '';
    let circlesSvg = '';

    series.forEach(s => {
      let dStr = '';
      s.data.forEach((val, idx) => {
        const x = getX(idx);
        const y = getY(val);
        dStr += (idx === 0 ? `M ${x} ${y}` : ` L ${x} ${y}`);
        circlesSvg += `<circle cx="${x}" cy="${y}" r="4.5" fill="${s.color}"><title>${s.name} (${months[idx]}): ${val} kWh</title></circle>`;
      });
      pathD += `<path d="${dStr}" fill="none" stroke="${s.color}" stroke-width="2.5" />`;
    });

    let xLabels = months.map((m, i) => `
      <text x="${getX(i)}" y="${height - 12}" text-anchor="middle" font-size="11" fill="currentColor">${m}</text>
    `).join('');

    container.innerHTML = `
      <svg viewBox="0 0 ${width} ${height}" style="width: 100%; height: auto; max-height: 280px;">
        <line x1="${padding.left}" y1="${height - padding.bottom}" x2="${width - padding.right}" y2="${height - padding.bottom}" stroke="#cbd5e1" stroke-width="1.5"/>
        ${pathD}
        ${circlesSvg}
        ${xLabels}
      </svg>
    `;
  }
};
