<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>AAS Management — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    .sidebar{background:#1e293b;border-right:none;}
    .sidebar-nav a{color:#94a3b8;}
    .sidebar-nav a:hover{background:rgba(255,255,255,0.06);color:#f1f5f9;}
    .sidebar-nav a.active{background:rgba(255,255,255,0.1);color:#f1f5f9;}
    .modal{display:none;position:fixed;inset:0;background:rgba(0,0,0,0.4);z-index:200;align-items:center;justify-content:center;}
    .modal-box{background:var(--color-surface);border-radius:var(--radius);padding:1.75rem;width:100%;max-width:460px;box-shadow:var(--shadow-lg);}
    .modal-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:1.25rem;}
    .modal-title{font-size:1rem;font-weight:700;}
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
      <a href="${pageContext.request.contextPath}/manageAAS" class="active">AAS Management</a>
      <a href="${pageContext.request.contextPath}/systemSettings">System Settings</a>
      <a href="${pageContext.request.contextPath}/dataManagement">Data Management</a>
    </nav>
    <div class="sidebar-footer" style="border-top:1px solid rgba(255,255,255,0.08);">
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm"
         style="width:100%;justify-content:center;border-color:rgba(255,255,255,0.15);color:#94a3b8;">Sign out</a>
    </div>
  </aside>
  <div class="main-content">
    <header class="topbar"><div class="topbar-title">AAS Management</div></header>
    <div class="page-body">
      <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(340px,1fr));gap:1.25rem;">
        <c:forEach var="a" items="${aasSettings}">
        <div class="card">
          <div class="card-header">
            <div>
              <div class="card-title">${a.aasName}</div>
              <div style="font-size:0.75rem;color:var(--color-text-muted);margin-top:2px;">Controls: ${a.variableControlled}</div>
            </div>
            <div style="display:flex;gap:0.5rem;">
              <span class="badge badge-blue">${a.aasType}</span>
              <span class="badge ${a.status=='active'?'badge-green':'badge-gray'}">${a.status}</span>
            </div>
          </div>
          <div class="card-body">
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:0.75rem;margin-bottom:1rem;">
              <div style="background:var(--color-bg);border-radius:0.5rem;padding:0.75rem;">
                <div style="font-size:0.7rem;color:var(--color-text-muted);margin-bottom:0.25rem;">PASSIVE VALUE</div>
                <div style="font-size:1.25rem;font-weight:700;">${a.passiveValue}</div>
              </div>
              <div style="background:var(--color-bg);border-radius:0.5rem;padding:0.75rem;">
                <div style="font-size:0.7rem;color:var(--color-text-muted);margin-bottom:0.25rem;">REACTIVE VALUE</div>
                <div style="font-size:1.25rem;font-weight:700;">${a.reactiveValue}</div>
              </div>
            </div>
            <button class="btn btn-outline btn-sm"
              onclick="openAASModal(${a.id},'${a.aasType}',${a.passiveValue},${a.reactiveValue},'${a.status}')">
              Edit Settings
            </button>
          </div>
        </div>
        </c:forEach>
      </div>
    </div>
  </div>
</div>

<!-- EDIT AAS MODAL -->
<div class="modal" id="editAASModal">
  <div class="modal-box">
    <div class="modal-header">
      <span class="modal-title">Edit AAS Settings</span>
      <button style="background:none;border:none;cursor:pointer;font-size:1.2rem;color:var(--color-text-muted);" onclick="closeModal('editAASModal')">✕</button>
    </div>
    <form action="${pageContext.request.contextPath}/manageAAS" method="post">
      <input type="hidden" name="id" id="aasId">
      <div class="form-group"><label class="form-label">AAS Type</label>
        <select name="aasType" id="aasType" class="form-control">
          <option value="Passive">Passive</option>
          <option value="Reactive">Reactive</option>
        </select></div>
      <div class="form-group"><label class="form-label">Passive Value</label>
        <input type="number" step="0.01" name="passiveValue" id="passiveValue" class="form-control" required></div>
      <div class="form-group"><label class="form-label">Reactive Value</label>
        <input type="number" step="0.01" name="reactiveValue" id="reactiveValue" class="form-control" required></div>
      <div class="form-group"><label class="form-label">Status</label>
        <select name="status" id="aasStatus" class="form-control">
          <option value="active">Active</option>
          <option value="inactive">Inactive</option>
        </select></div>
      <div style="display:flex;gap:0.75rem;justify-content:flex-end;margin-top:1.25rem;">
        <button type="button" class="btn btn-outline" onclick="closeModal('editAASModal')">Cancel</button>
        <button type="submit" class="btn btn-primary">Save Changes</button>
      </div>
    </form>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function openAASModal(id,type,passive,reactive,status){
  document.getElementById('aasId').value=id;
  document.getElementById('aasType').value=type;
  document.getElementById('passiveValue').value=passive;
  document.getElementById('reactiveValue').value=reactive;
  document.getElementById('aasStatus').value=status;
  openModal('editAASModal');
}
</script>
</body>
</html>