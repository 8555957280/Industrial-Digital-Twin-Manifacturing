<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>System Monitoring — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    .sidebar { background: #1e293b; border-right: none; }
    .sidebar-nav a { color: #94a3b8; }
    .sidebar-nav a:hover { background: rgba(255,255,255,0.06); color: #f1f5f9; }
    .sidebar-nav a.active { background: rgba(255,255,255,0.1); color: #f1f5f9; }
    .nav-section-label { color: #475569 !important; }

    .service-row {
      display: flex; align-items: center; justify-content: space-between;
      padding: 0.75rem 0; border-bottom: 1px solid var(--color-border);
    }
    .service-row:last-child { border-bottom: none; }
    .service-name { font-weight: 600; font-size: 0.875rem; }
    .service-desc { font-size: 0.75rem; color: var(--color-text-muted); }

    .metric-row {
      display: flex; align-items: center; justify-content: space-between;
      padding: 0.5rem 0; border-bottom: 1px solid var(--color-border);
      font-size: 0.875rem;
    }
    .metric-row:last-child { border-bottom: none; }
    .metric-label { color: var(--color-text-muted); font-size: 0.8rem; }
    .metric-value { font-weight: 700; font-variant-numeric: tabular-nums; }
  </style>
</head>
<body>
<div class="app-layout">

  <!-- SIDEBAR -->
  <aside class="sidebar">
    <div class="sidebar-brand">
      <div class="logo-icon" style="background:rgba(255,255,255,0.1);">
        <svg width="18" height="18" fill="none" stroke="#f1f5f9" stroke-width="2" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
      </div>
      <div><div class="logo-text" style="color:#f1f5f9;">Admin Panel</div><div class="logo-sub" style="color:#64748b;">TestBench System</div></div>
    </div>
    <nav class="sidebar-nav">
      <div class="nav-section-label">Overview</div>
      <a href="${pageContext.request.contextPath}/adminDashboard">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
        Dashboard
      </a>
      <div class="nav-section-label">Management</div>
      <a href="${pageContext.request.contextPath}/manageUsers">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
        User Management
      </a>
      <a href="${pageContext.request.contextPath}/manageAAS">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/></svg>
        AAS Management
      </a>
      <a href="${pageContext.request.contextPath}/systemSettings">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/></svg>
        System Settings
      </a>
      <a href="${pageContext.request.contextPath}/dataManagement">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><ellipse cx="12" cy="5" rx="9" ry="3"/></svg>
        Data Management
      </a>
      <div class="nav-section-label">Monitoring</div>
      <a href="${pageContext.request.contextPath}/admin/monitoring.jsp" class="active">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
        System Monitoring
      </a>
    </nav>
    <div class="sidebar-footer" style="border-top:1px solid rgba(255,255,255,0.08);">
      <div class="sidebar-user">
        <div class="sidebar-avatar" style="background:rgba(255,255,255,0.15);">${adminName.substring(0,1).toUpperCase()}</div>
        <div class="sidebar-user-info">
          <div class="name" style="color:#f1f5f9;">${adminName}</div>
          <div class="role">Administrator</div>
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm"
         style="width:100%; justify-content:center; margin-top:0.5rem; border-color:rgba(255,255,255,0.15); color:#94a3b8;">
        Sign out
      </a>
    </div>
  </aside>

  <!-- MAIN -->
  <div class="main-content">
    <header class="topbar">
      <div style="display:flex; align-items:center; gap:0.75rem;">
        <div class="topbar-title">System Monitoring</div>
        <span class="live-dot"></span>
        <span id="sysTimestamp" style="font-size:0.75rem; color:var(--color-text-muted);">Live</span>
      </div>
      <div class="topbar-actions">
        <span class="badge badge-green" id="sysStatus">All Services Online</span>
      </div>
    </header>

    <div class="page-body">

      <!-- TOP METRIC CARDS -->
      <div class="stat-grid" style="margin-bottom:1.5rem;">
        <div class="stat-card">
          <div class="icon-wrap icon-teal">
            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
          </div>
          <div class="label">Edge Device</div>
          <div class="value" style="font-size:1.1rem;">RPI-001</div>
          <div class="unit" id="rpiStatus">● Online</div>
        </div>
        <div class="stat-card">
          <div class="icon-wrap icon-blue">
            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/></svg>
          </div>
          <div class="label">Database</div>
          <div class="value" style="font-size:1.1rem;">MySQL 8</div>
          <div class="unit" id="dbStatus">● Connected</div>
        </div>
        <div class="stat-card">
          <div class="icon-wrap icon-orange">
            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
          </div>
          <div class="label">Cloud Storage</div>
          <div class="value" style="font-size:1.1rem;">Cloudinary</div>
          <div class="unit" id="cloudStatus">● Connected</div>
        </div>
        <div class="stat-card">
          <div class="icon-wrap icon-green">
            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
          </div>
          <div class="label">Sensor Reads</div>
          <div class="value">${totalReadings}</div>
          <div class="unit">total collected</div>
        </div>
      </div>

      <!-- SERVICE STATUS + PERFORMANCE CHART -->
      <div style="display:grid; grid-template-columns:1fr 2fr; gap:1.25rem; margin-bottom:1.25rem;">

        <div class="card">
          <div class="card-header"><span class="card-title">Service Status</span></div>
          <div class="card-body">
            <div class="service-row">
              <div><div class="service-name">Tomcat 10 Server</div><div class="service-desc">Web application container</div></div>
              <span class="badge badge-green">Running</span>
            </div>
            <div class="service-row">
              <div><div class="service-name">MySQL 8</div><div class="service-desc">Primary database</div></div>
              <span class="badge badge-green">Connected</span>
            </div>
            <div class="service-row">
              <div><div class="service-name">Sensor API</div><div class="service-desc">/api/sensor endpoint</div></div>
              <span class="badge badge-green" id="apiStatus">Responding</span>
            </div>
            <div class="service-row">
              <div><div class="service-name">Cloudinary CDN</div><div class="service-desc">Cloud file storage</div></div>
              <span class="badge badge-green">Connected</span>
            </div>
            <div class="service-row">
              <div><div class="service-name">Reactive AAS</div><div class="service-desc">AAS-TEMP-01, AAS-FLOW-01</div></div>
              <span class="badge badge-green">Active</span>
            </div>
            <div class="service-row">
              <div><div class="service-name">Passive AAS</div><div class="service-desc">AAS-PRES-01, AAS-LEVEL-01</div></div>
              <span class="badge badge-green">Active</span>
            </div>
          </div>
        </div>

        <div class="card">
          <div class="card-header">
            <span class="card-title">Live Sensor Performance</span>
            <span class="live-dot"></span>
          </div>
          <div class="card-body">
            <div class="chart-box" style="height:280px;"><canvas id="perfChart"></canvas></div>
          </div>
        </div>
      </div>

      <!-- COMMUNICATION LOG + DEVICE HEALTH -->
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.25rem;">

        <div class="card">
          <div class="card-header"><span class="card-title">Edge Device Health — RPI-001</span></div>
          <div class="card-body">
            <div class="metric-row">
              <span class="metric-label">Device ID</span>
              <span class="metric-value">RPI-001</span>
            </div>
            <div class="metric-row">
              <span class="metric-label">Communication Protocol</span>
              <span class="metric-value">HTTP REST</span>
            </div>
            <div class="metric-row">
              <span class="metric-label">Poll Interval</span>
              <span class="metric-value">5 seconds</span>
            </div>
            <div class="metric-row">
              <span class="metric-label">Last Seen</span>
              <span class="metric-value" id="lastSeen">--</span>
            </div>
            <div class="metric-row">
              <span class="metric-label">Connection Status</span>
              <span class="metric-value"><span class="badge badge-green" id="connStatus">Online</span></span>
            </div>
            <div class="metric-row">
              <span class="metric-label">Total Records</span>
              <span class="metric-value">${totalReadings}</span>
            </div>
          </div>
        </div>

        <div class="card">
          <div class="card-header"><span class="card-title">Communication Log</span></div>
          <div class="card-body" style="padding:0;">
            <div id="commLog" style="max-height:260px; overflow-y:auto; padding:0.75rem;">
              <div style="text-align:center; color:var(--color-text-muted); font-size:0.85rem; padding:2rem;">
                Collecting communication events...
              </div>
            </div>
          </div>
        </div>

      </div>

    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
const MAX_LOG = 15;
const logItems = [];

const perfChart = new Chart(document.getElementById('perfChart'), {
  type: 'line',
  data: {
    labels: [],
    datasets: [
      { label: 'Temperature (°C)', data: [], borderColor: '#ea580c', borderWidth: 2, tension: 0.4, pointRadius: 0, fill: false },
      { label: 'Pressure (bar)',   data: [], borderColor: '#2563eb', borderWidth: 2, tension: 0.4, pointRadius: 0, fill: false },
      { label: 'Flow (L/min)',     data: [], borderColor: '#01696f', borderWidth: 2, tension: 0.4, pointRadius: 0, fill: false },
      { label: 'Level (%)',        data: [], borderColor: '#16a34a', borderWidth: 2, tension: 0.4, pointRadius: 0, fill: false }
    ]
  },
  options: {
    responsive: true, maintainAspectRatio: false,
    animation: { duration: 300 },
    plugins: { legend: { position: 'top', labels: { usePointStyle: true, font: { size: 11 } } } },
    scales: {
      x: { grid: { display: false }, ticks: { maxTicksLimit: 8, font: { size: 10 } } },
      y: { grid: { color: '#f1f5f9' }, ticks: { font: { size: 11 } } }
    }
  }
});

function addPerfPoint(time, d) {
  const data = perfChart.data;
  data.labels.push(time);
  const vals = [d.temperature, d.pressure, d.flowRate, d.level];
  vals.forEach((v, i) => { data.datasets[i].data.push(v); });
  if (data.labels.length > 30) {
    data.labels.shift();
    data.datasets.forEach(ds => ds.data.shift());
  }
  perfChart.update('none');
}

function addLogEntry(msg, type) {
  const time = new Date().toLocaleTimeString();
  const color = type === 'error' ? '#ef4444' : type === 'warn' ? '#d97706' : '#16a34a';
  logItems.unshift({ time, msg, color });
  if (logItems.length > MAX_LOG) logItems.pop();
  const el = document.getElementById('commLog');
  if (el) {
    el.innerHTML = logItems.map(l =>
      `<div style="display:flex;gap:0.5rem;padding:0.375rem 0;border-bottom:1px solid var(--color-border);font-size:0.8rem;">
        <span style="color:var(--color-text-muted);flex-shrink:0;">${l.time}</span>
        <span style="color:${l.color};">●</span>
        <span>${l.msg}</span>
      </div>`
    ).join('');
  }
}

function pollAdmin() {
  const start = Date.now();
  fetch('${pageContext.request.contextPath}/api/sensor')
    .then(r => r.json())
    .then(d => {
      const elapsed = Date.now() - start;
      const now = new Date().toLocaleTimeString();

      addPerfPoint(now, d);
      addLogEntry(`RPI-001 → Temp:${parseFloat(d.temperature).toFixed(1)}°C  Pres:${parseFloat(d.pressure).toFixed(2)}bar  (${elapsed}ms)`, 'ok');

      document.getElementById('lastSeen').textContent = now;
      document.getElementById('sysTimestamp').textContent = 'Updated: ' + now;
      document.getElementById('apiStatus').textContent = 'Responding (' + elapsed + 'ms)';
      document.getElementById('connStatus').className = 'badge badge-green';
      document.getElementById('connStatus').textContent = 'Online';
    })
    .catch(() => {
      addLogEntry('RPI-001 → Connection failed', 'error');
      document.getElementById('connStatus').className = 'badge badge-red';
      document.getElementById('connStatus').textContent = 'Offline';
      document.getElementById('apiStatus').textContent = 'Not Responding';
      document.getElementById('sysStatus').className = 'badge badge-red';
      document.getElementById('sysStatus').textContent = 'Service Failure';
    });
}

// Also need to pass totalReadings from servlet
// Add this mapping in web.xml or use AdminDashboardServlet data
pollAdmin();
setInterval(pollAdmin, 5000);
</script>
</body>
</html>