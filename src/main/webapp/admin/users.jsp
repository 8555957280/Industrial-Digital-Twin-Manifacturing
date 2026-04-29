<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>User Management — Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    .sidebar { background: #1e293b; border-right: none; }
    .sidebar-nav a { color: #94a3b8; }
    .sidebar-nav a:hover { background: rgba(255,255,255,0.06); color: #f1f5f9; }
    .sidebar-nav a.active { background: rgba(255,255,255,0.1); color: #f1f5f9; }
    .nav-section-label { color: #475569 !important; }
    .sidebar-brand .logo-text { color: #f1f5f9; }
    .sidebar-brand .logo-sub  { color: #64748b; }

    /* Modal overlay */
    .modal {
      display: none; position: fixed; inset: 0;
      background: rgba(0,0,0,0.45); z-index: 999;
      align-items: center; justify-content: center;
    }
    .modal-box {
      background: #fff; border-radius: 0.75rem;
      padding: 1.75rem; width: 100%; max-width: 460px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.2);
    }
    .modal-box h3 { font-size: 1rem; font-weight: 700; margin-bottom: 1.25rem; }
    .modal-footer { display: flex; justify-content: flex-end; gap: 0.625rem; margin-top: 1.25rem; }
  </style>
</head>
<body>
<div class="app-layout">

  <!-- SIDEBAR -->
  <aside class="sidebar">
    <div class="sidebar-brand">
      <div class="logo-icon" style="background:rgba(255,255,255,0.1);">
        <svg width="18" height="18" fill="none" stroke="#f1f5f9" stroke-width="2" viewBox="0 0 24 24">
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
      <a href="${pageContext.request.contextPath}/adminDashboard">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
          <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
        </svg>
        Dashboard
      </a>
      <div class="nav-section-label">Management</div>
      <a href="${pageContext.request.contextPath}/manageUsers" class="active">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
          <circle cx="9" cy="7" r="4"/>
          <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>
        </svg>
        User Management
      </a>
      <a href="${pageContext.request.contextPath}/manageAAS">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="3"/>
          <path d="M19.07 4.93a10 10 0 0 1 0 14.14M4.93 4.93a10 10 0 0 0 0 14.14"/>
        </svg>
        AAS Management
      </a>
      <a href="${pageContext.request.contextPath}/systemSettings">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
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
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <ellipse cx="12" cy="5" rx="9" ry="3"/>
          <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
        </svg>
        Data Management
      </a>
    </nav>
    <div class="sidebar-footer" style="border-top:1px solid rgba(255,255,255,0.08);">
      <a href="${pageContext.request.contextPath}/logout"
         class="btn btn-outline btn-sm"
         style="width:100%; justify-content:center; color:#94a3b8; border-color:rgba(255,255,255,0.15);">
        Sign out
      </a>
    </div>
  </aside>

  <!-- MAIN -->
  <div class="main-content">
    <header class="topbar">
      <div class="topbar-title">User Management</div>
      <button class="btn btn-primary btn-sm" onclick="openModal('addModal')">
        + Add New User
      </button>
    </header>

    <div class="page-body">

      <!-- STATS ROW -->
      <div class="stat-grid" style="grid-template-columns:repeat(3,1fr); max-width:600px; margin-bottom:1.5rem;">
        <div class="stat-card">
          <div class="label">Total Users</div>
          <div class="value">${users.size()}</div>
        </div>
        <div class="stat-card">
          <div class="label">Active</div>
          <div class="value" style="color:var(--color-success);">
            <c:set var="active" value="0"/>
            <c:forEach var="u" items="${users}">
              <c:if test="${u.status == 'active'}"><c:set var="active" value="${active + 1}"/></c:if>
            </c:forEach>
            ${active}
          </div>
        </div>
        <div class="stat-card">
          <div class="label">Inactive</div>
          <div class="value" style="color:var(--color-text-muted);">${users.size() - active}</div>
        </div>
      </div>

      <!-- USERS TABLE -->
      <div class="card">
        <div class="card-header">
          <span class="card-title">All Users</span>
        </div>
        <div style="overflow-x:auto;">
          <table class="data-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>Status</th>
                <th>Created At</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="u" items="${users}" varStatus="st">
              <tr>
                <td>${st.count}</td>
                <td style="font-weight:600;">${u.name}</td>
                <td style="color:var(--color-text-muted);">${u.email}</td>
                <td><span class="badge ${u.role == 'admin' ? 'badge-blue' : 'badge-gray'}">${u.role}</span></td>
                <td><span class="badge ${u.status == 'active' ? 'badge-green' : 'badge-red'}">${u.status}</span></td>
                <td style="font-size:0.78rem; color:var(--color-text-muted);">${u.createdAt}</td>
                <td style="display:flex; gap:0.5rem;">
                  <!-- EDIT BUTTON -->
                  <button class="btn btn-outline btn-sm"
                    onclick="openEdit(${u.id},'${u.name}','${u.email}','${u.role}','${u.status}')">
                    Edit
                  </button>
                  <!-- DELETE BUTTON -->
                  <form action="${pageContext.request.contextPath}/manageUsers"
                        method="post"
                        enctype="multipart/form-data"
                        onsubmit="return confirm('Delete user ${u.name}?')">
                    <input type="hidden" name="action"  value="delete">
                    <input type="hidden" name="userId"  value="${u.id}">
                    <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                  </form>
                </td>
              </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ══ ADD USER MODAL ══════════════════════════════════════════ -->
<div class="modal" id="addModal">
  <div class="modal-box">
    <h3>Add New User</h3>
    <!-- KEY FIX: enctype="multipart/form-data" -->
    <form action="${pageContext.request.contextPath}/manageUsers"
          method="post"
          enctype="multipart/form-data">
      <input type="hidden" name="action" value="add">
      <div class="form-group">
        <label class="form-label">Full Name</label>
        <input type="text" name="name" class="form-control" placeholder="e.g. John Smith" required>
      </div>
      <div class="form-group">
        <label class="form-label">Email Address</label>
        <input type="email" name="email" class="form-control" placeholder="john@example.com" required>
      </div>
      <div class="form-group">
        <label class="form-label">Password</label>
        <input type="password" name="password" class="form-control" placeholder="Min 6 characters" required>
      </div>
      <div class="form-group">
        <label class="form-label">Role</label>
        <select name="role" class="form-control">
          <option value="user">User</option>
          <option value="admin">Admin</option>
        </select>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline" onclick="closeModal('addModal')">Cancel</button>
        <button type="submit" class="btn btn-primary">Create User</button>
      </div>
    </form>
  </div>
</div>

<!-- ══ EDIT USER MODAL ══════════════════════════════════════════ -->
<div class="modal" id="editModal">
  <div class="modal-box">
    <h3>Edit User</h3>
    <!-- KEY FIX: enctype="multipart/form-data" -->
    <form action="${pageContext.request.contextPath}/manageUsers"
          method="post"
          enctype="multipart/form-data">
      <input type="hidden" name="action"  value="update">
      <input type="hidden" name="userId"  id="editUserId">
      <div class="form-group">
        <label class="form-label">Full Name</label>
        <input type="text" name="name" id="editName" class="form-control" required>
      </div>
      <div class="form-group">
        <label class="form-label">Email Address</label>
        <input type="email" name="email" id="editEmail" class="form-control" required>
      </div>
      <div class="form-group">
        <label class="form-label">Role</label>
        <select name="role" id="editRole" class="form-control">
          <option value="user">User</option>
          <option value="admin">Admin</option>
        </select>
      </div>
      <div class="form-group">
        <label class="form-label">Status</label>
        <select name="status" id="editStatus" class="form-control">
          <option value="active">Active</option>
          <option value="inactive">Inactive</option>
        </select>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline" onclick="closeModal('editModal')">Cancel</button>
        <button type="submit" class="btn btn-primary">Save Changes</button>
      </div>
    </form>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
  function openEdit(id, name, email, role, status) {
    document.getElementById('editUserId').value = id;
    document.getElementById('editName').value   = name;
    document.getElementById('editEmail').value  = email;
    document.getElementById('editRole').value   = role;
    document.getElementById('editStatus').value = status;
    openModal('editModal');
  }
</script>
</body>
</html>