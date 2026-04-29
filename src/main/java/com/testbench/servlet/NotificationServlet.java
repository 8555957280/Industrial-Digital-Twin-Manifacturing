package com.testbench.servlet;

import com.testbench.dao.AlertDAO;
import com.testbench.model.Alert;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class NotificationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/user/login.jsp");
            return;
        }

        AlertDAO dao         = new AlertDAO();
        List<Alert> alerts   = dao.getAllAlerts();
        int unread           = dao.countUnread();

        req.setAttribute("alerts",  alerts);
        req.setAttribute("unread",  unread);
        req.getRequestDispatcher("/user/notifications.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        new AlertDAO().markAllRead();
        resp.sendRedirect(req.getContextPath() + "/notifications");
    }
}