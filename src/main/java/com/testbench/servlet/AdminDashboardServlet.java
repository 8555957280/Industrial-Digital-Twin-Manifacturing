package com.testbench.servlet;

import com.testbench.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("isAdmin") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login.jsp");
            return;
        }

        UserDAO  uDao = new UserDAO();
        SensorDAO sDao = new SensorDAO();
        AlertDAO aDao = new AlertDAO();

        req.setAttribute("totalUsers",    uDao.countUsers());
        req.setAttribute("totalReadings", sDao.countReadings());
        req.setAttribute("unreadAlerts",  aDao.countUnread());
        req.setAttribute("latestSensor",  sDao.getLatestReading());
        req.setAttribute("recentAlerts",  aDao.getAllAlerts());

        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}