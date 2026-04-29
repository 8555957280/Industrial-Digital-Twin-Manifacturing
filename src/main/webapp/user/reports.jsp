<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reports — Test Bench</title>
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
      <a href="${pageContext.request.contextPath}/user/monitor.jsp">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
        Live Monitor
      </a>
      <a href="${pageContext.request.contextPath}/control">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.07 4.93a10 10 0 0 1 0 14.14"/><path d="M4.93 4.93a10 10 0 0 0 0 14.14"/></svg>
        Control Panel
      </a>
      <div class="nav-section-label">Reports</div>
      <a href="${pageContext.request.contextPath}/user/reports.jsp" class="active">
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
      <div class="topbar-title">Reports and Analytics</div>
      <div class="topbar-actions">
        <a href="${pageContext.request.contextPath}/export" class="btn btn-primary btn-sm">
          <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
          Download CSV
        </a>
      </div>
    </header>

    <div class="page-body">

      <!-- SUMMARY STATS (computed from recentData passed by servlet) -->
      <div class="stat-grid" style="margin-bottom:1.5rem;">
        <div class="stat-card">
          <div class="label">Total Records</div>
          <div class="value">${totalReadings}</div>
          <div class="unit">sensor readings</div>
        </div>
        <div class="stat-card">
          <div class="label">Avg Temperature</div>
          <div class="value" id="avgTemp">--</div>
          <div class="unit">°C (last 50 readings)</div>
        </div>
        <div class="stat-card">
          <div class="label">Avg Pressure</div>
          <div class="value" id="avgPres">--</div>
          <div class="unit">bar (last 50 readings)</div>
        </div>
        <div class="stat-card">
          <div class="label">Avg Flow Rate</div>
          <div class="value" id="avgFlow">--</div>
          <div class="unit">L/min (last 50 readings)</div>
        </div>
      </div>

      <!-- ANALYTICS CHARTS -->
      <div style="display:grid; grid-template-columns:2fr 1fr; gap:1.25rem; margin-bottom:1.25rem;">

        <div class="card">
          <div class="card-header">
            <span class="card-title">Temperature &amp; Pressure — Historical Trend</span>
          </div>
          <div class="card-body">
            <div class="chart-box" style="height:280px;"><canvas id="reportTrendChart"></canvas></div>
          </div>
        </div>

        <div class="card">
          <div class="card-header"><span class="card-title">Variable Distribution</span></div>
          <div class="card-body">
            <div class="chart-box" style="height:280px;"><canvas id="reportRadarChart"></canvas></div>
          </div>
        </div>
      </div>

      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.25rem; margin-bottom:1.25rem;">

        <div class="card">
          <div class="card-header"><span class="card-title">Flow Rate Trend</span></div>
          <div class="card-body">
            <div class="chart-box"><canvas id="reportFlowChart"></canvas></div>
          </div>
        </div>

        <div class="card">
          <div class="card-header"><span class="card-title">Level Trend</span></div>
          <div class="card-body">
            <div class="chart-box"><canvas id="reportLevelChart"></canvas></div>
          </div>
        </div>
      </div>

      <!-- SUMMARY TABLE -->
      <div class="card">
        <div class="card-header">
          <span class="card-title">System Performance Summary</span>
          <a href="${pageContext.request.contextPath}/export" class="btn btn-outline btn-sm">
            ↓ Export All Data
          </a>
        </div>
        <div style="overflow-x:auto;">
          <table class="data-table">
            <thead>
              <tr>
                <th>Metric</th>
                <th>Current</th>
                <th>Min (50 samples)</th>
                <th>Max (50 samples)</th>
                <th>Average</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody id="summaryTableBody">
              <tr><td colspan="6" style="text-align:center; color:var(--color-text-muted); padding:2rem;">Loading data...</td></tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- PRINT REPORT BUTTON -->
      <div style="display:flex; gap:0.75rem; margin-top:1rem;">
        <button class="btn btn-outline" onclick="window.print()">
          <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
          Print Report
        </button>
        <a href="${pageContext.request.contextPath}/export" class="btn btn-primary">
          <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
          Download CSV
        </a>
      </div>

    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
// Build charts from server-rendered JSP data
const rows = [
  <c:forEach var="row" items="${recentData}" varStatus="st">
    { t: ${row.temperature}, p: ${row.pressure}, f: ${row.flowRate}, l: ${row.level}, ts: "${row.recordedAt}" }<c:if test="${!st.last}">,</c:if>
  </c:forEach>
].reverse();

const labels = rows.map(r => r.ts.substring(11,16));
const temps  = rows.map(r => r.t);
const pres   = rows.map(r => r.p);
const flows  = rows.map(r => r.f);
const levels = rows.map(r => r.l);

// Compute stats
function avg(arr) { return arr.length ? (arr.reduce((a,b)=>a+b,0)/arr.length).toFixed(2) : '--'; }
function minv(arr){ return arr.length ? Math.min(...arr).toFixed(2) : '--'; }
function maxv(arr){ return arr.length ? Math.max(...arr).toFixed(2) : '--'; }

