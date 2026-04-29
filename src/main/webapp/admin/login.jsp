<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Login — Test Bench</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="login-page">
  <div class="login-box">
    <div class="login-logo">
      <div class="icon" style="background:#1e293b;">
        <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
        </svg>
      </div>
      <div class="text"><h2>Admin Portal</h2><p>Test Bench Management</p></div>
    </div>
    <h3>Administrator Login</h3>
    <p class="sub">Restricted access — authorised personnel only</p>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger" data-auto-dismiss><%= request.getAttribute("error") %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/adminLogin" method="post">
      <div class="form-group">
        <label class="form-label" for="email">Admin Email</label>
        <input type="email" id="email" name="email" class="form-control" placeholder="admin@testbench.com" required>
      </div>
      <div class="form-group">
        <label class="form-label" for="password">Password</label>
        <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
      </div>
      <button type="submit" class="btn btn-primary" style="width:100%; justify-content:center; background:#1e293b;">
        Sign in as Admin
      </button>
    </form>
    <p style="text-align:center; margin-top:1.25rem; font-size:0.8rem; color:var(--color-text-muted);">
      <a href="${pageContext.request.contextPath}/user/login.jsp" style="color:var(--color-primary);">← User Login</a>
    </p>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>