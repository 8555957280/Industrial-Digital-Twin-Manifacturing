<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard — Test Bench</title>
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
      <div>
        <div class="logo-text">TestBench</div>
        <div class="logo-sub">Monitor and Control</div>
      </div>
    </div>
    <nav class="sidebar-nav">
      <div class="nav-section-label">Main</div>
      <a href="${pageContext.request.contextPath}/userDashboard" class="active">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
        Dashboard
      </a>
      <a href="${pageContext.request.contextPath}/userDashboard">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
        Live Monitor
      </a>
      <a href="${pageContext.request.contextPath}/control">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.07 4.93a10 10 0 0 1 0 14.14"/><path d="M4.93 4.93a10 10 0 0 0 0 14.14"/></svg>
        Control Panel
      </a>
      <div class="nav-section-label">Reports</div>
      <a href="${pageContext.request.contextPath}/export">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
        Export CSV
      </a>
      <a href="${pageContext.request.contextPath}/notifications">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
        Notifications
        <c:if test="${unreadAlerts > 0}"><span class="badge badge-red" style="margin-left:auto;">${unreadAlerts}</span></c:if>
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
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%; justify-content:center; margin-top:0.5rem;">
        Sign out
      </a>
    </div>
  </aside>

  <!-- MAIN -->
  <div class="main-content">
    <header class="topbar">
      <div style="display:flex; align-items:center; gap:0.75rem;">
        <button class="icon-btn" onclick="toggleSidebar()" style="display:none;" id="menuBtn">☰</button>
        <div class="topbar-title">Dashboard</div>
        <span class="live-dot"></span>
        <span id="lastUpdated" style="font-size:0.75rem; color:var(--color-text-muted);">Live</span>
      </div>
      <div class="topbar-actions">
        <span class="badge badge-green">RPI-001 Online</span>
        <a href="${pageContext.request.contextPath}/notifications" class="icon-btn">
          <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
        </a>
      </div>
    </header>

    <div class="page-body">

      <!-- KPI CARDS -->
      <div class="stat-grid">
        <div class="stat-card" id="tempCard">
          <div class="icon-wrap icon-orange">
            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M14 14.76V3.5a2.5 2.5 0 0 0-5 0v11.26a4.5 4.5 0 1 0 5 0z"/></svg>
          </div>
          <div class="label">Temperature</div>
          <div class="value" id="tempVal">
            <c:if test="${latest != null}"><fmt:formatNumber value="${latest.temperature}" maxFractionDigits="2"/> °C</c:if>
            <c:if test="${latest == null}">--</c:if>
          </div>
        </div>
        <div class="stat-card">
          <div class="icon-wrap icon-blue">
            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"/><path d="M12 8v4l3 3"/></svg>
          </div>
          <div class="label">Pressure</div>
          <div class="value" id="presVal">
            <c:if test="${latest != null}"><fmt:formatNumber value="${latest.pressure}" maxFractionDigits="2"/> bar</c:if>
            <c:if test="${latest == null}">--</c:if>
          </div>
        </div>
        <div class="stat-card">
          <div class="icon-wrap icon-teal">
            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
          </div>
          <div class="label">Flow Rate</div>
          <div class="value" id="flowVal">
            <c:if test="${latest != null}"><fmt:formatNumber value="${latest.flowRate}" maxFractionDigits="2"/> L/m</c:if>
            <c:if test="${latest == null}">--</c:if>
          </div>
        </div>
        <div class="stat-card">
          <div class="icon-wrap icon-green">
            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
          </div>
          <div class="label">Level</div>
          <div class="value" id="levelVal">
            <c:if test="${latest != null}"><fmt:formatNumber value="${latest.level}" maxFractionDigits="2"/> %</c:if>
            <c:if test="${latest == null}">--</c:if>
          </div>
        </div>
      </div>

      <!-- GAUGE + TREND CHARTS -->
      <div style="display:grid; grid-template-columns:1fr 2fr; gap:1.25rem;">

        <div class="card">
          <div class="card-header"><span class="card-title">Live Gauges</span></div>
          <div class="card-body">
            <div class="gauge-wrap">
              <div class="gauge-label"><span class="name">Temperature</span><span class="val" id="tGaugeLbl"></span></div>
              <div class="gauge-track"><div class="gauge-fill" id="tempGauge" style="width:0%"></div></div>
            </div>
            <div class="gauge-wrap">
              <div class="gauge-label"><span class="name">Pressure</span><span class="val" id="pGaugeLbl"></span></div>
              <div class="gauge-track"><div class="gauge-fill" id="presGauge" style="width:0%"></div></div>
            </div>
            <div class="gauge-wrap">
              <div class="gauge-label"><span class="name">Flow Rate</span><span class="val" id="fGaugeLbl"></span></div>
              <div class="gauge-track"><div class="gauge-fill" id="flowGauge" style="width:0%"></div></div>
            </div>
            <div class="gauge-wrap">
              <div class="gauge-label"><span class="name">Level</span><span class="val" id="lGaugeLbl"></span></div>
              <div class="gauge-track"><div class="gauge-fill" id="levelGauge" style="width:0%"></div></div>
            </div>
          </div>
        </div>

        <div class="card">
          <div class="card-header">
            <span class="card-title">Historical Trend</span>
            <a href="${pageContext.request.contextPath}/export" class="btn btn-outline btn-sm">↓ Export CSV</a>
          </div>
          <div class="card-body">
            <div class="chart-box"><canvas id="trendChart"></canvas></div>
          </div>
        </div>
      </div>

      <!-- RECENT DATA TABLE -->
      <div class="card">
        <div class="card-header"><span class="card-title">Recent Readings</span><span style="font-size:0.75rem; color:var(--color-text-muted);">Latest 50 records</span></div>
        <div style="overflow-x:auto;">
          <table class="data-table">
            <thead>
              <tr><th>#</th><th>Temperature (°C)</th><th>Pressure (bar)</th><th>Flow Rate (L/min)</th><th>Level (%)</th><th>Device</th><th>Recorded At</th></tr>
            </thead>
            <tbody>
              <c:forEach var="row" items="${recentData}" varStatus="st">
              <tr>
                <td>${st.count}</td>
                <td><fmt:formatNumber value="${row.temperature}" maxFractionDigits="2"/></td>
                <td><fmt:formatNumber value="${row.pressure}" maxFractionDigits="2"/></td>
                <td><fmt:formatNumber value="${row.flowRate}" maxFractionDigits="2"/></td>
                <td><fmt:formatNumber value="${row.level}" maxFractionDigits="2"/></td>
                <td><span class="badge badge-blue">${row.deviceId}</span></td>
                <td style="color:var(--color-text-muted); font-size:0.8rem;">${row.recordedAt}</td>
              </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>

    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
  // Build trend chart from server data
  const ctx = document.getElementById('trendChart');
  if (ctx) {
    const labels = [];
    const temps  = [];
    const pressures = [];

    // Populate from JSTL rendered JSON
    const rows = [
      <c:forEach var="row" items="${recentData}" varStatus="st">
        { t: ${row.temperature}, p: ${row.pressure}, ts: "${row.recordedAt}" }<c:if test="${!st.last}">,</c:if>
      </c:forEach>
    ].reverse();

    rows.forEach(r => {
      labels.push(r.ts.substring(11,16));
      temps.push(r.t);
      pressures.push(r.p);
    });

    new Chart(ctx, {
      type: 'line',
      data: {
        labels,
        datasets: [
          { label: 'Temperature (°C)', data: temps, borderColor: '#ea580c', backgroundColor: 'rgba(234,88,12,0.06)', tension: 0.4, borderWidth: 2, pointRadius: 0 },
          { label: 'Pressure (bar)',   data: pressures, borderColor: '#2563eb', backgroundColor: 'rgba(37,99,235,0.06)', tension: 0.4, borderWidth: 2, pointRadius: 0 }
        ]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { position: 'top', labels: { usePointStyle: true, font: { size: 11 } } } },
        scales: {
          x: { grid: { display: false }, ticks: { maxTicksLimit: 10, font: { size: 10 } } },
          y: { grid: { color: '#f1f5f9' }, ticks: { font: { size: 11 } } }
        }
      }
    });
  }

  // Start live polling
  startLivePolling('${pageContext.request.contextPath}');
</script>
</body>
</html>