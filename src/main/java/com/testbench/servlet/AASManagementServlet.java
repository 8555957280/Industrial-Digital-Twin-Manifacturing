package com.testbench.servlet;

import com.testbench.dao.SensorDAO;
import com.testbench.model.AASSetting;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AASManagementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("isAdmin") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login.jsp");
            return;
        }

        SensorDAO dao             = new SensorDAO();
        List<AASSetting> settings = dao.getAASSettings();
        req.setAttribute("aasSettings", settings);
        req.getRequestDispatcher("/admin/aas.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("isAdmin") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login.jsp");
            return;
        }

        int    id       = Integer.parseInt(req.getParameter("id"));
        double passive  = Double.parseDouble(req.getParameter("passiveValue"));
        double reactive = Double.parseDouble(req.getParameter("reactiveValue"));
        String type     = req.getParameter("aasType");
        String status   = req.getParameter("status");

        new SensorDAO().updateAASSetting(id, passive, reactive, type, status);
        resp.sendRedirect(req.getContextPath() + "/manageAAS");
    }
}