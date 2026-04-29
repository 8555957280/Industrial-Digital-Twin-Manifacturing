package com.testbench.servlet;

import com.testbench.dao.UserDAO;
import com.testbench.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // If already logged in as admin, redirect to dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("isAdmin") != null) {
            resp.sendRedirect(req.getContextPath() + "/adminDashboard");
            return;
        }

        req.getRequestDispatcher("/admin/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        // Null / empty guard
        if (email == null || password == null
                || email.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/admin/login.jsp").forward(req, resp);
            return;
        }

        email    = email.trim();
        password = password.trim();

        // Hash the entered password with SHA-256 — same logic as PasswordUtil
        String hashedPassword = PasswordUtil.hashPassword(password);

        System.out.println("[AdminLogin] Attempting login for: " + email);
        System.out.println("[AdminLogin] Input hash:  " + hashedPassword);

        UserDAO dao    = new UserDAO();
        boolean valid  = dao.loginAdmin(email, hashedPassword);

        if (valid) {
            // Invalidate old session and create fresh one
            HttpSession oldSession = req.getSession(false);
            if (oldSession != null) oldSession.invalidate();

            HttpSession session = req.getSession(true);
            session.setAttribute("isAdmin",    true);
            session.setAttribute("adminEmail", email);
            session.setAttribute("adminName",  dao.getAdminName(email));

            System.out.println("[AdminLogin] Login SUCCESS for: " + email);
            resp.sendRedirect(req.getContextPath() + "/adminDashboard");

        } else {
            System.out.println("[AdminLogin] Login FAILED for: " + email);
            req.setAttribute("error", "Invalid admin credentials. Please check your email and password.");
            req.getRequestDispatcher("/admin/login.jsp").forward(req, resp);
        }
    }
}