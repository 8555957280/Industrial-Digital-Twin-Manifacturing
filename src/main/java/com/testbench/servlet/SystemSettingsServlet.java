package com.testbench.servlet;

import com.testbench.dao.SensorDAO;
import com.testbench.model.ControlSetting;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class SystemSettingsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("isAdmin") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login.jsp");
            return;
        }

        SensorDAO dao                 = new SensorDAO();
        List<ControlSetting> settings = dao.getControlSettings();
        req.setAttribute("controlSettings", settings);
        req.getRequestDispatcher("/admin/settings.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("isAdmin") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login.jsp");
            return;
        }

        String variable = req.getParameter("variable");
        double min      = Double.parseDouble(req.getParameter("minThreshold"));
        double max      = Double.parseDouble(req.getParameter("maxThreshold"));
        double setpoint = Double.parseDouble(req.getParameter("setpoint"));

        new SensorDAO().updateControlSetting(variable, min, max, setpoint);
        req.setAttribute("success", "Threshold settings updated.");
        resp.sendRedirect(req.getContextPath() + "/systemSettings");
    }
}