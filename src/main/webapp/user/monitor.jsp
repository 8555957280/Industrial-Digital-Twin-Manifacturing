<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Live Monitor — Test Bench</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="app-layout">

  <!-- SIDEBAR -->
  <aside class="sidebar">
    <div class="sidebar-brand">
      <div class="logo-icon">
        <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M9 3H5a2 2 0 0 0-2 2v4m6-6h10a2 2 0 0 1 2 2v4M9 3v18m0 0h10a2 2 0 0 0 2-2V9M9 21H5a2 2 0 0 1-2-2V9m0 0h18"/>
        </svg>
      </div>
      <div><div class="logo-text">TestBench</div><div class="logo-sub">Monitor and Control</div></div>
    </div>
    <nav class="sidebar-nav">
      <div class="nav-section-label">Main</div>
      <a href="${pageContext.request.contextPath}/userDashboard">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
        Dashboard
      </a>
      <a href="${pageContext.request.contextPath}/user/monitor.jsp" class="active">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
        Live Monitor
      </a>
      <a href="${pageContext.request.contextPath}/control">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.07 4.93a10 10 0 0 1 0 14.14"/><path d="M4.93 4.93a10 10 0 0 0 0 14.14"/></svg>
        Control Panel
      </a>
      <div class="nav-section-label">Reports</div>
      <a href="${pageContext.request.contextPath}/user/reports.jsp">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
        Reports
      </a>
      <a href="${pageContext.request.contextPath}/export">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
        Export CSV
      </a>
      <a href="${pageContext.request.contextPath}/notifications">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
        Notifications
      </a>
    </nav>
    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="sidebar-avatar">${userName.substring(0,1).toUpperCase()}</div>
        <div class="sidebar-user-info">
          <div class="name">${userName}</div>
          <div class="role">User</div>
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm"
         style="width:100%; justify-content:center; margin-top:0.5rem;">Sign out</a>
    </div>
  </aside>

  <!-- MAIN -->
  <div class="main-content">
    <header class="topbar">
      <div style="display:flex; align-items:center; gap:0.75rem;">
        <div class="topbar-title">Live Monitor</div>
        <span class="live-dot"></span>
        <span id="lastUpdated" style="font-size:0.75rem; color:var(--color-text-muted);">Connecting...</span>
      </div>
      <div class="topbar-actions">
        <span class="badge badge-green" id="deviceStatus">RPI-001 Online</span>
        <span id="refreshCountdown" style="font-size:0.75rem; color:var(--color-text-muted);">Next refresh: 5s</span>
      </div>
    </header>

    <div class="page-body">

      <!-- LIVE VALUE CARDS -->
      <div class="stat-grid" style="margin-bottom:1.5rem;">

        <div class="stat-card" id="card-temperature">
          <div style="display:flex; justify-content:space-between; align-items:flex-start;">
            <div class="icon-wrap icon-orange">
              <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M14 14.76V3.5a2.5 2.5 0 0 0-5 0v11.26a4.5 4.5 0 1 0 5 0z"/></svg>
            </div>
            <span id="tempStatus" class="badge badge-green">Normal</span>
          </div>
          <div class="label" style="margin-top:0.5rem;">Temperature</div>
          <div class="value" id="tempVal">--</div>
          <div class="unit">°C — Limit: 10–85°C</div>
          <div class="gauge-track" style="margin-top:0.5rem;">
            <div class="gauge-fill" id="tempGauge" style="width:0%"></div>
          </div>
        </div>

        <div class="stat-card" id="card-pressure">
          <div style="display:flex; justify-content:space-between; align-items:flex-start;">
            <div class="icon-wrap icon-blue">
              <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
            </div>
            <span id="presStatus" class="badge badge-green">Normal</span>
          </div>
          <div class="label" style="margin-top:0.5rem;">Pressure</div>
          <div class="value" id="presVal">--</div>
          <div class="unit">bar — Limit: 1–10 bar</div>
          <div class="gauge-track" style="margin-top:0.5rem;">
            <div class="gauge-fill" id="presGauge" style="width:0%"></div>
          </div>
        </div>

        <div class="stat-card" id="card-flow">
          <div style="display:flex; justify-content:space-between; align-items:flex-start;">
            <div class="icon-wrap icon-teal">
              <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
            </div>
            <span id="flowStatus" class="badge badge-green">Normal</span>
          </div>
          <div class="label" style="margin-top:0.5rem;">Flow Rate</div>
          <div class="value" id="flowVal">--</div>
          <div class="unit">L/min — Limit: 0.5–50 L/min</div>
          <div class="gauge-track" style="margin-top:0.5rem;">
            <div class="gauge-fill" id="flowGauge" style="width:0%"></div>
          </div>
        </div>

        <div class="stat-card" id="card-level">
          <div style="display:flex; justify-content:space-between; align-items:flex-start;">
            <div class="icon-wrap icon-green">
              <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
            </div>
            <span id="levelStatus" class="badge badge-green">Normal</span>
          </div>
          <div class="label" style="margin-top:0.5rem;">Level</div>
          <div class="value" id="levelVal">--</div>
          <div class="unit">% — Limit: 5–95%</div>
          <div class="gauge-track" style="margin-top:0.5rem;">
            <div class="gauge-fill" id="levelGauge" style="width:0%"></div>
          </div>
        </div>
      </div>

      <!-- LIVE CHARTS (4 individual charts) -->
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.25rem; margin-bottom:1.25rem;">

        <div class="card">
          <div class="card-header">
            <span class="card-title">Temperature Trend</span>
            <span style="font-size:0.72rem; color:var(--color-text-muted);">Last 30 readings</span>
          </div>
          <div class="card-body">
            <div class="chart-box"><canvas id="chartTemp"></canvas></div>
          </div>
        </div>

        <div class="card">
          <div class="card-header">
            <span class="card-title">Pressure Trend</span>
            <span style="font-size:0.72rem; color:var(--color-text-muted);">Last 30 readings</span>
          </div>
          <div class="card-body">
            <div class="chart-box"><canvas id="chartPres"></canvas></div>
          </div>
        </div>

        <div class="card">
          <div class="card-header">
            <span class="card-title">Flow Rate Trend</span>
            <span style="font-size:0.72rem; color:var(--color-text-muted);">Last 30 readings</span>
          </div>
          <div class="card-body">
            <div class="chart-box"><canvas id="chartFlow"></canvas></div>
          </div>
        </div>

        <div class="card">
          <div class="card-header">
            <span class="card-title">Level Trend</span>
            <span style="font-size:0.72rem; color:var(--color-text-muted);">Last 30 readings</span>
          </div>
          <div class="card-body">
            <div class="chart-box"><canvas id="chartLevel"></canvas></div>
          </div>
        </div>
      </div>

      <!-- DEVICE INFO ROW -->
      <div class="card">
        <div class="card-header"><span class="card-title">Device Information</span></div>
        <div class="card-body">
          <div style="display:grid; grid-template-columns:repeat(auto-fill,minmax(200px,1fr)); gap:1rem;">
            <div>
              <div style="font-size:0.72rem; color:var(--color-text-muted); font-weight:600; text-transform:uppercase; margin-bottom:0.25rem;">Device ID</div>
              <div style="font-weight:700;" id="deviceId">RPI-001</div>
            </div>
            <div>
              <div style="font-size:0.72rem; color:var(--color-text-muted); font-weight:600; text-transform:uppercase; margin-bottom:0.25rem;">Protocol</div>
              <div style="font-weight:700;">HTTP Polling (5s)</div>
            </div>
            <div>
              <div style="font-size:0.72rem; color:var(--color-text-muted); font-weight:600; text-transform:uppercase; margin-bottom:0.25rem;">AAS Interface</div>
              <div style="font-weight:700;">Reactive AAS Active</div>
            </div>
            <div>
              <div style="font-size:0.72rem; color:var(--color-text-muted); font-weight:600; text-transform:uppercase; margin-bottom:0.25rem;">Last Timestamp</div>
              <div style="font-weight:700;" id="deviceTimestamp">--</div>
            </div>
          </div>
        </div>
      </div>

    </div><!-- /page-body -->
  </div><!-- /main-content -->
