<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Notifications — Test Bench</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-layout">
  <aside class="sidebar">
    <div class="sidebar-brand">
      <div class="logo-icon"><svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M9 3H5a2 2 0 0 0-2 2v4m6-6h10a2 2 0 0 1 2 2v4M9 3v18m0 0h10a2 2 0 0 0 2-2V9M9 21H5a2 2 0 0 1-2-2V9m0 0h18"/></svg></div>
      <div><div class="logo-text">TestBench</div></div>
    </div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/userDashboard"><svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>Dashboard</a>
      <a href="${pageContext.request.contextPath}/control"><svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/></svg>Control Panel</a>
      <a href="${pageContext.request.contextPath}/notifications" class="active"><svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>Notifications <c:if test="${unread>0}"><span class="badge badge-red" style="margin-left:auto;">${unread}</span></c:if></a>
    </nav>
    <div class="sidebar-footer"><a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width:100%; justify-content:center;">Sign out</a></div>
  </aside>
  <div class="main-content">
    <header class="topbar">
      <div class="topbar-title">Notifications</div>
      <form action="${pageContext.request.contextPath}/notifications" method="post">
        <button type="submit" class="btn btn-outline btn-sm">Mark all read</button>
      </form>
    </header>
    <div class="page-body">
      <div class="card">
        <div class="card-header"><span class="card-title">All Alerts and Notifications</span><span class="badge badge-red">${unread} unread</span></div>
        <div style="overflow-x:auto;">
          <table class="data-table">
            <thead><tr><th>Type</th><th>Message</th><th>Variable</th><th>Value</th><th>Threshold</th><th>Severity</th><th>Status</th><th>Date</th></tr></thead>
            <tbody>
              <c:forEach var="a" items="${alerts}">
              <tr>
                <td>${a.alertType}</td>
                <td>${a.message}</td>
                <td>${a.variableName != null ? a.variableName : '-'}</td>
                <td>${a.variableValue > 0 ? a.variableValue : '-'}</td>
                <td>${a.thresholdValue > 0 ? a.thresholdValue : '-'}</td>
                <td>
                  <span class="badge ${a.severity == 'critical' ? 'badge-red' : a.severity == 'warning' ? 'badge-yellow' : 'badge-blue'}">${a.severity}</span>
                </td>
                <td><span class="badge ${a.read ? 'badge-gray' : 'badge-green'}">${a.read ? 'Read' : 'Unread'}</span></td>
                <td style="font-size:0.78rem; color:var(--color-text-muted);">${a.createdAt}</td>
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
</body>
</html>