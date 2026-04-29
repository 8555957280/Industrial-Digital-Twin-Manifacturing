<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>System Settings — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    .sidebar{background:#1e293b;border-right:none;}
    .sidebar-nav a{color:#94a3b8;}
    .sidebar-nav a:hover{background:rgba(255,255,255,0.06);color:#f1f5f9;}
    .sidebar-nav a.active{background:rgba(255,255,255,0.1);color:#f1f5f9;}
  </style>
</head>
<body>
<div class="app-layout">
  <aside class="sidebar">
    <div class="sidebar-brand">
      <div class="logo-icon" style="background:rgba(255,255,255,0.1);"><svg width="18" height="18" fill="none" stroke="#f1f5f9" stroke-width="2" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
      <div><div class="logo-text" style="color:#f1f5f9;">Admin Panel</div></div>
    </div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/adminDashboard">Dashboard</a>
      <a href="${pageContext.request.contextPath}/manageUsers">User Management</a>
      <a href="${pageContext.request.contextPath}/manageAAS">AAS Management</a>
      <a href="${pageContext.request.contextPath}/systemSettings" class="active">System Settings</a>
      <a href="${pageContext.request.contextPath}/dataManagement">Data Management</a>
    </nav>
    <div class="sidebar-footer" style="border-top:1px solid rgba(255,255,255,0.08);">
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm"
         style="width:100%;justify-content:center;border-color:rgba(255,255,255,0.15);color:#94a3b8;">Sign out</a>
    </div>
  </aside>
  <div class="main-content">
    <header class="topbar"><div class="topbar-title">System Settings</div></header>
    <div class="page-body">
      <div style="max-width:720px;">
        <div class="card">
          <div class="card-header"><span class="card-title">Threshold and Control Settings</span></div>
          <div class="card-body">
            <c:forEach var="s" items="${controlSettings}">
            <form action="${pageContext.request.contextPath}/systemSettings" method="post"
              style="margin-bottom:1.5rem;padding-bottom:1.5rem;border-bottom:1px solid var(--color-border);">
              <input type="hidden" name="variable" value="${s.variableName}">
              <h4 style="margin-bottom:0.875rem;text-transform:capitalize;font-size:0.9rem;">${s.variableName}</h4>
              <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:0.75rem;">
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
              </div>
              <button type="submit" class="btn btn-primary btn-sm">Update ${s.variableName}</button>
            </form>
            </c:forEach>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>