</div><!-- /app-layout -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
// ─── CHART SETUP ────────────────────────────────────────────────────
const MAX_POINTS = 30;

function makeChart(canvasId, label, color) {
  return new Chart(document.getElementById(canvasId), {
    type: 'line',
    data: {
      labels: [],
      datasets: [{
        label: label,
        data: [],
        borderColor: color,
        backgroundColor: color + '18',
        borderWidth: 2,
        tension: 0.4,
        pointRadius: 2,
        pointHoverRadius: 4,
        fill: true
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      animation: { duration: 300 },
      plugins: { legend: { display: false } },
      scales: {
        x: { grid: { display: false }, ticks: { maxTicksLimit: 6, font: { size: 10 } } },
        y: { grid: { color: '#f1f5f9' }, ticks: { font: { size: 11 } } }
      }
    }
  });
}

const charts = {
  temp:  makeChart('chartTemp',  'Temperature (°C)', '#ea580c'),
  pres:  makeChart('chartPres',  'Pressure (bar)',   '#2563eb'),
  flow:  makeChart('chartFlow',  'Flow Rate (L/min)','#01696f'),
  level: makeChart('chartLevel', 'Level (%)',         '#16a34a')
};

function addChartPoint(chart, time, value) {
  const data = chart.data;
  data.labels.push(time);
  data.datasets[0].data.push(value);
  if (data.labels.length > MAX_POINTS) {
    data.labels.shift();
    data.datasets[0].data.shift();
  }
  chart.update('none');
}

// ─── THRESHOLD LIMITS ───────────────────────────────────────────────
const limits = {
  temperature: { min: 10,  max: 85,  chartMax: 100 },
  pressure:    { min: 1,   max: 10,  chartMax: 12  },
  flowRate:    { min: 0.5, max: 50,  chartMax: 60  },
  level:       { min: 5,   max: 95,  chartMax: 100 }
};

function getStatusBadge(value, min, max) {
  if (value > max || value < min) return { cls: 'badge-red', text: 'ALERT' };
  if (value > max * 0.85 || value < min * 1.2) return { cls: 'badge-yellow', text: 'Warning' };
  return { cls: 'badge-green', text: 'Normal' };
}

function updateStatusBadge(id, status) {
  const el = document.getElementById(id);
  if (!el) return;
  el.className = 'badge ' + status.cls;
  el.textContent = status.text;
}

function flashCard(cardId, isAlert) {
  const el = document.getElementById(cardId);
  if (!el) return;
  el.style.borderColor = isAlert ? '#ef4444' : '';
  el.style.boxShadow   = isAlert ? '0 0 0 3px rgba(239,68,68,0.15)' : '';
}

// ─── COUNTDOWN TIMER ────────────────────────────────────────────────
let countdown = 5;
setInterval(() => {
  countdown--;
  if (countdown <= 0) countdown = 5;
  const el = document.getElementById('refreshCountdown');
  if (el) el.textContent = 'Next refresh: ' + countdown + 's';
}, 1000);

// ─── LIVE POLL ───────────────────────────────────────────────────────
function pollSensor() {
  fetch('${pageContext.request.contextPath}/api/sensor')
    .then(r => r.json())
    .then(d => {
      const now = new Date().toLocaleTimeString();

      // Update value cards
      document.getElementById('tempVal').textContent  = parseFloat(d.temperature).toFixed(2) + ' °C';
      document.getElementById('presVal').textContent  = parseFloat(d.pressure).toFixed(2)    + ' bar';
      document.getElementById('flowVal').textContent  = parseFloat(d.flowRate).toFixed(2)    + ' L/min';
      document.getElementById('levelVal').textContent = parseFloat(d.level).toFixed(2)       + ' %';
      document.getElementById('deviceId').textContent = d.deviceId || 'RPI-001';
      document.getElementById('deviceTimestamp').textContent = now;

      // Update gauges
      setGauge('tempGauge',  d.temperature, 0, 100);
      setGauge('presGauge',  d.pressure,    0, 12);
      setGauge('flowGauge',  d.flowRate,    0, 60);
      setGauge('levelGauge', d.level,       0, 100);

      // Update status badges
      updateStatusBadge('tempStatus',  getStatusBadge(d.temperature, limits.temperature.min,  limits.temperature.max));
      updateStatusBadge('presStatus',  getStatusBadge(d.pressure,    limits.pressure.min,     limits.pressure.max));
      updateStatusBadge('flowStatus',  getStatusBadge(d.flowRate,    limits.flowRate.min,     limits.flowRate.max));
      updateStatusBadge('levelStatus', getStatusBadge(d.level,       limits.level.min,        limits.level.max));

      // Flash alert cards
      flashCard('card-temperature', d.temperature > limits.temperature.max || d.temperature < limits.temperature.min);
      flashCard('card-pressure',    d.pressure    > limits.pressure.max    || d.pressure    < limits.pressure.min);
      flashCard('card-flow',        d.flowRate    > limits.flowRate.max    || d.flowRate    < limits.flowRate.min);
      flashCard('card-level',       d.level       > limits.level.max       || d.level       < limits.level.min);

      // Push to charts
      addChartPoint(charts.temp,  now, d.temperature);
      addChartPoint(charts.pres,  now, d.pressure);
      addChartPoint(charts.flow,  now, d.flowRate);
      addChartPoint(charts.level, now, d.level);

      // Timestamp
      document.getElementById('lastUpdated').textContent = 'Last updated: ' + now;
      document.getElementById('deviceStatus').textContent = d.deviceId + ' Online';
    })
    .catch(() => {
      document.getElementById('lastUpdated').textContent = 'Connection error';
      document.getElementById('deviceStatus').className  = 'badge badge-red';
      document.getElementById('deviceStatus').textContent = 'Offline';
    });
}

// Initial load + repeat
pollSensor();
setInterval(pollSensor, 5000);
</script>
</body>
</html>