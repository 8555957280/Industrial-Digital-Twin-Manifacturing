<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Login — Test Bench</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="login-page">
  <div class="login-box">
    <div class="login-logo">
      <div class="icon">
        <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M9 3H5a2 2 0 0 0-2 2v4m6-6h10a2 2 0 0 1 2 2v4M9 3v18m0 0h10a2 2 0 0 0 2-2V9M9 21H5a2 2 0 0 1-2-2V9m0 0h18"/>
        </svg>
      </div>
      <div class="text">
        <h2>TestBench</h2>
        <p>Monitoring amd Control System</p>
      </div>
    </div>
    <h3>Welcome back</h3>
    <p class="sub">Sign in to monitor the test bench</p>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger" data-auto-dismiss>
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
      <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/userLogin" method="post">
      <div class="form-group">
        <label class="form-label" for="email">Email address</label>
        <input type="email" id="email" name="email" class="form-control" placeholder="you@example.com" required>
      </div>
      <div class="form-group">
        <label class="form-label" for="password">Password</label>
        <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
      </div>
      <button type="submit" class="btn btn-primary" style="width:100%; justify-content:center; margin-top:0.5rem;">
        Sign in
      </button>
    </form>
    <p style="text-align:center; margin-top:1.25rem; font-size:0.8rem; color:var(--color-text-muted);">
      Admin? <a href="${pageContext.request.contextPath}/admin/login.jsp" style="color:var(--color-primary); font-weight:600;">Admin Login →</a>
    </p>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>