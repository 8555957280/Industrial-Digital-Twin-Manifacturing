package com.testbench.servlet;

import com.testbench.dao.UserDAO;
import com.testbench.model.User;
import com.testbench.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class UserLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/user/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email").trim();
        String password = req.getParameter("password").trim();

        UserDAO dao  = new UserDAO();
        String hashed = PasswordUtil.hashPassword(password);
        User user    = dao.loginUser(email, hashed);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("loggedUser", user);
            session.setAttribute("userName", user.getName());
            session.setAttribute("userEmail", user.getEmail());
            resp.sendRedirect(req.getContextPath() + "/userDashboard");
        } else {
            req.setAttribute("error", "Invalid email or password. Please try again.");
            req.getRequestDispatcher("/user/login.jsp").forward(req, resp);
        }
    }
}