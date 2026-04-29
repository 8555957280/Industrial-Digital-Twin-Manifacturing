package com.testbench.servlet;

import com.testbench.dao.SensorDAO;
import com.testbench.model.SensorData;
import com.testbench.util.CloudinaryUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.List;

public class ExportServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/user/login.jsp");
            return;
        }

        SensorDAO dao         = new SensorDAO();
        List<SensorData> data = dao.getAllReadings();

        // ── Build CSV content in memory ──────────────────────────────
        StringBuilder csv = new StringBuilder();
        csv.append("ID,Temperature (C),Pressure (bar),Flow Rate (L/min),Level (%),Device ID,Recorded At\n");

        for (SensorData s : data) {
            csv.append(s.getId()).append(",")
               .append(s.getTemperature()).append(",")
               .append(s.getPressure()).append(",")
               .append(s.getFlowRate()).append(",")
               .append(s.getLevel()).append(",")
               .append(s.getDeviceId()).append(",")
               .append(s.getRecordedAt()).append("\n");
        }

        byte[] csvBytes = csv.toString().getBytes("UTF-8");

        // ── Upload to Cloudinary (stored in cloud as raw file) ────────
        try {
            String cloudUrl = CloudinaryUtil.uploadBytes(csvBytes, "testbench/reports");
            System.out.println("[Cloudinary] CSV report uploaded: " + cloudUrl);
            // Optionally store cloudUrl in DB for history
        } catch (Exception e) {
            System.err.println("[Cloudinary] CSV upload failed: " + e.getMessage());
        }

        // ── Also send as download to browser ─────────────────────────
        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition", "attachment; filename=sensor_data_export.csv");
        resp.setContentLength(csvBytes.length);
        resp.getOutputStream().write(csvBytes);
    }
}