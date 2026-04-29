package com.testbench.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.testbench.dao.SensorDAO;
import com.testbench.model.SensorData;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class SensorAPIServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        SensorDAO dao   = new SensorDAO();
        SensorData data = dao.getLatestReading();

        // Simulate small random fluctuation for live feel
        Map<String, Object> result = new HashMap<>();
        if (data != null) {
            Random rnd = new Random();
            result.put("temperature", Math.round((data.getTemperature() + (rnd.nextDouble() - 0.5)) * 100.0) / 100.0);
            result.put("pressure",    Math.round((data.getPressure()    + (rnd.nextDouble() - 0.5) * 0.1) * 100.0) / 100.0);
            result.put("flowRate",    Math.round((data.getFlowRate()    + (rnd.nextDouble() - 0.5)) * 100.0) / 100.0);
            result.put("level",       Math.round((data.getLevel()       + (rnd.nextDouble() - 0.5) * 0.5) * 100.0) / 100.0);
            result.put("deviceId",    data.getDeviceId());
            result.put("timestamp",   new java.util.Date().toString());
        }

        new ObjectMapper().writeValue(resp.getWriter(), result);
    }
}
