package com.testbench.servlet;

import com.testbench.dao.SensorDAO;
import com.testbench.model.ControlSetting;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ControlServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/user/login.jsp");
            return;
        }

        SensorDAO dao              = new SensorDAO();
        List<ControlSetting> settings = dao.getControlSettings();
        req.setAttribute("settings", settings);
        req.getRequestDispatcher("/user/control.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/user/login.jsp");
            return;
        }

        String variable  = req.getParameter("variable");
        double min       = Double.parseDouble(req.getParameter("minThreshold"));
        double max       = Double.parseDouble(req.getParameter("maxThreshold"));
        double setpoint  = Double.parseDouble(req.getParameter("setpoint"));

        SensorDAO dao = new SensorDAO();
        boolean updated = dao.updateControlSetting(variable, min, max, setpoint);

        if (updated) {
            req.setAttribute("success", "Settings for " + variable + " updated successfully.");
        } else {
            req.setAttribute("error", "Failed to update settings.");
        }

        List<ControlSetting> settings = dao.getControlSettings();
        req.setAttribute("settings", settings);
        req.getRequestDispatcher("/user/control.jsp").forward(req, resp);
    }
}