package com.testbench.servlet;

import com.testbench.dao.SensorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class DataManagementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("isAdmin") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login.jsp");
            return;
        }

        SensorDAO dao = new SensorDAO();
        req.setAttribute("totalReadings", dao.countReadings());
        req.getRequestDispatcher("/admin/data.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("isAdmin") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if ("cleanup".equals(action)) {
            new SensorDAO().deleteAllSensorData();
        }
        resp.sendRedirect(req.getContextPath() + "/dataManagement");
    }
}