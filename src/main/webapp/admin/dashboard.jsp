<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard &amp; Test Bench</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    .sidebar {
      background: #1e293b;
      border-right: none;
    }
    .sidebar-brand .logo-text { color: #f1f5f9; }
    .sidebar-brand .logo-sub  { color: #64748b; }
    .sidebar-nav a            { color: #94a3b8; }
    .sidebar-nav a:hover      { background: rgba(255,255,255,0.06); color: #f1f5f9; }
    .sidebar-nav a.active     { background: rgba(255,255,255,0.12); color: #f1f5f9; font-weight: 600; }
    .nav-section-label        { color: #475569 !important; }
    .sidebar-footer           { border-top: 1px solid rgba(255,255,255,0.08); }
    .sidebar-user .name       { color: #e2e8f0; }
    .sidebar-user .role       { color: #64748b; }
    .admin-topbar-badge       { background: rgba(255,255,255,0.1); color: #f1f5f9; border-radius: 6px; padding: 3px 10px; font-size: 0.75rem; font-weight: 600; }
    .summary-grid             { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 1rem; margin-bottom: 1.5rem; }
    .summary-card             { background: #fff; border: 1px solid var(--color-border); border-radius: var(--radius); padding: 1.25rem; display: flex; flex-direction: column; gap: 0.375rem; transition: box-shadow 180ms; }
    .summary-card:hover       { box-shadow: var(--shadow-md); }
    .summary-card .s-label    { font-size: 0.72rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.06em; color: var(--color-text-muted); }
    .summary-card .s-value    { font-size: 1.9rem; font-weight: 800; color: var(--color-text); font-variant-numeric: tabular-nums; line-height: 1; }
    .summary-card .s-sub      { font-size: 0.75rem; color: var(--color-text-muted); }
    .summary-card .s-icon     { width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; margin-bottom: 0.25rem; }
    .two-col                  { display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem; margin-bottom: 1.25rem; }
    .three-col                { display: grid; grid-template-columns: 2fr 1fr; gap: 1.25rem; margin-bottom: 1.25rem; }
    @media (max-width: 900px) { .two-col, .three-col { grid-template-columns: 1fr; } }
  </style>
</head>
<body>

<div class="app-layout">

  <!-- ═══════════════════════════ SIDEBAR ═══════════════════════════ -->
  <aside class="sidebar">

    <div class="sidebar-brand">
      <div class="logo-icon" style="background: rgba(255,255,255,0.1);">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
             stroke="#f1f5f9" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
        </svg>
      </div>
      <div>
        <div class="logo-text">Admin Panel</div>
        <div class="logo-sub">TestBench System</div>
      </div>
    </div>

    <nav class="sidebar-nav">

      <div class="nav-section-label">Overview</div>
      <a href="${pageContext.request.contextPath}/adminDashboard" class="active">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <rect x="3" y="3" width="7" height="7"/>
          <rect x="14" y="3" width="7" height="7"/>
          <rect x="14" y="14" width="7" height="7"/>
          <rect x="3" y="14" width="7" height="7"/>
        </svg>
        Dashboard
      </a>

      <div class="nav-section-label">Management</div>
      <a href="${pageContext.request.contextPath}/manageUsers">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
          <circle cx="9" cy="7" r="4"/>
          <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
          <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
        </svg>
        User Management
      </a>

      <a href="${pageContext.request.contextPath}/manageAAS">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="3"/>
          <path d="M19.07 4.93a10 10 0 0 1 0 14.14"/>
          <path d="M4.93 4.93a10 10 0 0 0 0 14.14"/>
        </svg>
        AAS Management
      </a>

      <div class="nav-section-label">System</div>
      <a href="${pageContext.request.contextPath}/systemSettings">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="3"/>
          <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06
                   a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09
                   A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83
                   l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09
                   A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83
                   l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09
                   a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83
                   l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09
                   a1.65 1.65 0 0 0-1.51 1z"/>
        </svg>
        System Settings
      </a>

      <a href="${pageContext.request.contextPath}/dataManagement">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <ellipse cx="12" cy="5" rx="9" ry="3"/>
          <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/>
          <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
        </svg>
        Data Management
      </a>

    </nav>

    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="sidebar-avatar" style="background: rgba(255,255,255,0.15); color:#f1f5f9;">
          <c:choose>
            <c:when test="${not empty adminName}">${adminName.substring(0,1).toUpperCase()}</c:when>
            <c:otherwise>A</c:otherwise>
          </c:choose>
        </div>
        <div class="sidebar-user-info">
          <div class="name">${not empty adminName ? adminName : 'Administrator'}</div>
          <div class="role">Admin</div>
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/logout"
         class="btn btn-outline btn-sm"
         style="width:100%; justify-content:center; margin-top:0.625rem;
                border-color:rgba(255,255,255,0.15); color:#94a3b8;">
        Sign out
      </a>
    </div>

  </aside>
  <!-- ═══════════════════════════ END SIDEBAR ═══════════════════════ -->


  <!-- ═══════════════════════════ MAIN CONTENT ══════════════════════ -->
  <div class="main-content">

    <!-- TOPBAR -->
    <header class="topbar">
      <div style="display:flex; align-items:center; gap:0.75rem;">
        <div class="topbar-title">Admin Dashboard</div>
        <span class="live-dot"></span>
        <span style="font-size:0.75rem; color:var(--color-text-muted);" id="lastUpdated">Live</span>
      </div>
      <div class="topbar-actions">
        <span class="admin-topbar-badge">
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
               stroke="currentColor" stroke-width="2" style="display:inline; margin-right:4px;">
            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
          </svg>
          Admin
        </span>
        <c:if test="${unreadAlerts > 0}">
          <a href="${pageContext.request.contextPath}/notifications"
             style="position:relative; display:inline-flex;">
            <span class="icon-btn">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                   stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
              </svg>
            </span>
            <span style="position:absolute; top:-4px; right:-4px; background:#ef4444; color:#fff;
                         border-radius:999px; font-size:0.62rem; font-weight:700; padding:1px 5px;">
              ${unreadAlerts}
            </span>
          </a>
        </c:if>
      </div>
    </header>
    <!-- END TOPBAR -->

    <!-- PAGE BODY -->
    <div class="page-body">

      <!-- ── SUMMARY CARDS ────────────────────────────────────────── -->
      <div class="summary-grid">

        <div class="summary-card">
          <div class="s-icon icon-teal">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
              <circle cx="9" cy="7" r="4"/>
            </svg>
          </div>
          <div class="s-label">Total Users</div>
          <div class="s-value">${totalUsers}</div>
          <div class="s-sub">Registered accounts</div>
        </div>

        <div class="summary-card">
          <div class="s-icon icon-blue">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <ellipse cx="12" cy="5" rx="9" ry="3"/>
              <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/>
              <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
            </svg>
          </div>
          <div class="s-label">Sensor Readings</div>
          <div class="s-value">${totalReadings}</div>
          <div class="s-sub">Total records stored</div>
        </div>

        <div class="summary-card">
          <div class="s-icon icon-red">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
              <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
            </svg>
          </div>
          <div class="s-label">Unread Alerts</div>
          <div class="s-value">${unreadAlerts}</div>
          <div class="s-sub">Pending notifications</div>
        </div>

        <div class="summary-card">
          <div class="s-icon icon-green">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
            </svg>
          </div>
          <div class="s-label">System Status</div>
          <div class="s-value" style="font-size:1.1rem; padding-top:0.25rem;">
            <c:choose>
              <c:when test="${unreadAlerts > 5}">
                <span class="badge badge-red">Alert</span>
              </c:when>
              <c:when test="${unreadAlerts > 0}">
                <span class="badge badge-yellow">Caution</span>
              </c:when>
              <c:otherwise>
                <span class="badge badge-green">Normal</span>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="s-sub">RPI-001 device</div>
        </div>

      </div>
      <!-- END SUMMARY CARDS -->


      <!-- ── LIVE SENSOR + QUICK LINKS ─────────────────────────────── -->
      <div class="two-col">

        <!-- Latest Sensor Reading -->
        <div class="card">
          <div class="card-header">
            <span class="card-title">Latest Sensor Reading</span>
            <span class="live-dot"></span>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${latestSensor != null}">
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">

                  <div style="background:var(--color-bg); border-radius:0.5rem; padding:0.875rem;">
                    <div style="font-size:0.72rem; font-weight:600; color:var(--color-text-muted);
                                text-transform:uppercase; letter-spacing:0.05em; margin-bottom:0.25rem;">
                      Temperature
                    </div>
                    <div style="font-size:1.5rem; font-weight:700; font-variant-numeric:tabular-nums;">
                      <fmt:formatNumber value="${latestSensor.temperature}" maxFractionDigits="2"/>
                      <span style="font-size:0.8rem; font-weight:400; color:var(--color-text-muted);">°C</span>
                    </div>
                  </div>

                  <div style="background:var(--color-bg); border-radius:0.5rem; padding:0.875rem;">
                    <div style="font-size:0.72rem; font-weight:600; color:var(--color-text-muted);
                                text-transform:uppercase; letter-spacing:0.05em; margin-bottom:0.25rem;">
                      Pressure
                    </div>
                    <div style="font-size:1.5rem; font-weight:700; font-variant-numeric:tabular-nums;">
                      <fmt:formatNumber value="${latestSensor.pressure}" maxFractionDigits="2"/>
                      <span style="font-size:0.8rem; font-weight:400; color:var(--color-text-muted);">bar</span>
                    </div>
                  </div>

                  <div style="background:var(--color-bg); border-radius:0.5rem; padding:0.875rem;">
                    <div style="font-size:0.72rem; font-weight:600; color:var(--color-text-muted);
                                text-transform:uppercase; letter-spacing:0.05em; margin-bottom:0.25rem;">
                      Flow Rate
                    </div>
                    <div style="font-size:1.5rem; font-weight:700; font-variant-numeric:tabular-nums;">
                      <fmt:formatNumber value="${latestSensor.flowRate}" maxFractionDigits="2"/>
                      <span style="font-size:0.8rem; font-weight:400; color:var(--color-text-muted);">L/min</span>
                    </div>
                  </div>

                  <div style="background:var(--color-bg); border-radius:0.5rem; padding:0.875rem;">
                    <div style="font-size:0.72rem; font-weight:600; color:var(--color-text-muted);
                                text-transform:uppercase; letter-spacing:0.05em; margin-bottom:0.25rem;">
                      Level
                    </div>
                    <div style="font-size:1.5rem; font-weight:700; font-variant-numeric:tabular-nums;">
                      <fmt:formatNumber value="${latestSensor.level}" maxFractionDigits="2"/>
                      <span style="font-size:0.8rem; font-weight:400; color:var(--color-text-muted);">%</span>
                    </div>
                  </div>

                </div>
                <div style="margin-top:0.875rem; padding-top:0.875rem;
                            border-top:1px solid var(--color-border);
                            font-size:0.78rem; color:var(--color-text-muted);
                            display:flex; justify-content:space-between;">
                  <span>Device: <strong>${latestSensor.deviceId}</strong></span>
                  <span>Recorded: <strong>${latestSensor.recordedAt}</strong></span>
                </div>
              </c:when>
              <c:otherwise>
                <div style="text-align:center; padding:2rem; color:var(--color-text-muted);">
                  <svg width="40" height="40" viewBox="0 0 24 24" fill="none"
                       stroke="currentColor" stroke-width="1.5" style="margin:0 auto 0.75rem;">
                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                  </svg>
                  <p>No sensor data available yet.</p>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <!-- Quick Navigation Links -->
        <div class="card">
          <div class="card-header">
            <span class="card-title">Quick Actions</span>
          </div>
          <div class="card-body" style="display:flex; flex-direction:column; gap:0.625rem;">

            <a href="${pageContext.request.contextPath}/manageUsers"
               style="display:flex; align-items:center; gap:0.75rem; padding:0.75rem;
                      border-radius:0.5rem; border:1px solid var(--color-border);
                      transition:background 180ms; text-decoration:none; color:var(--color-text);">
              <div class="s-icon icon-teal" style="margin:0; flex-shrink:0;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                  <circle cx="9" cy="7" r="4"/>
                </svg>
              </div>
              <div>
                <div style="font-size:0.875rem; font-weight:600;">Manage Users</div>
                <div style="font-size:0.75rem; color:var(--color-text-muted);">
                  ${totalUsers} registered users
                </div>
              </div>
            </a>

            <a href="${pageContext.request.contextPath}/manageAAS"
               style="display:flex; align-items:center; gap:0.75rem; padding:0.75rem;
                      border-radius:0.5rem; border:1px solid var(--color-border);
                      transition:background 180ms; text-decoration:none; color:var(--color-text);">
              <div class="s-icon icon-blue" style="margin:0; flex-shrink:0;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <circle cx="12" cy="12" r="3"/>
                  <path d="M19.07 4.93a10 10 0 0 1 0 14.14"/>
                  <path d="M4.93 4.93a10 10 0 0 0 0 14.14"/>
                </svg>
              </div>
              <div>
                <div style="font-size:0.875rem; font-weight:600;">AAS Management</div>
                <div style="font-size:0.75rem; color:var(--color-text-muted);">
                  Configure passive &amp; reactive AAS
                </div>
              </div>
            </a>

            <a href="${pageContext.request.contextPath}/systemSettings"
               style="display:flex; align-items:center; gap:0.75rem; padding:0.75rem;
                      border-radius:0.5rem; border:1px solid var(--color-border);
                      transition:background 180ms; text-decoration:none; color:var(--color-text);">
              <div class="s-icon icon-orange" style="margin:0; flex-shrink:0;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <circle cx="12" cy="12" r="3"/>
                </svg>
              </div>
              <div>
                <div style="font-size:0.875rem; font-weight:600;">System Settings</div>
                <div style="font-size:0.75rem; color:var(--color-text-muted);">
                  Thresholds &amp; sampling intervals
                </div>
              </div>
            </a>

            <a href="${pageContext.request.contextPath}/dataManagement"
               style="display:flex; align-items:center; gap:0.75rem; padding:0.75rem;
                      border-radius:0.5rem; border:1px solid var(--color-border);
                      transition:background 180ms; text-decoration:none; color:var(--color-text);">
              <div class="s-icon icon-green" style="margin:0; flex-shrink:0;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <ellipse cx="12" cy="5" rx="9" ry="3"/>
                  <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
                </svg>
              </div>
              <div>
                <div style="font-size:0.875rem; font-weight:600;">Data Management</div>
                <div style="font-size:0.75rem; color:var(--color-text-muted);">
                  ${totalReadings} records stored
                </div>
              </div>
            </a>

          </div>
        </div>

      </div>
      <!-- END LIVE SENSOR + QUICK LINKS -->


      <!-- ── RECENT ALERTS TABLE ────────────────────────────────────── -->
      <div class="card">
        <div class="card-header">
          <span class="card-title">Recent Alerts &amp; Notifications</span>
          <c:if test="${unreadAlerts > 0}">
            <span class="badge badge-red">${unreadAlerts} unread</span>
          </c:if>
        </div>
        <div style="overflow-x:auto;">
          <table class="data-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Type</th>
                <th>Message</th>
                <th>Variable</th>
                <th>Value</th>
                <th>Threshold</th>
                <th>Severity</th>
                <th>Status</th>
                <th>Date &amp; Time</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty recentAlerts}">
                  <c:forEach var="alert" items="${recentAlerts}" varStatus="st" end="9">
                  <tr>
                    <td style="color:var(--color-text-muted);">${st.count}</td>
                    <td>
                      <span style="font-size:0.8rem; font-weight:500;">
                        ${not empty alert.alertType ? alert.alertType : '-'}
                      </span>
                    </td>
                    <td style="max-width:260px;">
                      <span style="font-size:0.83rem;">
                        ${not empty alert.message ? alert.message : '-'}
                      </span>
                    </td>
                    <td>
                      <span class="badge badge-gray">
                        ${not empty alert.variableName ? alert.variableName : '-'}
                      </span>
                    </td>
                    <td>
                      <c:if test="${alert.variableValue > 0}">
                        <fmt:formatNumber value="${alert.variableValue}" maxFractionDigits="2"/>
                      </c:if>
                      <c:if test="${alert.variableValue <= 0}">-</c:if>
                    </td>
                    <td>
                      <c:if test="${alert.thresholdValue > 0}">
                        <fmt:formatNumber value="${alert.thresholdValue}" maxFractionDigits="2"/>
                      </c:if>
                      <c:if test="${alert.thresholdValue <= 0}">-</c:if>
                    </td>
                    <td>
                      <span class="badge
                        <c:choose>
                          <c:when test="${alert.severity == 'critical'}">badge-red</c:when>
                          <c:when test="${alert.severity == 'warning'}">badge-yellow</c:when>
                          <c:when test="${alert.severity == 'info'}">badge-blue</c:when>
                          <c:otherwise>badge-gray</c:otherwise>
                        </c:choose>">
                        ${not empty alert.severity ? alert.severity : 'info'}
                      </span>
                    </td>
                    <td>
                      <span class="badge ${alert.read ? 'badge-gray' : 'badge-green'}">
                        ${alert.read ? 'Read' : 'Unread'}
                      </span>
                    </td>
                    <td style="font-size:0.78rem; color:var(--color-text-muted); white-space:nowrap;">
                      ${alert.createdAt}
                    </td>
                  </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="9" style="text-align:center; padding:2.5rem; color:var(--color-text-muted);">
                      No alerts found.
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
        <c:if test="${not empty recentAlerts}">
          <div style="padding:0.75rem 1.25rem; border-top:1px solid var(--color-border);
                      display:flex; justify-content:flex-end;">
            <a href="${pageContext.request.contextPath}/notifications"
               class="btn btn-outline btn-sm">
              View all alerts
            </a>
          </div>
        </c:if>
      </div>
      <!-- END ALERTS TABLE -->

    </div>
    <!-- END PAGE BODY -->

  </div>
  <!-- END MAIN CONTENT -->

</div>
<!-- END APP LAYOUT -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
  // Update last-updated timestamp every 30 seconds
  setInterval(() => {
    const el = document.getElementById('lastUpdated');
    if (el) el.textContent = 'Updated: ' + new Date().toLocaleTimeString();
  }, 30000);
</script>

</body>
</html>