document.getElementById('avgTemp').textContent = avg(temps) + ' °C';
document.getElementById('avgPres').textContent = avg(pres)  + ' bar';
document.getElementById('avgFlow').textContent = avg(flows) + ' L/min';

// Summary table
const tbody = document.getElementById('summaryTableBody');
const latestRow = rows[rows.length - 1] || {};
const metrics = [
  { name: 'Temperature (°C)', cur: latestRow.t, arr: temps,  min: 10,  max: 85  },
  { name: 'Pressure (bar)',   cur: latestRow.p, arr: pres,   min: 1,   max: 10  },
  { name: 'Flow Rate (L/min)',cur: latestRow.f, arr: flows,  min: 0.5, max: 50  },
  { name: 'Level (%)',        cur: latestRow.l, arr: levels, min: 5,   max: 95  }
];

tbody.innerHTML = metrics.map(m => {
  const curNum = parseFloat(m.cur);
  const isAlert = curNum > m.max || curNum < m.min;
  const badgeCls = isAlert ? 'badge-red' : 'badge-green';
  const badgeTxt = isAlert ? 'Alert' : 'Normal';
  return `<tr>
    <td style="font-weight:600;">${m.name}</td>
    <td style="font-variant-numeric:tabular-nums;">${curNum.toFixed(2)}</td>
    <td style="font-variant-numeric:tabular-nums;">${minv(m.arr)}</td>
    <td style="font-variant-numeric:tabular-nums;">${maxv(m.arr)}</td>
    <td style="font-variant-numeric:tabular-nums;">${avg(m.arr)}</td>
    <td><span class="badge ${badgeCls}">${badgeTxt}</span></td>
  </tr>`;
}).join('');

// Chart options helper
const chartOpts = (yLabel) => ({
  responsive: true, maintainAspectRatio: false,
  plugins: { legend: { position: 'top', labels: { usePointStyle: true, font: { size: 11 } } } },
  scales: {
    x: { grid: { display: false }, ticks: { maxTicksLimit: 8, font: { size: 10 } } },
    y: { title: { display: true, text: yLabel, font: { size: 11 } }, grid: { color: '#f1f5f9' }, ticks: { font: { size: 11 } } }
  },
  elements: { point: { radius: 0 }, line: { tension: 0.4, borderWidth: 2 } }
});

// Trend chart (Temp + Pressure)
new Chart(document.getElementById('reportTrendChart'), {
  type: 'line',
  data: {
    labels,
    datasets: [
      { label: 'Temperature (°C)', data: temps, borderColor: '#ea580c', backgroundColor: 'rgba(234,88,12,0.06)', fill: true, tension: 0.4, borderWidth: 2, pointRadius: 0 },
      { label: 'Pressure (bar)',   data: pres,  borderColor: '#2563eb', backgroundColor: 'rgba(37,99,235,0.06)', fill: true, tension: 0.4, borderWidth: 2, pointRadius: 0 }
    ]
  },
  options: chartOpts('Value')
});

// Radar chart
new Chart(document.getElementById('reportRadarChart'), {
  type: 'radar',
  data: {
    labels: ['Temperature', 'Pressure', 'Flow Rate', 'Level'],
    datasets: [{
      label: 'Avg Values (normalised)',
      data: [
        (parseFloat(avg(temps))  / 85  * 100).toFixed(1),
        (parseFloat(avg(pres))   / 10  * 100).toFixed(1),
        (parseFloat(avg(flows))  / 50  * 100).toFixed(1),
        (parseFloat(avg(levels)) / 100 * 100).toFixed(1)
      ],
      backgroundColor: 'rgba(1,105,111,0.15)',
      borderColor: '#01696f',
      borderWidth: 2,
      pointBackgroundColor: '#01696f'
    }]
  },
  options: {
    responsive: true, maintainAspectRatio: false,
    scales: { r: { beginAtZero: true, max: 100, ticks: { font: { size: 10 } } } },
    plugins: { legend: { display: false } }
  }
});

// Flow chart
new Chart(document.getElementById('reportFlowChart'), {
  type: 'line',
  data: { labels, datasets: [{ label: 'Flow Rate (L/min)', data: flows, borderColor: '#01696f', backgroundColor: 'rgba(1,105,111,0.06)', fill: true, tension: 0.4, borderWidth: 2, pointRadius: 0 }] },
  options: chartOpts('L/min')
});

// Level chart
new Chart(document.getElementById('reportLevelChart'), {
  type: 'line',
  data: { labels, datasets: [{ label: 'Level (%)', data: levels, borderColor: '#16a34a', backgroundColor: 'rgba(22,163,74,0.06)', fill: true, tension: 0.4, borderWidth: 2, pointRadius: 0 }] },
  options: chartOpts('%')
});
</script>
</body>
</html>