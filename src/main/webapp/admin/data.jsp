<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Data Management — Admin</title>
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
      <a href="${pageContext.request.contextPath}/systemSettings">System Settings</a>
      <a href="${pageContext.request.contextPath}/dataManagement" class="active">Data Management</a>
    </nav>
    <div class="sidebar-footer" style="border-top:1px solid rgba(255,255,255,0.08);">
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm"
         style="width:100%;justify-content:center;border-color:rgba(255,255,255,0.15);color:#94a3b8;">Sign out</a>
    </div>
  </aside>
  <div class="main-content">
    <header class="topbar"><div class="topbar-title">Data Management</div></header>
    <div class="page-body">
      <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:1.25rem;">

        <div class="card">
          <div class="card-header"><span class="card-title">Database Summary</span></div>
          <div class="card-body">
            <div style="display:flex;align-items:center;justify-content:space-between;padding:0.75rem;background:var(--color-bg);border-radius:0.5rem;margin-bottom:0.75rem;">
              <span style="font-size:0.85rem;font-weight:600;">Total Sensor Readings</span>
              <span style="font-size:1.25rem;font-weight:700;font-variant-numeric:tabular-nums;">${totalReadings}</span>
            </div>
            <p style="font-size:0.8rem;color:var(--color-text-muted);">Historical data from all connected devices (RPI-001).</p>
          </div>
        </div>

        <div class="card">
          <div class="card-header"><span class="card-title">Export Data</span></div>
          <div class="card-body" style="display:flex;flex-direction:column;gap:0.75rem;">
            <p style="font-size:0.85rem;color:var(--color-text-muted);">Download all sensor readings as CSV for offline analysis or enterprise integration.</p>
            <a href="${pageContext.request.contextPath}/export" class="btn btn-primary" style="justify-content:center;">
              ↓ Download CSV
            </a>
          </div>
        </div>

        <div class="card">
          <div class="card-header"><span class="card-title">Data Cleanup</span></div>
          <div class="card-body">
            <p style="font-size:0.85rem;color:var(--color-text-muted);margin-bottom:0.875rem;">Remove sensor data older than 90 days to free up database storage.</p>
            <form action="${pageContext.request.contextPath}/dataManagement" method="post"
              onsubmit="return confirm('This will permanently delete data older than 90 days. Continue?')">
              <input type="hidden" name="action" value="cleanup">
              <button type="submit" class="btn btn-danger" style="width:100%;justify-content:center;">Run Cleanup</button>
            </form>
          </div>
        </div>

        <div class="card">
          <div class="card-header"><span class="card-title">Cloudinary Integration</span></div>
          <div class="card-body">
            <p style="font-size:0.85rem;color:var(--color-text-muted);margin-bottom:0.875rem;">Profile images and exports are stored in Cloudinary cloud storage.</p>
            <div style="background:var(--color-bg);border-radius:0.5rem;padding:0.75rem;">
              <div style="font-size:0.72rem;font-weight:600;color:var(--color-text-muted);margin-bottom:0.375rem;text-transform:uppercase;">Cloud Status</div>
              <span class="badge badge-green">Connected</span>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>