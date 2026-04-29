package com.testbench.servlet;

import com.testbench.dao.UserDAO;
import com.testbench.model.User;
import com.testbench.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;

@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class UserManagementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("isAdmin") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login.jsp");
            return;
        }

        UserDAO dao = new UserDAO();
        req.setAttribute("users", dao.getAllUsers());
        req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("isAdmin") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login.jsp");
            return;
        }

        // Safe way to get parameters — works with multipart/form-data
        String action = getPartAsString(req, "action");
        UserDAO dao   = new UserDAO();

        if ("add".equals(action)) {
            User user = new User();
            user.setName(getPartAsString(req, "name"));
            user.setEmail(getPartAsString(req, "email"));
            user.setPassword(PasswordUtil.hashPassword(getPartAsString(req, "password")));
            user.setRole(getPartAsString(req, "role"));
            dao.addUser(user);

        } else if ("update".equals(action)) {
            User user = new User();
            user.setId(Integer.parseInt(getPartAsString(req, "userId")));
            user.setName(getPartAsString(req, "name"));
            user.setEmail(getPartAsString(req, "email"));
            user.setRole(getPartAsString(req, "role"));
            user.setStatus(getPartAsString(req, "status"));
            dao.updateUser(user);

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(getPartAsString(req, "userId"));
            dao.deleteUser(id);
        }

        resp.sendRedirect(req.getContextPath() + "/manageUsers");
    }

    // ── Helper: safely read a text field from multipart request ──
    private String getPartAsString(HttpServletRequest req, String fieldName)
            throws ServletException, IOException {
        Part part = req.getPart(fieldName);
        if (part == null) return "";
        try (var is = part.getInputStream()) {
            return new String(is.readAllBytes(), "UTF-8").trim();
        }
    }
}