<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Control Panel — Test Bench</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-layout">
  <aside class="sidebar">
    <div class="sidebar-brand">
      <div class="logo-icon"><svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M9 3H5a2 2 0 0 0-2 2v4m6-6h10a2 2 0 0 1 2 2v4M9 3v18m0 0h10a2 2 0 0 0 2-2V9M9 21H5a2 2 0 0 1-2-2V9m0 0h18"/></svg></div>
      <div><div class="logo-text">TestBench</div><div class="logo-sub">Monitor and Control</div></div>
    </div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/userDashboard"><svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>Dashboard</a>
      <a href="${pageContext.request.contextPath}/control" class="active"><svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.07 4.93a10 10 0 0 1 0 14.14"/><path d="M4.93 4.93a10 10 0 0 0 0 14.14"/></svg>Control Panel</a>
      <a href="${pageContext.request.contextPath}/notifications"><svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>Notifications</a>
      <a href="${pageContext.request.contextPath}/export"><svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>Export CSV</a>
    </nav>
    <div class="sidebar-footer">
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%; justify-content:center;">Sign out</a>
    </div>
  </aside>
  <div class="main-content">
    <header class="topbar">
      <div class="topbar-title">Control Panel</div>
    </header>
    <div class="page-body">

      <c:if test="${success != null}">
        <div class="alert alert-success" data-auto-dismiss>✓ ${success}</div>
      </c:if>
      <c:if test="${error != null}">
        <div class="alert alert-danger" data-auto-dismiss>✗ ${error}</div>
      </c:if>

      <div style="display:grid; grid-template-columns:repeat(auto-fill,minmax(320px,1fr)); gap:1.25rem;">
        <c:forEach var="s" items="${settings}">
        <div class="card">
          <div class="card-header">
            <span class="card-title">${s.variableName}</span>
            <span class="badge ${s.active ? 'badge-green' : 'badge-gray'}">${s.active ? 'Active' : 'Inactive'}</span>
          </div>
          <div class="card-body">
            <form action="${pageContext.request.contextPath}/control" method="post">
              <input type="hidden" name="variable" value="${s.variableName}">
              <div class="form-group">
                <label class="form-label">Min Threshold</label>
                <input type="number" step="0.01" name="minThreshold" class="form-control" value="${s.minThreshold}" required>
              </div>
              <div class="form-group">
                <label class="form-label">Max Threshold</label>
                <input type="number" step="0.01" name="maxThreshold" class="form-control" value="${s.maxThreshold}" required>
              </div>
              <div class="form-group">
                <label class="form-label">Setpoint</label>
                <input type="number" step="0.01" name="setpoint" class="form-control" value="${s.currentSetpoint}" required>
              </div>
              <button type="submit" class="btn btn-primary btn-sm">Update ${s.variableName}</button>
            </form>
          </div>
        </div>
        </c:forEach>
      </div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>