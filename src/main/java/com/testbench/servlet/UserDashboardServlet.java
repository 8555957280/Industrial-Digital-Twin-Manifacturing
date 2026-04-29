package com.testbench.servlet;

import com.testbench.dao.AlertDAO;
import com.testbench.dao.SensorDAO;
import com.testbench.model.ControlSetting;
import com.testbench.model.SensorData;
import com.testbench.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class UserDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    // ─── GET: Load dashboard data ────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ── 1. SESSION GUARD ─────────────────────────────────────────────────
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/user/login.jsp");
            return;
        }

        // ── 2. GET LOGGED-IN USER ─────────────────────────────────────────────
        User loggedUser = (User) session.getAttribute("loggedUser");

        // ── 3. DAO INSTANCES ──────────────────────────────────────────────────
        SensorDAO sensorDAO = new SensorDAO();
        AlertDAO  alertDAO  = new AlertDAO();

        // ── 4. LATEST SENSOR READING (for KPI cards + gauges) ─────────────────
        SensorData latest = sensorDAO.getLatestReading();

        // ── 5. LAST 50 READINGS (for trend chart + recent table) ──────────────
        List<SensorData> recentData = sensorDAO.getLast50Readings();

        // ── 6. CONTROL SETTINGS (for threshold reference on dashboard) ─────────
        List<ControlSetting> controlSettings = sensorDAO.getControlSettings();

        // ── 7. ALERT COUNTS ───────────────────────────────────────────────────
        int unreadAlerts = alertDAO.countUnread();
        int totalAlerts  = alertDAO.getAllAlerts().size();

        // ── 8. SENSOR STATS ───────────────────────────────────────────────────
        int    totalReadings = sensorDAO.countReadings();

        // ── 9. COMPUTE MIN / MAX / AVG FROM RECENT DATA ───────────────────────
        double minTemp = Double.MAX_VALUE, maxTemp = Double.MIN_VALUE, sumTemp = 0;
        double minPres = Double.MAX_VALUE, maxPres = Double.MIN_VALUE, sumPres = 0;
        double minFlow = Double.MAX_VALUE, maxFlow = Double.MIN_VALUE, sumFlow = 0;
        double minLvl  = Double.MAX_VALUE, maxLvl  = Double.MIN_VALUE, sumLvl  = 0;

        if (!recentData.isEmpty()) {
            for (SensorData s : recentData) {
                // Temperature
                if (s.getTemperature() < minTemp) minTemp = s.getTemperature();
                if (s.getTemperature() > maxTemp) maxTemp = s.getTemperature();
                sumTemp += s.getTemperature();

                // Pressure
                if (s.getPressure() < minPres) minPres = s.getPressure();
                if (s.getPressure() > maxPres) maxPres = s.getPressure();
                sumPres += s.getPressure();

                // Flow Rate
                if (s.getFlowRate() < minFlow) minFlow = s.getFlowRate();
                if (s.getFlowRate() > maxFlow) maxFlow = s.getFlowRate();
                sumFlow += s.getFlowRate();

                // Level
                if (s.getLevel() < minLvl) minLvl = s.getLevel();
                if (s.getLevel() > maxLvl) maxLvl = s.getLevel();
                sumLvl += s.getLevel();
            }
        }

        int size = recentData.isEmpty() ? 1 : recentData.size(); // avoid divide-by-zero
        double avgTemp = round2(sumTemp / size);
        double avgPres = round2(sumPres / size);
        double avgFlow = round2(sumFlow / size);
        double avgLvl  = round2(sumLvl  / size);

        // ── 10. DETERMINE SYSTEM STATUS BASED ON THRESHOLDS ──────────────────
        String systemStatus = "Normal";
        String statusBadge  = "badge-green";

        if (latest != null && !controlSettings.isEmpty()) {
            for (ControlSetting cs : controlSettings) {
                double val = getValueByName(latest, cs.getVariableName());
                if (val > cs.getMaxThreshold() || val < cs.getMinThreshold()) {
                    systemStatus = "Warning";
                    statusBadge  = "badge-yellow";
                    break;
                }
                if (val > cs.getMaxThreshold() * 0.95) {
                    systemStatus = "Caution";
                    statusBadge  = "badge-yellow";
                }
            }
        }

        if (unreadAlerts > 5) {
            systemStatus = "Alert";
            statusBadge  = "badge-red";
        }

        // ── 11. SET ALL ATTRIBUTES FOR JSP ────────────────────────────────────
        req.setAttribute("loggedUser",      loggedUser);
        req.setAttribute("latest",          latest);
        req.setAttribute("recentData",      recentData);
        req.setAttribute("controlSettings", controlSettings);

        // Stats
        req.setAttribute("totalReadings",   totalReadings);
        req.setAttribute("unreadAlerts",    unreadAlerts);
        req.setAttribute("totalAlerts",     totalAlerts);

        // Min / Max / Avg
        req.setAttribute("minTemp",  round2(minTemp == Double.MAX_VALUE ? 0 : minTemp));
        req.setAttribute("maxTemp",  round2(maxTemp == Double.MIN_VALUE ? 0 : maxTemp));
        req.setAttribute("avgTemp",  avgTemp);

        req.setAttribute("minPres",  round2(minPres == Double.MAX_VALUE ? 0 : minPres));
        req.setAttribute("maxPres",  round2(maxPres == Double.MIN_VALUE ? 0 : maxPres));
        req.setAttribute("avgPres",  avgPres);

        req.setAttribute("minFlow",  round2(minFlow == Double.MAX_VALUE ? 0 : minFlow));
        req.setAttribute("maxFlow",  round2(maxFlow == Double.MIN_VALUE ? 0 : maxFlow));
        req.setAttribute("avgFlow",  avgFlow);

        req.setAttribute("minLvl",   round2(minLvl == Double.MAX_VALUE ? 0 : minLvl));
        req.setAttribute("maxLvl",   round2(maxLvl == Double.MIN_VALUE ? 0 : maxLvl));
        req.setAttribute("avgLvl",   avgLvl);

        // System status
        req.setAttribute("systemStatus", systemStatus);
        req.setAttribute("statusBadge",  statusBadge);

        // Device info
        req.setAttribute("deviceId", latest != null ? latest.getDeviceId() : "RPI-001");
        req.setAttribute("lastRecorded", latest != null ? latest.getRecordedAt() : "No data yet");

        // ── 12. FORWARD TO JSP ────────────────────────────────────────────────
        req.getRequestDispatcher("/user/dashboard.jsp").forward(req, resp);
    }

    // ─── POST: Handle quick control updates from dashboard ───────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/user/login.jsp");
            return;
        }

        // Quick setpoint update submitted from dashboard card
        String action = req.getParameter("action");
        if ("updateSetpoint".equals(action)) {
            String variable = req.getParameter("variable");
            String setpointStr = req.getParameter("setpoint");

            if (variable != null && setpointStr != null && !setpointStr.isEmpty()) {
                try {
                    double setpoint = Double.parseDouble(setpointStr);
                    SensorDAO dao   = new SensorDAO();
                    // Fetch current thresholds to keep them unchanged
                    List<ControlSetting> settings = dao.getControlSettings();
                    for (ControlSetting cs : settings) {
                        if (cs.getVariableName().equalsIgnoreCase(variable)) {
                            dao.updateControlSetting(variable, cs.getMinThreshold(), cs.getMaxThreshold(), setpoint);
                            session.setAttribute("dashboardMsg", "Setpoint for " + variable + " updated to " + setpoint);
                            break;
                        }
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("dashboardError", "Invalid setpoint value.");
                }
            }
        }

        // Redirect back to GET (PRG pattern — prevents form resubmit on refresh)
        resp.sendRedirect(req.getContextPath() + "/userDashboard");
    }

    // ─── HELPERS ─────────────────────────────────────────────────────────────

    /**
     * Round a double to 2 decimal places
     */
    private double round2(double value) {
        return Math.round(value * 100.0) / 100.0;
    }

    /**
     * Get the sensor value for a given variable name string
     * Used to compare against control setting thresholds
     */
    private double getValueByName(SensorData s, String variableName) {
        if (variableName == null) return 0;
        switch (variableName.toLowerCase()) {
            case "temperature": return s.getTemperature();
            case "pressure":    return s.getPressure();
            case "flow_rate":   return s.getFlowRate();
            case "level":       return s.getLevel();
            default:            return 0;
        }
    }
}